From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] extract or create av pair blob and free it - during
 first session setup
Date: Tue, 7 Sep 2010 07:56:48 -0400
Message-ID: <20100907075648.007c4e1e@corrin.poochiereds.net>
References: <1283830497-25086-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1283830497-25086-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon,  6 Sep 2010 22:34:57 -0500
shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/cifsencrypt.c |   68 +++++++++++++++++++++++++++++++++++++++++++++---
>  fs/cifs/cifspdu.h     |    1 -
>  fs/cifs/cifsproto.h   |    2 +-
>  fs/cifs/connect.c     |    2 +
>  fs/cifs/sess.c        |   24 ++++++++++++++++-
>  5 files changed, 88 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
> index fe1e4c9..5f0fc6b 100644
> --- a/fs/cifs/cifsencrypt.c
> +++ b/fs/cifs/cifsencrypt.c
> @@ -27,6 +27,7 @@
>  #include "md5.h"
>  #include "cifs_unicode.h"
>  #include "cifsproto.h"
> +#include "ntlmssp.h"
>  #include <linux/ctype.h>
>  #include <linux/random.h>
>  
> @@ -263,6 +264,56 @@ void calc_lanman_hash(const char *password, const char *cryptkey, bool encrypt,
>  }
>  #endif /* CIFS_WEAK_PW_HASH */
>  
> +static int
> +find_domain_name(struct cifsSesInfo *ses)
> +{
> +	int rc = 0;
> +	unsigned int attrsize;
> +	unsigned int type;
> +	unsigned char *blobptr;
> +	struct ntlmssp2_name *attrptr;
> +
> +	if (ses->server->tiblob) {
> +		blobptr = ses->server->tiblob;
> +		attrptr = (struct ntlmssp2_name *) blobptr;
> +
> +		while ((type = attrptr->type) != 0) {
> +			blobptr += 2; /* advance attr type */
> +			attrsize = attrptr->length;
> +			blobptr += 2; /* advance attr size */
> +			if (type == NTLMSSP_AV_NB_DOMAIN_NAME) {
> +				if (!ses->domainName) {
> +					ses->domainName =
> +						kmalloc(attrptr->length + 1,
> +								GFP_KERNEL);
> +					if (!ses->domainName)
> +							return -ENOMEM;
> +					cifs_from_ucs2(ses->domainName,
> +						(__le16 *)blobptr,
> +						attrptr->length,
> +						attrptr->length,
> +						load_nls_default(), false);
						^^^^^^^^
						Doesn't
						"load_nls_default" need
						an "unload_nls" when
						you're done with it?
> +				}
> +			}
> +			blobptr += attrsize; /* advance attr  value */
> +			attrptr = (struct ntlmssp2_name *) blobptr;
> +		}
> +	} else {
> +		ses->server->tilen = 2 * sizeof(struct ntlmssp2_name);
> +		ses->server->tiblob = kmalloc(ses->server->tilen, GFP_KERNEL);
> +		if (!ses->server->tiblob) {
> +			ses->server->tilen = 0;
> +			cERROR(1, "Challenge target info allocation failure");
> +			return -ENOMEM;
> +		}
> +		memset(ses->server->tiblob, 0x0, ses->server->tilen);
		^^^^^^^^^^
		This memset can be eliminated if you use kzalloc
		instead.

> +		attrptr = (struct ntlmssp2_name *) ses->server->tiblob;
> +		attrptr->type = cpu_to_le16(NTLMSSP_DOMAIN_TYPE);
> +	}
> +
> +	return rc;
> +}
> +

A comment describing what the above function is intended to do would be
nice. I can sort of guess that it's intended to parse the domain name
out of one of the NTLMSSP blobs, but I don't quite understand what the
stuff in the big "else" clause is for. Why allocate the buffer for the
tiblob in "find_domain_name" ? It seems like that ought to be done in a
more well-defined fashion.

>  static int calc_ntlmv2_hash(struct cifsSesInfo *ses,
>  			    const struct nls_table *nls_cp)
>  {
> @@ -322,7 +373,8 @@ calc_exit_2:
>  	return rc;
>  }
>  
> -void setup_ntlmv2_rsp(struct cifsSesInfo *ses, char *resp_buf,
> +int
> +setup_ntlmv2_rsp(struct cifsSesInfo *ses, char *resp_buf,
>  		      const struct nls_table *nls_cp)
>  {
>  	int rc;
> @@ -334,10 +386,14 @@ void setup_ntlmv2_rsp(struct cifsSesInfo *ses, char *resp_buf,
>  	buf->time = cpu_to_le64(cifs_UnixTimeToNT(CURRENT_TIME));
>  	get_random_bytes(&buf->client_chal, sizeof(buf->client_chal));
>  	buf->reserved2 = 0;
> -	buf->names[0].type = cpu_to_le16(NTLMSSP_DOMAIN_TYPE);
> -	buf->names[0].length = 0;
> -	buf->names[1].type = 0;
> -	buf->names[1].length = 0;
> +
> +	if (!ses->domainName) {
> +		rc = find_domain_name(ses);
> +		if (rc) {
> +			cERROR(1, "could not get domain/server name rc %d", rc);
> +			return rc;
> +		}
> +	}
>  
>  	/* calculate buf->ntlmv2_hash */
>  	rc = calc_ntlmv2_hash(ses, nls_cp);
> @@ -353,6 +409,8 @@ void setup_ntlmv2_rsp(struct cifsSesInfo *ses, char *resp_buf,
>  	memcpy(&ses->server->mac_signing_key.data.ntlmv2.resp, resp_buf,
>  	       sizeof(struct ntlmv2_resp));
>  	ses->server->mac_signing_key.len = 16 + sizeof(struct ntlmv2_resp);
> +
> +	return rc;
>  }
>  
>  void CalcNTLMv2_response(const struct cifsSesInfo *ses,
> diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
> index f5c78fb..dc90a36 100644
> --- a/fs/cifs/cifspdu.h
> +++ b/fs/cifs/cifspdu.h
> @@ -670,7 +670,6 @@ struct ntlmv2_resp {
>  	__le64  time;
>  	__u64  client_chal; /* random */
>  	__u32  reserved2;
> -	struct ntlmssp2_name names[2];
>  	/* array of name entries could follow ending in minimum 4 byte struct */
>  } __attribute__((packed));
>  
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index f3ffa69..ccc6d57 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -368,7 +368,7 @@ extern int cifs_calculate_mac_key(struct session_key *key, const char *rn,
>  extern int CalcNTLMv2_partial_mac_key(struct cifsSesInfo *,
>  			const struct nls_table *);
>  extern void CalcNTLMv2_response(const struct cifsSesInfo *, char *);
> -extern void setup_ntlmv2_rsp(struct cifsSesInfo *, char *,
> +extern int setup_ntlmv2_rsp(struct cifsSesInfo *, char *,
>  			     const struct nls_table *);
>  extern int cifs_crypto_shash_allocate(struct TCP_Server_Info *);
>  extern void cifs_crypto_shash_release(struct TCP_Server_Info *);
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index f5369e7..47b51eb 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -1580,6 +1580,8 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
>  		cERROR(1, "could not setup hash structures rc %d", rc);
>  		goto out_err;
>  	}
> +	tcp_ses->tilen = 0;
> +	tcp_ses->tiblob = NULL;
>  
>  	tcp_ses->hostname = extract_hostname(volume_info->UNC);
>  	if (IS_ERR(tcp_ses->hostname)) {
> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
> index 0a57cb7..6551b17 100644
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
> +	ses->server->tilen = tilen;
> +	if (tilen) {
> +		ses->server->tiblob = kmalloc(tilen, GFP_KERNEL);
> +		if (!ses->server->tiblob) {
> +			cERROR(1, "Challenge target info allocation failure");
> +			return -ENOMEM;
> +		}
> +		memcpy(ses->server->tiblob,  bcc_ptr + tioffset, tilen);
> +	}
> +
>  	return 0;
>  }
>  
> @@ -533,6 +550,10 @@ static int build_ntlmssp_auth_blob(unsigned char *pbuffer,
>  	sec_blob->SessionKey.BufferOffset = cpu_to_le32(tmp - pbuffer);
>  	sec_blob->SessionKey.Length = 0;
>  	sec_blob->SessionKey.MaximumLength = 0;
> +
> +	if (ses->server->tilen > 0)
> +		kfree(ses->server->tiblob);
> +

I'm not sure I get this...why are you freeing the blob if tilen is 0?
That seems like you could end up with a leak in corner cases. Why not
just unconditionally kfree it and make sure it's set to NULL if there
is no buffer?

>  	return tmp - pbuffer;
>  }
>  
> @@ -729,8 +750,7 @@ ssetup_ntlmssp_authenticate:
>  			cpu_to_le16(sizeof(struct ntlmv2_resp));
>  
>  		/* calculate session key */
> -		setup_ntlmv2_rsp(ses, v2_sess_key, nls_cp);
> -		/* FIXME: calculate MAC key */
> +		rc = setup_ntlmv2_rsp(ses, v2_sess_key, nls_cp);
		^^^^^^^^^^^
You're getting the return code from this function now, but it'll just
get clobbered when SendReceive2 is called. What's the point? Shouldn't
you do something different if it comes back with an error? What's going
to happen if find_domain_name fails and the session setup call proceeds?

>  		memcpy(bcc_ptr, (char *)v2_sess_key,
>  		       sizeof(struct ntlmv2_resp));
>  		bcc_ptr += sizeof(struct ntlmv2_resp);


-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
