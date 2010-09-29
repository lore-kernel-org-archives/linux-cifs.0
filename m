From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] cifs: prevent infinite recursion in cifs_reconnect_tcon
Date: Wed, 29 Sep 2010 16:00:26 -0400
Message-ID: <20100929160026.143d13c2@tlielax.poochiereds.net>
References: <1285788428-4864-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hramrach-aRb0bU7PRFPrBKCeMvbIDA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1285788428-4864-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 29 Sep 2010 15:27:08 -0400
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> cifs_reconnect_tcon is called from smb_init. After a successful
> reconnect, cifs_reconnect_tcon will call reset_cifs_unix_caps. That
> function will, in turn call CIFSSMBQFSUnixInfo and CIFSSMBSetFSUnixInfo.
> Those functions also call smb_init.
> 
> It's possible for the session and tcon reconnect to succeed, and then
> for another cifs_reconnect to occur before CIFSSMBQFSUnixInfo or
> CIFSSMBSetFSUnixInfo to be called. That'll cause those functions to call
> smb_init and cifs_reconnect_tcon again, ad infinitum...
> 
> Break the infinite recursion by having those functions use a new
> smb_init variant that doesn't attempt to perform a reconnect.
> 
> Reported-and-Tested-by: Michal Suchanek <hramrach-aRb0bU7PRFPrBKCeMvbIDA@public.gmane.org>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>


I should also note that this fixes the following kernel.org bug:

https://bugzilla.kernel.org/show_bug.cgi?id=18582

> ---
>  fs/cifs/cifssmb.c |   49 +++++++++++++++++++++++++++++++++----------------
>  1 files changed, 33 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index 13c854e..54bd83a 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -232,7 +232,7 @@ static int
>  small_smb_init(int smb_command, int wct, struct cifsTconInfo *tcon,
>  		void **request_buf)
>  {
> -	int rc = 0;
> +	int rc;
>  
>  	rc = cifs_reconnect_tcon(tcon, smb_command);
>  	if (rc)
> @@ -250,7 +250,7 @@ small_smb_init(int smb_command, int wct, struct cifsTconInfo *tcon,
>  	if (tcon != NULL)
>  		cifs_stats_inc(&tcon->num_smbs_sent);
>  
> -	return rc;
> +	return 0;
>  }
>  
>  int
> @@ -281,16 +281,9 @@ small_smb_init_no_tc(const int smb_command, const int wct,
>  
>  /* If the return code is zero, this function must fill in request_buf pointer */
>  static int
> -smb_init(int smb_command, int wct, struct cifsTconInfo *tcon,
> -	 void **request_buf /* returned */ ,
> -	 void **response_buf /* returned */ )
> +__smb_init(int smb_command, int wct, struct cifsTconInfo *tcon,
> +			void **request_buf, void **response_buf)
>  {
> -	int rc = 0;
> -
> -	rc = cifs_reconnect_tcon(tcon, smb_command);
> -	if (rc)
> -		return rc;
> -
>  	*request_buf = cifs_buf_get();
>  	if (*request_buf == NULL) {
>  		/* BB should we add a retry in here if not a writepage? */
> @@ -309,7 +302,31 @@ smb_init(int smb_command, int wct, struct cifsTconInfo *tcon,
>  	if (tcon != NULL)
>  		cifs_stats_inc(&tcon->num_smbs_sent);
>  
> -	return rc;
> +	return 0;
> +}
> +
> +/* If the return code is zero, this function must fill in request_buf pointer */
> +static int
> +smb_init(int smb_command, int wct, struct cifsTconInfo *tcon,
> +	 void **request_buf, void **response_buf)
> +{
> +	int rc;
> +
> +	rc = cifs_reconnect_tcon(tcon, smb_command);
> +	if (rc)
> +		return rc;
> +
> +	return __smb_init(smb_command, wct, tcon, request_buf, response_buf);
> +}
> +
> +static int
> +smb_init_no_reconnect(int smb_command, int wct, struct cifsTconInfo *tcon,
> +			void **request_buf, void **response_buf)
> +{
> +	if (tcon->ses->need_reconnect || tcon->need_reconnect)
> +		return -EHOSTDOWN;
> +
> +	return __smb_init(smb_command, wct, tcon, request_buf, response_buf);
>  }
>  
>  static int validate_t2(struct smb_t2_rsp *pSMB)
> @@ -4536,8 +4553,8 @@ CIFSSMBQFSUnixInfo(const int xid, struct cifsTconInfo *tcon)
>  
>  	cFYI(1, "In QFSUnixInfo");
>  QFSUnixRetry:
> -	rc = smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void **) &pSMB,
> -		      (void **) &pSMBr);
> +	rc = smb_init_no_reconnect(SMB_COM_TRANSACTION2, 15, tcon,
> +				   (void **) &pSMB, (void **) &pSMBr);
>  	if (rc)
>  		return rc;
>  
> @@ -4606,8 +4623,8 @@ CIFSSMBSetFSUnixInfo(const int xid, struct cifsTconInfo *tcon, __u64 cap)
>  	cFYI(1, "In SETFSUnixInfo");
>  SETFSUnixRetry:
>  	/* BB switch to small buf init to save memory */
> -	rc = smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void **) &pSMB,
> -		      (void **) &pSMBr);
> +	rc = smb_init_no_reconnect(SMB_COM_TRANSACTION2, 15, tcon,
> +					(void **) &pSMB, (void **) &pSMBr);
>  	if (rc)
>  		return rc;
>  


-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
