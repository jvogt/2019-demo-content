olddir="$(pwd)"

cd inspec/profiles/linux
bash ./bulk_update.sh

cd "${olddir}"
cd inspec/profiles/windows
bash ./bulk_update.sh

cd "${olddir}"
cd chef_policyfile/policyfiles
bash ./bulk_update.sh

cd "${olddir}"
cd chef_policyfile_windows/policies/acme_app_1
bash ./bulk_update.sh

cd "${olddir}"
