From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] ntlmv2 within ntlmssp authenticate
Date: Tue, 7 Sep 2010 08:35:14 -0400
Message-ID: <20100907083514.63e94838@corrin.poochiereds.net>
References: <1283830523-25110-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1283830523-25110-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon,  6 Sep 2010 22:35:23 -0500
shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/cifsencrypt.c |   33 ++++++++++++--------
>  fs/cifs/cifsglob.h    |    2 +-
>  fs/cifs/cifsproto.h   |    2 +-
>  fs/cifs/sess.c        |   80 +++++++++++++++++++++++++++++++++---------------
>  fs/cifs/transport.c   |    6 ++--
>  5 files changed, 80 insertions(+), 43 deletions(-)
> 
> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
> index 5f0fc6b..5fbd19b 100644
> --- a/fs/cifs/cifsencrypt.c
> +++ b/fs/cifs/cifsencrypt.c
> @@ -80,7 +80,7 @@ int cifs_sign_smb(struct smb_hdr *cifs_pdu, struct TCP_Server_Info *server,
>  	server->sequence_number++;
>  	spin_unlock(&GlobalMid_Lock);
>  
> -	rc = cifs_calculate_signature(cifs_pdu, &server->mac_signing_key,
> +	rc = cifs_calculate_signature(cifs_pdu, &server->session_key,
>  				      smb_signature);
>  	if (rc)
>  		memset(cifs_pdu->Signature.SecuritySignature, 0, 8);
> @@ -147,7 +147,7 @@ int cifs_sign_smb2(struct kvec *iov, int n_vec, struct TCP_Server_Info *server,
>  	server->sequence_number++;
>  	spin_unlock(&GlobalMid_Lock);
>  
> -	rc = cifs_calc_signature2(iov, n_vec, &server->mac_signing_key,
> +	rc = cifs_calc_signature2(iov, n_vec, &server->session_key,
>  				      smb_signature);
>  	if (rc)
>  		memset(cifs_pdu->Signature.SecuritySignature, 0, 8);
> @@ -211,7 +211,7 @@ int cifs_verify_signature(struct smb_hdr *cifs_pdu,
>  }
>  
>  /* We fill in key by putting in 40 byte array which was allocated by caller */
> -int cifs_calculate_mac_key(struct session_key *key, const char *rn,
> +int cifs_calculate_session_key(struct session_key *key, const char *rn,
>  			   const char *password)
>  {
>  	char temp_key[16];
> @@ -319,7 +319,7 @@ static int calc_ntlmv2_hash(struct cifsSesInfo *ses,
>  {
>  	int rc = 0;
>  	int len;
> -	char nt_hash[16];
> +	char nt_hash[CIFS_NTHASH_SIZE];
>  	struct HMACMD5Context *pctxt;
>  	wchar_t *user;
>  	wchar_t *domain;
> @@ -377,7 +377,7 @@ int
>  setup_ntlmv2_rsp(struct cifsSesInfo *ses, char *resp_buf,
>  		      const struct nls_table *nls_cp)
>  {
> -	int rc;
> +	int rc = 0;
>  	struct ntlmv2_resp *buf = (struct ntlmv2_resp *)resp_buf;
>  	struct HMACMD5Context context;
>  
> @@ -404,11 +404,11 @@ setup_ntlmv2_rsp(struct cifsSesInfo *ses, char *resp_buf,
>  	/* now calculate the MAC key for NTLMv2 */
>  	hmac_md5_init_limK_to_64(ses->server->ntlmv2_hash, 16, &context);
>  	hmac_md5_update(resp_buf, 16, &context);
> -	hmac_md5_final(ses->server->mac_signing_key.data.ntlmv2.key, &context);
> +	hmac_md5_final(ses->server->session_key.data.ntlmv2.key, &context);
>  
> -	memcpy(&ses->server->mac_signing_key.data.ntlmv2.resp, resp_buf,
> +	memcpy(&ses->server->session_key.data.ntlmv2.resp, resp_buf,
>  	       sizeof(struct ntlmv2_resp));
> -	ses->server->mac_signing_key.len = 16 + sizeof(struct ntlmv2_resp);
> +	ses->server->session_key.len = 16 + sizeof(struct ntlmv2_resp);
>  
>  	return rc;
>  }
> @@ -418,11 +418,18 @@ void CalcNTLMv2_response(const struct cifsSesInfo *ses,
>  {
>  	struct HMACMD5Context context;
>  	/* rest of v2 struct already generated */
> -	memcpy(v2_session_response + 8, ses->server->cryptKey, 8);
> -	hmac_md5_init_limK_to_64(ses->server->ntlmv2_hash, 16, &context);
> -
> -	hmac_md5_update(v2_session_response+8,
> -			sizeof(struct ntlmv2_resp) - 8, &context);
> +	memcpy(v2_session_response + CIFS_SERVER_CHALLENGE_SIZE,
> +		ses->server->cryptKey, CIFS_SERVER_CHALLENGE_SIZE);
> +	hmac_md5_init_limK_to_64(ses->server->ntlmv2_hash,
> +		CIFS_HMAC_MD5_HASH_SIZE, &context);
> +
> +	hmac_md5_update(v2_session_response + CIFS_SERVER_CHALLENGE_SIZE,
> +		sizeof(struct ntlmv2_resp) - CIFS_SERVER_CHALLENGE_SIZE,
> +		&context);
> +
> +	if (ses->server->tilen)
> +		hmac_md5_update(ses->server->tiblob,
> +			ses->server->tilen, &context);
>  
>  	hmac_md5_final(v2_session_response, &context);
>  /*	cifs_dump_mem("v2_sess_rsp: ", v2_session_response, 32); */
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 6b7249e..f67a5d7 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -201,7 +201,7 @@ struct TCP_Server_Info {
>  	/* 16th byte of RFC1001 workstation name is always null */
>  	char workstation_RFC1001_name[RFC1001_NAME_LEN_WITH_NULL];
>  	__u32 sequence_number; /* needed for CIFS PDU signature */
> -	struct session_key mac_signing_key;
> +	struct session_key session_key;
>  	char ntlmv2_hash[16];
>  	unsigned long lstrp; /* when we got last response from this server */
>  	u16 dialect; /* dialect index that server chose */
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index ccc6d57..d1b9bc4 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -363,7 +363,7 @@ extern int cifs_sign_smb2(struct kvec *iov, int n_vec, struct TCP_Server_Info *,
>  extern int cifs_verify_signature(struct smb_hdr *,
>  				 const struct session_key *session_key,
>  				__u32 expected_sequence_number);
> -extern int cifs_calculate_mac_key(struct session_key *key, const char *rn,
> +extern int cifs_calculate_session_key(struct session_key *key, const char *rn,
>  				 const char *pass);
>  extern int CalcNTLMv2_partial_mac_key(struct cifsSesInfo *,
>  			const struct nls_table *);
> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
> index 6551b17..f7fc3dc 100644
> --- a/fs/cifs/sess.c
> +++ b/fs/cifs/sess.c
> @@ -442,7 +442,7 @@ static void build_ntlmssp_negotiate_blob(unsigned char *pbuffer,
>  	/* BB is NTLMV2 session security format easier to use here? */
>  	flags = NTLMSSP_NEGOTIATE_56 |	NTLMSSP_REQUEST_TARGET |
>  		NTLMSSP_NEGOTIATE_128 | NTLMSSP_NEGOTIATE_UNICODE |
> -		NTLMSSP_NEGOTIATE_NT_ONLY | NTLMSSP_NEGOTIATE_NTLM;
> +		NTLMSSP_NEGOTIATE_NTLM;
>  	if (ses->server->secMode &
>  	   (SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED))
>  		flags |= NTLMSSP_NEGOTIATE_SIGN;
> @@ -468,10 +468,12 @@ static int build_ntlmssp_auth_blob(unsigned char *pbuffer,
>  				   struct cifsSesInfo *ses,
>  				   const struct nls_table *nls_cp, bool first)
>  {
> +	int rc;
> +	unsigned int size;
>  	AUTHENTICATE_MESSAGE *sec_blob = (AUTHENTICATE_MESSAGE *)pbuffer;
>  	__u32 flags;
>  	unsigned char *tmp;
> -	char ntlm_session_key[CIFS_SESS_KEY_SIZE];
> +	struct ntlmv2_resp ntlmv2_response = {};
>  
>  	memcpy(sec_blob->Signature, NTLMSSP_SIGNATURE, 8);
>  	sec_blob->MessageType = NtLmAuthenticate;
> @@ -479,7 +481,7 @@ static int build_ntlmssp_auth_blob(unsigned char *pbuffer,
>  	flags = NTLMSSP_NEGOTIATE_56 |
>  		NTLMSSP_REQUEST_TARGET | NTLMSSP_NEGOTIATE_TARGET_INFO |
>  		NTLMSSP_NEGOTIATE_128 | NTLMSSP_NEGOTIATE_UNICODE |
> -		NTLMSSP_NEGOTIATE_NT_ONLY | NTLMSSP_NEGOTIATE_NTLM;
> +		NTLMSSP_NEGOTIATE_NTLM;
>  	if (ses->server->secMode &
>  	   (SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED))
>  		flags |= NTLMSSP_NEGOTIATE_SIGN;
> @@ -494,19 +496,25 @@ static int build_ntlmssp_auth_blob(unsigned char *pbuffer,
>  	sec_blob->LmChallengeResponse.Length = 0;
>  	sec_blob->LmChallengeResponse.MaximumLength = 0;
>  
> -	/* calculate session key,  BB what about adding similar ntlmv2 path? */
> -	SMBNTencrypt(ses->password, ses->server->cryptKey, ntlm_session_key);
> -	if (first)
> -		cifs_calculate_mac_key(&ses->server->mac_signing_key,
> -				       ntlm_session_key, ses->password);
> -
> -	memcpy(tmp, ntlm_session_key, CIFS_SESS_KEY_SIZE);
>  	sec_blob->NtChallengeResponse.BufferOffset = cpu_to_le32(tmp - pbuffer);
> -	sec_blob->NtChallengeResponse.Length = cpu_to_le16(CIFS_SESS_KEY_SIZE);
> -	sec_blob->NtChallengeResponse.MaximumLength =
> -				cpu_to_le16(CIFS_SESS_KEY_SIZE);
> +	rc = setup_ntlmv2_rsp(ses, (char *)&ntlmv2_response, nls_cp);
> +	if (rc) {
> +		cERROR(1, "error rc: %d during ntlmssp ntlmv2 setup", rc);
> +		goto setup_ntlmv2_ret;
> +	}
> +	size =  sizeof(struct ntlmv2_resp);
> +	memcpy(tmp, (char *)&ntlmv2_response, size);
> +	tmp += size;
> +	if (ses->server->tilen > 0) {
> +		memcpy(tmp, ses->server->tiblob, ses->server->tilen);
> +		tmp += ses->server->tilen;
> +	} else
> +		ses->server->tilen = 0;
>  
> -	tmp += CIFS_SESS_KEY_SIZE;
> +	sec_blob->NtChallengeResponse.Length = cpu_to_le16(size +
> +			ses->server->tilen);
> +	sec_blob->NtChallengeResponse.MaximumLength =
> +			cpu_to_le16(size + ses->server->tilen);
>  
>  	if (ses->domainName == NULL) {
>  		sec_blob->DomainName.BufferOffset = cpu_to_le32(tmp - pbuffer);
> @@ -518,7 +526,6 @@ static int build_ntlmssp_auth_blob(unsigned char *pbuffer,
>  		len = cifs_strtoUCS((__le16 *)tmp, ses->domainName,
>  				    MAX_USERNAME_SIZE, nls_cp);
>  		len *= 2; /* unicode is 2 bytes each */
> -		len += 2; /* trailing null */
>  		sec_blob->DomainName.BufferOffset = cpu_to_le32(tmp - pbuffer);
>  		sec_blob->DomainName.Length = cpu_to_le16(len);
>  		sec_blob->DomainName.MaximumLength = cpu_to_le16(len);
> @@ -535,7 +542,6 @@ static int build_ntlmssp_auth_blob(unsigned char *pbuffer,
>  		len = cifs_strtoUCS((__le16 *)tmp, ses->userName,
>  				    MAX_USERNAME_SIZE, nls_cp);
>  		len *= 2; /* unicode is 2 bytes each */
> -		len += 2; /* trailing null */
>  		sec_blob->UserName.BufferOffset = cpu_to_le32(tmp - pbuffer);
>  		sec_blob->UserName.Length = cpu_to_le16(len);
>  		sec_blob->UserName.MaximumLength = cpu_to_le16(len);
> @@ -551,6 +557,7 @@ static int build_ntlmssp_auth_blob(unsigned char *pbuffer,
>  	sec_blob->SessionKey.Length = 0;
>  	sec_blob->SessionKey.MaximumLength = 0;
>  
> +setup_ntlmv2_ret:
>  	if (ses->server->tilen > 0)
>  		kfree(ses->server->tiblob);
>  
> @@ -567,15 +574,14 @@ static void setup_ntlmssp_neg_req(SESSION_SETUP_ANDX *pSMB,
>  	return;
>  }
>  
> -static int setup_ntlmssp_auth_req(SESSION_SETUP_ANDX *pSMB,
> +static int setup_ntlmssp_auth_req(char *ntlmsspblob,
>  				  struct cifsSesInfo *ses,
>  				  const struct nls_table *nls, bool first_time)
>  {
>  	int bloblen;
>  
> -	bloblen = build_ntlmssp_auth_blob(&pSMB->req.SecurityBlob[0], ses, nls,
> +	bloblen = build_ntlmssp_auth_blob(ntlmsspblob, ses, nls,
>  					  first_time);
> -	pSMB->req.SecurityBlobLength = cpu_to_le16(bloblen);
>  
>  	return bloblen;
>  }
> @@ -711,7 +717,7 @@ ssetup_ntlmssp_authenticate:
>  
>  		if (first_time) /* should this be moved into common code
>  				  with similar ntlmv2 path? */
> -			cifs_calculate_mac_key(&ses->server->mac_signing_key,
> +			cifs_calculate_session_key(&ses->server->session_key,
>  				ntlm_session_key, ses->password);
>  		/* copy session key */
>  
> @@ -751,10 +757,19 @@ ssetup_ntlmssp_authenticate:
>  
>  		/* calculate session key */
>  		rc = setup_ntlmv2_rsp(ses, v2_sess_key, nls_cp);
> +		if (rc) {
> +			kfree(v2_sess_key);
> +			goto ssetup_exit;
> +		}
>  		memcpy(bcc_ptr, (char *)v2_sess_key,
>  		       sizeof(struct ntlmv2_resp));
>  		bcc_ptr += sizeof(struct ntlmv2_resp);
>  		kfree(v2_sess_key);
> +		if (ses->server->tilen > 0) {
> +			memcpy(bcc_ptr, ses->server->tiblob,
> +				ses->server->tilen);
> +			bcc_ptr += ses->server->tilen;
> +		}
>  		if (ses->capabilities & CAP_UNICODE) {
>  			if (iov[0].iov_len % 2) {
>  				*bcc_ptr = 0;
> @@ -785,15 +800,15 @@ ssetup_ntlmssp_authenticate:
>  		}
>  		/* bail out if key is too long */
>  		if (msg->sesskey_len >
> -		    sizeof(ses->server->mac_signing_key.data.krb5)) {
> +		    sizeof(ses->server->session_key.data.krb5)) {
>  			cERROR(1, "Kerberos signing key too long (%u bytes)",
>  				msg->sesskey_len);
>  			rc = -EOVERFLOW;
>  			goto ssetup_exit;
>  		}
>  		if (first_time) {
> -			ses->server->mac_signing_key.len = msg->sesskey_len;
> -			memcpy(ses->server->mac_signing_key.data.krb5,
> +			ses->server->session_key.len = msg->sesskey_len;
> +			memcpy(ses->server->session_key.data.krb5,
>  				msg->data, msg->sesskey_len);
>  		}
>  		pSMB->req.hdr.Flags2 |= SMBFLG2_EXT_SEC;
> @@ -835,12 +850,28 @@ ssetup_ntlmssp_authenticate:
>  			if (phase == NtLmNegotiate) {
>  				setup_ntlmssp_neg_req(pSMB, ses);
>  				iov[1].iov_len = sizeof(NEGOTIATE_MESSAGE);
> +				iov[1].iov_base = &pSMB->req.SecurityBlob[0];
>  			} else if (phase == NtLmAuthenticate) {
>  				int blob_len;
> -				blob_len = setup_ntlmssp_auth_req(pSMB, ses,
> +				char *ntlmsspblob;
> +
> +				ntlmsspblob = kmalloc(5 *
						^^^^^^^^^^
						Why 5 here?

> +					sizeof(struct _AUTHENTICATE_MESSAGE),
> +					GFP_KERNEL);
> +				if (!ntlmsspblob) {
> +					cERROR(1, "Can't allocate NTLMSSP");
> +					rc = -ENOMEM;
> +					goto ssetup_exit;
> +				}
> +
> +				blob_len = setup_ntlmssp_auth_req(ntlmsspblob,
> +								ses,
>  								  nls_cp,
>  								  first_time);
>  				iov[1].iov_len = blob_len;
> +				iov[1].iov_base = ntlmsspblob;
> +				pSMB->req.SecurityBlobLength =
> +					cpu_to_le16(blob_len);
>  				/* Make sure that we tell the server that we
>  				   are using the uid that it just gave us back
>  				   on the response (challenge) */
> @@ -850,7 +881,6 @@ ssetup_ntlmssp_authenticate:
>  				rc = -ENOSYS;
>  				goto ssetup_exit;
>  			}
> -			iov[1].iov_base = &pSMB->req.SecurityBlob[0];
>  			/* unicode strings must be word aligned */
>  			if ((iov[0].iov_len + iov[1].iov_len) % 2) {
>  				*bcc_ptr = 0;
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index 82f78c4..a66c91e 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -543,7 +543,7 @@ SendReceive2(const unsigned int xid, struct cifsSesInfo *ses,
>  		    (ses->server->secMode & (SECMODE_SIGN_REQUIRED |
>  					     SECMODE_SIGN_ENABLED))) {
>  			rc = cifs_verify_signature(midQ->resp_buf,
> -						&ses->server->mac_signing_key,
> +						&ses->server->session_key,
>  						midQ->sequence_number+1);
>  			if (rc) {
>  				cERROR(1, "Unexpected SMB signature");
> @@ -731,7 +731,7 @@ SendReceive(const unsigned int xid, struct cifsSesInfo *ses,
>  		    (ses->server->secMode & (SECMODE_SIGN_REQUIRED |
>  					     SECMODE_SIGN_ENABLED))) {
>  			rc = cifs_verify_signature(out_buf,
> -						&ses->server->mac_signing_key,
> +						&ses->server->session_key,
>  						midQ->sequence_number+1);
>  			if (rc) {
>  				cERROR(1, "Unexpected SMB signature");
> @@ -981,7 +981,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifsTconInfo *tcon,
>  	    (ses->server->secMode & (SECMODE_SIGN_REQUIRED |
>  				     SECMODE_SIGN_ENABLED))) {
>  		rc = cifs_verify_signature(out_buf,
> -					   &ses->server->mac_signing_key,
> +					   &ses->server->session_key,
>  					   midQ->sequence_number+1);
>  		if (rc) {
>  			cERROR(1, "Unexpected SMB signature");


-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
