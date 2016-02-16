From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Fwd: [GIT] CIFS Fixes
Date: Tue, 16 Feb 2016 11:16:33 -0600
Message-ID: <CAH2r5muKsa4PeeK-bnpja0o3NzQrhyE3ZDCrWvoT-_pZhrXf0A@mail.gmail.com>
References: <CAH2r5msZ1uFbZvXX=z1NwDmJvk9VdPcLWDPbh=VDfk-Ln51AcA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5msZ1uFbZvXX=z1NwDmJvk9VdPcLWDPbh=VDfk-Ln51AcA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

---------- Forwarded message ----------
From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date: Tue, Feb 16, 2016 at 11:15 AM
Subject: [GIT] CIFS Fixes
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>


Please pull the following small set of cifs fixes.  I am still
reviewing some more, recently submitted SMB3 fixes, but these three
are small and safe and ready now.

The following changes since commit 74c7b2af37ad431c3b69961a5cdbd0a92292c92a:

  Merge branch 'for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input (2016-02-10
12:21:57 -0800)

are available in the git repository at:


  git://git.samba.org/sfrench/cifs-2.6.git for-next

for you to fetch changes up to 4b550af519854421dfec9f7732cdddeb057134b2:

  cifs: fix erroneous return value (2016-02-10 18:23:31 -0600)

----------------------------------------------------------------
Anton Protopopov (1):
      cifs: fix erroneous return value

Colin Ian King (1):
      cifs: remove redundant check for null string pointer

Insu Yun (1):
      cifs: fix potential overflow in cifs_compose_mount_options

 fs/cifs/cifs_dfs_ref.c | 2 +-
 fs/cifs/cifsencrypt.c  | 2 +-
 fs/cifs/connect.c      | 3 +--
 3 files changed, 3 insertions(+), 4 deletions(-)

-- 
Thanks,

Steve



-- 
Thanks,

Steve
