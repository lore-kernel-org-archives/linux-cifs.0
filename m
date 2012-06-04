From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Mon, 4 Jun 2012 12:02:13 -0500
Message-ID: <CAH2r5mur6A2rvzEs2f2OchjU6mVW8NTmXkEwdCDF_XThYMhWbA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The following changes since commit 51eab603f5c86dd1eae4c525df3e7f7eeab401d6:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../mason/linux-btrfs

are available in the git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git for-next

Pavel Shilovsky (4):
      CIFS: Fix possible wrong memory allocation
      CIFS: Improve identation in cifs_unlock_range
      CIFS: Make accessing is_valid_oplock/dump_detail ops struct field safe
      CIFS: Move get_next_mid to ops struct

 fs/cifs/cifsglob.h  |    7 +++
 fs/cifs/cifsproto.h |    1 -
 fs/cifs/cifssmb.c   |    8 ++--
 fs/cifs/connect.c   |    8 ++-
 fs/cifs/file.c      |  106 +++++++++++++++++++++++++++++----------------------
 fs/cifs/misc.c      |   89 +------------------------------------------
 fs/cifs/smb1ops.c   |   89 ++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/transport.c |    2 +-
 8 files changed, 167 insertions(+), 143 deletions(-)

-- 
Thanks,

Steve
