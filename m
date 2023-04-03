Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0527C761A6
	for <linux-cifs@archiver.kernel.org>; Mon,  3 Apr 2023 09:28:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231421AbjDCJ2g (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 3 Apr 2023 05:28:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232043AbjDCJ2c (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 3 Apr 2023 05:28:32 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7420E3C26
        for <linux-cifs@vger.kernel.org>; Mon,  3 Apr 2023 02:28:29 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 1AD1D21A42;
        Mon,  3 Apr 2023 09:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1680514108; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=NoyCghpYSK6WOE9xOow/VmWY1QfrCTyCyRWV8q3I27w=;
        b=n2cwLEryApfo6QPFWBSw2pTEry6hdYNRtHnXH9b4FatNuW00Cn/3TQbKvAtzelo7FoiyoT
        y82cel95nHF547BtRGTm62KP1Zh+LWQK+tNVE9N5gJ6DLROq3oyR2CgrP+16zaTWmKreA2
        DESfUsTHq1ufBh+/w5uL77LuGqk3CnE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1680514108;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=NoyCghpYSK6WOE9xOow/VmWY1QfrCTyCyRWV8q3I27w=;
        b=dMKImn47h5DyQKPfdLcqpaXa/jdAv7hzaFL00hcESbEPO6XYd3ja0YGZZXOvJ1Bqdqe8c0
        kcG5JVz8azb/gYDg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id EC4E913416;
        Mon,  3 Apr 2023 09:28:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id NsFIODucKmSOYgAAMHmgww
        (envelope-from <ddiss@suse.de>); Mon, 03 Apr 2023 09:28:27 +0000
From:   David Disseldorp <ddiss@suse.de>
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs@vger.kernel.org, David Disseldorp <ddiss@suse.de>
Subject: [PATCH] ksmbd: set NegotiateContextCount once instead of every inc
Date:   Mon,  3 Apr 2023 11:29:55 +0200
Message-Id: <20230403092955.23752-1-ddiss@suse.de>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

There are no early returns, so marshalling the incremented
NegotiateContextCount with every context is unnecessary.

Signed-off-by: David Disseldorp <ddiss@suse.de>
---
 fs/ksmbd/smb2pdu.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 97c9d1b5bcc0..e4d142b265d0 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -808,7 +808,6 @@ static void assemble_neg_contexts(struct ksmbd_conn *conn,
 		    "assemble SMB2_PREAUTH_INTEGRITY_CAPABILITIES context\n");
 	build_preauth_ctxt((struct smb2_preauth_neg_context *)pneg_ctxt,
 			   conn->preauth_info->Preauth_HashId);
-	rsp->NegotiateContextCount = cpu_to_le16(neg_ctxt_cnt);
 	inc_rfc1001_len(smb2_buf_len, AUTH_GSS_PADDING);
 	ctxt_size = sizeof(struct smb2_preauth_neg_context);
 	/* Round to 8 byte boundary */
@@ -820,7 +819,7 @@ static void assemble_neg_contexts(struct ksmbd_conn *conn,
 			    "assemble SMB2_ENCRYPTION_CAPABILITIES context\n");
 		build_encrypt_ctxt((struct smb2_encryption_neg_context *)pneg_ctxt,
 				   conn->cipher_type);
-		rsp->NegotiateContextCount = cpu_to_le16(++neg_ctxt_cnt);
+		neg_ctxt_cnt++;
 		ctxt_size += sizeof(struct smb2_encryption_neg_context) + 2;
 		/* Round to 8 byte boundary */
 		pneg_ctxt +=
@@ -835,7 +834,7 @@ static void assemble_neg_contexts(struct ksmbd_conn *conn,
 		/* Temporarily set to SMB3_COMPRESS_NONE */
 		build_compression_ctxt((struct smb2_compression_capabilities_context *)pneg_ctxt,
 				       conn->compress_algorithm);
-		rsp->NegotiateContextCount = cpu_to_le16(++neg_ctxt_cnt);
+		neg_ctxt_cnt++;
 		ctxt_size += sizeof(struct smb2_compression_capabilities_context) + 2;
 		/* Round to 8 byte boundary */
 		pneg_ctxt += round_up(sizeof(struct smb2_compression_capabilities_context) + 2,
@@ -847,7 +846,7 @@ static void assemble_neg_contexts(struct ksmbd_conn *conn,
 		ksmbd_debug(SMB,
 			    "assemble SMB2_POSIX_EXTENSIONS_AVAILABLE context\n");
 		build_posix_ctxt((struct smb2_posix_neg_context *)pneg_ctxt);
-		rsp->NegotiateContextCount = cpu_to_le16(++neg_ctxt_cnt);
+		neg_ctxt_cnt++;
 		ctxt_size += sizeof(struct smb2_posix_neg_context);
 		/* Round to 8 byte boundary */
 		pneg_ctxt += round_up(sizeof(struct smb2_posix_neg_context), 8);
@@ -859,10 +858,11 @@ static void assemble_neg_contexts(struct ksmbd_conn *conn,
 			    "assemble SMB2_SIGNING_CAPABILITIES context\n");
 		build_sign_cap_ctxt((struct smb2_signing_capabilities *)pneg_ctxt,
 				    conn->signing_algorithm);
-		rsp->NegotiateContextCount = cpu_to_le16(++neg_ctxt_cnt);
+		neg_ctxt_cnt++;
 		ctxt_size += sizeof(struct smb2_signing_capabilities) + 2;
 	}
 
+	rsp->NegotiateContextCount = cpu_to_le16(neg_ctxt_cnt);
 	inc_rfc1001_len(smb2_buf_len, ctxt_size);
 }
 
-- 
2.35.3

