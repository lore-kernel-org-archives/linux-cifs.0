From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: ensure that cifs_readpages calls cifsFileInfo_get
 under the cifs_file_list_lock
Date: Mon, 23 Jul 2012 08:18:18 -0400
Message-ID: <20120723081818.0ac7bf04@corrin.poochiereds.net>
References: <1342799330-2919-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342799330-2919-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 20 Jul 2012 11:48:50 -0400
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> ...regression introduced in 6993f74a5.
> 
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/file.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 513adbc..45508cf 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -3083,8 +3083,8 @@ static int cifs_readpages(struct file *file, struct address_space *mapping,
>  		}
>  
>  		spin_lock(&cifs_file_list_lock);
> -		spin_unlock(&cifs_file_list_lock);
>  		rdata->cfile = cifsFileInfo_get(open_file);
> +		spin_unlock(&cifs_file_list_lock);
>  		rdata->mapping = mapping;
>  		rdata->offset = offset;
>  		rdata->bytes = bytes;

Now that 3.5 has shipped, this patch needs to Cc: stable when it's included.

Cheers,
-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
