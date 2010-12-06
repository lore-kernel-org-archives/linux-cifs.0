From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: remove bogus remapping of error in cifs_filldir()
Date: Mon, 6 Dec 2010 09:47:38 -0500
Message-ID: <20101206094738.4a9402b2@tlielax.poochiereds.net>
References: <1291623350-11347-1-git-send-email-sjayaraman@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1291623350-11347-1-git-send-email-sjayaraman-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon,  6 Dec 2010 13:45:50 +0530
Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:

> As the FIXME points out correctly, now filldir() itself returns -EOVERFLOW if
> it not possible to represent the inode number supplied by the filesystem in
> the field provided by userspace.
> 
> Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
> ---
>  fs/cifs/readdir.c |   12 ------------
>  1 files changed, 0 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
> index 32d300e..a73eb9f 100644
> --- a/fs/cifs/readdir.c
> +++ b/fs/cifs/readdir.c
> @@ -759,18 +759,6 @@ static int cifs_filldir(char *pfindEntry, struct file *file, filldir_t filldir,
>  	rc = filldir(direntry, qstring.name, qstring.len, file->f_pos,
>  		     ino, fattr.cf_dtype);
>  
> -	/*
> -	 * we can not return filldir errors to the caller since they are
> -	 * "normal" when the stat blocksize is too small - we return remapped
> -	 * error instead
> -	 *
> -	 * FIXME: This looks bogus. filldir returns -EOVERFLOW in the above
> -	 * case already. Why should we be clobbering other errors from it?
> -	 */
> -	if (rc) {
> -		cFYI(1, "filldir rc = %d", rc);
> -		rc = -EOVERFLOW;
> -	}
>  	dput(tmp_dentry);
>  	return rc;
>  }


I meant to do that a while ago...

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
