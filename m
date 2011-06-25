From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Fri, 24 Jun 2011 19:24:27 -0500
Message-ID: <BANLkTinaH5J-ScB2PGVe1W=4cPqiCUbL4A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The following changes since commit 5220cc9382e11ca955ce946ee6a5bac577bb14ff:

  Merge branch 'for-linus' of git://git.kernel.dk/linux-block
(2011-06-24 08:42:35 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git master

Jeff Layton (2):
      cifs: free blkcipher in smbhash
      cifs: mark CONFIG_CIFS_NFSD_EXPORT as BROKEN

 fs/cifs/Kconfig      |    2 +-
 fs/cifs/smbencrypt.c |    6 ++----
 2 files changed, 3 insertions(+), 5 deletions(-)


-- 
Thanks,

Steve
