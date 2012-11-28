From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Wed, 28 Nov 2012 14:27:00 -0600
Message-ID: <CAH2r5mtPxmxjLRf7WLwa0k6aMsaPrm1neuQhbSfV+9+evkk-OQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The following changes since commit 5e351cdc998db82935d1248a053a1be37d1160fd:

  Merge tag 'devicetree-for-linus' of
git://git.secretlab.ca/git/linux-2.6 (2012-11-23 12:36:06 -1000)

are available in the git repository at:


  git://git.samba.org/sfrench/cifs-2.6.git for-linus

for you to fetch changes up to c772aa92b6deb2857d4b39a5cc3bd3679cc5f4a6:

  CIFS: Fix wrong buffer pointer usage in smb_set_file_info
(2012-11-28 10:02:46 -0600)

----------------------------------------------------------------
Jeff Layton (1):
      cifs: fix writeback race with file that is growing

Pavel Shilovsky (1):
      CIFS: Fix wrong buffer pointer usage in smb_set_file_info

 fs/cifs/file.c    | 6 +++---
 fs/cifs/smb1ops.c | 3 +--
 2 files changed, 4 insertions(+), 5 deletions(-)

-- 
Thanks,

Steve
