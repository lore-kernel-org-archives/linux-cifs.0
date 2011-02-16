From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: fix broken lanman (lm) auth code
Date: Wed, 16 Feb 2011 07:53:46 -0500
Message-ID: <20110216075346.2b69c431@tlielax.poochiereds.net>
References: <1297811443-4848-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1297811443-4848-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 15 Feb 2011 17:10:43 -0600
shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> 
> Fix lanman (lm) authentication code.
> 
> Change lm response length back to 24 from 16.
> Parse lanmani mount option.
> Add code to add odd parity bit to each of the eight bytes of a DES key.
> 
> 
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/cifsglob.h |    3 ++-
>  fs/cifs/connect.c  |    3 +++
>  fs/cifs/sess.c     |    8 ++++----
>  fs/cifs/smbdes.c   |   19 ++++++++++++++++++-
>  4 files changed, 27 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 17afb0f..0b5c950 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -710,7 +710,8 @@ require use of the stronger protocol */
>  #define   CIFSSEC_MUST_SEAL	0x40040 /* not supported yet */
>  #define   CIFSSEC_MUST_NTLMSSP	0x80080 /* raw ntlmssp with ntlmv2 */
>  
> -#define   CIFSSEC_DEF (CIFSSEC_MAY_SIGN | CIFSSEC_MAY_NTLM | CIFSSEC_MAY_NTLMV2)
> +#define   CIFSSEC_DEF (CIFSSEC_MAY_LANMAN | CIFSSEC_MAY_SIGN | \
> +			CIFSSEC_MAY_NTLM | CIFSSEC_MAY_NTLMV2)
			^^^^^^^^^^^
	Won't this change enable lanman auth by default? Is that
	intended?

>  #define   CIFSSEC_MAX (CIFSSEC_MUST_SIGN | CIFSSEC_MUST_NTLMV2)
>  #define   CIFSSEC_AUTH_MASK (CIFSSEC_MAY_NTLM | CIFSSEC_MAY_NTLMV2 | CIFSSEC_MAY_LANMAN | CIFSSEC_MAY_PLNTXT | CIFSSEC_MAY_KRB5 | CIFSSEC_MAY_NTLMSSP)
>  /*
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 8d6c17a..e3494df 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -1014,6 +1014,9 @@ cifs_parse_mount_options(char *options, const char *devname,
>  				/* BB is there a better way to do this? */
>  				vol->secFlg |= CIFSSEC_MAY_NTLMV2;
>  #ifdef CONFIG_CIFS_WEAK_PW_HASH
> +			} else if (strnicmp(value, "lanmani", 7) == 0) {
> +				vol->secFlg |= CIFSSEC_MAY_LANMAN |
> +					CIFSSEC_MUST_SIGN;
>  			} else if (strnicmp(value, "lanman", 6) == 0) {
>  				vol->secFlg |= CIFSSEC_MAY_LANMAN;
>  #endif
> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
> index 1adc962..1676570 100644
> --- a/fs/cifs/sess.c
> +++ b/fs/cifs/sess.c
> @@ -656,13 +656,13 @@ ssetup_ntlmssp_authenticate:
>  
>  	if (type == LANMAN) {
>  #ifdef CONFIG_CIFS_WEAK_PW_HASH
> -		char lnm_session_key[CIFS_SESS_KEY_SIZE];
> +		char lnm_session_key[CIFS_AUTH_RESP_SIZE];
>  
>  		pSMB->req.hdr.Flags2 &= ~SMBFLG2_UNICODE;
>  
>  		/* no capabilities flags in old lanman negotiation */
>  
> -		pSMB->old_req.PasswordLength = cpu_to_le16(CIFS_SESS_KEY_SIZE);
> +		pSMB->old_req.PasswordLength = cpu_to_le16(CIFS_AUTH_RESP_SIZE);
>  
>  		/* Calculate hash with password and copy into bcc_ptr.
>  		 * Encryption Key (stored as in cryptkey) gets used if the
> @@ -675,8 +675,8 @@ ssetup_ntlmssp_authenticate:
>  					true : false, lnm_session_key);
>  
>  		ses->flags |= CIFS_SES_LANMAN;
> -		memcpy(bcc_ptr, (char *)lnm_session_key, CIFS_SESS_KEY_SIZE);
> -		bcc_ptr += CIFS_SESS_KEY_SIZE;
> +		memcpy(bcc_ptr, (char *)lnm_session_key, CIFS_AUTH_RESP_SIZE);
> +		bcc_ptr += CIFS_AUTH_RESP_SIZE;
>  
>  		/* can not sign if LANMAN negotiated so no need
>  		to calculate signing key? but what if server
> diff --git a/fs/cifs/smbdes.c b/fs/cifs/smbdes.c
> index 0472148..dcfc379 100644
> --- a/fs/cifs/smbdes.c
> +++ b/fs/cifs/smbdes.c
> @@ -299,6 +299,20 @@ dohash(char *out, char *in, char *key, int forw)
>  	kfree(ki);
>  }
>  
> +static int
> +odd_parity(unsigned char c)
> +{
> +	int i;
> +	int val = 0x80;
> +	int count = 0;
> +
> +	for (i = 0; i < 7; ++i)
> +		if (c & (val >> i))
> +			++count;
> +
> +	return count % 2;
> +}
> +
>  static void
>  str_to_key(unsigned char *str, unsigned char *key)
>  {
> @@ -312,8 +326,11 @@ str_to_key(unsigned char *str, unsigned char *key)
>  	key[5] = ((str[4] & 0x1F) << 2) | (str[5] >> 6);
>  	key[6] = ((str[5] & 0x3F) << 1) | (str[6] >> 7);
>  	key[7] = str[6] & 0x7F;
> -	for (i = 0; i < 8; i++)
> +	for (i = 0; i < 8; i++) {
>  		key[i] = (key[i] << 1);
> +		if (!odd_parity(key[i]))
> +			key[i] |= 0x1;
> +	}
>  }
>  
>  static void


-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
