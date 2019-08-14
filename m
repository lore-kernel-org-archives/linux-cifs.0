Return-Path: <SRS0=FUL1=WK=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 390DAC433FF
	for <linux-cifs@archiver.kernel.org>; Wed, 14 Aug 2019 02:13:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 112C32085A
	for <linux-cifs@archiver.kernel.org>; Wed, 14 Aug 2019 02:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1565748833;
	bh=6IW0LbZ1Rpn2/X1ULoBXggIeNd4mXiLEGia1aydwyCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=uiQ0tCnZl8lp+VvNR89JgxRUddjlNLZCY+rfCvHr5I7uSe+n/CIODfqiQs6Yu+IXd
	 n44oPtMJ2i1YhGxDhLPGyi9wL+5X7JNbN2hMPCkWrT0cQMa8kNc9n9mzzttD5JpKkF
	 lBUxCcHoVRya9f2c0OB033yrr9PSU9NvGQ/BxE8o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728464AbfHNCNv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 13 Aug 2019 22:13:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:45912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728456AbfHNCNv (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 13 Aug 2019 22:13:51 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90AF020842;
        Wed, 14 Aug 2019 02:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565748830;
        bh=6IW0LbZ1Rpn2/X1ULoBXggIeNd4mXiLEGia1aydwyCU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VLDiz1MhmbU1B/a29E0qHrinSTihADS5sYQGYpJ5tdsGg8MWxNNSJn5QtjvIHOEmk
         nRG+1IOe52wcprQk/E/p0iVYYTGZiuWPWvjQAXWXjJrCmHbbfv/mOMHFgIr7QZZxvK
         GNgiTcEsUiwpb77IZd0rqHTxK1SWY/BhxdXX/adY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Shilovsky <pshilov@microsoft.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 090/123] SMB3: Fix potential memory leak when processing compound chain
Date:   Tue, 13 Aug 2019 22:10:14 -0400
Message-Id: <20190814021047.14828-90-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814021047.14828-1-sashal@kernel.org>
References: <20190814021047.14828-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Pavel Shilovsky <pshilov@microsoft.com>

[ Upstream commit 3edeb4a4146dc3b54d6fa71b7ee0585cb52ebfdf ]

When a reconnect happens in the middle of processing a compound chain
the code leaks a buffer from the memory pool. Fix this by properly
checking for a return code and freeing buffers in case of error.

Also maintain a buf variable to be equal to either smallbuf or bigbuf
depending on a response buffer size while parsing a chain and when
returning to the caller.

Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2ops.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 2ec37dc589a7b..ae10d6e297c3a 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -4015,7 +4015,6 @@ receive_encrypted_standard(struct TCP_Server_Info *server,
 {
 	int ret, length;
 	char *buf = server->smallbuf;
-	char *tmpbuf;
 	struct smb2_sync_hdr *shdr;
 	unsigned int pdu_length = server->pdu_size;
 	unsigned int buf_size;
@@ -4045,18 +4044,15 @@ receive_encrypted_standard(struct TCP_Server_Info *server,
 		return length;
 
 	next_is_large = server->large_buf;
- one_more:
+one_more:
 	shdr = (struct smb2_sync_hdr *)buf;
 	if (shdr->NextCommand) {
-		if (next_is_large) {
-			tmpbuf = server->bigbuf;
+		if (next_is_large)
 			next_buffer = (char *)cifs_buf_get();
-		} else {
-			tmpbuf = server->smallbuf;
+		else
 			next_buffer = (char *)cifs_small_buf_get();
-		}
 		memcpy(next_buffer,
-		       tmpbuf + le32_to_cpu(shdr->NextCommand),
+		       buf + le32_to_cpu(shdr->NextCommand),
 		       pdu_length - le32_to_cpu(shdr->NextCommand));
 	}
 
@@ -4085,12 +4081,21 @@ receive_encrypted_standard(struct TCP_Server_Info *server,
 		pdu_length -= le32_to_cpu(shdr->NextCommand);
 		server->large_buf = next_is_large;
 		if (next_is_large)
-			server->bigbuf = next_buffer;
+			server->bigbuf = buf = next_buffer;
 		else
-			server->smallbuf = next_buffer;
-
-		buf += le32_to_cpu(shdr->NextCommand);
+			server->smallbuf = buf = next_buffer;
 		goto one_more;
+	} else if (ret != 0) {
+		/*
+		 * ret != 0 here means that we didn't get to handle_mid() thus
+		 * server->smallbuf and server->bigbuf are still valid. We need
+		 * to free next_buffer because it is not going to be used
+		 * anywhere.
+		 */
+		if (next_is_large)
+			free_rsp_buf(CIFS_LARGE_BUFFER, next_buffer);
+		else
+			free_rsp_buf(CIFS_SMALL_BUFFER, next_buffer);
 	}
 
 	return ret;
-- 
2.20.1

