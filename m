From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [GIT PULL] CIFS FS-Cache bugfix
Date: Mon, 16 Sep 2013 14:34:40 +0100
Message-ID: <12400.1379338480@warthog.procyon.org.uk>
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cachefs-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


Hi Steve,

Could you pull a CIFS bugfix from my fscache branch?

David
---
The following changes since commit 5a6f282a2052bb13171b53f03b34501cf72c33f1:

  fscache: Netfs function for cleanup post readpages (2013-09-06 09:17:30 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git fscache

for you to fetch changes up to 19ce0a7c9e94ae975e1c029b65b332cbf77b41ec:

  CIFS: FS-Cache: Uncache unread pages in cifs_readpages() before freeing them (2013-09-06 09:17:30 +0100)

----------------------------------------------------------------
David Howells (1):
      CIFS: FS-Cache: Uncache unread pages in cifs_readpages() before freeing them

 fs/cifs/file.c    |  8 ++++++++
 fs/cifs/fscache.c |  7 +++++++
 fs/cifs/fscache.h | 13 +++++++++++++
 3 files changed, 28 insertions(+)
