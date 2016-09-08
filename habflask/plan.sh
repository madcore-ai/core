pkg_origin=core
pkg_name=flask
pkg_version=0.11.1
pkg_maintainer="test@mail"
pkg_upstream_url=https://pypi.python.org/pypi/Flask
pkg_source=nosuchfile.tgz
pkg_build_deps=(core/python)
pkg_deps=(core/python)

pkg_bin_dirs=(bin)

do_download() {
  return 0
}

do_verify() {
  return 0
}

do_unpack() {
  return 0
}

do_prepare() {
  pyvenv "$pkg_prefix"
  # shellcheck source=/dev/null
  source "$pkg_prefix/bin/activate"
}

do_build() {
  return 0
}


do_install() {
  pip install "$pkg_name==$pkg_version"
  pip freeze > "$pkg_prefix/requirements.txt"
}
