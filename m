From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 8/8] cifs: convert cifs_iovec_write to use async
 writes
Date: Fri, 23 Mar 2012 17:01:40 -0400
Message-ID: <20120323170140.3cdd927f@tlielax.poochiereds.net>
References: <1328279581-21889-1-git-send-email-jlayton@redhat.com>
	<1328279581-21889-9-git-send-email-jlayton@redhat.com>
	<CAKywueT3Cmw4ffuE1wvMzxZniWyUUCU=8rtrB4Eu7Zz3FMtecQ@mail.gmail.com>
	<20120221065455.4f4b3ec5@tlielax.poochiereds.net>
	<CAKywueRRCSttySt0AbkoANBYVgz=p-p+FbMEx9EfcdLP+v4OcQ@mail.gmail.com>
	<CAH2r5mvkMV7O8L+1yLg4v69YVSh8+xnvNHBK1_zm8EKAZA-MPQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mvkMV7O8L+1yLg4v69YVSh8+xnvNHBK1_zm8EKAZA-MPQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 23 Mar 2012 15:55:14 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Jeff,
> We should cleanup compile warning - was planning to add a tiny patch
> to fix if no objection.
> 
> Look correct?
> 
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index daaaca8..460d87b 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -2114,7 +2114,7 @@ cifs_uncached_marshal_iov(struct kvec *iov,
> struct cifs_writedata *wdata)
> 
>         /* marshal up the pages into iov array */
>         for (i = 0; i < wdata->nr_pages; i++) {
> -               iov[i + 1].iov_len = min(bytes, PAGE_SIZE);
> +               iov[i + 1].iov_len = min_t(size_t, bytes, PAGE_SIZE);
>                 iov[i + 1].iov_base = kmap(wdata->pages[i]);
>                 bytes -= iov[i + 1].iov_len;
>         }
> 

That patch looks harmless, but I don't seem to be able to reproduce any
warnings. Can you elaborate on how you're getting a warning from that?

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
