From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 6/8] cifs: implement CIFSQueryMFSymLink()
Date: Tue, 3 Aug 2010 12:31:58 -0400
Message-ID: <20100803123158.4df8c248@tlielax.poochiereds.net>
References: <1280847960-16371-1-git-send-email-metze@samba.org>
	<1280847960-16371-7-git-send-email-metze@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1280847960-16371-7-git-send-email-metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue,  3 Aug 2010 17:05:58 +0200
Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> Signed-off-by: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  fs/cifs/link.c |   46 ++++++++++++++++++++++++++++++++++++++++++----
>  1 files changed, 42 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/cifs/link.c b/fs/cifs/link.c
> index f7636f9..77f5a40 100644
> --- a/fs/cifs/link.c
> +++ b/fs/cifs/link.c
> @@ -102,10 +102,46 @@ CIFSCreateMFSymLink(const int xid, struct cifsTconInfo *tcon,
>  static int
>  CIFSQueryMFSymLink(const int xid, struct cifsTconInfo *tcon,
>  		   const unsigned char *searchName, char **symlinkinfo,
> -		   const struct nls_table *nls_codepage)
> +		   const struct nls_table *nls_codepage, int remap)
>  {
> -	int rc = -EOPNOTSUPP;
> -	return rc;
> +	int rc;
> +	int oplock = 0;
> +	__u16 netfid = 0;
> +	u8 buf[CIFS_MF_SYMLINK_FILE_SIZE];
	^^^^
	as noted before, you don't want to allocate these big buffers on the stack

> +	char *pbuf = buf;
> +	unsigned int bytes_read = 0;
> +	int buf_type = CIFS_NO_BUFFER;
> +	unsigned int link_len = 0;
> +	FILE_ALL_INFO file_info;
> +
> +	rc = CIFSSMBOpen(xid, tcon, searchName, FILE_OPEN, GENERIC_READ,
> +			 CREATE_NOT_DIR, &netfid, &oplock, &file_info,
> +			 nls_codepage, remap);
> +	if (rc != 0) {
> +		return rc;
> +	}
> +
	In general, kernel coding style leaves out braces when the
	inside of an if block is a single statement. IOW, this should
	read:

	if (rc != 0)
		return rc;

> +	if (file_info.EndOfFile != CIFS_MF_SYMLINK_FILE_SIZE) {
> +		CIFSSMBClose(xid, tcon, netfid);
> +		/* it's not a symlink */
> +		return -EINVAL;
> +	}
> +
> +	rc = CIFSSMBRead(xid, tcon, netfid,
> +			 CIFS_MF_SYMLINK_FILE_SIZE /* length */,
> +			 0 /* offset */,
> +			 &bytes_read, &pbuf, &buf_type);
> +	CIFSSMBClose(xid, tcon, netfid);
> +	if (rc != 0) {
> +		return rc;
> +	}
> +
> +	rc = CIFSParseMFSymlink(buf, bytes_read, &link_len, symlinkinfo);
> +	if (rc != 0) {
> +		return rc;
> +	}
> +
> +	return 0;
>  }
>  
>  int
> @@ -291,7 +327,9 @@ cifs_follow_link(struct dentry *direntry, struct nameidata *nd)
>  
>  	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS)
>  		rc = CIFSQueryMFSymLink(xid, tcon, full_path, &target_path,
> -					cifs_sb->local_nls);
> +					cifs_sb->local_nls,
> +					cifs_sb->mnt_cifs_flags &
> +						CIFS_MOUNT_MAP_SPECIAL_CHR);
>  	else
>  		rc = CIFSSMBUnixQuerySymLink(xid, tcon, full_path, &target_path,
>  					     cifs_sb->local_nls);


-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
