

Portserver.StorageBackend.DatabaseStorage.store("1", "TWOTTER", "aaaaaa")
Portserver.StorageBackend.DatabaseStorage.store("1", "FAISBEK", "cccc")
Portserver.StorageBackend.DatabaseStorage.store("9239238231", "FOSBOK", "bbbbbb")
Portserver.StorageBackend.DatabaseStorage.store("2", "FOSBOK", "bbbbbb")

Portserver.Accounts.Admin.valid_password?(nil, nil)

import Ecto.Query
alias Portserver.Repo

Repo.all(   
  from d in "donations",
  select: [d.participant_id, d.donation_id]
)

Repo.all(Donation)
