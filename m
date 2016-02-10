From: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] cifs: fix erroneous return value
Date: Wed, 10 Feb 2016 09:59:46 -0800
Message-ID: <1455127186.3333.44.camel@perches.com>
References: <1455126621-28052-1-git-send-email-a.s.protopopov@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Anton Protopopov <a.s.protopopov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1455126621-28052-1-git-send-email-a.s.protopopov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 2016-02-10 at 12:50 -0500, Anton Protopopov wrote:
> The setup_ntlmv2_rsp() function may return positive value ENOMEM inst=
ead
> of -ENOMEM in case of kmalloc failure.

How have you verified this change is correct?

Have you checked that the callers of this function in
fs/cifs/sess.c do the appropriate things with with a
negative return value?

The return value is now set into a struct member variable
as a positive value,

	sess_data->result =3D rc;

Have you checked all the users of this member variable?

If you have, you should say so in the commit message.

> Signed-off-by: Anton Protopopov <a.s.protopopov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> =A0fs/cifs/cifsencrypt.c | 2 +-
> =A01 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
> index afa09fc..e682b36 100644
> --- a/fs/cifs/cifsencrypt.c
> +++ b/fs/cifs/cifsencrypt.c
> @@ -714,7 +714,7 @@ setup_ntlmv2_rsp(struct cifs_ses *ses, const stru=
ct nls_table *nls_cp)
> =A0
> =A0	ses->auth_key.response =3D kmalloc(baselen + tilen, GFP_KERNEL);
> =A0	if (!ses->auth_key.response) {
> -		rc =3D ENOMEM;
> +		rc =3D -ENOMEM;
> =A0		ses->auth_key.len =3D 0;
> =A0		goto setup_ntlmv2_rsp_ret;
> =A0	}
