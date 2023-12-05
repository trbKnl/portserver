defmodule Portserver.StorageBackend.AzureStorage do
  @behaviour Portserver.StorageBackend.Behaviour

  require Logger

  def store(
        participant_id, donation_id, data
      ) do
    path = path(participant_id, donation_id)

    headers = [
      {"Content-Type", "text/plain"},
      {"x-ms-blob-type", "BlockBlob"}
    ]

    config = config()

    case url(config, path) do
      {:ok, url} ->
        HTTPoison.put(url, data, headers)
        |> case do
          {:ok, %{status_code: 201}} ->
            :ok

          {_, %{status_code: status_code, body: body}} ->
            Logger.error("status_code=#{status_code},message=#{body}")
            {:error, "status_code=#{status_code},message=#{body}"}

          {_, response} ->
            {:error, response}
        end

      {:error, error} ->
        Logger.error("[AzureStorageBackend] #{error}")
        {:error, error}
    end
  end

  def path(participant_id, donation_id) do
    "#{participant_id}/#{donation_id}.json"
  end

  defp url(
         config,
         path
       ) do
    storage_account_name = Keyword.get(config, :storage_account_name)
    container = Keyword.get(config, :container)
    sas_token = Keyword.get(config, :sas_token)

    if storage_account_name && container && sas_token do
      {:ok,
       "https://#{storage_account_name}.blob.core.windows.net/#{container}/#{path}#{sas_token}"}
    else
      {:error, "Unable to deliver donation: invalid Azure config"}
    end
  end

  defp config() do
    Application.get_env(:portserver, :azure_storage_config)
  end
end
