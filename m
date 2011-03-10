From: Chris Mason <chris.mason-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: stable page writes: wait_on_page_writeback and packet signing
Date: Thu, 10 Mar 2011 08:58:04 -0500
Message-ID: <1299764956-sup-2267@think>
References: <AANLkTinFx9KGKDWSdUvFSvT4S6f9QjBzX=6Uo17oO89+@mail.gmail.com> <20110309215148.GW15097@dastard> <1299707686-sup-6871@think> <AANLkTikK8MOm-m9XsOA4YGRe=E9bJTDh4iEYXtZumNmv@mail.gmail.com> <1299717690-sup-2613@think> <20110310081638.0f8275d4@barsoom.rdu.redhat.com> <1299763214-sup-2862@think> <20110310084724.658fe5d7@barsoom.rdu.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Mingming Cao <mcao-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <20110310084724.658fe5d7-xSBYVWDuneFaJnirhKH9O4GKTjYczspe@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Excerpts from Jeff Layton's message of 2011-03-10 08:47:24 -0500:
> > > > Does cifs take i_mutex before writepage? The disk based filesystems
> > > > don't.  So, i_mutex protects file_write from other procs jumping into
> > > > file_write, but it doesn't protect writeback from file_write jumping in
> > > > and changing the pages while they are being sent to storage (or over the
> > > > wire).
> > > > 
> > > > Basically the model needs to be:
> > > > 
> > > > file_write:
> > > >     lock the page
> > > >     wait on page writeback
> > > > 
> > > >     < new writeback cannot start because of the page lock >
> > > >     copy_from_user
> > > >     unlock the page
> > > > 
> > > > We also use page_mkwrite to get notified when userland wants to change
> > > > some page it has given to mmap.  That needs to wait on page writeback as
> > > > well.
> > > > 
> > > 
> > > No, cifs doesn't take the i_mutex in writepage, but the page is locked.
> > > cifs_write_begin calls grab_cache_page_write_begin, which returns a
> > > locked page and it's not unlocked until cifs_write_end.
> > 
> > Ah ok, so you've got the page locked the whole time it is being sent
> > over the wire?  The disk based filesystems split it and drop the page
> > lock once the page is set writeback, which is why we need the extra
> > waits.
> > 
> > So in your case you should just need a page_mkwrite that locks the page.
> > 
> 
> Right, or do a wait_on_page_writeback. I think that may have a little
> less overhead since we won't need to unlock it and it may mean less
> serialization if there are other contenders for the page lock.
> 

I think you'll need the page lock too, otherwise you aren't protected
against new IO starting.  page_mkwrite really works together with 
clear_page_dirty_for_io(), and I don't think you get proper
synchronization without the page lock.

You also need the page lock to make sure the page really is still in
your mapping and that truncate won't race in and take the page away.

Basically, if you add a wait_on_page_writeback() to block_page_mkwrite,
you should have what you need, +/- the prepare_write/commit_write calls,
which we use to fill any holes for the pages that are about to change.

-chris
