From: Dave Chinner <david@fromorbit.com>
Subject: Re: stable page writes: wait_on_page_writeback and packet signing
Date: Thu, 10 Mar 2011 10:46:07 +1100
Message-ID: <20110309234607.GY15097@dastard>
References: <AANLkTinFx9KGKDWSdUvFSvT4S6f9QjBzX=6Uo17oO89+@mail.gmail.com>
 <20110309215148.GW15097@dastard>
 <1299707686-sup-6871@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Steve French <smfrench@gmail.com>,
	linux-cifs <linux-cifs@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Mingming Cao <mcao@us.ibm.com>,
	Jeff Layton <jlayton@redhat.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1299707686-sup-6871@think>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Wed, Mar 09, 2011 at 04:58:19PM -0500, Chris Mason wrote:
> Excerpts from Dave Chinner's message of 2011-03-09 16:51:48 -0500:
> > On Wed, Mar 09, 2011 at 01:44:24PM -0600, Steve French wrote:
> > > Have alternative approaches, other than using wait_on_page_writeback,
> > > been considered for solving the stable page write problem in similar
> > > cases (since only about 1 out of 5 linux file systems uses this call
> > > today).
> > 
> > I think that is incorrect. write_cache_pages() does:
> > 
> >  929                         lock_page(page);
> > .....
> >  950                         if (PageWriteback(page)) {
> >  951                                 if (wbc->sync_mode != WB_SYNC_NONE)
> >  952                                         wait_on_page_writeback(page);
> >  953                                 else
> >  954                                         goto continue_unlock;
> >  955                         }
> >  956
> >  957                         BUG_ON(PageWriteback(page));
> >  958                         if (!clear_page_dirty_for_io(page))
> >  959                                 goto continue_unlock;
> >  960
> >  961                         trace_wbc_writepage(wbc, mapping->backing_dev_info);
> >  962                         ret = (*writepage)(page, wbc, data);
> > 
> > so every filesystem using the generic_writepages code already does
> > this check and wait before .writepage is called. Hence only the
> > filesystems that do not use generic_writepages() or
> > mpage_writepages() need a specific check, and that means most
> > filesystems are actually waiting on writeback pages correctly.
> 
> But checking here just means we don't start writeback on a page that is
> writeback, which is a good idea but not really related to stable pages?

True - but the context of the original question was w.r.t.  use of
wait_on_page_writeback in .writepage[s], which was what I assumed
(based on a quick cscope lookup) that the "1 out of 5" was then
referring to....

> stable pages means we don't let mmap'd pages or file_write muck around
> with the pages while they are in writeback, so we need to wait in
> file_write and page_mkwrite.

.... as I think it's much fewer than "1 in 5 linux filesystems" that
actually implement these waits to ensure pages stay stable once
under writeback. i.e. only BTRFS does them, IIRC.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
