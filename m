From: Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH 3.2] cifs: ensure that uncached writes handle unmapped
 areas correctly
Date: Mon, 7 Apr 2014 14:00:39 -0400
Message-ID: <20140407140039.7e2542e9@tlielax.poochiereds.net>
References: <1396819692.13361.4.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/rRDnGCulWpt6AlI3td/JOX5"; protocol="application/pgp-signature"
Cc: Pavel Shilovsky <piastry@etersoft.ru>,
	Steve French <smfrench@gmail.com>,
	stable <stable@vger.kernel.org>, linux-cifs@vger.kernel.org
To: Ben Hutchings <ben@decadent.org.uk>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1396819692.13361.4.camel@deadeye.wl.decadent.org.uk>
Sender: stable-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

--Sig_/rRDnGCulWpt6AlI3td/JOX5
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 06 Apr 2014 22:28:12 +0100
Ben Hutchings <ben@decadent.org.uk> wrote:

> Here's the backported version I've queued up for 3.2.  It's untested;
> please let me know if you see any problem with it.
>=20
> Ben.
> ---
> From: Jeff Layton <jlayton@redhat.com>
> Date: Fri, 14 Feb 2014 07:20:35 -0500
> Subject: cifs: ensure that uncached writes handle unmapped areas correctly
>=20
> commit 5d81de8e8667da7135d3a32a964087c0faf5483f upstream.
>=20
> It's possible for userland to pass down an iovec via writev() that has a
> bogus user pointer in it. If that happens and we're doing an uncached
> write, then we can end up getting less bytes than we expect from the
> call to iov_iter_copy_from_user. This is CVE-2014-0069
>=20
> cifs_iovec_write isn't set up to handle that situation however. It'll
> blindly keep chugging through the page array and not filling those pages
> with anything useful. Worse yet, we'll later end up with a negative
> number in wdata->tailsz, which will confuse the sending routines and
> cause an oops at the very least.
>=20
> Fix this by having the copy phase of cifs_iovec_write stop copying data
> in this situation and send the last write as a short one. At the same
> time, we want to avoid sending a zero-length write to the server, so
> break out of the loop and set rc to -EFAULT if that happens. This also
> allows us to handle the case where no address in the iovec is valid.
>=20
> [Note: Marking this for stable on v3.4+ kernels, but kernels as old as
>        v2.6.38 may have a similar problem and may need similar fix]
>=20
> Reviewed-by: Pavel Shilovsky <piastry@etersoft.ru>
> Reported-by: Al Viro <viro@zeniv.linux.org.uk>
> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> Signed-off-by: Steve French <smfrench@gmail.com>
> [bwh: Backported to 3.2:
>  - Adjust context
>  - s/nr_pages/npages/
>  - s/wdata->pages/pages/
>  - In case of an error with no data copied, we must kunmap() page 0,
>    but in neither case should we free anything else]
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  fs/cifs/file.c | 37 ++++++++++++++++++++++++++++++++++---
>  1 file changed, 34 insertions(+), 3 deletions(-)
>=20
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -2107,7 +2107,7 @@ cifs_iovec_write(struct file *file, cons
>  {
>  	unsigned int written;
>  	unsigned long num_pages, npages, i;
> -	size_t copied, len, cur_len;
> +	size_t bytes, copied, len, cur_len;
>  	ssize_t total_written =3D 0;
>  	struct kvec *to_send;
>  	struct page **pages;
> @@ -2165,17 +2165,44 @@ cifs_iovec_write(struct file *file, cons
>  	do {
>  		size_t save_len =3D cur_len;
>  		for (i =3D 0; i < npages; i++) {
> -			copied =3D min_t(const size_t, cur_len, PAGE_CACHE_SIZE);
> +			bytes =3D min_t(const size_t, cur_len, PAGE_CACHE_SIZE);
>  			copied =3D iov_iter_copy_from_user(pages[i], &it, 0,
> -							 copied);
> +							 bytes);
>  			cur_len -=3D copied;
>  			iov_iter_advance(&it, copied);
>  			to_send[i+1].iov_base =3D kmap(pages[i]);
>  			to_send[i+1].iov_len =3D copied;
> +			/*
> +			 * If we didn't copy as much as we expected, then that
> +			 * may mean we trod into an unmapped area. Stop copying
> +			 * at that point. On the next pass through the big
> +			 * loop, we'll likely end up getting a zero-length
> +			 * write and bailing out of it.
> +			 */
> +			if (copied < bytes)
> +				break;
>  		}
> =20
>  		cur_len =3D save_len - cur_len;
> =20
> +		/*
> +		 * If we have no data to send, then that probably means that
> +		 * the copy above failed altogether. That's most likely because
> +		 * the address in the iovec was bogus. Set the rc to -EFAULT,
> +		 * free anything we allocated and bail out.
> +		 */
> +		if (!cur_len) {
> +			kunmap(pages[0]);
> +			rc =3D -EFAULT;
> +			break;
> +		}
> +


I don't think this looks quite right in 3.2...

If you hit the -EFAULT case above, then you'll break out of the big
(outer) do...while loop. The code that handles whether to do a short
write or an error code is in that loop, and that break will bypass it.

If you didn't actually do any I/O at that point, then cifs_iovec_write
is going to return 0 instead of -EFAULT. You'll probably need to
rejigger the error handling to make that work properly.

Looks like there's also an existing bug in there too if
cifs_reopen_file fails...

> +		/*
> +		 * i + 1 now represents the number of pages we actually used in
> +		 * the copy phase above.
> +		 */
> +		npages =3D i + 1;
> +
>  		do {
>  			if (open_file->invalidHandle) {
>  				rc =3D cifs_reopen_file(open_file, false);
>=20
>=20


--Sig_/rRDnGCulWpt6AlI3td/JOX5
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTQufHAAoJEAAOaEEZVoIVjeAP/jWD7N8aGIbDd3XJ9cI4mDlQ
yQIr0NhmQGgMwnEBH/8Cg2gTZZ/rLAXAeKBM5PPicr6c+KBX/jj+ouc7spn2q6uP
k2gIwAZ+IgGFr1cGWca9K80YVeIP1S14WAzwbeBQO/ArgyYD5DEvRb5E+YFOz8s8
GMaHOGhBC4kc5bf6DvEF4urtytTWFJUMZFa+IF4afrGG5a1QlRhHna4nyT5xojc4
vRVts51GRQJ0Ixj2PtDV0DBhjjAnhHY8MF3GSUgkL3hQt7hL3XuOF+CjlWwp2S/V
orbDVJkwLNo6y+WRLP5AI+0M2rxW7r9T9EAs0UbhTFw9cgC86yYFoIsTe5BVQ/qX
Jpan+yP3J1xnq/ntrzbLZnHNM5svNGBUsSX8DIfeFFiyf37rCwMoa3PCNfBICm8A
qFIg4FP7AVKUup11UN/cYB/vrOEVnr5a1d6TEQqpDGYrKwtt7bq+6jJTwiEnVfvi
kW/zv7Jj9PDj3S1zxsglUzhDxXFooxVevp/nX9obP9+t5sjH7TVrsBinyVWcWKoo
YQ7xS0CUzLYYhuJ8H2BIBk7sLpFalCmtB9HV8hScz0IVJMa88fmfjSNn2ulCXpwW
x4I8sPLpzk3ma/Il9H/bsWc2NVmLePM6XRgrMM1vg2hvqo3FK4C8TTP8jMPk9J+9
lR/oZzhNaAS2DX8By9tx
=tCfg
-----END PGP SIGNATURE-----

--Sig_/rRDnGCulWpt6AlI3td/JOX5--
