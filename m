From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: reinstate sec=ntlmv2 mount option
Date: Tue, 24 Jul 2012 10:18:10 +0100
Message-ID: <1343121490.2432.1.camel@localhost>
References: <1343090057-32700-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-KQewbsS9MvBBDgjK7y7TUQ@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1343090057-32700-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 2012-07-23 at 20:34 -0400, Jeff Layton wrote:
> sec=3Dntlmv2 as a mount option got dropped in the mount option overha=
ul.
>=20
> Cc: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # 3.4+
> Reported-by: G=C3=BCnter Kukkukk <linux-KQewbsS9MvBBDgjK7y7TUQ@public.gmane.org>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/connect.c |    9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
>=20
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index e8c3e6b..a675b7f 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -238,8 +238,8 @@ static const match_table_t cifs_mount_option_toke=
ns =3D {
>  enum {
>  	Opt_sec_krb5, Opt_sec_krb5i, Opt_sec_krb5p,
>  	Opt_sec_ntlmsspi, Opt_sec_ntlmssp,
> -	Opt_ntlm, Opt_sec_ntlmi, Opt_sec_ntlmv2i,
> -	Opt_sec_nontlm, Opt_sec_lanman,
> +	Opt_ntlm, Opt_sec_ntlmi, Opt_sec_ntlmv2,
> +	Opt_sec_ntlmv2i, Opt_sec_lanman,
>  	Opt_sec_none,
> =20
>  	Opt_sec_err
> @@ -253,8 +253,9 @@ static const match_table_t cifs_secflavor_tokens =
=3D {
>  	{ Opt_sec_ntlmssp, "ntlmssp" },
>  	{ Opt_ntlm, "ntlm" },
>  	{ Opt_sec_ntlmi, "ntlmi" },
> +	{ Opt_sec_ntlmv2, "nontlm" },
> +	{ Opt_sec_ntlmv2, "ntlmv2" },
>  	{ Opt_sec_ntlmv2i, "ntlmv2i" },
> -	{ Opt_sec_nontlm, "nontlm" },
>  	{ Opt_sec_lanman, "lanman" },
>  	{ Opt_sec_none, "none" },
> =20
> @@ -1167,7 +1168,7 @@ static int cifs_parse_security_flavors(char *va=
lue,
>  	case Opt_sec_ntlmi:
>  		vol->secFlg |=3D CIFSSEC_MAY_NTLM | CIFSSEC_MUST_SIGN;
>  		break;
> -	case Opt_sec_nontlm:
> +	case Opt_sec_ntlmv2:
>  		vol->secFlg |=3D CIFSSEC_MAY_NTLMV2;
>  		break;
>  	case Opt_sec_ntlmv2i:

ACKed-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
