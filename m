Return-Path: <SRS0=EFjq=Q6=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9705BC4360F
	for <linux-cifs@archiver.kernel.org>; Sat, 23 Feb 2019 21:23:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D25320651
	for <linux-cifs@archiver.kernel.org>; Sat, 23 Feb 2019 21:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550957021;
	bh=A0UKc2ZGWAth2d+21AzkXptWPAlV+ToNfIfMlt/wiqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Sp18ucxahIZTXDawFr5g4pPA6YJUoydfqK0+i8a9GfSzmnI2whCRNSbeWLIaN8Sng
	 s/YgG73mFo3gS27E6VpIEPWojX8/jQDIgiRhGvWQbgzIWUn1S98DTLT9y0iwGYhWW2
	 TAely/V15YvwSEl2v4CE2fE7O9CyH4jNRcRvKXoc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729206AbfBWVXa (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 23 Feb 2019 16:23:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:43348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728579AbfBWVIE (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sat, 23 Feb 2019 16:08:04 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4C0820855;
        Sat, 23 Feb 2019 21:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550956083;
        bh=A0UKc2ZGWAth2d+21AzkXptWPAlV+ToNfIfMlt/wiqk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TBWDWJRy2r9qkzn8dMbyom4Ivnv+kCfcBZedc/yAnOQqQHSXR7kLPayBj2KWD1zy2
         pEtjczreoRHzQyZNRNtEwlhfiG7xYK81j5sQQgwsr3h5a9vBPVJ7Uv0jl5ban48gb3
         zJDUTw1RlCsO7zbRDUtcSmDULhAxK8lWP51mWGsc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 52/65] cifs: fix computation for MAX_SMB2_HDR_SIZE
Date:   Sat, 23 Feb 2019 16:06:27 -0500
Message-Id: <20190223210640.200911-52-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190223210640.200911-1-sashal@kernel.org>
References: <20190223210640.200911-1-sashal@kernel.org>
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
index 8fb7887f2b3d9..437257d1116f0 100644
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

