Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31DCCC433E6
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Mar 2021 12:21:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D804264FF4
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Mar 2021 12:21:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231956AbhCJMUy (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 10 Mar 2021 07:20:54 -0500
Received: from smtp2.axis.com ([195.60.68.18]:9013 "EHLO smtp2.axis.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232781AbhCJMUn (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 10 Mar 2021 07:20:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; q=dns/txt; s=axis-central1; t=1615378844;
  x=1646914844;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=HFPFW7dYxBR1uHyyA+wWF7i+lKbzCuiiUpMps7ZXBjs=;
  b=ClYcXu09LtPZsRuxysgLJr9RF5yJpkwQq8BYEB8kjJWJCZpXYRqVu5B4
   pwkROtwsY/wcsVvKRLWPcrHh5nUp4ufmbrCwPsYASvZ2h56cIL1lhWqyA
   UYVLn3v9mx9bA6uwp3BrLifo4fOTD3hCNTZhX3Osu1uv5A4wMJLoiHZOz
   vL3CoMhSf1jn2+o2fMRScHtZ7UXDVJGhKUtlV92sbrtCU9FrxPSLgwpm+
   zRtRvKCDDJggaJT2Eb6cwZe66QALAEqxS/lScBM9DVrmihoZL/XQx9Tft
   2TCF3mEHu5jAw1JPRih8xTkrS0TE0XxH2pkWU0G5Mmw4lW1uDQfz4Nfkq
   w==;
From:   Vincent Whitchurch <vincent.whitchurch@axis.com>
To:     <sfrench@samba.org>
CC:     <linux-cifs@vger.kernel.org>, <aaptel@suse.com>, <kernel@axis.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>
Subject: [PATCH] cifs: Fix preauth hash corruption
Date:   Wed, 10 Mar 2021 13:20:40 +0100
Message-ID: <20210310122040.17515-1-vincent.whitchurch@axis.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

smb311_update_preauth_hash() uses the shash in server->secmech without
appropriate locking, and this can lead to sessions corrupting each
other's preauth hashes.

The following script can easily trigger the problem:

	#!/bin/sh -e

	NMOUNTS=10
	for i in $(seq $NMOUNTS);
		mkdir -p /tmp/mnt$i
		umount /tmp/mnt$i 2>/dev/null || :
	done
	while :; do
		for i in $(seq $NMOUNTS); do
			mount -t cifs //192.168.0.1/test /tmp/mnt$i -o ... &
		done
		wait
		for i in $(seq $NMOUNTS); do
			umount /tmp/mnt$i
		done
	done

Usually within seconds this leads to one or more of the mounts failing
with the following errors, and a "Bad SMB2 signature for message" is
seen in the server logs:

 CIFS: VFS: \\192.168.0.1 failed to connect to IPC (rc=-13)
 CIFS: VFS: cifs_mount failed w/return code = -13

Fix it by holding the server mutex just like in the other places where
the shashes are used.

Fixes: 8bd68c6e47abff34e4 ("CIFS: implement v3.11 preauth integrity")
Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
---
 fs/cifs/transport.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index e90a1d1380b0..aa9c0f6bc263 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -1196,9 +1196,12 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 	/*
 	 * Compounding is never used during session establish.
 	 */
-	if ((ses->status == CifsNew) || (optype & CIFS_NEG_OP) || (optype & CIFS_SESS_OP))
+	if ((ses->status == CifsNew) || (optype & CIFS_NEG_OP) || (optype & CIFS_SESS_OP)) {
+		mutex_lock(&server->srv_mutex);
 		smb311_update_preauth_hash(ses, rqst[0].rq_iov,
 					   rqst[0].rq_nvec);
+		mutex_unlock(&server->srv_mutex);
+	}
 
 	for (i = 0; i < num_rqst; i++) {
 		rc = wait_for_response(server, midQ[i]);
@@ -1266,7 +1269,9 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 			.iov_base = resp_iov[0].iov_base,
 			.iov_len = resp_iov[0].iov_len
 		};
+		mutex_lock(&server->srv_mutex);
 		smb311_update_preauth_hash(ses, &iov, 1);
+		mutex_unlock(&server->srv_mutex);
 	}
 
 out:
-- 
2.28.0

