Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 697B5EB64DC
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Jun 2023 08:59:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbjF2I7m (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 29 Jun 2023 04:59:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjF2I7k (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 29 Jun 2023 04:59:40 -0400
Received: from smtpbgsg2.qq.com (smtpbgsg2.qq.com [54.254.200.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79BCCE4B
        for <linux-cifs@vger.kernel.org>; Thu, 29 Jun 2023 01:59:38 -0700 (PDT)
X-QQ-mid: bizesmtp71t1688029170t5li198q
Received: from localhost.localdomain ( [113.57.152.160])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Thu, 29 Jun 2023 16:59:29 +0800 (CST)
X-QQ-SSF: 01400000000000F0H000000A0000000
X-QQ-FEAT: zT6n3Y95oi1aCGkfXogeSa7YQtC2lUYv1KYRnqbdWTTG6yl+PB/9g2NexvJBB
        A6dEwSWHOEZolVS+rqLhwCZeN+kaTInUnlCWTivYT5nlKIv7Pl/eyfo7goCPPC9lj6HBzxo
        okBGgzrPkjivzfwJuJamFYCxuBQkDMtuNLMQwzZeyFQG7cnGYaA8xNhcFycekjzJbRLUow6
        eKaId0oH/3WF3Pji+TjRhgG/yZqciknBc3G29Yy9NyRWy2t5k8Gyv3eWNFvlXRTFG0U7V+l
        jLZI1C/5xEmbDKskOyoNQ1OZWZtOQW+5xW5DGZjqPtlLQmrVhhPbDMYA3Sn93JaM01VFAzM
        VjC8dktLYhOn2/DEl0Dx210+soN6+I/b83tb9/sURvUMxfXxor+jCUxk4viNKcNX5TFdMvn
        ClCOgLDhkNM=
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 8565504980206895837
From:   Winston Wen <wentao@uniontech.com>
To:     smfrench@gmail.com, linux-cifs@vger.kernel.org, pc@manguebit.com,
        nspmangalore@gmail.com
Cc:     Winston Wen <wentao@uniontech.com>
Subject: [PATCH 1/3] cifs: fix credit leaks in async callback
Date:   Thu, 29 Jun 2023 16:58:56 +0800
Message-Id: <20230629085858.2834937-1-wentao@uniontech.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:uniontech.com:qybglogicsvrgz:qybglogicsvrgz6a-1
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Initialize credits.value to 1, which will be passed to add_credits() if
mid->mid_state is not MID_RESPONSE_RECEIVED or MID_RESPONSE_MALFORMED.

Signed-off-by: Winston Wen <wentao@uniontech.com>
---
 fs/smb/client/smb2pdu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index e04766fe6f80..4c71979fca6d 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -3760,7 +3760,7 @@ smb2_echo_callback(struct mid_q_entry *mid)
 {
 	struct TCP_Server_Info *server = mid->callback_data;
 	struct smb2_echo_rsp *rsp = (struct smb2_echo_rsp *)mid->resp_buf;
-	struct cifs_credits credits = { .value = 0, .instance = 0 };
+	struct cifs_credits credits = { .value = 1, .instance = 0 };
 
 	if (mid->mid_state == MID_RESPONSE_RECEIVED
 	    || mid->mid_state == MID_RESPONSE_MALFORMED) {
@@ -4150,7 +4150,7 @@ smb2_readv_callback(struct mid_q_entry *mid)
 	struct TCP_Server_Info *server = rdata->server;
 	struct smb2_hdr *shdr =
 				(struct smb2_hdr *)rdata->iov[0].iov_base;
-	struct cifs_credits credits = { .value = 0, .instance = 0 };
+	struct cifs_credits credits = { .value = 1, .instance = 0 };
 	struct smb_rqst rqst = { .rq_iov = &rdata->iov[1], .rq_nvec = 1 };
 
 	if (rdata->got_bytes) {
@@ -4402,7 +4402,7 @@ smb2_writev_callback(struct mid_q_entry *mid)
 	struct TCP_Server_Info *server = wdata->server;
 	unsigned int written;
 	struct smb2_write_rsp *rsp = (struct smb2_write_rsp *)mid->resp_buf;
-	struct cifs_credits credits = { .value = 0, .instance = 0 };
+	struct cifs_credits credits = { .value = 1, .instance = 0 };
 
 	WARN_ONCE(wdata->server != mid->server,
 		  "wdata server %p != mid server %p",
-- 
2.40.1

