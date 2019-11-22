Return-Path: <SRS0=i0zP=ZO=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EA6BC432C0
	for <linux-cifs@archiver.kernel.org>; Fri, 22 Nov 2019 15:31:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4277220715
	for <linux-cifs@archiver.kernel.org>; Fri, 22 Nov 2019 15:31:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cjr.nz header.i=@cjr.nz header.b="pNZ6U/Ik"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbfKVPbl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 22 Nov 2019 10:31:41 -0500
Received: from mx.cjr.nz ([51.158.111.142]:28400 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726046AbfKVPbk (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 22 Nov 2019 10:31:40 -0500
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id A978180A4E;
        Fri, 22 Nov 2019 15:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1574436695;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yknjX8epFUwENSsCqC2VXl6TBNeeL8Vq3yG71VEu7oA=;
        b=pNZ6U/IktmQIA1j9T+qpAKyT44R9wKm3Fz+JVJ+P5Ys3zrC7CemUhehJeZc//Ec/qN1GUj
        VJ7TfcvlixPQ+Y6XBnbVfNxpog7Yz3JZyA+U8Av1dbGHv73rq867HufOZza06MNfRZ6H4l
        1LhZa7jua/+mKM+XgfC2i75ghtj0QYjvOhPYGQOX/oZQSP1VRt2HsNw7Yo4HCOjcYS+ZYZ
        pJrh/zod4t/P7DtkWBY4VLk6zeL7pKd3tU+zgrRJokNp0rdyUdehg5XfX8eoVym7EcUNKN
        tUcZDDiKFD52EP9aC3+gXQxirefnH+FyNl7YCNJ7RZTMkgb+UfZZJfdWqX353A==
From:   "Paulo Alcantara (SUSE)" <pc@cjr.nz>
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Aurelien Aptel <aaptel@suse.com>
Subject: [PATCH 3/7] cifs: Fix potential softlockups while refreshing DFS cache
Date:   Fri, 22 Nov 2019 12:30:53 -0300
Message-Id: <20191122153057.6608-4-pc@cjr.nz>
In-Reply-To: <20191122153057.6608-1-pc@cjr.nz>
References: <20191122153057.6608-1-pc@cjr.nz>
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

