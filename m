From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 09/15] cifscreds: add --domain flag
Date: Wed, 11 Jan 2012 12:31:29 -0600
Message-ID: <CADT32eLBd=xjh3RKv+9-zzbobeBzShheSP6ugR7RmOBYRZ4oTQ@mail.gmail.com>
References: <1325873687-11229-1-git-send-email-jlayton@samba.org>
	<1325873687-11229-10-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1325873687-11229-10-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Jan 6, 2012 at 12:14 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> ...to indicate that the first argument is not a hostname but an
> NT domain name. If it's set, then treat the argument as a
> string literal.
>
> Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
> =A0cifscreds.c | =A0 64 ++++++++++++++++++++++++++++++++++++++++-----=
-------------
> =A01 files changed, 44 insertions(+), 20 deletions(-)
>
> diff --git a/cifscreds.c b/cifscreds.c
> index f45497a..279517a 100644
> --- a/cifscreds.c
> +++ b/cifscreds.c
> @@ -53,6 +53,7 @@
> =A0struct cmdarg {
> =A0 =A0 =A0 =A0char =A0 =A0 =A0 =A0 =A0 =A0*host;
> =A0 =A0 =A0 =A0char =A0 =A0 =A0 =A0 =A0 =A0*user;
> + =A0 =A0 =A0 char =A0 =A0 =A0 =A0 =A0 =A0keytype;
> =A0};
>
> =A0struct command {
> @@ -69,15 +70,16 @@ static int cifscreds_update(struct cmdarg *arg);
> =A0const char *thisprogram;
>
> =A0struct command commands[] =3D {
> - =A0 =A0 =A0 { cifscreds_add, =A0 =A0 =A0 =A0"add", =A0 =A0 =A0 =A0 =
=A0"[-u username] <host>" },
> - =A0 =A0 =A0 { cifscreds_clear, =A0 =A0 =A0"clear", =A0 =A0 =A0 =A0"=
[-u username] <host>" },
> + =A0 =A0 =A0 { cifscreds_add, =A0 =A0 =A0 =A0"add", =A0 =A0 =A0 =A0 =
=A0"[-u username] [-d] <host|domain>" },
> + =A0 =A0 =A0 { cifscreds_clear, =A0 =A0 =A0"clear", =A0 =A0 =A0 =A0"=
[-u username] [-d] <host|domain>" },
> =A0 =A0 =A0 =A0{ cifscreds_clearall, =A0 "clearall", =A0 =A0 "" },
> - =A0 =A0 =A0 { cifscreds_update, =A0 =A0 "update", =A0 =A0 =A0 "[-u =
username] <host>" },
> + =A0 =A0 =A0 { cifscreds_update, =A0 =A0 "update", =A0 =A0 =A0 "[-u =
username] [-d] <host|domain>" },
> =A0 =A0 =A0 =A0{ NULL, "", NULL }
> =A0};
>
> =A0struct option longopts[] =3D {
> =A0 =A0 =A0 =A0{"username", 1, NULL, 'u'},
> + =A0 =A0 =A0 {"domain", 0, NULL, 'd' },
> =A0 =A0 =A0 =A0{NULL, 0, NULL, 0}
> =A0};
>
> @@ -98,7 +100,7 @@ usage(void)
>
> =A0/* search a specific key in keyring */
> =A0static key_serial_t
> -key_search(const char *addr)
> +key_search(const char *addr, char keytype)
> =A0{
> =A0 =A0 =A0 =A0char desc[INET6_ADDRSTRLEN + sizeof(THIS_PROGRAM_NAME)=
 + 4];
> =A0 =A0 =A0 =A0key_serial_t key, *pk;
> @@ -106,7 +108,7 @@ key_search(const char *addr)
> =A0 =A0 =A0 =A0char *buffer;
> =A0 =A0 =A0 =A0int count, dpos, n, ret;
>
> - =A0 =A0 =A0 sprintf(desc, "%s:a:%s", THIS_PROGRAM_NAME, addr);
> + =A0 =A0 =A0 sprintf(desc, "%s:%c:%s", THIS_PROGRAM_NAME, keytype, a=
ddr);
>
> =A0 =A0 =A0 =A0/* read the key payload data */
> =A0 =A0 =A0 =A0count =3D keyctl_read_alloc(DEST_KEYRING, &keylist);
> @@ -206,14 +208,14 @@ key_search_all_out:
>
> =A0/* add or update a specific key to keyring */
> =A0static key_serial_t
> -key_add(const char *addr, const char *user, const char *pass)
> +key_add(const char *addr, const char *user, const char *pass, char k=
eytype)
> =A0{
> =A0 =A0 =A0 =A0int len;
> =A0 =A0 =A0 =A0char desc[INET6_ADDRSTRLEN + sizeof(THIS_PROGRAM_NAME)=
 + 4];
> =A0 =A0 =A0 =A0char val[MOUNT_PASSWD_SIZE + =A0MAX_USERNAME_SIZE + 2]=
;
>
> =A0 =A0 =A0 =A0/* set key description */
> - =A0 =A0 =A0 sprintf(desc, "%s:a:%s", THIS_PROGRAM_NAME, addr);
> + =A0 =A0 =A0 sprintf(desc, "%s:%c:%s", THIS_PROGRAM_NAME, keytype, a=
ddr);
>
> =A0 =A0 =A0 =A0/* set payload contents */
> =A0 =A0 =A0 =A0len =3D sprintf(val, "%s:%s", user, pass);
> @@ -227,12 +229,16 @@ static int cifscreds_add(struct cmdarg *arg)
> =A0 =A0 =A0 =A0char addrstr[MAX_ADDR_LIST_LEN];
> =A0 =A0 =A0 =A0char *currentaddress, *nextaddress;
> =A0 =A0 =A0 =A0char *pass;
> - =A0 =A0 =A0 int ret;
> + =A0 =A0 =A0 int ret =3D 0;
>
> =A0 =A0 =A0 =A0if (arg->host =3D=3D NULL || arg->user =3D=3D NULL)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return usage();
>
> - =A0 =A0 =A0 ret =3D resolve_host(arg->host, addrstr);
> + =A0 =A0 =A0 if (arg->keytype =3D=3D 'd')
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 strlcpy(addrstr, arg->host, MAX_ADDR_LI=
ST_LEN);
> + =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D resolve_host(arg->host, addrstr=
);
> +
> =A0 =A0 =A0 =A0switch (ret) {
> =A0 =A0 =A0 =A0case EX_USAGE:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fprintf(stderr, "error: Could not reso=
lve address "
> @@ -256,7 +262,7 @@ static int cifscreds_add(struct cmdarg *arg)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*nextaddress++ =3D '\0';
>
> =A0 =A0 =A0 =A0while (currentaddress) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (key_search(currentaddress) > 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (key_search(currentaddress, arg->key=
type) > 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printf("You already ha=
ve stashed credentials "
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"for %=
s (%s)\n", currentaddress, arg->host);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printf("If you want to=
 update them use:\n");
> @@ -286,7 +292,7 @@ static int cifscreds_add(struct cmdarg *arg)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*nextaddress++ =3D '\0';
>
> =A0 =A0 =A0 =A0while (currentaddress) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 key_serial_t key =3D key_add(currentadd=
ress, arg->user, pass);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 key_serial_t key =3D key_add(currentadd=
ress, arg->user, pass, arg->keytype);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (key <=3D 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fprintf(stderr, "error=
: Add credential key for %s\n",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0curren=
taddress);
> @@ -322,12 +328,16 @@ static int cifscreds_clear(struct cmdarg *arg)
> =A0{
> =A0 =A0 =A0 =A0char addrstr[MAX_ADDR_LIST_LEN];
> =A0 =A0 =A0 =A0char *currentaddress, *nextaddress;
> - =A0 =A0 =A0 int ret, count =3D 0, errors =3D 0;
> + =A0 =A0 =A0 int ret =3D 0, count =3D 0, errors =3D 0;
>
> =A0 =A0 =A0 =A0if (arg->host =3D=3D NULL || arg->user =3D=3D NULL)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return usage();
>
> - =A0 =A0 =A0 ret =3D resolve_host(arg->host, addrstr);
> + =A0 =A0 =A0 if (arg->keytype =3D=3D 'd')
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 strlcpy(addrstr, arg->host, MAX_ADDR_LI=
ST_LEN);
> + =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D resolve_host(arg->host, addrstr=
);
> +
> =A0 =A0 =A0 =A0switch (ret) {
> =A0 =A0 =A0 =A0case EX_USAGE:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fprintf(stderr, "error: Could not reso=
lve address "
> @@ -354,7 +364,7 @@ static int cifscreds_clear(struct cmdarg *arg)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*nextaddress++ =3D '\0';
>
> =A0 =A0 =A0 =A0while (currentaddress) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 key_serial_t key =3D key_search(current=
address);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 key_serial_t key =3D key_search(current=
address, arg->keytype);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (key > 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (keyctl(KEYCTL_UNLI=
NK, key, DEST_KEYRING) < 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fprint=
f(stderr, "error: Removing key from "
> @@ -427,12 +437,16 @@ static int cifscreds_update(struct cmdarg *arg)
> =A0 =A0 =A0 =A0char addrstr[MAX_ADDR_LIST_LEN];
> =A0 =A0 =A0 =A0char *currentaddress, *nextaddress, *pass;
> =A0 =A0 =A0 =A0char *addrs[16];
> - =A0 =A0 =A0 int ret, id, count =3D 0;
> + =A0 =A0 =A0 int ret =3D 0, id, count =3D 0;
>
> =A0 =A0 =A0 =A0if (arg->host =3D=3D NULL || arg->user =3D=3D NULL)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return usage();
>
> - =A0 =A0 =A0 ret =3D resolve_host(arg->host, addrstr);
> + =A0 =A0 =A0 if (arg->keytype =3D=3D 'd')
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 strlcpy(addrstr, arg->host, MAX_ADDR_LI=
ST_LEN);
> + =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D resolve_host(arg->host, addrstr=
);
> +
> =A0 =A0 =A0 =A0switch (ret) {
> =A0 =A0 =A0 =A0case EX_USAGE:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fprintf(stderr, "error: Could not reso=
lve address "
> @@ -456,7 +470,7 @@ static int cifscreds_update(struct cmdarg *arg)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*nextaddress++ =3D '\0';
>
> =A0 =A0 =A0 =A0while (currentaddress) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (key_search(currentaddress) > 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (key_search(currentaddress, arg->key=
type) > 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0addrs[count] =3D curre=
ntaddress;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0count++;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> @@ -482,7 +496,7 @@ static int cifscreds_update(struct cmdarg *arg)
> =A0 =A0 =A0 =A0pass =3D getpass("Password: ");
>
> =A0 =A0 =A0 =A0for (id =3D 0; id < count; id++) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 key_serial_t key =3D key_add(addrs[id],=
 arg->user, pass);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 key_serial_t key =3D key_add(addrs[id],=
 arg->user, pass, arg->keytype);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (key <=3D 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fprintf(stderr, "error=
: Update credential key "
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"for %=
s\n", addrs[id]);
> @@ -498,6 +512,7 @@ int main(int argc, char **argv)
> =A0 =A0 =A0 =A0int n;
>
> =A0 =A0 =A0 =A0memset(&arg, 0, sizeof(arg));
> + =A0 =A0 =A0 arg.keytype =3D 'a';
>
> =A0 =A0 =A0 =A0thisprogram =3D (char *)basename(argv[0]);
> =A0 =A0 =A0 =A0if (thisprogram =3D=3D NULL)
> @@ -506,8 +521,11 @@ int main(int argc, char **argv)
> =A0 =A0 =A0 =A0if (argc =3D=3D 1)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return usage();
>
> - =A0 =A0 =A0 while((n =3D getopt_long(argc, argv, "u:", longopts, NU=
LL)) !=3D -1) {
> + =A0 =A0 =A0 while((n =3D getopt_long(argc, argv, "du:", longopts, N=
ULL)) !=3D -1) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0switch (n) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 case 'd':
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 arg.keytype =3D (char) =
n;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0case 'u':
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0arg.user =3D optarg;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> @@ -544,10 +562,16 @@ int main(int argc, char **argv)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return EXIT_FAILURE;
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 /* second argument should be host */
> + =A0 =A0 =A0 /* second argument should be host or domain */
> =A0 =A0 =A0 =A0if (argc >=3D 3)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0arg.host =3D argv[optind + 1];
>
> + =A0 =A0 =A0 if (arg.host && arg.keytype =3D=3D 'd' &&
> + =A0 =A0 =A0 =A0 =A0 strspn(arg.host, DOMAIN_ALLOWED_CHARS) !=3D str=
nlen(arg.host, MAX_DOMAIN_SIZE)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 fprintf(stderr, "error: Domain name con=
tains invalid characters\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return EXIT_FAILURE;
> + =A0 =A0 =A0 }
> +
> =A0 =A0 =A0 =A0if (arg.user =3D=3D NULL)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0arg.user =3D getusername(getuid());
>
> --
> 1.7.7.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html

if we have -d and -u, why not -h or -s for servername/hostname?
