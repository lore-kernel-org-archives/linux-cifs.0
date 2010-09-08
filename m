From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 2/8] ntlmv2/ntlmssp remove-unused-function
 CalcNTLMv2_partial_mac_key
Date: Wed, 8 Sep 2010 15:55:26 -0400
Message-ID: <20100908155526.69f47dd2@tlielax.poochiereds.net>
References: <1283921082-13019-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1283921082-13019-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue,  7 Sep 2010 23:44:42 -0500
shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> This function is not used, so remove the definition and declaration.
> 
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/cifsencrypt.c |   57 -------------------------------------------------
>  fs/cifs/cifsproto.h   |    2 -
>  2 files changed, 0 insertions(+), 59 deletions(-)
> 
> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
> index 796ebc7..4bdcf13 100644
> --- a/fs/cifs/cifsencrypt.c
> +++ b/fs/cifs/cifsencrypt.c
> @@ -224,63 +224,6 @@ int cifs_calculate_mac_key(struct session_key *key, const char *rn,
>  	return 0;
>  }
>  
> -int CalcNTLMv2_partial_mac_key(struct cifsSesInfo *ses,
> -			       const struct nls_table *nls_info)
> -{
> -	char temp_hash[16];
> -	struct HMACMD5Context ctx;
> -	char *ucase_buf;
> -	__le16 *unicode_buf;
> -	unsigned int i, user_name_len, dom_name_len;
> -
> -	if (ses == NULL)
> -		return -EINVAL;
> -
> -	E_md4hash(ses->password, temp_hash);
> -
> -	hmac_md5_init_limK_to_64(temp_hash, 16, &ctx);
> -	user_name_len = strlen(ses->userName);
> -	if (user_name_len > MAX_USERNAME_SIZE)
> -		return -EINVAL;
> -	if (ses->domainName == NULL)
> -		return -EINVAL; /* BB should we use CIFS_LINUX_DOM */
> -	dom_name_len = strlen(ses->domainName);
> -	if (dom_name_len > MAX_USERNAME_SIZE)
> -		return -EINVAL;
> -
> -	ucase_buf = kmalloc((MAX_USERNAME_SIZE+1), GFP_KERNEL);
> -	if (ucase_buf == NULL)
> -		return -ENOMEM;
> -	unicode_buf = kmalloc((MAX_USERNAME_SIZE+1)*4, GFP_KERNEL);
> -	if (unicode_buf == NULL) {
> -		kfree(ucase_buf);
> -		return -ENOMEM;
> -	}
> -
> -	for (i = 0; i < user_name_len; i++)
> -		ucase_buf[i] = nls_info->charset2upper[(int)ses->userName[i]];
> -	ucase_buf[i] = 0;
> -	user_name_len = cifs_strtoUCS(unicode_buf, ucase_buf,
> -				      MAX_USERNAME_SIZE*2, nls_info);
> -	unicode_buf[user_name_len] = 0;
> -	user_name_len++;
> -
> -	for (i = 0; i < dom_name_len; i++)
> -		ucase_buf[i] = nls_info->charset2upper[(int)ses->domainName[i]];
> -	ucase_buf[i] = 0;
> -	dom_name_len = cifs_strtoUCS(unicode_buf+user_name_len, ucase_buf,
> -				     MAX_USERNAME_SIZE*2, nls_info);
> -
> -	unicode_buf[user_name_len + dom_name_len] = 0;
> -	hmac_md5_update((const unsigned char *) unicode_buf,
> -		(user_name_len+dom_name_len)*2, &ctx);
> -
> -	hmac_md5_final(ses->server->ntlmv2_hash, &ctx);
> -	kfree(ucase_buf);
> -	kfree(unicode_buf);
> -	return 0;
> -}
> -
>  #ifdef CONFIG_CIFS_WEAK_PW_HASH
>  void calc_lanman_hash(const char *password, const char *cryptkey, bool encrypt,
>  			char *lnm_session_key)
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index 8d63406..eadf78c 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -365,8 +365,6 @@ extern int cifs_verify_signature(struct smb_hdr *,
>  				__u32 expected_sequence_number);
>  extern int cifs_calculate_mac_key(struct session_key *key, const char *rn,
>  				 const char *pass);
> -extern int CalcNTLMv2_partial_mac_key(struct cifsSesInfo *,
> -			const struct nls_table *);
>  extern void CalcNTLMv2_response(const struct cifsSesInfo *, char *);
>  extern void setup_ntlmv2_rsp(struct cifsSesInfo *, char *,
>  			     const struct nls_table *);

For the record, I'd be ok with this patch going into 2.6.36.

Reviewed-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
