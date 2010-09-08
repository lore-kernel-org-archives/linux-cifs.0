From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 4/8] ntlmv2/ntlmssp  define, declare, and use crypto
 hash functions
Date: Wed, 8 Sep 2010 16:00:05 -0400
Message-ID: <20100908160005.2e0c60ba@tlielax.poochiereds.net>
References: <1283921151-13090-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1283921151-13090-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue,  7 Sep 2010 23:45:51 -0500
shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> 
> Allocate crypto hashing functions, ecurity descriptiors, and respective
> contexts when a smb/tcp connection is established.
> Release them when a tcp/smb connection is taken down.
> 
> md5 and hmac-md5 are two crypto hashing functions that are used
> throught the life of an smb/tcp connection by various functions that
> calcualte signagure and ntlmv2 hash, HMAC etc.
> 
> 
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/cifsencrypt.c |   71 +++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/cifs/cifsproto.h   |    2 +
>  fs/cifs/connect.c     |   16 +++++++++--
>  3 files changed, 86 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
> index 4bdcf13..4772c4d 100644
> --- a/fs/cifs/cifsencrypt.c
> +++ b/fs/cifs/cifsencrypt.c
> @@ -369,3 +369,74 @@ void CalcNTLMv2_response(const struct cifsSesInfo *ses,
>  	hmac_md5_final(v2_session_response, &context);
>  /*	cifs_dump_mem("v2_sess_rsp: ", v2_session_response, 32); */
>  }
> +
> +void
> +cifs_crypto_shash_release(struct TCP_Server_Info *server)
> +{
> +	if (server->secmech.md5)
> +		crypto_free_shash(server->secmech.md5);
> +
> +	if (server->secmech.hmacmd5)
> +		crypto_free_shash(server->secmech.hmacmd5);
> +
> +	kfree(server->secmech.sdeschmacmd5);
> +
> +	kfree(server->secmech.sdescmd5);
> +}
> +
> +int
> +cifs_crypto_shash_allocate(struct TCP_Server_Info *server)
> +{
> +	int rc;
> +	unsigned int size;
> +
> +	server->secmech.hmacmd5 = crypto_alloc_shash("hmac(md5)", 0, 0);
> +	if (!server->secmech.hmacmd5 ||
> +			IS_ERR(server->secmech.hmacmd5)) {
> +		cERROR(1, "could not allocate crypto hmacmd5\n");
> +		return 1;
> +	}
> +
> +	server->secmech.md5 = crypto_alloc_shash("md5", 0, 0);
> +	if (!server->secmech.md5 || IS_ERR(server->secmech.md5)) {
> +		cERROR(1, "could not allocate crypto md5\n");
> +		rc = 1;
> +		goto cifs_crypto_shash_allocate_ret1;
> +	}
> +
> +	size = sizeof(struct shash_desc) +
> +			crypto_shash_descsize(server->secmech.hmacmd5);
> +	server->secmech.sdeschmacmd5 = kmalloc(size, GFP_KERNEL);
> +	if (!server->secmech.sdeschmacmd5) {
> +		cERROR(1, "cifs_crypto_shash_allocate: can't alloc hmacmd5\n");
> +		rc = -ENOMEM;
> +		goto cifs_crypto_shash_allocate_ret2;
> +	}
> +	server->secmech.sdeschmacmd5->shash.tfm = server->secmech.hmacmd5;
> +	server->secmech.sdeschmacmd5->shash.flags = 0x0;
> +
> +
> +	size = sizeof(struct shash_desc) +
> +			crypto_shash_descsize(server->secmech.md5);
> +	server->secmech.sdescmd5 = kmalloc(size, GFP_KERNEL);
> +	if (!server->secmech.sdescmd5) {
> +		cERROR(1, "cifs_crypto_shash_allocate: can't alloc md5\n");
> +		rc = -ENOMEM;
> +		goto cifs_crypto_shash_allocate_ret3;
> +	}
> +	server->secmech.sdescmd5->shash.tfm = server->secmech.md5;
> +	server->secmech.sdescmd5->shash.flags = 0x0;
> +
> +	return 0;
> +
> +cifs_crypto_shash_allocate_ret3:
> +	kfree(server->secmech.sdeschmacmd5);
> +
> +cifs_crypto_shash_allocate_ret2:
> +	crypto_free_shash(server->secmech.md5);
> +
> +cifs_crypto_shash_allocate_ret1:
> +	crypto_free_shash(server->secmech.hmacmd5);
> +
> +	return rc;
> +}
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index eadf78c..fa3716c 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -368,6 +368,8 @@ extern int cifs_calculate_mac_key(struct session_key *key, const char *rn,
>  extern void CalcNTLMv2_response(const struct cifsSesInfo *, char *);
>  extern void setup_ntlmv2_rsp(struct cifsSesInfo *, char *,
>  			     const struct nls_table *);
> +extern int cifs_crypto_shash_allocate(struct TCP_Server_Info *);
> +extern void cifs_crypto_shash_release(struct TCP_Server_Info *);
>  #ifdef CONFIG_CIFS_WEAK_PW_HASH
>  extern void calc_lanman_hash(const char *password, const char *cryptkey,
>  				bool encrypt, char *lnm_session_key);
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 0ea52e9..f5369e7 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -1520,6 +1520,7 @@ cifs_put_tcp_session(struct TCP_Server_Info *server)
>  	server->tcpStatus = CifsExiting;
>  	spin_unlock(&GlobalMid_Lock);
>  
> +	cifs_crypto_shash_release(server);
>  	cifs_fscache_release_client_cookie(server);
>  
>  	task = xchg(&server->tsk, NULL);
> @@ -1574,10 +1575,16 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
>  		goto out_err;
>  	}
>  
> +	rc = cifs_crypto_shash_allocate(tcp_ses);
> +	if (rc) {
> +		cERROR(1, "could not setup hash structures rc %d", rc);
> +		goto out_err;
> +	}
> +
>  	tcp_ses->hostname = extract_hostname(volume_info->UNC);
>  	if (IS_ERR(tcp_ses->hostname)) {
>  		rc = PTR_ERR(tcp_ses->hostname);
> -		goto out_err;
> +		goto out_err2;
>  	}
>  
>  	tcp_ses->noblocksnd = volume_info->noblocksnd;
> @@ -1618,7 +1625,7 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
>  	}
>  	if (rc < 0) {
>  		cERROR(1, "Error connecting to socket. Aborting operation");
> -		goto out_err;
> +		goto out_err2;
>  	}
>  
>  	/*
> @@ -1632,7 +1639,7 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
>  		rc = PTR_ERR(tcp_ses->tsk);
>  		cERROR(1, "error %d create cifsd thread", rc);
>  		module_put(THIS_MODULE);
> -		goto out_err;
> +		goto out_err2;
>  	}
>  
>  	/* thread spawned, put it on the list */
> @@ -1644,6 +1651,9 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
>  
>  	return tcp_ses;
>  
> +out_err2:
> +	cifs_crypto_shash_release(tcp_ses);
> +
>  out_err:
>  	if (tcp_ses) {
>  		if (!IS_ERR(tcp_ses->hostname))

Looks reasonable.

Acked-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
