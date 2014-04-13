From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 2/2] mm: Initialize error in shmem_file_aio_read()
Date: Sun, 13 Apr 2014 20:46:22 +0200
Message-ID: <1397414783-28098-2-git-send-email-geert@linux-m68k.org>
References: <1397414783-28098-1-git-send-email-geert@linux-m68k.org>
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
In-Reply-To: <1397414783-28098-1-git-send-email-geert@linux-m68k.org>
Sender: owner-linux-mm@kvack.org
List-Id: linux-cifs.vger.kernel.org

mm/shmem.c: In function =E2=80=98shmem_file_aio_read=E2=80=99:
mm/shmem.c:1414: warning: =E2=80=98error=E2=80=99 may be used uninitializ=
ed in this function

If the loop is aborted during the first iteration by one of the two first
break statements, error will be uninitialized.

Introduced by commit 6e58e79db8a16222b31fc8da1ca2ac2dccfc4237
("introduce copy_page_to_iter, kill loop over iovec in
generic_file_aio_read()").

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
The code is too complex to see if this is an obvious false positive.

 mm/shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 8f1a95406bae..9f70e02111c6 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1411,7 +1411,7 @@ static ssize_t shmem_file_aio_read(struct kiocb *io=
cb,
 	pgoff_t index;
 	unsigned long offset;
 	enum sgp_type sgp =3D SGP_READ;
-	int error;
+	int error =3D 0;
 	ssize_t retval;
 	size_t count;
 	loff_t *ppos =3D &iocb->ki_pos;
--=20
1.7.9.5

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=3Dmailto:"dont@kvack.org"> email@kvack.org </a>
