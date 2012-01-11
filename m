From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH v3 09/15] cifscreds: add --domain flag
Date: Wed, 11 Jan 2012 13:50:12 -0500
Message-ID: <20120111135012.2f341ead@tlielax.poochiereds.net>
References: <1325873687-11229-1-git-send-email-jlayton@samba.org>
	<1325873687-11229-10-git-send-email-jlayton@samba.org>
	<CADT32eLBd=xjh3RKv+9-zzbobeBzShheSP6ugR7RmOBYRZ4oTQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32eLBd=xjh3RKv+9-zzbobeBzShheSP6ugR7RmOBYRZ4oTQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 11 Jan 2012 12:31:29 -0600
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Fri, Jan 6, 2012 at 12:14 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrot=
e:
> > ...to indicate that the first argument is not a hostname but an
> > NT domain name. If it's set, then treat the argument as a
> > string literal.
> >
> > Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> > ---
> > =C2=A0cifscreds.c | =C2=A0 64 +++++++++++++++++++++++++++++++++++++=
+++------------------
> > =C2=A01 files changed, 44 insertions(+), 20 deletions(-)
> >
> > diff --git a/cifscreds.c b/cifscreds.c
> > index f45497a..279517a 100644
> > --- a/cifscreds.c
> > +++ b/cifscreds.c
> > @@ -53,6 +53,7 @@
> > =C2=A0struct cmdarg {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0char =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0*host;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0char =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0*user;
> > + =C2=A0 =C2=A0 =C2=A0 char =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
keytype;
> > =C2=A0};
> >
> > =C2=A0struct command {
> > @@ -69,15 +70,16 @@ static int cifscreds_update(struct cmdarg *arg)=
;
> > =C2=A0const char *thisprogram;
> >
> > =C2=A0struct command commands[] =3D {
> > - =C2=A0 =C2=A0 =C2=A0 { cifscreds_add, =C2=A0 =C2=A0 =C2=A0 =C2=A0=
"add", =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0"[-u username] <host>" },
> > - =C2=A0 =C2=A0 =C2=A0 { cifscreds_clear, =C2=A0 =C2=A0 =C2=A0"clea=
r", =C2=A0 =C2=A0 =C2=A0 =C2=A0"[-u username] <host>" },
> > + =C2=A0 =C2=A0 =C2=A0 { cifscreds_add, =C2=A0 =C2=A0 =C2=A0 =C2=A0=
"add", =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0"[-u username] [-d] <host|doma=
in>" },
> > + =C2=A0 =C2=A0 =C2=A0 { cifscreds_clear, =C2=A0 =C2=A0 =C2=A0"clea=
r", =C2=A0 =C2=A0 =C2=A0 =C2=A0"[-u username] [-d] <host|domain>" },
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0{ cifscreds_clearall, =C2=A0 "clearall",=
 =C2=A0 =C2=A0 "" },
> > - =C2=A0 =C2=A0 =C2=A0 { cifscreds_update, =C2=A0 =C2=A0 "update", =
=C2=A0 =C2=A0 =C2=A0 "[-u username] <host>" },
> > + =C2=A0 =C2=A0 =C2=A0 { cifscreds_update, =C2=A0 =C2=A0 "update", =
=C2=A0 =C2=A0 =C2=A0 "[-u username] [-d] <host|domain>" },
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0{ NULL, "", NULL }
> > =C2=A0};
> >
> > =C2=A0struct option longopts[] =3D {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0{"username", 1, NULL, 'u'},
> > + =C2=A0 =C2=A0 =C2=A0 {"domain", 0, NULL, 'd' },
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0{NULL, 0, NULL, 0}
> > =C2=A0};
> >
> > @@ -98,7 +100,7 @@ usage(void)
> >
> > =C2=A0/* search a specific key in keyring */
> > =C2=A0static key_serial_t
> > -key_search(const char *addr)
> > +key_search(const char *addr, char keytype)
> > =C2=A0{
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0char desc[INET6_ADDRSTRLEN + sizeof(THIS=
_PROGRAM_NAME) + 4];
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0key_serial_t key, *pk;
> > @@ -106,7 +108,7 @@ key_search(const char *addr)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0char *buffer;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0int count, dpos, n, ret;
> >
> > - =C2=A0 =C2=A0 =C2=A0 sprintf(desc, "%s:a:%s", THIS_PROGRAM_NAME, =
addr);
> > + =C2=A0 =C2=A0 =C2=A0 sprintf(desc, "%s:%c:%s", THIS_PROGRAM_NAME,=
 keytype, addr);
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0/* read the key payload data */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0count =3D keyctl_read_alloc(DEST_KEYRING=
, &keylist);
> > @@ -206,14 +208,14 @@ key_search_all_out:
> >
> > =C2=A0/* add or update a specific key to keyring */
> > =C2=A0static key_serial_t
> > -key_add(const char *addr, const char *user, const char *pass)
> > +key_add(const char *addr, const char *user, const char *pass, char=
 keytype)
> > =C2=A0{
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0int len;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0char desc[INET6_ADDRSTRLEN + sizeof(THIS=
_PROGRAM_NAME) + 4];
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0char val[MOUNT_PASSWD_SIZE + =C2=A0MAX_U=
SERNAME_SIZE + 2];
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0/* set key description */
> > - =C2=A0 =C2=A0 =C2=A0 sprintf(desc, "%s:a:%s", THIS_PROGRAM_NAME, =
addr);
> > + =C2=A0 =C2=A0 =C2=A0 sprintf(desc, "%s:%c:%s", THIS_PROGRAM_NAME,=
 keytype, addr);
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0/* set payload contents */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0len =3D sprintf(val, "%s:%s", user, pass=
);
> > @@ -227,12 +229,16 @@ static int cifscreds_add(struct cmdarg *arg)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0char addrstr[MAX_ADDR_LIST_LEN];
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0char *currentaddress, *nextaddress;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0char *pass;
> > - =C2=A0 =C2=A0 =C2=A0 int ret;
> > + =C2=A0 =C2=A0 =C2=A0 int ret =3D 0;
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0if (arg->host =3D=3D NULL || arg->user =3D=
=3D NULL)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return usage=
();
> >
> > - =C2=A0 =C2=A0 =C2=A0 ret =3D resolve_host(arg->host, addrstr);
> > + =C2=A0 =C2=A0 =C2=A0 if (arg->keytype =3D=3D 'd')
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 strlcpy(addrstr,=
 arg->host, MAX_ADDR_LIST_LEN);
> > + =C2=A0 =C2=A0 =C2=A0 else
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D resolve_=
host(arg->host, addrstr);
> > +
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0switch (ret) {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0case EX_USAGE:
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fprintf(stde=
rr, "error: Could not resolve address "
> > @@ -256,7 +262,7 @@ static int cifscreds_add(struct cmdarg *arg)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*nextaddress=
++ =3D '\0';
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0while (currentaddress) {
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (key_search(c=
urrentaddress) > 0) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (key_search(c=
urrentaddress, arg->keytype) > 0) {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0printf("You already have stashed credentials "
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0"for %s (%s)\n", currentaddre=
ss, arg->host);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0printf("If you want to update them use:\n");
> > @@ -286,7 +292,7 @@ static int cifscreds_add(struct cmdarg *arg)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*nextaddress=
++ =3D '\0';
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0while (currentaddress) {
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 key_serial_t key=
 =3D key_add(currentaddress, arg->user, pass);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 key_serial_t key=
 =3D key_add(currentaddress, arg->user, pass, arg->keytype);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (key <=3D=
 0) {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0fprintf(stderr, "error: Add credential key for %s\n",
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0currentaddress);
> > @@ -322,12 +328,16 @@ static int cifscreds_clear(struct cmdarg *arg=
)
> > =C2=A0{
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0char addrstr[MAX_ADDR_LIST_LEN];
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0char *currentaddress, *nextaddress;
> > - =C2=A0 =C2=A0 =C2=A0 int ret, count =3D 0, errors =3D 0;
> > + =C2=A0 =C2=A0 =C2=A0 int ret =3D 0, count =3D 0, errors =3D 0;
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0if (arg->host =3D=3D NULL || arg->user =3D=
=3D NULL)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return usage=
();
> >
> > - =C2=A0 =C2=A0 =C2=A0 ret =3D resolve_host(arg->host, addrstr);
> > + =C2=A0 =C2=A0 =C2=A0 if (arg->keytype =3D=3D 'd')
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 strlcpy(addrstr,=
 arg->host, MAX_ADDR_LIST_LEN);
> > + =C2=A0 =C2=A0 =C2=A0 else
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D resolve_=
host(arg->host, addrstr);
> > +
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0switch (ret) {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0case EX_USAGE:
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fprintf(stde=
rr, "error: Could not resolve address "
> > @@ -354,7 +364,7 @@ static int cifscreds_clear(struct cmdarg *arg)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*nextaddress=
++ =3D '\0';
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0while (currentaddress) {
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 key_serial_t key=
 =3D key_search(currentaddress);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 key_serial_t key=
 =3D key_search(currentaddress, arg->keytype);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (key > 0)=
 {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0if (keyctl(KEYCTL_UNLINK, key, DEST_KEYRING) < 0) {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fprintf(stderr, "error: Remov=
ing key from "
> > @@ -427,12 +437,16 @@ static int cifscreds_update(struct cmdarg *ar=
g)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0char addrstr[MAX_ADDR_LIST_LEN];
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0char *currentaddress, *nextaddress, *pas=
s;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0char *addrs[16];
> > - =C2=A0 =C2=A0 =C2=A0 int ret, id, count =3D 0;
> > + =C2=A0 =C2=A0 =C2=A0 int ret =3D 0, id, count =3D 0;
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0if (arg->host =3D=3D NULL || arg->user =3D=
=3D NULL)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return usage=
();
> >
> > - =C2=A0 =C2=A0 =C2=A0 ret =3D resolve_host(arg->host, addrstr);
> > + =C2=A0 =C2=A0 =C2=A0 if (arg->keytype =3D=3D 'd')
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 strlcpy(addrstr,=
 arg->host, MAX_ADDR_LIST_LEN);
> > + =C2=A0 =C2=A0 =C2=A0 else
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D resolve_=
host(arg->host, addrstr);
> > +
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0switch (ret) {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0case EX_USAGE:
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fprintf(stde=
rr, "error: Could not resolve address "
> > @@ -456,7 +470,7 @@ static int cifscreds_update(struct cmdarg *arg)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*nextaddress=
++ =3D '\0';
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0while (currentaddress) {
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (key_search(c=
urrentaddress) > 0) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (key_search(c=
urrentaddress, arg->keytype) > 0) {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0addrs[count] =3D currentaddress;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0count++;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> > @@ -482,7 +496,7 @@ static int cifscreds_update(struct cmdarg *arg)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0pass =3D getpass("Password: ");
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0for (id =3D 0; id < count; id++) {
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 key_serial_t key=
 =3D key_add(addrs[id], arg->user, pass);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 key_serial_t key=
 =3D key_add(addrs[id], arg->user, pass, arg->keytype);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (key <=3D=
 0)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0fprintf(stderr, "error: Update credential key "
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0"for %s\n", addrs[id]);
> > @@ -498,6 +512,7 @@ int main(int argc, char **argv)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0int n;
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0memset(&arg, 0, sizeof(arg));
> > + =C2=A0 =C2=A0 =C2=A0 arg.keytype =3D 'a';
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0thisprogram =3D (char *)basename(argv[0]=
);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0if (thisprogram =3D=3D NULL)
> > @@ -506,8 +521,11 @@ int main(int argc, char **argv)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0if (argc =3D=3D 1)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return usage=
();
> >
> > - =C2=A0 =C2=A0 =C2=A0 while((n =3D getopt_long(argc, argv, "u:", l=
ongopts, NULL)) !=3D -1) {
> > + =C2=A0 =C2=A0 =C2=A0 while((n =3D getopt_long(argc, argv, "du:", =
longopts, NULL)) !=3D -1) {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0switch (n) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 case 'd':
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 arg.keytype =3D (char) n;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 break;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0case 'u':
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0arg.user =3D optarg;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0break;
> > @@ -544,10 +562,16 @@ int main(int argc, char **argv)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return EXIT_=
=46AILURE;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> >
> > - =C2=A0 =C2=A0 =C2=A0 /* second argument should be host */
> > + =C2=A0 =C2=A0 =C2=A0 /* second argument should be host or domain =
*/
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0if (argc >=3D 3)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0arg.host =3D=
 argv[optind + 1];
> >
> > + =C2=A0 =C2=A0 =C2=A0 if (arg.host && arg.keytype =3D=3D 'd' &&
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 strspn(arg.host, DOMAIN_ALLOWE=
D_CHARS) !=3D strnlen(arg.host, MAX_DOMAIN_SIZE)) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fprintf(stderr, =
"error: Domain name contains invalid characters\n");
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return EXIT_FAIL=
URE;
> > + =C2=A0 =C2=A0 =C2=A0 }
> > +
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0if (arg.user =3D=3D NULL)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0arg.user =3D=
 getusername(getuid());
> >
> > --
> > 1.7.7.4
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-cif=
s" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.=
html
>=20
> if we have -d and -u, why not -h or -s for servername/hostname?

Because setting keys by server is the default.
--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
