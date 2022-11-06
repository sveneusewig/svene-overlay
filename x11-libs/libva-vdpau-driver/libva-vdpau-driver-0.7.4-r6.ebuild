# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools multilib-minimal git-r3

DESCRIPTION="Experimental VP9 codec support for vdpau-va-driver (NVIDIA VDPAU-VAAPI wrapper) and chromium-vaapi."
HOMEPAGE="https://github.com/xuanruiqi/vdpau-va-driver-vp9"
#SRC_URI="https://www.freedesktop.org/software/vaapi/releases/libva-vdpau-driver/${P}.tar.bz2"
EGIT_REPO_URI="https://github.com/xuanruiqi/vdpau-va-driver-vp9"
EGIT_BRANCH="master"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm64 ~riscv x86"
IUSE="debug opengl"

RDEPEND="
	>=media-libs/libva-2.2.1[X,opengl?,${MULTILIB_USEDEP}]
	>=x11-libs/libvdpau-0.8[${MULTILIB_USEDEP}]
	opengl? ( >=virtual/opengl-7.0-r1[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

#DOCS=( NEWS README AUTHORS )

#PATCHES=(
#	"${FILESDIR}"/${P}-glext-missing-definition.patch
#	"${FILESDIR}"/${P}-VAEncH264VUIBufferType.patch
#	"${FILESDIR}"/${P}-libvdpau-0.8.patch
#	"${FILESDIR}"/${P}-sigfpe-crash.patch
#	"${FILESDIR}"/${P}-include-linux-videodev2.h.patch
#)

src_prepare() {
	default
	sed -i 's:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:' configure.ac || die
	eautoreconf
}

multilib_src_configure() {
	local myeconfargs=(
		$(use_enable debug)
		$(use_enable opengl glx)
	)

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}
