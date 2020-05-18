pkg_name="inspec-cis-centos7-demo"
pkg_origin="jvdemo"
pkg_version="0.1.0"
pkg_build_deps=("chef/inspec")
pkg_deps=("chef/inspec")
pkg_svc_user="root"

do_build() {
  if [ ! -d $PLAN_CONTEXT/../vendor ]; then
    echo 1>&2 "You must run inspec vendor before building"
    exit 1
  fi
  cp -r $PLAN_CONTEXT/../* $HAB_CACHE_SRC_PATH/$pkg_dirname
}

do_install() {
  mkdir -p $pkg_prefix/dist
  cp -r $PLAN_CONTEXT/../* $pkg_prefix/dist/
  cd $pkg_prefix/dist/
  rm -rf *.hart habitat results
}
