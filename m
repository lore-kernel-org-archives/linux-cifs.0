Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ED90C433ED
	for <linux-cifs@archiver.kernel.org>; Fri, 21 May 2021 02:01:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A5A860551
	for <linux-cifs@archiver.kernel.org>; Fri, 21 May 2021 02:01:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237892AbhEUCDG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 20 May 2021 22:03:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236669AbhEUCDG (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 20 May 2021 22:03:06 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55705C061574;
        Thu, 20 May 2021 19:01:44 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id v14so10390577pgi.6;
        Thu, 20 May 2021 19:01:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6hrIz+ajKfPZMc4bZ7BlQ45/bEZLHLy+I8Nk5AFtJII=;
        b=kk8+g3nZpjGC3QTfzzLKloSmbhfwCmMiVfeojAdpUJ3pbFmGdkYodiRlGd4wPgGWzD
         RzdVq32WPrOuWDI815wnJILyKF29t6kl2DiRoRRAC+y3wBam/0WOqnXL2w/PBvhVVy2E
         k5tpykzB5OKVTrUSDnMX9bvDek0evLLsCzOKnzszjOfDdmSpr7+jv3B+ct+z0PTlBae2
         ff1hHO7XHJ5ytqadplvHldYcGVfDf1PuxL8GCYf6NCWXfUbyzI44Bzs2ot2lICjW7slO
         OWCSAjJEM76Dgk4R5GKLZFYU50U5AWzVKkZphRf+RRFmoUvY9SqMGMwh0duqZCyPYmrS
         qZ5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6hrIz+ajKfPZMc4bZ7BlQ45/bEZLHLy+I8Nk5AFtJII=;
        b=k8j7nysROCA+5+203+D2yj02iglwL4u+RoofyyIpTAUovbbbTeKDjPkN1+hvXCNlJ3
         m5Ebff3MWJaqIC89h+w2UBHCGQAhoBEG7XURkUcpBkz6nwXKqmNJBP192x8TEgTH9ZvU
         SmGES61JqnBl7X4hKVdUnw6H5O0/QUwI8wvpD06rQlxCgDc54wbxurwuuTe5t6iJe0xG
         A30ZyH/M/TX5oaz1AdaTThB6nPh+fdghwkJZ2T2Irmch+MMBs0vVa8jApxadAbKgi842
         51ajSllNDeM3Rg/y1d0eJA/QnBZJ5nvWjVQspUoQUHNW8dwLIdIajszJ2Injw7Rn0LSD
         FyJw==
X-Gm-Message-State: AOAM533FlSNsezM1KlDv6/nTPImiPD675uThDyv25MjIq1pcXnForZKl
        GY2N220oV3rskfj09hYp4pQ=
X-Google-Smtp-Source: ABdhPJwmwmTOM0moyv4N5CSQlDYHuZISUGKp2wrld/9r4tj5OJ6aC3vMG64xYdPdX/v50+ocmpmJ4Q==
X-Received: by 2002:a65:6a07:: with SMTP id m7mr7281532pgu.136.1621562503656;
        Thu, 20 May 2021 19:01:43 -0700 (PDT)
Received: from localhost.localdomain ([125.177.232.58])
        by smtp.googlemail.com with ESMTPSA id t1sm3052940pgl.40.2021.05.20.19.01.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 19:01:42 -0700 (PDT)
From:   Hyunchul Lee <hyc.lee@gmail.com>
To:     Steve French <sfrench@samba.org>,
        David Howells <dhowells@redhat.com>
Cc:     kernel-team@lge.com, Namjae Jeon <linkinjeon@kernel.org>,
        linux-kernel@vger.kernel.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, Hyunchul Lee <hyc.lee@gmail.com>
Subject: [PATCH v2] cifs: decoding negTokenInit with generic ASN1 decoder
Date:   Fri, 21 May 2021 11:00:51 +0900
Message-Id: <20210521020051.196434-1-hyc.lee@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Decode negTokenInit with lib/asn1_decoder. For that,
add OIDs in linux/oid_registry.h and a negTokenInit
ASN1 file, "spnego_negtokeninit.asn1".
And define decoder's callback functions, which
are the gssapi_this_mech for checking SPENGO oid and
the neg_token_init_mech_type for getting authentication
mechanisms supported by a server.

Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
---
changes from v1:
 - Select CONFIG_OID_REGISTRY

 fs/cifs/Kconfig                  |   2 +
 fs/cifs/Makefile                 |   4 +-
 fs/cifs/asn1.c                   | 624 ++-----------------------------
 fs/cifs/spnego_negtokeninit.asn1 |  40 ++
 include/linux/oid_registry.h     |   8 +
 5 files changed, 90 insertions(+), 588 deletions(-)
 create mode 100644 fs/cifs/spnego_negtokeninit.asn1

diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
index bf52e9326ebe..7de5c893c181 100644
--- a/fs/cifs/Kconfig
+++ b/fs/cifs/Kconfig
@@ -19,6 +19,8 @@ config CIFS
 	select CRYPTO_LIB_DES
 	select KEYS
 	select DNS_RESOLVER
+	select ASN1
+	select OID_REGISTRY
 	help
 	  This is the client VFS module for the SMB3 family of NAS protocols,
 	  (including support for the most recent, most secure dialect SMB3.1.1)
diff --git a/fs/cifs/Makefile b/fs/cifs/Makefile
index 3ee3b7de4ded..f12c1a3abd44 100644
--- a/fs/cifs/Makefile
+++ b/fs/cifs/Makefile
@@ -5,13 +5,15 @@
 ccflags-y += -I$(src)		# needed for trace events
 obj-$(CONFIG_CIFS) += cifs.o
 
+$(obj)/spnego_negtokeninit.asn1.o: $(obj)/spnego_negtokeninit.asn1.c $(obj)/spnego_negtokeninit.asn1.h
+
 cifs-y := trace.o cifsfs.o cifssmb.o cifs_debug.o connect.o dir.o file.o \
 	  inode.o link.o misc.o netmisc.o smbencrypt.o transport.o asn1.o \
 	  cifs_unicode.o nterr.o cifsencrypt.o \
 	  readdir.o ioctl.o sess.o export.o smb1ops.o unc.o winucase.o \
 	  smb2ops.o smb2maperror.o smb2transport.o \
 	  smb2misc.o smb2pdu.o smb2inode.o smb2file.o cifsacl.o fs_context.o \
-	  dns_resolve.o
+	  dns_resolve.o spnego_negtokeninit.asn1.o
 
 cifs-$(CONFIG_CIFS_XATTR) += xattr.o
 
diff --git a/fs/cifs/asn1.c b/fs/cifs/asn1.c
index 3150c19cdc2f..69a31d6b5fd9 100644
--- a/fs/cifs/asn1.c
+++ b/fs/cifs/asn1.c
@@ -1,612 +1,62 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
-/*
- * The ASB.1/BER parsing code is derived from ip_nat_snmp_basic.c which was in
- * turn derived from the gxsnmp package by Gregory McLean & Jochen Friedrich
- *
- * Copyright (c) 2000 RP Internet (www.rpi.net.au).
- */
 
 #include <linux/module.h>
-#include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/mm.h>
-#include <linux/slab.h>
-#include "cifspdu.h"
+#include <linux/oid_registry.h>
 #include "cifsglob.h"
 #include "cifs_debug.h"
-#include "cifsproto.h"
+#include "spnego_negtokeninit.asn1.h"
 
-/*****************************************************************************
- *
- * Basic ASN.1 decoding routines (gxsnmp author Dirk Wisse)
- *
- *****************************************************************************/
-
-/* Class */
-#define ASN1_UNI	0	/* Universal */
-#define ASN1_APL	1	/* Application */
-#define ASN1_CTX	2	/* Context */
-#define ASN1_PRV	3	/* Private */
-
-/* Tag */
-#define ASN1_EOC	0	/* End Of Contents or N/A */
-#define ASN1_BOL	1	/* Boolean */
-#define ASN1_INT	2	/* Integer */
-#define ASN1_BTS	3	/* Bit String */
-#define ASN1_OTS	4	/* Octet String */
-#define ASN1_NUL	5	/* Null */
-#define ASN1_OJI	6	/* Object Identifier  */
-#define ASN1_OJD	7	/* Object Description */
-#define ASN1_EXT	8	/* External */
-#define ASN1_ENUM	10	/* Enumerated */
-#define ASN1_SEQ	16	/* Sequence */
-#define ASN1_SET	17	/* Set */
-#define ASN1_NUMSTR	18	/* Numerical String */
-#define ASN1_PRNSTR	19	/* Printable String */
-#define ASN1_TEXSTR	20	/* Teletext String */
-#define ASN1_VIDSTR	21	/* Video String */
-#define ASN1_IA5STR	22	/* IA5 String */
-#define ASN1_UNITIM	23	/* Universal Time */
-#define ASN1_GENTIM	24	/* General Time */
-#define ASN1_GRASTR	25	/* Graphical String */
-#define ASN1_VISSTR	26	/* Visible String */
-#define ASN1_GENSTR	27	/* General String */
-
-/* Primitive / Constructed methods*/
-#define ASN1_PRI	0	/* Primitive */
-#define ASN1_CON	1	/* Constructed */
-
-/*
- * Error codes.
- */
-#define ASN1_ERR_NOERROR		0
-#define ASN1_ERR_DEC_EMPTY		2
-#define ASN1_ERR_DEC_EOC_MISMATCH	3
-#define ASN1_ERR_DEC_LENGTH_MISMATCH	4
-#define ASN1_ERR_DEC_BADVALUE		5
-
-#define SPNEGO_OID_LEN 7
-#define NTLMSSP_OID_LEN  10
-#define KRB5_OID_LEN  7
-#define KRB5U2U_OID_LEN  8
-#define MSKRB5_OID_LEN  7
-static unsigned long SPNEGO_OID[7] = { 1, 3, 6, 1, 5, 5, 2 };
-static unsigned long NTLMSSP_OID[10] = { 1, 3, 6, 1, 4, 1, 311, 2, 2, 10 };
-static unsigned long KRB5_OID[7] = { 1, 2, 840, 113554, 1, 2, 2 };
-static unsigned long KRB5U2U_OID[8] = { 1, 2, 840, 113554, 1, 2, 2, 3 };
-static unsigned long MSKRB5_OID[7] = { 1, 2, 840, 48018, 1, 2, 2 };
-
-/*
- * ASN.1 context.
- */
-struct asn1_ctx {
-	int error;		/* Error condition */
-	unsigned char *pointer;	/* Octet just to be decoded */
-	unsigned char *begin;	/* First octet */
-	unsigned char *end;	/* Octet after last octet */
-};
-
-/*
- * Octet string (not null terminated)
- */
-struct asn1_octstr {
-	unsigned char *data;
-	unsigned int len;
-};
-
-static void
-asn1_open(struct asn1_ctx *ctx, unsigned char *buf, unsigned int len)
-{
-	ctx->begin = buf;
-	ctx->end = buf + len;
-	ctx->pointer = buf;
-	ctx->error = ASN1_ERR_NOERROR;
-}
-
-static unsigned char
-asn1_octet_decode(struct asn1_ctx *ctx, unsigned char *ch)
-{
-	if (ctx->pointer >= ctx->end) {
-		ctx->error = ASN1_ERR_DEC_EMPTY;
-		return 0;
-	}
-	*ch = *(ctx->pointer)++;
-	return 1;
-}
-
-#if 0 /* will be needed later by spnego decoding/encoding of ntlmssp */
-static unsigned char
-asn1_enum_decode(struct asn1_ctx *ctx, __le32 *val)
-{
-	unsigned char ch;
-
-	if (ctx->pointer >= ctx->end) {
-		ctx->error = ASN1_ERR_DEC_EMPTY;
-		return 0;
-	}
-
-	ch = *(ctx->pointer)++; /* ch has 0xa, ptr points to length octet */
-	if ((ch) == ASN1_ENUM)  /* if ch value is ENUM, 0xa */
-		*val = *(++(ctx->pointer)); /* value has enum value */
-	else
-		return 0;
-
-	ctx->pointer++;
-	return 1;
-}
-#endif
-
-static unsigned char
-asn1_tag_decode(struct asn1_ctx *ctx, unsigned int *tag)
-{
-	unsigned char ch;
-
-	*tag = 0;
-
-	do {
-		if (!asn1_octet_decode(ctx, &ch))
-			return 0;
-		*tag <<= 7;
-		*tag |= ch & 0x7F;
-	} while ((ch & 0x80) == 0x80);
-	return 1;
-}
-
-static unsigned char
-asn1_id_decode(struct asn1_ctx *ctx,
-	       unsigned int *cls, unsigned int *con, unsigned int *tag)
-{
-	unsigned char ch;
-
-	if (!asn1_octet_decode(ctx, &ch))
-		return 0;
-
-	*cls = (ch & 0xC0) >> 6;
-	*con = (ch & 0x20) >> 5;
-	*tag = (ch & 0x1F);
-
-	if (*tag == 0x1F) {
-		if (!asn1_tag_decode(ctx, tag))
-			return 0;
-	}
-	return 1;
-}
-
-static unsigned char
-asn1_length_decode(struct asn1_ctx *ctx, unsigned int *def, unsigned int *len)
-{
-	unsigned char ch, cnt;
-
-	if (!asn1_octet_decode(ctx, &ch))
-		return 0;
-
-	if (ch == 0x80)
-		*def = 0;
-	else {
-		*def = 1;
-
-		if (ch < 0x80)
-			*len = ch;
-		else {
-			cnt = (unsigned char) (ch & 0x7F);
-			*len = 0;
-
-			while (cnt > 0) {
-				if (!asn1_octet_decode(ctx, &ch))
-					return 0;
-				*len <<= 8;
-				*len |= ch;
-				cnt--;
-			}
-		}
-	}
-
-	/* don't trust len bigger than ctx buffer */
-	if (*len > ctx->end - ctx->pointer)
-		return 0;
-
-	return 1;
-}
-
-static unsigned char
-asn1_header_decode(struct asn1_ctx *ctx,
-		   unsigned char **eoc,
-		   unsigned int *cls, unsigned int *con, unsigned int *tag)
-{
-	unsigned int def = 0;
-	unsigned int len = 0;
-
-	if (!asn1_id_decode(ctx, cls, con, tag))
-		return 0;
-
-	if (!asn1_length_decode(ctx, &def, &len))
-		return 0;
-
-	/* primitive shall be definite, indefinite shall be constructed */
-	if (*con == ASN1_PRI && !def)
-		return 0;
-
-	if (def)
-		*eoc = ctx->pointer + len;
-	else
-		*eoc = NULL;
-	return 1;
-}
-
-static unsigned char
-asn1_eoc_decode(struct asn1_ctx *ctx, unsigned char *eoc)
+int
+decode_negTokenInit(unsigned char *security_blob, int length,
+		    struct TCP_Server_Info *server)
 {
-	unsigned char ch;
-
-	if (eoc == NULL) {
-		if (!asn1_octet_decode(ctx, &ch))
-			return 0;
-
-		if (ch != 0x00) {
-			ctx->error = ASN1_ERR_DEC_EOC_MISMATCH;
-			return 0;
-		}
-
-		if (!asn1_octet_decode(ctx, &ch))
-			return 0;
-
-		if (ch != 0x00) {
-			ctx->error = ASN1_ERR_DEC_EOC_MISMATCH;
-			return 0;
-		}
-		return 1;
-	} else {
-		if (ctx->pointer != eoc) {
-			ctx->error = ASN1_ERR_DEC_LENGTH_MISMATCH;
-			return 0;
-		}
+	if (asn1_ber_decoder(&spnego_negtokeninit_decoder, server,
+			     security_blob, length) == 0)
 		return 1;
-	}
-}
-
-/* static unsigned char asn1_null_decode(struct asn1_ctx *ctx,
-				      unsigned char *eoc)
-{
-	ctx->pointer = eoc;
-	return 1;
-}
-
-static unsigned char asn1_long_decode(struct asn1_ctx *ctx,
-				      unsigned char *eoc, long *integer)
-{
-	unsigned char ch;
-	unsigned int len;
-
-	if (!asn1_octet_decode(ctx, &ch))
-		return 0;
-
-	*integer = (signed char) ch;
-	len = 1;
-
-	while (ctx->pointer < eoc) {
-		if (++len > sizeof(long)) {
-			ctx->error = ASN1_ERR_DEC_BADVALUE;
-			return 0;
-		}
-
-		if (!asn1_octet_decode(ctx, &ch))
-			return 0;
-
-		*integer <<= 8;
-		*integer |= ch;
-	}
-	return 1;
-}
-
-static unsigned char asn1_uint_decode(struct asn1_ctx *ctx,
-				      unsigned char *eoc,
-				      unsigned int *integer)
-{
-	unsigned char ch;
-	unsigned int len;
-
-	if (!asn1_octet_decode(ctx, &ch))
-		return 0;
-
-	*integer = ch;
-	if (ch == 0)
-		len = 0;
 	else
-		len = 1;
-
-	while (ctx->pointer < eoc) {
-		if (++len > sizeof(unsigned int)) {
-			ctx->error = ASN1_ERR_DEC_BADVALUE;
-			return 0;
-		}
-
-		if (!asn1_octet_decode(ctx, &ch))
-			return 0;
-
-		*integer <<= 8;
-		*integer |= ch;
-	}
-	return 1;
-}
-
-static unsigned char asn1_ulong_decode(struct asn1_ctx *ctx,
-				       unsigned char *eoc,
-				       unsigned long *integer)
-{
-	unsigned char ch;
-	unsigned int len;
-
-	if (!asn1_octet_decode(ctx, &ch))
 		return 0;
-
-	*integer = ch;
-	if (ch == 0)
-		len = 0;
-	else
-		len = 1;
-
-	while (ctx->pointer < eoc) {
-		if (++len > sizeof(unsigned long)) {
-			ctx->error = ASN1_ERR_DEC_BADVALUE;
-			return 0;
-		}
-
-		if (!asn1_octet_decode(ctx, &ch))
-			return 0;
-
-		*integer <<= 8;
-		*integer |= ch;
-	}
-	return 1;
 }
 
-static unsigned char
-asn1_octets_decode(struct asn1_ctx *ctx,
-		   unsigned char *eoc,
-		   unsigned char **octets, unsigned int *len)
+int gssapi_this_mech(void *context, size_t hdrlen,
+		     unsigned char tag, const void *value, size_t vlen)
 {
-	unsigned char *ptr;
-
-	*len = 0;
-
-	*octets = kmalloc(eoc - ctx->pointer, GFP_ATOMIC);
-	if (*octets == NULL) {
-		return 0;
-	}
-
-	ptr = *octets;
-	while (ctx->pointer < eoc) {
-		if (!asn1_octet_decode(ctx, (unsigned char *) ptr++)) {
-			kfree(*octets);
-			*octets = NULL;
-			return 0;
-		}
-		(*len)++;
-	}
-	return 1;
-} */
-
-static unsigned char
-asn1_subid_decode(struct asn1_ctx *ctx, unsigned long *subid)
-{
-	unsigned char ch;
-
-	*subid = 0;
-
-	do {
-		if (!asn1_octet_decode(ctx, &ch))
-			return 0;
-
-		*subid <<= 7;
-		*subid |= ch & 0x7F;
-	} while ((ch & 0x80) == 0x80);
-	return 1;
-}
-
-static int
-asn1_oid_decode(struct asn1_ctx *ctx,
-		unsigned char *eoc, unsigned long **oid, unsigned int *len)
-{
-	unsigned long subid;
-	unsigned int size;
-	unsigned long *optr;
-
-	size = eoc - ctx->pointer + 1;
-
-	/* first subid actually encodes first two subids */
-	if (size < 2 || size > UINT_MAX/sizeof(unsigned long))
-		return 0;
-
-	*oid = kmalloc_array(size, sizeof(unsigned long), GFP_ATOMIC);
-	if (*oid == NULL)
-		return 0;
-
-	optr = *oid;
-
-	if (!asn1_subid_decode(ctx, &subid)) {
-		kfree(*oid);
-		*oid = NULL;
-		return 0;
-	}
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
-	*len = 2;
-	optr += 2;
+	enum OID oid;
 
-	while (ctx->pointer < eoc) {
-		if (++(*len) > size) {
-			ctx->error = ASN1_ERR_DEC_BADVALUE;
-			kfree(*oid);
-			*oid = NULL;
-			return 0;
-		}
+	oid = look_up_OID(value, vlen);
+	if (oid != OID_spnego) {
+		char buf[50];
 
-		if (!asn1_subid_decode(ctx, optr++)) {
-			kfree(*oid);
-			*oid = NULL;
-			return 0;
-		}
+		sprint_oid(value, vlen, buf, sizeof(buf));
+		cifs_dbg(FYI, "Error decoding negTokenInit header: unexpected OID %s\n",
+			 buf);
+		return -EBADMSG;
 	}
-	return 1;
+	return 0;
 }
 
-static int
-compare_oid(unsigned long *oid1, unsigned int oid1len,
-	    unsigned long *oid2, unsigned int oid2len)
+int neg_token_init_mech_type(void *context, size_t hdrlen,
+			     unsigned char tag,
+			     const void *value, size_t vlen)
 {
-	unsigned int i;
+	struct TCP_Server_Info *server = context;
+	enum OID oid;
 
-	if (oid1len != oid2len)
-		return 0;
+	oid = look_up_OID(value, vlen);
+	if (oid == OID_mskrb5)
+		server->sec_mskerberos = true;
+	else if (oid == OID_krb5u2u)
+		server->sec_kerberosu2u = true;
+	else if (oid == OID_krb5)
+		server->sec_kerberos = true;
+	else if (oid == OID_ntlmssp)
+		server->sec_ntlmssp = true;
 	else {
-		for (i = 0; i < oid1len; i++) {
-			if (oid1[i] != oid2[i])
-				return 0;
-		}
-		return 1;
-	}
-}
-
-	/* BB check for endian conversion issues here */
-
-int
-decode_negTokenInit(unsigned char *security_blob, int length,
-		    struct TCP_Server_Info *server)
-{
-	struct asn1_ctx ctx;
-	unsigned char *end;
-	unsigned char *sequence_end;
-	unsigned long *oid = NULL;
-	unsigned int cls, con, tag, oidlen, rc;
-
-	/* cifs_dump_mem(" Received SecBlob ", security_blob, length); */
-
-	asn1_open(&ctx, security_blob, length);
+		char buf[50];
 
-	/* GSSAPI header */
-	if (asn1_header_decode(&ctx, &end, &cls, &con, &tag) == 0) {
-		cifs_dbg(FYI, "Error decoding negTokenInit header\n");
-		return 0;
-	} else if ((cls != ASN1_APL) || (con != ASN1_CON)
-		   || (tag != ASN1_EOC)) {
-		cifs_dbg(FYI, "cls = %d con = %d tag = %d\n", cls, con, tag);
-		return 0;
+		sprint_oid(value, vlen, buf, sizeof(buf));
+		cifs_dbg(FYI, "Decoding negTokenInit: unsupported OID %s\n",
+			 buf);
 	}
-
-	/* Check for SPNEGO OID -- remember to free obj->oid */
-	rc = asn1_header_decode(&ctx, &end, &cls, &con, &tag);
-	if (rc) {
-		if ((tag == ASN1_OJI) && (con == ASN1_PRI) &&
-		    (cls == ASN1_UNI)) {
-			rc = asn1_oid_decode(&ctx, end, &oid, &oidlen);
-			if (rc) {
-				rc = compare_oid(oid, oidlen, SPNEGO_OID,
-						 SPNEGO_OID_LEN);
-				kfree(oid);
-			}
-		} else
-			rc = 0;
-	}
-
-	/* SPNEGO OID not present or garbled -- bail out */
-	if (!rc) {
-		cifs_dbg(FYI, "Error decoding negTokenInit header\n");
-		return 0;
-	}
-
-	/* SPNEGO */
-	if (asn1_header_decode(&ctx, &end, &cls, &con, &tag) == 0) {
-		cifs_dbg(FYI, "Error decoding negTokenInit\n");
-		return 0;
-	} else if ((cls != ASN1_CTX) || (con != ASN1_CON)
-		   || (tag != ASN1_EOC)) {
-		cifs_dbg(FYI, "cls = %d con = %d tag = %d end = %p exit 0\n",
-			 cls, con, tag, end);
-		return 0;
-	}
-
-	/* negTokenInit */
-	if (asn1_header_decode(&ctx, &end, &cls, &con, &tag) == 0) {
-		cifs_dbg(FYI, "Error decoding negTokenInit\n");
-		return 0;
-	} else if ((cls != ASN1_UNI) || (con != ASN1_CON)
-		   || (tag != ASN1_SEQ)) {
-		cifs_dbg(FYI, "cls = %d con = %d tag = %d end = %p exit 1\n",
-			 cls, con, tag, end);
-		return 0;
-	}
-
-	/* sequence */
-	if (asn1_header_decode(&ctx, &end, &cls, &con, &tag) == 0) {
-		cifs_dbg(FYI, "Error decoding 2nd part of negTokenInit\n");
-		return 0;
-	} else if ((cls != ASN1_CTX) || (con != ASN1_CON)
-		   || (tag != ASN1_EOC)) {
-		cifs_dbg(FYI, "cls = %d con = %d tag = %d end = %p exit 0\n",
-			 cls, con, tag, end);
-		return 0;
-	}
-
-	/* sequence of */
-	if (asn1_header_decode
-	    (&ctx, &sequence_end, &cls, &con, &tag) == 0) {
-		cifs_dbg(FYI, "Error decoding 2nd part of negTokenInit\n");
-		return 0;
-	} else if ((cls != ASN1_UNI) || (con != ASN1_CON)
-		   || (tag != ASN1_SEQ)) {
-		cifs_dbg(FYI, "cls = %d con = %d tag = %d sequence_end = %p exit 1\n",
-			 cls, con, tag, sequence_end);
-		return 0;
-	}
-
-	/* list of security mechanisms */
-	while (!asn1_eoc_decode(&ctx, sequence_end)) {
-		rc = asn1_header_decode(&ctx, &end, &cls, &con, &tag);
-		if (!rc) {
-			cifs_dbg(FYI, "Error decoding negTokenInit hdr exit2\n");
-			return 0;
-		}
-		if ((tag == ASN1_OJI) && (con == ASN1_PRI)) {
-			if (asn1_oid_decode(&ctx, end, &oid, &oidlen)) {
-
-				cifs_dbg(FYI, "OID len = %d oid = 0x%lx 0x%lx 0x%lx 0x%lx\n",
-					 oidlen, *oid, *(oid + 1), *(oid + 2),
-					 *(oid + 3));
-
-				if (compare_oid(oid, oidlen, MSKRB5_OID,
-						MSKRB5_OID_LEN))
-					server->sec_mskerberos = true;
-				else if (compare_oid(oid, oidlen, KRB5U2U_OID,
-						     KRB5U2U_OID_LEN))
-					server->sec_kerberosu2u = true;
-				else if (compare_oid(oid, oidlen, KRB5_OID,
-						     KRB5_OID_LEN))
-					server->sec_kerberos = true;
-				else if (compare_oid(oid, oidlen, NTLMSSP_OID,
-						     NTLMSSP_OID_LEN))
-					server->sec_ntlmssp = true;
-
-				kfree(oid);
-			}
-		} else {
-			cifs_dbg(FYI, "Should be an oid what is going on?\n");
-		}
-	}
-
-	/*
-	 * We currently ignore anything at the end of the SPNEGO blob after
-	 * the mechTypes have been parsed, since none of that info is
-	 * used at the moment.
-	 */
-	return 1;
+	return 0;
 }
diff --git a/fs/cifs/spnego_negtokeninit.asn1 b/fs/cifs/spnego_negtokeninit.asn1
new file mode 100644
index 000000000000..aa5b4a61b3f5
--- /dev/null
+++ b/fs/cifs/spnego_negtokeninit.asn1
@@ -0,0 +1,40 @@
+GSSAPI ::=
+	[APPLICATION 0] IMPLICIT SEQUENCE {
+		thisMech
+			OBJECT IDENTIFIER ({gssapi_this_mech}),
+		negotiationToken
+			NegotiationToken
+	}
+
+MechType ::= OBJECT IDENTIFIER ({neg_token_init_mech_type})
+
+MechTypeList ::= SEQUENCE OF MechType
+
+NegHints ::= SEQUENCE {
+	hintName
+		[0] GeneralString OPTIONAL,
+	hintAddress
+		[1] OCTET STRING OPTIONAL
+	}
+
+NegTokenInit2 ::=
+	SEQUENCE {
+		mechTypes
+			[0] MechTypeList OPTIONAL,
+		reqFlags
+			[1] BIT STRING OPTIONAL,
+		mechToken
+			[2] OCTET STRING OPTIONAL,
+		negHints
+			[3] NegHints OPTIONAL,
+		mechListMIC
+			[3] OCTET STRING OPTIONAL
+	}
+
+NegotiationToken ::=
+	CHOICE {
+		negTokenInit
+			[0] NegTokenInit2,
+		negTokenTarg
+			[1] ANY
+	}
diff --git a/include/linux/oid_registry.h b/include/linux/oid_registry.h
index 461b7aa587ba..3d8db1f6a5db 100644
--- a/include/linux/oid_registry.h
+++ b/include/linux/oid_registry.h
@@ -54,6 +54,10 @@ enum OID {
 	OID_md4,			/* 1.2.840.113549.2.4 */
 	OID_md5,			/* 1.2.840.113549.2.5 */
 
+	OID_mskrb5,			/* 1.2.840.48018.1.2.2 */
+	OID_krb5,			/* 1.2.840.113554.1.2.2 */
+	OID_krb5u2u,			/* 1.2.840.113554.1.2.2.3 */
+
 	/* Microsoft Authenticode & Software Publishing */
 	OID_msIndirectData,		/* 1.3.6.1.4.1.311.2.1.4 */
 	OID_msStatementType,		/* 1.3.6.1.4.1.311.2.1.11 */
@@ -62,6 +66,10 @@ enum OID {
 	OID_msIndividualSPKeyPurpose,	/* 1.3.6.1.4.1.311.2.1.21 */
 	OID_msOutlookExpress,		/* 1.3.6.1.4.1.311.16.4 */
 
+	OID_ntlmssp,			/* 1.3.6.1.4.1.311.2.2.10 */
+
+	OID_spnego,			/* 1.3.6.1.5.5.2 */
+
 	OID_certAuthInfoAccess,		/* 1.3.6.1.5.5.7.1.1 */
 	OID_sha1,			/* 1.3.14.3.2.26 */
 	OID_id_ansip384r1,		/* 1.3.132.0.34 */
-- 
2.25.1

