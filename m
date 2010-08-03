From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 8/8] cifs: implement CIFSCreateMFSymLink()
Date: Tue, 3 Aug 2010 11:29:00 -0400
Message-ID: <20100803112900.64485e43@tlielax.poochiereds.net>
References: <1280847960-16371-1-git-send-email-metze@samba.org>
	<1280847960-16371-9-git-send-email-metze@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1280847960-16371-9-git-send-email-metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue,  3 Aug 2010 17:06:00 +0200
Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> Signed-off-by: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  fs/cifs/link.c |   39 +++++++++++++++++++++++++++++++++++----
>  1 files changed, 35 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/cifs/link.c b/fs/cifs/link.c
> index b281d26..93d2dfd 100644
> --- a/fs/cifs/link.c
> +++ b/fs/cifs/link.c
> @@ -135,10 +135,39 @@ CIFSFormatMFSymlink(u8 *buf, unsigned int buf_len, const char *link_str)
>  static int
>  CIFSCreateMFSymLink(const int xid, struct cifsTconInfo *tcon,
>  		    const char *fromName, const char *toName,
> -		    const struct nls_table *nls_codepage)
> +		    const struct nls_table *nls_codepage, int remap)
>  {
> -	int rc = -EOPNOTSUPP;
> -	return rc;
> +	int rc;
> +	int oplock = 0;
> +	__u16 netfid = 0;
> +	u8 buf[CIFS_MF_SYMLINK_FILE_SIZE];
	^^^^^^^^^^^^^^
Oof. You really don't want to do this -- allocating this much on the
stack is a good way to get memory corruption. I'd kmalloc this
buffer instead.

> +	unsigned int bytes_written = 0;
> +
> +	rc = CIFSFormatMFSymlink(buf, sizeof(buf), toName);
> +	if (rc != 0) {
> +		return rc;
> +	}
> +
> +	rc = CIFSSMBOpen(xid, tcon, fromName, FILE_CREATE, GENERIC_WRITE,
> +			 CREATE_NOT_DIR, &netfid, &oplock, NULL,
> +			 nls_codepage, remap);
> +	if (rc != 0) {
> +		return rc;
> +	}
> +
> +	rc = CIFSSMBWrite(xid, tcon, netfid,
> +			  sizeof(buf) /* length */,
> +			  0 /* offset */,
> +			  &bytes_written, buf, NULL, 0);
> +	CIFSSMBClose(xid, tcon, netfid);
> +	if (rc != 0) {
> +		return rc;
> +	}
> +
> +	if (bytes_written != sizeof(buf))
> +		return -EIO;
> +
> +	return 0;
>  }
>  
>  static int
> @@ -416,7 +445,9 @@ cifs_symlink(struct inode *inode, struct dentry *direntry, const char *symname)
>  	/* BB what if DFS and this volume is on different share? BB */
>  	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS)
>  		rc = CIFSCreateMFSymLink(xid, pTcon, full_path, symname,
> -					 cifs_sb->local_nls);
> +					 cifs_sb->local_nls,
> +					 cifs_sb->mnt_cifs_flags &
> +						CIFS_MOUNT_MAP_SPECIAL_CHR);
>  	else if (pTcon->unix_ext)
>  		rc = CIFSUnixCreateSymLink(xid, pTcon, full_path, symname,
>  					   cifs_sb->local_nls);


-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
