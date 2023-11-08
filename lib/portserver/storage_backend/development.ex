defmodule Portserver.StorageBackend.Development do
  @moduledoc """
  This Module implements the storage behaviour when in development
  """

  alias Portserver.StorageBackend.LocalStorage
  alias Portserver.StorageBackend.YodaStorage

  @behaviour Portserver.StorageBackend.Behaviour
  def store(participant_id, donation_id, data) do
    YodaStorage.store(participant_id, donation_id, data)
  end

end
