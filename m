From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 1/2] cifs: Use min_t() when comparing "size_t" and "unsigned long"
Date: Sun, 13 Apr 2014 20:46:21 +0200
Message-ID: <1397414783-28098-1-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: Steve French <sfrench@samba.org>,
	linux-cifs@vger.kernel.org,
	Hugh Dickins <hughd@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>
Return-path: <owner-linux-mm@kvack.org>
Sender: owner-linux-mm@kvack.org
List-Id: linux-cifs.vger.kernel.org

On 32 bit, size_t is "unsigned int", not "unsigned long", causing the
following warning when comparing with PAGE_SIZE, which is always "unsigne=
d
long":

fs/cifs/file.c: In function =E2=80=98cifs_readdata_to_iov=E2=80=99:
fs/cifs/file.c:2757: warning: comparison of distinct pointer types lacks =
a cast

Introduced by commit 7f25bba819a38ab7310024a9350655f374707e20
("cifs_iovec_read: keep iov_iter between the calls of
cifs_readdata_to_iov()"), which changed the signedness of "remaining"
and the code from min_t() to min().

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
PAGE_SIZE should really be size_t, but that would require lots of changes
all over the place.

 fs/cifs/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 8807442c94dd..8add25538a3b 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2754,7 +2754,7 @@ cifs_readdata_to_iov(struct cifs_readdata *rdata, s=
truct iov_iter *iter)
=20
 	for (i =3D 0; i < rdata->nr_pages; i++) {
 		struct page *page =3D rdata->pages[i];
-		size_t copy =3D min(remaining, PAGE_SIZE);
+		size_t copy =3D min_t(size_t, remaining, PAGE_SIZE);
 		size_t written =3D copy_page_to_iter(page, 0, copy, iter);
 		remaining -=3D written;
 		if (written < copy && iov_iter_count(iter) > 0)
--=20
1.7.9.5

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=3Dmailto:"dont@kvack.org"> email@kvack.org </a>
