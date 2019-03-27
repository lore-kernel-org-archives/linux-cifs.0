Return-Path: <SRS0=fS5U=R6=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0327C43381
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Mar 2019 19:30:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AFAD72075C
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Mar 2019 19:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553715047;
	bh=slGkVjFL3LpAiH1xQquQ8NgUeVdDJIVdqTTaX78/7NQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=LBzIep2/a1jkmJg7Fz+pOlh4YgA81og8GB867x66HBMyop213qjhUqzM2Sqf5nBYp
	 kuJCLU8JzkvFqJ2AlX6KO+DeW/1dxj/COT63rbzc300JUyRnh82KKrGoF2owSYmS6I
	 +6BfWzJeM52sXUXHXV18bHdv6SpDPAlmoyNvNjqM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729546AbfC0Tam (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 27 Mar 2019 15:30:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:43726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732444AbfC0SD2 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 27 Mar 2019 14:03:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E7A042177E;
        Wed, 27 Mar 2019 18:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553709807;
        bh=slGkVjFL3LpAiH1xQquQ8NgUeVdDJIVdqTTaX78/7NQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dRevXqIPHPivG/l3WzusUwI9w7Lf3xBgE3UIHCT0um/MSW5St6PO6C9jwmqKeUdoE
         Mqisv9YqRZ8oCaJclqi5E7q/nLwecl/+wqcN9wv3YRO23s2DGPEe2AFofCqIJK0r7u
         OpinAlb0vyUxY6670N0JqOzM24yFH09UC90bP7A4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@gmail.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 049/262] cifs: Accept validate negotiate if server return NT_STATUS_NOT_SUPPORTED
Date:   Wed, 27 Mar 2019 13:58:24 -0400
Message-Id: <20190327180158.10245-49-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190327180158.10245-1-sashal@kernel.org>
References: <20190327180158.10245-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Namjae Jeon <linkinjeon@gmail.com>

[ Upstream commit 969ae8e8d4ee54c99134d3895f2adf96047f5bee ]

Old windows version or Netapp SMB server will return
NT_STATUS_NOT_SUPPORTED since they do not allow or implement
FSCTL_VALIDATE_NEGOTIATE_INFO. The client should accept the response
provided it's properly signed.

See
https://blogs.msdn.microsoft.com/openspecification/2012/06/28/smb3-secure-dialect-negotiation/

and

MS-SMB2 validate negotiate response processing:
https://msdn.microsoft.com/en-us/library/hh880630.aspx

Samba client had already handled it.
https://bugzilla.samba.org/attachment.cgi?id=13285&action=edit

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2pdu.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 77b3aaa39b35..4efeb2a02ea4 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -986,8 +986,14 @@ int smb3_validate_negotiate(const unsigned int xid, struct cifs_tcon *tcon)
 	rc = SMB2_ioctl(xid, tcon, NO_FILE_ID, NO_FILE_ID,
 		FSCTL_VALIDATE_NEGOTIATE_INFO, true /* is_fsctl */,
 		(char *)pneg_inbuf, inbuflen, (char **)&pneg_rsp, &rsplen);
-
-	if (rc != 0) {
+	if (rc == -EOPNOTSUPP) {
+		/*
+		 * Old Windows versions or Netapp SMB server can return
+		 * not supported error. Client should accept it.
+		 */
+		cifs_dbg(VFS, "Server does not support validate negotiate\n");
+		return 0;
+	} else if (rc != 0) {
 		cifs_dbg(VFS, "validate protocol negotiate failed: %d\n", rc);
 		rc = -EIO;
 		goto out_free_inbuf;
-- 
2.19.1

