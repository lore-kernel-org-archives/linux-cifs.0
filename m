From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 1/2] dax: prevent invalidation of mapped DAX entries
Date: Tue, 25 Apr 2017 12:10:41 +0200
Message-ID: <20170425101041.GG2793@quack2.suse.cz>
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
 linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
 Alexey Kuznetsov <kuznet-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>,
 linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ron Minnich <rminnich-4OHPYypu0djtX7QSmKvirg@public.gmane.org>,
 Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
 Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
To: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
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

On Thu 20-04-17 21:44:36, Ross Zwisler wrote:
> dax_invalidate_mapping_entry() currently removes DAX exceptional entries
> only if they are clean and unlocked.  This is done via:
> 
> invalidate_mapping_pages()
>   invalidate_exceptional_entry()
>     dax_invalidate_mapping_entry()
> 
> However, for page cache pages removed in invalidate_mapping_pages() there
> is an additional criteria which is that the page must not be mapped.  This
> is noted in the comments above invalidate_mapping_pages() and is checked in
> invalidate_inode_page().
> 
> For DAX entries this means that we can can end up in a situation where a
> DAX exceptional entry, either a huge zero page or a regular DAX entry,
> could end up mapped but without an associated radix tree entry. This is
> inconsistent with the rest of the DAX code and with what happens in the
> page cache case.
> 
> We aren't able to unmap the DAX exceptional entry because according to its
> comments invalidate_mapping_pages() isn't allowed to block, and
> unmap_mapping_range() takes a write lock on the mapping->i_mmap_rwsem.
> 
> Since we essentially never have unmapped DAX entries to evict from the
> radix tree, just remove dax_invalidate_mapping_entry().
> 
> Signed-off-by: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Fixes: c6dcf52c23d2 ("mm: Invalidate DAX radix tree entries only if appropriate")
> Reported-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>    [4.10+]

Just as a side note - we wouldn't really have to unmap the mapping range
covered by the DAX exceptional entry. It would be enough to find out
whether such range is mapped and bail out in that case. But that would
still be pretty expensive for DAX - we'd have to do rmap walk similar as in
dax_mapping_entry_mkclean() and IMHO it is not worth it. So I agree with
what you did. You can add:

Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>

								Honza

> ---
> 
> This series applies cleanly to the current v4.11-rc7 based linux/master,
> and has passed an xfstests run with DAX on ext4 and XFS.
> 
> These patches also apply to v4.10.9 with a little work from the 3-way
> merge feature.
> 
>  fs/dax.c            | 29 -----------------------------
>  include/linux/dax.h |  1 -
>  mm/truncate.c       |  9 +++------
>  3 files changed, 3 insertions(+), 36 deletions(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 85abd74..166504c 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -507,35 +507,6 @@ int dax_delete_mapping_entry(struct address_space *mapping, pgoff_t index)
>  }
>  
>  /*
> - * Invalidate exceptional DAX entry if easily possible. This handles DAX
> - * entries for invalidate_inode_pages() so we evict the entry only if we can
> - * do so without blocking.
> - */
> -int dax_invalidate_mapping_entry(struct address_space *mapping, pgoff_t index)
> -{
> -	int ret = 0;
> -	void *entry, **slot;
> -	struct radix_tree_root *page_tree = &mapping->page_tree;
> -
> -	spin_lock_irq(&mapping->tree_lock);
> -	entry = __radix_tree_lookup(page_tree, index, NULL, &slot);
> -	if (!entry || !radix_tree_exceptional_entry(entry) ||
> -	    slot_locked(mapping, slot))
> -		goto out;
> -	if (radix_tree_tag_get(page_tree, index, PAGECACHE_TAG_DIRTY) ||
> -	    radix_tree_tag_get(page_tree, index, PAGECACHE_TAG_TOWRITE))
> -		goto out;
> -	radix_tree_delete(page_tree, index);
> -	mapping->nrexceptional--;
> -	ret = 1;
> -out:
> -	spin_unlock_irq(&mapping->tree_lock);
> -	if (ret)
> -		dax_wake_mapping_entry_waiter(mapping, index, entry, true);
> -	return ret;
> -}
> -
> -/*
>   * Invalidate exceptional DAX entry if it is clean.
>   */
>  int dax_invalidate_mapping_entry_sync(struct address_space *mapping,
> diff --git a/include/linux/dax.h b/include/linux/dax.h
> index d8a3dc0..f8e1833 100644
> --- a/include/linux/dax.h
> +++ b/include/linux/dax.h
> @@ -41,7 +41,6 @@ ssize_t dax_iomap_rw(struct kiocb *iocb, struct iov_iter *iter,
>  int dax_iomap_fault(struct vm_fault *vmf, enum page_entry_size pe_size,
>  		    const struct iomap_ops *ops);
>  int dax_delete_mapping_entry(struct address_space *mapping, pgoff_t index);
> -int dax_invalidate_mapping_entry(struct address_space *mapping, pgoff_t index);
>  int dax_invalidate_mapping_entry_sync(struct address_space *mapping,
>  				      pgoff_t index);
>  void dax_wake_mapping_entry_waiter(struct address_space *mapping,
> diff --git a/mm/truncate.c b/mm/truncate.c
> index 6263aff..c537184 100644
> --- a/mm/truncate.c
> +++ b/mm/truncate.c
> @@ -67,17 +67,14 @@ static void truncate_exceptional_entry(struct address_space *mapping,
>  
>  /*
>   * Invalidate exceptional entry if easily possible. This handles exceptional
> - * entries for invalidate_inode_pages() so for DAX it evicts only unlocked and
> - * clean entries.
> + * entries for invalidate_inode_pages().
>   */
>  static int invalidate_exceptional_entry(struct address_space *mapping,
>  					pgoff_t index, void *entry)
>  {
> -	/* Handled by shmem itself */
> -	if (shmem_mapping(mapping))
> +	/* Handled by shmem itself, or for DAX we do nothing. */
> +	if (shmem_mapping(mapping) || dax_mapping(mapping))
>  		return 1;
> -	if (dax_mapping(mapping))
> -		return dax_invalidate_mapping_entry(mapping, index);
>  	clear_shadow_entry(mapping, index, entry);
>  	return 1;
>  }
> -- 
> 2.9.3
> 
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
