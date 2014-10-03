From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT PULL] CIFS/SMB3 Fixes
Date: Fri, 3 Oct 2014 14:56:15 -0500
Message-ID: <CAH2r5mvYGmtFa8Cb=r3pXDCGJdOm+wvtdSCZW0WC2G2y+Mj1pw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Fix for CIFS/SMB3 oops on reconnect during readpages (3.17 regression)
and for incorrectly closing file handle in symlink error cases

Please pull the following changes since commit
50dddff3cb9af328dd42bafe3437c7f47e8b38a9:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net
(2014-10-01 21:29:06 -0700)

are available in the git repository at:


  git://git.samba.org/sfrench/cifs-2.6.git for-linus

for you to fetch changes up to 1209bbdff2f6bbffa6eb5823033bbd7b8799a5e2:

  CIFS: Fix readpages retrying on reconnects (2014-10-02 14:17:41 -0500)

----------------------------------------------------------------
Pavel Shilovsky (1):
      CIFS: Fix readpages retrying on reconnects

Steve French (1):
      Fix problem recognizing symlinks

 fs/cifs/file.c         | 8 +-------
 fs/cifs/smb1ops.c      | 2 +-
 fs/cifs/smb2maperror.c | 2 ++
 3 files changed, 4 insertions(+), 8 deletions(-)

-- 
Thanks,

Steve
