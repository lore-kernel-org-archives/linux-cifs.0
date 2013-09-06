From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 3/3]     cifs: Start using per session key for smb2/3
 for signature generation
Date: Fri, 6 Sep 2013 09:18:55 -0400
Message-ID: <20130906091855.1e17b07b@corrin.poochiereds.net>
References: <1377783311-3924-1-git-send-email-shirishpargaonkar@gmail.com>
	<1377783311-3924-4-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1377783311-3924-4-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 29 Aug 2013 08:35:11 -0500
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

>     Switch smb2 code to use per session session key and smb3 code to
>     use per session signing key instead of per connection key to
>     generate signatures.
> 
>     For that, we need to find a session to fetch the session key to
>     generate signature to match for every request and response packet.
> 
>     We also forgo checking signature for a session setup response
>     from the server.
> ---
>  fs/cifs/cifsglob.h      |  5 ++--
>  fs/cifs/cifsproto.h     |  2 +-
>  fs/cifs/smb2pdu.c       | 14 ++++++++--
>  fs/cifs/smb2transport.c | 70 ++++++++++++++++++++++++++++++++++++-------------
>  4 files changed, 67 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index cce26a8..18e623e 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -367,8 +367,7 @@ struct smb_version_operations {
>  	void (*set_lease_key)(struct inode *, struct cifs_fid *fid);
>  	/* generate new lease key */
>  	void (*new_lease_key)(struct cifs_fid *fid);
> -	/* The next two functions will need to be changed to per smb session */
> -	void (*generate_signingkey)(struct TCP_Server_Info *server);
> +	int (*generate_signingkey)(struct cifs_ses *);
>  	int (*calc_signature)(struct smb_rqst *rqst,
>  				   struct TCP_Server_Info *server);
>  	int (*query_mf_symlink)(const unsigned char *path, char *pbuf,
> @@ -549,7 +548,6 @@ struct TCP_Server_Info {
>  	int timeAdj;  /* Adjust for difference in server time zone in sec */
>  	__u64 CurrentMid;         /* multiplex id - rotating counter */
>  	char cryptkey[CIFS_CRYPTO_KEY_SIZE]; /* used by ntlm, ntlmv2 etc */
> -	char smb3signingkey[SMB3_SIGN_KEY_SIZE]; /* for signing smb3 packets */
>  	/* 16th byte of RFC1001 workstation name is always null */
>  	char workstation_RFC1001_name[RFC1001_NAME_LEN_WITH_NULL];
>  	__u32 sequence_number; /* for signing, protected by srv_mutex */
> @@ -732,6 +730,7 @@ struct cifs_ses {
>  	bool need_reconnect:1; /* connection reset, uid now invalid */
>  #ifdef CONFIG_CIFS_SMB2
>  	__u16 session_flags;
> +	char smb3signingkey[SMB3_SIGN_KEY_SIZE]; /* for signing smb3 packets */
>  #endif /* CONFIG_CIFS_SMB2 */
>  };
>  
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index b29a012..e0b2826 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -435,7 +435,7 @@ extern int setup_ntlm_response(struct cifs_ses *, const struct nls_table *);
>  extern int setup_ntlmv2_rsp(struct cifs_ses *, const struct nls_table *);
>  extern void cifs_crypto_shash_release(struct TCP_Server_Info *);
>  extern int calc_seckey(struct cifs_ses *);
> -extern void generate_smb3signingkey(struct TCP_Server_Info *);
> +extern int generate_smb3signingkey(struct cifs_ses *);
>  
>  #ifdef CONFIG_CIFS_WEAK_PW_HASH
>  extern int calc_lanman_hash(const char *password, const char *cryptkey,
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 28083b4..6385482 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -639,11 +639,20 @@ ssetup_exit:
>  
>  	if (!rc) {
>  		mutex_lock(&server->srv_mutex);
> +		if (server->sign && server->ops->generate_signingkey) {
> +			rc = server->ops->generate_signingkey(ses);
> +			kfree(ses->auth_key.response);
> +			ses->auth_key.response = NULL;
> +			if (rc) {
> +				cifs_dbg(FYI,
> +					"SMB3 session key generation failed\n");
> +				mutex_unlock(&server->srv_mutex);
> +				goto keygen_exit;
> +			}
> +		}
>  		if (!server->session_estab) {
>  			server->sequence_number = 0x2;
>  			server->session_estab = true;
> -			if (server->ops->generate_signingkey)
> -				server->ops->generate_signingkey(server);
>  		}
>  		mutex_unlock(&server->srv_mutex);
>  
> @@ -654,6 +663,7 @@ ssetup_exit:
>  		spin_unlock(&GlobalMid_Lock);
>  	}
>  
> +keygen_exit:
>  	if (!server->sign) {
>  		kfree(ses->auth_key.response);
>  		ses->auth_key.response = NULL;
> diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
> index 4f2300d..340abca 100644
> --- a/fs/cifs/smb2transport.c
> +++ b/fs/cifs/smb2transport.c
> @@ -114,6 +114,23 @@ smb3_crypto_shash_allocate(struct TCP_Server_Info *server)
>  	return 0;
>  }
>  
> +static struct cifs_ses *
> +smb2_find_smb_ses(struct smb2_hdr *smb2hdr, struct TCP_Server_Info *server)
> +{
> +	struct cifs_ses *ses;
> +
> +	spin_lock(&cifs_tcp_ses_lock);
> +	list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
> +		if (ses->Suid != smb2hdr->SessionId)
> +			continue;
> +		spin_unlock(&cifs_tcp_ses_lock);
> +		return ses;
> +	}
> +	spin_unlock(&cifs_tcp_ses_lock);
> +
> +	return NULL;
> +}
> +
>  
>  int
>  smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
> @@ -124,6 +141,13 @@ smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
>  	struct kvec *iov = rqst->rq_iov;
>  	int n_vec = rqst->rq_nvec;
>  	struct smb2_hdr *smb2_pdu = (struct smb2_hdr *)iov[0].iov_base;
> +	struct cifs_ses *ses;
> +
> +	ses = smb2_find_smb_ses(smb2_pdu, server);
> +	if (!ses) {
> +		cifs_dbg(VFS, "%s: Could not find session\n", __func__);
> +		return 0;
> +	}
>  
>  	memset(smb2_signature, 0x0, SMB2_HMACSHA256_SIZE);
>  	memset(smb2_pdu->Signature, 0x0, SMB2_SIGNATURE_SIZE);
> @@ -135,7 +159,7 @@ smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
>  	}
>  
>  	rc = crypto_shash_setkey(server->secmech.hmacsha256,
> -		server->session_key.response, SMB2_NTLMV2_SESSKEY_SIZE);
> +		ses->auth_key.response, SMB2_NTLMV2_SESSKEY_SIZE);
>  	if (rc) {
>  		cifs_dbg(VFS, "%s: Could not update with response\n", __func__);
>  		return rc;
> @@ -198,8 +222,8 @@ smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
>  	return rc;
>  }
>  
> -void
> -generate_smb3signingkey(struct TCP_Server_Info *server)
> +int
> +generate_smb3signingkey(struct cifs_ses *ses)
>  {
>  	unsigned char zero = 0x0;
>  	__u8 i[4] = {0, 0, 0, 1};
> @@ -209,90 +233,99 @@ generate_smb3signingkey(struct TCP_Server_Info *server)
>  	unsigned char *hashptr = prfhash;
>  
>  	memset(prfhash, 0x0, SMB2_HMACSHA256_SIZE);
> -	memset(server->smb3signingkey, 0x0, SMB3_SIGNKEY_SIZE);
> +	memset(ses->smb3signingkey, 0x0, SMB3_SIGNKEY_SIZE);
>  
> -	rc = smb3_crypto_shash_allocate(server);
> +	rc = smb3_crypto_shash_allocate(ses->server);
>  	if (rc) {
>  		cifs_dbg(VFS, "%s: crypto alloc failed\n", __func__);
>  		goto smb3signkey_ret;
>  	}
>  
> -	rc = crypto_shash_setkey(server->secmech.hmacsha256,
> -		server->session_key.response, SMB2_NTLMV2_SESSKEY_SIZE);
> +	rc = crypto_shash_setkey(ses->server->secmech.hmacsha256,
> +		ses->auth_key.response, SMB2_NTLMV2_SESSKEY_SIZE);
>  	if (rc) {
>  		cifs_dbg(VFS, "%s: Could not set with session key\n", __func__);
>  		goto smb3signkey_ret;
>  	}
>  
> -	rc = crypto_shash_init(&server->secmech.sdeschmacsha256->shash);
> +	rc = crypto_shash_init(&ses->server->secmech.sdeschmacsha256->shash);
>  	if (rc) {
>  		cifs_dbg(VFS, "%s: Could not init sign hmac\n", __func__);
>  		goto smb3signkey_ret;
>  	}
>  
> -	rc = crypto_shash_update(&server->secmech.sdeschmacsha256->shash,
> +	rc = crypto_shash_update(&ses->server->secmech.sdeschmacsha256->shash,
>  				i, 4);
>  	if (rc) {
>  		cifs_dbg(VFS, "%s: Could not update with n\n", __func__);
>  		goto smb3signkey_ret;
>  	}
>  
> -	rc = crypto_shash_update(&server->secmech.sdeschmacsha256->shash,
> +	rc = crypto_shash_update(&ses->server->secmech.sdeschmacsha256->shash,
>  				"SMB2AESCMAC", 12);
>  	if (rc) {
>  		cifs_dbg(VFS, "%s: Could not update with label\n", __func__);
>  		goto smb3signkey_ret;
>  	}
>  
> -	rc = crypto_shash_update(&server->secmech.sdeschmacsha256->shash,
> +	rc = crypto_shash_update(&ses->server->secmech.sdeschmacsha256->shash,
>  				&zero, 1);
>  	if (rc) {
>  		cifs_dbg(VFS, "%s: Could not update with zero\n", __func__);
>  		goto smb3signkey_ret;
>  	}
>  
> -	rc = crypto_shash_update(&server->secmech.sdeschmacsha256->shash,
> +	rc = crypto_shash_update(&ses->server->secmech.sdeschmacsha256->shash,
>  				"SmbSign", 8);
>  	if (rc) {
>  		cifs_dbg(VFS, "%s: Could not update with context\n", __func__);
>  		goto smb3signkey_ret;
>  	}
>  
> -	rc = crypto_shash_update(&server->secmech.sdeschmacsha256->shash,
> +	rc = crypto_shash_update(&ses->server->secmech.sdeschmacsha256->shash,
>  				L, 4);
>  	if (rc) {
>  		cifs_dbg(VFS, "%s: Could not update with L\n", __func__);
>  		goto smb3signkey_ret;
>  	}
>  
> -	rc = crypto_shash_final(&server->secmech.sdeschmacsha256->shash,
> +	rc = crypto_shash_final(&ses->server->secmech.sdeschmacsha256->shash,
>  				hashptr);
>  	if (rc) {
>  		cifs_dbg(VFS, "%s: Could not generate sha256 hash\n", __func__);
>  		goto smb3signkey_ret;
>  	}
>  
> -	memcpy(server->smb3signingkey, hashptr, SMB3_SIGNKEY_SIZE);
> +	memcpy(ses->smb3signingkey, hashptr, SMB3_SIGNKEY_SIZE);
>  
>  smb3signkey_ret:
> -	return;
> +	return rc;
>  }
>  
>  int
>  smb3_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
>  {
> -	int i, rc;
> +	int i;
> +	int rc = 0;
>  	unsigned char smb3_signature[SMB2_CMACAES_SIZE];
>  	unsigned char *sigptr = smb3_signature;
>  	struct kvec *iov = rqst->rq_iov;
>  	int n_vec = rqst->rq_nvec;
>  	struct smb2_hdr *smb2_pdu = (struct smb2_hdr *)iov[0].iov_base;
> +	struct cifs_ses *ses;
> +
> +	ses = smb2_find_smb_ses(smb2_pdu, server);
> +	if (!ses) {
> +		cifs_dbg(VFS, "%s: Could not find session\n", __func__);
> +		return 0;
> +	}
>  
>  	memset(smb3_signature, 0x0, SMB2_CMACAES_SIZE);
>  	memset(smb2_pdu->Signature, 0x0, SMB2_SIGNATURE_SIZE);
>  
>  	rc = crypto_shash_setkey(server->secmech.cmacaes,
> -		server->smb3signingkey, SMB2_CMACAES_SIZE);
> +		ses->smb3signingkey, SMB2_CMACAES_SIZE);
> +
>  	if (rc) {
>  		cifs_dbg(VFS, "%s: Could not set key for cmac aes\n", __func__);
>  		return rc;
> @@ -389,6 +422,7 @@ smb2_verify_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
>  	struct smb2_hdr *smb2_pdu = (struct smb2_hdr *)rqst->rq_iov[0].iov_base;
>  
>  	if ((smb2_pdu->Command == SMB2_NEGOTIATE) ||
> +	    (smb2_pdu->Command == SMB2_SESSION_SETUP) ||
>  	    (smb2_pdu->Command == SMB2_OPLOCK_BREAK) ||
>  	    (!server->session_estab))
>  		return 0;

Nice work. I think this looks clean and reasonable.

Acked-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
