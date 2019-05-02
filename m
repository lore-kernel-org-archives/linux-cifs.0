Return-Path: <SRS0=G37X=TC=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0AA1C43219
	for <linux-cifs@archiver.kernel.org>; Thu,  2 May 2019 05:53:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8942F2081C
	for <linux-cifs@archiver.kernel.org>; Thu,  2 May 2019 05:53:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725764AbfEBFxG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 2 May 2019 01:53:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35812 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725763AbfEBFxG (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 2 May 2019 01:53:06 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C74A637E7B;
        Thu,  2 May 2019 05:53:05 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-54.bne.redhat.com [10.64.54.54])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2A1078A299;
        Thu,  2 May 2019 05:53:04 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH] cifs: fix smb3_zero_range for Azure
Date:   Thu,  2 May 2019 15:52:57 +1000
Message-Id: <20190502055257.31219-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Thu, 02 May 2019 05:53:05 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

For zero-range that also extend the file we were sending this as a
compound of two different operations; a fsctl to set-zero-data for the range
and then an additional set-info to extend the file size.
This does not work for Azure since it does not support this fsctl which leads
to fallocate(FALLOC_FL_ZERO_RANGE) failing but still changing the file size.

To fix this we un-compound this and send these two operations as separate
commands, firsat one command to set-zero-data for the range and it this
was successful we proceed to send a set-info to update the file size.

This fixes xfstest generic/469 for Azure servers.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/smb2ops.c | 54 +++++++-----------------------------------------------
 1 file changed, 7 insertions(+), 47 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 9b7a2f448591..860dd1696830 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -2648,16 +2648,8 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
 	struct cifsInodeInfo *cifsi;
 	struct cifsFileInfo *cfile = file->private_data;
 	struct file_zero_data_information fsctl_buf;
-	struct smb_rqst rqst[2];
-	int resp_buftype[2];
-	struct kvec rsp_iov[2];
-	struct kvec io_iov[SMB2_IOCTL_IOV_SIZE];
-	struct kvec si_iov[1];
-	unsigned int size[1];
-	void *data[1];
 	long rc;
 	unsigned int xid;
-	int num = 0, flags = 0;
 	__le64 eof;
 
 	xid = get_xid();
@@ -2684,22 +2676,11 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
 	fsctl_buf.FileOffset = cpu_to_le64(offset);
 	fsctl_buf.BeyondFinalZero = cpu_to_le64(offset + len);
 
-	if (smb3_encryption_required(tcon))
-		flags |= CIFS_TRANSFORM_REQ;
-
-	memset(rqst, 0, sizeof(rqst));
-	resp_buftype[0] = resp_buftype[1] = CIFS_NO_BUFFER;
-	memset(rsp_iov, 0, sizeof(rsp_iov));
-
-
-	memset(&io_iov, 0, sizeof(io_iov));
-	rqst[num].rq_iov = io_iov;
-	rqst[num].rq_nvec = SMB2_IOCTL_IOV_SIZE;
-	rc = SMB2_ioctl_init(tcon, &rqst[num++], cfile->fid.persistent_fid,
-			     cfile->fid.volatile_fid, FSCTL_SET_ZERO_DATA,
-			     true /* is_fctl */, (char *)&fsctl_buf,
-			     sizeof(struct file_zero_data_information),
-			     CIFSMaxBufSize);
+	rc = SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
+			cfile->fid.volatile_fid, FSCTL_SET_ZERO_DATA, true,
+			(char *)&fsctl_buf,
+			sizeof(struct file_zero_data_information),
+			0, NULL, NULL);
 	if (rc)
 		goto zero_range_exit;
 
@@ -2707,33 +2688,12 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
 	 * do we also need to change the size of the file?
 	 */
 	if (keep_size == false && i_size_read(inode) < offset + len) {
-		smb2_set_next_command(tcon, &rqst[0]);
-
-		memset(&si_iov, 0, sizeof(si_iov));
-		rqst[num].rq_iov = si_iov;
-		rqst[num].rq_nvec = 1;
-
 		eof = cpu_to_le64(offset + len);
-		size[0] = 8; /* sizeof __le64 */
-		data[0] = &eof;
-
-		rc = SMB2_set_info_init(tcon, &rqst[num++],
-					cfile->fid.persistent_fid,
-					cfile->fid.persistent_fid,
-					current->tgid,
-					FILE_END_OF_FILE_INFORMATION,
-					SMB2_O_INFO_FILE, 0, data, size);
-		smb2_set_related(&rqst[1]);
+		rc = SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
+				  cfile->fid.volatile_fid, cfile->pid, &eof);
 	}
 
-	rc = compound_send_recv(xid, ses, flags, num, rqst,
-				resp_buftype, rsp_iov);
-
  zero_range_exit:
-	SMB2_ioctl_free(&rqst[0]);
-	SMB2_set_info_free(&rqst[1]);
-	free_rsp_buf(resp_buftype[0], rsp_iov[0].iov_base);
-	free_rsp_buf(resp_buftype[1], rsp_iov[1].iov_base);
 	free_xid(xid);
 	if (rc)
 		trace_smb3_zero_err(xid, cfile->fid.persistent_fid, tcon->tid,
-- 
2.13.6

