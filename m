From: Chris Mason <chris.mason-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: stable page writes: wait_on_page_writeback and packet signing
Date: Fri, 11 Mar 2011 11:00:39 -0500
Message-ID: <1299858514-sup-4213@think>
References: <AANLkTinFx9KGKDWSdUvFSvT4S6f9QjBzX=6Uo17oO89+@mail.gmail.com> <20110309215148.GW15097@dastard> <1299707686-sup-6871@think> <AANLkTikK8MOm-m9XsOA4YGRe=E9bJTDh4iEYXtZumNmv@mail.gmail.com> <1299717690-sup-2613@think> <20110310081638.0f8275d4@barsoom.rdu.redhat.com> <1299763214-sup-2862@think> <20110310084724.658fe5d7@barsoom.rdu.redhat.com> <1299764956-sup-2267@think> <20110311071143.01b407b6@tlielax.poochiereds.net> <1299847396-sup-9741@think> <20110311084221.4ac6bd11@tlielax.poochiereds.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Mingming Cao <mcao-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <20110311084221.4ac6bd11-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Excerpts from Jeff Layton's message of 2011-03-11 08:42:21 -0500:
> On Fri, 11 Mar 2011 07:56:14 -0500
> > > This I'm a little less clear on. Why is this a concern only for
> > > read-only pages and not for writable ones which won't pass through
> > > page_mkwrite?
> > 
> > We want to make sure that we're not racing with truncate.   For us that
> > means we don't want to insert blocks to fill a hole in the middle of
> > truncate doing away with that range in the file.
> > 
> > This may or may not be a concern for cifs, but truncate is going to lock
> > every page, so we need the page lock to really synchronize with it.
> > 
> 
> Hmm...ok. I'll need to ponder this a bit more, but the comment above
> btrfs_page_mkwrite makes this a bit more clear. Still, it seems like
> page_mkwrite ought to not have to worry about this. IOW...
> 
> Why doesn't the page fault handler fix that up? And why is this not an
> issue for filesystems that don't even implement page_mkwrite?

The page fault handler can deal with pages being dirty or clean or
inside or outside of i_size.  But the filesystem is using page_mkwrite
to allocate blocks in the file if the write is filling a hole, or in the
btrfs case to satisfy COW.

So the allocation code needs to synchronize with truncate while the page
handling code itself is already safe.

> 
> > > 
> > > The reason I'm reluctant to take the page lock here is that I've been
> > > toying with the idea of having page_mkwrite copy the page to a new one
> > > when it's under writeback. Basically, have page_mkwrite:
> > > 
> > > 1) allocate a new page (if that fails, just wait_on_page_writeback)
> > > 2) copy the old page data to the new one
> > > 3) replace the old page in the pagecache with the new one
> > > 4) shoot down any PTE's that point to the old page (via unmap_mapping_range)
> > > 5) return an error from page_mkwrite that tells the caller that the page
> > >    needs to be refaulted in
> > > 
> > > I think that would allow us to have stable pages for the actual write,
> > > but without blocking processes that have the pages mmapped for an
> > > arbitrary period. If I have to take the page lock however, then that
> > > sort of blows that whole idea out of the water.
> > > 
> > > I haven't worked through all of the details for this (and I'm sure
> > > handling the locking for this will be tricky). Maybe it's a dumb
> > > idea, but I think it's worth investigating.
> > > 
> > 
> > Would it be easier to send a bounce buffer over the wire instead of
> > the page cache page?
> > 
> > In general we haven't seen a big performance problem from waiting on
> > writeback and locking the page in page_mkwrite().  Writable mmaps and
> > high performance expectations don't often go together.
> > 
> 
> That would definitely be easier. I'm just always a bit leery of doing
> any sort of memory allocation while in writeback. The scheme I
> described would only do them when someone writes to a mmapped page, and
> it can just fall back to blocking if that fails.
> 
> My main worry is not so much with performance, but rather with making
> sure that we're not blocking processes that are trying to write to
> mmaps indefinitely if the server goes away. Blocking them only until
> kernel_sendmsg returns makes this a bit less of an issue, but it can
> still happen if the socket buffer is full.

Don't we already have the risk of blocking in them in
balance_dirty_pages for file_write?  I'm not sure how mmap is different.
At any rate, an interruptible wait_on_page_writeback(), or
wait_on_page_writeback_timeout() might be easier?

> 
> In principle, the above scheme would mostly avoid unnecessary memory
> allocations, and should mostly prevent mmapped processes from
> blocking indefinitely. It is rather complicated though, which might
> make it too "fiddly" to really be workable.
> 

In general I'd try to avoid being special in mmap writes.  It's one of
those things that doesn't get exercised that much in the common test
suites, and so you'll have mysterious bug reports that very few people
see.

(Don't let my grumpiness with mmap stop you from doing cool things
though ;)

-chris
