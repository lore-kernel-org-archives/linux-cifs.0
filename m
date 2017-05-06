From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] SMB3 Fixes
Date: Sat, 6 May 2017 12:34:35 -0500
Message-ID: <CAH2r5mvNknV7-By6Fo767opCsL+ZuzWF5NJpt9efp-YLBDKL=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The following includes various fixes for stable for CIFS/SMB3 especially
for better interoperability for SMB3 to Macs. It also includes Pavel's
improvements to SMB3 async i/o support (which is much faster now).

Please pull the following changes since commit
204f144c9fcac355843412b6ba1150086488a208:

  Merge branch 'work.compat' of
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs (2017-05-02
11:54:26 -0700)

are available in the git repository at:


  git://git.samba.org/sfrench/cifs-2.6.git for-next

for you to fetch changes up to 85435d7a15294f9f7ef23469e6aaf7c5dfcc54f0:

  CIFS: add misssing SFM mapping for doublequote (2017-05-05 08:33:44 -0500=
)

----------------------------------------------------------------
Bj=C3=B6rn Jacke (2):
      CIFS: fix mapping of SFM_SPACE and SFM_PERIOD
      CIFS: add misssing SFM mapping for doublequote

Dan Carpenter (1):
      cifs: small underflow in cnvrtDosUnixTm()

Daniel N Pettersson (1):
      cifs: fix IPv6 link local, with scope id, address parsing

David Disseldorp (3):
      cifs: fix leak in FSCTL_ENUM_SNAPS response handling
      cifs: fix CIFS_ENUMERATE_SNAPSHOTS oops
      cifs: fix CIFS_IOC_GET_MNT_INFO oops

Pavel Shilovsky (3):
      CIFS: Add asynchronous context to support kernel AIO
      CIFS: Add asynchronous read support through kernel AIO
      CIFS: Add asynchronous write support through kernel AIO

Rabin Vincent (1):
      CIFS: fix oplock break deadlocks

Steve French (2):
      Set unicode flag on cifs echo request to avoid Mac error
      SMB3: Work around mount failure when using SMB3 dialect to Macs

 fs/cifs/cifs_unicode.c |   6 +
 fs/cifs/cifs_unicode.h |   5 +-
 fs/cifs/cifsfs.c       |  15 ++-
 fs/cifs/cifsglob.h     |  20 +++
 fs/cifs/cifsproto.h    |   3 +
 fs/cifs/cifssmb.c      |   3 +
 fs/cifs/connect.c      |   9 +-
 fs/cifs/file.c         | 357 ++++++++++++++++++++++++++++++++++++---------=
----
 fs/cifs/ioctl.c        |   4 +
 fs/cifs/misc.c         | 122 ++++++++++++++++-
 fs/cifs/netmisc.c      |   6 +-
 fs/cifs/smb2misc.c     |   5 +-
 fs/cifs/smb2ops.c      |   1 +
 fs/cifs/smb2pdu.c      |  14 +-
 14 files changed, 465 insertions(+), 105 deletions(-)

--=20
Thanks,

Steve
