From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 9/45] CIFS: Move unlink code to ops struct
Date: Thu, 13 Sep 2012 08:07:31 -0400
Message-ID: <20120913080731.1e7a0016@tlielax.poochiereds.net>
References: <CAKywueTvDNzQQVG0TEvhu2CxEERQc9dxH-VuUwmgOf5d7eeniA@mail.gmail.com>
	<1347516738-6861-1-git-send-email-pshilovsky@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1347516738-6861-1-git-send-email-pshilovsky-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 13 Sep 2012 10:12:18 +0400
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> 
> Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/cifsglob.h  |    6 ++++++
>  fs/cifs/cifsproto.h |    9 ++++++---
>  fs/cifs/cifssmb.c   |   16 ++++++++--------
>  fs/cifs/inode.c     |   33 ++++++++++++++++++++++-----------
>  fs/cifs/smb1ops.c   |    2 ++
>  5 files changed, 44 insertions(+), 22 deletions(-)
> 
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 977dc0e..843356f 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -256,6 +256,12 @@ struct smb_version_operations {
>  	/* remove directory */
>  	int (*rmdir)(const unsigned int, struct cifs_tcon *, const char *,
>  		     struct cifs_sb_info *);
> +	/* unlink file */
> +	int (*unlink)(const unsigned int, struct cifs_tcon *, const char *,
> +		      struct cifs_sb_info *);
> +	/* open, rename and delete file */
> +	int (*rename_pending_delete)(const char *, struct dentry *,
> +				     const unsigned int);
>  };
>  
>  struct smb_version_values {
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index f1bbf83..79c0884 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -144,6 +144,11 @@ extern int cifs_get_file_info_unix(struct file *filp);
>  extern int cifs_get_inode_info_unix(struct inode **pinode,
>  			const unsigned char *search_path,
>  			struct super_block *sb, unsigned int xid);
> +extern int cifs_set_file_info(struct inode *inode, struct iattr *attrs,
> +			      unsigned int xid, char *full_path, __u32 dosattr);
> +extern int cifs_rename_pending_delete(const char *full_path,
> +				      struct dentry *dentry,
> +				      const unsigned int xid);
>  extern int cifs_acl_to_fattr(struct cifs_sb_info *cifs_sb,
>  			      struct cifs_fattr *fattr, struct inode *inode,
>  			      const char *path, const __u16 *pfid);
> @@ -303,9 +308,7 @@ extern int CIFSPOSIXDelFile(const unsigned int xid, struct cifs_tcon *tcon,
>  			const struct nls_table *nls_codepage,
>  			int remap_special_chars);
>  extern int CIFSSMBDelFile(const unsigned int xid, struct cifs_tcon *tcon,
> -			const char *name,
> -			const struct nls_table *nls_codepage,
> -			int remap_special_chars);
> +			  const char *name, struct cifs_sb_info *cifs_sb);
>  extern int CIFSSMBRename(const unsigned int xid, struct cifs_tcon *tcon,
>  			const char *fromName, const char *toName,
>  			const struct nls_table *nls_codepage,
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index f0cf934..2dddf01 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -902,15 +902,15 @@ PsxDelete:
>  }
>  
>  int
> -CIFSSMBDelFile(const unsigned int xid, struct cifs_tcon *tcon,
> -	       const char *fileName, const struct nls_table *nls_codepage,
> -	       int remap)
> +CIFSSMBDelFile(const unsigned int xid, struct cifs_tcon *tcon, const char *name,
> +	       struct cifs_sb_info *cifs_sb)
>  {
>  	DELETE_FILE_REQ *pSMB = NULL;
>  	DELETE_FILE_RSP *pSMBr = NULL;
>  	int rc = 0;
>  	int bytes_returned;
>  	int name_len;
> +	int remap = cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR;
>  
>  DelFileRetry:
>  	rc = smb_init(SMB_COM_DELETE, 1, tcon, (void **) &pSMB,
> @@ -919,15 +919,15 @@ DelFileRetry:
>  		return rc;
>  
>  	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
> -		name_len =
> -		    cifsConvertToUTF16((__le16 *) pSMB->fileName, fileName,
> -				       PATH_MAX, nls_codepage, remap);
> +		name_len = cifsConvertToUTF16((__le16 *) pSMB->fileName, name,
> +					      PATH_MAX, cifs_sb->local_nls,
> +					      remap);
>  		name_len++;	/* trailing null */
>  		name_len *= 2;
>  	} else {		/* BB improve check for buffer overruns BB */
> -		name_len = strnlen(fileName, PATH_MAX);
> +		name_len = strnlen(name, PATH_MAX);
>  		name_len++;	/* trailing null */
> -		strncpy(pSMB->fileName, fileName, name_len);
> +		strncpy(pSMB->fileName, name, name_len);
>  	}
>  	pSMB->SearchAttributes =
>  	    cpu_to_le16(ATTR_READONLY | ATTR_HIDDEN | ATTR_SYSTEM);
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index cb79c7e..bb39ea4 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -876,9 +876,9 @@ out:
>  	return inode;
>  }
>  
> -static int
> +int
>  cifs_set_file_info(struct inode *inode, struct iattr *attrs, unsigned int xid,
> -		    char *full_path, __u32 dosattr)
> +		   char *full_path, __u32 dosattr)
>  {
>  	int rc;
>  	int oplock = 0;
> @@ -993,13 +993,13 @@ out:
>  }
>  
>  /*
> - * open the given file (if it isn't already), set the DELETE_ON_CLOSE bit
> + * Open the given file (if it isn't already), set the DELETE_ON_CLOSE bit
>   * and rename it to a random name that hopefully won't conflict with
>   * anything else.
>   */
> -static int
> -cifs_rename_pending_delete(char *full_path, struct dentry *dentry,
> -			   unsigned int xid)
> +int
> +cifs_rename_pending_delete(const char *full_path, struct dentry *dentry,
> +			   const unsigned int xid)
>  {
>  	int oplock = 0;
>  	int rc;
> @@ -1136,6 +1136,7 @@ int cifs_unlink(struct inode *dir, struct dentry *dentry)
>  	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
>  	struct tcon_link *tlink;
>  	struct cifs_tcon *tcon;
> +	struct TCP_Server_Info *server;
>  	struct iattr *attrs = NULL;
>  	__u32 dosattr = 0, origattr = 0;
>  
> @@ -1145,6 +1146,7 @@ int cifs_unlink(struct inode *dir, struct dentry *dentry)
>  	if (IS_ERR(tlink))
>  		return PTR_ERR(tlink);
>  	tcon = tlink_tcon(tlink);
> +	server = tcon->ses->server;
>  
>  	xid = get_xid();
>  
> @@ -1167,8 +1169,12 @@ int cifs_unlink(struct inode *dir, struct dentry *dentry)
>  	}
>  
>  retry_std_delete:
> -	rc = CIFSSMBDelFile(xid, tcon, full_path, cifs_sb->local_nls,
> -			cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
> +	if (!server->ops->unlink) {
> +		rc = -ENOSYS;
> +		goto psx_del_no_retry;
> +	}
> +
> +	rc = server->ops->unlink(xid, tcon, full_path, cifs_sb);
>  
>  psx_del_no_retry:
>  	if (!rc) {
> @@ -1177,9 +1183,14 @@ psx_del_no_retry:
>  	} else if (rc == -ENOENT) {
>  		d_drop(dentry);
>  	} else if (rc == -ETXTBSY) {
> -		rc = cifs_rename_pending_delete(full_path, dentry, xid);
> -		if (rc == 0)
> -			cifs_drop_nlink(inode);
> +		if (server->ops->rename_pending_delete) {
> +			rc = server->ops->rename_pending_delete(full_path,
> +								dentry, xid);
> +			if (rc == 0)
> +				cifs_drop_nlink(inode);
> +		}
> +		if (rc == -ETXTBSY)
> +			rc = -EBUSY;
>  	} else if ((rc == -EACCES) && (dosattr == 0) && inode) {
>  		attrs = kzalloc(sizeof(*attrs), GFP_KERNEL);
>  		if (attrs == NULL) {
> diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
> index 3129ac7..725fa61 100644
> --- a/fs/cifs/smb1ops.c
> +++ b/fs/cifs/smb1ops.c
> @@ -644,6 +644,8 @@ struct smb_version_operations smb1_operations = {
>  	.mkdir = CIFSSMBMkDir,
>  	.mkdir_setinfo = cifs_mkdir_setinfo,
>  	.rmdir = CIFSSMBRmDir,
> +	.unlink = CIFSSMBDelFile,
> +	.rename_pending_delete = cifs_rename_pending_delete,
>  };
>  
>  struct smb_version_values smb1_values = {

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
