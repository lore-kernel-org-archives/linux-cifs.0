From: Chris Mason <chris.mason-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: stable page writes: wait_on_page_writeback and packet signing
Date: Fri, 11 Mar 2011 07:56:14 -0500
Message-ID: <1299847396-sup-9741@think>
References: <AANLkTinFx9KGKDWSdUvFSvT4S6f9QjBzX=6Uo17oO89+@mail.gmail.com> <20110309215148.GW15097@dastard> <1299707686-sup-6871@think> <AANLkTikK8MOm-m9XsOA4YGRe=E9bJTDh4iEYXtZumNmv@mail.gmail.com> <1299717690-sup-2613@think> <20110310081638.0f8275d4@barsoom.rdu.redhat.com> <1299763214-sup-2862@think> <20110310084724.658fe5d7@barsoom.rdu.redhat.com> <1299764956-sup-2267@think> <20110311071143.01b407b6@tlielax.poochiereds.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Mingming Cao <mcao-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <20110311071143.01b407b6-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Excerpts from Jeff Layton's message of 2011-03-11 07:11:43 -0500:
> On Thu, 10 Mar 2011 08:58:04 -0500
> Chris Mason <chris.mason-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> 
> > 
> > I think you'll need the page lock too, otherwise you aren't protected
> > against new IO starting.  page_mkwrite really works together with 
> > clear_page_dirty_for_io(), and I don't think you get proper
> > synchronization without the page lock.
> > 
> 
> I'm trying to work this out in my head and I'm having a hard time...
> 
> If we fix cifs_writepages to set_page_writeback before calling
> clear_page_dirty_for_io, then do we really need the page lock here?

clear_page_dirty_for_io is called by write_cache_pages before setting
the page writeback.  This way we avoid transient setting of page
writeback when it wasn't really dirty.  It doesn't mean it won't work
the other way around, but PageWriteback usually means 'I'm being
written' not 'Maybe I'm being written'.

> 
> > You also need the page lock to make sure the page really is still in
> > your mapping and that truncate won't race in and take the page away.
> > 
> 
> This I'm a little less clear on. Why is this a concern only for
> read-only pages and not for writable ones which won't pass through
> page_mkwrite?

We want to make sure that we're not racing with truncate.   For us that
means we don't want to insert blocks to fill a hole in the middle of
truncate doing away with that range in the file.

This may or may not be a concern for cifs, but truncate is going to lock
every page, so we need the page lock to really synchronize with it.

> 
> The reason I'm reluctant to take the page lock here is that I've been
> toying with the idea of having page_mkwrite copy the page to a new one
> when it's under writeback. Basically, have page_mkwrite:
> 
> 1) allocate a new page (if that fails, just wait_on_page_writeback)
> 2) copy the old page data to the new one
> 3) replace the old page in the pagecache with the new one
> 4) shoot down any PTE's that point to the old page (via unmap_mapping_range)
> 5) return an error from page_mkwrite that tells the caller that the page
>    needs to be refaulted in
> 
> I think that would allow us to have stable pages for the actual write,
> but without blocking processes that have the pages mmapped for an
> arbitrary period. If I have to take the page lock however, then that
> sort of blows that whole idea out of the water.
> 
> I haven't worked through all of the details for this (and I'm sure
> handling the locking for this will be tricky). Maybe it's a dumb
> idea, but I think it's worth investigating.
> 

Would it be easier to send a bounce buffer over the wire instead of
the page cache page?

In general we haven't seen a big performance problem from waiting on
writeback and locking the page in page_mkwrite().  Writable mmaps and
high performance expectations don't often go together.

-chris
