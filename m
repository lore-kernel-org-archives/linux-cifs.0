From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Sat, 6 Aug 2011 15:51:27 -0500
Message-ID: <CAH2r5mvWjxT1O2KDMMe3TN05e7DzKtR91kUXqW5fkPNjFcem6Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The following changes since commit 5f66d2b58ca879e70740c82422354144845d6dd3:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6
(2011-08-01 06:14:25 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git master

Jeff Layton (3):
      cifs: demote DFS referral lookup errors to cFYI
      cifs: convert prefixpath delimiters in cifs_build_path_to_root
      cifs: cope with negative dentries in cifs_get_root

Pavel Shilovsky (1):
      CIFS: Fix missing a decrement of inFlight value

Steve French (1):
      Revert "cifs: advertise the right receive buffer size to the server"

 fs/cifs/cifs_dfs_ref.c |    5 +++--
 fs/cifs/cifsfs.c       |    4 ++++
 fs/cifs/dns_resolve.c  |    4 ++--
 fs/cifs/inode.c        |   14 ++------------
 fs/cifs/sess.c         |    3 +--
 fs/cifs/transport.c    |    2 ++
 6 files changed, 14 insertions(+), 18 deletions(-)


-- 
Thanks,

Steve
