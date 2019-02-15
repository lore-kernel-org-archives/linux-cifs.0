Return-Path: <SRS0=lRaz=QW=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C948C43381
	for <linux-cifs@archiver.kernel.org>; Fri, 15 Feb 2019 02:36:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B40321927
	for <linux-cifs@archiver.kernel.org>; Fri, 15 Feb 2019 02:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550198205;
	bh=3Ofq+yH8oR3dBcfiUcgUXePwhupmTumFtJHdVDIGK4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Uqb2FTreERxeJF51kbSrih46pfFPVpuStViYs9AyuU+lqOcaAJnwba5bjey1Gbl/5
	 apKRBpAbrLfg2PyIyqtIzzCa4+W7cITTnb7zIcShgomlegBSUf4z8kwTCSdB045IQm
	 j1gcmreln7gsU75gWyuFsW0z2d0776BvC7K33LCU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727106AbfBOCgg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 14 Feb 2019 21:36:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:50998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731925AbfBOCKw (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 14 Feb 2019 21:10:52 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2BF22222D4;
        Fri, 15 Feb 2019 02:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550196651;
        bh=3Ofq+yH8oR3dBcfiUcgUXePwhupmTumFtJHdVDIGK4A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LBacrgFskLC4fbHGk7RB3qC5pZLJIuJRnYrYiw9eKa6oFm+/UDfb3o5tbLh7C3iwH
         cG4TreYin/5QmgcKnYXvEM/Wld9/wV611+8cMDwIeyxYUR2Hejcl/3zJlBKR+zarUn
         zQ0Ff9Z345lifmG5z/vUSp5x4617mZYZVbdoOJek=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Shilovsky <pshilov@microsoft.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.20 65/77] CIFS: Do not assume one credit for async responses
Date:   Thu, 14 Feb 2019 21:08:43 -0500
Message-Id: <20190215020855.176727-65-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190215020855.176727-1-sashal@kernel.org>
References: <20190215020855.176727-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Pavel Shilovsky <pshilov@microsoft.com>

[ Upstream commit 0fd1d37b0501efc6e295f56ab55cdaff784aa50c ]

If we don't receive a response we can't assume that the server
granted one credit. Assume zero credits in such cases.

Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2pdu.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index d1ae7cdb236d..3c44c51310c4 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2834,9 +2834,10 @@ smb2_echo_callback(struct mid_q_entry *mid)
 {
 	struct TCP_Server_Info *server = mid->callback_data;
 	struct smb2_echo_rsp *rsp = (struct smb2_echo_rsp *)mid->resp_buf;
-	unsigned int credits_received = 1;
+	unsigned int credits_received = 0;
 
-	if (mid->mid_state == MID_RESPONSE_RECEIVED)
+	if (mid->mid_state == MID_RESPONSE_RECEIVED
+	    || mid->mid_state == MID_RESPONSE_MALFORMED)
 		credits_received = le16_to_cpu(rsp->sync_hdr.CreditRequest);
 
 	DeleteMidQEntry(mid);
@@ -3093,7 +3094,7 @@ smb2_readv_callback(struct mid_q_entry *mid)
 	struct TCP_Server_Info *server = tcon->ses->server;
 	struct smb2_sync_hdr *shdr =
 				(struct smb2_sync_hdr *)rdata->iov[0].iov_base;
-	unsigned int credits_received = 1;
+	unsigned int credits_received = 0;
 	struct smb_rqst rqst = { .rq_iov = rdata->iov,
 				 .rq_nvec = 2,
 				 .rq_pages = rdata->pages,
@@ -3132,6 +3133,9 @@ smb2_readv_callback(struct mid_q_entry *mid)
 		task_io_account_read(rdata->got_bytes);
 		cifs_stats_bytes_read(tcon, rdata->got_bytes);
 		break;
+	case MID_RESPONSE_MALFORMED:
+		credits_received = le16_to_cpu(shdr->CreditRequest);
+		/* fall through */
 	default:
 		if (rdata->result != -ENODATA)
 			rdata->result = -EIO;
@@ -3325,7 +3329,7 @@ smb2_writev_callback(struct mid_q_entry *mid)
 	struct cifs_tcon *tcon = tlink_tcon(wdata->cfile->tlink);
 	unsigned int written;
 	struct smb2_write_rsp *rsp = (struct smb2_write_rsp *)mid->resp_buf;
-	unsigned int credits_received = 1;
+	unsigned int credits_received = 0;
 
 	switch (mid->mid_state) {
 	case MID_RESPONSE_RECEIVED:
@@ -3353,6 +3357,9 @@ smb2_writev_callback(struct mid_q_entry *mid)
 	case MID_RETRY_NEEDED:
 		wdata->result = -EAGAIN;
 		break;
+	case MID_RESPONSE_MALFORMED:
+		credits_received = le16_to_cpu(rsp->sync_hdr.CreditRequest);
+		/* fall through */
 	default:
 		wdata->result = -EIO;
 		break;
-- 
2.19.1

