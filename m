From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/6] CIFS: Make write call work with strict cache mode
Date: Wed, 10 Nov 2010 08:30:25 -0500
Message-ID: <20101110083025.20b68e7b@tlielax.poochiereds.net>
References: <1288945777-9197-1-git-send-email-piastryyy@gmail.com>
	<1288945777-9197-4-git-send-email-piastryyy@gmail.com>
	<20101109131001.56a40c86@corrin.poochiereds.net>
	<AANLkTik-0k-p_XeWjd79-Popa57g-BFcLtB-XY55mktw@mail.gmail.com>
	<20101110070420.74daca64@tlielax.poochiereds.net>
	<AANLkTikCh+UgGRwdXqTjrZXEonb+J-c=NpxQ-Ph16Emt@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikCh+UgGRwdXqTjrZXEonb+J-c=NpxQ-Ph16Emt-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 10 Nov 2010 16:15:33 +0300
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> 2010/11/10 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> >
> > Hmm...setting the dirty bit before the data has actually been copied to
> > the page? I'm not sure that's a good idea. If you want to do that you
> > may want to run it by linux-fsdevel first.
> >
> > Maybe you could do something instead with the fsdata pointer in
> > write_begin and write_end?
> >
> 
> Jeff, what's about simply invalidating inode range if we don't have
> exlusive oplock after cifs_user_write? I don't think that there is a
> chance to write a data to the server and keep oplock level II in the
> same time - so no need for storing the data in the cache at all. And
> if we don't store it in the cache we don't need to modify
> cifs_write_end - no races.
> 
> so, I mean the following:
> 
> +       if (CIFS_I(inode)->clientCanCacheAll)
> +               return generic_file_aio_write(iocb, iov, nr_segs, pos);
> +
> +       cifs_sb = CIFS_SB(iocb->ki_filp->f_path.dentry->d_sb);
> +
> +       if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO) == 0) {
> +               int rc;
> +
> +               written = generic_file_aio_write(iocb, iov, nr_segs, pos);
> +
> +               rc = filemap_fdatawrite(inode->i_mapping);
> +               if (rc)
> +                       cFYI(1, "cifs_file_aio_write: %d rc on %p inode",
> +                            rc, inode);
> +               return written;
> +       }
> +
> +       written = cifs_user_write(iocb->ki_filp, iov->iov_base,
> +                                 iov->iov_len, &pos);
> +
> +       if (written > 0)
> +               invalidate_mapping_pages(inode->i_mapping,
> +                                             (pos-written) >> PAGE_CACHE_SHIFT,
> +                                             (pos-1) >> PAGE_CACHE_SHIFT);
> +       iocb->ki_pos = pos;
> 

That might work, and it gets around the ugly double write thing that
the earlier patches did.

You're probably right that most servers won't allow you to keep a
level II oplock and write to the file. If one does, then the pages will
have to be refaulted in, of course which will suck for performance, but
I'm not terribly concerned about that.

Also, please take some time and sprinkle some comments in there too. In
a year or two we'll be struggling to recall this conversation to figure
out why it was done this way...

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
