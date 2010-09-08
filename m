From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 3/8] ntlmv2/ntlmssp do not assume kerberos as default
 auth mech
Date: Wed, 8 Sep 2010 15:56:15 -0400
Message-ID: <20100908155615.0eb8a30e@tlielax.poochiereds.net>
References: <1283921118-13066-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1283921118-13066-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue,  7 Sep 2010 23:45:18 -0500
shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> 
> kerberos gets selected as a default mechanism if server supports it, over
> the other security mechanisms.
> 
> 
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/cifssmb.c |   15 +++++++++------
>  1 files changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index c65c341..1f1b097 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -604,12 +604,15 @@ CIFSSMBNegotiate(unsigned int xid, struct cifsSesInfo *ses)
>  			else
>  				rc = -EINVAL;
>  
> -			if (server->sec_kerberos || server->sec_mskerberos)
> -				server->secType = Kerberos;
> -			else if (server->sec_ntlmssp)
> -				server->secType = RawNTLMSSP;
> -			else
> -				rc = -EOPNOTSUPP;
> +			if (server->secType == Kerberos) {
> +				if (!server->sec_kerberos &&
> +						!server->sec_mskerberos)
> +					rc = -EOPNOTSUPP;
> +			} else if (server->secType == RawNTLMSSP) {
> +				if (!server->sec_ntlmssp)
> +					rc = -EOPNOTSUPP;
> +			} else
> +					rc = -EOPNOTSUPP;
>  		}
>  	} else
>  		server->capabilities &= ~CAP_EXTENDED_SECURITY;

Reviewed-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
