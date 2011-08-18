From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Thu, 18 Aug 2011 12:08:34 -0500
Message-ID: <CAH2r5mtt4hnUG7qE-uYFVZtHGyW+9N-oknmbFDzFzX4_4FsCDw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The following changes since commit b5ddbf465f3675b19c8f5528b4064cbf278a5c6f:

  regmap: using module facilities requires module.h (2011-08-15 19:28:17 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git
..BRANCH.NOT.VERIFIED..

Jeff Layton (1):
      cifs: demote cERROR in build_path_from_dentry to cFYI

Steve French (2):
      [CIFS] possible memory corruption on mount
      update cifs version to 1.75

 fs/cifs/cifsfs.h  |    2 +-
 fs/cifs/connect.c |    3 ++-
 fs/cifs/dir.c     |    4 ++--
 3 files changed, 5 insertions(+), 4 deletions(-)

-- 
Thanks,

Steve
