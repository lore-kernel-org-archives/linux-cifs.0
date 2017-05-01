From: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 2/2] dax: fix data corruption due to stale mmap reads
Date: Mon, 1 May 2017 16:38:55 -0600
Message-ID: <20170501223855.GA25862@linux.intel.com>
References: <20170420191446.GA21694@linux.intel.com>
 <20170421034437.4359-1-ross.zwisler@linux.intel.com>
 <20170421034437.4359-2-ross.zwisler@linux.intel.com>
 <20170425111043.GH2793@quack2.suse.cz>
 <20170425225936.GA29655@linux.intel.com>
 <20170426085235.GA21738@quack2.suse.cz>
 <20170426225236.GA25838@linux.intel.com>
 <20170427072659.GA29789@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Latchesar Ionkov <lucho-OnYtXJJ0/fesTnJN9+BGXg@public.gmane.org>,
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
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170427072659.GA29789-4I4JzKEfoa/jFM9bn6wA6Q@public.gmane.org>
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

On Thu, Apr 27, 2017 at 09:26:59AM +0200, Jan Kara wrote:
> On Wed 26-04-17 16:52:36, Ross Zwisler wrote:
<>
> > I don't think this alone is enough to save us.  The I/O path doesn't currently
> > take any DAX radix tree entry locks, so our race would just become:
> > 
> > CPU1 - write(2)				CPU2 - read fault
> > 
> > 					dax_iomap_pte_fault()
> > 					  grab_mapping_entry() // newly moved
> > 					  ->iomap_begin() - sees hole
> > dax_iomap_rw()
> >   iomap_apply()
> >     ->iomap_begin - allocates blocks
> >     dax_iomap_actor()
> >       invalidate_inode_pages2_range()
> >         - there's nothing to invalidate
> > 					  - we add zero page in the radix
> > 					    tree & map it to page tables
> > 
> > In their current form I don't think we want to take DAX radix tree entry locks
> > in the I/O path because that would effectively serialize I/O over a given
> > radix tree entry. For a 2MiB entry, for example, all I/O to that 2MiB range
> > would be serialized.
> 
> Note that invalidate_inode_pages2_range() will see the entry created by
> grab_mapping_entry() on CPU2 and block waiting for its lock and this is
> exactly what stops the race. The invalidate_inode_pages2_range()
> effectively makes sure there isn't any page fault in progress for given
> range...

Yep, this is the bit that I was missing.  Thanks.

> Also note that writes to a file are serialized by i_rwsem anyway (and at
> least serialization of writes to the overlapping range is required by POSIX)
> so this doesn't add any more serialization than we already have.
> 
> > > Another solution would be to grab i_mmap_sem for write when doing write
> > > fault of a page and similarly have it grabbed for writing when doing
> > > write(2). This would scale rather poorly but if we later replaced it with a
> > > range lock (Davidlohr has already posted a nice implementation of it) it
> > > won't be as bad. But I guess option 1) is better...
> > 
> > The best idea I had for handling this sounds similar, which would be to
> > convert the radix tree locks to essentially be reader/writer locks.  I/O and
> > faults that don't modify the block mapping could just take read-level locks,
> > and could all run concurrently.  I/O or faults that modify a block mapping
> > would take a write lock, and serialize with other writers and readers.
> 
> Well, this would be difficult to implement inside the radix tree (not
> enough bits in the entry) so you'd have to go for some external locking
> primitive anyway. And if you do that, read-write range lock Davidlohr has
> implemented is what you describe - well we could also have a radix tree
> with rwsems but I suspect the overhead of maintaining that would be too
> large. It would require larger rewrite than reusing entry locks as I
> suggest above though and it isn't an obvious performance win for realistic
> workloads either so I'd like to see some performance numbers before going
> that way. It likely improves a situation where processes race to fault the
> same page for which we already know the block mapping but I'm not sure if
> that translates to any measurable performance wins for workloads on DAX
> filesystem.
> 
> > You could know if you needed a write lock without asking the filesystem - if
> > you're a write and the radix tree entry is empty or is for a zero page, you
> > grab the write lock.
> > 
> > This dovetails nicely with the idea of having the radix tree act as a cache
> > for block mappings.  You take the appropriate lock on the radix tree entry,
> > and it has the block mapping info for your I/O or fault so you don't have to
> > call into the FS.  I/O would also participate so we would keep info about
> > block mappings that we gather from I/O to help shortcut our page faults.
> > 
> > How does this sound vs the range lock idea?  How hard do you think it would be
> > to convert our current wait queue system to reader/writer style locking?
> > 
> > Also, how do you think we should deal with the current PMD corruption?  Should
> > we go with the current fix (I can augment the comments as you suggested), and
> > then handle optimizations to that approach and the solution to this larger
> > race as a follow-on?
> 
> So for now I'm still more inclined to just stay with the radix tree lock as
> is and just fix up the locking as I suggest and go for larger rewrite only
> if we can demonstrate further performance wins.

Sounds good.

> WRT your second patch, if we go with the locking as I suggest, it is enough
> to unmap the whole range after invalidate_inode_pages2() has cleared radix
> tree entries (*) which will be much cheaper (for large writes) than doing
> unmapping entry by entry.

I'm still not convinced that it is safe to do the unmap in a separate step.  I
see your point about it being expensive to do a rmap walk to unmap each entry
in __dax_invalidate_mapping_entry(), but I think we might need to because the
unmap is part of the contract imposed by invalidate_inode_pages2_range() and
invalidate_inode_pages2().  This exists in the header comment above each:

 * Any pages which are found to be mapped into pagetables are unmapped prior
 * to invalidation.

If you look at the usage of invalidate_inode_pages2_range() in
generic_file_direct_write() for example (which I realize we won't call for a
DAX inode, but still), I think that it really does rely on the fact that
invalidated pages are unmapped, right?  If it didn't, and hole pages were
mapped, the hole pages could remain mapped while a direct I/O write allocated
blocks and then wrote real data.

If we really want to unmap the entire range at once, maybe it would have to be
done in invalidate_inode_pages2_range(), after the loop?  My hesitation about
this is that we'd be leaking yet more DAX special casing up into the
mm/truncate.c code.

Or am I missing something?

> So I'd go for that. I'll prepare a patch for the
> locking change - it will require changes to ext4 transaction handling so it
> won't be completely trivial.
> 
> (*) The flow of information is: filesystem block mapping info -> radix tree
> -> page tables so if 'filesystem block mapping info' changes, we should go
> invalidate corresponding radix tree entries (new entries will already have
> uptodate info) and then invalidate corresponding page tables (again once
> radix tree has no stale entries, we are sure new page table entries will be
> uptodate).
> 
> 								Honza
> -- 
> Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
> SUSE Labs, CR
