From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH] CIFS: Rename *UCS* functions to *UTF16*
Date: Tue, 17 Jan 2012 23:31:58 +0400
Message-ID: <1326828718-15006-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

to reflect the unicode encoding used by CIFS protocol.

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/cifs_unicode.c |   41 ++++++------
 fs/cifs/cifs_unicode.h |   20 +++---
 fs/cifs/cifsencrypt.c  |   12 ++--
 fs/cifs/cifssmb.c      |  162 +++++++++++++++++++++++++-----------------------
 fs/cifs/connect.c      |    4 +-
 fs/cifs/readdir.c      |    9 ++-
 fs/cifs/sess.c         |   34 +++++-----
 fs/cifs/smbencrypt.c   |    2 +-
 8 files changed, 146 insertions(+), 138 deletions(-)

diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
index 1b2e180..fbb9da9 100644
--- a/fs/cifs/cifs_unicode.c
+++ b/fs/cifs/cifs_unicode.c
@@ -27,17 +27,17 @@
 #include "cifs_debug.h"
 
 /*
- * cifs_ucs2_bytes - how long will a string be after conversion?
- * @ucs - pointer to input string
+ * cifs_utf16_bytes - how long will a string be after conversion?
+ * @utf16 - pointer to input string
  * @maxbytes - don't go past this many bytes of input string
  * @codepage - destination codepage
  *
- * Walk a ucs2le string and return the number of bytes that the string will
+ * Walk a utf16le string and return the number of bytes that the string will
  * be after being converted to the given charset, not including any null
  * termination required. Don't walk past maxbytes in the source buffer.
  */
 int
-cifs_ucs2_bytes(const __le16 *from, int maxbytes,
+cifs_utf16_bytes(const __le16 *from, int maxbytes,
 		const struct nls_table *codepage)
 {
 	int i;
@@ -122,7 +122,7 @@ cp_convert:
 }
 
 /*
- * cifs_from_ucs2 - convert utf16le string to local charset
+ * cifs_from_utf16 - convert utf16le string to local charset
  * @to - destination buffer
  * @from - source buffer
  * @tolen - destination buffer size (in bytes)
@@ -130,7 +130,7 @@ cp_convert:
  * @codepage - codepage to which characters should be converted
  * @mapchar - should characters be remapped according to the mapchars option?
  *
- * Convert a little-endian ucs2le string (as sent by the server) to a string
+ * Convert a little-endian utf16le string (as sent by the server) to a string
  * in the provided codepage. The tolen and fromlen parameters are to ensure
  * that the code doesn't walk off of the end of the buffer (which is always
  * a danger if the alignment of the source buffer is off). The destination
@@ -139,12 +139,12 @@ cp_convert:
  * null terminator).
  *
  * Note that some windows versions actually send multiword UTF-16 characters
- * instead of straight UCS-2. The linux nls routines however aren't able to
+ * instead of straight UTF16-2. The linux nls routines however aren't able to
  * deal with those characters properly. In the event that we get some of
  * those characters, they won't be translated properly.
  */
 int
-cifs_from_ucs2(char *to, const __le16 *from, int tolen, int fromlen,
+cifs_from_utf16(char *to, const __le16 *from, int tolen, int fromlen,
 		 const struct nls_table *codepage, bool mapchar)
 {
 	int i, charlen, safelen;
@@ -190,13 +190,13 @@ cifs_from_ucs2(char *to, const __le16 *from, int tolen, int fromlen,
 }
 
 /*
- * NAME:	cifs_strtoUCS()
+ * NAME:	cifs_strtoUTF16()
  *
  * FUNCTION:	Convert character string to unicode string
  *
  */
 int
-cifs_strtoUCS(__le16 *to, const char *from, int len,
+cifs_strtoUTF16(__le16 *to, const char *from, int len,
 	      const struct nls_table *codepage)
 {
 	int charlen;
@@ -206,7 +206,7 @@ cifs_strtoUCS(__le16 *to, const char *from, int len,
 	for (i = 0; len && *from; i++, from += charlen, len -= charlen) {
 		charlen = codepage->char2uni(from, len, &wchar_to);
 		if (charlen < 1) {
-			cERROR(1, "strtoUCS: char2uni of 0x%x returned %d",
+			cERROR(1, "strtoUTF16: char2uni of 0x%x returned %d",
 				*from, charlen);
 			/* A question mark */
 			wchar_to = 0x003f;
@@ -220,7 +220,8 @@ cifs_strtoUCS(__le16 *to, const char *from, int len,
 }
 
 /*
- * cifs_strndup_from_ucs - copy a string from wire format to the local codepage
+ * cifs_strndup_from_utf16 - copy a string from wire format to the local
+ * codepage
  * @src - source string
  * @maxlen - don't walk past this many bytes in the source string
  * @is_unicode - is this a unicode string?
@@ -231,19 +232,19 @@ cifs_strtoUCS(__le16 *to, const char *from, int len,
  * error.
  */
 char *
-cifs_strndup_from_ucs(const char *src, const int maxlen, const bool is_unicode,
-	     const struct nls_table *codepage)
+cifs_strndup_from_utf16(const char *src, const int maxlen,
+			const bool is_unicode, const struct nls_table *codepage)
 {
 	int len;
 	char *dst;
 
 	if (is_unicode) {
-		len = cifs_ucs2_bytes((__le16 *) src, maxlen, codepage);
+		len = cifs_utf16_bytes((__le16 *) src, maxlen, codepage);
 		len += nls_nullsize(codepage);
 		dst = kmalloc(len, GFP_KERNEL);
 		if (!dst)
 			return NULL;
-		cifs_from_ucs2(dst, (__le16 *) src, len, maxlen, codepage,
+		cifs_from_utf16(dst, (__le16 *) src, len, maxlen, codepage,
 			       false);
 	} else {
 		len = strnlen(src, maxlen);
@@ -264,7 +265,7 @@ cifs_strndup_from_ucs(const char *src, const int maxlen, const bool is_unicode,
  * names are little endian 16 bit Unicode on the wire
  */
 int
-cifsConvertToUCS(__le16 *target, const char *source, int srclen,
+cifsConvertToUTF16(__le16 *target, const char *source, int srclen,
 		 const struct nls_table *cp, int mapChars)
 {
 	int i, j, charlen;
@@ -273,7 +274,7 @@ cifsConvertToUCS(__le16 *target, const char *source, int srclen,
 	wchar_t tmp;
 
 	if (!mapChars)
-		return cifs_strtoUCS(target, source, PATH_MAX, cp);
+		return cifs_strtoUTF16(target, source, PATH_MAX, cp);
 
 	for (i = 0, j = 0; i < srclen; j++) {
 		src_char = source[i];
@@ -281,7 +282,7 @@ cifsConvertToUCS(__le16 *target, const char *source, int srclen,
 		switch (src_char) {
 		case 0:
 			put_unaligned(0, &target[j]);
-			goto ctoUCS_out;
+			goto ctoUTF16_out;
 		case ':':
 			dst_char = cpu_to_le16(UNI_COLON);
 			break;
@@ -326,7 +327,7 @@ cifsConvertToUCS(__le16 *target, const char *source, int srclen,
 		put_unaligned(dst_char, &target[j]);
 	}
 
-ctoUCS_out:
+ctoUTF16_out:
 	return i;
 }
 
diff --git a/fs/cifs/cifs_unicode.h b/fs/cifs/cifs_unicode.h
index 6d02fd5..a513a54 100644
--- a/fs/cifs/cifs_unicode.h
+++ b/fs/cifs/cifs_unicode.h
@@ -74,16 +74,16 @@ extern const struct UniCaseRange CifsUniLowerRange[];
 #endif				/* UNIUPR_NOLOWER */
 
 #ifdef __KERNEL__
-int cifs_from_ucs2(char *to, const __le16 *from, int tolen, int fromlen,
-		   const struct nls_table *codepage, bool mapchar);
-int cifs_ucs2_bytes(const __le16 *from, int maxbytes,
-		    const struct nls_table *codepage);
-int cifs_strtoUCS(__le16 *, const char *, int, const struct nls_table *);
-char *cifs_strndup_from_ucs(const char *src, const int maxlen,
-			    const bool is_unicode,
-			    const struct nls_table *codepage);
-extern int cifsConvertToUCS(__le16 *target, const char *source, int maxlen,
-			const struct nls_table *cp, int mapChars);
+int cifs_from_utf16(char *to, const __le16 *from, int tolen, int fromlen,
+		    const struct nls_table *codepage, bool mapchar);
+int cifs_utf16_bytes(const __le16 *from, int maxbytes,
+		     const struct nls_table *codepage);
+int cifs_strtoUTF16(__le16 *, const char *, int, const struct nls_table *);
+char *cifs_strndup_from_utf16(const char *src, const int maxlen,
+			      const bool is_unicode,
+			      const struct nls_table *codepage);
+extern int cifsConvertToUTF16(__le16 *target, const char *source, int maxlen,
+			      const struct nls_table *cp, int mapChars);
 
 #endif
 
diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 5d9b9ac..f6ddd3d 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -327,7 +327,7 @@ build_avpair_blob(struct cifs_ses *ses, const struct nls_table *nls_cp)
 	attrptr->type = cpu_to_le16(NTLMSSP_AV_NB_DOMAIN_NAME);
 	attrptr->length = cpu_to_le16(2 * dlen);
 	blobptr = (unsigned char *)attrptr + sizeof(struct ntlmssp2_name);
-	cifs_strtoUCS((__le16 *)blobptr, ses->domainName, dlen, nls_cp);
+	cifs_strtoUTF16((__le16 *)blobptr, ses->domainName, dlen, nls_cp);
 
 	return 0;
 }
@@ -376,7 +376,7 @@ find_domain_name(struct cifs_ses *ses, const struct nls_table *nls_cp)
 					kmalloc(attrsize + 1, GFP_KERNEL);
 				if (!ses->domainName)
 						return -ENOMEM;
-				cifs_from_ucs2(ses->domainName,
+				cifs_from_utf16(ses->domainName,
 					(__le16 *)blobptr, attrsize, attrsize,
 					nls_cp, false);
 				break;
@@ -427,7 +427,7 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
 		rc = -ENOMEM;
 		return rc;
 	}
-	len = cifs_strtoUCS((__le16 *)user, ses->user_name, len, nls_cp);
+	len = cifs_strtoUTF16((__le16 *)user, ses->user_name, len, nls_cp);
 	UniStrupr(user);
 
 	rc = crypto_shash_update(&ses->server->secmech.sdeschmacmd5->shash,
@@ -448,8 +448,8 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
 			rc = -ENOMEM;
 			return rc;
 		}
-		len = cifs_strtoUCS((__le16 *)domain, ses->domainName, len,
-					nls_cp);
+		len = cifs_strtoUTF16((__le16 *)domain, ses->domainName, len,
+				      nls_cp);
 		rc =
 		crypto_shash_update(&ses->server->secmech.sdeschmacmd5->shash,
 					(char *)domain, 2 * len);
@@ -468,7 +468,7 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
 			rc = -ENOMEM;
 			return rc;
 		}
-		len = cifs_strtoUCS((__le16 *)server, ses->serverName, len,
+		len = cifs_strtoUTF16((__le16 *)server, ses->serverName, len,
 					nls_cp);
 		rc =
 		crypto_shash_update(&ses->server->secmech.sdeschmacmd5->shash,
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 6600aa2..8b7794c 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -821,8 +821,8 @@ PsxDelete:
 
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len =
-		    cifsConvertToUCS((__le16 *) pSMB->FileName, fileName,
-				     PATH_MAX, nls_codepage, remap);
+		    cifsConvertToUTF16((__le16 *) pSMB->FileName, fileName,
+				       PATH_MAX, nls_codepage, remap);
 		name_len++;	/* trailing null */
 		name_len *= 2;
 	} else { /* BB add path length overrun check */
@@ -893,8 +893,8 @@ DelFileRetry:
 
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len =
-		    cifsConvertToUCS((__le16 *) pSMB->fileName, fileName,
-				     PATH_MAX, nls_codepage, remap);
+		    cifsConvertToUTF16((__le16 *) pSMB->fileName, fileName,
+				       PATH_MAX, nls_codepage, remap);
 		name_len++;	/* trailing null */
 		name_len *= 2;
 	} else {		/* BB improve check for buffer overruns BB */
@@ -938,8 +938,8 @@ RmDirRetry:
 		return rc;
 
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
-		name_len = cifsConvertToUCS((__le16 *) pSMB->DirName, dirName,
-					 PATH_MAX, nls_codepage, remap);
+		name_len = cifsConvertToUTF16((__le16 *) pSMB->DirName, dirName,
+					      PATH_MAX, nls_codepage, remap);
 		name_len++;	/* trailing null */
 		name_len *= 2;
 	} else {		/* BB improve check for buffer overruns BB */
@@ -981,8 +981,8 @@ MkDirRetry:
 		return rc;
 
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
-		name_len = cifsConvertToUCS((__le16 *) pSMB->DirName, name,
-					    PATH_MAX, nls_codepage, remap);
+		name_len = cifsConvertToUTF16((__le16 *) pSMB->DirName, name,
+					      PATH_MAX, nls_codepage, remap);
 		name_len++;	/* trailing null */
 		name_len *= 2;
 	} else {		/* BB improve check for buffer overruns BB */
@@ -1030,8 +1030,8 @@ PsxCreat:
 
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len =
-		    cifsConvertToUCS((__le16 *) pSMB->FileName, name,
-				     PATH_MAX, nls_codepage, remap);
+		    cifsConvertToUTF16((__le16 *) pSMB->FileName, name,
+				       PATH_MAX, nls_codepage, remap);
 		name_len++;	/* trailing null */
 		name_len *= 2;
 	} else {	/* BB improve the check for buffer overruns BB */
@@ -1197,8 +1197,8 @@ OldOpenRetry:
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		count = 1;      /* account for one byte pad to word boundary */
 		name_len =
-		   cifsConvertToUCS((__le16 *) (pSMB->fileName + 1),
-				    fileName, PATH_MAX, nls_codepage, remap);
+		   cifsConvertToUTF16((__le16 *) (pSMB->fileName + 1),
+				      fileName, PATH_MAX, nls_codepage, remap);
 		name_len++;     /* trailing null */
 		name_len *= 2;
 	} else {                /* BB improve check for buffer overruns BB */
@@ -1304,8 +1304,8 @@ openRetry:
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		count = 1;	/* account for one byte pad to word boundary */
 		name_len =
-		    cifsConvertToUCS((__le16 *) (pSMB->fileName + 1),
-				     fileName, PATH_MAX, nls_codepage, remap);
+		    cifsConvertToUTF16((__le16 *) (pSMB->fileName + 1),
+				       fileName, PATH_MAX, nls_codepage, remap);
 		name_len++;	/* trailing null */
 		name_len *= 2;
 		pSMB->NameLength = cpu_to_le16(name_len);
@@ -2649,16 +2649,16 @@ renameRetry:
 
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len =
-		    cifsConvertToUCS((__le16 *) pSMB->OldFileName, fromName,
-				     PATH_MAX, nls_codepage, remap);
+		    cifsConvertToUTF16((__le16 *) pSMB->OldFileName, fromName,
+				       PATH_MAX, nls_codepage, remap);
 		name_len++;	/* trailing null */
 		name_len *= 2;
 		pSMB->OldFileName[name_len] = 0x04;	/* pad */
 	/* protocol requires ASCII signature byte on Unicode string */
 		pSMB->OldFileName[name_len + 1] = 0x00;
 		name_len2 =
-		    cifsConvertToUCS((__le16 *)&pSMB->OldFileName[name_len + 2],
-				     toName, PATH_MAX, nls_codepage, remap);
+		    cifsConvertToUTF16((__le16 *)&pSMB->OldFileName[name_len+2],
+				       toName, PATH_MAX, nls_codepage, remap);
 		name_len2 += 1 /* trailing null */  + 1 /* Signature word */ ;
 		name_len2 *= 2;	/* convert to bytes */
 	} else {	/* BB improve the check for buffer overruns BB */
@@ -2738,10 +2738,12 @@ int CIFSSMBRenameOpenFile(const int xid, struct cifs_tcon *pTcon,
 	/* unicode only call */
 	if (target_name == NULL) {
 		sprintf(dummy_string, "cifs%x", pSMB->hdr.Mid);
-		len_of_str = cifsConvertToUCS((__le16 *)rename_info->target_name,
+		len_of_str =
+			cifsConvertToUTF16((__le16 *)rename_info->target_name,
 					dummy_string, 24, nls_codepage, remap);
 	} else {
-		len_of_str = cifsConvertToUCS((__le16 *)rename_info->target_name,
+		len_of_str =
+			cifsConvertToUTF16((__le16 *)rename_info->target_name,
 					target_name, PATH_MAX, nls_codepage,
 					remap);
 	}
@@ -2795,17 +2797,17 @@ copyRetry:
 	pSMB->Flags = cpu_to_le16(flags & COPY_TREE);
 
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
-		name_len = cifsConvertToUCS((__le16 *) pSMB->OldFileName,
-					    fromName, PATH_MAX, nls_codepage,
-					    remap);
+		name_len = cifsConvertToUTF16((__le16 *) pSMB->OldFileName,
+					      fromName, PATH_MAX, nls_codepage,
+					      remap);
 		name_len++;     /* trailing null */
 		name_len *= 2;
 		pSMB->OldFileName[name_len] = 0x04;     /* pad */
 		/* protocol requires ASCII signature byte on Unicode string */
 		pSMB->OldFileName[name_len + 1] = 0x00;
 		name_len2 =
-		    cifsConvertToUCS((__le16 *)&pSMB->OldFileName[name_len + 2],
-				toName, PATH_MAX, nls_codepage, remap);
+		    cifsConvertToUTF16((__le16 *)&pSMB->OldFileName[name_len+2],
+				       toName, PATH_MAX, nls_codepage, remap);
 		name_len2 += 1 /* trailing null */  + 1 /* Signature word */ ;
 		name_len2 *= 2; /* convert to bytes */
 	} else { 	/* BB improve the check for buffer overruns BB */
@@ -2861,9 +2863,9 @@ createSymLinkRetry:
 
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len =
-		    cifs_strtoUCS((__le16 *) pSMB->FileName, fromName, PATH_MAX
-				  /* find define for this maxpathcomponent */
-				  , nls_codepage);
+		    cifs_strtoUTF16((__le16 *) pSMB->FileName, fromName,
+				    /* find define for this maxpathcomponent */
+				    PATH_MAX, nls_codepage);
 		name_len++;	/* trailing null */
 		name_len *= 2;
 
@@ -2885,9 +2887,9 @@ createSymLinkRetry:
 	data_offset = (char *) (&pSMB->hdr.Protocol) + offset;
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len_target =
-		    cifs_strtoUCS((__le16 *) data_offset, toName, PATH_MAX
-				  /* find define for this maxpathcomponent */
-				  , nls_codepage);
+		    cifs_strtoUTF16((__le16 *) data_offset, toName, PATH_MAX
+				    /* find define for this maxpathcomponent */
+				    , nls_codepage);
 		name_len_target++;	/* trailing null */
 		name_len_target *= 2;
 	} else {	/* BB improve the check for buffer overruns BB */
@@ -2949,8 +2951,8 @@ createHardLinkRetry:
 		return rc;
 
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
-		name_len = cifsConvertToUCS((__le16 *) pSMB->FileName, toName,
-					    PATH_MAX, nls_codepage, remap);
+		name_len = cifsConvertToUTF16((__le16 *) pSMB->FileName, toName,
+					      PATH_MAX, nls_codepage, remap);
 		name_len++;	/* trailing null */
 		name_len *= 2;
 
@@ -2972,8 +2974,8 @@ createHardLinkRetry:
 	data_offset = (char *) (&pSMB->hdr.Protocol) + offset;
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len_target =
-		    cifsConvertToUCS((__le16 *) data_offset, fromName, PATH_MAX,
-				     nls_codepage, remap);
+		    cifsConvertToUTF16((__le16 *) data_offset, fromName,
+				       PATH_MAX, nls_codepage, remap);
 		name_len_target++;	/* trailing null */
 		name_len_target *= 2;
 	} else {	/* BB improve the check for buffer overruns BB */
@@ -3042,8 +3044,8 @@ winCreateHardLinkRetry:
 
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len =
-		    cifsConvertToUCS((__le16 *) pSMB->OldFileName, fromName,
-				     PATH_MAX, nls_codepage, remap);
+		    cifsConvertToUTF16((__le16 *) pSMB->OldFileName, fromName,
+				       PATH_MAX, nls_codepage, remap);
 		name_len++;	/* trailing null */
 		name_len *= 2;
 
@@ -3051,8 +3053,8 @@ winCreateHardLinkRetry:
 		pSMB->OldFileName[name_len] = 0x04;
 		pSMB->OldFileName[name_len + 1] = 0x00; /* pad */
 		name_len2 =
-		    cifsConvertToUCS((__le16 *)&pSMB->OldFileName[name_len + 2],
-				     toName, PATH_MAX, nls_codepage, remap);
+		    cifsConvertToUTF16((__le16 *)&pSMB->OldFileName[name_len+2],
+				       toName, PATH_MAX, nls_codepage, remap);
 		name_len2 += 1 /* trailing null */  + 1 /* Signature word */ ;
 		name_len2 *= 2;	/* convert to bytes */
 	} else {	/* BB improve the check for buffer overruns BB */
@@ -3108,8 +3110,8 @@ querySymLinkRetry:
 
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len =
-		    cifs_strtoUCS((__le16 *) pSMB->FileName, searchName,
-				  PATH_MAX, nls_codepage);
+			cifs_strtoUTF16((__le16 *) pSMB->FileName, searchName,
+					PATH_MAX, nls_codepage);
 		name_len++;	/* trailing null */
 		name_len *= 2;
 	} else {	/* BB improve the check for buffer overruns BB */
@@ -3166,8 +3168,8 @@ querySymLinkRetry:
 				is_unicode = false;
 
 			/* BB FIXME investigate remapping reserved chars here */
-			*symlinkinfo = cifs_strndup_from_ucs(data_start, count,
-						    is_unicode, nls_codepage);
+			*symlinkinfo = cifs_strndup_from_utf16(data_start,
+					count, is_unicode, nls_codepage);
 			if (!*symlinkinfo)
 				rc = -ENOMEM;
 		}
@@ -3450,8 +3452,9 @@ queryAclRetry:
 
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len =
-			cifsConvertToUCS((__le16 *) pSMB->FileName, searchName,
-					 PATH_MAX, nls_codepage, remap);
+			cifsConvertToUTF16((__le16 *) pSMB->FileName,
+					   searchName, PATH_MAX, nls_codepage,
+					   remap);
 		name_len++;     /* trailing null */
 		name_len *= 2;
 		pSMB->FileName[name_len] = 0;
@@ -3537,8 +3540,8 @@ setAclRetry:
 		return rc;
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len =
-			cifsConvertToUCS((__le16 *) pSMB->FileName, fileName,
-				      PATH_MAX, nls_codepage, remap);
+			cifsConvertToUTF16((__le16 *) pSMB->FileName, fileName,
+					   PATH_MAX, nls_codepage, remap);
 		name_len++;     /* trailing null */
 		name_len *= 2;
 	} else {	/* BB improve the check for buffer overruns BB */
@@ -3948,8 +3951,9 @@ QInfRetry:
 
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len =
-			cifsConvertToUCS((__le16 *) pSMB->FileName, searchName,
-					PATH_MAX, nls_codepage, remap);
+			cifsConvertToUTF16((__le16 *) pSMB->FileName,
+					   searchName, PATH_MAX, nls_codepage,
+					   remap);
 		name_len++;     /* trailing null */
 		name_len *= 2;
 	} else {
@@ -4086,8 +4090,8 @@ QPathInfoRetry:
 
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len =
-		    cifsConvertToUCS((__le16 *) pSMB->FileName, searchName,
-				     PATH_MAX, nls_codepage, remap);
+		    cifsConvertToUTF16((__le16 *) pSMB->FileName, searchName,
+				       PATH_MAX, nls_codepage, remap);
 		name_len++;	/* trailing null */
 		name_len *= 2;
 	} else {	/* BB improve the check for buffer overruns BB */
@@ -4255,8 +4259,8 @@ UnixQPathInfoRetry:
 
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len =
-		    cifsConvertToUCS((__le16 *) pSMB->FileName, searchName,
-				  PATH_MAX, nls_codepage, remap);
+		    cifsConvertToUTF16((__le16 *) pSMB->FileName, searchName,
+				       PATH_MAX, nls_codepage, remap);
 		name_len++;	/* trailing null */
 		name_len *= 2;
 	} else {	/* BB improve the check for buffer overruns BB */
@@ -4344,8 +4348,8 @@ findFirstRetry:
 
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len =
-		    cifsConvertToUCS((__le16 *) pSMB->FileName, searchName,
-				 PATH_MAX, nls_codepage, remap);
+		    cifsConvertToUTF16((__le16 *) pSMB->FileName, searchName,
+				       PATH_MAX, nls_codepage, remap);
 		/* We can not add the asterik earlier in case
 		it got remapped to 0xF03A as if it were part of the
 		directory name instead of a wildcard */
@@ -4656,8 +4660,9 @@ GetInodeNumberRetry:
 
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len =
-			cifsConvertToUCS((__le16 *) pSMB->FileName, searchName,
-					 PATH_MAX, nls_codepage, remap);
+			cifsConvertToUTF16((__le16 *) pSMB->FileName,
+					   searchName, PATH_MAX, nls_codepage,
+					   remap);
 		name_len++;     /* trailing null */
 		name_len *= 2;
 	} else {	/* BB improve the check for buffer overruns BB */
@@ -4794,9 +4799,9 @@ parse_DFS_referrals(TRANSACTION2_GET_DFS_REFER_RSP *pSMBr,
 				rc = -ENOMEM;
 				goto parse_DFS_referrals_exit;
 			}
-			cifsConvertToUCS((__le16 *) tmp, searchName,
-					PATH_MAX, nls_codepage, remap);
-			node->path_consumed = cifs_ucs2_bytes(tmp,
+			cifsConvertToUTF16((__le16 *) tmp, searchName,
+					   PATH_MAX, nls_codepage, remap);
+			node->path_consumed = cifs_utf16_bytes(tmp,
 					le16_to_cpu(pSMBr->PathConsumed),
 					nls_codepage);
 			kfree(tmp);
@@ -4809,8 +4814,8 @@ parse_DFS_referrals(TRANSACTION2_GET_DFS_REFER_RSP *pSMBr,
 		/* copy DfsPath */
 		temp = (char *)ref + le16_to_cpu(ref->DfsPathOffset);
 		max_len = data_end - temp;
-		node->path_name = cifs_strndup_from_ucs(temp, max_len,
-						      is_unicode, nls_codepage);
+		node->path_name = cifs_strndup_from_utf16(temp, max_len,
+						is_unicode, nls_codepage);
 		if (!node->path_name) {
 			rc = -ENOMEM;
 			goto parse_DFS_referrals_exit;
@@ -4819,8 +4824,8 @@ parse_DFS_referrals(TRANSACTION2_GET_DFS_REFER_RSP *pSMBr,
 		/* copy link target UNC */
 		temp = (char *)ref + le16_to_cpu(ref->NetworkAddressOffset);
 		max_len = data_end - temp;
-		node->node_name = cifs_strndup_from_ucs(temp, max_len,
-						      is_unicode, nls_codepage);
+		node->node_name = cifs_strndup_from_utf16(temp, max_len,
+						is_unicode, nls_codepage);
 		if (!node->node_name)
 			rc = -ENOMEM;
 	}
@@ -4873,8 +4878,9 @@ getDFSRetry:
 	if (ses->capabilities & CAP_UNICODE) {
 		pSMB->hdr.Flags2 |= SMBFLG2_UNICODE;
 		name_len =
-		    cifsConvertToUCS((__le16 *) pSMB->RequestFileName,
-				     searchName, PATH_MAX, nls_codepage, remap);
+		    cifsConvertToUTF16((__le16 *) pSMB->RequestFileName,
+				       searchName, PATH_MAX, nls_codepage,
+				       remap);
 		name_len++;	/* trailing null */
 		name_len *= 2;
 	} else {	/* BB improve the check for buffer overruns BB */
@@ -5506,8 +5512,8 @@ SetEOFRetry:
 
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len =
-		    cifsConvertToUCS((__le16 *) pSMB->FileName, fileName,
-				     PATH_MAX, nls_codepage, remap);
+		    cifsConvertToUTF16((__le16 *) pSMB->FileName, fileName,
+				       PATH_MAX, nls_codepage, remap);
 		name_len++;	/* trailing null */
 		name_len *= 2;
 	} else {	/* BB improve the check for buffer overruns BB */
@@ -5796,8 +5802,8 @@ SetTimesRetry:
 
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len =
-		    cifsConvertToUCS((__le16 *) pSMB->FileName, fileName,
-				     PATH_MAX, nls_codepage, remap);
+		    cifsConvertToUTF16((__le16 *) pSMB->FileName, fileName,
+				       PATH_MAX, nls_codepage, remap);
 		name_len++;	/* trailing null */
 		name_len *= 2;
 	} else {	/* BB improve the check for buffer overruns BB */
@@ -5877,8 +5883,8 @@ SetAttrLgcyRetry:
 
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len =
-			ConvertToUCS((__le16 *) pSMB->fileName, fileName,
-				PATH_MAX, nls_codepage);
+			ConvertToUTF16((__le16 *) pSMB->fileName, fileName,
+				       PATH_MAX, nls_codepage);
 		name_len++;     /* trailing null */
 		name_len *= 2;
 	} else {	/* BB improve the check for buffer overruns BB */
@@ -6030,8 +6036,8 @@ setPermsRetry:
 
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len =
-		    cifsConvertToUCS((__le16 *) pSMB->FileName, fileName,
-				     PATH_MAX, nls_codepage, remap);
+		    cifsConvertToUTF16((__le16 *) pSMB->FileName, fileName,
+				       PATH_MAX, nls_codepage, remap);
 		name_len++;	/* trailing null */
 		name_len *= 2;
 	} else {	/* BB improve the check for buffer overruns BB */
@@ -6123,8 +6129,8 @@ QAllEAsRetry:
 
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		list_len =
-		    cifsConvertToUCS((__le16 *) pSMB->FileName, searchName,
-				     PATH_MAX, nls_codepage, remap);
+		    cifsConvertToUTF16((__le16 *) pSMB->FileName, searchName,
+				       PATH_MAX, nls_codepage, remap);
 		list_len++;	/* trailing null */
 		list_len *= 2;
 	} else {	/* BB improve the check for buffer overruns BB */
@@ -6301,8 +6307,8 @@ SetEARetry:
 
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len =
-		    cifsConvertToUCS((__le16 *) pSMB->FileName, fileName,
-				     PATH_MAX, nls_codepage, remap);
+		    cifsConvertToUTF16((__le16 *) pSMB->FileName, fileName,
+				       PATH_MAX, nls_codepage, remap);
 		name_len++;	/* trailing null */
 		name_len *= 2;
 	} else {	/* BB improve the check for buffer overruns BB */
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index f3670cf..2838195 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3478,7 +3478,7 @@ CIFSTCon(unsigned int xid, struct cifs_ses *ses,
 	if (ses->capabilities & CAP_UNICODE) {
 		smb_buffer->Flags2 |= SMBFLG2_UNICODE;
 		length =
-		    cifs_strtoUCS((__le16 *) bcc_ptr, tree,
+		    cifs_strtoUTF16((__le16 *) bcc_ptr, tree,
 			6 /* max utf8 char length in bytes */ *
 			(/* server len*/ + 256 /* share len */), nls_codepage);
 		bcc_ptr += 2 * length;	/* convert num 16 bit words to bytes */
@@ -3533,7 +3533,7 @@ CIFSTCon(unsigned int xid, struct cifs_ses *ses,
 
 		/* mostly informational -- no need to fail on error here */
 		kfree(tcon->nativeFileSystem);
-		tcon->nativeFileSystem = cifs_strndup_from_ucs(bcc_ptr,
+		tcon->nativeFileSystem = cifs_strndup_from_utf16(bcc_ptr,
 						      bytes_left, is_unicode,
 						      nls_codepage);
 
diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index a090bbe..e2bbc68 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -647,10 +647,11 @@ static int cifs_filldir(char *find_entry, struct file *file, filldir_t filldir,
 
 		name.name = scratch_buf;
 		name.len =
-			cifs_from_ucs2((char *)name.name, (__le16 *)de.name,
-				       UNICODE_NAME_MAX,
-				       min(de.namelen, (size_t)max_len), nlt,
-				       cifs_sb->mnt_cifs_flags &
+			cifs_from_utf16((char *)name.name, (__le16 *)de.name,
+					UNICODE_NAME_MAX,
+					min_t(size_t, de.namelen,
+					      (size_t)max_len), nlt,
+					cifs_sb->mnt_cifs_flags &
 						CIFS_MOUNT_MAP_SPECIAL_CHR);
 		name.len -= nls_nullsize(nlt);
 	} else {
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 4ec3ee9..d85efad 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -167,16 +167,16 @@ unicode_oslm_strings(char **pbcc_area, const struct nls_table *nls_cp)
 	int bytes_ret = 0;
 
 	/* Copy OS version */
-	bytes_ret = cifs_strtoUCS((__le16 *)bcc_ptr, "Linux version ", 32,
-				  nls_cp);
+	bytes_ret = cifs_strtoUTF16((__le16 *)bcc_ptr, "Linux version ", 32,
+				    nls_cp);
 	bcc_ptr += 2 * bytes_ret;
-	bytes_ret = cifs_strtoUCS((__le16 *) bcc_ptr, init_utsname()->release,
-				  32, nls_cp);
+	bytes_ret = cifs_strtoUTF16((__le16 *) bcc_ptr, init_utsname()->release,
+				    32, nls_cp);
 	bcc_ptr += 2 * bytes_ret;
 	bcc_ptr += 2; /* trailing null */
 
-	bytes_ret = cifs_strtoUCS((__le16 *) bcc_ptr, CIFS_NETWORK_OPSYS,
-				  32, nls_cp);
+	bytes_ret = cifs_strtoUTF16((__le16 *) bcc_ptr, CIFS_NETWORK_OPSYS,
+				    32, nls_cp);
 	bcc_ptr += 2 * bytes_ret;
 	bcc_ptr += 2; /* trailing null */
 
@@ -197,8 +197,8 @@ static void unicode_domain_string(char **pbcc_area, struct cifs_ses *ses,
 		*(bcc_ptr+1) = 0;
 		bytes_ret = 0;
 	} else
-		bytes_ret = cifs_strtoUCS((__le16 *) bcc_ptr, ses->domainName,
-					  256, nls_cp);
+		bytes_ret = cifs_strtoUTF16((__le16 *) bcc_ptr, ses->domainName,
+					    256, nls_cp);
 	bcc_ptr += 2 * bytes_ret;
 	bcc_ptr += 2;  /* account for null terminator */
 
@@ -226,8 +226,8 @@ static void unicode_ssetup_strings(char **pbcc_area, struct cifs_ses *ses,
 		*bcc_ptr = 0;
 		*(bcc_ptr+1) = 0;
 	} else {
-		bytes_ret = cifs_strtoUCS((__le16 *) bcc_ptr, ses->user_name,
-					  MAX_USERNAME_SIZE, nls_cp);
+		bytes_ret = cifs_strtoUTF16((__le16 *) bcc_ptr, ses->user_name,
+					    MAX_USERNAME_SIZE, nls_cp);
 	}
 	bcc_ptr += 2 * bytes_ret;
 	bcc_ptr += 2; /* account for null termination */
@@ -287,7 +287,7 @@ decode_unicode_ssetup(char **pbcc_area, int bleft, struct cifs_ses *ses,
 	cFYI(1, "bleft %d", bleft);
 
 	kfree(ses->serverOS);
-	ses->serverOS = cifs_strndup_from_ucs(data, bleft, true, nls_cp);
+	ses->serverOS = cifs_strndup_from_utf16(data, bleft, true, nls_cp);
 	cFYI(1, "serverOS=%s", ses->serverOS);
 	len = (UniStrnlen((wchar_t *) data, bleft / 2) * 2) + 2;
 	data += len;
@@ -296,7 +296,7 @@ decode_unicode_ssetup(char **pbcc_area, int bleft, struct cifs_ses *ses,
 		return;
 
 	kfree(ses->serverNOS);
-	ses->serverNOS = cifs_strndup_from_ucs(data, bleft, true, nls_cp);
+	ses->serverNOS = cifs_strndup_from_utf16(data, bleft, true, nls_cp);
 	cFYI(1, "serverNOS=%s", ses->serverNOS);
 	len = (UniStrnlen((wchar_t *) data, bleft / 2) * 2) + 2;
 	data += len;
@@ -305,7 +305,7 @@ decode_unicode_ssetup(char **pbcc_area, int bleft, struct cifs_ses *ses,
 		return;
 
 	kfree(ses->serverDomain);
-	ses->serverDomain = cifs_strndup_from_ucs(data, bleft, true, nls_cp);
+	ses->serverDomain = cifs_strndup_from_utf16(data, bleft, true, nls_cp);
 	cFYI(1, "serverDomain=%s", ses->serverDomain);
 
 	return;
@@ -502,8 +502,8 @@ static int build_ntlmssp_auth_blob(unsigned char *pbuffer,
 		tmp += 2;
 	} else {
 		int len;
-		len = cifs_strtoUCS((__le16 *)tmp, ses->domainName,
-				    MAX_USERNAME_SIZE, nls_cp);
+		len = cifs_strtoUTF16((__le16 *)tmp, ses->domainName,
+				      MAX_USERNAME_SIZE, nls_cp);
 		len *= 2; /* unicode is 2 bytes each */
 		sec_blob->DomainName.BufferOffset = cpu_to_le32(tmp - pbuffer);
 		sec_blob->DomainName.Length = cpu_to_le16(len);
@@ -518,8 +518,8 @@ static int build_ntlmssp_auth_blob(unsigned char *pbuffer,
 		tmp += 2;
 	} else {
 		int len;
-		len = cifs_strtoUCS((__le16 *)tmp, ses->user_name,
-				    MAX_USERNAME_SIZE, nls_cp);
+		len = cifs_strtoUTF16((__le16 *)tmp, ses->user_name,
+				      MAX_USERNAME_SIZE, nls_cp);
 		len *= 2; /* unicode is 2 bytes each */
 		sec_blob->UserName.BufferOffset = cpu_to_le32(tmp - pbuffer);
 		sec_blob->UserName.Length = cpu_to_le16(len);
diff --git a/fs/cifs/smbencrypt.c b/fs/cifs/smbencrypt.c
index 80d8508..d5cd9aa 100644
--- a/fs/cifs/smbencrypt.c
+++ b/fs/cifs/smbencrypt.c
@@ -213,7 +213,7 @@ E_md4hash(const unsigned char *passwd, unsigned char *p16,
 
 	/* Password cannot be longer than 128 characters */
 	if (passwd) /* Password must be converted to NT unicode */
-		len = cifs_strtoUCS(wpwd, passwd, 128, codepage);
+		len = cifs_strtoUTF16(wpwd, passwd, 128, codepage);
 	else {
 		len = 0;
 		*wpwd = 0; /* Ensure string is null terminated */
-- 
1.7.1
