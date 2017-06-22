From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Thu, 22 Jun 2017 11:30:26 -0500
Message-ID: <CAH2r5mvDc3F5b6j_1hLeoBRb+fdJvy+HUZk_wSj24PH6SyMddQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Please pull the following changes since commit
9705596d08ac87c18aee32cc97f2783b7d14624e:

  Merge tag 'clk-fixes-for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/clk/linux (2017-06-20
11:02:29 +0800)

are available in the git repository at:


  git://git.samba.org/sfrench/cifs-2.6.git for-next

for you to fetch changes up to 517a6e43c4872c89794af5b377fa085e47345952:

  CIFS: Fix some return values in case of error in 'crypt_message'
(2017-06-21 00:09:28 -0500)


Includes various small fixes for stable

----------------------------------------------------------------
Christophe Jaillet (1):
      CIFS: Fix some return values in case of error in 'crypt_message'

Colin Ian King (2):
      CIFS: check if pages is null rather than bv for a failed allocation
      cifs: remove redundant return in cifs_creation_time_get

Dan Carpenter (1):
      CIFS: Set ->should_dirty in cifs_user_readv()

Pavel Shilovsky (1):
      CIFS: Improve readdir verbosity

 fs/cifs/file.c    | 2 +-
 fs/cifs/misc.c    | 2 +-
 fs/cifs/smb1ops.c | 9 +++++++--
 fs/cifs/smb2ops.c | 8 +++++---
 fs/cifs/xattr.c   | 2 --
 5 files changed, 14 insertions(+), 9 deletions(-)

-- 
Thanks,

Steve
