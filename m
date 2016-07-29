From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/3] bug fixes and code cleanups for inaccessible root patch
Date: Fri, 29 Jul 2016 22:38:18 +0100
Message-ID: <1469828301-9937-1-git-send-email-sprabhu@redhat.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	=?UTF-8?q?Aur=C3=A9lien=20Aptel?= <aaptel-IBi9RG/b67k@public.gmane.org>,
	Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The fix for unaccessible root with summary
"fs/cifs: make share unaccessible at root level mountable"
introduces a few bugs. This series of patches cleans up some parts of the code
and also fixes a couple of bugs seen in the patch.

Sachin Prabhu (3):
  Fix memory leaks in cifs_do_mount()
  Compare prepaths when comparing superblocks
  Move check for prefix path to within cifs_get_root()

 fs/cifs/cifsfs.c    | 29 ++++++++++++-----------------
 fs/cifs/cifsproto.h |  2 +-
 fs/cifs/connect.c   | 31 +++++++++++++++++++++++++++++--
 3 files changed, 42 insertions(+), 20 deletions(-)

-- 
2.5.5
