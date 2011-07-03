From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fix
Date: Sun, 3 Jul 2011 12:59:58 -0500
Message-ID: <CAH2r5muydfwyjqNhOg=3WvpH8OEdRtUDN77M_zQVmmJ6HwTDiA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The following changes since commit daf54f1f363a61c618662ef66d4bf09d2b090941:

  drm/radeon/kms: Fix chremap setup on RV770 CE (2011-07-01 07:29:46 +1000)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git master

Jeff Layton (1):
      cifs: set socket send and receive timeouts before attempting connect

 fs/cifs/connect.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)


-- 
Thanks,

Steve
