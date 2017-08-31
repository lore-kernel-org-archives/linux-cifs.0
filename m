From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] Two small cifs fixes for stable
Date: Thu, 31 Aug 2017 18:52:12 -0500
Message-ID: <CAH2r5mtnxY05_AW=5+ajOAKcB4nW=RiFcEP3QAF=Gy+yoMzibw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
        "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Please pull the following changes since commit
36fde05f3fb51edea879636db590d70e11f16c82:

  Merge branch 'for-4.13-fixes' of
git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup (2017-08-29
11:16:21 -0700)

are available in the git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git for-next

for you to fetch changes up to 6e3c1529c39e92ed64ca41d53abadabbaa1d5393:

  CIFS: remove endian related sparse warning (2017-08-30 14:43:11 -0500)

The signed tag is cifs-fixes-for-4.13-rc7-and-stable

----------------------------------------------------------------
Pavel Shilovsky (1):
      CIFS: Fix maximum SMB2 header size

Steve French (1):
      CIFS: remove endian related sparse warning

 fs/cifs/dir.c     | 2 +-
 fs/cifs/smb2pdu.h | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

-- 
Thanks,

Steve
