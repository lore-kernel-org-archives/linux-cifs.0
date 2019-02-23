Return-Path: <SRS0=EFjq=Q6=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1D76C43381
	for <linux-cifs@archiver.kernel.org>; Sat, 23 Feb 2019 21:19:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8109B205C9
	for <linux-cifs@archiver.kernel.org>; Sat, 23 Feb 2019 21:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550956756;
	bh=tK/c9XNB7dyw5U4oD/9OpsHySHhRH+qDAbKob+NkCpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=qUV/RsVIiDDjDWVuRYsdnLy9hwTkbuD0Q/4YykPlK+r3S2MbwgaxffzX9f+K1K0mh
	 KXPtl1WQz6vkwvm9s7A3s0RwOclL62UGaEZDaNuBKkIcZmAZXmxoazmX7U6LeV5Xze
	 vHKSyo7PWnNMl/XS29Vt1tGu9gB1WSR1XSDsSe3g=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729188AbfBWVTH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 23 Feb 2019 16:19:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:45078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729191AbfBWVJ1 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sat, 23 Feb 2019 16:09:27 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B6582085A;
        Sat, 23 Feb 2019 21:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550956166;
        bh=tK/c9XNB7dyw5U4oD/9OpsHySHhRH+qDAbKob+NkCpc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iXK1NMILMwQbjKQZgFO3M0fhXUGo3nQ+Hq3hnwwEUAlFnGELSC1BlQ4qQl3kw/x2P
         LaGYLKWzm5o46kl9lAbSmA3HgLdQLXrqYyhsNtJvMMe0NTfkMb1BYB4cWUKt19CCTX
         HqJHCo+/Jvj0/yl2fsqm3uCfx5wTQW9a9BSwTnrQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 33/45] cifs: fix computation for MAX_SMB2_HDR_SIZE
Date:   Sat, 23 Feb 2019 16:08:23 -0500
Message-Id: <20190223210835.201708-33-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190223210835.201708-1-sashal@kernel.org>
References: <20190223210835.201708-1-sashal@kernel.org>
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
index e524540597256..bad458a2b579e 100644
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

