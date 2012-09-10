From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Mon, 10 Sep 2012 11:51:43 -0500
Message-ID: <CAH2r5muNJci+H5=oKSXmHpznJ+jEUtNVN7yGRK0GczmV9dD06w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The following changes since commit 5b716ac728bcc01b1f2a7ed6e437196602237c27:

  Merge branch 'for-next' of git://git.samba.org/sfrench/cifs-2.6
(2012-09-02 11:30:10 -0700)

are available in the git repository at:


  git://git.samba.org/sfrench/cifs-2.6.git for-linus

for you to fetch changes up to b2ede58e98c87c7f0f44a926f974262f65c3402f:

  CIFS: Fix endianness conversion (2012-09-06 12:42:35 -0500)

----------------------------------------------------------------
Pavel Shilovsky (2):
      CIFS: Fix error handling in cifs_push_mandatory_locks
      CIFS: Fix endianness conversion

 fs/cifs/file.c    | 2 +-
 fs/cifs/smb2pdu.h | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

-- 
Thanks,

Steve
