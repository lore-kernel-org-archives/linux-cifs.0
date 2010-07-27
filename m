From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 4/4] data_blob: change for loop indices to a unsigned int
Date: Tue, 27 Jul 2010 15:37:07 -0400
Message-ID: <1280259427-14617-5-git-send-email-jlayton@samba.org>
References: <1280259427-14617-1-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1280259427-14617-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

To silence these warnings:

data_blob.c: In function =E2=80=98data_blob_hex_string_lower=E2=80=99:
data_blob.c:155:16: warning: comparison between signed and unsigned int=
eger
expressions
data_blob.c: In function =E2=80=98data_blob_hex_string_upper=E2=80=99:
data_blob.c:172:16: warning: comparison between signed and unsigned int=
eger
expressions

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 data_blob.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/data_blob.c b/data_blob.c
index 2384661..16c78ce 100644
--- a/data_blob.c
+++ b/data_blob.c
@@ -141,7 +141,7 @@ print the data_blob as hex string
 **/
 _PUBLIC_ char *data_blob_hex_string_lower(TALLOC_CTX *mem_ctx, const D=
ATA_BLOB *blob)
 {
-	int i;
+	unsigned int i;
 	char *hex_string;
=20
 	hex_string =3D talloc_array(mem_ctx, char, (blob->length*2)+1);
@@ -161,7 +161,7 @@ _PUBLIC_ char *data_blob_hex_string_lower(TALLOC_CT=
X *mem_ctx, const DATA_BLOB *
=20
 _PUBLIC_ char *data_blob_hex_string_upper(TALLOC_CTX *mem_ctx, const D=
ATA_BLOB *blob)
 {
-	int i;
+	unsigned int i;
 	char *hex_string;
=20
 	hex_string =3D talloc_array(mem_ctx, char, (blob->length*2)+1);
--=20
1.7.1.1
