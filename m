From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 01/11] CIFS: Respect negotiated MaxMpxCount
Date: Sat, 17 Mar 2012 07:12:01 -0400
Message-ID: <20120317071201.7f28683b@tlielax.poochiereds.net>
References: <1331910574-998-1-git-send-email-piastry@etersoft.ru>
	<1331910574-998-2-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1331910574-998-2-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 16 Mar 2012 18:09:24 +0300
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> Some servers sets this value less than 50 that was hardcoded and
> we lost the connection if when we exceed this limit. Fix this by
> respecting this value - not sending more than the server allows.
> 
> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> ---
>  fs/cifs/cifsfs.c    |    8 ++++----
>  fs/cifs/cifsglob.h  |   10 +++-------
>  fs/cifs/cifssmb.c   |    9 +++++++--
>  fs/cifs/connect.c   |   11 ++++-------
>  fs/cifs/dir.c       |    6 ++++--
>  fs/cifs/file.c      |    4 ++--
>  fs/cifs/transport.c |    4 ++--
>  7 files changed, 26 insertions(+), 26 deletions(-)
> 
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index b1fd382..6ee1cb4 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -76,7 +76,7 @@ MODULE_PARM_DESC(cifs_min_small, "Small network buffers in pool. Default: 30 "
>  unsigned int cifs_max_pending = CIFS_MAX_REQ;
>  module_param(cifs_max_pending, int, 0444);
>  MODULE_PARM_DESC(cifs_max_pending, "Simultaneous requests to server. "
> -				   "Default: 50 Range: 2 to 256");
> +				   "Default: 32767 Range: 2 to 32767.");
>  unsigned short echo_retries = 5;
>  module_param(echo_retries, ushort, 0644);
>  MODULE_PARM_DESC(echo_retries, "Number of echo attempts before giving up and "
> @@ -1116,9 +1116,9 @@ init_cifs(void)
>  	if (cifs_max_pending < 2) {
>  		cifs_max_pending = 2;
>  		cFYI(1, "cifs_max_pending set to min of 2");
> -	} else if (cifs_max_pending > 256) {
> -		cifs_max_pending = 256;
> -		cFYI(1, "cifs_max_pending set to max of 256");
> +	} else if (cifs_max_pending > CIFS_MAX_REQ) {
> +		cifs_max_pending = CIFS_MAX_REQ;
> +		cFYI(1, "cifs_max_pending set to max of %u", CIFS_MAX_REQ);
>  	}
>  
>  	rc = cifs_fscache_register();
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 76e7d8b..d47d20a 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -55,14 +55,9 @@
>  
>  /*
>   * MAX_REQ is the maximum number of requests that WE will send
> - * on one socket concurrently. It also matches the most common
> - * value of max multiplex returned by servers.  We may
> - * eventually want to use the negotiated value (in case
> - * future servers can handle more) when we are more confident that
> - * we will not have problems oveloading the socket with pending
> - * write data.
> + * on one socket concurrently.
>   */
> -#define CIFS_MAX_REQ 50
> +#define CIFS_MAX_REQ 32767
>  
>  #define RFC1001_NAME_LEN 15
>  #define RFC1001_NAME_LEN_WITH_NULL (RFC1001_NAME_LEN + 1)
> @@ -263,6 +258,7 @@ struct TCP_Server_Info {
>  	bool session_estab; /* mark when very first sess is established */
>  	u16 dialect; /* dialect index that server chose */
>  	enum securityEnum secType;
> +	bool oplocks:1; /* enable oplocks */
>  	unsigned int maxReq;	/* Clients should submit no more */
>  	/* than maxReq distinct unanswered SMBs to the server when using  */
>  	/* multiplexed reads or writes */
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index 8b7794c..cd66b76 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -458,7 +458,10 @@ CIFSSMBNegotiate(unsigned int xid, struct cifs_ses *ses)
>  			goto neg_err_exit;
>  		}
>  		server->sec_mode = (__u8)le16_to_cpu(rsp->SecurityMode);
> -		server->maxReq = le16_to_cpu(rsp->MaxMpxCount);
> +		server->maxReq = min_t(unsigned int,
> +				       le16_to_cpu(rsp->MaxMpxCount),
> +				       cifs_max_pending);
> +		server->oplocks = server->maxReq > 1 ? enable_oplocks : false;
>  		server->maxBuf = le16_to_cpu(rsp->MaxBufSize);
>  		server->max_vcs = le16_to_cpu(rsp->MaxNumberVcs);
>  		/* even though we do not use raw we might as well set this
> @@ -564,7 +567,9 @@ CIFSSMBNegotiate(unsigned int xid, struct cifs_ses *ses)
>  
>  	/* one byte, so no need to convert this or EncryptionKeyLen from
>  	   little endian */
> -	server->maxReq = le16_to_cpu(pSMBr->MaxMpxCount);
> +	server->maxReq = min_t(unsigned int, le16_to_cpu(pSMBr->MaxMpxCount),
> +			       cifs_max_pending);
> +	server->oplocks = server->maxReq > 1 ? enable_oplocks : false;
>  	/* probably no need to store and check maxvcs */
>  	server->maxBuf = le32_to_cpu(pSMBr->MaxBufferSize);
>  	server->max_rw = le32_to_cpu(pSMBr->MaxRawSize);
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 602f77c..03f71fb 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -642,14 +642,10 @@ static void clean_demultiplex_info(struct TCP_Server_Info *server)
>  	spin_unlock(&GlobalMid_Lock);
>  	wake_up_all(&server->response_q);
>  
> -	/*
> -	 * Check if we have blocked requests that need to free. Note that
> -	 * cifs_max_pending is normally 50, but can be set at module install
> -	 * time to as little as two.
> -	 */
> +	/* Check if we have blocked requests that need to free. */
>  	spin_lock(&GlobalMid_Lock);
> -	if (atomic_read(&server->inFlight) >= cifs_max_pending)
> -		atomic_set(&server->inFlight, cifs_max_pending - 1);
> +	if (atomic_read(&server->inFlight) >= server->maxReq)
> +		atomic_set(&server->inFlight, server->maxReq - 1);
>  	/*
>  	 * We do not want to set the max_pending too low or we could end up
>  	 * with the counter going negative.
> @@ -1910,6 +1906,7 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
>  	tcp_ses->noautotune = volume_info->noautotune;
>  	tcp_ses->tcp_nodelay = volume_info->sockopt_tcp_nodelay;
>  	atomic_set(&tcp_ses->inFlight, 0);
> +	tcp_ses->maxReq = 1; /* enough to send negotiate request */
>  	init_waitqueue_head(&tcp_ses->response_q);
>  	init_waitqueue_head(&tcp_ses->request_q);
>  	INIT_LIST_HEAD(&tcp_ses->pending_mid_q);
> diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
> index bc7e244..d172c8e 100644
> --- a/fs/cifs/dir.c
> +++ b/fs/cifs/dir.c
> @@ -171,7 +171,7 @@ cifs_create(struct inode *inode, struct dentry *direntry, umode_t mode,
>  	}
>  	tcon = tlink_tcon(tlink);
>  
> -	if (enable_oplocks)
> +	if (tcon->ses->server->oplocks)
>  		oplock = REQ_OPLOCK;
>  
>  	if (nd)
> @@ -492,7 +492,7 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
>  {
>  	int xid;
>  	int rc = 0; /* to get around spurious gcc warning, set to zero here */
> -	__u32 oplock = enable_oplocks ? REQ_OPLOCK : 0;
> +	__u32 oplock;
>  	__u16 fileHandle = 0;
>  	bool posix_open = false;
>  	struct cifs_sb_info *cifs_sb;
> @@ -518,6 +518,8 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
>  	}
>  	pTcon = tlink_tcon(tlink);
>  
> +	oplock = pTcon->ses->server->oplocks ? REQ_OPLOCK : 0;
> +
>  	/*
>  	 * Don't allow the separator character in a path component.
>  	 * The VFS will not allow "/", but "\" is allowed by posix.
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 5e64748..4aa6080 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -380,7 +380,7 @@ int cifs_open(struct inode *inode, struct file *file)
>  	cFYI(1, "inode = 0x%p file flags are 0x%x for %s",
>  		 inode, file->f_flags, full_path);
>  
> -	if (enable_oplocks)
> +	if (tcon->ses->server->oplocks)
>  		oplock = REQ_OPLOCK;
>  	else
>  		oplock = 0;
> @@ -505,7 +505,7 @@ static int cifs_reopen_file(struct cifsFileInfo *pCifsFile, bool can_flush)
>  	cFYI(1, "inode = 0x%p file flags 0x%x for %s",
>  		 inode, pCifsFile->f_flags, full_path);
>  
> -	if (enable_oplocks)
> +	if (tcon->ses->server->oplocks)
>  		oplock = REQ_OPLOCK;
>  	else
>  		oplock = 0;
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index 0cc9584..99a27cf 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -265,12 +265,12 @@ static int wait_for_free_request(struct TCP_Server_Info *server,
>  
>  	spin_lock(&GlobalMid_Lock);
>  	while (1) {
> -		if (atomic_read(&server->inFlight) >= cifs_max_pending) {
> +		if (atomic_read(&server->inFlight) >= server->maxReq) {
>  			spin_unlock(&GlobalMid_Lock);
>  			cifs_num_waiters_inc(server);
>  			wait_event(server->request_q,
>  				   atomic_read(&server->inFlight)
> -				     < cifs_max_pending);
> +				     < server->maxReq);
>  			cifs_num_waiters_dec(server);
>  			spin_lock(&GlobalMid_Lock);
>  		} else {

Sorry, I probably should have made my earlier comment against this
email. If there are regressions from this series, they are likely going
to be quite difficult to track down. We need to ensure that we do this
in a way that makes that possible.

Introducing a behavior change like this at the beginning of the series
is probably a mistake. You'll have no reasonable way to bisect down
regressions, so you won't know if a problem is due to the change to a
credit-based model or due to changing the client to respect the maxmpx.

Instead of doing this, we should instead reorganize the code around a
credit based model first, while attempting to mimic the existing
behavior as closely as possible. Once that framework is in place, then
change the behavior and start respecting the maxmpx.

If you do that, then someone can reasonably bisect between those two
changes and we can determine the source of a regression.
-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
