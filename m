Return-Path: <SRS0=FUL1=WK=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A945C32750
	for <linux-cifs@archiver.kernel.org>; Wed, 14 Aug 2019 02:30:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD25620679
	for <linux-cifs@archiver.kernel.org>; Wed, 14 Aug 2019 02:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1565749816;
	bh=E+XwmjQVxHruMvGF0Jc53PukRwBG5+BMPyTR7bUQ6n8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=k9zum/JNnwBJ+siQ49F5tfbIYHQT/FTsSU3hm7zHNXZuFccuyYHiivqZl7WCPvk7h
	 3c8HRg7yAZXiCOnscQM164byigzaT7rEJBJZKbkEeLFfxFFI3TSJXrr6fFSrkGjB1F
	 0/z2gxec3/FxCNHS5EdiRN2vqqmdTg9X25BOBdF4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729311AbfHNCRK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 13 Aug 2019 22:17:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:48482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728816AbfHNCRK (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 13 Aug 2019 22:17:10 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC49B2085A;
        Wed, 14 Aug 2019 02:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565749029;
        bh=E+XwmjQVxHruMvGF0Jc53PukRwBG5+BMPyTR7bUQ6n8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pYClcZRvEcsIDeVA2eorDsjnIxemq1+L2xnpQt9Rz1YM4RLzF4ITYn0JuK20qY/dD
         Zh5DitpYDOGhlPHxXeVvtXA5T2mA2HQwQ5FxbKqi9Q2nWm7nwzvbqLd4MeebSqFGcC
         xzDqcstroTiXOLYmKJf4zK0WWTlNPWeLNNi6Tn5A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sebastien Tisserant <stisserant@wallix.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 47/68] SMB3: Kernel oops mounting a encryptData share with CONFIG_DEBUG_VIRTUAL
Date:   Tue, 13 Aug 2019 22:15:25 -0400
Message-Id: <20190814021548.16001-47-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814021548.16001-1-sashal@kernel.org>
References: <20190814021548.16001-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Sebastien Tisserant <stisserant@wallix.com>

[ Upstream commit ee9d66182392695535cc9fccfcb40c16f72de2a9 ]

Fix kernel oops when mounting a encryptData CIFS share with
CONFIG_DEBUG_VIRTUAL

Signed-off-by: Sebastien Tisserant <stisserant@wallix.com>
Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2ops.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 97fdbec54db97..cc9e846a38658 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -2545,7 +2545,15 @@ fill_transform_hdr(struct smb2_transform_hdr *tr_hdr, unsigned int orig_len,
 static inline void smb2_sg_set_buf(struct scatterlist *sg, const void *buf,
 				   unsigned int buflen)
 {
-	sg_set_page(sg, virt_to_page(buf), buflen, offset_in_page(buf));
+	void *addr;
+	/*
+	 * VMAP_STACK (at least) puts stack into the vmalloc address space
+	 */
+	if (is_vmalloc_addr(buf))
+		addr = vmalloc_to_page(buf);
+	else
+		addr = virt_to_page(buf);
+	sg_set_page(sg, addr, buflen, offset_in_page(buf));
 }
 
 /* Assumes the first rqst has a transform header as the first iov.
-- 
2.20.1

