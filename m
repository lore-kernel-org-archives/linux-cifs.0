Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FC3DC76188
	for <linux-cifs@archiver.kernel.org>; Mon,  3 Apr 2023 22:46:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232284AbjDCWqP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 3 Apr 2023 18:46:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233575AbjDCWqO (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 3 Apr 2023 18:46:14 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EFEC4497
        for <linux-cifs@vger.kernel.org>; Mon,  3 Apr 2023 15:46:13 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 421811FE42;
        Mon,  3 Apr 2023 22:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1680561972; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=w7oQrxTDWBHmLO8cJIMMJF2AZzc8OSq+pbtUum5lWKs=;
        b=HOP21o3BdD2dKuVauQM0MhEsXVcrkIW6wAtk5dkfY/NYzV1iIPFrXwdUoXkKKGIcbpWnPg
        qZ+2sPMsfpXCGYAJaj9QVKIB1Bl4zsfu3rnypXbly73s37ZPpUbma9lBT0Ap+Z8oEq83Fp
        Dmi0gw9joZwqlVseV8YHOWP4EcaTphs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1680561972;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=w7oQrxTDWBHmLO8cJIMMJF2AZzc8OSq+pbtUum5lWKs=;
        b=Z0tbG+OMfsEJ5PSyTrOVnMMpa+3llD0WTVD6MilO05+xkbcpDH76KnFwHtnJbh+WINhQHY
        Cx0pkGFSw1WkYYAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1CC8513416;
        Mon,  3 Apr 2023 22:46:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id r1l7BTRXK2SNEQAAMHmgww
        (envelope-from <ddiss@suse.de>); Mon, 03 Apr 2023 22:46:12 +0000
From:   David Disseldorp <ddiss@suse.de>
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs@vger.kernel.org, David Disseldorp <ddiss@suse.de>
Subject: [PATCH] ksmbd: avoid duplicate negotiate ctx offset increments
Date:   Tue,  4 Apr 2023 00:47:48 +0200
Message-Id: <20230403224748.27323-1-ddiss@suse.de>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Both pneg_ctxt and ctxt_size change in unison, with each adding the
length of the previously added context, rounded up to an eight byte
boundary.
Drop pneg_ctxt increments and instead use the ctxt_size offset when
passing output pointers to per-context helper functions. This slightly
simplifies offset tracking and shaves off a few text bytes.
Before (x86-64 gcc 7.5):
   text    data     bss     dec     hex filename
 213234    8677     672  222583   36577 ksmbd.ko

After:
   text    data     bss     dec     hex filename
 213218    8677     672  222567   36567 ksmbd.ko

Signed-off-by: David Disseldorp <ddiss@suse.de>
---
Note: this applies atop my previous assemble_neg_contexts cleanup
  ksmbd: set NegotiateContextCount once instead of every inc

 fs/ksmbd/smb2pdu.c | 26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index e4d142b265d0..9416c766483e 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -799,7 +799,7 @@ static void assemble_neg_contexts(struct ksmbd_conn *conn,
 				  struct smb2_negotiate_rsp *rsp,
 				  void *smb2_buf_len)
 {
-	char *pneg_ctxt = (char *)rsp +
+	char * const pneg_ctxt = (char *)rsp +
 			le32_to_cpu(rsp->NegotiateContextOffset);
 	int neg_ctxt_cnt = 1;
 	int ctxt_size;
@@ -810,21 +810,17 @@ static void assemble_neg_contexts(struct ksmbd_conn *conn,
 			   conn->preauth_info->Preauth_HashId);
 	inc_rfc1001_len(smb2_buf_len, AUTH_GSS_PADDING);
 	ctxt_size = sizeof(struct smb2_preauth_neg_context);
-	/* Round to 8 byte boundary */
-	pneg_ctxt += round_up(sizeof(struct smb2_preauth_neg_context), 8);
 
 	if (conn->cipher_type) {
+		/* Round to 8 byte boundary */
 		ctxt_size = round_up(ctxt_size, 8);
 		ksmbd_debug(SMB,
 			    "assemble SMB2_ENCRYPTION_CAPABILITIES context\n");
-		build_encrypt_ctxt((struct smb2_encryption_neg_context *)pneg_ctxt,
+		build_encrypt_ctxt((struct smb2_encryption_neg_context *)
+				   (pneg_ctxt + ctxt_size),
 				   conn->cipher_type);
 		neg_ctxt_cnt++;
 		ctxt_size += sizeof(struct smb2_encryption_neg_context) + 2;
-		/* Round to 8 byte boundary */
-		pneg_ctxt +=
-			round_up(sizeof(struct smb2_encryption_neg_context) + 2,
-				 8);
 	}
 
 	if (conn->compress_algorithm) {
@@ -832,31 +828,29 @@ static void assemble_neg_contexts(struct ksmbd_conn *conn,
 		ksmbd_debug(SMB,
 			    "assemble SMB2_COMPRESSION_CAPABILITIES context\n");
 		/* Temporarily set to SMB3_COMPRESS_NONE */
-		build_compression_ctxt((struct smb2_compression_capabilities_context *)pneg_ctxt,
+		build_compression_ctxt((struct smb2_compression_capabilities_context *)
+				       (pneg_ctxt + ctxt_size),
 				       conn->compress_algorithm);
 		neg_ctxt_cnt++;
 		ctxt_size += sizeof(struct smb2_compression_capabilities_context) + 2;
-		/* Round to 8 byte boundary */
-		pneg_ctxt += round_up(sizeof(struct smb2_compression_capabilities_context) + 2,
-				      8);
 	}
 
 	if (conn->posix_ext_supported) {
 		ctxt_size = round_up(ctxt_size, 8);
 		ksmbd_debug(SMB,
 			    "assemble SMB2_POSIX_EXTENSIONS_AVAILABLE context\n");
-		build_posix_ctxt((struct smb2_posix_neg_context *)pneg_ctxt);
+		build_posix_ctxt((struct smb2_posix_neg_context *)
+				 (pneg_ctxt + ctxt_size));
 		neg_ctxt_cnt++;
 		ctxt_size += sizeof(struct smb2_posix_neg_context);
-		/* Round to 8 byte boundary */
-		pneg_ctxt += round_up(sizeof(struct smb2_posix_neg_context), 8);
 	}
 
 	if (conn->signing_negotiated) {
 		ctxt_size = round_up(ctxt_size, 8);
 		ksmbd_debug(SMB,
 			    "assemble SMB2_SIGNING_CAPABILITIES context\n");
-		build_sign_cap_ctxt((struct smb2_signing_capabilities *)pneg_ctxt,
+		build_sign_cap_ctxt((struct smb2_signing_capabilities *)
+				    (pneg_ctxt + ctxt_size),
 				    conn->signing_algorithm);
 		neg_ctxt_cnt++;
 		ctxt_size += sizeof(struct smb2_signing_capabilities) + 2;
-- 
2.35.3

