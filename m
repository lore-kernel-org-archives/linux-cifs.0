Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71246ECAAA1
	for <linux-cifs@archiver.kernel.org>; Sat, 17 Sep 2022 02:07:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbiIQCHM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 16 Sep 2022 22:07:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiIQCHL (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 16 Sep 2022 22:07:11 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34ED1B0B15
        for <linux-cifs@vger.kernel.org>; Fri, 16 Sep 2022 19:07:10 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id D074634561;
        Sat, 17 Sep 2022 02:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1663380428; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=DXcx62q5B28S3Ylq0t+ry2C7T5h+OSMm+QxfSp7zswQ=;
        b=zrIR8fU+Qw4zZJdVtZgFhSlWyNxEy+8HPqo86JhVnneRLiFlT4iiJhWAX6JmRP/J9CrVnd
        aqCgwMcEej5MIuxFAaf5qXjqtVHL85ySB1xcAJVLNh+hnPIyTieE7DRHvgk+0gWUK7qeSU
        NVJ2R0cpGuGAIidM8RxWIAMEGBe+KCU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1663380428;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=DXcx62q5B28S3Ylq0t+ry2C7T5h+OSMm+QxfSp7zswQ=;
        b=MxH9t5zqJjj9ThjO0v7/KpwGIbsSLHW3NOLQnDBCO3wRRurLTAKkeggB5fAFQjRPSeyc0Y
        gV51H1iHC4UhyBDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5144713A7F;
        Sat, 17 Sep 2022 02:07:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 2a6JBcwrJWPHNgAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Sat, 17 Sep 2022 02:07:08 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com
Subject: [PATCH] cifs: verify signature only for valid responses
Date:   Fri, 16 Sep 2022 23:07:04 -0300
Message-Id: <20220917020704.25181-1-ematsumiya@suse.de>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The signature check will always fail for a response with SMB2
Status == STATUS_END_OF_FILE, so skip the verification of those.

Also, in async IO, it doesn't make sense to verify the signature
of an unsuccessful read (rdata->result != 0), as the data is
probably corrupt/inconsistent/incomplete. Verify only the responses
of successful reads.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/cifs/smb2pdu.c       | 4 ++--
 fs/cifs/smb2transport.c | 1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 6352ab32c7e7..9ae25ba909f5 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -4144,8 +4144,8 @@ smb2_readv_callback(struct mid_q_entry *mid)
 	case MID_RESPONSE_RECEIVED:
 		credits.value = le16_to_cpu(shdr->CreditRequest);
 		credits.instance = server->reconnect_instance;
-		/* result already set, check signature */
-		if (server->sign && !mid->decrypted) {
+		/* check signature only if read was successful */
+		if (server->sign && !mid->decrypted && rdata->result == 0) {
 			int rc;
 
 			rc = smb2_verify_signature(&rqst, server);
diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index 1a5fc3314dbf..37c7ed2f1984 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -668,6 +668,7 @@ smb2_verify_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 	if ((shdr->Command == SMB2_NEGOTIATE) ||
 	    (shdr->Command == SMB2_SESSION_SETUP) ||
 	    (shdr->Command == SMB2_OPLOCK_BREAK) ||
+	    (shdr->Status == STATUS_END_OF_FILE) ||
 	    server->ignore_signature ||
 	    (!server->session_estab))
 		return 0;
-- 
2.35.3

