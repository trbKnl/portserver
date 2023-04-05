defmodule Portserver.StorageBackend.Behaviour do
  @callback store(
    participant_id :: term, 
    key :: term, 
    data ::term
  ) :: any
end
