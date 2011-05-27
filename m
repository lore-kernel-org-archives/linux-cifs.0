From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: sparse warning in cifsacl.c
Date: Fri, 27 May 2011 07:27:17 -0500
Message-ID: <BANLkTimPsO+=Mj0eKC-DhZ_z0Q_FSsRbEg@mail.gmail.com>
References: <BANLkTinzZeiiOChBDDymhCsuOw57fTP2Ng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTinzZeiiOChBDDymhCsuOw57fTP2Ng-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, May 26, 2011 at 11:48 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wro=
te:
> Shirish - below is a patch to fix a sparse warning in the cifsacl
> code. =A0The change around line 458 is cosmetic (doesn't look like th=
e
> original code caused a problem but at least this quiets sparse) but
> doesn't sid_authusers have an endian error. =A0 How far back does thi=
s
> bug go - does it affect much?

Yes, sid_authusers have an endian error.

>
> diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
> index 076b69c..5f02b4e 100644
> --- a/fs/cifs/cifsacl.c
> +++ b/fs/cifs/cifsacl.c
> @@ -38,7 +38,7 @@ static const struct cifs_sid sid_everyone =3D {
> =A0 =A0 =A0 =A01, 1, {0, 0, 0, 0, 0, 1}, {0} };
> =A0/* security id for Authenticated Users system group */
> =A0static const struct cifs_sid sid_authusers =3D {
> - =A0 =A0 =A0 1, 1, {0, 0, 0, 0, 0, 5}, {11} };

This variable was addedd in commit 2fbc2f1729e785a7b2faf9d8d60926bb1ff6=
2af0

> + =A0 =A0 =A0 1, 1, {0, 0, 0, 0, 0, 5}, {cpu_to_le32(11)} };
> =A0/* group users */
> =A0static const struct cifs_sid sid_user =3D {1, 2 , {0, 0, 0, 0, 0, =
5}, {} };
>
> @@ -458,7 +458,8 @@ int compare_sids(const struct cifs_sid *ctsid,
> const struct cifs_sid *cwsid)
> =A0 =A0 =A0 =A0if (num_subauth) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0for (i =3D 0; i < num_subauth; ++i) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (ctsid->sub_auth[i]=
 !=3D cwsid->sub_auth[i]) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (cts=
id->sub_auth[i] > cwsid->sub_auth[i])
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (le3=
2_to_cpu(ctsid->sub_auth[i]) >
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 le32_to_cpu(cwsid->sub_auth[i]))

This code has been around for quite some time.

> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0return 1;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0else
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0return -1;
>
>
> --
> Thanks,
>
> Steve
>
