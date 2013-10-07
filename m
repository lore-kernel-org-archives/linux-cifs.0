From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: Send a logoff request before removing a smb
 session
Date: Mon, 7 Oct 2013 06:50:16 -0400
Message-ID: <20131007065016.6502d81e@tlielax.poochiereds.net>
References: <1380913583-5506-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1380913583-5506-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri,  4 Oct 2013 14:06:23 -0500
shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> 
> Send a smb session logoff request before removing smb session off of the list.
> On a signed smb session, remvoing a session off of the list before sending
> a logoff request results in server returning an error for lack of
> smb signature.
>  
> If a server returns an error to a logoff request, log and error
> and keep the session on the list.
> 
> 
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/connect.c       | 32 +++++++++++++++++++++++++++-----
>  fs/cifs/smb2transport.c | 10 ++++++++--
>  fs/cifs/transport.c     | 11 +++++++++--
>  3 files changed, 44 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index a279ffc..ab3cc8d 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -2242,6 +2242,8 @@ cifs_find_smb_ses(struct TCP_Server_Info *server, struct smb_vol *vol)
>  
>  	spin_lock(&cifs_tcp_ses_lock);
>  	list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
> +		if (ses->status == CifsExiting)
> +			continue;
>  		if (!match_session(ses, vol))
>  			continue;
>  		++ses->ses_count;
> @@ -2255,24 +2257,44 @@ cifs_find_smb_ses(struct TCP_Server_Info *server, struct smb_vol *vol)
>  static void
>  cifs_put_smb_ses(struct cifs_ses *ses)
>  {
> -	unsigned int xid;
> +	unsigned int rc, xid;
>  	struct TCP_Server_Info *server = ses->server;
>  
>  	cifs_dbg(FYI, "%s: ses_count=%d\n", __func__, ses->ses_count);
> +
>  	spin_lock(&cifs_tcp_ses_lock);
> +	if (ses->status == CifsExiting) {
> +		spin_unlock(&cifs_tcp_ses_lock);
> +		return;
> +	}
>  	if (--ses->ses_count > 0) {
>  		spin_unlock(&cifs_tcp_ses_lock);
>  		return;
>  	}
> -
> -	list_del_init(&ses->smb_ses_list);
> +	if (ses->status == CifsGood)
> +		ses->status = CifsExiting;
>  	spin_unlock(&cifs_tcp_ses_lock);
>  
> -	if (ses->status == CifsGood && server->ops->logoff) {
> +	if (ses->status == CifsExiting && server->ops->logoff) {
>  		xid = get_xid();
> -		server->ops->logoff(xid, ses);
> +		rc = server->ops->logoff(xid, ses);
>  		_free_xid(xid);
> +
> +		if (rc) {
> +			cifs_dbg(VFS, "%s: Session Logoff failure rc=%d\n",
> +				__func__, rc);
> +			spin_lock(&cifs_tcp_ses_lock);
> +			++ses->ses_count;
> +			ses->status = CifsGood;
> +			spin_unlock(&cifs_tcp_ses_lock);
> +			return;
> +		}

This looks wrong.

With this patch, if ->logoff returns an error we'll end up just leaking
this reference. What's going to eventually clean it up?

>  	}
> +
> +	spin_lock(&cifs_tcp_ses_lock);
> +	list_del_init(&ses->smb_ses_list);
> +	spin_unlock(&cifs_tcp_ses_lock);
> +
>  	sesInfoFree(ses);
>  	cifs_put_tcp_session(server);
>  }
> diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
> index 340abca..ee1963b 100644
> --- a/fs/cifs/smb2transport.c
> +++ b/fs/cifs/smb2transport.c
> @@ -516,13 +516,19 @@ smb2_get_mid_entry(struct cifs_ses *ses, struct smb2_hdr *buf,
>  		return -EAGAIN;
>  	}
>  
> -	if (ses->status != CifsGood) {
> -		/* check if SMB2 session is bad because we are setting it up */
> +	if (ses->status == CifsNew) {
>  		if ((buf->Command != SMB2_SESSION_SETUP) &&
>  		    (buf->Command != SMB2_NEGOTIATE))
>  			return -EAGAIN;
>  		/* else ok - we are setting up session */
>  	}
> +
> +	if (ses->status == CifsExiting) {
> +		if (buf->Command != SMB2_LOGOFF)
> +			return -EAGAIN;
> +		/* else ok - we are shutting down the session */
> +	}
> +
>  	*mid = smb2_mid_entry_alloc(buf, ses->server);
>  	if (*mid == NULL)
>  		return -ENOMEM;
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index 800b938..ebb46e3 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -431,13 +431,20 @@ static int allocate_mid(struct cifs_ses *ses, struct smb_hdr *in_buf,
>  		return -EAGAIN;
>  	}
>  
> -	if (ses->status != CifsGood) {
> -		/* check if SMB session is bad because we are setting it up */
> +	if (ses->status == CifsNew) {
>  		if ((in_buf->Command != SMB_COM_SESSION_SETUP_ANDX) &&
>  			(in_buf->Command != SMB_COM_NEGOTIATE))
>  			return -EAGAIN;
>  		/* else ok - we are setting up session */
>  	}
> +
> +	if (ses->status == CifsExiting) {
> +		/* check if SMB session is bad because we are setting it up */
> +		if (in_buf->Command != SMB_COM_LOGOFF_ANDX)
> +			return -EAGAIN;
> +		/* else ok - we are shutting down session */
> +	}
> +
>  	*ppmidQ = AllocMidQEntry(in_buf, ses->server);
>  	if (*ppmidQ == NULL)
>  		return -ENOMEM;


-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
