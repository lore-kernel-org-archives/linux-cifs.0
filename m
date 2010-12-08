From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 5/6] CIFS: Make cifs_file_map work with strict cache
 mode (try #3)
Date: Wed, 8 Dec 2010 15:59:57 -0500
Message-ID: <20101208155957.486451a4@tlielax.poochiereds.net>
References: <1291037804-4000-1-git-send-email-piastryyy@gmail.com>
	<1291037804-4000-4-git-send-email-piastryyy@gmail.com>
	<20101207075635.6f9c1c5f@tlielax.poochiereds.net>
	<AANLkTineJVVgK6aihGBLWJfEnEOuz67CcHncwBUpdvt0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTineJVVgK6aihGBLWJfEnEOuz67CcHncwBUpdvt0-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 8 Dec 2010 23:53:12 +0300
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> 2010/12/7 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> > Looks reasonable, though all of this special-casing sure is gross...
> >
> > Might it be better to have a set of cifs_strict_file/inode_ops and use
> > those rather than all of these if/else conditions?
> >
> 
> Good idea. So, do you mean to split all these aio_read, aio_write,
> fsync and mmap into strict and non-strict calls as we have in direct
> i/o case?
> 

Right. Once a mount is declared "strictcache" it won't ever change, so
you might as well set the ops appropriately.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
