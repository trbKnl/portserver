defmodule Portserver.StorageBackend.YodaClient do
  use HTTPoison.Base
  import SweetXml

  @doc """
  PUT puts the data in the body to yoda instance
  """
  def put(path, body) do
    url = create_resource_url(path)
    username = get_yoda_username()
    password = get_yoda_password() 

    headers = [
      {"Authorization", "Basic " <> Base.encode64("#{username}:#{password}")}
    ]

    case HTTPoison.put(url, body, headers) do
      {:ok, %HTTPoison.Response{status_code: 201}} ->
        {:ok, "data written"}

      {:ok, %HTTPoison.Response{status_code: 204}} ->
        {:ok, "data written"}

      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} ->
        {:error, "Request failed with status code #{status_code}. #{body}"}

      {:error, error} ->
        {:error, "Request failed: #{inspect(error)}"}
    end
  end

  @doc """
  PROPFIND can be used to check if a resouce exists
  such as a collection
  """
  def propfind(path) do
    url = create_resource_url(path)
    username = get_yoda_username()
    password = get_yoda_password() 

    headers = [
      {"Authorization", "Basic " <> Base.encode64("#{username}:#{password}")},
      {"Depth", "0"}
    ]

    case HTTPoison.request(:propfind, url, "", headers) do
      {:ok, %HTTPoison.Response{status_code: 207, body: body}} ->
        # Got multipart response, handle xml body
        case body |> xpath(~x"//D:status[1]/text()") do
          'HTTP/1.1 200 OK' -> {:ok, "resource found"}
          _ -> {:error, "Multiparse response, not expected response: #{inspect(body)}"}
        end

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:ok, "resource does not exist"}

      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        {:error, "Request failed with status code #{status_code}"}

      {:error, error} ->
        {:error, "Request failed: #{inspect(error)}"}
    end
  end

  @doc """
  MKCOL make collection, be used to create a collection (folder)
  """
  def mkcol(path) do
    url = create_resource_url(path)
    username = get_yoda_username()
    password = get_yoda_password() 

    headers = [
      {"Authorization", "Basic " <> Base.encode64("#{username}:#{password}")}
    ]

    case HTTPoison.request(:mkcol, url, "", headers) do
      {:ok, %HTTPoison.Response{status_code: 201}} ->
        {:ok, "Collection created"}

      {:ok, %HTTPoison.Response{status_code: 405}} ->
        {:ok, "Not allowed"}

      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        {:error, "Request failed with status code #{status_code}"}

      {:error, error} ->
        {:error, "Request failed: #{inspect(error)}"}
    end
  end

  defp create_resource_url(path) do
    "#{get_yoda_url()}/#{path}"
  end

  defp get_yoda_url() do
    Application.fetch_env!(:portserver, :yoda_storage_config)
    |> Keyword.get(:url)
  end

  defp get_yoda_username() do
    Application.fetch_env!(:portserver, :yoda_storage_config)
    |> Keyword.get(:username)
  end

  defp get_yoda_password() do
    Application.fetch_env!(:portserver, :yoda_storage_config)
    |> Keyword.get(:password)
  end
end
