From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6 5/5] CIFS: Move protocol specific tcon/tdis code to
 ops struct
Date: Wed, 20 Jun 2012 17:56:37 -0700
Message-ID: <20120620175637.1c6fb05f@corrin.poochiereds.net>
References: <1340189651-25093-1-git-send-email-pshilovsky@samba.org>
	<1340189651-25093-6-git-send-email-pshilovsky@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1340189651-25093-6-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 20 Jun 2012 14:54:11 +0400
Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> and rename variables around the code changes.
> 
> Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  fs/cifs/cifsglob.h  |    6 ++++
>  fs/cifs/cifsproto.h |    8 +++---
>  fs/cifs/cifssmb.c   |    2 +-
>  fs/cifs/connect.c   |   73 ++++++++++++++++++++++++++++++---------------------
>  fs/cifs/smb1ops.c   |    2 +
>  5 files changed, 56 insertions(+), 35 deletions(-)
> 
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index a6eb9be..6d18962 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -160,6 +160,7 @@ struct mid_q_entry;
>  struct TCP_Server_Info;
>  struct cifsFileInfo;
>  struct cifs_ses;
> +struct cifs_tcon;
>  
>  struct smb_version_operations {
>  	int (*send_cancel)(struct TCP_Server_Info *, void *,
> @@ -201,6 +202,11 @@ struct smb_version_operations {
>  			  const struct nls_table *);
>  	/* close smb session */
>  	int (*logoff)(const unsigned int, struct cifs_ses *);
> +	/* connect to a server share */
> +	int (*tree_connect)(const unsigned int, struct cifs_ses *, const char *,
> +			    struct cifs_tcon *, const struct nls_table *);
> +	/* close tree connecion */
> +	int (*tree_disconnect)(const unsigned int, struct cifs_tcon *);
>  };
>  
>  struct smb_version_values {
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index a4360c5..e1689e7 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -184,9 +184,9 @@ extern int cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
>  			      struct nls_table *nls_info);
>  extern int CIFSSMBNegotiate(const unsigned int xid, struct cifs_ses *ses);
>  
> -extern int CIFSTCon(unsigned int xid, struct cifs_ses *ses,
> -			const char *tree, struct cifs_tcon *tcon,
> -			const struct nls_table *);
> +extern int CIFSTCon(const unsigned int xid, struct cifs_ses *ses,
> +		    const char *tree, struct cifs_tcon *tcon,
> +		    const struct nls_table *);
>  
>  extern int CIFSFindFirst(const int xid, struct cifs_tcon *tcon,
>  		const char *searchName, const struct nls_table *nls_codepage,
> @@ -388,7 +388,7 @@ extern int CIFSSMBPosixLock(const int xid, struct cifs_tcon *tcon,
>  			const __u16 smb_file_id, const __u32 netpid,
>  			const int get_flag, const __u64 len, struct file_lock *,
>  			const __u16 lock_type, const bool waitFlag);
> -extern int CIFSSMBTDis(const int xid, struct cifs_tcon *tcon);
> +extern int CIFSSMBTDis(const unsigned int xid, struct cifs_tcon *tcon);
>  extern int CIFSSMBEcho(struct TCP_Server_Info *server);
>  extern int CIFSSMBLogoff(const unsigned int xid, struct cifs_ses *ses);
>  
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index eb2ac1b..90f7de8 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -670,7 +670,7 @@ neg_err_exit:
>  }
>  
>  int
> -CIFSSMBTDis(const int xid, struct cifs_tcon *tcon)
> +CIFSSMBTDis(const unsigned int xid, struct cifs_tcon *tcon)
>  {
>  	struct smb_hdr *smb_buffer;
>  	int rc = 0;
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index c51d048..b91f64d 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -2541,7 +2541,7 @@ cifs_find_tcon(struct cifs_ses *ses, const char *unc)
>  static void
>  cifs_put_tcon(struct cifs_tcon *tcon)
>  {
> -	int xid;
> +	unsigned int xid;
>  	struct cifs_ses *ses = tcon->ses;
>  
>  	cFYI(1, "%s: tc_count=%d\n", __func__, tcon->tc_count);
> @@ -2555,7 +2555,8 @@ cifs_put_tcon(struct cifs_tcon *tcon)
>  	spin_unlock(&cifs_tcp_ses_lock);
>  
>  	xid = GetXid();
> -	CIFSSMBTDis(xid, tcon);
> +	if (ses->server->ops->tree_disconnect)
> +		ses->server->ops->tree_disconnect(xid, tcon);
>  	_FreeXid(xid);
>  
>  	cifs_fscache_release_super_cookie(tcon);
> @@ -2580,6 +2581,11 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb_vol *volume_info)
>  		return tcon;
>  	}
>  
> +	if (!ses->server->ops->tree_connect) {
> +		rc = -ENOSYS;
> +		goto out_fail;
> +	}
> +
>  	tcon = tconInfoAlloc();
>  	if (tcon == NULL) {
>  		rc = -ENOMEM;
> @@ -2602,13 +2608,15 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb_vol *volume_info)
>  		goto out_fail;
>  	}
>  
> -	/* BB Do we need to wrap session_mutex around
> -	 * this TCon call and Unix SetFS as
> -	 * we do on SessSetup and reconnect? */
> +	/*
> +	 * BB Do we need to wrap session_mutex around this TCon call and Unix
> +	 * SetFS as we do on SessSetup and reconnect?
> +	 */
>  	xid = GetXid();
> -	rc = CIFSTCon(xid, ses, volume_info->UNC, tcon, volume_info->local_nls);
> +	rc = ses->server->ops->tree_connect(xid, ses, volume_info->UNC, tcon,
> +					    volume_info->local_nls);
>  	FreeXid(xid);
> -	cFYI(1, "CIFS Tcon rc = %d", rc);
> +	cFYI(1, "Tcon rc = %d", rc);
>  	if (rc)
>  		goto out_fail;
>  
> @@ -2617,10 +2625,11 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb_vol *volume_info)
>  		cFYI(1, "DFS disabled (%d)", tcon->Flags);
>  	}
>  	tcon->seal = volume_info->seal;
> -	/* we can have only one retry value for a connection
> -	   to a share so for resources mounted more than once
> -	   to the same server share the last value passed in
> -	   for the retry flag is used */
> +	/*
> +	 * We can have only one retry value for a connection to a share so for
> +	 * resources mounted more than once to the same server share the last
> +	 * value passed in for the retry flag is used.
> +	 */
>  	tcon->retry = volume_info->retry;
>  	tcon->nocase = volume_info->nocase;
>  	tcon->local_lease = volume_info->local_lease;
> @@ -2754,37 +2763,41 @@ out:
>  }
>  
>  int
> -get_dfs_path(int xid, struct cifs_ses *pSesInfo, const char *old_path,
> -	     const struct nls_table *nls_codepage, unsigned int *pnum_referrals,
> -	     struct dfs_info3_param **preferrals, int remap)
> +get_dfs_path(int xid, struct cifs_ses *ses, const char *old_path,
> +	     const struct nls_table *nls_codepage, unsigned int *num_referrals,
> +	     struct dfs_info3_param **referrals, int remap)
>  {
>  	char *temp_unc;
>  	int rc = 0;
>  
> -	*pnum_referrals = 0;
> -	*preferrals = NULL;
> +	if (!ses->server->ops->tree_connect)
> +		return -ENOSYS;
> +
> +	*num_referrals = 0;
> +	*referrals = NULL;
>  
> -	if (pSesInfo->ipc_tid == 0) {
> +	if (ses->ipc_tid == 0) {
>  		temp_unc = kmalloc(2 /* for slashes */ +
> -			strnlen(pSesInfo->serverName,
> -				SERVER_NAME_LEN_WITH_NULL * 2)
> -				 + 1 + 4 /* slash IPC$ */  + 2,
> -				GFP_KERNEL);
> +			strnlen(ses->serverName, SERVER_NAME_LEN_WITH_NULL * 2)
> +				+ 1 + 4 /* slash IPC$ */ + 2, GFP_KERNEL);
>  		if (temp_unc == NULL)
>  			return -ENOMEM;
>  		temp_unc[0] = '\\';
>  		temp_unc[1] = '\\';
> -		strcpy(temp_unc + 2, pSesInfo->serverName);
> -		strcpy(temp_unc + 2 + strlen(pSesInfo->serverName), "\\IPC$");
> -		rc = CIFSTCon(xid, pSesInfo, temp_unc, NULL, nls_codepage);
> -		cFYI(1, "CIFS Tcon rc = %d ipc_tid = %d", rc, pSesInfo->ipc_tid);
> +		strcpy(temp_unc + 2, ses->serverName);
> +		strcpy(temp_unc + 2 + strlen(ses->serverName), "\\IPC$");
> +		rc = ses->server->ops->tree_connect(xid, ses, temp_unc, NULL,
> +						    nls_codepage);
> +		cFYI(1, "Tcon rc = %d ipc_tid = %d", rc, ses->ipc_tid);
>  		kfree(temp_unc);
>  	}
>  	if (rc == 0)
> -		rc = CIFSGetDFSRefer(xid, pSesInfo, old_path, preferrals,
> -				     pnum_referrals, nls_codepage, remap);
> -	/* BB map targetUNCs to dfs_info3 structures, here or
> -		in CIFSGetDFSRefer BB */
> +		rc = CIFSGetDFSRefer(xid, ses, old_path, referrals,
> +				     num_referrals, nls_codepage, remap);
> +	/*
> +	 * BB - map targetUNCs to dfs_info3 structures, here or in
> +	 * CIFSGetDFSRefer.
> +	 */
>  
>  	return rc;
>  }
> @@ -3761,7 +3774,7 @@ out:
>   * pointer may be NULL.
>   */
>  int
> -CIFSTCon(unsigned int xid, struct cifs_ses *ses,
> +CIFSTCon(const unsigned int xid, struct cifs_ses *ses,
>  	 const char *tree, struct cifs_tcon *tcon,
>  	 const struct nls_table *nls_codepage)
>  {
> diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
> index 6b0a5d6..728595f 100644
> --- a/fs/cifs/smb1ops.c
> +++ b/fs/cifs/smb1ops.c
> @@ -432,6 +432,8 @@ struct smb_version_operations smb1_operations = {
>  	.negotiate = cifs_negotiate,
>  	.sess_setup = CIFS_SessSetup,
>  	.logoff = CIFSSMBLogoff,
> +	.tree_connect = CIFSTCon,
> +	.tree_disconnect = CIFSSMBTDis,
>  };
>  
>  struct smb_version_values smb1_values = {

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
