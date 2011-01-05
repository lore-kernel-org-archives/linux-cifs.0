From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs.upcall: add 'l' to getopt_long string
Date: Wed, 5 Jan 2011 09:47:51 -0600
Message-ID: <AANLkTimLn3VLvrjc5e9iQ_HGN4=CeSaoo24VuHysQz-m@mail.gmail.com>
References: <1294241825-9979-1-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Stefan Walter <walteste-gy3b+zu4XSAfv37vnLkPlQ@public.gmane.org>
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1294241825-9979-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Jan 5, 2011 at 9:37 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> Reported-by: Stefan Walter <walteste-gy3b+zu4XSAfv37vnLkPlQ@public.gmane.org>
> Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
> =A0cifs.upcall.c | =A0 =A02 +-
> =A01 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/cifs.upcall.c b/cifs.upcall.c
> index 648a138..1ffcd7c 100644
> --- a/cifs.upcall.c
> +++ b/cifs.upcall.c
> @@ -680,7 +680,7 @@ int main(const int argc, char *const argv[])
>
> =A0 =A0 =A0 =A0openlog(prog, 0, LOG_DAEMON);
>
> - =A0 =A0 =A0 while ((c =3D getopt_long(argc, argv, "ctv", long_optio=
ns, NULL)) !=3D -1) {
> + =A0 =A0 =A0 while ((c =3D getopt_long(argc, argv, "cltv", long_opti=
ons, NULL)) !=3D -1) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0switch (c) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0case 'c':
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* legacy option -- sk=
ip it */
> --
> 1.7.3.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
Looks fine.

Reviewed-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
