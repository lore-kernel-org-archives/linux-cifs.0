From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] [CIFS] Limit allocation of crypto mechanisms to when we
 need it for a particular dialect
Date: Wed, 03 Jul 2013 08:53:48 -0400
Message-ID: <1372856028.3070.25.camel@tlielax.poochiereds.net>
References: <CAH2r5mtHiVHSa2_3wDT__7cNsiz1CDLWW9SSrSXwp5Yf_zJz5w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mtHiVHSa2_3wDT__7cNsiz1CDLWW9SSrSXwp5Yf_zJz5w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 2013-07-02 at 20:43 -0500, Steve French wrote:
> Author: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Date:   Tue Jul 2 20:34:49 2013 -0500
> 
>     [CIFS] Limit allocation of crypto mechanisms to when we need it
> for a particular dialect
> 
>     Updated patch to try to prevent allocation of cifs, smb2 or smb3 crypto
>     secmech structures unless needed.  Currently cifs allocates all crypto
>     mechanisms when the first session is established (4 functions and
> 4 contexts),
>     rather than only allocating these when needed (smb3 needs two, the
> rest of the
>     dialects only need one).
> 
>     Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 

Looks good overall. Some comments inline below...

> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
> index 3d8bf94..bf0de6f 100644
> --- a/fs/cifs/cifsencrypt.c
> +++ b/fs/cifs/cifsencrypt.c
> @@ -31,6 +31,33 @@
>  #include <linux/random.h>
>  #include <linux/highmem.h>
> 
> +static int
> +cifs_crypto_shash_md5_allocate(struct TCP_Server_Info *server)
> +{
> +	int rc;
> +	unsigned int size;
> +
> +	server->secmech.md5 = crypto_alloc_shash("md5", 0, 0);
> +	if (IS_ERR(server->secmech.md5)) {
> +		cifs_dbg(VFS, "could not allocate crypto md5\n");
> +		return PTR_ERR(server->secmech.md5);
> +	}
> +
> +	size = sizeof(struct shash_desc) +
> +			crypto_shash_descsize(server->secmech.md5);
> +	server->secmech.sdescmd5 = kmalloc(size, GFP_KERNEL);
> +	if (!server->secmech.sdescmd5) {
> +		rc = -ENOMEM;
> +		crypto_free_shash(server->secmech.md5);
> +		server->secmech.md5 = NULL;
> +		return rc;
> +	}
> +	server->secmech.sdescmd5->shash.tfm = server->secmech.md5;
> +	server->secmech.sdescmd5->shash.flags = 0x0;
> +
> +	return 0;
> +}
> +
>  /*
>   * Calculate and return the CIFS signature based on the mac key and SMB PDU.
>   * The 16 byte signature must be allocated by the caller. Note we only use the
> @@ -50,8 +77,11 @@ static int cifs_calc_signature(struct smb_rqst *rqst,
>  		return -EINVAL;
> 
>  	if (!server->secmech.sdescmd5) {
> -		cifs_dbg(VFS, "%s: Can't generate signature\n", __func__);
> -		return -1;
> +		rc = cifs_crypto_shash_md5_allocate(server);
> +		if (rc) {
> +			cifs_dbg(VFS, "%s: Can't alloc md5 crypto\n", __func__);
> +			return -1;
> +		}
>  	}
> 
>  	rc = crypto_shash_init(&server->secmech.sdescmd5->shash);
> @@ -556,6 +586,29 @@ CalcNTLMv2_response(const struct cifs_ses *ses,
> char *ntlmv2_hash)
>  	return rc;
>  }
> 
> +static int crypto_hmacmd5_alloc(struct TCP_Server_Info *server)
> +{
> +	unsigned int size;
> +
> +	server->secmech.hmacmd5 = crypto_alloc_shash("hmac(md5)", 0, 0);
> +	if (IS_ERR(server->secmech.hmacmd5)) {
> +		cifs_dbg(VFS, "could not allocate crypto hmacmd5\n");
> +		return PTR_ERR(server->secmech.hmacmd5);
> +	}
> +
> +	size = sizeof(struct shash_desc) +
> +			crypto_shash_descsize(server->secmech.hmacmd5);
> +	server->secmech.sdeschmacmd5 = kmalloc(size, GFP_KERNEL);
> +	if (!server->secmech.sdeschmacmd5) {
> +		crypto_free_shash(server->secmech.hmacmd5);
> +		server->secmech.hmacmd5 = NULL;
> +		return -ENOMEM;
> +	}
> +	server->secmech.sdeschmacmd5->shash.tfm = server->secmech.hmacmd5;
> +	server->secmech.sdeschmacmd5->shash.flags = 0x0;
> +
> +	return 0;
> +}
> 
>  int
>  setup_ntlmv2_rsp(struct cifs_ses *ses, const struct nls_table *nls_cp)
> @@ -606,6 +659,12 @@ setup_ntlmv2_rsp(struct cifs_ses *ses, const
> struct nls_table *nls_cp)

  ^^^^ note that your mailer is word-wrapping patches. You may want to
set up git-send-email to send them in the future.

> 
>  	memcpy(ses->auth_key.response + baselen, tiblob, tilen);
> 
> +	rc = crypto_hmacmd5_alloc(ses->server);
> +	if (rc) {
> +		cifs_dbg(VFS, "could not crypto alloc md5 rc %d\n", rc);
> +		goto setup_ntlmv2_rsp_ret;
> +	}
> +

You're not checking whether you've already done this allocation. On a
reconnect, won't this cause a leak?

>  	/* calculate ntlmv2_hash */
>  	rc = calc_ntlmv2_hash(ses, ntlmv2_hash, nls_cp);
>  	if (rc) {
> @@ -705,123 +764,32 @@ calc_seckey(struct cifs_ses *ses)
>  void
>  cifs_crypto_shash_release(struct TCP_Server_Info *server)
>  {
> -	if (server->secmech.cmacaes)
> +	if (server->secmech.cmacaes) {
>  		crypto_free_shash(server->secmech.cmacaes);
> +		server->secmech.cmacaes = NULL;
> +	}
> 
> -	if (server->secmech.hmacsha256)
> +	if (server->secmech.hmacsha256) {
>  		crypto_free_shash(server->secmech.hmacsha256);
> +		server->secmech.hmacsha256 = NULL;
> +	}
> 
> -	if (server->secmech.md5)
> +	if (server->secmech.md5) {
>  		crypto_free_shash(server->secmech.md5);
> +		server->secmech.md5 = NULL;
> +	}
> 
> -	if (server->secmech.hmacmd5)
> +	if (server->secmech.hmacmd5) {
>  		crypto_free_shash(server->secmech.hmacmd5);
> +		server->secmech.hmacmd5 = NULL;
> +	}
> 
>  	kfree(server->secmech.sdesccmacaes);
> -
> +	server->secmech.sdesccmacaes = NULL;
>  	kfree(server->secmech.sdeschmacsha256);
> -
> +	server->secmech.sdeschmacsha256 = NULL;
>  	kfree(server->secmech.sdeschmacmd5);
> -
> -	kfree(server->secmech.sdescmd5);
> -}
> -
> -int
> -cifs_crypto_shash_allocate(struct TCP_Server_Info *server)
> -{
> -	int rc;
> -	unsigned int size;
> -
> -	server->secmech.hmacmd5 = crypto_alloc_shash("hmac(md5)", 0, 0);
> -	if (IS_ERR(server->secmech.hmacmd5)) {
> -		cifs_dbg(VFS, "could not allocate crypto hmacmd5\n");
> -		return PTR_ERR(server->secmech.hmacmd5);
> -	}
> -
> -	server->secmech.md5 = crypto_alloc_shash("md5", 0, 0);
> -	if (IS_ERR(server->secmech.md5)) {
> -		cifs_dbg(VFS, "could not allocate crypto md5\n");
> -		rc = PTR_ERR(server->secmech.md5);
> -		goto crypto_allocate_md5_fail;
> -	}
> -
> -	server->secmech.hmacsha256 = crypto_alloc_shash("hmac(sha256)", 0, 0);
> -	if (IS_ERR(server->secmech.hmacsha256)) {
> -		cifs_dbg(VFS, "could not allocate crypto hmacsha256\n");
> -		rc = PTR_ERR(server->secmech.hmacsha256);
> -		goto crypto_allocate_hmacsha256_fail;
> -	}
> -
> -	server->secmech.cmacaes = crypto_alloc_shash("cmac(aes)", 0, 0);
> -	if (IS_ERR(server->secmech.cmacaes)) {
> -		cifs_dbg(VFS, "could not allocate crypto cmac-aes");
> -		rc = PTR_ERR(server->secmech.cmacaes);
> -		goto crypto_allocate_cmacaes_fail;
> -	}
> -
> -	size = sizeof(struct shash_desc) +
> -			crypto_shash_descsize(server->secmech.hmacmd5);
> -	server->secmech.sdeschmacmd5 = kmalloc(size, GFP_KERNEL);
> -	if (!server->secmech.sdeschmacmd5) {
> -		rc = -ENOMEM;
> -		goto crypto_allocate_hmacmd5_sdesc_fail;
> -	}
> -	server->secmech.sdeschmacmd5->shash.tfm = server->secmech.hmacmd5;
> -	server->secmech.sdeschmacmd5->shash.flags = 0x0;
> -
> -	size = sizeof(struct shash_desc) +
> -			crypto_shash_descsize(server->secmech.md5);
> -	server->secmech.sdescmd5 = kmalloc(size, GFP_KERNEL);
> -	if (!server->secmech.sdescmd5) {
> -		rc = -ENOMEM;
> -		goto crypto_allocate_md5_sdesc_fail;
> -	}
> -	server->secmech.sdescmd5->shash.tfm = server->secmech.md5;
> -	server->secmech.sdescmd5->shash.flags = 0x0;
> -
> -	size = sizeof(struct shash_desc) +
> -			crypto_shash_descsize(server->secmech.hmacsha256);
> -	server->secmech.sdeschmacsha256 = kmalloc(size, GFP_KERNEL);
> -	if (!server->secmech.sdeschmacsha256) {
> -		rc = -ENOMEM;
> -		goto crypto_allocate_hmacsha256_sdesc_fail;
> -	}
> -	server->secmech.sdeschmacsha256->shash.tfm = server->secmech.hmacsha256;
> -	server->secmech.sdeschmacsha256->shash.flags = 0x0;
> -
> -	size = sizeof(struct shash_desc) +
> -			crypto_shash_descsize(server->secmech.cmacaes);
> -	server->secmech.sdesccmacaes = kmalloc(size, GFP_KERNEL);
> -	if (!server->secmech.sdesccmacaes) {
> -		cifs_dbg(VFS, "%s: Can't alloc cmacaes\n", __func__);
> -		rc = -ENOMEM;
> -		goto crypto_allocate_cmacaes_sdesc_fail;
> -	}
> -	server->secmech.sdesccmacaes->shash.tfm = server->secmech.cmacaes;
> -	server->secmech.sdesccmacaes->shash.flags = 0x0;
> -
> -	return 0;
> -
> -crypto_allocate_cmacaes_sdesc_fail:
> -	kfree(server->secmech.sdeschmacsha256);
> -
> -crypto_allocate_hmacsha256_sdesc_fail:
> +	server->secmech.sdeschmacmd5 = NULL;
>  	kfree(server->secmech.sdescmd5);
> -
> -crypto_allocate_md5_sdesc_fail:
> -	kfree(server->secmech.sdeschmacmd5);
> -
> -crypto_allocate_hmacmd5_sdesc_fail:
> -	crypto_free_shash(server->secmech.cmacaes);
> -
> -crypto_allocate_cmacaes_fail:
> -	crypto_free_shash(server->secmech.hmacsha256);
> -
> -crypto_allocate_hmacsha256_fail:
> -	crypto_free_shash(server->secmech.md5);
> -
> -crypto_allocate_md5_fail:
> -	crypto_free_shash(server->secmech.hmacmd5);
> -
> -	return rc;
> +	server->secmech.sdescmd5 = NULL;
>  }
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index c8ff018..f7e584d 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -433,7 +433,6 @@ extern int SMBNTencrypt(unsigned char *, unsigned
> char *, unsigned char *,
>  			const struct nls_table *);
>  extern int setup_ntlm_response(struct cifs_ses *, const struct nls_table *);
>  extern int setup_ntlmv2_rsp(struct cifs_ses *, const struct nls_table *);
> -extern int cifs_crypto_shash_allocate(struct TCP_Server_Info *);
>  extern void cifs_crypto_shash_release(struct TCP_Server_Info *);
>  extern int calc_seckey(struct cifs_ses *);
>  extern void generate_smb3signingkey(struct TCP_Server_Info *);
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index afcb8a1..fa68813 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -2108,12 +2108,6 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
>  		goto out_err;
>  	}
> 
> -	rc = cifs_crypto_shash_allocate(tcp_ses);
> -	if (rc) {
> -		cifs_dbg(VFS, "could not setup hash structures rc %d\n", rc);
> -		goto out_err;
> -	}
> -
>  	tcp_ses->ops = volume_info->ops;
>  	tcp_ses->vals = volume_info->vals;
>  	cifs_set_net_ns(tcp_ses, get_net(current->nsproxy->net_ns));
> diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
> index 09b4fba..5bea1f0 100644
> --- a/fs/cifs/smb2transport.c
> +++ b/fs/cifs/smb2transport.c
> @@ -39,6 +39,71 @@
>  #include "smb2status.h"
>  #include "smb2glob.h"
> 
> +static int
> +smb2_crypto_shash_allocate(struct TCP_Server_Info *server)
> +{
> +	unsigned int size;
> +
> +	server->secmech.hmacsha256 = crypto_alloc_shash("hmac(sha256)", 0, 0);
> +	if (IS_ERR(server->secmech.hmacsha256)) {
> +		cifs_dbg(VFS, "could not allocate crypto hmacsha256\n");
> +		return PTR_ERR(server->secmech.hmacsha256);
> +	}
> +
> +	size = sizeof(struct shash_desc) +
> +			crypto_shash_descsize(server->secmech.hmacsha256);
> +	server->secmech.sdeschmacsha256 = kmalloc(size, GFP_KERNEL);
> +	if (!server->secmech.sdeschmacsha256) {
> +		crypto_free_shash(server->secmech.hmacsha256);
> +		server->secmech.hmacsha256 = NULL;
> +		return -ENOMEM;
> +	}
> +	server->secmech.sdeschmacsha256->shash.tfm = server->secmech.hmacsha256;
> +	server->secmech.sdeschmacsha256->shash.flags = 0x0;
> +
> +	return 0;
> +}
> +
> +static int
> +smb3_crypto_shash_allocate(struct TCP_Server_Info *server)
> +{
> +	unsigned int size;
> +	int rc;
> +
> +	rc = smb2_crypto_shash_allocate(server);
> +	if (rc)
> +		return rc;
> +
> +	server->secmech.cmacaes = crypto_alloc_shash("cmac(aes)", 0, 0);
> +	if (IS_ERR(server->secmech.cmacaes)) {
> +		cifs_dbg(VFS, "could not allocate crypto cmac-aes");
> +		kfree(server->secmech.sdeschmacsha256);
> +		server->secmech.sdeschmacsha256 = NULL;
> +		crypto_free_shash(server->secmech.hmacsha256);
> +		server->secmech.hmacsha256 = NULL;
> +		return PTR_ERR(server->secmech.cmacaes);
> +	}
> +
> +	size = sizeof(struct shash_desc) +
> +			crypto_shash_descsize(server->secmech.cmacaes);
> +	server->secmech.sdesccmacaes = kmalloc(size, GFP_KERNEL);
> +	if (!server->secmech.sdesccmacaes) {
> +		cifs_dbg(VFS, "%s: Can't alloc cmacaes\n", __func__);
> +		kfree(server->secmech.sdeschmacsha256);
> +		server->secmech.sdeschmacsha256 = NULL;
> +		crypto_free_shash(server->secmech.hmacsha256);
> +		crypto_free_shash(server->secmech.cmacaes);
> +		server->secmech.hmacsha256 = NULL;
> +		server->secmech.cmacaes = NULL;
> +		return -ENOMEM;
> +	}
> +	server->secmech.sdesccmacaes->shash.tfm = server->secmech.cmacaes;
> +	server->secmech.sdesccmacaes->shash.flags = 0x0;
> +
> +	return 0;
> +}
> +
> +
>  int
>  smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
>  {
> @@ -52,6 +117,14 @@ smb2_calc_signature(struct smb_rqst *rqst, struct
> TCP_Server_Info *server)
>  	memset(smb2_signature, 0x0, SMB2_HMACSHA256_SIZE);
>  	memset(smb2_pdu->Signature, 0x0, SMB2_SIGNATURE_SIZE);
> 
> +	if (server->secmech.hmacsha256 == NULL) {

Might it look cleaner to move the NULL pointer check into the allocation
function, and simply return 0 if it's already allocated?

> +		rc = smb2_crypto_shash_allocate(server);
> +		if (rc) {
> +			cifs_dbg(VFS, "%s: shah256 alloc failed\n", __func__);
					^^^^^
					shash256

> +			return rc;
> +		}
> +	}
> +
>  	rc = crypto_shash_setkey(server->secmech.hmacsha256,
>  		server->session_key.response, SMB2_NTLMV2_SESSKEY_SIZE);
>  	if (rc) {
> @@ -61,7 +134,7 @@ smb2_calc_signature(struct smb_rqst *rqst, struct
> TCP_Server_Info *server)
> 
>  	rc = crypto_shash_init(&server->secmech.sdeschmacsha256->shash);
>  	if (rc) {
> -		cifs_dbg(VFS, "%s: Could not init md5\n", __func__);
> +		cifs_dbg(VFS, "%s: Could not init sha256", __func__);
>  		return rc;
>  	}
> 
> @@ -129,6 +202,16 @@ generate_smb3signingkey(struct TCP_Server_Info *server)
>  	memset(prfhash, 0x0, SMB2_HMACSHA256_SIZE);
>  	memset(server->smb3signingkey, 0x0, SMB3_SIGNKEY_SIZE);
> 
> +	/* SMB3 essentially requires signing so no harm allocating it early */

Are you really allocating it early here? This comment is a little
confusing.

> +	if (server->secmech.hmacsha256 == NULL) {
> +		rc = smb3_crypto_shash_allocate(server);
> +		if (rc) {
> +			cifs_dbg(VFS, "%s: crypto alloc failed\n", __func__);
> +			goto smb3signkey_ret;
> +		}
> +	}
> +
> +
>  	rc = crypto_shash_setkey(server->secmech.hmacsha256,
>  		server->session_key.response, SMB2_NTLMV2_SESSKEY_SIZE);
>  	if (rc) {
> @@ -210,6 +293,9 @@ smb3_calc_signature(struct smb_rqst *rqst, struct
> TCP_Server_Info *server)
>  		return rc;
>  	}
> 
> +	/* we already allocate sdesccmacaes when we init smb3 signing key,
> +	   so unlike smb2 we do not have to check here if secmech
> +	   are initialized */
		^^^
This should be formatted as a standard kernel comment.

>  	rc = crypto_shash_init(&server->secmech.sdesccmacaes->shash);
>  	if (rc) {
>  		cifs_dbg(VFS, "%s: Could not init cmac aes\n", __func__);
> 


-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
