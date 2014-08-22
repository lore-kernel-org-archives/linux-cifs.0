From: Simo <simo-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 1/7] cifs: Bypass windows extended security for ntlmv2
 negotiate
Date: Fri, 22 Aug 2014 00:27:06 -0400
Message-ID: <1408681626.11134.20.camel@pico.ipa.ssimo.org>
References: <003401cfbc62$f505f920$df11eb60$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: 'Steve French' <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	'Shirish Pargaonkar' <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	'Pavel Shilovsky' <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ashish Sangwan <a.sangwan-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
To: Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <003401cfbc62$f505f920$df11eb60$@samsung.com>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 2014-08-20 at 19:39 +0900, Namjae Jeon wrote:
> Windows machine has extended security feature which refuse to allow
> authentication when there is time difference between server time and
> client time when ntlmv2 negotiation is used. This problem is prevalent
> in embedded enviornment where system time is set to default 1970.
> 
> We don't know yet the exact threshold for the time difference at which
> the connection is refused but one comment in cifs code suggest that it
> is around 5 minutes.
> 
> This patch tries to solve this problem by sending the received server
> time during negotiate process as the current client time.
> 
> Signed-off-by: Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
> Signed-off-by: Ashish Sangwan <a.sangwan-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
> ---
>  fs/cifs/cifsencrypt.c |    4 ++--
>  fs/cifs/cifsglob.h    |    2 ++
>  fs/cifs/cifssmb.c     |    2 ++
>  fs/cifs/smb2pdu.c     |    1 +
>  4 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
> index 4934347..d5cec81 100644
> --- a/fs/cifs/cifsencrypt.c
> +++ b/fs/cifs/cifsencrypt.c
> @@ -671,8 +671,8 @@ setup_ntlmv2_rsp(struct cifs_ses *ses, const struct nls_table *nls_cp)
>  			(ses->auth_key.response + CIFS_SESS_KEY_SIZE);
>  	ntlmv2->blob_signature = cpu_to_le32(0x00000101);
>  	ntlmv2->reserved = 0;
> -	/* Must be within 5 minutes of the server */
> -	ntlmv2->time = cpu_to_le64(cifs_UnixTimeToNT(CURRENT_TIME));
> +	/* Hack to get around windows extended security */
> +	ntlmv2->time = cpu_to_le64(ses->serverTime);
>  	get_random_bytes(&ntlmv2->client_chal, sizeof(ntlmv2->client_chal));
>  	ntlmv2->reserved2 = 0;
>  
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index ce24c1f..9344c94 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -796,6 +796,8 @@ struct cifs_ses {
>  	enum securityEnum sectype; /* what security flavor was specified? */
>  	bool sign;		/* is signing required? */
>  	bool need_reconnect:1; /* connection reset, uid now invalid */
> +	__u64   serverTime;	/* Keeps a track of server time sent by server
> +				   during negotiate response */
>  #ifdef CONFIG_CIFS_SMB2
>  	__u16 session_flags;
>  	char smb3signingkey[SMB3_SIGN_KEY_SIZE]; /* for signing smb3 packets */
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index 86a2aa5..ead2da0 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -584,6 +584,8 @@ CIFSSMBNegotiate(const unsigned int xid, struct cifs_ses *ses)
>  	if (rc != 0)
>  		goto neg_err_exit;
>  
> +	ses->serverTime = le32_to_cpu(pSMBr->SystemTimeLow);
> +	ses->serverTime |= ((__u64)le32_to_cpu(pSMBr->SystemTimeHigh) << 32);
>  	server->dialect = le16_to_cpu(pSMBr->DialectIndex);
>  	cifs_dbg(FYI, "Dialect: %d\n", server->dialect);
>  	/* Check wct = 1 error case */
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index ed42234..a40f492 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -381,6 +381,7 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
>  	if (rc != 0)
>  		goto neg_exit;
>  
> +	ses->serverTime = le64_to_cpu(rsp->SystemTime);
>  	cifs_dbg(FYI, "mode 0x%x\n", rsp->SecurityMode);
>  
>  	/* BB we may eventually want to match the negotiated vs. requested

This patch is not addressing the problem in the correct way.
The server should send the time in the challenge message targetinfo data
(see MS-NLMP and search for MsvAvTimestamp in 2.2.2.1 and 3..5.1.2),
only if it is not available the currentime should be used (if you have
to pick the current time I guess you can employ tricks to try to get one
as close as possible to the server time by other means).

It is not clear to me whether the code parses the challenge messages's
targetinfo field, if it doesn't it should.

Simo.
