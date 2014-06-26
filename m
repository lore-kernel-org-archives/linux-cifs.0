From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Wed, 25 Jun 2014 23:39:28 -0500
Message-ID: <CAH2r5msZfYuuaS_+WEY6RG-vA_3ZH1cggLrRtmYSneBQ-ovY-Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Small set of misc cifs/smb3 fixes

The following changes since commit 7171511eaec5bf23fb06078f59784a3a0626=
b38f:

  Linux 3.16-rc1 (2014-06-15 17:45:28 -1000)

are available in the git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git for-next

for you to fetch changes up to ce36d9ab3bab06b7b5522f5c8b68fac231b76ffb=
:

  [CIFS] fix mount failure with broken pathnames when smb3 mount with
mapchars option (2014-06-24 08:10:24 -0500)

----------------------------------------------------------------
Bj=C3=B6rn Baumbach (1):
      fs/cifs: fix regression in cifs_create_mf_symlink()

Jeff Layton (1):
      cifs: revalidate mapping prior to satisfying read_iter request
with cache=3Dloose

Steve French (1):
      [CIFS] fix mount failure with broken pathnames when smb3 mount
with mapchars option

 fs/cifs/cifs_unicode.c |  7 ++++---
 fs/cifs/cifsfs.c       | 17 +++++++++++++++--
 fs/cifs/link.c         |  2 +-
 3 files changed, 20 insertions(+), 6 deletions(-)

--=20
Thanks,

Steve
