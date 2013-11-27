From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 5/8] cifs: Add create MFSymlinks to protocol ops struct
Date: Wed, 27 Nov 2013 06:40:51 -0500
Message-ID: <20131127064051.0615c390@tlielax.poochiereds.net>
References: <1385399395-19217-1-git-send-email-sprabhu@redhat.com>
	<1385399395-19217-6-git-send-email-sprabhu@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1385399395-19217-6-git-send-email-sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 25 Nov 2013 17:09:52 +0000
Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> Add a new protocol ops function create_mf_symlink and have
> create_mf_symlink() use it.
> 
> This patchset moves the MFSymlink operations completely to the
> ops structure so that we only use the right protocol versions when
> querying or creating MFSymlinks.
> 
> Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/cifsglob.h  |  3 ++
>  fs/cifs/cifsproto.h |  4 +++
>  fs/cifs/link.c      | 88 ++++++++++++++++++++++++++++-------------------------
>  fs/cifs/smb1ops.c   |  1 +
>  4 files changed, 54 insertions(+), 42 deletions(-)
> 
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index e844515..1781e89 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -373,6 +373,9 @@ struct smb_version_operations {
>  	int (*query_mf_symlink)(unsigned int, struct cifs_tcon *,
>  				struct cifs_sb_info *, const unsigned char *,
>  				char *, unsigned int *);
> +	int (*create_mf_symlink)(unsigned int, struct cifs_tcon *,
> +				 struct cifs_sb_info *, const unsigned char *,
> +				 char *, unsigned int *);
>  	/* if we can do cache read operations */
>  	bool (*is_read_op)(__u32);
>  	/* set oplock level for the inode */
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index 78bb6d6..e88c3b1 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -500,4 +500,8 @@ int cifs_query_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
>  			  struct cifs_sb_info *cifs_sb,
>  			  const unsigned char *path, char *pbuf,
>  			  unsigned int *pbytes_read);
> +int cifs_create_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
> +			   struct cifs_sb_info *cifs_sb,
> +			   const unsigned char *path, char *pbuf,
> +			   unsigned int *pbytes_written);
>  #endif			/* _CIFSPROTO_H */
> diff --git a/fs/cifs/link.c b/fs/cifs/link.c
> index f8aaf10..d45d43d 100644
> --- a/fs/cifs/link.c
> +++ b/fs/cifs/link.c
> @@ -180,59 +180,31 @@ format_mf_symlink(u8 *buf, unsigned int buf_len, const char *link_str)
>  
>  static int
>  create_mf_symlink(const unsigned int xid, struct cifs_tcon *tcon,
> -		    const char *fromName, const char *toName,
> -		    struct cifs_sb_info *cifs_sb)
> +		  struct cifs_sb_info *cifs_sb, const char *fromName,
> +		  const char *toName)
>  {
>  	int rc;
> -	int oplock = 0;
> -	int remap;
> -	int create_options = CREATE_NOT_DIR;
> -	__u16 netfid = 0;
>  	u8 *buf;
>  	unsigned int bytes_written = 0;
> -	struct cifs_io_parms io_parms;
> -	struct nls_table *nls_codepage;
> -
> -	nls_codepage = cifs_sb->local_nls;
> -	remap = cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR;
>  
>  	buf = kmalloc(CIFS_MF_SYMLINK_FILE_SIZE, GFP_KERNEL);
>  	if (!buf)
>  		return -ENOMEM;
>  
>  	rc = format_mf_symlink(buf, CIFS_MF_SYMLINK_FILE_SIZE, toName);
> -	if (rc != 0) {
> -		kfree(buf);
> -		return rc;
> -	}
> -
> -	if (backup_cred(cifs_sb))
> -		create_options |= CREATE_OPEN_BACKUP_INTENT;
> -
> -	rc = CIFSSMBOpen(xid, tcon, fromName, FILE_CREATE, GENERIC_WRITE,
> -			 create_options, &netfid, &oplock, NULL,
> -			 nls_codepage, remap);
> -	if (rc != 0) {
> -		kfree(buf);
> -		return rc;
> -	}
> -
> -	io_parms.netfid = netfid;
> -	io_parms.pid = current->tgid;
> -	io_parms.tcon = tcon;
> -	io_parms.offset = 0;
> -	io_parms.length = CIFS_MF_SYMLINK_FILE_SIZE;
> +	if (rc)
> +		goto out;
>  
> -	rc = CIFSSMBWrite(xid, &io_parms, &bytes_written, buf, NULL, 0);
> -	CIFSSMBClose(xid, tcon, netfid);
> -	kfree(buf);
> -	if (rc != 0)
> -		return rc;
> +	rc = tcon->ses->server->ops->create_mf_symlink(xid, tcon, cifs_sb,
> +					fromName, buf, &bytes_written);
> +	if (rc)
> +		goto out;
>  
>  	if (bytes_written != CIFS_MF_SYMLINK_FILE_SIZE)
> -		return -EIO;
> -
> -	return 0;
> +		rc = -EIO;
> +out:
> +	kfree(buf);
> +	return rc;
>  }
>  
>  static int
> @@ -320,6 +292,39 @@ out:
>  }
>  
>  int
> +cifs_create_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
> +		       struct cifs_sb_info *cifs_sb, const unsigned char *path,
> +		       char *pbuf, unsigned int *pbytes_written)
> +{
> +	int rc;
> +	int oplock = 0;
> +	__u16 netfid = 0;
> +	struct cifs_io_parms io_parms;
> +	int create_options = CREATE_NOT_DIR;
> +
> +	if (backup_cred(cifs_sb))
> +		create_options |= CREATE_OPEN_BACKUP_INTENT;
> +
> +	rc = CIFSSMBOpen(xid, tcon, path, FILE_CREATE, GENERIC_WRITE,
> +			 create_options, &netfid, &oplock, NULL,
> +			 cifs_sb->local_nls,
> +			 cifs_sb->mnt_cifs_flags &
> +				CIFS_MOUNT_MAP_SPECIAL_CHR);
> +	if (rc)
> +		return rc;
> +
> +	io_parms.netfid = netfid;
> +	io_parms.pid = current->tgid;
> +	io_parms.tcon = tcon;
> +	io_parms.offset = 0;
> +	io_parms.length = CIFS_MF_SYMLINK_FILE_SIZE;
> +
> +	rc = CIFSSMBWrite(xid, &io_parms, pbytes_written, pbuf, NULL, 0);
> +	CIFSSMBClose(xid, tcon, netfid);
> +	return rc;
> +}
> +
> +int
>  check_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
>  		 struct cifs_sb_info *cifs_sb, struct cifs_fattr *fattr,
>  		 const unsigned char *path)
> @@ -551,8 +556,7 @@ cifs_symlink(struct inode *inode, struct dentry *direntry, const char *symname)
>  
>  	/* BB what if DFS and this volume is on different share? BB */
>  	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS)
> -		rc = create_mf_symlink(xid, pTcon, full_path, symname,
> -					cifs_sb);
> +		rc = create_mf_symlink(xid, pTcon, cifs_sb, full_path, symname);
>  	else if (pTcon->unix_ext)
>  		rc = CIFSUnixCreateSymLink(xid, pTcon, full_path, symname,
>  					   cifs_sb->local_nls);
> diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
> index 099c276..1470ec4 100644
> --- a/fs/cifs/smb1ops.c
> +++ b/fs/cifs/smb1ops.c
> @@ -1010,6 +1010,7 @@ struct smb_version_operations smb1_operations = {
>  	.mand_unlock_range = cifs_unlock_range,
>  	.push_mand_locks = cifs_push_mandatory_locks,
>  	.query_mf_symlink = cifs_query_mf_symlink,
> +	.create_mf_symlink = cifs_create_mf_symlink,
>  	.is_read_op = cifs_is_read_op,
>  };
>  

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
