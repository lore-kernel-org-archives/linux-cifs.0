From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: Fix signing failure when server mandates signing
 for NTLMSSP
Date: Mon, 11 Jul 2011 09:48:33 -0400
Message-ID: <20110711094833.7dc02343@tlielax.poochiereds.net>
References: <1310298932-6901-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1310298932-6901-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, 10 Jul 2011 06:55:32 -0500
shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> 
> When using NTLMSSP authentication mechanism, if server mandates
> signing, keep the flags in type 3 messages of the NTLMSSP exchange
> same as in type 1 messages (i.e. keep the indicated capabilities same).
> 
> Some of the servers such as Samba, expect the flags such as
> Negotiate_Key_Exchange in type 3 message of NTLMSSP exchange as well.
> Some servers like Windows do not.
> 
> https://bugzilla.samba.org/show_bug.cgi?id=8212
> 
> 
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar@gmail>
> ---
>  fs/cifs/sess.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
> index 3892ab8..d3e6196 100644
> --- a/fs/cifs/sess.c
> +++ b/fs/cifs/sess.c
> @@ -428,8 +428,7 @@ static void build_ntlmssp_negotiate_blob(unsigned char *pbuffer,
>  			(SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED)) {
>  		flags |= NTLMSSP_NEGOTIATE_SIGN;
>  		if (!ses->server->session_estab)
> -			flags |= NTLMSSP_NEGOTIATE_KEY_XCH |
> -				NTLMSSP_NEGOTIATE_EXTENDED_SEC;
> +			flags |= NTLMSSP_NEGOTIATE_KEY_XCH;
>  	}
>  
>  	sec_blob->NegotiateFlags = cpu_to_le32(flags);
> @@ -465,10 +464,11 @@ static int build_ntlmssp_auth_blob(unsigned char *pbuffer,
>  		NTLMSSP_NEGOTIATE_128 | NTLMSSP_NEGOTIATE_UNICODE |
>  		NTLMSSP_NEGOTIATE_NTLM | NTLMSSP_NEGOTIATE_EXTENDED_SEC;
>  	if (ses->server->sec_mode &
> -	   (SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED))
> +	   (SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED)) {
>  		flags |= NTLMSSP_NEGOTIATE_SIGN;
> -	if (ses->server->sec_mode & SECMODE_SIGN_REQUIRED)
> -		flags |= NTLMSSP_NEGOTIATE_ALWAYS_SIGN;
> +		if (!ses->server->session_estab)
> +			flags |= NTLMSSP_NEGOTIATE_KEY_XCH;
> +	}
>  
>  	tmp = pbuffer + sizeof(AUTHENTICATE_MESSAGE);
>  	sec_blob->NegotiateFlags = cpu_to_le32(flags);

Looks reasonable...

Acked-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
