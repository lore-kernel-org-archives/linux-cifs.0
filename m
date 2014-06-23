From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH][CIFS] fix SMB3 mount failure due to corrupted empty paths
 when mapchars option used
Date: Sun, 22 Jun 2014 20:49:57 -0500
Message-ID: <CAH2r5mtX=ZyPm4JO7WH9uDo3nE_T4GP9h822EP8Ch=sbp2H1vA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

When we SMB3 mounted with mapchars (to allow reserved characters : \ / > < * ?
via the Unicode Windows to POSIX remap range) empty paths
(eg when we open "" to query the root of the SMB3 directory on mount) were not
null terminated so we sent garbarge as a path name on empty paths which caused
SMB2/SMB2.1/SMB3 mounts to fail when mapchars was specified.  mapchars is
particularly important since Unix Extensions for SMB3 are not supported (yet)

Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifs_unicode.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
index 0227b45..15e9505 100644
--- a/fs/cifs/cifs_unicode.c
+++ b/fs/cifs/cifs_unicode.c
@@ -290,7 +290,8 @@ int
 cifsConvertToUTF16(__le16 *target, const char *source, int srclen,
          const struct nls_table *cp, int mapChars)
 {
-    int i, j, charlen;
+    int i, charlen;
+    int j = 0;
     char src_char;
     __le16 dst_char;
     wchar_t tmp;
@@ -298,12 +299,11 @@ cifsConvertToUTF16(__le16 *target, const char
*source, int srclen,
     if (!mapChars)
         return cifs_strtoUTF16(target, source, PATH_MAX, cp);

-    for (i = 0, j = 0; i < srclen; j++) {
+    for (i = 0; i < srclen; j++) {
         src_char = source[i];
         charlen = 1;
         switch (src_char) {
         case 0:
-            put_unaligned(0, &target[j]);
             goto ctoUTF16_out;
         case ':':
             dst_char = cpu_to_le16(UNI_COLON);
@@ -350,6 +350,7 @@ cifsConvertToUTF16(__le16 *target, const char
*source, int srclen,
     }

 ctoUTF16_out:
+    put_unaligned(0, &target[j]); /* Null terminate target unicode string */
     return j;
 }


-- 
Thanks,

Steve
