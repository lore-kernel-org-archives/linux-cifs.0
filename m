From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Mon, 21 Feb 2011 16:34:20 -0600
Message-ID: <AANLkTi=QRisTVYdNDDQkWXwXBr5YiL3oMh2z-NzHGR86@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The following changes since commit a2640111d5edb3f4e6dd6089c0dbddc7590110b4:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6
(2011-02-16 09:07:00 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git
..BRANCH.NOT.VERIFIED..

Jeff Layton (1):
      cifs: fix handling of scopeid in cifs_convert_address

Shirish Pargaonkar (1):
      cifs: Fix regression in LANMAN (LM) auth code

Steve French (1):
      [CIFS] update cifs version

 fs/cifs/cifsfs.h  |    2 +-
 fs/cifs/netmisc.c |    8 ++++----
 fs/cifs/sess.c    |    8 ++++----
 3 files changed, 9 insertions(+), 9 deletions(-)


-- 
Thanks,

Steve
