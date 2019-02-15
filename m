Return-Path: <SRS0=lRaz=QW=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EAF2C10F04
	for <linux-cifs@archiver.kernel.org>; Fri, 15 Feb 2019 02:30:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F2F2120840
	for <linux-cifs@archiver.kernel.org>; Fri, 15 Feb 2019 02:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550197824;
	bh=Wb0I43kT1FzP9mnX602sQTz4Hxk0NvBFPw8oBH3QYuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=hq4lRo573Ulbzi3qQ/fje409eWH+hrx1mF1BNwud/LBT4lrijeI0UwQHOXuYSeCqv
	 1VBxTyl9AmOpxFoG8FJYdssZ/3EPhZjTp+S2p+IRmPIa/S27PdJnxmPPeyBl+mZk/z
	 1FpQ9afnKAQ93rRSiy0DtZp6zMOXHlv+E6QDZS4o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbfBOCaQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 14 Feb 2019 21:30:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:52900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391213AbfBOCMx (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 14 Feb 2019 21:12:53 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E10E21934;
        Fri, 15 Feb 2019 02:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550196773;
        bh=Wb0I43kT1FzP9mnX602sQTz4Hxk0NvBFPw8oBH3QYuM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JGHPhpE49LaxUOlUP7jZoA4Dj4oB6PnZjBakdOus0e8+B1r9o/06YN7VD7Bw2mNR7
         S+18BeWefSRMeEUeg7/yDhZEvJoBD56H11Um/Th8FRDwcr2gY0kFPE+6euRH1eu93R
         yCoojNDlvHKWfRKgWrFCHBBjRSbfc2yquQMCCxnQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Shilovsky <pshilov@microsoft.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 55/65] CIFS: Do not assume one credit for async responses
Date:   Thu, 14 Feb 2019 21:11:11 -0500
Message-Id: <20190215021121.177674-55-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190215021121.177674-1-sashal@kernel.org>
References: <20190215021121.177674-1-sashal@kernel.org>
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
index 8a01e89ff827..1e5a1171212f 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2814,9 +2814,10 @@ smb2_echo_callback(struct mid_q_entry *mid)
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
@@ -3073,7 +3074,7 @@ smb2_readv_callback(struct mid_q_entry *mid)
 	struct TCP_Server_Info *server = tcon->ses->server;
 	struct smb2_sync_hdr *shdr =
 				(struct smb2_sync_hdr *)rdata->iov[0].iov_base;
-	unsigned int credits_received = 1;
+	unsigned int credits_received = 0;
 	struct smb_rqst rqst = { .rq_iov = rdata->iov,
 				 .rq_nvec = 2,
 				 .rq_pages = rdata->pages,
@@ -3112,6 +3113,9 @@ smb2_readv_callback(struct mid_q_entry *mid)
 		task_io_account_read(rdata->got_bytes);
 		cifs_stats_bytes_read(tcon, rdata->got_bytes);
 		break;
+	case MID_RESPONSE_MALFORMED:
+		credits_received = le16_to_cpu(shdr->CreditRequest);
+		/* fall through */
 	default:
 		if (rdata->result != -ENODATA)
 			rdata->result = -EIO;
@@ -3305,7 +3309,7 @@ smb2_writev_callback(struct mid_q_entry *mid)
 	struct cifs_tcon *tcon = tlink_tcon(wdata->cfile->tlink);
 	unsigned int written;
 	struct smb2_write_rsp *rsp = (struct smb2_write_rsp *)mid->resp_buf;
-	unsigned int credits_received = 1;
+	unsigned int credits_received = 0;
 
 	switch (mid->mid_state) {
 	case MID_RESPONSE_RECEIVED:
@@ -3333,6 +3337,9 @@ smb2_writev_callback(struct mid_q_entry *mid)
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

