From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 08/15] cifscreds: make username parameter optional
Date: Wed, 11 Jan 2012 12:22:30 -0600
Message-ID: <CADT32eJAfBUozLzhobOpWq62hygwi1mfB76ZzWBfy7tKdVzhGA@mail.gmail.com>
References: <1325873687-11229-1-git-send-email-jlayton@samba.org>
	<1325873687-11229-9-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1325873687-11229-9-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Jan 6, 2012 at 12:14 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> ...and use getopt_long to get it. If someone doesn't specify the user=
name,
> use getusername() to get it.
>
> Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
> =A0cifscreds.c | =A0 39 ++++++++++++++++++++++++++++-----------
> =A01 files changed, 28 insertions(+), 11 deletions(-)
>
> diff --git a/cifscreds.c b/cifscreds.c
> index 79ab426..f45497a 100644
> --- a/cifscreds.c
> +++ b/cifscreds.c
> @@ -27,8 +27,10 @@
> =A0#include <string.h>
> =A0#include <ctype.h>
> =A0#include <keyutils.h>
> +#include <getopt.h>
> =A0#include "mount.h"
> =A0#include "resolve_host.h"
> +#include "util.h"
>
> =A0#define THIS_PROGRAM_NAME "cifscreds"
>
> @@ -49,8 +51,8 @@
> =A0#define DEST_KEYRING KEY_SPEC_USER_KEYRING
>
> =A0struct cmdarg {
> - =A0 =A0 =A0 char =A0 =A0*host;
> - =A0 =A0 =A0 char =A0 =A0*user;
> + =A0 =A0 =A0 char =A0 =A0 =A0 =A0 =A0 =A0*host;
> + =A0 =A0 =A0 char =A0 =A0 =A0 =A0 =A0 =A0*user;
> =A0};
>
> =A0struct command {
> @@ -67,13 +69,18 @@ static int cifscreds_update(struct cmdarg *arg);
> =A0const char *thisprogram;
>
> =A0struct command commands[] =3D {
> - =A0 =A0 =A0 { cifscreds_add, =A0 =A0 =A0 =A0"add", =A0 =A0 =A0 =A0 =
=A0"<host> <user>" },
> - =A0 =A0 =A0 { cifscreds_clear, =A0 =A0 =A0"clear", =A0 =A0 =A0 =A0"=
<host> <user>" },
> + =A0 =A0 =A0 { cifscreds_add, =A0 =A0 =A0 =A0"add", =A0 =A0 =A0 =A0 =
=A0"[-u username] <host>" },
> + =A0 =A0 =A0 { cifscreds_clear, =A0 =A0 =A0"clear", =A0 =A0 =A0 =A0"=
[-u username] <host>" },
> =A0 =A0 =A0 =A0{ cifscreds_clearall, =A0 "clearall", =A0 =A0 "" },
> - =A0 =A0 =A0 { cifscreds_update, =A0 =A0 "update", =A0 =A0 =A0 "<hos=
t> <user>" },
> + =A0 =A0 =A0 { cifscreds_update, =A0 =A0 "update", =A0 =A0 =A0 "[-u =
username] <host>" },
> =A0 =A0 =A0 =A0{ NULL, "", NULL }
> =A0};
>
> +struct option longopts[] =3D {
> + =A0 =A0 =A0 {"username", 1, NULL, 'u'},
> + =A0 =A0 =A0 {NULL, 0, NULL, 0}
> +};
> +
> =A0/* display usage information */
> =A0static int
> =A0usage(void)
> @@ -499,12 +506,22 @@ int main(int argc, char **argv)
> =A0 =A0 =A0 =A0if (argc =3D=3D 1)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return usage();
>
> + =A0 =A0 =A0 while((n =3D getopt_long(argc, argv, "u:", longopts, NU=
LL)) !=3D -1) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 switch (n) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 case 'u':
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 arg.user =3D optarg;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 default:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return usage();
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 }
> +
> =A0 =A0 =A0 =A0/* find the best fit command */
> =A0 =A0 =A0 =A0best =3D NULL;
> - =A0 =A0 =A0 n =3D strnlen(argv[1], MAX_COMMAND_SIZE);
> + =A0 =A0 =A0 n =3D strnlen(argv[optind], MAX_COMMAND_SIZE);
>
> =A0 =A0 =A0 =A0for (cmd =3D commands; cmd->action; cmd++) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (memcmp(cmd->name, argv[1], n) !=3D =
0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (memcmp(cmd->name, argv[optind], n) =
!=3D 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0continue;
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (cmd->name[n] =3D=3D 0) {
> @@ -527,12 +544,12 @@ int main(int argc, char **argv)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return EXIT_FAILURE;
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 /* first argument should be host */
> + =A0 =A0 =A0 /* second argument should be host */
> =A0 =A0 =A0 =A0if (argc >=3D 3)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 arg.host =3D argv[2];
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 arg.host =3D argv[optind + 1];
>
> - =A0 =A0 =A0 if (argc >=3D 4)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 arg.user =3D argv[3];
> + =A0 =A0 =A0 if (arg.user =3D=3D NULL)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 arg.user =3D getusername(getuid());
>
> =A0 =A0 =A0 =A0return best->action(&arg);
> =A0}
> --
> 1.7.7.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html

Just a thought, can user specify only one hostname and would hostname
be always the last argument for cifscreds_* commands?

I was thinking whtether an user might want to manipulate keys for
multiple servers in one command!
