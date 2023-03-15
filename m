Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93FBCC61DA4
	for <linux-cifs@archiver.kernel.org>; Wed, 15 Mar 2023 13:05:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232048AbjCONF4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 15 Mar 2023 09:05:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231234AbjCONFw (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 15 Mar 2023 09:05:52 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE2A957D07
        for <linux-cifs@vger.kernel.org>; Wed, 15 Mar 2023 06:05:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=aM0oakkiFXBAksukeeaWT6kPwK50+QtzTF0tQNARWOs=; b=cuByXm1eSk12ZAAqA1oxVnsRSC
        ioEjGG4Us50qzPRLrGwGW8fGHfF5aFrgIQtbYBsxMzsk68+5LOsUNjsxKO3KZyURfKXirm1IEDNuW
        XFUavk3YRK6CamjFIHP65qDnjVjQjqXTX1/xHxZypGASWyL9SNBx9EcCFHpxkq6Of+ZS3IQC8DZSD
        6gvZqVTitK69+H3WudXhn+pqKKKm4HYQwR8eYXAOyCMOMC0Mi4mofQeRC33+ZxzjNOaXut6n6xWGa
        Hd2pNQ3pS7M8vtPyqkyoxgE/5L3YO63L3An/veP56Do95hPGnYKCFEciJrTFEDglcu5NqsF4gQ+KW
        wTw3Cg4kFGFCbIANIT7vwo+mZdqIZjUOaFkRrDK023a1fplcYPt/D/zNDKHM5jUz9AIhyL9WdAMeq
        7b28ctnYvKtpyFYEnGebKAPJL6EEsW/0/WD3U1PTUxx9FFIJJvzzuera4G3x3VJo8eU2pDyi2+4Vl
        TMePFot+5SndlS3apytn9Pdr;
Received: from [2a01:4f8:252:410e::177:224] (port=40716 helo=atb-devel-224..) 
        by hr2.samba.org with esmtp (Exim)
        id 1pcQp7-003KNd-No; Wed, 15 Mar 2023 13:05:45 +0000
From:   Volker Lendecke <vl@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Volker Lendecke <vl@samba.org>
Subject: [PATCH 09/10] cifs: Store smb3_create_tag_posix just once
Date:   Wed, 15 Mar 2023 13:05:30 +0000
Message-Id: <eb3964c490aa3280f7ddba4a33790a19714631ac.1678885349.git.vl@samba.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1678885349.git.vl@samba.org>
References: <cover.1678885349.git.vl@samba.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Save 32 bytes in .text and a few lines

Signed-off-by: Volker Lendecke <vl@samba.org>
---
 fs/cifs/smb2pdu.c | 49 +++++++++--------------------------------------
 1 file changed, 9 insertions(+), 40 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 14b909b2348b..0c1dc33aff05 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -482,28 +482,19 @@ build_netname_ctxt(struct smb2_netname_neg_context *pneg_ctxt, char *hostname)
 	return ALIGN(le16_to_cpu(pneg_ctxt->DataLength) + sizeof(struct smb2_neg_context), 8);
 }
 
+static const char smb3_create_tag_posix[] = {
+	0x93, 0xAD, 0x25, 0x50, 0x9C, 0xB4, 0x11, 0xE7,
+	0xB4, 0x23, 0x83, 0xDE, 0x96, 0x8B, 0xCD, 0x7C
+};
+
 static void
 build_posix_ctxt(struct smb2_posix_neg_context *pneg_ctxt)
 {
 	pneg_ctxt->ContextType = SMB2_POSIX_EXTENSIONS_AVAILABLE;
 	pneg_ctxt->DataLength = cpu_to_le16(POSIX_CTXT_DATA_LEN);
-	/* SMB2_CREATE_TAG_POSIX is "0x93AD25509CB411E7B42383DE968BCD7C" */
-	pneg_ctxt->Name[0] = 0x93;
-	pneg_ctxt->Name[1] = 0xAD;
-	pneg_ctxt->Name[2] = 0x25;
-	pneg_ctxt->Name[3] = 0x50;
-	pneg_ctxt->Name[4] = 0x9C;
-	pneg_ctxt->Name[5] = 0xB4;
-	pneg_ctxt->Name[6] = 0x11;
-	pneg_ctxt->Name[7] = 0xE7;
-	pneg_ctxt->Name[8] = 0xB4;
-	pneg_ctxt->Name[9] = 0x23;
-	pneg_ctxt->Name[10] = 0x83;
-	pneg_ctxt->Name[11] = 0xDE;
-	pneg_ctxt->Name[12] = 0x96;
-	pneg_ctxt->Name[13] = 0x8B;
-	pneg_ctxt->Name[14] = 0xCD;
-	pneg_ctxt->Name[15] = 0x7C;
+	memcpy(pneg_ctxt->Name,
+	       smb3_create_tag_posix,
+	       sizeof(pneg_ctxt->Name));
 }
 
 static void
@@ -771,24 +762,7 @@ create_posix_buf(umode_t mode)
 	buf->ccontext.NameOffset =
 		cpu_to_le16(offsetof(struct create_posix, Name));
 	buf->ccontext.NameLength = cpu_to_le16(16);
-
-	/* SMB2_CREATE_TAG_POSIX is "0x93AD25509CB411E7B42383DE968BCD7C" */
-	buf->Name[0] = 0x93;
-	buf->Name[1] = 0xAD;
-	buf->Name[2] = 0x25;
-	buf->Name[3] = 0x50;
-	buf->Name[4] = 0x9C;
-	buf->Name[5] = 0xB4;
-	buf->Name[6] = 0x11;
-	buf->Name[7] = 0xE7;
-	buf->Name[8] = 0xB4;
-	buf->Name[9] = 0x23;
-	buf->Name[10] = 0x83;
-	buf->Name[11] = 0xDE;
-	buf->Name[12] = 0x96;
-	buf->Name[13] = 0x8B;
-	buf->Name[14] = 0xCD;
-	buf->Name[15] = 0x7C;
+	memcpy(buf->Name, smb3_create_tag_posix, sizeof(buf->Name));
 	buf->Mode = cpu_to_le32(mode);
 	cifs_dbg(FYI, "mode on posix create 0%o\n", mode);
 	return buf;
@@ -2099,11 +2073,6 @@ smb2_parse_contexts(struct TCP_Server_Info *server,
 	unsigned int next;
 	unsigned int remaining;
 	char *name;
-	static const char smb3_create_tag_posix[] = {
-		0x93, 0xAD, 0x25, 0x50, 0x9C,
-		0xB4, 0x11, 0xE7, 0xB4, 0x23, 0x83,
-		0xDE, 0x96, 0x8B, 0xCD, 0x7C
-	};
 
 	*oplock = 0;
 	data_offset = (char *)rsp + le32_to_cpu(rsp->CreateContextsOffset);
-- 
2.30.2

