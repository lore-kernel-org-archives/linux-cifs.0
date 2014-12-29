From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT PULL] CIFS Fixes
Date: Mon, 29 Dec 2014 14:55:22 -0600
Message-ID: <CAH2r5mt2bzLyi1BYEoXD_UbuabwKtEqENoer2jedpE07T0ucqg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

A set of three minor cifs fixes.

Please pull the following changes since commit
9ea18f8cab5f1c36cdd0f09717e35ceb48c36a87:

  Merge branch 'for-3.19/drivers' of git://git.kernel.dk/linux-block
(2014-12-13 14:22:26 -0800)

are available in the git repository at:


  git://git.samba.org/sfrench/cifs-2.6.git for-linus

for you to fetch changes up to 9e6d722f3d91c94f2a303d67ddd8fb1ca4c0d375:

  cifs: make new inode cache when file type is different (2014-12-22
14:16:21 -0600)

----------------------------------------------------------------
Kevin Cernekee (1):
      Fix signed/unsigned pointer warning

Nakajima Akira (1):
      cifs: make new inode cache when file type is different

Sachin Prabhu (1):
      Convert MessageID in smb2_hdr to LE

 fs/cifs/cifsglob.h      |  6 +++---
 fs/cifs/netmisc.c       | 12 +++++++-----
 fs/cifs/readdir.c       | 10 +++++++---
 fs/cifs/smb2misc.c      | 12 +++++++-----
 fs/cifs/smb2ops.c       |  3 ++-
 fs/cifs/smb2pdu.h       |  2 +-
 fs/cifs/smb2transport.c |  2 +-
 7 files changed, 28 insertions(+), 19 deletions(-)

-- 
Thanks,

Steve
