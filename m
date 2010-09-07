From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] remove unused function CalcNTLMv2_partial_mac_key
Date: Tue, 7 Sep 2010 07:17:58 -0400
Message-ID: <20100907071758.67e8d753@corrin.poochiereds.net>
References: <1283830340-24991-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1283830340-24991-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon,  6 Sep 2010 22:32:20 -0500
shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/cifsencrypt.c |   57 -------------------------------------------------
>  1 files changed, 0 insertions(+), 57 deletions(-)
> 
> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
> index 86e33cc..4f85651 100644
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

What about the declaration in cifsproto.h?

Other than that...strong ACK here. We should get rid of as much unused
bloat as possible.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
