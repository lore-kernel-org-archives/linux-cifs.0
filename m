From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH -v3 3/4 cifs] NTLMv2/NTLMSSP define crypto hash
 functions and create and send keys needed for key exchange
Date: Tue, 14 Sep 2010 08:33:58 -0400
Message-ID: <20100914083358.45c05914@corrin.poochiereds.net>
References: <1284405339-31226-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1284405339-31226-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 13 Sep 2010 14:15:39 -0500
shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> 
> Mark dependency on crypto modules in Kconfig.
> 
> Defining per structures sdesc and cifs_secmech which are used to store
> crypto hash functions and contexts.  They are stored per smb connection
> and used for all auth mechs to genereate hash values and signatures.
> 
> Allocate crypto hashing functions, security descriptiors, and respective
> contexts when a smb/tcp connection is established.
> Release them when a tcp/smb connection is taken down.
> 
> md5 and hmac-md5 are two crypto hashing functions that are used
> throught the life of an smb/tcp connection by various functions that
> calcualte signagure and ntlmv2 hash, HMAC etc.
> 
> structure ntlmssp_auth and filed cphready is defined as per smb connection.
> 
> ntlmssp_auth holds secondary key which is a nonce that gets used as a key
> to generate signatures, ciphertext is genereated by rc4/arc4 encryption of
> secondary key using ntlmv2 session key and sent in the session key field of
> the type 3 message sent by the client during ntlmssp negotiation/exchange
> These are per session structures and secondary key and cipher text
> get calculated only once per smb connection, during first smb session setup
> for that smb connection.
> 
> Field cphready is used to mark such that once secondary keys and ciphertext
> are calculated during very first smb session setup for a smb connection
> and ciphertext is sent to the server, the same does not happen during
> subsequent smb session setups/establishments.
> 
> A key is exchanged with the server if client indicates so in flags in
> type 1 messsage and server agrees in flag in type 2 message of ntlmssp
> negotiation.  If both client and agree, a key sent by client in
> type 3 message of ntlmssp negotiation in the session key field.
> The key is a ciphertext generated off of secondary key, a nonce, using
> ntlmv2 hash via rc4/arc4.
> 
> If authentication is successful, the secondary key is the that client
> uses to calculate cifs/smb signature in the messages that client sends
> and to verify the messages sent by server.
> This key stays with the smb connection for its life and is the key used
> to generate (and verify) signatures for all the subsequent smb sessions
> for this smb connection.
> 
> So only for the first smb session on any smb connection, type 1 message
> of ntlmssp negotiation selects the flag NTLMSSP_NEGOTIATE_KEY_XCH.
> It is not used for subsequent smb sessions on this smb connection i.e.
> no need to generate secondary key, create ciphertext and send it etc.
> 
> After the very first successful smb session, sequence number gets set
> to 0 and  variable cphready is used to mark that the key calculations
> are done. cphready is reset when a reconnect of the smb connection
> happens as sessions get set up again.
> 
> Calculation of ciphertext and setting cphready, is done within
> mutex lock to prevent race of smb session setups on a new smb connection.
> 
> 
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/Kconfig       |    3 +
>  fs/cifs/cifsencrypt.c |  125 +++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/cifs/cifsglob.h    |   28 +++++++++++
>  fs/cifs/cifspdu.h     |    7 +++
>  fs/cifs/cifsproto.h   |    3 +
>  fs/cifs/connect.c     |   18 ++++++-
>  fs/cifs/sess.c        |  125 +++++++++++++++++++++++++++++++++++++-----------
>  7 files changed, 277 insertions(+), 32 deletions(-)
> 
> diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
> index 917b7d4..0ed2139 100644
> --- a/fs/cifs/Kconfig
> +++ b/fs/cifs/Kconfig
> @@ -2,6 +2,9 @@ config CIFS
>  	tristate "CIFS support (advanced network filesystem, SMBFS successor)"
>  	depends on INET
>  	select NLS
> +	select CRYPTO
> +	select CRYPTO_MD5
> +	select CRYPTO_ARC4
>  	help
>  	  This is the client VFS module for the Common Internet File System
>  	  (CIFS) protocol which is the successor to the Server Message Block
> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
> index 960c948..7fd3dcc 100644
> --- a/fs/cifs/cifsencrypt.c
> +++ b/fs/cifs/cifsencrypt.c
> @@ -477,3 +477,128 @@ void CalcNTLMv2_response(const struct cifsSesInfo *ses,
>  	hmac_md5_final(v2_session_response, &context);
>  /*	cifs_dump_mem("v2_sess_rsp: ", v2_session_response, 32); */
>  }
> +
> +int
> +calc_seckey(struct TCP_Server_Info *server)
> +{
> +	int rc;
> +	struct crypto_blkcipher *tfm_arc4;
> +	struct scatterlist sgin, sgout;
> +	struct blkcipher_desc desc;
> +
> +	if (!server) {
> +		cERROR(1, "%s: Can't determine ciphertext key\n", __func__);
> +		return 1;
> +	}
> +
> +	mutex_lock(&server->srv_mutex);
> +	if (server->cphready) {
> +		mutex_unlock(&server->srv_mutex);
> +		return 0;
> +	}
> +
> +	get_random_bytes(server->ntlmssp.sec_key, CIFS_NTLMV2_SESSKEY_SIZE);
> +
> +	tfm_arc4 = crypto_alloc_blkcipher("ecb(arc4)",
> +						0, CRYPTO_ALG_ASYNC);
> +	if (!tfm_arc4 || IS_ERR(tfm_arc4)) {
> +		cERROR(1, "could not allocate crypto API arc4\n");
> +		mutex_unlock(&server->srv_mutex);
> +		return PTR_ERR(tfm_arc4);
> +	}
> +
> +	desc.tfm = tfm_arc4;
> +
> +	crypto_blkcipher_setkey(tfm_arc4, server->session_key.data.ntlmv2.key,
> +					CIFS_CPHTXT_SIZE);
> +
> +	sg_init_one(&sgin, server->ntlmssp.sec_key, CIFS_CPHTXT_SIZE);
> +	sg_init_one(&sgout, server->ntlmssp.ciphertext, CIFS_CPHTXT_SIZE);
> +
> +	rc = crypto_blkcipher_encrypt(&desc, &sgout, &sgin, CIFS_CPHTXT_SIZE);
> +	if (rc) {
> +		cERROR(1, "could not encrypt session key rc: %d\n", rc);
> +		crypto_free_blkcipher(tfm_arc4);
> +		mutex_unlock(&server->srv_mutex);
> +		return rc;
> +	}
> +
> +	crypto_free_blkcipher(tfm_arc4);
> +
> +	server->sequence_number = 0;
> +	server->cphready = true;
> +	mutex_unlock(&server->srv_mutex);
> +
> +	return 0;
> +}
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
> +		return PTR_ERR(server->secmech.hmacmd5);
> +	}
> +
> +	server->secmech.md5 = crypto_alloc_shash("md5", 0, 0);
> +	if (!server->secmech.md5 || IS_ERR(server->secmech.md5)) {
> +		cERROR(1, "could not allocate crypto md5\n");
> +		rc = PTR_ERR(server->secmech.md5);
> +		goto crypto_allocate_md5_fail;
> +	}
> +
> +	size = sizeof(struct shash_desc) +
> +			crypto_shash_descsize(server->secmech.hmacmd5);
> +	server->secmech.sdeschmacmd5 = kmalloc(size, GFP_KERNEL);
> +	if (!server->secmech.sdeschmacmd5) {
> +		cERROR(1, "cifs_crypto_shash_allocate: can't alloc hmacmd5\n");
> +		rc = -ENOMEM;
> +		goto crypto_allocate_hmacmd5_sdesc_fail;
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
> +		goto crypto_allocate_md5_sdesc_fail;
> +	}
> +	server->secmech.sdescmd5->shash.tfm = server->secmech.md5;
> +	server->secmech.sdescmd5->shash.flags = 0x0;
> +
> +	return 0;
> +
> +crypto_allocate_md5_sdesc_fail:
> +	kfree(server->secmech.sdeschmacmd5);
> +
> +crypto_allocate_hmacmd5_sdesc_fail:
> +	crypto_free_shash(server->secmech.md5);
> +
> +crypto_allocate_md5_fail:
> +	crypto_free_shash(server->secmech.hmacmd5);
> +
> +	return rc;
> +}
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index c68f31c..c7da866 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -25,6 +25,9 @@
>  #include <linux/workqueue.h>
>  #include "cifs_fs_sb.h"
>  #include "cifsacl.h"
> +#include <crypto/internal/hash.h>
> +#include <linux/scatterlist.h>
> +
>  /*
>   * The sizes of various internal tables and strings
>   */
> @@ -109,6 +112,28 @@ struct session_key {
>  	} data;
>  };
>  
> +/* crypto security descriptor definition */
> +struct sdesc {
> +	struct shash_desc shash;
> +	char ctx[];
> +};
> +
> +/* crypto hashing related structure/fields, not speicific to a sec mech */
> +struct cifs_secmech {
> +	struct crypto_shash *hmacmd5; /* hmac-md5 hash function */
> +	struct crypto_shash *md5; /* md5 hash function */
> +	struct sdesc *sdeschmacmd5;  /* ctxt to generate ntlmv2 hash, CR1 */
> +	struct sdesc *sdescmd5; /* ctxt to generate cifs/smb signature */
> +};
> +
> +/* per smb connection structure/fields */
> +struct ntlmssp_auth {
> +	__u32 client_flags; /* sent by client in type 1 ntlmsssp exchange */
> +	__u32 server_flags; /* sent by server in type 2 ntlmssp exchange */
> +	unsigned char sec_key[CIFS_CPHTXT_SIZE]; /* a nonce client generates */
> +	unsigned char ciphertext[CIFS_CPHTXT_SIZE]; /* sent to server */
> +};
> +
>  struct cifs_cred {
>  	int uid;
>  	int gid;
> @@ -187,6 +212,9 @@ struct TCP_Server_Info {
>  	unsigned long lstrp; /* when we got last response from this server */
>  	u16 dialect; /* dialect index that server chose */
>  	/* extended security flavors that server supports */
> +	struct cifs_secmech secmech; /* crypto sec mech functs, descriptors */
> +	struct ntlmssp_auth ntlmssp; /* sec key, ciphertext, flags */
> +	bool    cphready;               /* ciphertext is calculated */
>  	bool	sec_kerberos;		/* supports plain Kerberos */
>  	bool	sec_mskerberos;		/* supports legacy MS Kerberos */
>  	bool	sec_kerberosu2u;	/* supports U2U Kerberos */
> diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
> index b0f4b56..dc90a36 100644
> --- a/fs/cifs/cifspdu.h
> +++ b/fs/cifs/cifspdu.h
> @@ -134,6 +134,13 @@
>   * Size of the session key (crypto key encrypted with the password
>   */
>  #define CIFS_SESS_KEY_SIZE (24)
> +#define CIFS_CLIENT_CHALLENGE_SIZE (8)
> +#define CIFS_SERVER_CHALLENGE_SIZE (8)
> +#define CIFS_HMAC_MD5_HASH_SIZE (16)
> +#define CIFS_CPHTXT_SIZE (16)
> +#define CIFS_NTLMV2_SESSKEY_SIZE (16)
> +#define CIFS_NTHASH_SIZE (16)
> +
>  
>  /*
>   * Maximum user name length
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index c155479..d89a87a 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -369,6 +369,9 @@ extern int cifs_calculate_session_key(struct session_key *key, const char *rn,
>  extern void CalcNTLMv2_response(const struct cifsSesInfo *, char *);
>  extern int setup_ntlmv2_rsp(struct cifsSesInfo *, char *,
>  			     const struct nls_table *);
> +extern int cifs_crypto_shash_allocate(struct TCP_Server_Info *);
> +extern void cifs_crypto_shash_release(struct TCP_Server_Info *);
> +extern int calc_seckey(struct TCP_Server_Info *);
>  #ifdef CONFIG_CIFS_WEAK_PW_HASH
>  extern void calc_lanman_hash(const char *password, const char *cryptkey,
>  				bool encrypt, char *lnm_session_key);
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index f8891a2..ffccd9f 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -199,6 +199,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
>  			if (server->tcpStatus != CifsExiting)
>  				server->tcpStatus = CifsGood;
>  			server->sequence_number = 0;
> +			server->cphready = false;
>  			spin_unlock(&GlobalMid_Lock);
>  	/*		atomic_set(&server->inFlight,0);*/
>  			wake_up(&server->response_q);
> @@ -1502,6 +1503,7 @@ cifs_put_tcp_session(struct TCP_Server_Info *server)
>  	server->tcpStatus = CifsExiting;
>  	spin_unlock(&GlobalMid_Lock);
>  
> +	cifs_crypto_shash_release(server);
>  	cifs_fscache_release_client_cookie(server);
>  
>  	task = xchg(&server->tsk, NULL);
> @@ -1556,12 +1558,19 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
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
> +	tcp_ses->cphready = false;
>  	tcp_ses->noblocksnd = volume_info->noblocksnd;
>  	tcp_ses->noautotune = volume_info->noautotune;
>  	tcp_ses->tcp_nodelay = volume_info->sockopt_tcp_nodelay;
> @@ -1600,7 +1609,7 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
>  	}
>  	if (rc < 0) {
>  		cERROR(1, "Error connecting to socket. Aborting operation");
> -		goto out_err;
> +		goto out_err2;
>  	}
>  
>  	/*
> @@ -1614,7 +1623,7 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
>  		rc = PTR_ERR(tcp_ses->tsk);
>  		cERROR(1, "error %d create cifsd thread", rc);
>  		module_put(THIS_MODULE);
> -		goto out_err;
> +		goto out_err2;
>  	}
>  
>  	/* thread spawned, put it on the list */
> @@ -1626,6 +1635,9 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
>  
>  	return tcp_ses;
>  
> +out_err2:
> +	cifs_crypto_shash_release(tcp_ses);
> +
>  out_err:
>  	if (tcp_ses) {
>  		if (!IS_ERR(tcp_ses->hostname))
> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
> index 8882012..50e8f75 100644
> --- a/fs/cifs/sess.c
> +++ b/fs/cifs/sess.c
> @@ -383,6 +383,9 @@ static int decode_ascii_ssetup(char **pbcc_area, int bleft,
>  static int decode_ntlmssp_challenge(char *bcc_ptr, int blob_len,
>  				    struct cifsSesInfo *ses)
>  {
> +	unsigned int tioffset; /* challenge message target info area */
> +	unsigned int tilen; /* challenge message target info area length  */
> +
>  	CHALLENGE_MESSAGE *pblob = (CHALLENGE_MESSAGE *)bcc_ptr;
>  
>  	if (blob_len < sizeof(CHALLENGE_MESSAGE)) {
> @@ -405,6 +408,20 @@ static int decode_ntlmssp_challenge(char *bcc_ptr, int blob_len,
>  	/* BB spec says that if AvId field of MsvAvTimestamp is populated then
>  		we must set the MIC field of the AUTHENTICATE_MESSAGE */
>  
> +	ses->server->ntlmssp.server_flags = le32_to_cpu(pblob->NegotiateFlags);
> +
> +	tioffset = cpu_to_le16(pblob->TargetInfoArray.BufferOffset);
> +	tilen = cpu_to_le16(pblob->TargetInfoArray.Length);
> +	ses->tilen = tilen;
> +	if (ses->tilen) {
> +		ses->tiblob = kmalloc(tilen, GFP_KERNEL);
> +		if (!ses->tiblob) {
> +			cERROR(1, "Challenge target info allocation failure");
> +			return -ENOMEM;
> +		}
> +		memcpy(ses->tiblob,  bcc_ptr + tioffset, ses->tilen);
> +	}
> +

		^^^^^^^^^^^^^^^
The scheme where you check for the presence of a tiblob by checking to
see if tilen is non-zero seems fragile. There are places (like the one
above) where you have no buffer, but the tilen is left non-zero.

This code may be fine -- it may not be possible to NULL pointer
dereference here, but I worry about later changes to it. The error
handling is complex and the lifecycle of the tiblob is not terribly
clear. For instance, you free tiblob in setup_ntlmv2_rsp in an error
condition but the pointer isn't zeroed out. When there's no error, you
free it in the caller. It also occasionally frees tiblob without
checking to see whether tilen is 0 first.

It would be very easy to get this wrong. If this is really what
you want to do, it would be good to set the tilen to 0 whenever the
tiblob allocation fails, and to make sure that you zero out the tiblob
pointer after you free it. A clearer lifecycle for this thing would
really be better though.

Maybe consider making the tiblob/tilen a kvec or something, and have an
allocation and free routine to make sure it gets handled correctly.

>  	return 0;
>  }
>  
> @@ -425,12 +442,14 @@ static void build_ntlmssp_negotiate_blob(unsigned char *pbuffer,
>  	/* BB is NTLMV2 session security format easier to use here? */
>  	flags = NTLMSSP_NEGOTIATE_56 |	NTLMSSP_REQUEST_TARGET |
>  		NTLMSSP_NEGOTIATE_128 | NTLMSSP_NEGOTIATE_UNICODE |
> -		NTLMSSP_NEGOTIATE_NT_ONLY | NTLMSSP_NEGOTIATE_NTLM;
> +		NTLMSSP_NEGOTIATE_NTLM;
>  	if (ses->server->secMode &
> -	   (SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED))
> +			(SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED)) {
>  		flags |= NTLMSSP_NEGOTIATE_SIGN;
> -	if (ses->server->secMode & SECMODE_SIGN_REQUIRED)
> -		flags |= NTLMSSP_NEGOTIATE_ALWAYS_SIGN;
> +		if (!ses->server->cphready)
> +			flags |= NTLMSSP_NEGOTIATE_KEY_XCH |
> +				NTLMSSP_NEGOTIATE_EXTENDED_SEC;
> +	}
>  
>  	sec_blob->NegotiateFlags |= cpu_to_le32(flags);
>  
> @@ -451,10 +470,12 @@ static int build_ntlmssp_auth_blob(unsigned char *pbuffer,
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
> @@ -462,7 +483,7 @@ static int build_ntlmssp_auth_blob(unsigned char *pbuffer,
>  	flags = NTLMSSP_NEGOTIATE_56 |
>  		NTLMSSP_REQUEST_TARGET | NTLMSSP_NEGOTIATE_TARGET_INFO |
>  		NTLMSSP_NEGOTIATE_128 | NTLMSSP_NEGOTIATE_UNICODE |
> -		NTLMSSP_NEGOTIATE_NT_ONLY | NTLMSSP_NEGOTIATE_NTLM;
> +		NTLMSSP_NEGOTIATE_NTLM;
>  	if (ses->server->secMode &
>  	   (SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED))
>  		flags |= NTLMSSP_NEGOTIATE_SIGN;
> @@ -477,19 +498,25 @@ static int build_ntlmssp_auth_blob(unsigned char *pbuffer,
>  	sec_blob->LmChallengeResponse.Length = 0;
>  	sec_blob->LmChallengeResponse.MaximumLength = 0;
>  
> -	/* calculate session key,  BB what about adding similar ntlmv2 path? */
> -	SMBNTencrypt(ses->password, ses->server->cryptKey, ntlm_session_key);
> -	if (first)
> -		cifs_calculate_session_key(&ses->server->session_key,
> -				       ntlm_session_key, ses->password);
> -
> -	memcpy(tmp, ntlm_session_key, CIFS_SESS_KEY_SIZE);
>  	sec_blob->NtChallengeResponse.BufferOffset = cpu_to_le32(tmp - pbuffer);
> -	sec_blob->NtChallengeResponse.Length = cpu_to_le16(CIFS_SESS_KEY_SIZE);
> -	sec_blob->NtChallengeResponse.MaximumLength =
> -				cpu_to_le16(CIFS_SESS_KEY_SIZE);
> +	rc = setup_ntlmv2_rsp(ses, (char *)&ntlmv2_response, nls_cp);
> +	if (rc) {
> +		cERROR(1, "Error %d during NTLMSSP authentication", rc);
> +		goto setup_ntlmv2_ret;
> +	}
> +	size =  sizeof(struct ntlmv2_resp);
> +	memcpy(tmp, (char *)&ntlmv2_response, size);
> +	tmp += size;
> +	if (ses->tilen > 0) {
> +		memcpy(tmp, ses->tiblob, ses->tilen);
> +		tmp += ses->tilen;
> +	}
>  
> -	tmp += CIFS_SESS_KEY_SIZE;
> +	sec_blob->NtChallengeResponse.Length = cpu_to_le16(size + ses->tilen);
> +	sec_blob->NtChallengeResponse.MaximumLength =
> +				cpu_to_le16(size + ses->tilen);
> +	kfree(ses->tiblob);
> +	ses->tilen = 0;
>  
>  	if (ses->domainName == NULL) {
>  		sec_blob->DomainName.BufferOffset = cpu_to_le32(tmp - pbuffer);
> @@ -501,7 +528,6 @@ static int build_ntlmssp_auth_blob(unsigned char *pbuffer,
>  		len = cifs_strtoUCS((__le16 *)tmp, ses->domainName,
>  				    MAX_USERNAME_SIZE, nls_cp);
>  		len *= 2; /* unicode is 2 bytes each */
> -		len += 2; /* trailing null */
>  		sec_blob->DomainName.BufferOffset = cpu_to_le32(tmp - pbuffer);
>  		sec_blob->DomainName.Length = cpu_to_le16(len);
>  		sec_blob->DomainName.MaximumLength = cpu_to_le16(len);
> @@ -518,7 +544,6 @@ static int build_ntlmssp_auth_blob(unsigned char *pbuffer,
>  		len = cifs_strtoUCS((__le16 *)tmp, ses->userName,
>  				    MAX_USERNAME_SIZE, nls_cp);
>  		len *= 2; /* unicode is 2 bytes each */
> -		len += 2; /* trailing null */
>  		sec_blob->UserName.BufferOffset = cpu_to_le32(tmp - pbuffer);
>  		sec_blob->UserName.Length = cpu_to_le16(len);
>  		sec_blob->UserName.MaximumLength = cpu_to_le16(len);
> @@ -530,9 +555,21 @@ static int build_ntlmssp_auth_blob(unsigned char *pbuffer,
>  	sec_blob->WorkstationName.MaximumLength = 0;
>  	tmp += 2;
>  
> -	sec_blob->SessionKey.BufferOffset = cpu_to_le32(tmp - pbuffer);
> -	sec_blob->SessionKey.Length = 0;
> -	sec_blob->SessionKey.MaximumLength = 0;
> +	if ((ses->server->ntlmssp.server_flags & NTLMSSP_NEGOTIATE_KEY_XCH) &&
> +			!calc_seckey(ses->server)) {
> +		memcpy(tmp, ses->server->ntlmssp.ciphertext, CIFS_CPHTXT_SIZE);
> +		sec_blob->SessionKey.BufferOffset = cpu_to_le32(tmp - pbuffer);
> +		sec_blob->SessionKey.Length = cpu_to_le16(CIFS_CPHTXT_SIZE);
> +		sec_blob->SessionKey.MaximumLength =
> +			cpu_to_le16(CIFS_CPHTXT_SIZE);
> +		tmp += CIFS_CPHTXT_SIZE;
> +	} else {
> +		sec_blob->SessionKey.BufferOffset = cpu_to_le32(tmp - pbuffer);
> +		sec_blob->SessionKey.Length = 0;
> +		sec_blob->SessionKey.MaximumLength = 0;
> +	}
> +
> +setup_ntlmv2_ret:
>  	return tmp - pbuffer;
>  }
>  
> @@ -546,15 +583,14 @@ static void setup_ntlmssp_neg_req(SESSION_SETUP_ANDX *pSMB,
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

		^^^^^^^^
Isn't the above function now just a passthrough? Please just get rid
of it and fix the callers.

> @@ -729,12 +765,23 @@ ssetup_ntlmssp_authenticate:
>  			cpu_to_le16(sizeof(struct ntlmv2_resp));
>  
>  		/* calculate session key */
> -		setup_ntlmv2_rsp(ses, v2_sess_key, nls_cp);
> -		/* FIXME: calculate MAC key */
> +		rc = setup_ntlmv2_rsp(ses, v2_sess_key, nls_cp);
> +		if (rc) {
> +			cERROR(1, "Error %d during NTLMv2 authentication", rc);
> +			kfree(v2_sess_key);
> +			goto ssetup_exit;
> +		}
>  		memcpy(bcc_ptr, (char *)v2_sess_key,
>  		       sizeof(struct ntlmv2_resp));
>  		bcc_ptr += sizeof(struct ntlmv2_resp);
>  		kfree(v2_sess_key);
> +		if (ses->tilen > 0) {
> +			memcpy(bcc_ptr, ses->tiblob,
> +				ses->tilen);
> +			bcc_ptr += ses->tilen;
> +			kfree(ses->tiblob);
> +			ses->tilen = 0;
> +		}
>  		if (ses->capabilities & CAP_UNICODE) {
>  			if (iov[0].iov_len % 2) {
>  				*bcc_ptr = 0;
> @@ -815,12 +862,33 @@ ssetup_ntlmssp_authenticate:
>  			if (phase == NtLmNegotiate) {
>  				setup_ntlmssp_neg_req(pSMB, ses);
>  				iov[1].iov_len = sizeof(NEGOTIATE_MESSAGE);
> +				iov[1].iov_base = &pSMB->req.SecurityBlob[0];
>  			} else if (phase == NtLmAuthenticate) {
>  				int blob_len;
> -				blob_len = setup_ntlmssp_auth_req(pSMB, ses,
> +				char *ntlmsspblob;
> +
> +				/* 5 is an empirical value, large enought to
> +				 * hold authenticate message, max 10 of
> +				 * av paris, doamin,user,workstation mames,
> +				 * flags etc..
> +				 */
> +				ntlmsspblob = kmalloc(5 *
> +					sizeof(struct _AUTHENTICATE_MESSAGE),
> +					GFP_KERNEL);

				^^^^ when does this get freed?

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
> @@ -830,7 +898,6 @@ ssetup_ntlmssp_authenticate:
>  				rc = -ENOSYS;
>  				goto ssetup_exit;
>  			}
> -			iov[1].iov_base = &pSMB->req.SecurityBlob[0];
>  			/* unicode strings must be word aligned */
>  			if ((iov[0].iov_len + iov[1].iov_len) % 2) {
>  				*bcc_ptr = 0;


-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
