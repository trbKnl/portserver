defmodule Portserver.StorageBackend.Vault do
  use Cloak.Vault, otp_app: :portserver
  
  @impl GenServer
  def init(config) do
    config =
      Keyword.put(config, :ciphers, [
        default: {
          Cloak.Ciphers.AES.GCM, 
          tag: "AES.GCM.V1", 
          key: get_encryption_key() |> Base.decode64!() 
        }
      ])

    {:ok, config}
  end

  defp get_encryption_key() do
    Application.fetch_env!(:portserver, :database_storage_config)
    |> Keyword.get(:cloak_key)
  end

end

defmodule Portserver.Encrypted.Binary do
  @moduledoc """
  This defines the encrypted type of binary 
  to be used in schema definitions
  """

  use Cloak.Ecto.Binary, vault: Portserver.StorageBackend.Vault 
end
