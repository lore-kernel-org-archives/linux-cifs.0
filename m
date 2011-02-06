From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Sun, 6 Feb 2011 10:45:33 -0600
Message-ID: <AANLkTimnN_LKnGdVgqBC0rMBVApN+Qn5bzOzv28Y=9eh@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The following changes since commit afe8a887550f7cc24eb16449670b93f6b43c32d8:

  Merge branch 'next' of git://git.monstr.eu/linux-2.6-microblaze
(2011-02-02 10:23:58 +1100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git master

Jeff Layton (3):
      cifs: fix length vs. total_read confusion in cifs_demultiplex_thread
      cifs: enable signing flag in SMB header when server has it on
      cifs: don't send an echo request unless NegProt has been done

Pavel Shilovsky (1):
      CIFS: Fix variable types in cifs_iovec_read/write (try #2)

Shirish Pargaonkar (1):
      cifs: Possible slab memory corruption while updating extended
stats (repost)

Stanislav Fomichev (1):
      cifs: add check for kmalloc in parse_dacl

 fs/cifs/cifsacl.c   |    4 ++++
 fs/cifs/connect.c   |   22 +++++++++++++---------
 fs/cifs/file.c      |   11 ++++++-----
 fs/cifs/transport.c |    4 ++++
 4 files changed, 27 insertions(+), 14 deletions(-)


-- 
Thanks,

Steve
