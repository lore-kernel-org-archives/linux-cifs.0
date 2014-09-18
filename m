From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT PULL] CIFS/SMB3 Fixes
Date: Thu, 18 Sep 2014 10:00:56 -0700
Message-ID: <CAH2r5msoMtzb9jENNet7YSOTmurEiaTh_ju-BSf8v47f_CLr6Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Fixes for problems found during testing and debugging at the SMB3 storage
test event (plugfest) this week.

Please pull the following changes since commit
1536340e7c67694b134cbbc07168e5a524e49d08:

  Merge branches 'locking-urgent-for-linus' and
'timers-urgent-for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip (2014-09-13
14:22:12 -0700)

are available in the git repository at:


  git://git.samba.org/sfrench/cifs-2.6.git for-linus

for you to fetch changes up to 364d42930d96a872b2076deeb9c24f9ff132de34:

  Fix mfsymlinks file size check (2014-09-16 06:48:20 -0500)

----------------------------------------------------------------
Arnd Bergmann (1):
      cifs: remove dead code

Steve French (5):
      [CIFS] Fix setting time before epoch (negative time values)
      [SMB3] Fix oops when creating symlinks on smb3
      Revert "cifs: No need to send SIGKILL to demux_thread during umount"
      Update version number displayed by modinfo for cifs.ko
      Fix mfsymlinks file size check

 fs/cifs/cifsfs.h  |  2 +-
 fs/cifs/connect.c | 19 +++++++++++++++++++
 fs/cifs/link.c    | 12 +++++++++---
 fs/cifs/netmisc.c | 20 ++++++++++++++++----
 fs/cifs/sess.c    | 17 -----------------
 5 files changed, 45 insertions(+), 25 deletions(-)

-- 
Thanks,

Steve
