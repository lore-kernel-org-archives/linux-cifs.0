From: "Ozanski, Grzegorz" <grzegorz.ozanski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] cifs: Fix regression during share-level security mounts
Date: Thu, 20 Jan 2011 14:26:55 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D176F432E2@irsmsx503.ger.corp.intel.com>
References: <1294327443-24293-1-git-send-email-shirishpargaonkar@gmail.com>
 <AANLkTim9_RA7YWLArC=yU18TDrZRxRQtcnzyPNug5KaX@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Ozanski, Grzegorz" <grzegorz.ozanski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTim9_RA7YWLArC=yU18TDrZRxRQtcnzyPNug5KaX-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

-----Original Message-----
=46rom: Shirish Pargaonkar [mailto:shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]=20
Sent: Tuesday, January 18, 2011 17:19
To: Ozanski, Grzegorz
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org; linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Subject: Re: [PATCH] cifs: Fix regression during share-level security m=
ounts

On Thu, Jan 6, 2011 at 9:24 AM,  <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
>
> NTLM response length was changed during to 16 bytes instead of 24 byt=
es
> that get sent in Tree Connection Request during share-level security
> share mounts. =A0Revert it back to 24 bytes.
>
>
> Reported-by: Grzegorz Ozanski <grzegorz.ozanski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> =A0fs/cifs/connect.c | =A0 =A04 ++--
> =A01 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 41f002f..cdba196 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -2966,7 +2966,7 @@ CIFSTCon(unsigned int xid, struct cifsSesInfo *=
ses,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bcc_ptr++; =A0 =A0 =A0 =A0 =A0 =A0 =A0=
/* skip password */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* already aligned so no need to do it=
 below */
> =A0 =A0 =A0 =A0} else {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 pSMB->PasswordLength =3D cpu_to_le16(CI=
=46S_SESS_KEY_SIZE);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 pSMB->PasswordLength =3D cpu_to_le16(CI=
=46S_AUTH_RESP_SIZE);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* BB FIXME add code to fail this if N=
TLMv2 or Kerberos
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 specified as required (when that =
support is added to
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 the vfs in the future) as only NT=
LM or the much
> @@ -2984,7 +2984,7 @@ CIFSTCon(unsigned int xid, struct cifsSesInfo *=
ses,
> =A0#endif /* CIFS_WEAK_PW_HASH */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0SMBNTencrypt(tcon->password, ses->serv=
er->cryptkey, bcc_ptr);
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 bcc_ptr +=3D CIFS_SESS_KEY_SIZE;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 bcc_ptr +=3D CIFS_AUTH_RESP_SIZE;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (ses->capabilities & CAP_UNICODE) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* must align unicode =
strings */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*bcc_ptr =3D 0; /* nul=
l byte password */
> --
> 1.6.0.2
>
>
Reported-and-Tested-by: Grzegorz Ozanski <grzegorz.ozanski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

---------------------------------------------------------------------
Intel Technology Poland sp. z o.o.
z siedziba w Gdansku
ul. Slowackiego 173
80-298 Gdansk

Sad Rejonowy Gdansk Polnoc w Gdansku,=20
VII Wydzial Gospodarczy Krajowego Rejestru Sadowego,=20
numer KRS 101882

NIP 957-07-52-316
Kapital zakladowy 200.000 zl

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
