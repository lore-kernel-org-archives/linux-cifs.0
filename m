Return-Path: <SRS0=l6Wi=ZT=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52688C432C0
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Nov 2019 00:37:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2411520665
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Nov 2019 00:37:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cjr.nz header.i=@cjr.nz header.b="U8uCAmz9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbfK0AhP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 26 Nov 2019 19:37:15 -0500
Received: from mx.cjr.nz ([51.158.111.142]:16070 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726947AbfK0AhO (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 26 Nov 2019 19:37:14 -0500
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id E176980A21;
        Wed, 27 Nov 2019 00:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1574815032;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cwJx7z+bkC3/gD+ONb1P6E34ZBefqumUIraTyBEflQk=;
        b=U8uCAmz94aOO+s0XdNXJVFsCMmEX+RdAR/VLRVfYxeDv0zil+rEIzSX2jBmIQQV9qTDGIE
        98DPQzst39LtwWvLYwvhcCI+sBdx485tKTJfpQY54lROb6rneEJgxtBAS2QW/ovmlKQynb
        UAkN5W+uPpWr954EbnRNaQIU1dEBxvJO5atWm2k5gGbnQeVCLnC846wjoBURfxP8cG6Pm8
        CUYXZ7nK8AVfJF5H/u/fEHq1VMBMaAL4JMiXE9rvjIT6tQCd1NFVtp1aI1507r1msePd+F
        3bHvjKpUWvb0rkaIVl8EjXxWhZyYIT83nptJHyNzBEds4MgwM0gRGRjSQxreUg==
From:   "Paulo Alcantara (SUSE)" <pc@cjr.nz>
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Aurelien Aptel <aaptel@suse.com>
Subject: [PATCH v3 03/11] cifs: Fix potential softlockups while refreshing DFS cache
Date:   Tue, 26 Nov 2019 21:36:26 -0300
Message-Id: <20191127003634.14072-4-pc@cjr.nz>
In-Reply-To: <20191127003634.14072-1-pc@cjr.nz>
References: <20191127003634.14072-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

We used to skip reconnects on all SMB2_IOCTL commands due to SMB3+
FSCTL_VALIDATE_NEGOTIATE_INFO - which made sense since we're still
establishing a SMB session.

However, when refresh_cache_worker() calls smb2_get_dfs_refer() and
we're under reconnect, SMB2_ioctl() will not be able to get a proper
status error (e.g. -EHOSTDOWN in case we failed to reconnect) but an
-EAGAIN from cifs_send_recv() thus looping forever in
refresh_cache_worker().

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Suggested-by: Aurelien Aptel <aaptel@suse.com>
Fixes: e99c63e4d86d ("SMB3: Fix deadlock in validate negotiate hits reconnect")
Reviewed-by: Aurelien Aptel <aaptel@suse.com>
---
 fs/cifs/smb2pdu.c | 41 +++++++++++++++++++++++++++++------------
 1 file changed, 29 insertions(+), 12 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index c09ca6963394..3cd90088d8ac 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -252,7 +252,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon)
 	if (tcon == NULL)
 		return 0;
 
-	if (smb2_command == SMB2_TREE_CONNECT || smb2_command == SMB2_IOCTL)
+	if (smb2_command == SMB2_TREE_CONNECT)
 		return 0;
 
 	if (tcon->tidStatus == CifsExiting) {
@@ -426,16 +426,9 @@ fill_small_buf(__le16 smb2_command, struct cifs_tcon *tcon, void *buf,
  * SMB information in the SMB header. If the return code is zero, this
  * function must have filled in request_buf pointer.
  */
-static int
-smb2_plain_req_init(__le16 smb2_command, struct cifs_tcon *tcon,
-		    void **request_buf, unsigned int *total_len)
+static int __smb2_plain_req_init(__le16 smb2_command, struct cifs_tcon *tcon,
+				  void **request_buf, unsigned int *total_len)
 {
-	int rc;
-
-	rc = smb2_reconnect(smb2_command, tcon);
-	if (rc)
-		return rc;
-
 	/* BB eventually switch this to SMB2 specific small buf size */
 	if (smb2_command == SMB2_SET_INFO)
 		*request_buf = cifs_buf_get();
@@ -456,7 +449,31 @@ smb2_plain_req_init(__le16 smb2_command, struct cifs_tcon *tcon,
 		cifs_stats_inc(&tcon->num_smbs_sent);
 	}
 
-	return rc;
+	return 0;
+}
+
+static int smb2_plain_req_init(__le16 smb2_command, struct cifs_tcon *tcon,
+			       void **request_buf, unsigned int *total_len)
+{
+	int rc;
+
+	rc = smb2_reconnect(smb2_command, tcon);
+	if (rc)
+		return rc;
+
+	return __smb2_plain_req_init(smb2_command, tcon, request_buf,
+				     total_len);
+}
+
+static int smb2_ioctl_req_init(u32 opcode, struct cifs_tcon *tcon,
+			       void **request_buf, unsigned int *total_len)
+{
+	/* Skip reconnect only for FSCTL_VALIDATE_NEGOTIATE_INFO IOCTLs */
+	if (opcode == FSCTL_VALIDATE_NEGOTIATE_INFO) {
+		return __smb2_plain_req_init(SMB2_IOCTL, tcon, request_buf,
+					     total_len);
+	}
+	return smb2_plain_req_init(SMB2_IOCTL, tcon, request_buf, total_len);
 }
 
 /* For explanation of negotiate contexts see MS-SMB2 section 2.2.3.1 */
@@ -2686,7 +2703,7 @@ SMB2_ioctl_init(struct cifs_tcon *tcon, struct smb_rqst *rqst,
 	int rc;
 	char *in_data_buf;
 
-	rc = smb2_plain_req_init(SMB2_IOCTL, tcon, (void **) &req, &total_len);
+	rc = smb2_ioctl_req_init(opcode, tcon, (void **) &req, &total_len);
 	if (rc)
 		return rc;
 
-- 
2.24.0

