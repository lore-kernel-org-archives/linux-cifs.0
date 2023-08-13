Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAA25C001DE
	for <linux-cifs@archiver.kernel.org>; Sun, 13 Aug 2023 15:50:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231656AbjHMPuM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 13 Aug 2023 11:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231683AbjHMPuD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 13 Aug 2023 11:50:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21B32173B;
        Sun, 13 Aug 2023 08:49:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ABD1263189;
        Sun, 13 Aug 2023 15:49:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F8EFC43397;
        Sun, 13 Aug 2023 15:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691941797;
        bh=C17RJKjX+TL0KtPZUT4O8y3e0+4IPFuoRHU7HofuzaE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KyPvzE+UuN9af2LaxBZFzEqeHFBEZNC/Zi0m3O37HyERPU4R3No0vrtwEADoko9Ol
         4lWjI3QTmiC3x2z8qfuEAsV4+5HMw6l7cnepM9nweReqHGLnlPik7FsZL1rEq7cmej
         0IX/bS2IOewJET6lHX/PWOyEPBr0YqWTm22GHdGpxu2Fo0D6JyVYLtPeHJqcXYbIKA
         XFvkow1NH1cALwBhjyPHrWxvmKa+ejWEuPKgU1Q1LttTT4KX9qkQoxthv+uQ0YVzDb
         1ntmL75lp6QNl7FRsJ+3KGq1h0riafQjQ4rqaKsMi6JjGJIkU1B065g8XF2zljVFC7
         W6MgltzIKBTVg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        zdi-disclosures@trendmicro.com,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, sfrench@samba.org,
        linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 6.4 13/54] ksmbd: no response from compound read
Date:   Sun, 13 Aug 2023 11:48:52 -0400
Message-Id: <20230813154934.1067569-13-sashal@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230813154934.1067569-1-sashal@kernel.org>
References: <20230813154934.1067569-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.4.10
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit e202a1e8634b186da38cbbff85382ea2b9e297cf ]

ksmbd doesn't support compound read. If client send read-read in
compound to ksmbd, there can be memory leak from read buffer.
Windows and linux clients doesn't send it to server yet. For now,
No response from compound read. compound read will be supported soon.

Reported-by: zdi-disclosures@trendmicro.com # ZDI-CAN-21587, ZDI-CAN-21588
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index f4421d4bff0f8..a10478fb78c88 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -6211,6 +6211,11 @@ int smb2_read(struct ksmbd_work *work)
 	unsigned int max_read_size = conn->vals->max_read_size;
 
 	WORK_BUFFERS(work, req, rsp);
+	if (work->next_smb2_rcv_hdr_off) {
+		work->send_no_response = 1;
+		err = -EOPNOTSUPP;
+		goto out;
+	}
 
 	if (test_share_config_flag(work->tcon->share_conf,
 				   KSMBD_SHARE_FLAG_PIPE)) {
-- 
2.40.1

