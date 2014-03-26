From: Jeffrey Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [CIFS][PATCH] Return correct error code on query xattr when
 empty xattr list
Date: Wed, 26 Mar 2014 07:30:42 -0700
Message-ID: <20140326073042.0f045127@ipyr.poochiereds.net>
References: <CAH2r5msaxk6hGCL_HiQ+ZGK4L7Ryr=uKYyhwTfrz7CvtSgd7Pg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5msaxk6hGCL_HiQ+ZGK4L7Ryr=uKYyhwTfrz7CvtSgd7Pg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 25 Mar 2014 19:53:40 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> In working on getting xfstest working on cifs found the following
> problem.
> 
> From c6845613066b4544978de749cd5c73fb14ed936b Mon Sep 17 00:00:00 2001
> From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Date: Tue, 25 Mar 2014 19:46:36 -0500
> Subject: [PATCH] [CIFS] Return correct error on query of xattr on
> file with empty xattrs
> 
> xfstest 020 detected a problem with cifs xattr handling.  When a file
> had an empty xattr list, we returned success (with an empty xattr
> value) on query of particular xattrs rather than returning ENODATA.
> This patch fixes it so that query of an xattr returns ENODATA when the
> xattr list is empty for the file.
> 
> Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/cifssmb.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index f3264bd..6ce4e09 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -6197,6 +6197,9 @@ QAllEAsRetry:
>      cifs_dbg(FYI, "ea length %d\n", list_len);
>      if (list_len <= 8) {
>          cifs_dbg(FYI, "empty EA list returned from server\n");
> +        /* didn't find the named attribute */
> +        if (ea_name)
> +            rc = -ENODATA;
>          goto QAllEAsOut;
>      }
> 


Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
