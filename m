From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 4/5] CIFS: Move protocol specific session
 setup/logoff code to ops struct
Date: Tue, 19 Jun 2012 08:51:59 -0700
Message-ID: <20120619085159.6bac54fa@corrin.poochiereds.net>
References: <1339223164-9721-1-git-send-email-pshilovsky@samba.org>
	<1339223164-9721-5-git-send-email-pshilovsky@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1339223164-9721-5-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat,  9 Jun 2012 10:26:03 +0400
Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  fs/cifs/cifsglob.h  |    5 +++++
>  fs/cifs/cifsproto.h |    8 ++++----
>  fs/cifs/connect.c   |   16 +++++++++-------
>  fs/cifs/sess.c      |    2 +-
>  fs/cifs/smb1ops.c   |    2 ++
>  5 files changed, 21 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 669de88..812f27c 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -196,6 +196,11 @@ struct smb_version_operations {
>  	bool (*need_neg)(struct TCP_Server_Info *);
>  	/* negotiate to the server */
>  	int (*negotiate)(const int, struct cifs_ses *);
> +	/* setup smb sessionn */
> +	int (*sess_setup)(const int, struct cifs_ses *,
> +			  const struct nls_table *);
> +	/* close smb session */
> +	int (*logoff)(const int, struct cifs_ses *);
>  };
>  
>  struct smb_version_values {
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index 32b569f..8e6cd38 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -112,8 +112,8 @@ extern void header_assemble(struct smb_hdr *, char /* command */ ,
>  extern int small_smb_init_no_tc(const int smb_cmd, const int wct,
>  				struct cifs_ses *ses,
>  				void **request_buf);
> -extern int CIFS_SessSetup(unsigned int xid, struct cifs_ses *ses,
> -			     const struct nls_table *nls_cp);
> +extern int CIFS_SessSetup(const int xid, struct cifs_ses *ses,
> +			  const struct nls_table *nls_cp);
>  extern struct timespec cifs_NTtimeToUnix(__le64 utc_nanoseconds_since_1601);
>  extern u64 cifs_UnixTimeToNT(struct timespec);
>  extern struct timespec cnvrtDosUnixTm(__le16 le_date, __le16 le_time,
> @@ -179,8 +179,8 @@ void cifs_proc_init(void);
>  void cifs_proc_clean(void);
>  
>  extern int cifs_negotiate_protocol(const int xid, struct cifs_ses *ses);
> -extern int cifs_setup_session(unsigned int xid, struct cifs_ses *ses,
> -			struct nls_table *nls_info);
> +extern int cifs_setup_session(const int xid, struct cifs_ses *ses,
> +			      struct nls_table *nls_info);
>  extern int CIFSSMBNegotiate(const int xid, struct cifs_ses *ses);
>  
>  extern int CIFSTCon(unsigned int xid, struct cifs_ses *ses,
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 4780342..9679352 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -2263,9 +2263,9 @@ cifs_put_smb_ses(struct cifs_ses *ses)
>  	list_del_init(&ses->smb_ses_list);
>  	spin_unlock(&cifs_tcp_ses_lock);
>  
> -	if (ses->status == CifsGood) {
> +	if (ses->status == CifsGood && server->ops->logoff) {
>  		xid = GetXid();
> -		CIFSSMBLogoff(xid, ses);
> +		server->ops->logoff(xid, ses);
>  		_FreeXid(xid);
>  	}
>  	sesInfoFree(ses);
> @@ -3970,11 +3970,11 @@ cifs_negotiate_protocol(const int xid, struct cifs_ses *ses)
>  	return rc;
>  }
>  
> -
> -int cifs_setup_session(unsigned int xid, struct cifs_ses *ses,
> -			struct nls_table *nls_info)
> +int
> +cifs_setup_session(const int xid, struct cifs_ses *ses,
> +		   struct nls_table *nls_info)


While I think this whole "xid" thing is a bogus idea, if we're going to
do it, we should at least try to be consistent about the type. _GetXid
returns unsigned int but you're turning that into a signed int here.

I suggest that we don't do that. Let's declare henceforth that it's
unsigned. Any place that treats it as signed is a bug. We probably have
a lot of these bugs. I don't expect you to fix them all up, but you
should at least try to fix that up in the code that you're touching in
this series. We can get the rest later...

Sound ok?


>  {
> -	int rc = 0;
> +	int rc = -ENOSYS;
>  	struct TCP_Server_Info *server = ses->server;
>  
>  	ses->flags = 0;
> @@ -3985,7 +3985,9 @@ int cifs_setup_session(unsigned int xid, struct cifs_ses *ses,
>  	cFYI(1, "Security Mode: 0x%x Capabilities: 0x%x TimeAdjust: %d",
>  		 server->sec_mode, server->capabilities, server->timeAdj);
>  
> -	rc = CIFS_SessSetup(xid, ses, nls_info);
> +	if (server->ops->sess_setup)
> +		rc = server->ops->sess_setup(xid, ses, nls_info);
> +
>  	if (rc) {
>  		cERROR(1, "Send error in SessSetup = %d", rc);
>  	} else {
> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
> index f88fa4d..16b2083 100644
> --- a/fs/cifs/sess.c
> +++ b/fs/cifs/sess.c
> @@ -556,7 +556,7 @@ setup_ntlmv2_ret:
>  }
>  
>  int
> -CIFS_SessSetup(unsigned int xid, struct cifs_ses *ses,
> +CIFS_SessSetup(const int xid, struct cifs_ses *ses,
>  	       const struct nls_table *nls_cp)
>  {
>  	int rc = 0;
> diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
> index 5bfc26a..ba3071f 100644
> --- a/fs/cifs/smb1ops.c
> +++ b/fs/cifs/smb1ops.c
> @@ -430,6 +430,8 @@ struct smb_version_operations smb1_operations = {
>  	.check_trans2 = cifs_check_trans2,
>  	.need_neg = cifs_need_neg,
>  	.negotiate = cifs_negotiate,
> +	.sess_setup = CIFS_SessSetup,
> +	.logoff = CIFSSMBLogoff,
>  };
>  
>  struct smb_version_values smb1_values = {


-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
