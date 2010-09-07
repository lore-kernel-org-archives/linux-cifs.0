From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] extract or create av pair blob and free it - during
 first session setup
Date: Tue, 7 Sep 2010 09:16:04 -0400
Message-ID: <20100907091604.305c65f7@corrin.poochiereds.net>
References: <1283830497-25086-1-git-send-email-shirishpargaonkar@gmail.com>
	<20100907075648.007c4e1e@corrin.poochiereds.net>
	<AANLkTi=FMm-fYhBcZbCxwWQ=LejdYahDM=E5RUWg62sy@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=FMm-fYhBcZbCxwWQ=LejdYahDM=E5RUWg62sy-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 7 Sep 2010 07:52:09 -0500
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Tue, Sep 7, 2010 at 6:56 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote=
:
> > On Mon, =A06 Sep 2010 22:34:57 -0500
> > shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> >
> >> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >>
> >> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >> ---
> >> =A0fs/cifs/cifsencrypt.c | =A0 68 ++++++++++++++++++++++++++++++++=
+++++++++++++---
> >> =A0fs/cifs/cifspdu.h =A0 =A0 | =A0 =A01 -
> >> =A0fs/cifs/cifsproto.h =A0 | =A0 =A02 +-
> >> =A0fs/cifs/connect.c =A0 =A0 | =A0 =A02 +
> >> =A0fs/cifs/sess.c =A0 =A0 =A0 =A0| =A0 24 ++++++++++++++++-
> >> =A05 files changed, 88 insertions(+), 9 deletions(-)
> >>
> >> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
> >> index fe1e4c9..5f0fc6b 100644
> >> --- a/fs/cifs/cifsencrypt.c
> >> +++ b/fs/cifs/cifsencrypt.c
> >> @@ -27,6 +27,7 @@
> >> =A0#include "md5.h"
> >> =A0#include "cifs_unicode.h"
> >> =A0#include "cifsproto.h"
> >> +#include "ntlmssp.h"
> >> =A0#include <linux/ctype.h>
> >> =A0#include <linux/random.h>
> >>
> >> @@ -263,6 +264,56 @@ void calc_lanman_hash(const char *password, c=
onst char *cryptkey, bool encrypt,
> >> =A0}
> >> =A0#endif /* CIFS_WEAK_PW_HASH */
> >>
> >> +static int
> >> +find_domain_name(struct cifsSesInfo *ses)
> >> +{
> >> + =A0 =A0 int rc =3D 0;
> >> + =A0 =A0 unsigned int attrsize;
> >> + =A0 =A0 unsigned int type;
> >> + =A0 =A0 unsigned char *blobptr;
> >> + =A0 =A0 struct ntlmssp2_name *attrptr;
> >> +
> >> + =A0 =A0 if (ses->server->tiblob) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 blobptr =3D ses->server->tiblob;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 attrptr =3D (struct ntlmssp2_name *) blo=
bptr;
> >> +
> >> + =A0 =A0 =A0 =A0 =A0 =A0 while ((type =3D attrptr->type) !=3D 0) =
{
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 blobptr +=3D 2; /* advan=
ce attr type */
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 attrsize =3D attrptr->le=
ngth;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 blobptr +=3D 2; /* advan=
ce attr size */
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (type =3D=3D NTLMSSP_=
AV_NB_DOMAIN_NAME) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!ses=
->domainName) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 ses->domainName =3D
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 kmalloc(attrptr->length + 1,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 GFP_KERNEL);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 if (!ses->domainName)
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 cifs_from_ucs2(ses->domainName,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 (__le16 *)blobptr,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 attrptr->length,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 attrptr->length,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 load_nls_default(), false);
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^^^^^
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0Doesn't
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0"load_nls_default" need
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0an "unload_nls" when
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0you're done with it?
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 blobptr +=3D attrsize; /=
* advance attr =A0value */
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 attrptr =3D (struct ntlm=
ssp2_name *) blobptr;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 }
> >> + =A0 =A0 } else {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 ses->server->tilen =3D 2 * sizeof(struct=
 ntlmssp2_name);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 ses->server->tiblob =3D kmalloc(ses->ser=
ver->tilen, GFP_KERNEL);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 if (!ses->server->tiblob) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->server->tilen =3D 0=
;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Challenge tar=
get info allocation failure");
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 }
> >> + =A0 =A0 =A0 =A0 =A0 =A0 memset(ses->server->tiblob, 0x0, ses->se=
rver->tilen);
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^^^^^^^
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0This memset can be eliminated if you=
 use kzalloc
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0instead.
>=20
> OK, will change the call.
>=20
> >
> >> + =A0 =A0 =A0 =A0 =A0 =A0 attrptr =3D (struct ntlmssp2_name *) ses=
->server->tiblob;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 attrptr->type =3D cpu_to_le16(NTLMSSP_DO=
MAIN_TYPE);
> >> + =A0 =A0 }
> >> +
> >> + =A0 =A0 return rc;
> >> +}
> >> +
> >
> > A comment describing what the above function is intended to do woul=
d be
> > nice. I can sort of guess that it's intended to parse the domain na=
me
> > out of one of the NTLMSSP blobs, but I don't quite understand what =
the
> > stuff in the big "else" clause is for. Why allocate the buffer for =
the
> > tiblob in "find_domain_name" ? It seems like that ought to be done =
in a
> > more well-defined fashion.
>=20
> Because av pairs were removed from struct ntlmv2_resp, if we are usin=
g a
> a non ntlmssp sec mech e.g. sec=3Dntlmv2/ntlmv2i, the very same tiblo=
b is
> created as it was done before.  Servers like Windows 2003 are not ver=
y
> particular about this blob and so this blob does not need all the Tar=
get Info/
> AV pairs such as dns/netbios names of the domain and server, timestam=
p etc.
> But you need that (else part) blob nonetheless for sec=3Dntlmv2i like=
 of security
> mech options.
>=20

This seems like a red flag for the design of this whole thing. This
buffer ought not be allocated in find_domain_name(). One reason is that
it's not at all obvious why a function like find_domain_name ought to
be responsible for allocating something unrelated to the domain name.
These built-in "side effects" for some functions make CIFS really hard
to understand and maintain.

The lifecycle of this the tibuf is very difficult to follow with this
design. As soon as you know the secType and whether signing is enabled,
you'll know whether you need this buffer, right? So why not allocate it
then in a single, well-defined spot?

--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
