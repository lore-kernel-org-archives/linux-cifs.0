Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 323B0C61DA4
	for <linux-cifs@archiver.kernel.org>; Wed, 15 Mar 2023 13:05:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231946AbjCONFu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 15 Mar 2023 09:05:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231867AbjCONFu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 15 Mar 2023 09:05:50 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 561EB57093
        for <linux-cifs@vger.kernel.org>; Wed, 15 Mar 2023 06:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=Dd+2o/QhkHPQAqLt1EVZgly77SVHKDmhY2Sv6Tn4gGI=; b=o71KNyF6WpckjFOCOWjRWdkaXN
        8gdnz115MRTfanXYdOBfw/wFTmL5PCTKOWaWHfH2BBU87BCDQUrRs/JvK3KzAgH1Nereh2PnEOMV7
        qKdxeLHW+mX4X54HkGJbmkJ5rOmkeExqRjXgoMF5Nj2KjhAEUgeL4XOjHEhH3HM7X7YtHoqyKejJx
        W828XFBAXX1kiA1hUYYgerPI9jlgvvUbaVzI5Y/OPs1VqqT66V1oJAL9uKq7FOlgC5W6nVnsGIFVW
        EIPmQBkr5Y32Ce+ChXnvhwdAHrdNTU85z7FcOpGVAlnF6Lwp1EIrOd+5oHrBGJoQQZsZGItBPCIss
        Ly1Fd6afCgbePwEcHx66iAinCG47+ZLkA/phhBI4u4joApkNzCHVmVs0N9O91vpyhTL5Js3+KQtw6
        rqNMQb1UMPQUK7LG+RMUNQuoLKxO4SQq7idaUgkI3PFIMenZboIFkJxpmCa/1cjN5fxsuLaMVobmK
        0xxdWWxdiD++IdTpduTqRELN;
Received: from [2a01:4f8:252:410e::177:224] (port=40716 helo=atb-devel-224..) 
        by hr2.samba.org with esmtp (Exim)
        id 1pcQp6-003KNd-CI; Wed, 15 Mar 2023 13:05:44 +0000
From:   Volker Lendecke <vl@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Volker Lendecke <vl@samba.org>
Subject: [PATCH 02/10] cifs: Make "resp_buf_type" initialization consistent
Date:   Wed, 15 Mar 2023 13:05:23 +0000
Message-Id: <715459412f19853c56156b8c0ce39fe74f148860.1678885349.git.vl@samba.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1678885349.git.vl@samba.org>
References: <cover.1678885349.git.vl@samba.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The majority of cifs_send_recv() do not initialize resp_buf_type, make
this consistent in all callers. Probably does not make a difference in
performance, but the consistency improves readability.

Signed-off-by: Volker Lendecke <vl@samba.org>
---
 fs/cifs/cifssmb.c |  6 +++---
 fs/cifs/smb2pdu.c | 14 +++++++-------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index a43c78396dd8..1f02c66e5716 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -1378,7 +1378,7 @@ CIFSSMBRead(const unsigned int xid, struct cifs_io_parms *io_parms,
 	READ_RSP *pSMBr = NULL;
 	char *pReadData = NULL;
 	int wct;
-	int resp_buf_type = 0;
+	int resp_buf_type;
 	struct kvec iov[1];
 	struct kvec rsp_iov;
 	__u32 pid = io_parms->pid;
@@ -1742,7 +1742,7 @@ CIFSSMBWrite2(const unsigned int xid, struct cifs_io_parms *io_parms,
 	WRITE_REQ *pSMB = NULL;
 	int wct;
 	int smb_hdr_len;
-	int resp_buf_type = 0;
+	int resp_buf_type;
 	__u32 pid = io_parms->pid;
 	__u16 netfid = io_parms->netfid;
 	__u64 offset = io_parms->offset;
@@ -1966,7 +1966,7 @@ CIFSSMBPosixLock(const unsigned int xid, struct cifs_tcon *tcon,
 	int rc = 0;
 	int timeout = 0;
 	int bytes_returned = 0;
-	int resp_buf_type = 0;
+	int resp_buf_type;
 	__u16 params, param_offset, offset, byte_count, count;
 	struct kvec iov[1];
 	struct kvec rsp_iov;
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 0e53265e1462..dede2d422c1f 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2952,7 +2952,7 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 	struct TCP_Server_Info *server = cifs_pick_channel(ses);
 	struct kvec iov[SMB2_CREATE_IOV_SIZE];
 	struct kvec rsp_iov = {NULL, 0};
-	int resp_buftype = CIFS_NO_BUFFER;
+	int resp_buftype;
 	int rc = 0;
 	int flags = 0;
 
@@ -3149,7 +3149,7 @@ SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
 	struct TCP_Server_Info *server;
 	struct kvec iov[SMB2_IOCTL_IOV_SIZE];
 	struct kvec rsp_iov = {NULL, 0};
-	int resp_buftype = CIFS_NO_BUFFER;
+	int resp_buftype;
 	int rc = 0;
 	int flags = 0;
 
@@ -3330,7 +3330,7 @@ __SMB2_close(const unsigned int xid, struct cifs_tcon *tcon,
 	struct TCP_Server_Info *server = cifs_pick_channel(ses);
 	struct kvec iov[1];
 	struct kvec rsp_iov;
-	int resp_buftype = CIFS_NO_BUFFER;
+	int resp_buftype;
 	int rc = 0;
 	int flags = 0;
 	bool query_attrs = false;
@@ -3514,7 +3514,7 @@ query_info(const unsigned int xid, struct cifs_tcon *tcon,
 	struct kvec iov[1];
 	struct kvec rsp_iov;
 	int rc = 0;
-	int resp_buftype = CIFS_NO_BUFFER;
+	int resp_buftype;
 	struct cifs_ses *ses = tcon->ses;
 	struct TCP_Server_Info *server;
 	int flags = 0;
@@ -3693,7 +3693,7 @@ SMB2_change_notify(const unsigned int xid, struct cifs_tcon *tcon,
 	struct smb2_change_notify_rsp *smb_rsp;
 	struct kvec iov[1];
 	struct kvec rsp_iov = {NULL, 0};
-	int resp_buftype = CIFS_NO_BUFFER;
+	int resp_buftype;
 	int flags = 0;
 	int rc = 0;
 
@@ -3983,7 +3983,7 @@ SMB2_flush(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
 	struct kvec iov[1];
 	struct kvec rsp_iov = {NULL, 0};
 	struct TCP_Server_Info *server = cifs_pick_channel(ses);
-	int resp_buftype = CIFS_NO_BUFFER;
+	int resp_buftype;
 	int flags = 0;
 	int rc = 0;
 
@@ -5016,7 +5016,7 @@ SMB2_query_directory(const unsigned int xid, struct cifs_tcon *tcon,
 	struct smb_rqst rqst;
 	struct kvec iov[SMB2_QUERY_DIRECTORY_IOV_SIZE];
 	struct smb2_query_directory_rsp *rsp = NULL;
-	int resp_buftype = CIFS_NO_BUFFER;
+	int resp_buftype;
 	struct kvec rsp_iov;
 	int rc = 0;
 	struct cifs_ses *ses = tcon->ses;
-- 
2.30.2

