From: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH 2/2] dax: fix data corruption due to stale mmap reads
Date: Thu, 20 Apr 2017 21:44:37 -0600
Message-ID: <20170421034437.4359-2-ross.zwisler@linux.intel.com>
References: <20170420191446.GA21694@linux.intel.com>
 <20170421034437.4359-1-ross.zwisler@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Latchesar Ionkov <lucho-OnYtXJJ0/fesTnJN9+BGXg@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>,
 Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org,
 Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
 Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>,
 Eric Van Hensbergen <ericvh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org,
 Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, v9fs-developer-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,
 Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
 Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Alexey Kuznetsov <kuznet-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>,
 Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 Ron Minnich <rminnich-4OHPYypu0djtX7QSmKvirg@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20170421034437.4359-1-ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Id: linux-cifs.vger.kernel.org

Users of DAX can suffer data corruption from stale mmap reads via the
following sequence:

- open an mmap over a 2MiB hole

- read from a 2MiB hole, faulting in a 2MiB zero page

- write to the hole with write(3p).  The write succeeds but we incorrectly
  leave the 2MiB zero page mapping intact.

- via the mmap, read the data that was just written.  Since the zero page
  mapping is still intact we read back zeroes instead of the new data.

We fix this by unconditionally calling invalidate_inode_pages2_range() in
dax_iomap_actor() for new block allocations, and by enhancing
__dax_invalidate_mapping_entry() so that it properly unmaps the DAX entry
being removed from the radix tree.

This is based on an initial patch from Jan Kara.

Signed-off-by: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Fixes: c6dcf52c23d2 ("mm: Invalidate DAX radix tree entries only if appropriate")
Reported-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>    [4.10+]
---
 fs/dax.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 166504c..3f445d5 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -468,23 +468,35 @@ static int __dax_invalidate_mapping_entry(struct address_space *mapping,
 					  pgoff_t index, bool trunc)
 {
 	int ret = 0;
-	void *entry;
+	void *entry, **slot;
 	struct radix_tree_root *page_tree = &mapping->page_tree;
 
 	spin_lock_irq(&mapping->tree_lock);
-	entry = get_unlocked_mapping_entry(mapping, index, NULL);
+	entry = get_unlocked_mapping_entry(mapping, index, &slot);
 	if (!entry || !radix_tree_exceptional_entry(entry))
 		goto out;
 	if (!trunc &&
 	    (radix_tree_tag_get(page_tree, index, PAGECACHE_TAG_DIRTY) ||
 	     radix_tree_tag_get(page_tree, index, PAGECACHE_TAG_TOWRITE)))
 		goto out;
+
+	/*
+	 * Make sure 'entry' remains valid while we drop mapping->tree_lock to
+	 * do the unmap_mapping_range() call.
+	 */
+	entry = lock_slot(mapping, slot);
+	spin_unlock_irq(&mapping->tree_lock);
+
+	unmap_mapping_range(mapping, (loff_t)index << PAGE_SHIFT,
+			(loff_t)PAGE_SIZE << dax_radix_order(entry), 0);
+
+	spin_lock_irq(&mapping->tree_lock);
 	radix_tree_delete(page_tree, index);
 	mapping->nrexceptional--;
 	ret = 1;
 out:
-	put_unlocked_mapping_entry(mapping, index, entry);
 	spin_unlock_irq(&mapping->tree_lock);
+	dax_wake_mapping_entry_waiter(mapping, index, entry, true);
 	return ret;
 }
 /*
@@ -999,11 +1011,11 @@ dax_iomap_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 		return -EIO;
 
 	/*
-	 * Write can allocate block for an area which has a hole page mapped
-	 * into page tables. We have to tear down these mappings so that data
-	 * written by write(2) is visible in mmap.
+	 * Write can allocate block for an area which has a hole page or zero
+	 * PMD entry in the radix tree.  We have to tear down these mappings so
+	 * that data written by write(2) is visible in mmap.
 	 */
-	if ((iomap->flags & IOMAP_F_NEW) && inode->i_mapping->nrpages) {
+	if (iomap->flags & IOMAP_F_NEW) {
 		invalidate_inode_pages2_range(inode->i_mapping,
 					      pos >> PAGE_SHIFT,
 					      (end - 1) >> PAGE_SHIFT);
-- 
2.9.3
