From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Sun, 14 Aug 2011 22:19:06 -0500
Message-ID: <CAH2r5mtoCq+K=1sZUuWC3T-YdmWrT5Q0u_nCgs5w7+2xYu-oBg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The following changes since commit e6a99d312687a42c077a9b8cb5e757f186edb1b9:

  Merge branch 'slab/urgent' of
git://git.kernel.org/pub/scm/linux/kernel/git/penberg/slab-2.6
(2011-08-09 08:42:16 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git master

Shirish Pargaonkar (1):
      cifs: Do not set cifs/ntfs acl using a file handle (try #4)

Steve French (1):
      [CIFS] Cleanup use of CONFIG_CIFS_STATS2 ifdef to make transport
routines more readable

 fs/cifs/cifs_debug.c |    2 +-
 fs/cifs/cifsacl.c    |   28 +------------------------
 fs/cifs/cifsglob.h   |   56 +++++++++++++++++++++++++++++++++++++++++++------
 fs/cifs/transport.c  |   51 +++++++++++++++------------------------------
 4 files changed, 68 insertions(+), 69 deletions(-)


-- 
Thanks,

Steve
