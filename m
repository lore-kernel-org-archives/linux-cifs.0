From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Mon, 30 Dec 2013 18:18:06 -0600
Message-ID: <CAH2r5mu_QfVAx8psgz2giyw7+tEpQKkV-Y+vbkqurOBB94nY+w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

A few small cifs fixes including two for stable, and fixing a
regression introduced by the VFS change to file create.

The following changes since commit f41bfc9423aac4e589d2b3bedf26b3c249c61146:

  Merge tag 'ext4_for_linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4 (2013-12-26
09:26:12 -0800)

are available in the git repository at:


  git://git.samba.org/sfrench/cifs-2.6.git for-linus

for you to fetch changes up to f1e3268126a35b9d3cb8bf67487fcc6cd13991d8:

  cifs: set FILE_CREATED (2013-12-27 15:14:45 -0600)

----------------------------------------------------------------
Sachin Prabhu (1):
      cifs: We do not drop reference to tlink in CIFSCheckMFSymlink()

Shirish Pargaonkar (1):
      cifs: set FILE_CREATED

Steve French (1):
      Add missing end of line termination to some cifs messages

 fs/cifs/cifsproto.h |  7 ++++---
 fs/cifs/cifssmb.c   |  6 +++---
 fs/cifs/dir.c       | 11 ++++++-----
 fs/cifs/inode.c     |  6 ++++--
 fs/cifs/link.c      | 26 +++++++++++---------------
 5 files changed, 28 insertions(+), 28 deletions(-)

-- 
Thanks,

Steve
