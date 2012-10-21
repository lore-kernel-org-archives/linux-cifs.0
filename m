From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH v4 1/2] cifs: Alternate Data Streams: Add support
Date: Sun, 21 Oct 2012 07:44:54 -0400
Message-ID: <20121021074454.1a4316e5@tlielax.poochiereds.net>
References: <1350739560-9197-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1350739560-9197-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 20 Oct 2012 08:26:00 -0500
shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> 
> Add support of Alternate Data Streams (ads).
> 
> The generic access flags that cifs client currently employs are sufficient
> for alternate data streams as well (MS-CIFS 2.2.4.64.1).
> 
> The stream file and stream type are specified using : after the file name,
> so that is used to differentiate between a regular file and its
> alternate data streams and stream types.
> Since they all have the same file id, each path name,
> file name:stream name:stream type, has a separate inode with that same
> file id but a distinct private data (path name) in that inode to
> distinguish them.
> 
> This scheme applies only to non-posix compliant servers such as Windows.
> 
> One operation that does not work is Rename (0x7).
> 
> 
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/cifsfs.c   |    1 +
>  fs/cifs/cifsglob.h |    2 ++
>  fs/cifs/inode.c    |   34 +++++++++++++++++++++++++++++++++-
>  3 files changed, 36 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index a41044a..1a02c81 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -264,6 +264,7 @@ cifs_evict_inode(struct inode *inode)
>  {
>  	truncate_inode_pages(&inode->i_data, 0);
>  	clear_inode(inode);
> +	kfree(inode->i_private);

Are you sure that i_private is always initialized to NULL? Hmm...looks
like they probably are in inode_init_always. Ok...

>  	cifs_fscache_release_inode_cookie(inode);
>  }
>  
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index f5af252..26d65c7 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -1251,6 +1251,7 @@ struct dfs_info3_param {
>  #define CIFS_FATTR_DELETE_PENDING	0x2
>  #define CIFS_FATTR_NEED_REVAL		0x4
>  #define CIFS_FATTR_INO_COLLISION	0x8
> +#define CIFS_FATTR_ALTDATASTR		0x10
>  
>  struct cifs_fattr {
>  	u32		cf_flags;
> @@ -1268,6 +1269,7 @@ struct cifs_fattr {
>  	struct timespec	cf_atime;
>  	struct timespec	cf_mtime;
>  	struct timespec	cf_ctime;
> +	char		*cf_private;
>  };
>  
>  static inline void free_dfs_info_param(struct dfs_info3_param *param)
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index afdff79..201ec46 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -615,10 +615,12 @@ cifs_get_inode_info(struct inode **inode, const char *full_path,
>  	struct tcon_link *tlink;
>  	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
>  	char *buf = NULL;
> +	char *altstr = NULL;
>  	bool adjust_tz = false;
>  	struct cifs_fattr fattr;
>  	struct cifs_search_info *srchinf = NULL;
>  
> +	fattr.cf_private = NULL;
>  	tlink = cifs_sb_tlink(cifs_sb);
>  	if (IS_ERR(tlink))
>  		return PTR_ERR(tlink);
> @@ -746,14 +748,34 @@ cifs_get_inode_info(struct inode **inode, const char *full_path,
>  	}
>  
>  	if (!*inode) {
> +		altstr = strchr(full_path, ':');
> +		if (altstr) {
> +			fattr.cf_private = kstrdup(altstr, GFP_KERNEL);
> +			if (!fattr.cf_private) {
> +				rc = -ENOMEM;
> +				goto cgii_exit;
> +			}
> +			fattr.cf_flags |= CIFS_FATTR_ALTDATASTR;
> +		}
> +
>  		*inode = cifs_iget(sb, &fattr);
> -		if (!*inode)
> +		if (*inode) {
> +			if (altstr && !((*inode)->i_flags & S_PRIVATE)) {
> +				(*inode)->i_private =
> +					kstrdup(altstr, GFP_KERNEL);
> +				if ((*inode)->i_private)
> +					(*inode)->i_flags |= S_PRIVATE;
> +				else
> +					rc = -ENOMEM;
> +			}
> +		} else

		^^^^^
Why redo the allocation and copy here? You could just hand off the one
you just allocated...

>  			rc = -ENOMEM;
>  	} else {
>  		cifs_fattr_to_inode(*inode, &fattr);
>  	}
>  
>  cgii_exit:
> +	kfree(fattr.cf_private);
>  	kfree(buf);
>  	cifs_put_tlink(tlink);
>  	return rc;
> @@ -784,6 +806,16 @@ cifs_find_inode(struct inode *inode, void *opaque)
>  	if (S_ISDIR(inode->i_mode) && !hlist_empty(&inode->i_dentry))
>  		fattr->cf_flags |= CIFS_FATTR_INO_COLLISION;
>  
> +	/* looking for an inode of a alternate data stream (full pathname) */
> +	if (fattr->cf_flags & CIFS_FATTR_ALTDATASTR) {
> +		if (!(inode->i_flags & S_PRIVATE)) {
> +			return 0;
> +		} else {
> +			if (strcmp(inode->i_private, fattr->cf_private))
> +				return 0;
> +		}
> +	}
> +
>  	return 1;
>  }
>  

Looks like S_PRIVATE has some other security/permissions related
effects. Do you expect any behavior change from using it here?
-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
