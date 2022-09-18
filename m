Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4DA7ECAAD8
	for <linux-cifs@archiver.kernel.org>; Sun, 18 Sep 2022 23:54:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbiIRXyx (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 18 Sep 2022 19:54:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbiIRXyx (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 18 Sep 2022 19:54:53 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C31A7DE8A
        for <linux-cifs@vger.kernel.org>; Sun, 18 Sep 2022 16:54:51 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 465DD1FA4D;
        Sun, 18 Sep 2022 23:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1663545290; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=hJGXiZnc1FuIjsK//YJuWGtMFgGg7HCihDeWOTE8O48=;
        b=EOkMlhq2llb1VvRkknyqd/SSr7vBCuMg49+LEdvO0IHnoZoSoI9sp5yCOoQv5c4kiFV5Nw
        REk9z2oyQDTKnOYSIZfvkSJEsJ0Gq3Mw10Z6IOT8I/t+FRPw2F5AxLpsxiuXXe1UqGS4J+
        bETH0Jn+mCFT6Li9rNDoJDiIfoc0pSc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1663545290;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=hJGXiZnc1FuIjsK//YJuWGtMFgGg7HCihDeWOTE8O48=;
        b=4J1EY1oh6QlXCg7E45GNvllrKxr48Tt6v+uKLAgwN3MTFIcwB4WGJFEvCArLHDtj8kHq1f
        ArFHMmj6FA7EMdDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id BA33713A6B;
        Sun, 18 Sep 2022 23:54:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id XVvfHsmvJ2PmJwAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Sun, 18 Sep 2022 23:54:49 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com
Subject: [PATCH] cifs: check if mid was deleted in async read callback
Date:   Sun, 18 Sep 2022 20:54:42 -0300
Message-Id: <20220918235442.2981-1-ematsumiya@suse.de>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

There's a race when cifs_readv_receive() might dequeue the mid,
and mid->callback(), called from demultiplex thread, will try to
access it to verify the signature before the mid is actually
released/deleted.

Currently the signature verification fails, but the verification
shouldn't have happened at all because the mid was deleted because
of an error, and hence not really supposed to be passed to
->callback(). There are no further errors because the mid is
effectivelly gone by the end of the callback.

This patch checks if the mid doesn't have the MID_DELETED flag set (by
dequeue_mid()) right before trying to verify the signature. According to
my tests, trying to check it earlier, e.g. after the ->receive() call in
cifs_demultiplex_thread, will fail most of the time as dequeue_mid()
might not have been called yet.

This behaviour can be seen in xfstests generic/465, for example, where
mids with STATUS_END_OF_FILE (-ENODATA) are dequeued and supposed to be
discarded, but instead have their signature computed, but mismatched.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/cifs/cifssmb.c | 2 +-
 fs/cifs/smb2pdu.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index addf3fc62aef..116f6afe33c6 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -1308,7 +1308,7 @@ cifs_readv_callback(struct mid_q_entry *mid)
 	switch (mid->mid_state) {
 	case MID_RESPONSE_RECEIVED:
 		/* result already set, check signature */
-		if (server->sign) {
+		if (server->sign && !(mid->mid_flags & MID_DELETED)) {
 			int rc = 0;
 
 			rc = cifs_verify_signature(&rqst, server,
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 5da0b596c8a0..394996c4f729 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -4136,7 +4136,7 @@ smb2_readv_callback(struct mid_q_entry *mid)
 		credits.value = le16_to_cpu(shdr->CreditRequest);
 		credits.instance = server->reconnect_instance;
 		/* result already set, check signature */
-		if (server->sign && !mid->decrypted) {
+		if (server->sign && !mid->decrypted && !(mid->mid_flags & MID_DELETED)) {
 			int rc;
 
 			rc = smb2_verify_signature(&rqst, server);
-- 
2.35.3

