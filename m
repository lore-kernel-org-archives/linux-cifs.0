From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: don't instantiate new dentries in readdir for
 inodes that need to be revalidated immediately
Date: Wed, 7 Aug 2013 09:06:16 -0400
Message-ID: <20130807090616.6ba44d6c@tlielax.poochiereds.net>
References: <51F92F0B.7030504@cam.ac.uk>
	<1375880647-22512-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: David McBride <dwm37-KWPb1pKIrIJaa/9Udqfwiw@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	"Stefan (metze) Metzmacher" <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1375880647-22512-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed,  7 Aug 2013 09:04:07 -0400
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> David reported that commit c2b93e06 (cifs: only set ops for inodes in
> I_NEW state) caused a regression with mfsymlinks. If a mfsymlink dentry
> was instantiated at readdir time, then it would not be properly tossed
> out of the cache and reinstantiated when a stat or readlink call came
> about.
> 
> This patch addresses this by simply skipping instantiating dentries
> when we *know* that they will need to be immediately revalidated. The
> next attempt to use that dentry will cause a new lookup to occur
> (which is basically what we want to happen anyway).
> 
> Reported-by: David McBride <dwm37-KWPb1pKIrIJaa/9Udqfwiw@public.gmane.org>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/readdir.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
> index ab87784..69d2c82 100644
> --- a/fs/cifs/readdir.c
> +++ b/fs/cifs/readdir.c
> @@ -111,6 +111,14 @@ cifs_prime_dcache(struct dentry *parent, struct qstr *name,
>  			return;
>  	}
>  
> +	/*
> +	 * If we know that the inode will need to be revalidated immediately,
> +	 * then don't create a new dentry for it. We'll end up doing an on
> +	 * the wire call either way and this spares us an invalidation.
> +	 */
> +	if (fattr->cf_flags & CIFS_FATTR_NEED_REVAL)
> +		return;
> +
>  	dentry = d_alloc(parent, name);
>  	if (!dentry)
>  		return;


This patch is untested (other than for compilation), but I think it'll
do the right thing. Metze, David could you test it and let us know if
it helps?

Thanks,
-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
