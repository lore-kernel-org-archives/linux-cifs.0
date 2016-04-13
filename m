From: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] xattr: Export xattr_resolve_name
Date: Thu, 14 Apr 2016 00:27:38 +0200
Message-ID: <1460586466-5518-1-git-send-email-agruenba@redhat.com>
References: <20160413182026.GR25498@ZenIV.linux.org.uk>
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160413182026.GR25498-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Apr 13, 2016 at 8:20 PM, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org> wrote:
> On Wed, Apr 13, 2016 at 05:40:34PM +0200, Andreas Gruenbacher wrote:
>> Export xattr_resolve_name and make it easier to use by filesystems.
>> Use it to remove reiserfs's own copy of the same functionality.
>
> Nah - I've switched that sucker to generic_*xattr() already.  See
> #work.xattr for the current state (commit 79a628d14 in there, should
> propagate in a few).  Sorry, should've pushed that last week...

Okay, here are some more xattr-related patches.

Andreas

Andreas Gruenbacher (7):
  cifs: Fix xattr name checks
  cifs: Check for equality with ACL_TYPE_ACCESS and ACL_TYPE_DEFAULT
  cifs: Fix removexattr for os2.* xattrs
  ceph: Get rid of d_find_alias in ceph_set_acl
  ceph: Switch to generic xattr handlers
  posix acls: Export xattr_handler functions
  gfs2: Switch to generic xattr handlers

Yan, Zheng (1):
  ceph: kill __ceph_removexattr()

 fs/ceph/acl.c                   |  14 ++-
 fs/ceph/dir.c                   |   7 +-
 fs/ceph/inode.c                 |  29 +++---
 fs/ceph/super.h                 |   8 +-
 fs/ceph/xattr.c                 | 192 ++++++----------------------------------
 fs/cifs/cifssmb.c               |   4 +-
 fs/cifs/xattr.c                 |  50 +++++------
 fs/gfs2/inode.c                 |  78 ++--------------
 fs/gfs2/xattr.c                 | 108 ++++++++++++++++++++--
 fs/posix_acl.c                  |   9 +-
 include/linux/posix_acl_xattr.h |   8 ++
 11 files changed, 203 insertions(+), 304 deletions(-)

-- 
2.4.11
