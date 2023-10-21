Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07B2DC0032E
	for <linux-cifs@archiver.kernel.org>; Sat, 21 Oct 2023 12:06:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231126AbjJUMGD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 21 Oct 2023 08:06:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbjJUMGC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 21 Oct 2023 08:06:02 -0400
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E3AED52
        for <linux-cifs@vger.kernel.org>; Sat, 21 Oct 2023 05:05:59 -0700 (PDT)
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-27d4b280e4eso1284963a91.1
        for <linux-cifs@vger.kernel.org>; Sat, 21 Oct 2023 05:05:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697889958; x=1698494758;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Z5EKBum0m1Xkp1SaaldCAyddAdQGBIzkCR+aLYZ6CLE=;
        b=GbHuTQYAsYg28EXtNSQaBI+6TQYNX7g3+SroGPOy5aRvthZ6ewHs2vqmGdxU0Fu3/z
         3tSYfdLSYrSftJSJQ9xkBGjyFFOxBL4QKD6PBdz9acU4oE6ES99ySNk/V2dy3LnxkOHm
         RZ2FhofsbK4XCohdWZgleI/hEelRkSGBrHTU8dg7O9n317CqUS5fmor8IWNG3At5mWMn
         B/i3sCT72sTtpDdoUALGmxS9aS0R9oa8Em8MdW1wafcHQS7lBYyD/q4k/WjDLrAo1mdu
         u3sBbIjn02hQnzpl4kCCBr74WlC3vc2ozKzzzUGzJf/Fu2DJvmh9J9B6GI0cVBzSXyTx
         8PQg==
X-Gm-Message-State: AOJu0Yw6SRAQVRIo1BQWPuouXgbIlmEjK1K3VmA9R6KTXMfFQn/8ds0v
        BkWtDMRVaPgyBzAjIoDDo23FhQrrmr0=
X-Google-Smtp-Source: AGHT+IEZsqdTdkcVt7vaYMLkz22HAIBQkkRQEeMd8wUV7eDVC813CpYs6dAaVm5t137C2ZCBmAox5g==
X-Received: by 2002:a17:90a:e409:b0:27d:1126:1ff6 with SMTP id hv9-20020a17090ae40900b0027d11261ff6mr11097273pjb.8.1697889958313;
        Sat, 21 Oct 2023 05:05:58 -0700 (PDT)
Received: from localhost.localdomain ([110.14.71.32])
        by smtp.gmail.com with ESMTPSA id nk5-20020a17090b194500b00268b439a0cbsm2994763pjb.23.2023.10.21.05.05.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Oct 2023 05:05:57 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        atteh.mailbox@gmail.com, Namjae Jeon <linkinjeon@kernel.org>,
        Marios Makassikis <mmakassikis@freebox.fr>
Subject: [PATCH] ksmbd: add support for surrogate pair conversion
Date:   Sat, 21 Oct 2023 21:05:40 +0900
Message-Id: <20231021120540.28732-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

ksmbd is missing supporting to convert filename included surrogate pair
characters. It triggers a "file or folder does not exist" error in
Windows client.

[Steps to Reproduce for bug]
1. Create surrogate pair file
 touch $(echo -e '\xf0\x9d\x9f\xa3')
 touch $(echo -e '\xf0\x9d\x9f\xa4')

2. Try to open these files in ksmbd share through Windows client.

This patch update unicode functions not to consider about surrogate pair
(and IVS).

Reviewed-by: Marios Makassikis <mmakassikis@freebox.fr>
Tested-by: Marios Makassikis <mmakassikis@freebox.fr>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/unicode.c | 187 +++++++++++++++++++++++++++++-----------
 1 file changed, 138 insertions(+), 49 deletions(-)

diff --git a/fs/smb/server/unicode.c b/fs/smb/server/unicode.c
index 393dd4a7432b..43ed29ee44ea 100644
--- a/fs/smb/server/unicode.c
+++ b/fs/smb/server/unicode.c
@@ -13,46 +13,10 @@
 #include "unicode.h"
 #include "smb_common.h"
 
-/*
- * smb_utf16_bytes() - how long will a string be after conversion?
- * @from:	pointer to input string
- * @maxbytes:	don't go past this many bytes of input string
- * @codepage:	destination codepage
- *
- * Walk a utf16le string and return the number of bytes that the string will
- * be after being converted to the given charset, not including any null
- * termination required. Don't walk past maxbytes in the source buffer.
- *
- * Return:	string length after conversion
- */
-static int smb_utf16_bytes(const __le16 *from, int maxbytes,
-			   const struct nls_table *codepage)
-{
-	int i;
-	int charlen, outlen = 0;
-	int maxwords = maxbytes / 2;
-	char tmp[NLS_MAX_CHARSET_SIZE];
-	__u16 ftmp;
-
-	for (i = 0; i < maxwords; i++) {
-		ftmp = get_unaligned_le16(&from[i]);
-		if (ftmp == 0)
-			break;
-
-		charlen = codepage->uni2char(ftmp, tmp, NLS_MAX_CHARSET_SIZE);
-		if (charlen > 0)
-			outlen += charlen;
-		else
-			outlen++;
-	}
-
-	return outlen;
-}
-
 /*
  * cifs_mapchar() - convert a host-endian char to proper char in codepage
  * @target:	where converted character should be copied
- * @src_char:	2 byte host-endian source character
+ * @from:	host-endian source string
  * @cp:		codepage to which character should be converted
  * @mapchar:	should character be mapped according to mapchars mount option?
  *
@@ -63,10 +27,13 @@ static int smb_utf16_bytes(const __le16 *from, int maxbytes,
  * Return:	string length after conversion
  */
 static int
-cifs_mapchar(char *target, const __u16 src_char, const struct nls_table *cp,
+cifs_mapchar(char *target, const __u16 *from, const struct nls_table *cp,
 	     bool mapchar)
 {
 	int len = 1;
+	__u16 src_char;
+
+	src_char = *from;
 
 	if (!mapchar)
 		goto cp_convert;
@@ -104,12 +71,66 @@ cifs_mapchar(char *target, const __u16 src_char, const struct nls_table *cp,
 
 cp_convert:
 	len = cp->uni2char(src_char, target, NLS_MAX_CHARSET_SIZE);
-	if (len <= 0) {
-		*target = '?';
-		len = 1;
-	}
+	if (len <= 0)
+		goto surrogate_pair;
 
 	goto out;
+
+surrogate_pair:
+	/* convert SURROGATE_PAIR and IVS */
+	if (strcmp(cp->charset, "utf8"))
+		goto unknown;
+	len = utf16s_to_utf8s(from, 3, UTF16_LITTLE_ENDIAN, target, 6);
+	if (len <= 0)
+		goto unknown;
+	return len;
+
+unknown:
+	*target = '?';
+	len = 1;
+	goto out;
+}
+
+/*
+ * smb_utf16_bytes() - compute converted string length
+ * @from:	pointer to input string
+ * @maxbytes:	input string length
+ * @codepage:	destination codepage
+ *
+ * Walk a utf16le string and return the number of bytes that the string will
+ * be after being converted to the given charset, not including any null
+ * termination required. Don't walk past maxbytes in the source buffer.
+ *
+ * Return:	string length after conversion
+ */
+static int smb_utf16_bytes(const __le16 *from, int maxbytes,
+			   const struct nls_table *codepage)
+{
+	int i, j;
+	int charlen, outlen = 0;
+	int maxwords = maxbytes / 2;
+	char tmp[NLS_MAX_CHARSET_SIZE];
+	__u16 ftmp[3];
+
+	for (i = 0; i < maxwords; i++) {
+		ftmp[0] = get_unaligned_le16(&from[i]);
+		if (ftmp[0] == 0)
+			break;
+		for (j = 1; j <= 2; j++) {
+			if (i + j < maxwords)
+				ftmp[j] = get_unaligned_le16(&from[i + j]);
+			else
+				ftmp[j] = 0;
+		}
+
+		charlen = cifs_mapchar(tmp, ftmp, codepage, 0);
+		if (charlen > 0)
+			outlen += charlen;
+		else
+			outlen++;
+	}
+
+	return outlen;
 }
 
 /*
@@ -139,12 +160,12 @@ cifs_mapchar(char *target, const __u16 src_char, const struct nls_table *cp,
 static int smb_from_utf16(char *to, const __le16 *from, int tolen, int fromlen,
 			  const struct nls_table *codepage, bool mapchar)
 {
-	int i, charlen, safelen;
+	int i, j, charlen, safelen;
 	int outlen = 0;
 	int nullsize = nls_nullsize(codepage);
 	int fromwords = fromlen / 2;
 	char tmp[NLS_MAX_CHARSET_SIZE];
-	__u16 ftmp;
+	__u16 ftmp[3];	/* ftmp[3] = 3array x 2bytes = 6bytes UTF-16 */
 
 	/*
 	 * because the chars can be of varying widths, we need to take care
@@ -155,9 +176,15 @@ static int smb_from_utf16(char *to, const __le16 *from, int tolen, int fromlen,
 	safelen = tolen - (NLS_MAX_CHARSET_SIZE + nullsize);
 
 	for (i = 0; i < fromwords; i++) {
-		ftmp = get_unaligned_le16(&from[i]);
-		if (ftmp == 0)
+		ftmp[0] = get_unaligned_le16(&from[i]);
+		if (ftmp[0] == 0)
 			break;
+		for (j = 1; j <= 2; j++) {
+			if (i + j < fromwords)
+				ftmp[j] = get_unaligned_le16(&from[i + j]);
+			else
+				ftmp[j] = 0;
+		}
 
 		/*
 		 * check to see if converting this character might make the
@@ -172,6 +199,19 @@ static int smb_from_utf16(char *to, const __le16 *from, int tolen, int fromlen,
 		/* put converted char into 'to' buffer */
 		charlen = cifs_mapchar(&to[outlen], ftmp, codepage, mapchar);
 		outlen += charlen;
+
+		/*
+		 * charlen (=bytes of UTF-8 for 1 character)
+		 * 4bytes UTF-8(surrogate pair) is charlen=4
+		 * (4bytes UTF-16 code)
+		 * 7-8bytes UTF-8(IVS) is charlen=3+4 or 4+4
+		 * (2 UTF-8 pairs divided to 2 UTF-16 pairs)
+		 */
+		if (charlen == 4)
+			i++;
+		else if (charlen >= 5)
+			/* 5-6bytes UTF-8 */
+			i += 2;
 	}
 
 	/* properly null-terminate string */
@@ -306,6 +346,9 @@ int smbConvertToUTF16(__le16 *target, const char *source, int srclen,
 	char src_char;
 	__le16 dst_char;
 	wchar_t tmp;
+	wchar_t wchar_to[6];	/* UTF-16 */
+	int ret;
+	unicode_t u;
 
 	if (!mapchars)
 		return smb_strtoUTF16(target, source, srclen, cp);
@@ -348,11 +391,57 @@ int smbConvertToUTF16(__le16 *target, const char *source, int srclen,
 			 * if no match, use question mark, which at least in
 			 * some cases serves as wild card
 			 */
-			if (charlen < 1) {
-				dst_char = cpu_to_le16(0x003f);
-				charlen = 1;
+			if (charlen > 0)
+				goto ctoUTF16;
+
+			/* convert SURROGATE_PAIR */
+			if (strcmp(cp->charset, "utf8"))
+				goto unknown;
+			if (*(source + i) & 0x80) {
+				charlen = utf8_to_utf32(source + i, 6, &u);
+				if (charlen < 0)
+					goto unknown;
+			} else
+				goto unknown;
+			ret  = utf8s_to_utf16s(source + i, charlen,
+					UTF16_LITTLE_ENDIAN,
+					wchar_to, 6);
+			if (ret < 0)
+				goto unknown;
+
+			i += charlen;
+			dst_char = cpu_to_le16(*wchar_to);
+			if (charlen <= 3)
+				/* 1-3bytes UTF-8 to 2bytes UTF-16 */
+				put_unaligned(dst_char, &target[j]);
+			else if (charlen == 4) {
+				/*
+				 * 4bytes UTF-8(surrogate pair) to 4bytes UTF-16
+				 * 7-8bytes UTF-8(IVS) divided to 2 UTF-16
+				 * (charlen=3+4 or 4+4)
+				 */
+				put_unaligned(dst_char, &target[j]);
+				dst_char = cpu_to_le16(*(wchar_to + 1));
+				j++;
+				put_unaligned(dst_char, &target[j]);
+			} else if (charlen >= 5) {
+				/* 5-6bytes UTF-8 to 6bytes UTF-16 */
+				put_unaligned(dst_char, &target[j]);
+				dst_char = cpu_to_le16(*(wchar_to + 1));
+				j++;
+				put_unaligned(dst_char, &target[j]);
+				dst_char = cpu_to_le16(*(wchar_to + 2));
+				j++;
+				put_unaligned(dst_char, &target[j]);
 			}
+			continue;
+
+unknown:
+			dst_char = cpu_to_le16(0x003f);
+			charlen = 1;
 		}
+
+ctoUTF16:
 		/*
 		 * character may take more than one byte in the source string,
 		 * but will take exactly two bytes in the target string
-- 
2.25.1

