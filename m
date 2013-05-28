From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS FIxes
Date: Tue, 28 May 2013 11:11:22 -0500
Message-ID: <CAH2r5muTx5hxSDQxBe1H8dN9FArSOOY4w63DicpXWBb__V0hMQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Fixes for a couple of DFS problems, a problem with extended security
negotiation and two other small cifs fixes.

The following changes since commit 62106e96279f66c52e2123782f9420af9dbe8cbe:

  cifs: only set ops for inodes in I_NEW state (2013-05-24 12:55:39 -0500)

are available in the git repository at:
  git://git.samba.org/sfrench/cifs-2.6.git for-3.10

Jeff Layton (5):
      cifs: fix potential buffer overrun when composing a new options string
      cifs: allow sec=none mounts to work against servers that don't
support extended security
      cifs: fix error handling when calling cifs_parse_devname
      cifs: stop printing the unc= option in /proc/mounts
      cifs: fix composing of mount options for DFS referrals

 fs/cifs/cifs_dfs_ref.c |  141 ++++++++++++++++++++++++-----------------------
 fs/cifs/cifsfs.c       |    3 -
 fs/cifs/connect.c      |   23 +++++---
 fs/cifs/dns_resolve.c  |    4 +-
 4 files changed, 88 insertions(+), 83 deletions(-)


--
Thanks,

Steve
