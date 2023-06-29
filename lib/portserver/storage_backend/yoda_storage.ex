defmodule Portserver.StorageBackend.YodaStorage do

  alias Portserver.StorageBackend.YodaClient

  @behaviour Portserver.StorageBackend.Behaviour
  def store(participant_id, donation_id, data) do
    filename = participant_id <> "-" <> donation_id
    YodaClient.put(filename, data)
  end
end
