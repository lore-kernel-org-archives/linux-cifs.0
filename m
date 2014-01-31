From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: Fix check for regular file in
 couldbe_mf_symlink()
Date: Fri, 31 Jan 2014 09:32:50 -0500
Message-ID: <20140131093250.3f26fa59@tlielax.poochiereds.net>
References: <1391178436-10069-1-git-send-email-sprabhu@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1391178436-10069-1-git-send-email-sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 31 Jan 2014 14:27:16 +0000
Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> MF Symlinks are regular files containing content in a specified format.
> 
> The function couldbe_mf_symlink() checks the mode for a set S_IFREG bit
> as a test to confirm that it is a regular file. This bit is also set for
> other filetypes and simply checking for this bit being set may return
> false positives.
> 
> We ensure that we are actually checking for a regular file by using the
> S_ISREG macro to test instead.
> 
> Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Reported-by: Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org>
> Reported-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/link.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/cifs/link.c b/fs/cifs/link.c
> index 52f41f9..264ece7 100644
> --- a/fs/cifs/link.c
> +++ b/fs/cifs/link.c
> @@ -185,7 +185,7 @@ format_mf_symlink(u8 *buf, unsigned int buf_len, const char *link_str)
>  bool
>  couldbe_mf_symlink(const struct cifs_fattr *fattr)
>  {
> -	if (!(fattr->cf_mode & S_IFREG))
> +	if (!S_ISREG(fattr->cf_mode))
>  		/* it's not a symlink */
>  		return false;
>  

Looks correct.

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
