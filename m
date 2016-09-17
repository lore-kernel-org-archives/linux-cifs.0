From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Fri, 16 Sep 2016 19:06:58 -0500
Message-ID: <CAH2r5mtTkbxfsh=H0OT4ABRZJF=RbqT1XLCfvwi08s1tJdyh2Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Please merge the following small set of cifs ixes.

The following changes since commit bd0b841fee49de421f615cc173ccff063303672f:

  nvme: make NVME_RDMA depend on BLOCK (2016-09-11 14:41:49 -0700)

are available in the git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git for-next

for you to fetch changes up to 348c1bfa84dfc47da1f1234b7f2bf09fa798edea:

  Move check for prefix path to within cifs_get_root() (2016-09-09
23:58:07 -0500)

----------------------------------------------------------------
Sachin Prabhu (3):
      Fix memory leaks in cifs_do_mount()
      Compare prepaths when comparing superblocks
      Move check for prefix path to within cifs_get_root()

 fs/cifs/cifsfs.c    | 29 ++++++++++++-----------------
 fs/cifs/cifsproto.h |  2 +-
 fs/cifs/connect.c   | 31 +++++++++++++++++++++++++++++--
 3 files changed, 42 insertions(+), 20 deletions(-)

-- 
Thanks,

Steve
