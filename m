From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: Fix broken lanman (lm) auth code (try #4)
Date: Wed, 16 Feb 2011 20:52:15 -0500
Message-ID: <20110216205215.40c6b7c3@corrin.poochiereds.net>
References: <1297901128-23418-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1297901128-23418-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 16 Feb 2011 18:05:28 -0600
shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> 
> Fix lanman (lm) authentication code.
> 
> Change lm response length back to 24 from 16.
> Add code to add odd parity bit to each of the eight bytes of a DES key.
> 
> 
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/sess.c   |    8 ++++----
>  fs/cifs/smbdes.c |    5 ++++-
>  2 files changed, 8 insertions(+), 5 deletions(-)
> 
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
> index 0472148..0ab5def 100644
> --- a/fs/cifs/smbdes.c
> +++ b/fs/cifs/smbdes.c
> @@ -312,8 +312,11 @@ str_to_key(unsigned char *str, unsigned char *key)
>  	key[5] = ((str[4] & 0x1F) << 2) | (str[5] >> 6);
>  	key[6] = ((str[5] & 0x3F) << 1) | (str[6] >> 7);
>  	key[7] = str[6] & 0x7F;
> -	for (i = 0; i < 8; i++)
> +	for (i = 0; i < 8; i++) {
>  		key[i] = (key[i] << 1);
> +		if (~(hweight8(key[i]) & 1))
> +			key[i] |= 0x1; /* add odd parity bit */
> +	}

This doesn't look right:

hweight8 will return an unsigned int. You & that with 1, so you'll
either get 0x1 (for odd number of bits) or 0x0 (for even). Then take
the one's compliment of that and you'll either have 0xfffffffe (odd) or
0xffffffff (even), both of which will return true.

I think you'll need to do this differently -- perhaps something like
this which also has the advantage of avoiding the if statement:

	/* set the odd parity bit */
	key[i] |= (~(hweight8(key[i]) & 1)) & 1;

...though be sure to step through the bitwise logic by hand to make
sure I've got it right. There may also be more efficient ways to do
this that I don't see right offhand.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
