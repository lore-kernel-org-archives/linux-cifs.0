Return-Path: <SRS0=EFjq=Q6=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5134C10F0B
	for <linux-cifs@archiver.kernel.org>; Sat, 23 Feb 2019 21:16:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8CABF20651
	for <linux-cifs@archiver.kernel.org>; Sat, 23 Feb 2019 21:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550956573;
	bh=0RpTqKRgmJVh0JeZVdP9OxbVnZkgUWoIxBdEWbipMPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=p1Za/+/5jSlDKCbJuQzhOTrLjudXGMDa73WdEW0IZdfmg9F1c22e2AE2XI/BQxUQP
	 XV44gEiajGd0+98TXZvu1GSOaeAJwsXiNi5TIkKgR0FM/1wN8Qc/U3vGYJVwjoyl/H
	 Lt7R02w2FGaxROxdgpH6WBIpw0Um0WW3NiKctfy8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728357AbfBWVQG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 23 Feb 2019 16:16:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:46576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729734AbfBWVK2 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sat, 23 Feb 2019 16:10:28 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 790D220861;
        Sat, 23 Feb 2019 21:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550956228;
        bh=0RpTqKRgmJVh0JeZVdP9OxbVnZkgUWoIxBdEWbipMPE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jdbDOh8fgycaU9vsJOzrnQdjMJ8klUDn4hdAXkbN/1U8zhHT5MYov4eXYJlnuZKoQ
         jwFNp8rd8EUoJStBYUTpI46pGkDYfjPnDMAKsO4HK8ASDRQgV8IxPWVyEJjK+gV8NA
         bA1xm+/dJXgi78NtMLi5uLQRxX9aN3EaV35WjveY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 24/32] cifs: fix computation for MAX_SMB2_HDR_SIZE
Date:   Sat, 23 Feb 2019 16:09:43 -0500
Message-Id: <20190223210951.202268-24-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190223210951.202268-1-sashal@kernel.org>
References: <20190223210951.202268-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Ronnie Sahlberg <lsahlber@redhat.com>

[ Upstream commit 58d15ed1203f4d858c339ea4d7dafa94bd2a56d3 ]

The size of the fixed part of the create response is 88 bytes not 56.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2pdu.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index 1e1449ad00e89..1af7afae3ad18 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -84,8 +84,8 @@
 
 #define NUMBER_OF_SMB2_COMMANDS	0x0013
 
-/* 4 len + 52 transform hdr + 64 hdr + 56 create rsp */
-#define MAX_SMB2_HDR_SIZE 0x00b0
+/* 52 transform hdr + 64 hdr + 88 create rsp */
+#define MAX_SMB2_HDR_SIZE 204
 
 #define SMB2_PROTO_NUMBER cpu_to_le32(0x424d53fe)
 #define SMB2_TRANSFORM_PROTO_NUM cpu_to_le32(0x424d53fd)
-- 
2.19.1

