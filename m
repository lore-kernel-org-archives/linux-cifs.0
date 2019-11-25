Return-Path: <SRS0=nVbX=ZR=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D81FDC432C0
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Nov 2019 16:58:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B11CC2068E
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Nov 2019 16:58:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cjr.nz header.i=@cjr.nz header.b="RagMSoOx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728988AbfKYQ6g (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 25 Nov 2019 11:58:36 -0500
Received: from mx.cjr.nz ([51.158.111.142]:22718 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728902AbfKYQ6g (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 25 Nov 2019 11:58:36 -0500
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id F075180A57;
        Mon, 25 Nov 2019 16:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1574701113;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cwJx7z+bkC3/gD+ONb1P6E34ZBefqumUIraTyBEflQk=;
        b=RagMSoOxdoygDYKOHfdDWZrKvLBV/LzO9tkYiNGfDXCoutYgwVVmvsUVS9Uv+zd0bQoENO
        1GCLE4f6SxsZ5iXqQV4doDTiu6OC4c7wdnaW8WsAfUVT3lIGyVsUpRS0XIMytI8FtFENoK
        V/1fzcfsHw1wpxxfXQDrnAht2HsAYaGQ7oEwgr3Th5sQzq+apNEF6cBkIqWWy92WSoQzVe
        WZeNMDFXek7xpf0V2imIE0lhpegyVvpLTKC2uaV7CqVYO8NeFXT/P9lF6jCli6u31ZV3kp
        4gLWVfPRNw4yKzDKO+FHgmZkyfJytqn3S3nu90MJfWaOD4J7r+Cb46n8RPl0PQ==
From:   "Paulo Alcantara (SUSE)" <pc@cjr.nz>
To:     smfrench@gmail.com, aaptel@suse.com
Cc:     linux-cifs@vger.kernel.org, "Paulo Alcantara (SUSE)" <pc@cjr.nz>
Subject: [PATCH v2 3/7] cifs: Fix potential softlockups while refreshing DFS cache
Date:   Mon, 25 Nov 2019 13:57:54 -0300
Message-Id: <20191125165758.3793-4-pc@cjr.nz>
In-Reply-To: <20191125165758.3793-1-pc@cjr.nz>
References: <20191125165758.3793-1-pc@cjr.nz>
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

