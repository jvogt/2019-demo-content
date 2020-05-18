policy_name="base"
pkg_name=chef-linux-hardening-demo
pkg_origin=jvdemo
pkg_version="0.1.0"
pkg_svc_user=("root")

pkg_deps=(
  "chef/chef-client"
  "core/cacerts"
  "core/sed"
)

pkg_build_deps=(
  "chef/chef-dk"
  "core/git"
)

do_build() {
  cd "$PLAN_CONTEXT/../policyfiles"
  rm -f *.lock.json
  chef install "$policy_name.rb"
}

do_install() {
  cd "$PLAN_CONTEXT/../policyfiles"
  chef export "$policy_name.lock.json" "$pkg_prefix"
}