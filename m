From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Tue, 9 Nov 2010 12:20:44 -0600
Message-ID: <AANLkTimn687e4OGudbJ7SCn0OMrbQr0_9E2rKOVYoS1t@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The following changes since commit 151f52f09c5728ecfdd0c289da1a4b30bb416f2c:

  ipw2x00: remove the right /proc/net entry (2010-11-05 18:57:04 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git master

Jeff Layton (1):
      cifs: make cifs_ioctl handle NULL filp->private_data correctly

Suresh Jayaraman (1):
      cifs: fix a memleak in cifs_setattr_nounix()

 fs/cifs/inode.c |    1 -
 fs/cifs/ioctl.c |   12 ++++++++++--
 2 files changed, 10 insertions(+), 3 deletions(-)


-- 
Thanks,

Steve
