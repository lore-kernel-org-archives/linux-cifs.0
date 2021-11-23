Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0958CC433F5
	for <linux-cifs@archiver.kernel.org>; Tue, 23 Nov 2021 02:10:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231857AbhKWCN6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 22 Nov 2021 21:13:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231516AbhKWCN6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 22 Nov 2021 21:13:58 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A51EC061574
        for <linux-cifs@vger.kernel.org>; Mon, 22 Nov 2021 18:10:51 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id n15-20020a17090a160f00b001a75089daa3so824107pja.1
        for <linux-cifs@vger.kernel.org>; Mon, 22 Nov 2021 18:10:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GwBo3kBcfvMF7XryqLUNo8SwmErVSSgauMegMbqfEvY=;
        b=VgaHcU/8fc/fTjxzY0G+9SuwYrfSOXKPqNknZu1K7pXjqN6UoWlPTt/NGZGkoUnncW
         2IUPI7gPqpJPFtS11c1gbqGRblTGbHp7iTblOKW3D0ZlvBv6iVPaWYFf12HWqDj+TN3A
         NAhMYM/DoriOr4E7wWRK2W/MnWD0AAzL2Ddhi2eyzCUIOTxGW3+oPM/1giioE341/LZ0
         +0vJEAPjqe7SPKoUBUtMVuyZDVPiQTtg7AST6LWzJU/Y2iKtd24gg5gSKHK3v+bGI8S5
         bYNYS2gGLhhrArvLuF0nJ+qCyDRsmV4fGyeZv62l3EqlON1dRkox11ReENd5/upxZLAx
         3kgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GwBo3kBcfvMF7XryqLUNo8SwmErVSSgauMegMbqfEvY=;
        b=Y8ZfWOkx4XVzwilQETXnYUNeqMDY6Whb5Ed9Oc8ysYH+i+jdQSEoXa2eK39qiFfY5l
         heGLM2bn6mx5eJKxCxMZUn1gh9V66iKFJmaKZ4ZpmS+WTGTY2WAixg/IZlCpCBCLuhJL
         H8Gi8nIEAcvSyCkx4BFpU3XE2W6vskPmhw+TfrjyNh7vUmZDrkAH3fLdXu/yrRqGMzyd
         TK3D7sUF6ohsrHk61ROoKlnkAvLAtfCczIEJZ922iGgxE2498XmQaQQ4t7uimku4lMTp
         1HObAhPMTJbEa7Knl+yInzJ7FAI3Cs9jyiUlWRNPwZ3inATMZq2TeyjdjvS5I5ZELRbv
         3QDA==
X-Gm-Message-State: AOAM532oQEy8rXYERrks7nYR+f2+ToKqw89gQcIj93/oE8PjCSxhs1sQ
        982bSPsrrf+PCgtHG77TX0GpRS+IXOUgQNQR
X-Google-Smtp-Source: ABdhPJycWJMzF3U6yse7nqmjgfesAXtnrN4Qf2E5Rlv1O+fPmJdgnOpQhv5I6DNOmWsy4bE5/1yCaQ==
X-Received: by 2002:a17:90b:4d08:: with SMTP id mw8mr38812610pjb.236.1637633450321;
        Mon, 22 Nov 2021 18:10:50 -0800 (PST)
Received: from localhost.localdomain ([210.123.88.105])
        by smtp.googlemail.com with ESMTPSA id ep15sm267570pjb.3.2021.11.22.18.10.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Nov 2021 18:10:49 -0800 (PST)
From:   Hyunchul Lee <hyc.lee@gmail.com>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>
Subject: [PATCH] ksmbd: use oid registry functions to decode OIDs
Date:   Tue, 23 Nov 2021 11:10:13 +0900
Message-Id: <20211123021013.32566-1-hyc.lee@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Use look_up_OID to decode OIDs rather than
implementing functions.

Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
---
 fs/ksmbd/asn1.c | 142 +++++++-----------------------------------------
 1 file changed, 19 insertions(+), 123 deletions(-)

diff --git a/fs/ksmbd/asn1.c b/fs/ksmbd/asn1.c
index b014f4638610..c03eba090368 100644
--- a/fs/ksmbd/asn1.c
+++ b/fs/ksmbd/asn1.c
@@ -21,101 +21,11 @@
 #include "ksmbd_spnego_negtokeninit.asn1.h"
 #include "ksmbd_spnego_negtokentarg.asn1.h"
 
-#define SPNEGO_OID_LEN 7
 #define NTLMSSP_OID_LEN  10
-#define KRB5_OID_LEN  7
-#define KRB5U2U_OID_LEN  8
-#define MSKRB5_OID_LEN  7
-static unsigned long SPNEGO_OID[7] = { 1, 3, 6, 1, 5, 5, 2 };
-static unsigned long NTLMSSP_OID[10] = { 1, 3, 6, 1, 4, 1, 311, 2, 2, 10 };
-static unsigned long KRB5_OID[7] = { 1, 2, 840, 113554, 1, 2, 2 };
-static unsigned long KRB5U2U_OID[8] = { 1, 2, 840, 113554, 1, 2, 2, 3 };
-static unsigned long MSKRB5_OID[7] = { 1, 2, 840, 48018, 1, 2, 2 };
 
 static char NTLMSSP_OID_STR[NTLMSSP_OID_LEN] = { 0x2b, 0x06, 0x01, 0x04, 0x01,
 	0x82, 0x37, 0x02, 0x02, 0x0a };
 
-static bool
-asn1_subid_decode(const unsigned char **begin, const unsigned char *end,
-		  unsigned long *subid)
-{
-	const unsigned char *ptr = *begin;
-	unsigned char ch;
-
-	*subid = 0;
-
-	do {
-		if (ptr >= end)
-			return false;
-
-		ch = *ptr++;
-		*subid <<= 7;
-		*subid |= ch & 0x7F;
-	} while ((ch & 0x80) == 0x80);
-
-	*begin = ptr;
-	return true;
-}
-
-static bool asn1_oid_decode(const unsigned char *value, size_t vlen,
-			    unsigned long **oid, size_t *oidlen)
-{
-	const unsigned char *iptr = value, *end = value + vlen;
-	unsigned long *optr;
-	unsigned long subid;
-
-	vlen += 1;
-	if (vlen < 2 || vlen > UINT_MAX / sizeof(unsigned long))
-		goto fail_nullify;
-
-	*oid = kmalloc(vlen * sizeof(unsigned long), GFP_KERNEL);
-	if (!*oid)
-		return false;
-
-	optr = *oid;
-
-	if (!asn1_subid_decode(&iptr, end, &subid))
-		goto fail;
-
-	if (subid < 40) {
-		optr[0] = 0;
-		optr[1] = subid;
-	} else if (subid < 80) {
-		optr[0] = 1;
-		optr[1] = subid - 40;
-	} else {
-		optr[0] = 2;
-		optr[1] = subid - 80;
-	}
-
-	*oidlen = 2;
-	optr += 2;
-
-	while (iptr < end) {
-		if (++(*oidlen) > vlen)
-			goto fail;
-
-		if (!asn1_subid_decode(&iptr, end, optr++))
-			goto fail;
-	}
-	return true;
-
-fail:
-	kfree(*oid);
-fail_nullify:
-	*oid = NULL;
-	return false;
-}
-
-static bool oid_eq(unsigned long *oid1, unsigned int oid1len,
-		   unsigned long *oid2, unsigned int oid2len)
-{
-	if (oid1len != oid2len)
-		return false;
-
-	return memcmp(oid1, oid2, oid1len) == 0;
-}
-
 int
 ksmbd_decode_negTokenInit(unsigned char *security_blob, int length,
 			  struct ksmbd_conn *conn)
@@ -252,26 +162,18 @@ int build_spnego_ntlmssp_auth_blob(unsigned char **pbuffer, u16 *buflen,
 int ksmbd_gssapi_this_mech(void *context, size_t hdrlen, unsigned char tag,
 			   const void *value, size_t vlen)
 {
-	unsigned long *oid;
-	size_t oidlen;
-	int err = 0;
-
-	if (!asn1_oid_decode(value, vlen, &oid, &oidlen)) {
-		err = -EBADMSG;
-		goto out;
-	}
+	enum OID oid;
 
-	if (!oid_eq(oid, oidlen, SPNEGO_OID, SPNEGO_OID_LEN))
-		err = -EBADMSG;
-	kfree(oid);
-out:
-	if (err) {
+	oid = look_up_OID(value, vlen);
+	if (oid != OID_spnego) {
 		char buf[50];
 
 		sprint_oid(value, vlen, buf, sizeof(buf));
 		ksmbd_debug(AUTH, "Unexpected OID: %s\n", buf);
+		return -EBADMSG;
 	}
-	return err;
+
+	return 0;
 }
 
 int ksmbd_neg_token_init_mech_type(void *context, size_t hdrlen,
@@ -279,37 +181,31 @@ int ksmbd_neg_token_init_mech_type(void *context, size_t hdrlen,
 				   size_t vlen)
 {
 	struct ksmbd_conn *conn = context;
-	unsigned long *oid;
-	size_t oidlen;
+	enum OID oid;
 	int mech_type;
-	char buf[50];
 
-	if (!asn1_oid_decode(value, vlen, &oid, &oidlen))
-		goto fail;
-
-	if (oid_eq(oid, oidlen, NTLMSSP_OID, NTLMSSP_OID_LEN))
+	oid = look_up_OID(value, vlen);
+	if (oid == OID_ntlmssp) {
 		mech_type = KSMBD_AUTH_NTLMSSP;
-	else if (oid_eq(oid, oidlen, MSKRB5_OID, MSKRB5_OID_LEN))
+	} else if (oid == OID_mskrb5) {
 		mech_type = KSMBD_AUTH_MSKRB5;
-	else if (oid_eq(oid, oidlen, KRB5_OID, KRB5_OID_LEN))
+	} else if (oid == OID_krb5) {
 		mech_type = KSMBD_AUTH_KRB5;
-	else if (oid_eq(oid, oidlen, KRB5U2U_OID, KRB5U2U_OID_LEN))
+	} else if (oid == OID_krb5u2u) {
 		mech_type = KSMBD_AUTH_KRB5U2U;
-	else
-		goto fail;
+	} else {
+		char buf[50];
+
+		sprint_oid(value, vlen, buf, sizeof(buf));
+		ksmbd_debug(AUTH, "Unexpected OID: %s\n", buf);
+		return -EBADMSG;
+	}
 
 	conn->auth_mechs |= mech_type;
 	if (conn->preferred_auth_mech == 0)
 		conn->preferred_auth_mech = mech_type;
 
-	kfree(oid);
 	return 0;
-
-fail:
-	kfree(oid);
-	sprint_oid(value, vlen, buf, sizeof(buf));
-	ksmbd_debug(AUTH, "Unexpected OID: %s\n", buf);
-	return -EBADMSG;
 }
 
 int ksmbd_neg_token_init_mech_token(void *context, size_t hdrlen,
-- 
2.25.1

