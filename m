From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 12/45] CIFS: Move close code to ops struct
Date: Thu, 13 Sep 2012 11:45:10 -0400
Message-ID: <20120913114510.5c5c76aa@corrin.poochiereds.net>
References: <1342626541-29872-1-git-send-email-pshilovsky@samba.org>
	<1342626541-29872-13-git-send-email-pshilovsky@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342626541-29872-13-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 18 Jul 2012 19:48:28 +0400
Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  fs/cifs/cifsglob.h |    2 ++
>  fs/cifs/file.c     |   10 +++++++---
>  fs/cifs/smb1ops.c  |    8 ++++++++
>  3 files changed, 17 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index c4375d8..b3cbce6 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -269,6 +269,8 @@ struct smb_version_operations {
>  		    struct cifs_sb_info *);
>  	/* set fid protocol-specific info */
>  	void (*set_fid)(struct cifsFileInfo *, struct cifs_fid *, __u32);
> +	/* close a file */
> +	int (*close)(const unsigned int, struct cifs_tcon *, struct cifs_fid *);
>  };
>  

nit: maybe ->close and CIFSSMBClose should be a void return? Nothing
actually pays attention to the return code for CIFSSMBClose

>  struct smb_version_values {
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 3f4b4ba..b18b36a 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -317,10 +317,13 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
>  	cancel_work_sync(&cifs_file->oplock_break);
>  
>  	if (!tcon->need_reconnect && !cifs_file->invalidHandle) {
> +		struct TCP_Server_Info *server = tcon->ses->server;
>  		unsigned int xid;
> -		int rc;
> +		int rc = -ENOSYS;
> +

No need to initialize this at all. In fact, probably best to convert
CIFSSMBClose to void return and get rid of that variable.

>  		xid = get_xid();
> -		rc = CIFSSMBClose(xid, tcon, cifs_file->fid.netfid);
> +		if (server->ops->close)
> +			rc = server->ops->close(xid, tcon, &cifs_file->fid);
>  		free_xid(xid);
>  	}
>  
> @@ -414,7 +417,8 @@ int cifs_open(struct inode *inode, struct file *file)
>  
>  	cfile = cifs_new_fileinfo(&fid, file, tlink, oplock);
>  	if (cfile == NULL) {
> -		CIFSSMBClose(xid, tcon, fid.netfid);
> +		if (tcon->ses->server->ops->close)
> +			tcon->ses->server->ops->close(xid, tcon, &fid);
>  		rc = -ENOMEM;
>  		goto out;
>  	}
> diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
> index 907b308..bb75847 100644
> --- a/fs/cifs/smb1ops.c
> +++ b/fs/cifs/smb1ops.c
> @@ -634,6 +634,13 @@ cifs_set_fid(struct cifsFileInfo *cfile, struct cifs_fid *fid, __u32 oplock)
>  	cinode->can_cache_brlcks = cinode->clientCanCacheAll;
>  }
>  
> +static int
> +cifs_close_file(const unsigned int xid, struct cifs_tcon *tcon,
> +		struct cifs_fid *fid)
> +{
> +	return CIFSSMBClose(xid, tcon, fid->netfid);
> +}
> +
>  struct smb_version_operations smb1_operations = {
>  	.send_cancel = send_nt_cancel,
>  	.compare_fids = cifs_compare_fids,
> @@ -675,6 +682,7 @@ struct smb_version_operations smb1_operations = {
>  	.rename_pending_delete = cifs_rename_pending_delete,
>  	.open = cifs_open_file,
>  	.set_fid = cifs_set_fid,
> +	.close = cifs_close_file,
>  };
>  
>  struct smb_version_values smb1_values = {

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
