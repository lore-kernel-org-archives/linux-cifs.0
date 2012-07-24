From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 09/11] cifs: convert async write code to pass in data
 via rq_pages array
Date: Tue, 24 Jul 2012 06:19:25 -0400
Message-ID: <20120724061925.21c5710d@corrin.poochiereds.net>
References: <1342634346-22818-1-git-send-email-jlayton@redhat.com>
	<1342634346-22818-10-git-send-email-jlayton@redhat.com>
	<CAKywueTO3OCTV8M4Lo1kSpfZjyHDPDxRZthE-URkr=5=ow-Z2g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueTO3OCTV8M4Lo1kSpfZjyHDPDxRZthE-URkr=5=ow-Z2g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 24 Jul 2012 13:44:44 +0400
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> 2012/7/18 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> > Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> >  fs/cifs/cifsproto.h |    4 ++--
> >  fs/cifs/cifssmb.c   |   33 ++++++++++-----------------------
> >  fs/cifs/file.c      |   47 +++++++++--------------------------------------
> >  3 files changed, 21 insertions(+), 63 deletions(-)
> >
> > diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> > index dbb9c61..64a4297 100644
> > --- a/fs/cifs/cifsproto.h
> > +++ b/fs/cifs/cifsproto.h
> > @@ -515,8 +515,8 @@ struct cifs_writedata {
> >         pid_t                           pid;
> >         unsigned int                    bytes;
> >         int                             result;
> > -       void (*marshal_iov) (struct kvec *iov,
> > -                            struct cifs_writedata *wdata);
> > +       unsigned int                    pagesz;
> > +       unsigned int                    tailsz;
> >         unsigned int                    nr_pages;
> >         struct page                     *pages[1];
> >  };
> > diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> > index 727f35e..cb7de86 100644
> > --- a/fs/cifs/cifssmb.c
> > +++ b/fs/cifs/cifssmb.c
> > @@ -2052,7 +2052,7 @@ cifs_async_writev(struct cifs_writedata *wdata)
> >         WRITE_REQ *smb = NULL;
> >         int wct;
> >         struct cifs_tcon *tcon = tlink_tcon(wdata->cfile->tlink);
> > -       struct kvec *iov = NULL;
> > +       struct kvec iov;
> >         struct smb_rqst rqst = { };
> >
> >         if (tcon->ses->capabilities & CAP_LARGE_FILES) {
> > @@ -2069,15 +2069,6 @@ cifs_async_writev(struct cifs_writedata *wdata)
> >         if (rc)
> >                 goto async_writev_out;
> >
> > -       /* 1 iov per page + 1 for header */
> > -       rqst.rq_nvec = wdata->nr_pages + 1;
> > -       iov = kzalloc((rqst.rq_nvec) * sizeof(*iov), GFP_NOFS);
> > -       if (iov == NULL) {
> > -               rc = -ENOMEM;
> > -               goto async_writev_out;
> > -       }
> > -       rqst.rq_iov = iov;
> > -
> >         smb->hdr.Pid = cpu_to_le16((__u16)wdata->pid);
> >         smb->hdr.PidHigh = cpu_to_le16((__u16)(wdata->pid >> 16));
> >
> > @@ -2094,18 +2085,15 @@ cifs_async_writev(struct cifs_writedata *wdata)
> >             cpu_to_le16(offsetof(struct smb_com_write_req, Data) - 4);
> >
> >         /* 4 for RFC1001 length + 1 for BCC */
> > -       iov[0].iov_len = be32_to_cpu(smb->hdr.smb_buf_length) + 4 + 1;
> > -       iov[0].iov_base = smb;
> > +       iov.iov_len = be32_to_cpu(smb->hdr.smb_buf_length) + 4 + 1;
> > +       iov.iov_base = smb;
> >
> > -       /*
> > -        * This function should marshal up the page array into the kvec
> > -        * array, reserving [0] for the header. It should kmap the pages
> > -        * and set the iov_len properly for each one. It may also set
> > -        * wdata->bytes too.
> > -        */
> > -       cifs_kmap_lock();
> > -       wdata->marshal_iov(iov, wdata);
> > -       cifs_kmap_unlock();
> > +       rqst.rq_iov = &iov;
> > +       rqst.rq_nvec = 1;
> > +       rqst.rq_pages = wdata->pages;
> > +       rqst.rq_npages = wdata->nr_pages;
> > +       rqst.rq_pagesz = wdata->pagesz;
> > +       rqst.rq_tailsz = wdata->tailsz;
> 
> Now we are not kmapping here but still kunmaping below:
> 
> 2105 >-------/* send is done, unmap pages */
> 2106 >-------for (i = 0; i < wdata->nr_pages; i++)
> 2107 >------->-------kunmap(wdata->pages[i]);
> 
> Is it ok? (seems like we've already kunmap'ed them in smb_send_rqst)
> 

Well spotted.

No that's not OK. We'll end up putting too many refs to it. I'll fix
and respin.

> >
> >         cFYI(1, "async write at %llu %u bytes", wdata->offset, wdata->bytes);
> >
> > @@ -2121,7 +2109,7 @@ cifs_async_writev(struct cifs_writedata *wdata)
> >                                 (struct smb_com_writex_req *)smb;
> >                 inc_rfc1001_len(&smbw->hdr, wdata->bytes + 5);
> >                 put_bcc(wdata->bytes + 5, &smbw->hdr);
> > -               iov[0].iov_len += 4; /* pad bigger by four bytes */
> > +               iov.iov_len += 4; /* pad bigger by four bytes */
> >         }
> >
> >         kref_get(&wdata->refcount);
> > @@ -2139,7 +2127,6 @@ cifs_async_writev(struct cifs_writedata *wdata)
> >
> >  async_writev_out:
> >         cifs_small_buf_release(smb);
> > -       kfree(iov);
> >         return rc;
> >  }
> >
> > diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> > index dd28caa..d5f8c60 100644
> > --- a/fs/cifs/file.c
> > +++ b/fs/cifs/file.c
> > @@ -1710,27 +1710,6 @@ static int cifs_partialpagewrite(struct page *page, unsigned from, unsigned to)
> >         return rc;
> >  }
> >
> > -/*
> > - * Marshal up the iov array, reserving the first one for the header. Also,
> > - * set wdata->bytes.
> > - */
> > -static void
> > -cifs_writepages_marshal_iov(struct kvec *iov, struct cifs_writedata *wdata)
> > -{
> > -       int i;
> > -       struct inode *inode = wdata->cfile->dentry->d_inode;
> > -       loff_t size = i_size_read(inode);
> > -
> > -       /* marshal up the pages into iov array */
> > -       wdata->bytes = 0;
> > -       for (i = 0; i < wdata->nr_pages; i++) {
> > -               iov[i + 1].iov_len = min(size - page_offset(wdata->pages[i]),
> > -                                       (loff_t)PAGE_CACHE_SIZE);
> > -               iov[i + 1].iov_base = kmap(wdata->pages[i]);
> > -               wdata->bytes += iov[i + 1].iov_len;
> > -       }
> > -}
> > -
> >  static int cifs_writepages(struct address_space *mapping,
> >                            struct writeback_control *wbc)
> >  {
> > @@ -1740,6 +1719,7 @@ static int cifs_writepages(struct address_space *mapping,
> >         struct cifs_writedata *wdata;
> >         struct page *page;
> >         int rc = 0;
> > +       loff_t isize = i_size_read(mapping->host);
> >
> >         /*
> >          * If wsize is smaller than the page cache size, default to writing
> > @@ -1844,7 +1824,7 @@ retry:
> >                          */
> >                         set_page_writeback(page);
> >
> > -                       if (page_offset(page) >= mapping->host->i_size) {
> > +                       if (page_offset(page) >= isize) {
> >                                 done = true;
> >                                 unlock_page(page);
> >                                 end_page_writeback(page);
> > @@ -1875,7 +1855,11 @@ retry:
> >                 wdata->sync_mode = wbc->sync_mode;
> >                 wdata->nr_pages = nr_pages;
> >                 wdata->offset = page_offset(wdata->pages[0]);
> > -               wdata->marshal_iov = cifs_writepages_marshal_iov;
> > +               wdata->pagesz = PAGE_CACHE_SIZE;
> > +               wdata->tailsz = min(isize - page_offset(wdata->pages[nr_pages - 1]),
> > +                                       (loff_t)PAGE_CACHE_SIZE);
> > +               wdata->bytes = ((nr_pages - 1) * PAGE_CACHE_SIZE) +
> > +                                       wdata->tailsz;
> >
> >                 do {
> >                         if (wdata->cfile != NULL)
> > @@ -2164,20 +2148,6 @@ size_t get_numpages(const size_t wsize, const size_t len, size_t *cur_len)
> >  }
> >
> >  static void
> > -cifs_uncached_marshal_iov(struct kvec *iov, struct cifs_writedata *wdata)
> > -{
> > -       int i;
> > -       size_t bytes = wdata->bytes;
> > -
> > -       /* marshal up the pages into iov array */
> > -       for (i = 0; i < wdata->nr_pages; i++) {
> > -               iov[i + 1].iov_len = min_t(size_t, bytes, PAGE_SIZE);
> > -               iov[i + 1].iov_base = kmap(wdata->pages[i]);
> > -               bytes -= iov[i + 1].iov_len;
> > -       }
> > -}
> > -
> > -static void
> >  cifs_uncached_writev_complete(struct work_struct *work)
> >  {
> >         int i;
> > @@ -2290,7 +2260,8 @@ cifs_iovec_write(struct file *file, const struct iovec *iov,
> >                 wdata->cfile = cifsFileInfo_get(open_file);
> >                 wdata->pid = pid;
> >                 wdata->bytes = cur_len;
> > -               wdata->marshal_iov = cifs_uncached_marshal_iov;
> > +               wdata->pagesz = PAGE_SIZE;
> > +               wdata->tailsz = cur_len - ((nr_pages - 1) * PAGE_SIZE);
> >                 rc = cifs_uncached_retry_writev(wdata);
> >                 if (rc) {
> >                         kref_put(&wdata->refcount, cifs_writedata_release);
> > --
> > 1.7.10.4
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 


-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
