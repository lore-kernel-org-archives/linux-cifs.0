From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 1/1] cifs: add krb5m option for MAY_SIGN
Date: Tue, 23 Oct 2012 15:57:50 -0400
Message-ID: <20121023155750.726f5da5@corrin.poochiereds.net>
References: <1351005100-21172-1-git-send-email-martijn.de.gouw@prodrive.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Martijn de Gouw <martijn.de.gouw-BHYAuTpL47qEVqv0pETR8A@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1351005100-21172-1-git-send-email-martijn.de.gouw-BHYAuTpL47qEVqv0pETR8A@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 23 Oct 2012 17:11:40 +0200
Martijn de Gouw <martijn.de.gouw-BHYAuTpL47qEVqv0pETR8A@public.gmane.org> wrote:

> This option allows usage of dfs where some servers require signing
> and others don't.
> 
> Signed-off-by: Martijn de Gouw <martijn.de.gouw-BHYAuTpL47qEVqv0pETR8A@public.gmane.org>
> ---
> :100644 100644 b39bb4a... c5a4183... M	fs/cifs/connect.c
>  fs/cifs/connect.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index b39bb4a..c5a4183 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -236,7 +236,7 @@ static const match_table_t cifs_mount_option_tokens = {
>  };
>  
>  enum {
> -	Opt_sec_krb5, Opt_sec_krb5i, Opt_sec_krb5p,
> +	Opt_sec_krb5, Opt_sec_krb5i, Opt_sec_krb5m, Opt_sec_krb5p,
>  	Opt_sec_ntlmsspi, Opt_sec_ntlmssp,
>  	Opt_ntlm, Opt_sec_ntlmi, Opt_sec_ntlmv2,
>  	Opt_sec_ntlmv2i, Opt_sec_lanman,
> @@ -248,6 +248,7 @@ enum {
>  static const match_table_t cifs_secflavor_tokens = {
>  	{ Opt_sec_krb5, "krb5" },
>  	{ Opt_sec_krb5i, "krb5i" },
> +	{ Opt_sec_krb5m, "krb5m" },
>  	{ Opt_sec_krb5p, "krb5p" },
>  	{ Opt_sec_ntlmsspi, "ntlmsspi" },
>  	{ Opt_sec_ntlmssp, "ntlmssp" },
> @@ -999,6 +1000,9 @@ static int cifs_parse_security_flavors(char *value,
>  	case Opt_sec_krb5i:
>  		vol->secFlg |= CIFSSEC_MAY_KRB5 | CIFSSEC_MUST_SIGN;
>  		break;
> +	case Opt_sec_krb5m:
> +		vol->secFlg |= CIFSSEC_MAY_KRB5 | CIFSSEC_MAY_SIGN;
> +		break;
>  	case Opt_sec_krb5p:
>  		/* vol->secFlg |= CIFSSEC_MUST_SEAL | CIFSSEC_MAY_KRB5; */
>  		cERROR(1, "Krb5 cifs privacy not supported");

Yuck. I've no objection to allowing MAY_SIGN, but I'm not crazy about
adding a new security flavor. It might be best to just add that flag
unconditionally under Opt_sec_krb5. IOW, we'd just declare that
sec=krb5 == your new sec=krb5m.

<obligatory rant>
The whole secFlg thing is a f'ed up mess. It needs an overall redesign
from the ground up. Not only because the current code is getting in the
way of proper autonegotiation with the server, but it's hard to
maintain and the SecurityFlags interface is the epitome of obtuseness.
</obligatory rant>
-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
