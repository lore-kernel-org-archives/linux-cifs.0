From: Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 3.2] cifs: ensure that uncached writes handle unmapped areas
 correctly
Date: Sun, 06 Apr 2014 22:28:12 +0100
Message-ID: <1396819692.13361.4.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-yrvV5o/NDaebD3KGvqfn"
Cc: Pavel Shilovsky <piastry@etersoft.ru>,
	Steve French <smfrench@gmail.com>,
	stable <stable@vger.kernel.org>, linux-cifs@vger.kernel.org
To: Jeff Layton <jlayton@redhat.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org


--=-yrvV5o/NDaebD3KGvqfn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Here's the backported version I've queued up for 3.2.  It's untested;
please let me know if you see any problem with it.

Ben.
---
From: Jeff Layton <jlayton@redhat.com>
Date: Fri, 14 Feb 2014 07:20:35 -0500
Subject: cifs: ensure that uncached writes handle unmapped areas correctly

commit 5d81de8e8667da7135d3a32a964087c0faf5483f upstream.

It's possible for userland to pass down an iovec via writev() that has a
bogus user pointer in it. If that happens and we're doing an uncached
write, then we can end up getting less bytes than we expect from the
call to iov_iter_copy_from_user. This is CVE-2014-0069

cifs_iovec_write isn't set up to handle that situation however. It'll
blindly keep chugging through the page array and not filling those pages
with anything useful. Worse yet, we'll later end up with a negative
number in wdata->tailsz, which will confuse the sending routines and
cause an oops at the very least.

Fix this by having the copy phase of cifs_iovec_write stop copying data
in this situation and send the last write as a short one. At the same
time, we want to avoid sending a zero-length write to the server, so
break out of the loop and set rc to -EFAULT if that happens. This also
allows us to handle the case where no address in the iovec is valid.

[Note: Marking this for stable on v3.4+ kernels, but kernels as old as
       v2.6.38 may have a similar problem and may need similar fix]

Reviewed-by: Pavel Shilovsky <piastry@etersoft.ru>
Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <smfrench@gmail.com>
[bwh: Backported to 3.2:
 - Adjust context
 - s/nr_pages/npages/
 - s/wdata->pages/pages/
 - In case of an error with no data copied, we must kunmap() page 0,
   but in neither case should we free anything else]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/cifs/file.c | 37 ++++++++++++++++++++++++++++++++++---
 1 file changed, 34 insertions(+), 3 deletions(-)

--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2107,7 +2107,7 @@ cifs_iovec_write(struct file *file, cons
 {
 	unsigned int written;
 	unsigned long num_pages, npages, i;
-	size_t copied, len, cur_len;
+	size_t bytes, copied, len, cur_len;
 	ssize_t total_written =3D 0;
 	struct kvec *to_send;
 	struct page **pages;
@@ -2165,17 +2165,44 @@ cifs_iovec_write(struct file *file, cons
 	do {
 		size_t save_len =3D cur_len;
 		for (i =3D 0; i < npages; i++) {
-			copied =3D min_t(const size_t, cur_len, PAGE_CACHE_SIZE);
+			bytes =3D min_t(const size_t, cur_len, PAGE_CACHE_SIZE);
 			copied =3D iov_iter_copy_from_user(pages[i], &it, 0,
-							 copied);
+							 bytes);
 			cur_len -=3D copied;
 			iov_iter_advance(&it, copied);
 			to_send[i+1].iov_base =3D kmap(pages[i]);
 			to_send[i+1].iov_len =3D copied;
+			/*
+			 * If we didn't copy as much as we expected, then that
+			 * may mean we trod into an unmapped area. Stop copying
+			 * at that point. On the next pass through the big
+			 * loop, we'll likely end up getting a zero-length
+			 * write and bailing out of it.
+			 */
+			if (copied < bytes)
+				break;
 		}
=20
 		cur_len =3D save_len - cur_len;
=20
+		/*
+		 * If we have no data to send, then that probably means that
+		 * the copy above failed altogether. That's most likely because
+		 * the address in the iovec was bogus. Set the rc to -EFAULT,
+		 * free anything we allocated and bail out.
+		 */
+		if (!cur_len) {
+			kunmap(pages[0]);
+			rc =3D -EFAULT;
+			break;
+		}
+
+		/*
+		 * i + 1 now represents the number of pages we actually used in
+		 * the copy phase above.
+		 */
+		npages =3D i + 1;
+
 		do {
 			if (open_file->invalidHandle) {
 				rc =3D cifs_reopen_file(open_file, false);


--=20
Ben Hutchings
I say we take off; nuke the site from orbit.  It's the only way to be sure.

--=-yrvV5o/NDaebD3KGvqfn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAU0HG7Oe/yOyVhhEJAQrKOhAArTR0KMn3R33rk5yLezFMWYGcxQR1pD7n
pWQugYa5iTOqKv8onML9TNGzop9unzjJLYcv2b9qInA6HNsMuOd43enNC940XObJ
I1xqzvtYbcH+B+RbEXbvxfaZsdk3LSzplFLZ0oh5jNX9j+e0IWZY8wpEZa0fFhVa
3GRPjhd1m+nnxPGKEDWPEQLOvJynHxhMLbsiMG0/XzHVpUT2d54haRwK49bb71N/
MujmoPA0595Efcrw2h4cMpfRgB/RI8DCefbXlQBRmAQpo5tcIxjBEF0/JcgXWnMO
BYGMN789rTp23nyqdO1kd/F/0IJYZ721kesfjj8Oy1Coy+VTH7yV26BqSvX0XkAt
K6Kk0qAt9akYrmfkb9KxJwRomdW5f/qD7bdA40JjznFJozBx7UE8IryoVWnmhpbJ
jd4o8B+jcvJY2ohdzh3QHuLhdL5f3OA40hg5zzaBMTeZDswtXJsArODqFNhECDrS
5V0G0kYxVYV4als6loM618dfA2CipjJYewpRW1oqTc5sTMQBTvR3I1yWvllMfiAt
MhivH2a+380l5u68+SoWxCMtSKOYMCUnjSdwNGKodPCd8Pc5FFrrLP85fcoFcFB0
VvDcpzIpR/q8Ekah59HIxzEENDSEwesUd1pWGouwlPsAwz1oUlYn/iCLPWsUM8e0
WmBc7qTQZdw=
=rc8H
-----END PGP SIGNATURE-----

--=-yrvV5o/NDaebD3KGvqfn--
