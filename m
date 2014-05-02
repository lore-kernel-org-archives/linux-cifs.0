From: Jeff Layton <jlayton@poochiereds.net>
Subject: Re: [PATCH 1/2] cifs: Use min_t() when comparing "size_t" and
 "unsigned long"
Date: Fri, 2 May 2014 15:55:25 -0400
Message-ID: <20140502155525.02dde4de@tlielax.poochiereds.net>
References: <1397414783-28098-1-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Steve
 French <sfrench@samba.org>, linux-cifs@vger.kernel.org, Hugh Dickins
 <hughd@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1397414783-28098-1-git-send-email-geert@linux-m68k.org>
Sender: owner-linux-mm@kvack.org
List-Id: linux-cifs.vger.kernel.org

On Sun, 13 Apr 2014 20:46:21 +0200
Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> On 32 bit, size_t is "unsigned int", not "unsigned long", causing the
> following warning when comparing with PAGE_SIZE, which is always "unsigned
> long":
>=20
> fs/cifs/file.c: In function =E2=80=98cifs_readdata_to_iov=E2=80=99:
> fs/cifs/file.c:2757: warning: comparison of distinct pointer types lacks =
a cast
>=20
> Introduced by commit 7f25bba819a38ab7310024a9350655f374707e20
> ("cifs_iovec_read: keep iov_iter between the calls of
> cifs_readdata_to_iov()"), which changed the signedness of "remaining"
> and the code from min_t() to min().
>=20
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
> PAGE_SIZE should really be size_t, but that would require lots of changes
> all over the place.
>=20
>  fs/cifs/file.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 8807442c94dd..8add25538a3b 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -2754,7 +2754,7 @@ cifs_readdata_to_iov(struct cifs_readdata *rdata, s=
truct iov_iter *iter)
> =20
>  	for (i =3D 0; i < rdata->nr_pages; i++) {
>  		struct page *page =3D rdata->pages[i];
> -		size_t copy =3D min(remaining, PAGE_SIZE);
> +		size_t copy =3D min_t(size_t, remaining, PAGE_SIZE);
>  		size_t written =3D copy_page_to_iter(page, 0, copy, iter);
>  		remaining -=3D written;
>  		if (written < copy && iov_iter_count(iter) > 0)

Reviewed-by: Jeff Layton <jlayton@poochiereds.net>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
