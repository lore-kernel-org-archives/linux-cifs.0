From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Mon, 6 Feb 2012 19:38:02 -0600
Message-ID: <CAH2r5mvLbc+d0CRm-EaVbezmso8W+rU_ev-0ZMh6KJBcHM7gaA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The following changes since commit c1aab02dac690af7ff634d8e1cb3be6a04387eef:

  migrate_mode.h is not exported to user mode (2012-01-23 17:17:45 -0800)

are available in the git repository at:
  git://git.samba.org/sfrench/cifs-2.6.git master

Dan Carpenter (2):
      cifs: NULL dereference on allocation failure
      cifs: check offset in decode_ntlmssp_challenge()

Randy Dunlap (1):
      cifs: fix printk format warnings

Shirish Pargaonkar (1):
      cifs: Fix oops in session setup code for null user mounts

Steve French (1):
      [CIFS] Update cifs Kconfig title to match removal of
experimental dependency

 fs/cifs/Kconfig   |    4 ++--
 fs/cifs/connect.c |   14 ++++++--------
 fs/cifs/sess.c    |   11 +++++++----
 3 files changed, 15 insertions(+), 14 deletions(-)

-- 
Thanks,

Steve
