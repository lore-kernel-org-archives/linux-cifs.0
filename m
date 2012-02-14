From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Mon, 13 Feb 2012 21:30:51 -0600
Message-ID: <CAH2r5ms+ZunDJ-OkhSUUsrL_Wzz1b1dd2Ge3oxJV-dDJNPX78g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The following changes since commit 98e96852480566333f6dacd3223f0be15df34d60:

  Merge tag 'fbdev-fixes-for-3.3-1' of
git://github.com/schandinat/linux-2.6 (2012-02-07 15:54:02 -0800)

are available in the git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git master

Jeff Layton (3):
      cifs: fix error handling when cifscreds key payload is an error
      cifs: request oplock when doing open on lookup
      cifs: don't return error from standard_receive3 after marking
response malformed

 fs/cifs/connect.c |    9 +++++----
 fs/cifs/dir.c     |    2 +-
 2 files changed, 6 insertions(+), 5 deletions(-)

-- 
Thanks,

Steve
