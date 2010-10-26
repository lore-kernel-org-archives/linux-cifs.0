From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] [CIFS] [2/3 -v4] NTLM auth and sign - Define crypto
 hash functions and create and send keys needed for key exchange
Date: Tue, 26 Oct 2010 10:04:14 -0400
Message-ID: <20101026100414.1288fd25@tlielax.poochiereds.net>
References: <1287689108-3611-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1287689108-3611-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 21 Oct 2010 14:25:08 -0500
shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> 

[...]

> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index cfb8f99..4d6fcd8 100644
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
> @@ -102,6 +105,27 @@ struct session_key {
>  	char *response;
>  };
>  
> +/* crypto security descriptor definition */
> +struct sdesc {
> +	struct shash_desc shash;
> +	char ctx[];
> +};
> +
> +/* crypto hashing related structure/fields, not speicific to a sec mech */
						   ^^^^^^^^^
						   nit: specific

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
> +	unsigned char ciphertext[CIFS_CPHTXT_SIZE]; /* sent to server */
> +};
> +
>  struct cifs_cred {
>  	int uid;
>  	int gid;
> @@ -178,6 +202,7 @@ struct TCP_Server_Info {
>  	struct session_key session_key;
>  	unsigned long lstrp; /* when we got last response from this server */
>  	u16 dialect; /* dialect index that server chose */
> +	struct cifs_secmech secmech; /* crypto sec mech functs, descriptors */
>  	/* extended security flavors that server supports */
>  	bool	sec_kerberos;		/* supports plain Kerberos */
>  	bool	sec_mskerberos;		/* supports legacy MS Kerberos */
> @@ -220,6 +245,7 @@ struct cifsSesInfo {
>  	char ntlmv2_hash[16];
>  	unsigned int tilen; /* length of the target info blob */
>  	unsigned char *tiblob; /* target info blob in challenge response */
> +	struct ntlmssp_auth ntlmssp; /* ciphertext, flags */
>  	bool need_reconnect:1; /* connection reset, uid now invalid */
>  };
>  /* no more than one of the following three session flags may be set */
> diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
> index a152cd6..de36b09 100644
> --- a/fs/cifs/cifspdu.h
> +++ b/fs/cifs/cifspdu.h
> @@ -140,6 +140,12 @@
>   */
>  #define CIFS_SESS_KEY_SIZE (16)
>  
> +#define CIFS_CLIENT_CHALLENGE_SIZE (8)
> +#define CIFS_SERVER_CHALLENGE_SIZE (8)
> +#define CIFS_HMAC_MD5_HASH_SIZE (16)
> +#define CIFS_CPHTXT_SIZE (16)
> +#define CIFS_NTHASH_SIZE (16)
> +
>  /*
>   * Maximum user name length
>   */
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index 8c2d0cf..1e4728b 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -368,6 +368,10 @@ extern void SMBNTencrypt(unsigned char *, unsigned char *, unsigned char *);
>  extern int setup_ntlm_response(struct cifsSesInfo *);
>  extern void CalcNTLMv2_response(const struct cifsSesInfo *);
>  extern int setup_ntlmv2_rsp(struct cifsSesInfo *, const struct nls_table *);
> +extern int cifs_crypto_shash_allocate(struct TCP_Server_Info *);
> +extern void cifs_crypto_shash_release(struct TCP_Server_Info *);
> +extern int calc_seckey(struct cifsSesInfo *);
> +
>  #ifdef CONFIG_CIFS_WEAK_PW_HASH
>  extern void calc_lanman_hash(const char *password, const char *cryptkey,
>  				bool encrypt, char *lnm_session_key);

> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index c5807d3..a3cae2f 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -1563,6 +1563,7 @@ cifs_put_tcp_session(struct TCP_Server_Info *server)
>  	server->tcpStatus = CifsExiting;
>  	spin_unlock(&GlobalMid_Lock);
>  
> +	cifs_crypto_shash_release(server);
>  	cifs_fscache_release_client_cookie(server);
>  
>  	kfree(server->session_key.response);
> @@ -1621,10 +1622,16 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
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
> @@ -1668,7 +1675,7 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
>  	}
>  	if (rc < 0) {
>  		cERROR(1, "Error connecting to socket. Aborting operation");
> -		goto out_err;
> +		goto out_err2;
>  	}
>  
>  	/*
> @@ -1682,7 +1689,7 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
>  		rc = PTR_ERR(tcp_ses->tsk);
>  		cERROR(1, "error %d create cifsd thread", rc);
>  		module_put(THIS_MODULE);
> -		goto out_err;
> +		goto out_err2;
>  	}
>  
>  	/* thread spawned, put it on the list */
> @@ -1694,6 +1701,9 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
>  
>  	return tcp_ses;
>  
> +out_err2:
   ^^^^^^^^^
	As a general rule, names like this should be avoided.
	Maybe "out_crypto_release:" would be better?

> +	cifs_crypto_shash_release(tcp_ses);
> +
>  out_err:
>  	if (tcp_ses) {
>  		if (!IS_ERR(tcp_ses->hostname))


Other than the above nits (whihc aren't show stoppers), it looks
reasonable overall. I'm not that well versed in the crypto routines or
in NTLMSSP negotiation specifically to do more than ACK here however...

Acked-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
