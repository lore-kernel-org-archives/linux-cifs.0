From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Tue, 17 Apr 2012 11:10:39 -0500
Message-ID: <CAH2r5mvZk1qCwdbkWW6LD4=xvzr_1=dbPNAM3Rw=yVRWrm1rkQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The following changes since commit f68e556e23d1a4176b563bcb25d8baf2c5313f91:
  Linus Torvalds (1):
        Make the "word-at-a-time" helper functions more commonly usable

are available in the git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git ..BRANCH.NOT.VERIFIED..

Sachin Prabhu (2):
      Cleanup handling of NULL value passed for a mount option
      Fix number parsing in cifs_parse_mount_options

 fs/cifs/connect.c |   82 +++++++++++++----------------------------------------
 1 files changed, 20 insertions(+), 62 deletions(-)

-- 
Thanks,

Steve
