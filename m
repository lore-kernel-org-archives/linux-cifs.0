Return-Path: <SRS0=HB3D=5K=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5E9FC2D0E5
	for <linux-cifs@archiver.kernel.org>; Wed, 25 Mar 2020 19:30:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A3E920740
	for <linux-cifs@archiver.kernel.org>; Wed, 25 Mar 2020 19:30:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxonhyperv.com header.i=@linuxonhyperv.com header.b="OwgWT/j+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727351AbgCYTa0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 25 Mar 2020 15:30:26 -0400
Received: from linux.microsoft.com ([13.77.154.182]:46716 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727328AbgCYTaZ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 25 Mar 2020 15:30:25 -0400
Received: by linux.microsoft.com (Postfix, from userid 1004)
        id 5956420B4737; Wed, 25 Mar 2020 12:30:24 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5956420B4737
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxonhyperv.com;
        s=default; t=1585164624;
        bh=JTOKPle64Y3CcsUT3NLGdNuqHsoqlanFLCnXhn2nAO4=;
        h=From:To:Cc:Subject:Date:Reply-To:From;
        b=OwgWT/j+a88JSBxb/rt6FAeu2wCIayAMGUkyBZpi9tL2y59B4zn9Ww3JWvkaXXwlw
         s9qozR0xVpfeefTYvoG9n2GqKFlVRR+RWEScgsSI1DPpx145t6RsVf3u4F98yVGgvl
         n84cMyFzRyiKXNcrAPwAUUdKscIX0FhV5mO1jx2Q=
From:   longli@linuxonhyperv.com
To:     Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Cc:     Long Li <longli@microsoft.com>
Subject: [PATCH] cifs: smbd: Calculate the correct maximum packet size for segmented SMBDirect send/receive
Date:   Wed, 25 Mar 2020 12:30:14 -0700
Message-Id: <1585164614-123696-1-git-send-email-longli@linuxonhyperv.com>
X-Mailer: git-send-email 1.8.3.1
Reply-To: longli@microsoft.com
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Long Li <longli@microsoft.com>

The packet size needs to take account of SMB2 header size and possible
encryption header size. This is only done when signing is used and it is for
RDMA send/receive, not read/write.

Also remove the dead SMBD code in smb2_negotiate_r(w)size.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/smb2ops.c   | 38 ++++++++++++++++----------------------
 fs/cifs/smbdirect.c |  3 +--
 2 files changed, 17 insertions(+), 24 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 4c0922596467..9043d34eef43 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -332,16 +332,6 @@ smb2_negotiate_wsize(struct cifs_tcon *tcon, struct smb_vol *volume_info)
 	/* start with specified wsize, or default */
 	wsize = volume_info->wsize ? volume_info->wsize : CIFS_DEFAULT_IOSIZE;
 	wsize = min_t(unsigned int, wsize, server->max_write);
-#ifdef CONFIG_CIFS_SMB_DIRECT
-	if (server->rdma) {
-		if (server->sign)
-			wsize = min_t(unsigned int,
-				wsize, server->smbd_conn->max_fragmented_send_size);
-		else
-			wsize = min_t(unsigned int,
-				wsize, server->smbd_conn->max_readwrite_size);
-	}
-#endif
 	if (!(server->capabilities & SMB2_GLOBAL_CAP_LARGE_MTU))
 		wsize = min_t(unsigned int, wsize, SMB2_MAX_BUFFER_SIZE);
 
@@ -360,8 +350,15 @@ smb3_negotiate_wsize(struct cifs_tcon *tcon, struct smb_vol *volume_info)
 #ifdef CONFIG_CIFS_SMB_DIRECT
 	if (server->rdma) {
 		if (server->sign)
+			/*
+			 * Account for SMB2 data transfer packet header
+			 * SMB2_READ/SMB2_WRITE (49) and possible encryption
+			 * headers
+			 */
 			wsize = min_t(unsigned int,
-				wsize, server->smbd_conn->max_fragmented_send_size);
+				wsize,
+				server->smbd_conn->max_fragmented_send_size -
+					49 - sizeof(struct smb2_transform_hdr));
 		else
 			wsize = min_t(unsigned int,
 				wsize, server->smbd_conn->max_readwrite_size);
@@ -382,16 +379,6 @@ smb2_negotiate_rsize(struct cifs_tcon *tcon, struct smb_vol *volume_info)
 	/* start with specified rsize, or default */
 	rsize = volume_info->rsize ? volume_info->rsize : CIFS_DEFAULT_IOSIZE;
 	rsize = min_t(unsigned int, rsize, server->max_read);
-#ifdef CONFIG_CIFS_SMB_DIRECT
-	if (server->rdma) {
-		if (server->sign)
-			rsize = min_t(unsigned int,
-				rsize, server->smbd_conn->max_fragmented_recv_size);
-		else
-			rsize = min_t(unsigned int,
-				rsize, server->smbd_conn->max_readwrite_size);
-	}
-#endif
 
 	if (!(server->capabilities & SMB2_GLOBAL_CAP_LARGE_MTU))
 		rsize = min_t(unsigned int, rsize, SMB2_MAX_BUFFER_SIZE);
@@ -411,8 +398,15 @@ smb3_negotiate_rsize(struct cifs_tcon *tcon, struct smb_vol *volume_info)
 #ifdef CONFIG_CIFS_SMB_DIRECT
 	if (server->rdma) {
 		if (server->sign)
+			/*
+			 * Account for SMB2 data transfer packet header
+			 * SMB2_READ/SMB2_WRITE (49) and possible encryption
+			 * headers
+			 */
 			rsize = min_t(unsigned int,
-				rsize, server->smbd_conn->max_fragmented_recv_size);
+				rsize,
+				server->smbd_conn->max_fragmented_recv_size -
+					49 - sizeof(struct smb2_transform_hdr));
 		else
 			rsize = min_t(unsigned int,
 				rsize, server->smbd_conn->max_readwrite_size);
diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index eb1e40af9f3a..0327b575ab87 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -2097,8 +2097,7 @@ int smbd_send(struct TCP_Server_Info *server,
 	for (i = 0; i < num_rqst; i++)
 		remaining_data_length += smb_rqst_len(server, &rqst_array[i]);
 
-	if (remaining_data_length + sizeof(struct smbd_data_transfer) >
-		info->max_fragmented_send_size) {
+	if (remaining_data_length > info->max_fragmented_send_size) {
 		log_write(ERR, "payload size %d > max size %d\n",
 			remaining_data_length, info->max_fragmented_send_size);
 		rc = -EINVAL;
-- 
2.17.1

