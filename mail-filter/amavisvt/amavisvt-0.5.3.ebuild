# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{5..9} )
DISTUTILS_USE_SETUPTOOLS=bdepend
inherit distutils-r1 wrapper

DESCRIPTION="Amavisd-new virus scanner by using the Virustotal Public API."
HOMEPAGE="https://github.com/ercpe/amavisvt"
SRC_URI="https://github.com/ercpe/${PN}/archive/${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	mail-filter/amavisd-new
	dev-python/python-levenshtein[${PYTHON_USEDEP}]
	dev-python/python-magic[${PYTHON_USEDEP}]
	dev-python/python-memcached[${PYTHON_USEDEP}]
	>=dev-python/requests-2.9.1[${PYTHON_USEDEP}]
	dev-python/setproctitle[${PYTHON_USEDEP}]"

BDEPEND="${RDEPEND}"

python_install_all() {
	distutils-r1_python_install_all

	sed -e '/^\[daemon\]/a socket-path = /run/amavisvt.sock' amavisvt_example.cfg > amavisvt.cfg || die

	newinitd "${FILESDIR}/${PN}-initrd" "${PN}"
	newconfd "${FILESDIR}/${PN}-confd"  ${PN}

	make_wrapper "${PN}-daemon" "${EPYTHON} $(python_get_sitedir)/${PN}/amavisvtd.py"

	keepdir /var/lib/${PN}

	insinto /etc
	doins amavisvt.cfg
}

pkg_postinst() {
	elog "First, create an account on virustotal.com to obtain your API key."
	elog "Place it one the following location: /etc/amavisvt.cfg"
}
