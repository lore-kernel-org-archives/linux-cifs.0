From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: checkpatch warning on single statement do ... while
Date: Fri, 14 Sep 2012 13:13:14 -0400
Message-ID: <20120914131314.4bcf9cb2@corrin.poochiereds.net>
References: <CAH2r5mv2+m2+8+mYMo4qomGaOtpXs02TnToMH7PgCR4yrUaUeA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mv2+m2+8+mYMo4qomGaOtpXs02TnToMH7PgCR4yrUaUeA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 14 Sep 2012 10:51:04 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Any thoughts about this checkpatch warning? (We have the same kind of
> thing in cifssmb.c)
> 
> WARNING: Single statement macros should not use a do {} while (0) loop
> #65: FILE: fs/cifs/cifsglob.h:608:
> +#define cifs_kmap_lock() do { ; } while (0)
> 
> WARNING: Single statement macros should not use a do {} while (0) loop
> #66: FILE: fs/cifs/cifsglob.h:609:
> +#define cifs_kmap_unlock() do { ; } while (0)
> 
> total: 0 errors, 2 warnings, 307 lines checked
> 
> /home/stevef/3.7-patches/0019-CIFS-Add-SMB2-support-for-cifs_iovec_write.patch
> has style problems, please review.
> 
> 
> --
> Thanks,
> 
> Steve
> 
> 

I think it's not worth worrying about since a later patch removes those
macros altogether.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
