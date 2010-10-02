From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: handle FindFirst failure gracefully
Date: Fri, 1 Oct 2010 21:29:10 -0400
Message-ID: <20101001212910.44fe19d9@corrin.poochiereds.net>
References: <4CA603FD.6040308@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CA603FD.6040308-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 01 Oct 2010 21:23:33 +0530
Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:

> FindFirst failure due to permission errors or any other errors are silently
> ignored by cifs_readdir(). This could cause problem to applications that depend
> on the error to do further processing.
> 
> Reproducer:
>   - mount a cifs share
>   - mkdir tdir;touch tdir/1 tdir/2 tdir/3
>   - chmod -x tdir
>   - ls tdir
> 
> Currently, we start calling filldir() for '.' and '..' before we know we
> whether FindFirst could succeed or not. If FindFirst fails later, there is no
> way to notify VFS by setting buf.error and so VFS won't be able to catch this.
> Fix this by moving the call to initiate_cifs_search() before we start doing
> filldir().
> 
> This fixes https://bugzilla.samba.org/show_bug.cgi?id=7535
> 
> Reported-by: Tom Dexter <digitalaudiorock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
> ---
>  fs/cifs/readdir.c |   19 +++++++++++--------
>  1 files changed, 11 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
> index 887a7e2..edb69a9 100644
> --- a/fs/cifs/readdir.c
> +++ b/fs/cifs/readdir.c
> @@ -786,6 +786,17 @@ int cifs_readdir(struct file *file, void *direntry, filldir_t filldir)
>  
>  	cifs_sb = CIFS_SB(file->f_path.dentry->d_sb);
>  
> +	/*
> +	 * Ensure FindFirst doesn't fail before doing filldir() for '.' and
> +	 * '..'. Otherwise we won't be able to notify VFS in case of failure.
> +	 */
> +	if (file->private_data == NULL) {
> +		rc = initiate_cifs_search(xid, file);
> +		cFYI(1, "initiate cifs search rc %d", rc);
> +		if (rc)
> +			goto rddir2_exit;
> +	}
> +
>  	switch ((int) file->f_pos) {
>  	case 0:
>  		if (filldir(direntry, ".", 1, file->f_pos,
> @@ -810,14 +821,6 @@ int cifs_readdir(struct file *file, void *direntry, filldir_t filldir)
>  			if after then keep searching till find it */
>  
>  		if (file->private_data == NULL) {
> -			rc = initiate_cifs_search(xid, file);
> -			cFYI(1, "initiate cifs search rc %d", rc);
> -			if (rc) {
> -				FreeXid(xid);
> -				return rc;
> -			}
> -		}
> -		if (file->private_data == NULL) {
>  			rc = -EINVAL;
>  			FreeXid(xid);
>  			return rc;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Looks correct to me.

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
