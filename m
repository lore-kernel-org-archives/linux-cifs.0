From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Thu, 24 Jan 2013 17:15:41 -0600
Message-ID: <CAH2r5mtVEkFjw=zUG1Mx9dwtucLD9GCmVjwT6uus2fZEfykp5A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Two small cifs fixes

The following changes since commit 9a9284153d965a57edc7162a8e57c14c97f3a935:

  Merge branch 'drm-fixes' of
git://people.freedesktop.org/~airlied/linux (2013-01-20 20:55:49
-0800)

are available in the git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git for-next

Cong Ding (1):
      fs/cifs/cifs_dfs_ref.c: fix potential memory leakage

Nickolai Zeldovich (1):
      cifs: fix srcip_matches() for ipv6

 fs/cifs/cifs_dfs_ref.c |    2 ++
 fs/cifs/connect.c      |    2 +-
 2 files changed, 3 insertions(+), 1 deletions(-)

-- 
Thanks,

Steve
