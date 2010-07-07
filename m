From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: allow ntlmv2 ntlmssp authentication
Date: Wed, 7 Jul 2010 07:25:17 -0400
Message-ID: <20100707072517.1446d70e@corrin.poochiereds.net>
References: <1278126963-16111-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel-N0cyB0Tf/z2923ynj/IuLw@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1278126963-16111-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri,  2 Jul 2010 22:16:03 -0500
shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> Have kept ntlmv1 ntlmssp as a default, ntlmv2 ntlmssp can
> be made default only by making code change.
> 
> 
> From 3d8a8960a6d164e2bacd2a4fc96456453042e049 Mon Sep 17 00:00:00 2001
> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Date: Fri, 2 Jul 2010 21:54:51 -0500
> Subject: [PATCH] add ntlvm2 ntlmssp authentication
> 
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/cifsencrypt.c |   48 ++++++++++++++++++++++++++++++++++++++++++++----
>  fs/cifs/cifsglob.h    |    2 ++
>  fs/cifs/cifspdu.h     |    1 -
>  fs/cifs/sess.c        |   39 +++++++++++++++++++++++++++++++++++++--
>  4 files changed, 83 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
> index 847628d..ebfafec 100644
> --- a/fs/cifs/cifsencrypt.c
> +++ b/fs/cifs/cifsencrypt.c
> @@ -378,6 +378,44 @@ calc_exit_2:
>  	return rc;
>  }
>  
> +static void
> +find_domain_name(struct cifsSesInfo *ses)
> +{
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
> +			if (type == 0x2) {
				    ^^^
		Magic numbers like this should be turned into names.

> +				if (!ses->domainName) {
> +					ses->domainName =
> +						kmalloc(attrptr->length + 1,
> +								GFP_KERNEL);
> +					if (!ses->domainName)
> +						return;
> +					cifs_from_ucs2(ses->domainName,
> +						(__le16 *)blobptr,
> +						attrptr->length,
> +						attrptr->length,
> +						load_nls_default(), false);
> +				}
> +			}
> +			blobptr += attrsize; /* advance attr  value */
> +			attrptr = (struct ntlmssp2_name *) blobptr;
> +		}
> +	}
> +
> +	return;
> +}
> +

Is it possible that you'll need to pick other UCS2 fields than the
domain out of a NTLMSSP blob? If so, it might be better to turn the
above function into a "copy the field of type X out of the blob"
function.

>  void setup_ntlmv2_rsp(struct cifsSesInfo *ses, char *resp_buf,
>  		      const struct nls_table *nls_cp)
>  {
> @@ -390,10 +428,9 @@ void setup_ntlmv2_rsp(struct cifsSesInfo *ses, char *resp_buf,
>  	buf->time = cpu_to_le64(cifs_UnixTimeToNT(CURRENT_TIME));
>  	get_random_bytes(&buf->client_chal, sizeof(buf->client_chal));
>  	buf->reserved2 = 0;
> -	buf->names[0].type = cpu_to_le16(NTLMSSP_DOMAIN_TYPE);
> -	buf->names[0].length = 0;
> -	buf->names[1].type = 0;
> -	buf->names[1].length = 0;
> +
> +	if (!ses->domainName)
> +		find_domain_name(ses);
>  
>  	/* calculate buf->ntlmv2_hash */
>  	rc = calc_ntlmv2_hash(ses, nls_cp);
> @@ -421,6 +458,9 @@ void CalcNTLMv2_response(const struct cifsSesInfo *ses,
>  
>  	hmac_md5_update(v2_session_response+8,
>  			sizeof(struct ntlmv2_resp) - 8, &context);
> +	if (ses->server->tilen)
> +		hmac_md5_update(ses->server->tiblob,
> +			ses->server->tilen, &context);
>  
>  	hmac_md5_final(v2_session_response, &context);
>  /*	cifs_dump_mem("v2_sess_rsp: ", v2_session_response, 32); */
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 3c55e10..db6c5da 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -188,6 +188,8 @@ struct TCP_Server_Info {
>  	unsigned long lstrp; /* when we got last response from this server */
>  	u16 dialect; /* dialect index that server chose */
>  	/* extended security flavors that server supports */
> +	unsigned int tilen; /* length of the target info blob */
> +	unsigned char *tiblob; /* target info blob in challenge response */

All of this is for NTLMSSP session setup, correct? If so, is the
TCP_Server_Info really the right place for this? Will this break if I
have more than one session on the same socket?

>  	bool	sec_kerberos;		/* supports plain Kerberos */
>  	bool	sec_mskerberos;		/* supports legacy MS Kerberos */
>  	bool	sec_kerberosu2u;	/* supports U2U Kerberos */
> diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
> index 14d036d..b0f4b56 100644
> --- a/fs/cifs/cifspdu.h
> +++ b/fs/cifs/cifspdu.h
> @@ -663,7 +663,6 @@ struct ntlmv2_resp {
>  	__le64  time;
>  	__u64  client_chal; /* random */
>  	__u32  reserved2;
> -	struct ntlmssp2_name names[2];
>  	/* array of name entries could follow ending in minimum 4 byte struct */
>  } __attribute__((packed));
>  
> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
> index 0a57cb7..d1ec053 100644
> --- a/fs/cifs/sess.c
> +++ b/fs/cifs/sess.c
> @@ -383,6 +383,9 @@ static int decode_ascii_ssetup(char **pbcc_area, int bleft,
>  static int decode_ntlmssp_challenge(char *bcc_ptr, int blob_len,
>  				    struct cifsSesInfo *ses)
>  {
> +	unsigned int tioffset; /* challeng message target info area */
> +	unsigned int tilen; /* challeng message target info area length  */
> +
>  	CHALLENGE_MESSAGE *pblob = (CHALLENGE_MESSAGE *)bcc_ptr;
>  
>  	if (blob_len < sizeof(CHALLENGE_MESSAGE)) {
> @@ -405,6 +408,18 @@ static int decode_ntlmssp_challenge(char *bcc_ptr, int blob_len,
>  	/* BB spec says that if AvId field of MsvAvTimestamp is populated then
>  		we must set the MIC field of the AUTHENTICATE_MESSAGE */
>  
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
> @@ -451,10 +466,12 @@ static int build_ntlmssp_auth_blob(unsigned char *pbuffer,
>  				   struct cifsSesInfo *ses,
>  				   const struct nls_table *nls_cp, bool first)
>  {
> +	unsigned int size;
>  	AUTHENTICATE_MESSAGE *sec_blob = (AUTHENTICATE_MESSAGE *)pbuffer;
>  	__u32 flags;
>  	unsigned char *tmp;
>  	char ntlm_session_key[CIFS_SESS_KEY_SIZE];
> +	struct ntlmv2_resp ntlmv2_response = {};
>  
>  	memcpy(sec_blob->Signature, NTLMSSP_SIGNATURE, 8);
>  	sec_blob->MessageType = NtLmAuthenticate;
> @@ -477,6 +494,7 @@ static int build_ntlmssp_auth_blob(unsigned char *pbuffer,
>  	sec_blob->LmChallengeResponse.Length = 0;
>  	sec_blob->LmChallengeResponse.MaximumLength = 0;
>  
> +#if 1
  ^^^^^^^
Why are you adding code that's always compiled out?

>  	/* calculate session key,  BB what about adding similar ntlmv2 path? */
>  	SMBNTencrypt(ses->password, ses->server->cryptKey, ntlm_session_key);
>  	if (first)
> @@ -491,6 +509,25 @@ static int build_ntlmssp_auth_blob(unsigned char *pbuffer,
>  
>  	tmp += CIFS_SESS_KEY_SIZE;
>  
> +#else
> +	sec_blob->NtChallengeResponse.BufferOffset = cpu_to_le32(tmp - pbuffer);
> +	setup_ntlmv2_rsp(ses, (char *)&ntlmv2_response, nls_cp);
> +	size =  sizeof(struct ntlmv2_resp);
> +	memcpy(tmp, (char *)&ntlmv2_response, size);
> +	tmp += size;
> +	if (ses->server->tilen > 0) {
> +		memcpy(tmp, ses->server->tiblob, ses->server->tilen);
> +		kfree(ses->server->tiblob);
> +		tmp += ses->server->tilen;
> +	} else
> +		ses->server->tilen = 0;
> +
> +	sec_blob->NtChallengeResponse.Length = cpu_to_le16(size +
> +				ses->server->tilen);
> +	sec_blob->NtChallengeResponse.MaximumLength =
> +		cpu_to_le16(size + ses->server->tilen);
> +#endif
> +
>  	if (ses->domainName == NULL) {
>  		sec_blob->DomainName.BufferOffset = cpu_to_le32(tmp - pbuffer);
>  		sec_blob->DomainName.Length = 0;
> @@ -501,7 +538,6 @@ static int build_ntlmssp_auth_blob(unsigned char *pbuffer,
>  		len = cifs_strtoUCS((__le16 *)tmp, ses->domainName,
>  				    MAX_USERNAME_SIZE, nls_cp);
>  		len *= 2; /* unicode is 2 bytes each */
> -		len += 2; /* trailing null */
>  		sec_blob->DomainName.BufferOffset = cpu_to_le32(tmp - pbuffer);
>  		sec_blob->DomainName.Length = cpu_to_le16(len);
>  		sec_blob->DomainName.MaximumLength = cpu_to_le16(len);
> @@ -518,7 +554,6 @@ static int build_ntlmssp_auth_blob(unsigned char *pbuffer,
>  		len = cifs_strtoUCS((__le16 *)tmp, ses->userName,
>  				    MAX_USERNAME_SIZE, nls_cp);
>  		len *= 2; /* unicode is 2 bytes each */
> -		len += 2; /* trailing null */
>  		sec_blob->UserName.BufferOffset = cpu_to_le32(tmp - pbuffer);
>  		sec_blob->UserName.Length = cpu_to_le16(len);
>  		sec_blob->UserName.MaximumLength = cpu_to_le16(len);


-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
