Return-Path: <SRS0=HHpq=RQ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80A35C43381
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Mar 2019 04:37:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 571162177E
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Mar 2019 04:37:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725820AbfCMEh6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 13 Mar 2019 00:37:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51554 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725785AbfCMEh6 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 13 Mar 2019 00:37:58 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BFF15C04AC51;
        Wed, 13 Mar 2019 04:37:57 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-89.bne.redhat.com [10.64.54.89])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2AD765D706;
        Wed, 13 Mar 2019 04:37:56 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH 2/2] cifs: fix smb3_zero_range so it can expand the file-size when required
Date:   Wed, 13 Mar 2019 14:37:49 +1000
Message-Id: <20190313043749.832-3-lsahlber@redhat.com>
In-Reply-To: <20190313043749.832-1-lsahlber@redhat.com>
References: <20190313043749.832-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Wed, 13 Mar 2019 04:37:57 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This allows fallocate -z to work against a Windows2016 share.

This is due to the SMB3 ZERO_RANGE command does not modify the filesize.
To address this we will now append a compounded SET-INFO to update the
end-of-file information.

This brings xfstests generic/469 closer to working against a windows share.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/smb2ops.c | 76 ++++++++++++++++++++++++++++++++++++++++++-------------
 fs/cifs/smb2pdu.c |  4 +--
 fs/cifs/smb2pdu.h |  7 +++++
 3 files changed, 68 insertions(+), 19 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 085e91436da7..f5b34a7b29f9 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -2472,12 +2472,22 @@ get_smb2_acl(struct cifs_sb_info *cifs_sb,
 static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
 			    loff_t offset, loff_t len, bool keep_size)
 {
+	struct cifs_ses *ses = tcon->ses;
 	struct inode *inode;
 	struct cifsInodeInfo *cifsi;
 	struct cifsFileInfo *cfile = file->private_data;
 	struct file_zero_data_information fsctl_buf;
+	struct smb_rqst rqst[2];
+	int resp_buftype[2];
+	struct kvec rsp_iov[2];
+	struct kvec io_iov[SMB2_IOCTL_IOV_SIZE];
+	struct kvec si_iov[1];
+	unsigned int size[1];
+	void *data[1];
 	long rc;
 	unsigned int xid;
+	int num = 0, flags = 0;
+	__le64 eof;
 
 	xid = get_xid();
 
@@ -2502,28 +2512,60 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
 		return rc;
 	}
 
-	/*
-	 * need to make sure we are not asked to extend the file since the SMB3
-	 * fsctl does not change the file size. In the future we could change
-	 * this to zero the first part of the range then set the file size
-	 * which for a non sparse file would zero the newly extended range
-	 */
-	if (keep_size == false)
-		if (i_size_read(inode) < offset + len) {
-			rc = -EOPNOTSUPP;
-			free_xid(xid);
-			return rc;
-		}
-
 	cifs_dbg(FYI, "offset %lld len %lld", offset, len);
 
 	fsctl_buf.FileOffset = cpu_to_le64(offset);
 	fsctl_buf.BeyondFinalZero = cpu_to_le64(offset + len);
 
-	rc = SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
-			cfile->fid.volatile_fid, FSCTL_SET_ZERO_DATA,
-			true /* is_fctl */, (char *)&fsctl_buf,
-			sizeof(struct file_zero_data_information), NULL, NULL);
+	if (smb3_encryption_required(tcon))
+		flags |= CIFS_TRANSFORM_REQ;
+
+	memset(rqst, 0, sizeof(rqst));
+	resp_buftype[0] = resp_buftype[1] = CIFS_NO_BUFFER;
+	memset(rsp_iov, 0, sizeof(rsp_iov));
+
+
+	memset(&io_iov, 0, sizeof(io_iov));
+	rqst[num].rq_iov = io_iov;
+	rqst[num].rq_nvec = SMB2_IOCTL_IOV_SIZE;
+	rc = SMB2_ioctl_init(tcon, &rqst[num++], cfile->fid.persistent_fid,
+			     cfile->fid.volatile_fid, FSCTL_SET_ZERO_DATA,
+			     true /* is_fctl */, (char *)&fsctl_buf,
+			     sizeof(struct file_zero_data_information));
+	if (rc)
+		goto zero_range_exit;
+
+	/*
+	 * do we also need to change the size of the file?
+	 */
+	if (keep_size == false && i_size_read(inode) < offset + len) {
+		smb2_set_next_command(tcon, &rqst[0]);
+
+		memset(&si_iov, 0, sizeof(si_iov));
+		rqst[num].rq_iov = si_iov;
+		rqst[num].rq_nvec = 1;
+
+		eof = cpu_to_le64(offset + len);
+		size[0] = 8; /* sizeof __le64 */
+		data[0] = &eof;
+
+		rc = SMB2_set_info_init(tcon, &rqst[num++],
+					cfile->fid.persistent_fid,
+					cfile->fid.persistent_fid,
+					current->tgid,
+					FILE_END_OF_FILE_INFORMATION,
+					SMB2_O_INFO_FILE, 0, data, size);
+		smb2_set_related(&rqst[1]);
+	}
+
+	rc = compound_send_recv(xid, ses, flags, num, rqst,
+				resp_buftype, rsp_iov);
+
+ zero_range_exit:
+	SMB2_ioctl_free(&rqst[0]);
+	SMB2_set_info_free(&rqst[1]);
+	free_rsp_buf(resp_buftype[0], rsp_iov[0].iov_base);
+	free_rsp_buf(resp_buftype[1], rsp_iov[1].iov_base);
 	free_xid(xid);
 	return rc;
 }
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index e074cc12b4b4..e1cdee97078e 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2553,7 +2553,7 @@ SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
 	struct smb_rqst rqst;
 	struct smb2_ioctl_rsp *rsp = NULL;
 	struct cifs_ses *ses;
-	struct kvec iov[2];
+	struct kvec iov[SMB2_IOCTL_IOV_SIZE];
 	struct kvec rsp_iov = {NULL, 0};
 	int resp_buftype = CIFS_NO_BUFFER;
 	int rc = 0;
@@ -2582,7 +2582,7 @@ SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
 	memset(&rqst, 0, sizeof(struct smb_rqst));
 	memset(&iov, 0, sizeof(iov));
 	rqst.rq_iov = iov;
-	rqst.rq_nvec = 2;
+	rqst.rq_nvec = SMB2_IOCTL_IOV_SIZE;
 
 	rc = SMB2_ioctl_init(tcon, &rqst, persistent_fid, volatile_fid,
 			     opcode, is_fsctl, in_data, indatalen);
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index 0bd4d4802701..ee8977688e21 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -959,6 +959,13 @@ struct duplicate_extents_to_file {
 	__le64 ByteCount;  /* Bytes to be copied */
 } __packed;
 
+/*
+ * Maximum number of iovs we need for an ioctl request.
+ * [0] : struct smb2_ioctl_req
+ * [1] : in_data
+ */
+#define SMB2_IOCTL_IOV_SIZE 2
+
 struct smb2_ioctl_req {
 	struct smb2_sync_hdr sync_hdr;
 	__le16 StructureSize;	/* Must be 57 */
-- 
2.13.6

