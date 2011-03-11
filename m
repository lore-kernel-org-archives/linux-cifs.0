From: Jeff Layton <jlayton@redhat.com>
Subject: Re: stable page writes: wait_on_page_writeback and packet signing
Date: Fri, 11 Mar 2011 08:42:21 -0500
Message-ID: <20110311084221.4ac6bd11@tlielax.poochiereds.net>
References: <AANLkTinFx9KGKDWSdUvFSvT4S6f9QjBzX=6Uo17oO89+@mail.gmail.com>
	<20110309215148.GW15097@dastard>
	<1299707686-sup-6871@think>
	<AANLkTikK8MOm-m9XsOA4YGRe=E9bJTDh4iEYXtZumNmv@mail.gmail.com>
	<1299717690-sup-2613@think>
	<20110310081638.0f8275d4@barsoom.rdu.redhat.com>
	<1299763214-sup-2862@think>
	<20110310084724.658fe5d7@barsoom.rdu.redhat.com>
	<1299764956-sup-2267@think>
	<20110311071143.01b407b6@tlielax.poochiereds.net>
	<1299847396-sup-9741@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench@gmail.com>,
	Dave Chinner <david@fromorbit.com>,
	linux-cifs <linux-cifs@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Mingming Cao <mcao@us.ibm.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1299847396-sup-9741@think>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Fri, 11 Mar 2011 07:56:14 -0500
Chris Mason <chris.mason@oracle.com> wrote:

> Excerpts from Jeff Layton's message of 2011-03-11 07:11:43 -0500:
> > On Thu, 10 Mar 2011 08:58:04 -0500
> > Chris Mason <chris.mason@oracle.com> wrote:
> > 
> > > 
> > > I think you'll need the page lock too, otherwise you aren't protected
> > > against new IO starting.  page_mkwrite really works together with 
> > > clear_page_dirty_for_io(), and I don't think you get proper
> > > synchronization without the page lock.
> > > 
> > 
> > I'm trying to work this out in my head and I'm having a hard time...
> > 
> > If we fix cifs_writepages to set_page_writeback before calling
> > clear_page_dirty_for_io, then do we really need the page lock here?
> 
> clear_page_dirty_for_io is called by write_cache_pages before setting
> the page writeback.  This way we avoid transient setting of page
> writeback when it wasn't really dirty.  It doesn't mean it won't work
> the other way around, but PageWriteback usually means 'I'm being
> written' not 'Maybe I'm being written'.
> 

Ok that makes sense. cifs does it the same way currently.

> > 
> > > You also need the page lock to make sure the page really is still in
> > > your mapping and that truncate won't race in and take the page away.
> > > 
> > 
> > This I'm a little less clear on. Why is this a concern only for
> > read-only pages and not for writable ones which won't pass through
> > page_mkwrite?
> 
> We want to make sure that we're not racing with truncate.   For us that
> means we don't want to insert blocks to fill a hole in the middle of
> truncate doing away with that range in the file.
> 
> This may or may not be a concern for cifs, but truncate is going to lock
> every page, so we need the page lock to really synchronize with it.
> 

Hmm...ok. I'll need to ponder this a bit more, but the comment above
btrfs_page_mkwrite makes this a bit more clear. Still, it seems like
page_mkwrite ought to not have to worry about this. IOW...

Why doesn't the page fault handler fix that up? And why is this not an
issue for filesystems that don't even implement page_mkwrite?

> > 
> > The reason I'm reluctant to take the page lock here is that I've been
> > toying with the idea of having page_mkwrite copy the page to a new one
> > when it's under writeback. Basically, have page_mkwrite:
> > 
> > 1) allocate a new page (if that fails, just wait_on_page_writeback)
> > 2) copy the old page data to the new one
> > 3) replace the old page in the pagecache with the new one
> > 4) shoot down any PTE's that point to the old page (via unmap_mapping_range)
> > 5) return an error from page_mkwrite that tells the caller that the page
> >    needs to be refaulted in
> > 
> > I think that would allow us to have stable pages for the actual write,
> > but without blocking processes that have the pages mmapped for an
> > arbitrary period. If I have to take the page lock however, then that
> > sort of blows that whole idea out of the water.
> > 
> > I haven't worked through all of the details for this (and I'm sure
> > handling the locking for this will be tricky). Maybe it's a dumb
> > idea, but I think it's worth investigating.
> > 
> 
> Would it be easier to send a bounce buffer over the wire instead of
> the page cache page?
> 
> In general we haven't seen a big performance problem from waiting on
> writeback and locking the page in page_mkwrite().  Writable mmaps and
> high performance expectations don't often go together.
> 

That would definitely be easier. I'm just always a bit leery of doing
any sort of memory allocation while in writeback. The scheme I
described would only do them when someone writes to a mmapped page, and
it can just fall back to blocking if that fails.

My main worry is not so much with performance, but rather with making
sure that we're not blocking processes that are trying to write to
mmaps indefinitely if the server goes away. Blocking them only until
kernel_sendmsg returns makes this a bit less of an issue, but it can
still happen if the socket buffer is full.

In principle, the above scheme would mostly avoid unnecessary memory
allocations, and should mostly prevent mmapped processes from
blocking indefinitely. It is rather complicated though, which might
make it too "fiddly" to really be workable.

-- 
Jeff Layton <jlayton@redhat.com>
