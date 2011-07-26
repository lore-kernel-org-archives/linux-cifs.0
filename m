From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: fix name parsing in CIFSSMBQAllEAs
Date: Tue, 26 Jul 2011 23:44:12 +0400
Message-ID: <CAKywueRgbQgkcwKSDO=chjRZpR-4P=nqhgXy=DXfU9sajsjeDQ@mail.gmail.com>
References: <1311707000-4071-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jiali-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1311707000-4071-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/7/26 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> The code that matches EA names in CIFSSMBQAllEAs is incorrect. It
> uses strncmp to do the comparison with the length limited to the
> name_len sent in the response.
>
> Problem: Suppose we're looking for an attribute named "foobar" and
> have an attribute before it in the EA list named "foo". The
> comparison will succeed since we're only looking at the first 3
> characters. Fix this by also comparing the length of the provided
> ea_name with the name_len in the response. If they're not equal then
> it shouldn't match.
>
> Reported-by: Jian Li <jiali-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/cifssmb.c | =A0 =A08 +++++++-
> =A01 files changed, 7 insertions(+), 1 deletions(-)
>
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index c101775..ec796fc 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -5720,6 +5720,7 @@ CIFSSMBQAllEAs(const int xid, struct cifs_tcon =
*tcon,
> =A0 =A0 =A0 =A0char *temp_ptr;
> =A0 =A0 =A0 =A0char *end_of_smb;
> =A0 =A0 =A0 =A0__u16 params, byte_count, data_offset;
> + =A0 =A0 =A0 unsigned int ea_name_len;
>
> =A0 =A0 =A0 =A0cFYI(1, "In Query All EAs path %s", searchName);
> =A0QAllEAsRetry:
> @@ -5814,6 +5815,10 @@ QAllEAsRetry:
> =A0 =A0 =A0 =A0list_len -=3D 4;
> =A0 =A0 =A0 =A0temp_fea =3D ea_response_data->list;
> =A0 =A0 =A0 =A0temp_ptr =3D (char *)temp_fea;
> +
> + =A0 =A0 =A0 if (ea_name)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ea_name_len =3D strlen(ea_name);
> +
> =A0 =A0 =A0 =A0while (list_len > 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned int name_len;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__u16 value_len;
> @@ -5837,7 +5842,8 @@ QAllEAsRetry:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (ea_name) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (strncmp(ea_name, te=
mp_ptr, name_len) =3D=3D 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ea_name_len =3D=3D =
name_len &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 strncmp(ea_name=
, temp_ptr, name_len) =3D=3D 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0temp_p=
tr +=3D name_len + 1;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D=
 value_len;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (bu=
f_size =3D=3D 0)
> --
> 1.7.6

Looks good.

Reviewed-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

--=20
Best regards,
Pavel Shilovsky.
