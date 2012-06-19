From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 5/5] CIFS: Move protocol specific tcon/tdis code to
 ops struct
Date: Tue, 19 Jun 2012 08:59:40 -0700
Message-ID: <20120619085940.337536ed@corrin.poochiereds.net>
References: <1339223164-9721-1-git-send-email-pshilovsky@samba.org>
	<1339223164-9721-6-git-send-email-pshilovsky@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1339223164-9721-6-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat,  9 Jun 2012 10:26:04 +0400
Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> and rename variables around the code changes.
> 
> Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  fs/cifs/cifsglob.h  |    6 ++++
>  fs/cifs/cifsproto.h |    5 +--
>  fs/cifs/connect.c   |   71 ++++++++++++++++++++++++++++++---------------------
>  fs/cifs/smb1ops.c   |    2 +
>  4 files changed, 52 insertions(+), 32 deletions(-)
> 
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 812f27c..1266e2e 100644
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
>  	int (*logoff)(const int, struct cifs_ses *);
> +	/* connect to a server share */
> +	int (*tree_connect)(const int, struct cifs_ses *, const char *,
> +			    struct cifs_tcon *, const struct nls_table *);
> +	/* close tree connecion */
> +	int (*tree_disconnect)(const int, struct cifs_tcon *);
>  };
>  
>  struct smb_version_values {
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index 8e6cd38..2f4f661 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -183,9 +183,8 @@ extern int cifs_setup_session(const int xid, struct cifs_ses *ses,
>  			      struct nls_table *nls_info);
>  extern int CIFSSMBNegotiate(const int xid, struct cifs_ses *ses);
>  
> -extern int CIFSTCon(unsigned int xid, struct cifs_ses *ses,
> -			const char *tree, struct cifs_tcon *tcon,
> -			const struct nls_table *);
> +extern int CIFSTCon(const int xid, struct cifs_ses *ses, const char *tree,
> +		    struct cifs_tcon *tcon, const struct nls_table *);
>  
>  extern int CIFSFindFirst(const int xid, struct cifs_tcon *tcon,
>  		const char *searchName, const struct nls_table *nls_codepage,
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 9679352..d14bd45 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -2552,7 +2552,8 @@ cifs_put_tcon(struct cifs_tcon *tcon)
>  	spin_unlock(&cifs_tcp_ses_lock);
>  
>  	xid = GetXid();
> -	CIFSSMBTDis(xid, tcon);
> +	if (ses->server->ops->tree_disconnect)
> +		ses->server->ops->tree_disconnect(xid, tcon);
>  	_FreeXid(xid);
>  
>  	cifs_fscache_release_super_cookie(tcon);
> @@ -2577,6 +2578,11 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb_vol *volume_info)
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
> @@ -2599,13 +2605,15 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb_vol *volume_info)
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
> @@ -2614,10 +2622,11 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb_vol *volume_info)
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
> @@ -2751,37 +2760,41 @@ out:
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
> @@ -3758,7 +3771,7 @@ out:
>   * pointer may be NULL.
>   */
>  int
> -CIFSTCon(unsigned int xid, struct cifs_ses *ses,
> +CIFSTCon(const int xid, struct cifs_ses *ses,
>  	 const char *tree, struct cifs_tcon *tcon,
>  	 const struct nls_table *nls_codepage)
>  {
> diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
> index ba3071f..1a3f08c 100644
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

Looks fine other than the type change on the xid. Note too, that if you
wanted to just remove all of that xid stuff, I'd be even happier. Steve
seems to like it for some reason though, so we'll need to convince him.

IMO, it's just unnecessary clutter that gets in the way of the code
clarity. It's also very unclear that FreeXid() has a side effect (a
debug printk).

A better scheme would be to turn all of those FreeXid calls into an
explict cFYI that prints the name of the function and maybe the return
code. The xid could be replaced with current->pid, which would
eliminate GetXid.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
