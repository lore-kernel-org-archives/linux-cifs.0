From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] cifs-utils: fix up some compiler warnings in asn1.c
Date: Wed, 18 Apr 2012 15:53:52 -0400
Message-ID: <20120418155352.4a93a55c@corrin.poochiereds.net>
References: <1334490685-14366-1-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1334490685-14366-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, 15 Apr 2012 07:51:25 -0400
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> These have been around for quite some time.
>=20
> gcc -DHAVE_CONFIG_H -I.    -Wall -Wextra -g -O2 -MT asn1.o -MD -MP -M=
=46
> .deps/asn1.Tpo -c -o asn1.o asn1.c
> asn1.c: In function =E2=80=98asn1_write=E2=80=99:
> asn1.c:45:19: warning: comparison between signed and unsigned integer
> expressions [-Wsign-compare]
> asn1.c: In function =E2=80=98asn1_peek=E2=80=99:
> asn1.c:411:22: warning: comparison between signed and unsigned intege=
r
> expressions [-Wsign-compare]
> asn1.c: In function =E2=80=98asn1_tag_remaining=E2=80=99:
> asn1.c:541:16: warning: comparison between signed and unsigned intege=
r
> expressions [-Wsign-compare]
> asn1.c: In function =E2=80=98_ber_read_OID_String_impl=E2=80=99:
> asn1.c:570:22: warning: comparison between signed and unsigned intege=
r
> expressions [-Wsign-compare]
>=20
> Almost all of these are due to the fact that asn1_data->ofs is a
> signed value, and ->length is unsigned. In most cases, I've fixed
> it by casting ofs to an unsigned value, but in one case, I cast
> length to a signed value since it looked possible for the result
> to go negative.
>=20
> Hopefully the values here will always be small enough that this is
> never a real problem.
>=20
> This should clear the way to add -Werror to the cflags in the near
> future.
>=20
> Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  asn1.c |   11 ++++++-----
>  1 files changed, 6 insertions(+), 5 deletions(-)
>=20
> diff --git a/asn1.c b/asn1.c
> index 4103419..34475b6 100644
> --- a/asn1.c
> +++ b/asn1.c
> @@ -41,8 +41,9 @@ void asn1_free(struct asn1_data *data)
>  /* write to the ASN1 buffer, advancing the buffer pointer */
>  bool asn1_write(struct asn1_data *data, const void *p, int len)
>  {
> -	if (data->has_error) return false;
> -	if (data->length < data->ofs+len) {
> +	if (data->has_error)
> +		return false;
> +	if (data->length < (size_t)data->ofs + len) {
>  		uint8_t *newp;
>  		newp =3D talloc_realloc(data, data->data, uint8_t, data->ofs+len);
>  		if (!newp) {
> @@ -408,7 +409,7 @@ bool asn1_peek(struct asn1_data *data, void *p, i=
nt len)
>  	if (len < 0 || data->ofs + len < data->ofs || data->ofs + len < len=
)
>  		return false;
> =20
> -	if (data->ofs + len > data->length) {
> +	if ((size_t)data->ofs + len > data->length) {
>  		/* we need to mark the buffer as consumed, so the caller knows
>  		   this was an out of data error, and not a decode error */
>  		data->ofs =3D data->length;
> @@ -538,7 +539,7 @@ int asn1_tag_remaining(struct asn1_data *data)
>  		return -1;
>  	}
>  	remaining =3D data->nesting->taglen - (data->ofs - data->nesting->s=
tart);
> -	if (remaining > (data->length - data->ofs)) {
> +	if (remaining > (ssize_t)data->length - data->ofs) {
>  		data->has_error =3D true;
>  		return -1;
>  	}
> @@ -553,7 +554,7 @@ int asn1_tag_remaining(struct asn1_data *data)
>  static bool _ber_read_OID_String_impl(TALLOC_CTX *mem_ctx, DATA_BLOB=
 blob,
>  					const char **OID, size_t *bytes_eaten)
>  {
> -	int i;
> +	unsigned int i;
>  	uint8_t *b;
>  	unsigned int v;
>  	char *tmp_oid =3D NULL;

Merged...
--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
