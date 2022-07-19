Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56872C433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 19 Jul 2022 17:32:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239193AbiGSRcl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 19 Jul 2022 13:32:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239577AbiGSRcl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 19 Jul 2022 13:32:41 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0300952FDB
        for <linux-cifs@vger.kernel.org>; Tue, 19 Jul 2022 10:32:39 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id AB50C33CC1;
        Tue, 19 Jul 2022 17:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1658251958; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B2SjL3KngPWs7p6BTaVn5p/bmNrCNaMqn0wpUwBUPtU=;
        b=r0Pp+bGop2X4oDUhdA9sZhP5Cocg69mC5JaoOvK6CDx/vqu+DE07YahuzdzmgChxaodRnG
        Ak2nW10kSOvpoIOqVLR2zFKHbcU5CPCzujvttBZfrA/mcLtHs3LY08mPzQ4L0J8kJXcNlz
        9KRN6PwG3QaOTQ+ozBpmiKSvhC5zPSY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1658251958;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B2SjL3KngPWs7p6BTaVn5p/bmNrCNaMqn0wpUwBUPtU=;
        b=rJ8ZourkeEzMN/N9UC1QGBw5PDApqRQrCIwdklQFaBkCMezbQhCDeRSIG0jbWfp6TKLZwX
        QmG2+eKlbB78pBBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2B3BF13488;
        Tue, 19 Jul 2022 17:32:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id JlwmN7Xq1mJLQwAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Tue, 19 Jul 2022 17:32:37 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com, Enzo Matsumiya <ematsumiya@suse.de>
Subject: [PATCH] smb2: small refactor in smb2_check_message()
Date:   Tue, 19 Jul 2022 14:31:51 -0300
Message-Id: <20220719173151.12068-2-ematsumiya@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220719173151.12068-1-ematsumiya@suse.de>
References: <20220719173151.12068-1-ematsumiya@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

If the command is SMB2_IOCTL, OutputLength and OutputContext are
optional and can be zero, so return early and skip calculated length
check.

Move the mismatched length message to the end of the check, to avoid
unnecessary logs when the check was not a real miscalculation.

Also change the pr_warn_once() to a pr_warn() so we're sure to get a
log for the real mismatches.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/cifs/connect.c  | 13 ++++++-------
 fs/cifs/smb2misc.c | 47 +++++++++++++++++++++++++++-------------------
 2 files changed, 34 insertions(+), 26 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 386bb523c69e..057237c9cb30 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1039,19 +1039,18 @@ int
 cifs_handle_standard(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 {
 	char *buf = server->large_buf ? server->bigbuf : server->smallbuf;
-	int length;
+	int rc;
 
 	/*
 	 * We know that we received enough to get to the MID as we
 	 * checked the pdu_length earlier. Now check to see
-	 * if the rest of the header is OK. We borrow the length
-	 * var for the rest of the loop to avoid a new stack var.
+	 * if the rest of the header is OK.
 	 *
 	 * 48 bytes is enough to display the header and a little bit
 	 * into the payload for debugging purposes.
 	 */
-	length = server->ops->check_message(buf, server->total_read, server);
-	if (length != 0)
+	rc = server->ops->check_message(buf, server->total_read, server);
+	if (rc)
 		cifs_dump_mem("Bad SMB: ", buf,
 			min_t(unsigned int, server->total_read, 48));
 
@@ -1066,9 +1065,9 @@ cifs_handle_standard(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 		return -1;
 
 	if (!mid)
-		return length;
+		return rc;
 
-	handle_mid(mid, server, buf, length);
+	handle_mid(mid, server, buf, rc);
 	return 0;
 }
 
diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index 17813c3d0c6e..562064fe9668 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -132,15 +132,15 @@ static __u32 get_neg_ctxt_len(struct smb2_hdr *hdr, __u32 len,
 }
 
 int
-smb2_check_message(char *buf, unsigned int len, struct TCP_Server_Info *srvr)
+smb2_check_message(char *buf, unsigned int len, struct TCP_Server_Info *server)
 {
 	struct smb2_hdr *shdr = (struct smb2_hdr *)buf;
 	struct smb2_pdu *pdu = (struct smb2_pdu *)shdr;
-	__u64 mid;
-	__u32 clc_len;  /* calculated length */
-	int command;
-	int pdu_size = sizeof(struct smb2_pdu);
 	int hdr_size = sizeof(struct smb2_hdr);
+	int pdu_size = sizeof(struct smb2_pdu);
+	int command;
+	__u32 calc_len; /* calculated length */
+	__u64 mid;
 
 	/*
 	 * Add function to do table lookup of StructureSize by command
@@ -154,7 +154,7 @@ smb2_check_message(char *buf, unsigned int len, struct TCP_Server_Info *srvr)
 
 		/* decrypt frame now that it is completely read in */
 		spin_lock(&cifs_tcp_ses_lock);
-		list_for_each_entry(iter, &srvr->smb_ses_list, smb_ses_list) {
+		list_for_each_entry(iter, &server->smb_ses_list, smb_ses_list) {
 			if (iter->Suid == le64_to_cpu(thdr->SessionId)) {
 				ses = iter;
 				break;
@@ -221,30 +221,33 @@ smb2_check_message(char *buf, unsigned int len, struct TCP_Server_Info *srvr)
 		}
 	}
 
-	clc_len = smb2_calc_size(buf, srvr);
+	calc_len = smb2_calc_size(buf, server);
+
+	/* For SMB2_IOCTL, OutputOffset and OutputLength are optional, so might
+	 * be 0, and not a real miscalculation */
+	if (command == SMB2_IOCTL_HE && calc_len == 0)
+		return 0;
 
-	if (shdr->Command == SMB2_NEGOTIATE)
-		clc_len += get_neg_ctxt_len(shdr, len, clc_len);
+	if (command == SMB2_NEGOTIATE_HE)
+		calc_len += get_neg_ctxt_len(shdr, len, calc_len);
 
-	if (len != clc_len) {
-		cifs_dbg(FYI, "Calculated size %u length %u mismatch mid %llu\n",
-			 clc_len, len, mid);
+	if (len != calc_len) {
 		/* create failed on symlink */
 		if (command == SMB2_CREATE_HE &&
 		    shdr->Status == STATUS_STOPPED_ON_SYMLINK)
 			return 0;
 		/* Windows 7 server returns 24 bytes more */
-		if (clc_len + 24 == len && command == SMB2_OPLOCK_BREAK_HE)
+		if (calc_len + 24 == len && command == SMB2_OPLOCK_BREAK_HE)
 			return 0;
 		/* server can return one byte more due to implied bcc[0] */
-		if (clc_len == len + 1)
+		if (calc_len == len + 1)
 			return 0;
 
 		/*
 		 * Some windows servers (win2016) will pad also the final
 		 * PDU in a compound to 8 bytes.
 		 */
-		if (((clc_len + 7) & ~7) == len)
+		if (((calc_len + 7) & ~7) == len)
 			return 0;
 
 		/*
@@ -253,12 +256,18 @@ smb2_check_message(char *buf, unsigned int len, struct TCP_Server_Info *srvr)
 		 * SMB2/SMB3 frame length (header + smb2 response specific data)
 		 * Some windows servers also pad up to 8 bytes when compounding.
 		 */
-		if (clc_len < len)
+		if (calc_len < len)
 			return 0;
 
-		pr_warn_once(
-			"srv rsp too short, len %d not %d. cmd:%d mid:%llu\n",
-			len, clc_len, command, mid);
+		/* Only log a message if len was really miscalculated */
+		if (unlikely(cifsFYI))
+			cifs_dbg(FYI, "Server response too short: calculated "
+				 "length %u doesn't match read length %u (cmd=%d, mid=%llu)\n",
+				 calc_len, len, command, mid);
+		else
+			pr_warn("Server response too short: calculated length "
+				"%u doesn't match read length %u (cmd=%d, mid=%llu)\n",
+				calc_len, len, command, mid);
 
 		return 1;
 	}
-- 
2.35.3

