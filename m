From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/7 cifs] ntlm authentication and signing - Calculate
 auth response per smb session
Date: Mon, 4 Oct 2010 07:02:12 -0400
Message-ID: <20101004070212.74b7968f@tlielax.poochiereds.net>
References: <1285771177-23146-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1285771177-23146-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 29 Sep 2010 09:39:37 -0500
shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> 
> Start calculation auth response within a session.  Move/Add pertinet
> data structures like session key, server challenge and ntlmv2_hash in
> a session structure.  We should do the calculations within a session 
> before copying session key and response over to server data
> structures because a session setup can fail.
> 
> 
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/cifsencrypt.c |   16 ++++++++--------
>  fs/cifs/cifsglob.h    |    6 ++++--
>  fs/cifs/cifssmb.c     |    4 ++--
>  fs/cifs/connect.c     |    7 ++++---
>  fs/cifs/sess.c        |   17 ++++++++---------
>  5 files changed, 26 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
> index 7ca9c80..0dda565 100644
> --- a/fs/cifs/cifsencrypt.c
> +++ b/fs/cifs/cifsencrypt.c
> @@ -458,7 +458,7 @@ calc_exit_1:
>  calc_exit_2:
>  	/* BB FIXME what about bytes 24 through 40 of the signing key?
>  	   compare with the NTLM example */
> -	hmac_md5_final(ses->server->ntlmv2_hash, pctxt);
> +	hmac_md5_final(ses->ntlmv2_hash, pctxt);
>  
>  	kfree(pctxt);
>  	return rc;
> @@ -502,14 +502,14 @@ setup_ntlmv2_rsp(struct cifsSesInfo *ses, char *resp_buf,
>  	}
>  	CalcNTLMv2_response(ses, resp_buf);
>  
> -	/* now calculate the MAC key for NTLMv2 */
> -	hmac_md5_init_limK_to_64(ses->server->ntlmv2_hash, 16, &context);
> +	/* now calculate the session key for NTLMv2 */
> +	hmac_md5_init_limK_to_64(ses->ntlmv2_hash, 16, &context);
>  	hmac_md5_update(resp_buf, 16, &context);
> -	hmac_md5_final(ses->server->session_key.data.ntlmv2.key, &context);
> +	hmac_md5_final(ses->auth_key.data.ntlmv2.key, &context);
>  
> -	memcpy(&ses->server->session_key.data.ntlmv2.resp, resp_buf,
> +	memcpy(&ses->auth_key.data.ntlmv2.resp, resp_buf,
>  	       sizeof(struct ntlmv2_resp));
> -	ses->server->session_key.len = 16 + sizeof(struct ntlmv2_resp);
> +	ses->auth_key.len = 16 + sizeof(struct ntlmv2_resp);
>  
>  	return 0;
>  
> @@ -526,8 +526,8 @@ void CalcNTLMv2_response(const struct cifsSesInfo *ses,
>  {
>  	struct HMACMD5Context context;
>  	/* rest of v2 struct already generated */
> -	memcpy(v2_session_response + 8, ses->server->cryptKey, 8);
> -	hmac_md5_init_limK_to_64(ses->server->ntlmv2_hash, 16, &context);
> +	memcpy(v2_session_response + 8, ses->cryptKey, 8);
> +	hmac_md5_init_limK_to_64(ses->ntlmv2_hash, 16, &context);
>  
>  	hmac_md5_update(v2_session_response+8,
>  			sizeof(struct ntlmv2_resp) - 8, &context);
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index c265ebd..4ae331c 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -179,12 +179,10 @@ struct TCP_Server_Info {
>  	int capabilities; /* allow selective disabling of caps by smb sess */
>  	int timeAdj;  /* Adjust for difference in server time zone in sec */
>  	__u16 CurrentMid;         /* multiplex id - rotating counter */
> -	char cryptKey[CIFS_CRYPTO_KEY_SIZE];
>  	/* 16th byte of RFC1001 workstation name is always null */
>  	char workstation_RFC1001_name[RFC1001_NAME_LEN_WITH_NULL];
>  	__u32 sequence_number; /* needed for CIFS PDU signature */
>  	struct session_key session_key;
> -	char ntlmv2_hash[16];
>  	unsigned long lstrp; /* when we got last response from this server */
>  	u16 dialect; /* dialect index that server chose */
>  	/* extended security flavors that server supports */
> @@ -192,6 +190,7 @@ struct TCP_Server_Info {
>  	bool	sec_mskerberos;		/* supports legacy MS Kerberos */
>  	bool	sec_kerberosu2u;	/* supports U2U Kerberos */
>  	bool	sec_ntlmssp;		/* supports NTLMSSP */
> +	bool session_estab; /* mark when very first sess is established */
>  #ifdef CONFIG_CIFS_FSCACHE
>  	struct fscache_cookie   *fscache; /* client index cache cookie */
>  #endif
> @@ -223,6 +222,9 @@ struct cifsSesInfo {
>  	char userName[MAX_USERNAME_SIZE + 1];
>  	char *domainName;
>  	char *password;
> +	char cryptKey[CIFS_CRYPTO_KEY_SIZE];
> +	struct session_key auth_key;
> +	char ntlmv2_hash[16];
>  	unsigned int tilen; /* length of the target info blob */
>  	unsigned char *tiblob; /* target info blob in challenge response */
>  	bool need_reconnect:1; /* connection reset, uid now invalid */
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index 13c854e..0dbc51c 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -486,7 +486,7 @@ CIFSSMBNegotiate(unsigned int xid, struct cifsSesInfo *ses)
>  
>  		if (rsp->EncryptionKeyLength ==
>  				cpu_to_le16(CIFS_CRYPTO_KEY_SIZE)) {
> -			memcpy(server->cryptKey, rsp->EncryptionKey,
> +			memcpy(ses->cryptKey, rsp->EncryptionKey,
>  				CIFS_CRYPTO_KEY_SIZE);
>  		} else if (server->secMode & SECMODE_PW_ENCRYPT) {
>  			rc = -EIO; /* need cryptkey unless plain text */
> @@ -557,7 +557,7 @@ CIFSSMBNegotiate(unsigned int xid, struct cifsSesInfo *ses)
>  	server->timeAdj = (int)(__s16)le16_to_cpu(pSMBr->ServerTimeZone);
>  	server->timeAdj *= 60;
>  	if (pSMBr->EncryptionKeyLength == CIFS_CRYPTO_KEY_SIZE) {
> -		memcpy(server->cryptKey, pSMBr->u.EncryptionKey,
> +		memcpy(ses->cryptKey, pSMBr->u.EncryptionKey,
>  		       CIFS_CRYPTO_KEY_SIZE);
>  	} else if ((pSMBr->hdr.Flags2 & SMBFLG2_EXT_SEC)
>  			&& (pSMBr->EncryptionKeyLength == 0)) {
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index f6a3091..12a6e20 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -200,6 +200,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
>  			if (server->tcpStatus != CifsExiting)
>  				server->tcpStatus = CifsGood;
>  			server->sequence_number = 0;
> +			server->session_estab = false;
>  			spin_unlock(&GlobalMid_Lock);
>  	/*		atomic_set(&server->inFlight,0);*/
>  			wake_up(&server->response_q);
> @@ -1616,6 +1617,7 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
>  		volume_info->source_rfc1001_name, RFC1001_NAME_LEN_WITH_NULL);
>  	memcpy(tcp_ses->server_RFC1001_name,
>  		volume_info->target_rfc1001_name, RFC1001_NAME_LEN_WITH_NULL);
> +	tcp_ses->session_estab = false;
>  	tcp_ses->sequence_number = 0;
>  	INIT_LIST_HEAD(&tcp_ses->tcp_ses_list);
>  	INIT_LIST_HEAD(&tcp_ses->smb_ses_list);
> @@ -2914,14 +2916,13 @@ CIFSTCon(unsigned int xid, struct cifsSesInfo *ses,
>  #ifdef CONFIG_CIFS_WEAK_PW_HASH
>  		if ((global_secflags & CIFSSEC_MAY_LANMAN) &&
>  		    (ses->server->secType == LANMAN))
> -			calc_lanman_hash(tcon->password, ses->server->cryptKey,
> +			calc_lanman_hash(tcon->password, ses->cryptKey,
>  					 ses->server->secMode &
>  					    SECMODE_PW_ENCRYPT ? true : false,
>  					 bcc_ptr);
>  		else
>  #endif /* CIFS_WEAK_PW_HASH */
> -		SMBNTencrypt(tcon->password, ses->server->cryptKey,
> -			     bcc_ptr);
> +		SMBNTencrypt(tcon->password, ses->cryptKey, bcc_ptr);
>  
>  		bcc_ptr += CIFS_SESS_KEY_SIZE;
>  		if (ses->capabilities & CAP_UNICODE) {
> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
> index 9148fd8..d632331 100644
> --- a/fs/cifs/sess.c
> +++ b/fs/cifs/sess.c
> @@ -402,7 +402,7 @@ static int decode_ntlmssp_challenge(char *bcc_ptr, int blob_len,
>  		return -EINVAL;
>  	}
>  
> -	memcpy(ses->server->cryptKey, pblob->Challenge, CIFS_CRYPTO_KEY_SIZE);
> +	memcpy(ses->cryptKey, pblob->Challenge, CIFS_CRYPTO_KEY_SIZE);
>  	/* BB we could decode pblob->NegotiateFlags; some may be useful */
>  	/* In particular we can examine sign flags */
>  	/* BB spec says that if AvId field of MsvAvTimestamp is populated then
> @@ -672,7 +672,7 @@ ssetup_ntlmssp_authenticate:
>  		/* BB calculate hash with password */
>  		/* and copy into bcc */
>  
> -		calc_lanman_hash(ses->password, ses->server->cryptKey,
> +		calc_lanman_hash(ses->password, ses->cryptKey,
>  				 ses->server->secMode & SECMODE_PW_ENCRYPT ?
>  					true : false, lnm_session_key);
>  
> @@ -699,12 +699,11 @@ ssetup_ntlmssp_authenticate:
>  			cpu_to_le16(CIFS_SESS_KEY_SIZE);
>  
>  		/* calculate session key */
> -		SMBNTencrypt(ses->password, ses->server->cryptKey,
> -			     ntlm_session_key);
> +		SMBNTencrypt(ses->password, ses->cryptKey, ntlm_session_key);
>  
>  		if (first_time) /* should this be moved into common code
> -				  with similar ntlmv2 path? */
> -			cifs_calculate_session_key(&ses->server->session_key,
> +				   with similar ntlmv2 path? */
> +			cifs_calculate_session_key(&ses->auth_key,
>  				ntlm_session_key, ses->password);
>  		/* copy session key */
>  
> @@ -794,15 +793,15 @@ ssetup_ntlmssp_authenticate:
>  		}
>  		/* bail out if key is too long */
>  		if (msg->sesskey_len >
> -		    sizeof(ses->server->session_key.data.krb5)) {
> +		    sizeof(ses->auth_key.data.krb5)) {
>  			cERROR(1, "Kerberos signing key too long (%u bytes)",
>  				msg->sesskey_len);
>  			rc = -EOVERFLOW;
>  			goto ssetup_exit;
>  		}
>  		if (first_time) {
> -			ses->server->session_key.len = msg->sesskey_len;
> -			memcpy(ses->server->session_key.data.krb5,
> +			ses->auth_key.len = msg->sesskey_len;
> +			memcpy(ses->auth_key.data.krb5,
>  				msg->data, msg->sesskey_len);
>  		}
>  		pSMB->req.hdr.Flags2 |= SMBFLG2_EXT_SEC;

Ok, so basically this moves all of the session key data structures from
the server to session. Once you calculate the key however and have a
successful session setup, don't you need to copy that key from the
session to the server? Where does that happen?

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
