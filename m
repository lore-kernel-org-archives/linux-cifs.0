From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: [RFC][PATCH 00/10] cifs: local caching support using FS-Cache
Date: Tue, 22 Jun 2010 20:50:05 +0530
Message-ID: <1277220005-3322-1-git-send-email-sjayaraman@suse.de>
References: <yes>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <yes>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This patchset is a first stab at adding persistent, local caching facility for
CIFS using the FS-Cache interface.

The index hierarchy which is mainly used to locate a file object or discard
a certain subset of the files cached, currently has three levels:
	- Server
	- Share 
	- File

The server index object is keyed by hostname of the server. The superblock
index object is keyed by the sharename and the inode object is keyed by the
UniqueId. The cache coherency is ensured by checking the 'LastWriteTime' and
size of file.

To use this, apply this patchset in order, mount the share with rsize=4096 and
try copying a huge file (say few hundred MBs) from mount point to local
filesystem. During the first time, the cache will be initialized. When you copy
the second time, it should read from the local cache.

To reduce the impact of page cache and see the local caching in action
readily, try doing a sync and drop the caches by doing:
	sync; echo 3 > /proc/sys/vm/drop_caches

Known issues
-------------
	- the cache coherency check may not be reliable always as some
	  CIFS servers are known not to update mtime until the filehandle is
	  closed.
	- not all the Servers under all circumstances provide a unique
	  'UniqueId'.

Todo's
-------
	- improvements to avoid potential key collisions
	- address the above known issues

This set is lightly tested and all the bugs seen during my testing have been
fixed. However, this can be considered as an RFC for now.

Any Comments or Suggestions are welcome.

Suresh Jayaraman (10)
  cifs: add kernel config option for CIFS Client caching support
  cifs: guard cifsglob.h against multiple inclusion
  cifs: register CIFS for caching
  cifs: define server-level cache index objects and register them with FS-Cache
  cifs: define superblock-level cache index objects and register them
  cifs: define inode-level cache object and register them
  cifs: FS-Cache page management
  cifs: store pages into local cache
  cifs: read pages from FS-Cache
  cifs: add mount option to enable local caching

 Kconfig      |    9 ++
 Makefile     |    2 
 cache.c      |  251 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 cifs_fs_sb.h |    1 
 cifsfs.c     |   15 +++
 cifsglob.h   |   14 +++
 connect.c    |   16 +++
 file.c       |   51 +++++++++++
 fscache.c    |  244 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fscache.h    |  135 +++++++++++++++++++++++++++++++
 inode.c      |    4 
 11 files changed, 742 insertions(+)
