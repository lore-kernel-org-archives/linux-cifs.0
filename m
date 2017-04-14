From: Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: [PATCH 0/4] Properly invalidate data in the cleancache.
Date: Fri, 14 Apr 2017 17:07:49 +0300
Message-ID: <20170414140753.16108-1-aryabinin@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>,
        Konrad Rzeszutek Wilk <konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>,
        Eric Van Hensbergen <ericvh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Ron Minnich <rminnich-4OHPYypu0djtX7QSmKvirg@public.gmane.org>,
        Latchesar Ionkov <lucho-OnYtXJJ0/fesTnJN9+BGXg@public.gmane.org>,
        Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>,
        Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>,
        Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>,
        Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
        Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>,
        Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>,
        Alexey Kuznetsov <kuznet-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>,
        Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>,
        <v9fs-developer-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>,
        <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        <samba-technical-w/Ol4Ecudpkbz5eF0SucJw@public.gmane.org
To: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>,
        <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

We've noticed that after direct IO write, buffered read sometimes gets
stale data which is coming from the cleancache.
The reason for this is that some direct write hooks call call invalidate_inode_pages2[_range]()
conditionally iff mapping->nrpages is not zero, so we may not invalidate
data in the cleancache.

Another odd thing is that we check only for ->nrpages and don't check for ->nrexceptional,
but invalidate_inode_pages2[_range] also invalidates exceptional entries as well.
So we invalidate exceptional entries only if ->nrpages != 0? This doesn't feel right.

 - Patch 1 fixes direct IO writes by removing ->nrpages check.
 - Patch 2 fixes similar case in invalidate_bdev(). 
     Note: I only fixed conditional cleancache_invalidate_inode() here.
       Do we also need to add ->nrexceptional check in into invalidate_bdev()?
     
 - Patches 3-4: some optimizations.

Andrey Ryabinin (4):
  fs: fix data invalidation in the cleancache during direct IO
  fs/block_dev: always invalidate cleancache in invalidate_bdev()
  mm/truncate: bail out early from invalidate_inode_pages2_range() if
    mapping is empty
  mm/truncate: avoid pointless cleancache_invalidate_inode() calls.

 fs/9p/vfs_file.c |  2 +-
 fs/block_dev.c   | 11 +++++------
 fs/cifs/inode.c  |  2 +-
 fs/dax.c         |  2 +-
 fs/iomap.c       | 16 +++++++---------
 fs/nfs/direct.c  |  6 ++----
 fs/nfs/inode.c   |  8 +++++---
 mm/filemap.c     | 26 +++++++++++---------------
 mm/truncate.c    | 13 +++++++++----
 9 files changed, 42 insertions(+), 44 deletions(-)

-- 
2.10.2
