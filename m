From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Sun, 13 Sep 2015 15:59:52 -0500
Message-ID: <CAH2r5msYg76kub6pF9DRc1Y0Kc9oVasVs2eHHBj7G49a-3Nc-g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Two small cifs fixes.

Please pull the following changes since commit
b0a1ea51bda4c2bcdde460221e1772f3a4f8c44f:

  Merge branch 'for-4.3/blkcg' of git://git.kernel.dk/linux-block
(2015-09-10 18:56:14 -0700)

are available in the git repository at:


  git://git.samba.org/sfrench/cifs-2.6.git for-next

for you to fetch changes up to eda2116f4ab6d79cfcffc202b5d2bbb0797ba013:

  [CIFS] mount option sec=none not displayed properly in /proc/mounts
(2015-09-11 19:37:06 -0500)

----------------------------------------------------------------
Jann Horn (1):
      CIFS: fix type confusion in copy offload ioctl

Steve French (1):
      [CIFS] mount option sec=none not displayed properly in /proc/mounts

 fs/cifs/cifsfs.c | 5 ++++-
 fs/cifs/ioctl.c  | 6 ++++++
 2 files changed, 10 insertions(+), 1 deletion(-)

-- 
Thanks,

Steve
