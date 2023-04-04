Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53316C761A6
	for <linux-cifs@archiver.kernel.org>; Tue,  4 Apr 2023 14:12:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235703AbjDDOMO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 4 Apr 2023 10:12:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235737AbjDDOMN (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 4 Apr 2023 10:12:13 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7BB2AF
        for <linux-cifs@vger.kernel.org>; Tue,  4 Apr 2023 07:12:10 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 1BE9222B67;
        Tue,  4 Apr 2023 14:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1680617529; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=HkWnQIwLMNzM/oP3tGht9ZdRGvA9DoNZ4Am1Vc01PVQ=;
        b=H7vrqO40QHnwXGul2CiumSWtQm4RxVM9qdm6c47JQ3S4WY6t8n6zxYsPcz+QvWVOkBVs3j
        dmhDHE9mRilWA0SeR4RqQH50LxfggYC8waXEBS6RZ4ix83+gLN7HA+0e4tzjkrKiW710hz
        wh6SIGRRzHf1CBe4N/yozPG3xRs6jSA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1680617529;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=HkWnQIwLMNzM/oP3tGht9ZdRGvA9DoNZ4Am1Vc01PVQ=;
        b=+xxnEXq57TIDtmB6tQzV0m92JOEftkVmnvllDy7k0sBV/KpEjrTOWJivKTKD6D66NykRZg
        EJ7oSwKLLdzVX6Aw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E46AE1391A;
        Tue,  4 Apr 2023 14:12:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id sfomNjgwLGSMXAAAMHmgww
        (envelope-from <ddiss@suse.de>); Tue, 04 Apr 2023 14:12:08 +0000
From:   David Disseldorp <ddiss@suse.de>
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>, linux-cifs@vger.kernel.org,
        David Disseldorp <ddiss@suse.de>
Subject: [PATCH] ksmbd: remove unused compression negotiate ctx packing
Date:   Tue,  4 Apr 2023 16:13:42 +0200
Message-Id: <20230404141342.26269-1-ddiss@suse.de>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

build_compression_ctxt() is currently unreachable due to
conn.compress_algorithm remaining zero (SMB3_COMPRESS_NONE).

It appears to have been broken in a couple of subtle ways over the
years:
- prior to d6c9ad23b421 ("ksmbd: use the common definitions for
  NEGOTIATE_PROTOCOL") smb2_compression_ctx.DataLength was set to 8,
  which didn't account for the single CompressionAlgorithms flexible
  array member.
- post d6c9ad23b421 smb2_compression_capabilities_context
  CompressionAlgorithms is a three member array, while
  CompressionAlgorithmCount is set to indicates only one member.

Signed-off-by: David Disseldorp <ddiss@suse.de>
---
Note: this applies atop my previous assemble_neg_contexts cleanups
  ksmbd: set NegotiateContextCount once instead of every inc
  ksmbd: avoid duplicate negotiate ctx offset increments

 fs/ksmbd/smb2pdu.c | 26 ++------------------------
 1 file changed, 2 insertions(+), 24 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 9416c766483e..6dbc2300bd2a 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -747,19 +747,6 @@ static void build_encrypt_ctxt(struct smb2_encryption_neg_context *pneg_ctxt,
 	pneg_ctxt->Ciphers[0] = cipher_type;
 }
 
-static void build_compression_ctxt(struct smb2_compression_capabilities_context *pneg_ctxt,
-				   __le16 comp_algo)
-{
-	pneg_ctxt->ContextType = SMB2_COMPRESSION_CAPABILITIES;
-	pneg_ctxt->DataLength =
-		cpu_to_le16(sizeof(struct smb2_compression_capabilities_context)
-			- sizeof(struct smb2_neg_context));
-	pneg_ctxt->Reserved = cpu_to_le32(0);
-	pneg_ctxt->CompressionAlgorithmCount = cpu_to_le16(1);
-	pneg_ctxt->Flags = cpu_to_le32(0);
-	pneg_ctxt->CompressionAlgorithms[0] = comp_algo;
-}
-
 static void build_sign_cap_ctxt(struct smb2_signing_capabilities *pneg_ctxt,
 				__le16 sign_algo)
 {
@@ -823,17 +810,8 @@ static void assemble_neg_contexts(struct ksmbd_conn *conn,
 		ctxt_size += sizeof(struct smb2_encryption_neg_context) + 2;
 	}
 
-	if (conn->compress_algorithm) {
-		ctxt_size = round_up(ctxt_size, 8);
-		ksmbd_debug(SMB,
-			    "assemble SMB2_COMPRESSION_CAPABILITIES context\n");
-		/* Temporarily set to SMB3_COMPRESS_NONE */
-		build_compression_ctxt((struct smb2_compression_capabilities_context *)
-				       (pneg_ctxt + ctxt_size),
-				       conn->compress_algorithm);
-		neg_ctxt_cnt++;
-		ctxt_size += sizeof(struct smb2_compression_capabilities_context) + 2;
-	}
+	/* compression context not yet supported */
+	WARN_ON(conn->compress_algorithm != SMB3_COMPRESS_NONE);
 
 	if (conn->posix_ext_supported) {
 		ctxt_size = round_up(ctxt_size, 8);
-- 
2.35.3

