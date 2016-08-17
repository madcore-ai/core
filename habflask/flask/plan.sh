pkg_name=flask
pkg_origin=flaskkey
pkg_version=0.1.0
pkg_maintainer="Robert Gludo <robert_gludo@yahoo.com>"
pkg_license=("MIT")
pkg_source="https://bitbucket.org/ronaanimation/controlbox/habflask"
pkg_deps=(core/glibc core/python2 core/cacerts core/openssl core/gcc-libs)
pkg_build_deps=(core/glibc core/gcc core/gcc-libs core/python2 core/git core/openssl core/curl)
pkg_bin_dirs=(bin)
pkg_lib_dirs=(lib)
pkg_include_dirs=(include)
pkg_expose=(5000)

do_download(){
  return 0
}

do_verify(){
  return 0
}

do_unpack(){
  return 0
}

do_build () {
  pip install --upgrade pip
  pip install virtualenv
  virtualenv ${pkg_prefix}
}

do_install () {
  pushd $PLAN_CONTEXT > /dev/null
  source ${pkg_prefix}/bin/activate
  pip install -r ../requirements.txt
  popd > /dev/null
}

