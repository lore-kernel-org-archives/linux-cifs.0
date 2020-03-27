Return-Path: <SRS0=a8IY=5M=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8B63C43331
	for <linux-cifs@archiver.kernel.org>; Fri, 27 Mar 2020 02:42:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 94B0C20714
	for <linux-cifs@archiver.kernel.org>; Fri, 27 Mar 2020 02:42:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxonhyperv.com header.i=@linuxonhyperv.com header.b="YFR8QAmQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbgC0Cm2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 26 Mar 2020 22:42:28 -0400
Received: from linux.microsoft.com ([13.77.154.182]:34314 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726363AbgC0Cm2 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 26 Mar 2020 22:42:28 -0400
Received: by linux.microsoft.com (Postfix, from userid 1004)
        id 976F620B4737; Thu, 26 Mar 2020 19:42:26 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 976F620B4737
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxonhyperv.com;
        s=default; t=1585276946;
        bh=zvffKctMIj2SFnhEj55/AzFnvDRhG2tE5Rzn8kutAEA=;
        h=From:To:Cc:Subject:Date:Reply-To:From;
        b=YFR8QAmQvBbsrDSG95KLNjrojPASe8E68C6aEhrFpr5LuqKVUydN5R2l2eOiec2Cj
         Y0DYwIzY/RBeF+ZnB3GcRdJ+LMBZrGnb+du5p2PbI75az+UcDBVBP5EXLQLlmXx/St
         t5YV8EFSnXPjlvLYgH0zYjOtGYpWIc2NEgzgvbIU=
From:   longli@linuxonhyperv.com
To:     Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Cc:     Long Li <longli@microsoft.com>
Subject: [Patch v2] cifs: smbd: Calculate the correct maximum packet size for segmented SMBDirect send/receive
Date:   Thu, 26 Mar 2020 19:42:24 -0700
Message-Id: <1585276944-5332-1-git-send-email-longli@linuxonhyperv.com>
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

Change since v1: defined SMB2_READWRITE_PDU_HEADER_SIZE for header size and corrected miscalculation

 fs/cifs/smb2ops.c   | 38 ++++++++++++++++----------------------
 fs/cifs/smb2pdu.h   |  3 +++
 fs/cifs/smbdirect.c |  3 +--
 3 files changed, 20 insertions(+), 24 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 9c9258fc8756..b36c46f48705 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -328,16 +328,6 @@ smb2_negotiate_wsize(struct cifs_tcon *tcon, struct smb_vol *volume_info)
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
 
@@ -356,8 +346,15 @@ smb3_negotiate_wsize(struct cifs_tcon *tcon, struct smb_vol *volume_info)
 #ifdef CONFIG_CIFS_SMB_DIRECT
 	if (server->rdma) {
 		if (server->sign)
+			/*
+			 * Account for SMB2 data transfer packet header and
+			 * possible encryption header
+			 */
 			wsize = min_t(unsigned int,
-				wsize, server->smbd_conn->max_fragmented_send_size);
+				wsize,
+				server->smbd_conn->max_fragmented_send_size -
+					SMB2_READWRITE_PDU_HEADER_SIZE -
+					sizeof(struct smb2_transform_hdr));
 		else
 			wsize = min_t(unsigned int,
 				wsize, server->smbd_conn->max_readwrite_size);
@@ -378,16 +375,6 @@ smb2_negotiate_rsize(struct cifs_tcon *tcon, struct smb_vol *volume_info)
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
@@ -407,8 +394,15 @@ smb3_negotiate_rsize(struct cifs_tcon *tcon, struct smb_vol *volume_info)
 #ifdef CONFIG_CIFS_SMB_DIRECT
 	if (server->rdma) {
 		if (server->sign)
+			/*
+			 * Account for SMB2 data transfer packet header and
+			 * possible encryption header
+			 */
 			rsize = min_t(unsigned int,
-				rsize, server->smbd_conn->max_fragmented_recv_size);
+				rsize,
+				server->smbd_conn->max_fragmented_recv_size -
+					SMB2_READWRITE_PDU_HEADER_SIZE -
+					sizeof(struct smb2_transform_hdr));
 		else
 			rsize = min_t(unsigned int,
 				rsize, server->smbd_conn->max_readwrite_size);
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index dda928d05c13..10acf90f858d 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -120,6 +120,9 @@ struct smb2_sync_hdr {
 	__u8   Signature[16];
 } __packed;
 
+/* The total header size for SMB2 read and write */
+#define SMB2_READWRITE_PDU_HEADER_SIZE (48 + sizeof(struct smb2_sync_hdr))
+
 struct smb2_sync_pdu {
 	struct smb2_sync_hdr sync_hdr;
 	__le16 StructureSize2; /* size of wct area (varies, request specific) */
diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index 5b1b97e9e0c9..a6ae29b3c4e7 100644
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

