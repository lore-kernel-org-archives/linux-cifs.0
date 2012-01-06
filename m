From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3] cifs: fetch credentials out of keyring for non-krb5
 auth multiuser mounts
Date: Fri, 6 Jan 2012 12:45:30 -0500
Message-ID: <20120106124530.263899db@tlielax.poochiereds.net>
References: <1325855483-8846-1-git-send-email-jlayton@redhat.com>
	<1325855483-8846-4-git-send-email-jlayton@redhat.com>
	<CADT32eJfYjK1ny4ctqdD3id03pWiKJh9j-jNVH-iEao7L6YhEA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	keyrings-6DNke4IJHB0gsBAKwltoeQ@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32eJfYjK1ny4ctqdD3id03pWiKJh9j-jNVH-iEao7L6YhEA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 6 Jan 2012 11:16:32 -0600
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Fri, Jan 6, 2012 at 7:11 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrot=
e:
> > Fix up multiuser mounts to set the secType and set the username and
> > password from the key payload in the vol info for non-krb5 auth typ=
es.
> >
> > Look for a key of type "secret" with a description of
> > "cifs:a:<server address>" or "cifs:d:<domainname>". If that's found=
,
> > then scrape the username and password out of the key payload and us=
e
> > that to create a new user session.
> >
> > Finally, don't have the code enforce krb5 auth on multiuser mounts,
> > but do require a kernel with keys support.
> >
> > Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> > =C2=A0fs/cifs/connect.c | =C2=A0176 +++++++++++++++++++++++++++++++=
+++++++++++++++++++---
> > =C2=A01 files changed, 166 insertions(+), 10 deletions(-)
> >
> > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> > index 5e96e60..48f2d15 100644
> > --- a/fs/cifs/connect.c
> > +++ b/fs/cifs/connect.c
> > @@ -38,6 +38,7 @@
> > =C2=A0#include <asm/processor.h>
> > =C2=A0#include <linux/inet.h>
> > =C2=A0#include <linux/module.h>
> > +#include <keys/user-type.h>
> > =C2=A0#include <net/ipv6.h>
> > =C2=A0#include "cifspdu.h"
> > =C2=A0#include "cifsglob.h"
> > @@ -1594,11 +1595,14 @@ cifs_parse_mount_options(const char *mountd=
ata, const char *devname,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> >
> > - =C2=A0 =C2=A0 =C2=A0 if (vol->multiuser && !(vol->secFlg & CIFSSE=
C_MAY_KRB5)) {
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cERROR(1, "Multi=
user mounts currently require krb5 "
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 "authentication!");
> > +#ifndef CONFIG_KEYS
> > + =C2=A0 =C2=A0 =C2=A0 /* Muliuser mounts require CONFIG_KEYS suppo=
rt */
> > + =C2=A0 =C2=A0 =C2=A0 if (vol->multiuser) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cERROR(1, "Multi=
user mounts require kernels with "
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 "CONFIG_KEYS enabled.");
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto cifs_pa=
rse_mount_err;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> > +#endif
>=20
> Will this break existing setups when those users update kernel
> and/or update cifs module?
>=20

No. Why would it? You need keys support for krb5 auth.

> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0if (vol->UNCip =3D=3D NULL)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0vol->UNCip =3D=
 &vol->UNC[2];
> > @@ -2061,6 +2065,133 @@ cifs_put_smb_ses(struct cifs_ses *ses)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0cifs_put_tcp_session(server);
> > =C2=A0}
> >
> > +#ifdef CONFIG_KEYS
> > +
> > +/* strlen("cifs:a:") + INET6_ADDRSTRLEN + 1 */
> > +#define CIFSCREDS_DESC_SIZE (7 + INET6_ADDRSTRLEN + 1)
> > +
> > +/* Populate username and pw fields from keyring if possible */
> > +static int
> > +cifs_set_cifscreds(struct smb_vol *vol, struct cifs_ses *ses)
> > +{
> > + =C2=A0 =C2=A0 =C2=A0 int rc =3D 0;
> > + =C2=A0 =C2=A0 =C2=A0 char *desc, *delim, *payload;
> > + =C2=A0 =C2=A0 =C2=A0 ssize_t len;
> > + =C2=A0 =C2=A0 =C2=A0 struct key *key;
> > + =C2=A0 =C2=A0 =C2=A0 struct TCP_Server_Info *server =3D ses->serv=
er;
> > + =C2=A0 =C2=A0 =C2=A0 struct sockaddr_in *sa;
> > + =C2=A0 =C2=A0 =C2=A0 struct sockaddr_in6 *sa6;
> > + =C2=A0 =C2=A0 =C2=A0 struct user_key_payload *upayload;
> > +
> > + =C2=A0 =C2=A0 =C2=A0 desc =3D kmalloc(CIFSCREDS_DESC_SIZE, GFP_KE=
RNEL);
> > + =C2=A0 =C2=A0 =C2=A0 if (!desc)
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -ENOMEM;
> > +
> > + =C2=A0 =C2=A0 =C2=A0 /* try to find an address key first */
> > + =C2=A0 =C2=A0 =C2=A0 switch (server->dstaddr.ss_family) {
> > + =C2=A0 =C2=A0 =C2=A0 case AF_INET:
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sa =3D (struct s=
ockaddr_in *)&server->dstaddr;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sprintf(desc, "c=
ifs:a:%pI4", &sa->sin_addr.s_addr);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> > + =C2=A0 =C2=A0 =C2=A0 case AF_INET6:
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sa6 =3D (struct =
sockaddr_in6 *)&server->dstaddr;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sprintf(desc, "c=
ifs:a:%pI6c", &sa6->sin6_addr.s6_addr);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> > + =C2=A0 =C2=A0 =C2=A0 default:
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cFYI(1, "Bad ss_=
family (%hu)", server->dstaddr.ss_family);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D -EINVAL;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out_err;
> > + =C2=A0 =C2=A0 =C2=A0 }
> > +
> > + =C2=A0 =C2=A0 =C2=A0 cFYI(1, "%s: desc=3D%s", __func__, desc);
> > + =C2=A0 =C2=A0 =C2=A0 key =3D request_key(&key_type_secret, desc, =
"");
> > + =C2=A0 =C2=A0 =C2=A0 if (IS_ERR(key)) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!ses->domain=
Name) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 cFYI(1, "domainName is NULL");
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 rc =3D PTR_ERR(key);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 goto out_err;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> > +
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* didn't work, =
try to find a domain key */
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sprintf(desc, "c=
ifs:d:%s", ses->domainName);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cFYI(1, "%s: des=
c=3D%s", __func__, desc);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 key =3D request_=
key(&key_type_secret, desc, "");
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (IS_ERR(key))=
 {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 rc =3D PTR_ERR(key);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 goto out_err;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> > + =C2=A0 =C2=A0 =C2=A0 }
> > +
> > + =C2=A0 =C2=A0 =C2=A0 down_read(&key->sem);
> > + =C2=A0 =C2=A0 =C2=A0 upayload =3D key->payload.data;
> > + =C2=A0 =C2=A0 =C2=A0 if (IS_ERR_OR_NULL(upayload)) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D PTR_ERR(k=
ey);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out_key_put=
;
> > + =C2=A0 =C2=A0 =C2=A0 }
> > +
> > + =C2=A0 =C2=A0 =C2=A0 /* find first : in payload */
> > + =C2=A0 =C2=A0 =C2=A0 payload =3D (char *)upayload->data;
> > + =C2=A0 =C2=A0 =C2=A0 delim =3D strnchr(payload, upayload->datalen=
, ':');
> > + =C2=A0 =C2=A0 =C2=A0 cFYI(1, "payload=3D%s", payload);
> > + =C2=A0 =C2=A0 =C2=A0 if (!delim) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cFYI(1, "Unable =
to find ':' in payload (datalen=3D%d)",
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 upayload->datalen);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D -EINVAL;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out_key_put=
;
> > + =C2=A0 =C2=A0 =C2=A0 }
> > +
> > + =C2=A0 =C2=A0 =C2=A0 len =3D delim - payload;
> > + =C2=A0 =C2=A0 =C2=A0 if (len > MAX_USERNAME_SIZE || len <=3D 0) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cFYI(1, "Bad val=
ue from username search (len=3D%ld)", len);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D -EINVAL;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out_key_put=
;
> > + =C2=A0 =C2=A0 =C2=A0 }
> > +
> > + =C2=A0 =C2=A0 =C2=A0 vol->username =3D kstrndup(payload, len, GFP=
_KERNEL);
> > + =C2=A0 =C2=A0 =C2=A0 if (!vol->username) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cFYI(1, "Unable =
to allocate %ld bytes for username", len);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D -ENOMEM;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out_key_put=
;
> > + =C2=A0 =C2=A0 =C2=A0 }
> > + =C2=A0 =C2=A0 =C2=A0 cFYI(1, "username=3D%s", vol->username);
> > +
> > + =C2=A0 =C2=A0 =C2=A0 len =3D key->datalen - (len + 1);
> > + =C2=A0 =C2=A0 =C2=A0 if (len > MAX_PASSWORD_SIZE || len <=3D 0) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cFYI(1, "Bad len=
 for password search (len=3D%ld)", len);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D -EINVAL;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 kfree(vol->usern=
ame);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 vol->username =3D=
 NULL;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out_key_put=
;
> > + =C2=A0 =C2=A0 =C2=A0 }
> > +
> > + =C2=A0 =C2=A0 =C2=A0 ++delim;
> > + =C2=A0 =C2=A0 =C2=A0 vol->password =3D kstrndup(delim, len, GFP_K=
ERNEL);
> > + =C2=A0 =C2=A0 =C2=A0 if (!vol->password) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cFYI(1, "Unable =
to allocate %ld bytes for password", len);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D -ENOMEM;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 kfree(vol->usern=
ame);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 vol->username =3D=
 NULL;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out_key_put=
;
> > + =C2=A0 =C2=A0 =C2=A0 }
> > + =C2=A0 =C2=A0 =C2=A0 cFYI(1, "password=3D%s", vol->password);
>=20
> I would be wary of printing the password.
>=20

Good point. I had that in there when I was debugging this, but I think
I can remove it now.

> > +
> > +out_key_put:
> > + =C2=A0 =C2=A0 =C2=A0 up_read(&key->sem);
> > + =C2=A0 =C2=A0 =C2=A0 key_put(key);
> > +out_err:
> > + =C2=A0 =C2=A0 =C2=A0 kfree(desc);
> > + =C2=A0 =C2=A0 =C2=A0 cFYI(1, "%s: returning %d", __func__, rc);
> > + =C2=A0 =C2=A0 =C2=A0 return rc;
> > +}
> > +#else /* ! CONFIG_KEYS */
> > +static inline int
> > +cifs_set_cifscreds(struct smb_vol *vol __attribute__((unused)),
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0str=
uct cifs_ses *ses __attribute__((unused)))
> > +{
> > + =C2=A0 =C2=A0 =C2=A0 return -ENOSYS;
> > +}
> > +#endif /* CONFIG_KEYS */
> > +
> > =C2=A0static bool warned_on_ntlm; =C2=A0/* globals init to false au=
tomatically */
> >
> > =C2=A0static struct cifs_ses *
> > @@ -3678,16 +3809,38 @@ int cifs_setup_session(unsigned int xid, st=
ruct cifs_ses *ses,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0return rc;
> > =C2=A0}
> >
> > +static int
> > +cifs_set_vol_auth(struct smb_vol *vol, struct cifs_ses *ses)
> > +{
> > + =C2=A0 =C2=A0 =C2=A0 switch(ses->server->secType) {
> > + =C2=A0 =C2=A0 =C2=A0 case Kerberos:
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 vol->secFlg =3D =
CIFSSEC_MUST_KRB5;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;
> > + =C2=A0 =C2=A0 =C2=A0 case NTLMv2:
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 vol->secFlg =3D =
CIFSSEC_MUST_NTLMV2;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> > + =C2=A0 =C2=A0 =C2=A0 case NTLM:
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 vol->secFlg =3D =
CIFSSEC_MUST_NTLM;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> > + =C2=A0 =C2=A0 =C2=A0 case RawNTLMSSP:
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 vol->secFlg =3D =
CIFSSEC_MAY_NTLMSSP;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> > + =C2=A0 =C2=A0 =C2=A0 case LANMAN:
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 vol->secFlg =3D =
CIFSSEC_MAY_LANMAN;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> > + =C2=A0 =C2=A0 =C2=A0 }

Also, since we're critiquing this patch, the MAYs above should probably
be MUSTs.

> > +
> > + =C2=A0 =C2=A0 =C2=A0 return cifs_set_cifscreds(vol, ses);
> > +}
> > +
> > =C2=A0static struct cifs_tcon *
> > =C2=A0cifs_construct_tcon(struct cifs_sb_info *cifs_sb, uid_t fsuid=
)
> > =C2=A0{
> > + =C2=A0 =C2=A0 =C2=A0 int rc;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0struct cifs_tcon *master_tcon =3D cifs_s=
b_master_tcon(cifs_sb);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0struct cifs_ses *ses;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0struct cifs_tcon *tcon =3D NULL;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0struct smb_vol *vol_info;
> > - =C2=A0 =C2=A0 =C2=A0 char username[28]; /* big enough for "krb50x=
" + hex of ULONG_MAX 6+16 */
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0/* We used to have this as MAX_USERNAME which i=
s =C2=A0 */
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0/* way too big now (256 instead of 32) */
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0vol_info =3D kzalloc(sizeof(*vol_info), =
GFP_KERNEL);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0if (vol_info =3D=3D NULL) {
> > @@ -3695,8 +3848,6 @@ cifs_construct_tcon(struct cifs_sb_info *cifs=
_sb, uid_t fsuid)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> >
> > - =C2=A0 =C2=A0 =C2=A0 snprintf(username, sizeof(username), "krb50x=
%x", fsuid);
> > - =C2=A0 =C2=A0 =C2=A0 vol_info->username =3D username;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0vol_info->local_nls =3D cifs_sb->local_n=
ls;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0vol_info->linux_uid =3D fsuid;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0vol_info->cred_uid =3D fsuid;
> > @@ -3706,8 +3857,11 @@ cifs_construct_tcon(struct cifs_sb_info *cif=
s_sb, uid_t fsuid)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0vol_info->local_lease =3D master_tcon->l=
ocal_lease;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0vol_info->no_linux_ext =3D !master_tcon-=
>unix_ext;
> >
> > - =C2=A0 =C2=A0 =C2=A0 /* FIXME: allow for other secFlg settings */
> > - =C2=A0 =C2=A0 =C2=A0 vol_info->secFlg =3D CIFSSEC_MUST_KRB5;
> > + =C2=A0 =C2=A0 =C2=A0 rc =3D cifs_set_vol_auth(vol_info, master_tc=
on->ses);
> > + =C2=A0 =C2=A0 =C2=A0 if (rc) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 tcon =3D ERR_PTR=
(rc);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out;
> > + =C2=A0 =C2=A0 =C2=A0 }
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0/* get a reference for the same TCP sess=
ion */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0spin_lock(&cifs_tcp_ses_lock);
> > @@ -3730,6 +3884,8 @@ cifs_construct_tcon(struct cifs_sb_info *cifs=
_sb, uid_t fsuid)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ses->capabilities & CAP_UNIX)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0reset_cifs_u=
nix_caps(0, tcon, NULL, vol_info);
> > =C2=A0out:
> > + =C2=A0 =C2=A0 =C2=A0 kfree(vol_info->username);
> > + =C2=A0 =C2=A0 =C2=A0 kfree(vol_info->password);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0kfree(vol_info);
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0return tcon;
> > --
> > 1.7.7.4
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-cif=
s" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.=
html


--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
