From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs.upcall: fix crash when trying to free uninitialized var
Date: Fri, 7 Jan 2011 12:01:24 -0600
Message-ID: <AANLkTi=ydfD5NEKoc=_ffqYkDMj_cW1whhXKiHrGa7SN@mail.gmail.com>
References: <1294241851-10013-1-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Stefan Walter <walteste-gy3b+zu4XSAfv37vnLkPlQ@public.gmane.org>
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1294241851-10013-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Jan 5, 2011 at 9:37 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> If cifs.upcall is passed an invalid argument then it will "goto out".
> The decoded_args struct however is uninitialized at that point so it
> will usually segfault when trying to free fields in it. Move the
> initialization up in the function.
>
> Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
> =A0cifs.upcall.c | =A0 =A03 +--
> =A01 files changed, 1 insertions(+), 2 deletions(-)
>
> diff --git a/cifs.upcall.c b/cifs.upcall.c
> index 1ffcd7c..34b0638 100644
> --- a/cifs.upcall.c
> +++ b/cifs.upcall.c
> @@ -677,6 +677,7 @@ int main(const int argc, char *const argv[])
> =A0 =A0 =A0 =A0const char *oid;
>
> =A0 =A0 =A0 =A0hostbuf[0] =3D '\0';
> + =A0 =A0 =A0 memset(&arg, 0, sizeof(arg));
>
> =A0 =A0 =A0 =A0openlog(prog, 0, LOG_DAEMON);
>
> @@ -731,8 +732,6 @@ int main(const int argc, char *const argv[])
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 memset(&arg, 0, sizeof(arg));
> -
> =A0 =A0 =A0 =A0have =3D decode_key_description(buf, &arg);
> =A0 =A0 =A0 =A0SAFE_FREE(buf);
> =A0 =A0 =A0 =A0if ((have & DKD_MUSTHAVE_SET) !=3D DKD_MUSTHAVE_SET) {
> --
> 1.7.3.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Looks correct but something like would do the same (and save a memset c=
all?)

struct decoded_args arg =3D {0};
