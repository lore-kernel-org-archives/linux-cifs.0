Return-Path: <SRS0=EFjq=Q6=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5417C43381
	for <linux-cifs@archiver.kernel.org>; Sat, 23 Feb 2019 21:12:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9AAAA20651
	for <linux-cifs@archiver.kernel.org>; Sat, 23 Feb 2019 21:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550956357;
	bh=jOv4A/jPJA/mTY1Lym6n/aDKIKYtTRHYDWCW8C7oIMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=oOIw9u3eQ05/zqAZ8t2+81bs3DL2oGcceOOFRVy8zgaZcG1pyOyI2sCyXjjqDdtg4
	 vVFGG7JDsiuqyVl5bgidNor8sYvHB8qA8SaiuF5lggyDWD1Wv5WaCVgSODUpacGgMU
	 Z1Bek0uHGhfdvj5xQydJqhgee8t/wuf7tFFfCSBc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730098AbfBWVL6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 23 Feb 2019 16:11:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:48664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729557AbfBWVL5 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sat, 23 Feb 2019 16:11:57 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 814522086A;
        Sat, 23 Feb 2019 21:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550956317;
        bh=jOv4A/jPJA/mTY1Lym6n/aDKIKYtTRHYDWCW8C7oIMM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KN6KNRCTSBq2Dt3iWePKngWzXVtT5u/BGi3MuFQhHYFS8Sk8iSpXtri2ccWf1aWma
         okFNqify9Cm/bK7zYVB7wY/p16RHHzmJMi19m2OczdEcTOrHNB9NsguIEPYcZunByA
         BCeWLI4ZHRQZ9q5Z+W+SZs427BrbtG8KtdhH6tM4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 3.18 14/18] cifs: fix computation for MAX_SMB2_HDR_SIZE
Date:   Sat, 23 Feb 2019 16:11:31 -0500
Message-Id: <20190223211135.203082-14-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190223211135.203082-1-sashal@kernel.org>
References: <20190223211135.203082-1-sashal@kernel.org>
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
index 05c322d9e1e74..c68c31c9fedf5 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -82,8 +82,8 @@
 
 #define NUMBER_OF_SMB2_COMMANDS	0x0013
 
-/* 4 len + 52 transform hdr + 64 hdr + 56 create rsp */
-#define MAX_SMB2_HDR_SIZE 0x00b0
+/* 52 transform hdr + 64 hdr + 88 create rsp */
+#define MAX_SMB2_HDR_SIZE 204
 
 #define SMB2_PROTO_NUMBER __constant_cpu_to_le32(0x424d53fe)
 
-- 
2.19.1

