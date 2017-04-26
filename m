From: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 2/2] dax: fix data corruption due to stale mmap reads
Date: Wed, 26 Apr 2017 16:52:36 -0600
Message-ID: <20170426225236.GA25838@linux.intel.com>
References: <20170420191446.GA21694@linux.intel.com>
 <20170421034437.4359-1-ross.zwisler@linux.intel.com>
 <20170421034437.4359-2-ross.zwisler@linux.intel.com>
 <20170425111043.GH2793@quack2.suse.cz>
 <20170425225936.GA29655@linux.intel.com>
 <20170426085235.GA21738@quack2.suse.cz>
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
In-Reply-To: <20170426085235.GA21738-4I4JzKEfoa/jFM9bn6wA6Q@public.gmane.org>
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

On Wed, Apr 26, 2017 at 10:52:35AM +0200, Jan Kara wrote:
> On Tue 25-04-17 16:59:36, Ross Zwisler wrote:
> > On Tue, Apr 25, 2017 at 01:10:43PM +0200, Jan Kara wrote:
> > <>
> > > Hum, but now thinking more about it I have hard time figuring out why write
> > > vs fault cannot actually still race:
> > > 
> > > CPU1 - write(2)				CPU2 - read fault
> > > 
> > > 					dax_iomap_pte_fault()
> > > 					  ->iomap_begin() - sees hole
> > > dax_iomap_rw()
> > >   iomap_apply()
> > >     ->iomap_begin - allocates blocks
> > >     dax_iomap_actor()
> > >       invalidate_inode_pages2_range()
> > >         - there's nothing to invalidate
> > > 					  grab_mapping_entry()
> > > 					  - we add zero page in the radix
> > > 					    tree & map it to page tables
> > > 
> > > Similarly read vs write fault may end up racing in a wrong way and try to
> > > replace already existing exceptional entry with a hole page?
> > 
> > Yep, this race seems real to me, too.  This seems very much like the issues
> > that exist when a thread is doing direct I/O.  One thread is doing I/O to an
> > intermediate buffer (page cache for direct I/O case, zero page for us), and
> > the other is going around it directly to media, and they can get out of sync.
> > 
> > IIRC the direct I/O code looked something like:
> > 
> > 1/ invalidate existing mappings
> > 2/ do direct I/O to media
> > 3/ invalidate mappings again, just in case.  Should be cheap if there weren't
> >    any conflicting faults.  This makes sure any new allocations we made are
> >    faulted in.
> 
> Yeah, the problem is people generally expect weird behavior when they mix
> direct and buffered IO (or let alone mmap) however everyone expects
> standard read(2) and write(2) to be completely coherent with mmap(2).

Yep, fair enough.

> > I guess one option would be to replicate that logic in the DAX I/O path, or we
> > could try and enhance our locking so page faults can't race with I/O since
> > both can allocate blocks.
> 
> In the abstract way, the problem is that we have radix tree (and page
> tables) cache block mapping information and the operation: "read block
> mapping information, store it in the radix tree" is not serialized in any
> way against other block allocations so the information we store can be out
> of date by the time we store it.
> 
> One way to solve this would be to move ->iomap_begin call in the fault
> paths under entry lock although that would mean I have to redo how ext4
> handles DAX faults because with current code it would create lock inversion
> wrt transaction start.

I don't think this alone is enough to save us.  The I/O path doesn't currently
take any DAX radix tree entry locks, so our race would just become:

CPU1 - write(2)				CPU2 - read fault

					dax_iomap_pte_fault()
					  grab_mapping_entry() // newly moved
					  ->iomap_begin() - sees hole
dax_iomap_rw()
  iomap_apply()
    ->iomap_begin - allocates blocks
    dax_iomap_actor()
      invalidate_inode_pages2_range()
        - there's nothing to invalidate
					  - we add zero page in the radix
					    tree & map it to page tables

In their current form I don't think we want to take DAX radix tree entry locks
in the I/O path because that would effectively serialize I/O over a given
radix tree entry. For a 2MiB entry, for example, all I/O to that 2MiB range
would be serialized.

> Another solution would be to grab i_mmap_sem for write when doing write
> fault of a page and similarly have it grabbed for writing when doing
> write(2). This would scale rather poorly but if we later replaced it with a
> range lock (Davidlohr has already posted a nice implementation of it) it
> won't be as bad. But I guess option 1) is better...

The best idea I had for handling this sounds similar, which would be to
convert the radix tree locks to essentially be reader/writer locks.  I/O and
faults that don't modify the block mapping could just take read-level locks,
and could all run concurrently.  I/O or faults that modify a block mapping
would take a write lock, and serialize with other writers and readers.

You could know if you needed a write lock without asking the filesystem - if
you're a write and the radix tree entry is empty or is for a zero page, you
grab the write lock.

This dovetails nicely with the idea of having the radix tree act as a cache
for block mappings.  You take the appropriate lock on the radix tree entry,
and it has the block mapping info for your I/O or fault so you don't have to
call into the FS.  I/O would also participate so we would keep info about
block mappings that we gather from I/O to help shortcut our page faults.

How does this sound vs the range lock idea?  How hard do you think it would be
to convert our current wait queue system to reader/writer style locking?

Also, how do you think we should deal with the current PMD corruption?  Should
we go with the current fix (I can augment the comments as you suggested), and
then handle optimizations to that approach and the solution to this larger
race as a follow-on?
