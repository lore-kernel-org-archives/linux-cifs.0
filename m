From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH V2] cifs: Add support of Alternate Data Streams
Date: Sun, 16 Sep 2012 06:59:41 -0400
Message-ID: <20120916065941.7f6f778d@corrin.poochiereds.net>
References: <1347764747-16822-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tugosavi-xthvdsQ13ZrQT0dZR+AlfA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1347764747-16822-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 15 Sep 2012 22:05:47 -0500
shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> 
> Add support of Alternate Data Streams (ads).
> 
> The generic access flags that cifs client currently employs are sufficient
> for alternate data streams as well (MS-CIFS 2.2.4.64.1).
> 
> The ads files have a : in the name, so that is used to differentiate
> between a regular file and its alternate data streams as they
> have the same file id.
> This scheme applies to non-posix compliant servers such as Windows only.
> 
> One operation that does not work is Rename (0x7).
> 
> 
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/inode.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index cb79c7e..a28950a 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -709,10 +709,15 @@ cifs_get_inode_info(struct inode **inode, const char *full_path,
>  			cFYI(1, "CIFSCheckMFSymlink: %d", tmprc);
>  	}
>  
> +	if (strstr(full_path, ":"))
> +		fattr.cf_flags |= S_PRIVATE;
> +

While S_PRIVATE doesn't conflict with any of the other cf_flag values
currently, I think it would be best to define a new CIFS_FATTR_* flag
for this purpose.

>  	if (!*inode) {
>  		*inode = cifs_iget(sb, &fattr);
>  		if (!*inode)
>  			rc = -ENOMEM;
> +		else
> +			(*inode)->i_flags |= fattr.cf_flags;

Uhh no...these flags have nothing to do with the i_flags. This will
almost certainly break things.

>  	} else {
>  		cifs_fattr_to_inode(*inode, &fattr);
>  	}
> @@ -744,6 +749,10 @@ cifs_find_inode(struct inode *inode, void *opaque)
>  	if ((inode->i_mode & S_IFMT) != (fattr->cf_mode & S_IFMT))
>  		return 0;
>  
> +	/* don't match inode with different flags */
> +	if ((inode->i_flags & S_PRIVATE) != (fattr->cf_flags & S_PRIVATE))
> +		return 0;
> +
>  	/* if it's not a directory or has no dentries, then flag it */
>  	if (S_ISDIR(inode->i_mode) && !hlist_empty(&inode->i_dentry))
>  		fattr->cf_flags |= CIFS_FATTR_INO_COLLISION;

I'm still trying to understand the point of this patch. I guess the
concern is that these files have the same uniqueid? So this will look
like a hardlinked file metadata-wise, but will have different contents?

If so, then isn't it possible that you'd have more than one alternate
data stream attached to the file? In that case, it looks like the
approach you're using here won't work since you're only designating the
alternate data stream with a single flag value.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
