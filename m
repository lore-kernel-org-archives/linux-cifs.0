Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05AD7C04A6A
	for <linux-cifs@archiver.kernel.org>; Sun, 13 Aug 2023 16:02:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231263AbjHMQC0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 13 Aug 2023 12:02:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232311AbjHMQCB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 13 Aug 2023 12:02:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46FE6268C;
        Sun, 13 Aug 2023 09:01:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C706063369;
        Sun, 13 Aug 2023 16:00:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DE7FC433CA;
        Sun, 13 Aug 2023 16:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691942452;
        bh=hm/avD0/sLzTVxMCvL9dd5hJKmtvP3tYHyqeunc5Y+8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SEe8n5nYTjkVgDz6O5Tt87lLdmh7HwClKMYgQQk6DxEZMTzvtUrNIdJyPCdbfRbZr
         6NEoImhkuedj3V3ZkpuyXkiPNO5cfEvb/6o6h8iY/FQJV+obDvkdTPI27mK/TSR1wA
         B3R5lvOuh2/sG8YPMwBZoS20A26Mb8ArPA7OTN8ZcvLB3QMsR7F3NGdatiFHkLNWDP
         6XGJHW12CvyXx6FG35CmvQkPG1RiBrK+nANexBU8hp3ojtZj+E+UBGada7+Zj5YsFv
         f9PHzQ7RD8hxblAmuJKnMXx3req1zEcauSiFRbPXz7qRrtXE8BrRb/Gl79S6Emve8b
         Wsiyy+Lif36pA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        zdi-disclosures@trendmicro.com,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, sfrench@samba.org,
        linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 09/47] ksmbd: fix out of bounds in smb3_decrypt_req()
Date:   Sun, 13 Aug 2023 11:59:04 -0400
Message-Id: <20230813160006.1073695-9-sashal@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230813160006.1073695-1-sashal@kernel.org>
References: <20230813160006.1073695-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.45
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit dc318846f3dd54574a36ae97fc8d8b75dd7cdb1e ]

smb3_decrypt_req() validate if pdu_length is smaller than
smb2_transform_hdr size.

Reported-by: zdi-disclosures@trendmicro.com # ZDI-CAN-21589
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 26cf73d664f94..c33249393ef36 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8706,7 +8706,8 @@ int smb3_decrypt_req(struct ksmbd_work *work)
 	struct smb2_transform_hdr *tr_hdr = smb2_get_msg(buf);
 	int rc = 0;
 
-	if (buf_data_size < sizeof(struct smb2_hdr)) {
+	if (pdu_length < sizeof(struct smb2_transform_hdr) ||
+	    buf_data_size < sizeof(struct smb2_hdr)) {
 		pr_err("Transform message is too small (%u)\n",
 		       pdu_length);
 		return -ECONNABORTED;
-- 
2.40.1

