Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 966E4C433B4
	for <linux-cifs@archiver.kernel.org>; Thu,  8 Apr 2021 22:41:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75EB161159
	for <linux-cifs@archiver.kernel.org>; Thu,  8 Apr 2021 22:41:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232632AbhDHWlR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 8 Apr 2021 18:41:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26413 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232265AbhDHWlR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 8 Apr 2021 18:41:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617921664;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=0TVhV8suZ1t5+FJ05dPXpMdk6zWKpfbhrR8Bf0eYxs8=;
        b=YfELWXsv7FhmDLL7sA0dzjgDBBU/7whGRPOcPeWa8wa49Hp6iXqSQLi7D79dRS6rK2gvpQ
        7wjLkqOYteXBSg+fuJM/foqMK8gg31e0Ffmkg+m6KrCpWhZ0bYZu9jS8s+2B4Yafe/DFfT
        bJB0+47MGvSq7I95wsbBSP+bfzehflA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-41-5Ps4XwuBMpyS3MXkXe2nlw-1; Thu, 08 Apr 2021 18:41:03 -0400
X-MC-Unique: 5Ps4XwuBMpyS3MXkXe2nlw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E3E866D4E0;
        Thu,  8 Apr 2021 22:41:01 +0000 (UTC)
Received: from localhost.localdomain (vpn2-54-17.bne.redhat.com [10.64.54.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4B740196E3;
        Thu,  8 Apr 2021 22:41:01 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH] cifs: improve fallocate emulation
Date:   Fri,  9 Apr 2021 08:40:54 +1000
Message-Id: <20210408224054.649656-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

RHBZ: 1866684

We don't have a real fallocate in the SMB2 protocol so we used to emulate fallocate
by simply switching the file to become non-sparse. But as that could potantially
consume a lot more data than we intended to fallocate (large sparse file and fallocating a thin
slice in the middle) we would only do this IFF the fallocate request was for virtually the entire file.

This patch improves this and starts allowing us to fallocate smaller chunks of a file by
overwriting the region with 0, for the parts that are unallocated.

The method used is to first query the server for FSCTL_QUERY_ALLOCATED_RANGES to find what
is unallocated in teh fallocate range and then to only overwrite-with-zero the unallocated ranges to fill
in the holes.
As overwriting-with-zero is different from just allocating blocks, and potentially much more expensive,
we limit this to only allow fallocate ranges up to 1Mb in size.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/smb2ops.c | 133 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 133 insertions(+)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index f703204fb185..1eecaeb4beb4 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -3563,6 +3563,119 @@ static long smb3_punch_hole(struct file *file, struct cifs_tcon *tcon,
 	return rc;
 }
 
+static int smb3_simple_fallocate_write_range(unsigned int xid,
+					     struct cifs_tcon *tcon,
+					     struct cifsFileInfo *cfile,
+					     loff_t off, loff_t len,
+					     char *buf)
+{
+	struct cifs_io_parms io_parms = {0};
+	int nbytes;
+	struct kvec iov[2];
+
+	io_parms.netfid = cfile->fid.netfid;
+	io_parms.pid = current->tgid;
+	io_parms.tcon = tcon;
+	io_parms.persistent_fid = cfile->fid.persistent_fid;
+	io_parms.volatile_fid = cfile->fid.volatile_fid;
+	io_parms.offset = off;
+	io_parms.length = len;
+
+	/* iov[0] is reserved for smb header */
+	iov[1].iov_base = buf;
+	iov[1].iov_len = io_parms.length;
+	return SMB2_write(xid, &io_parms, &nbytes, iov, 1);
+}
+
+static int smb3_simple_fallocate_range(unsigned int xid,
+				       struct cifs_tcon *tcon,
+				       struct cifsFileInfo *cfile,
+				       loff_t off, loff_t len)
+{
+	struct file_allocated_range_buffer in_data, *out_data = NULL, *tmp_data;
+	u32 out_data_len;
+	char *buf = NULL;
+	loff_t l;
+	int rc;
+
+	in_data.file_offset = cpu_to_le64(off);
+	in_data.length = cpu_to_le64(len);
+	rc = SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
+			cfile->fid.volatile_fid,
+			FSCTL_QUERY_ALLOCATED_RANGES, true,
+			(char *)&in_data, sizeof(in_data),
+			1024 * sizeof(struct file_allocated_range_buffer),
+			(char **)&out_data, &out_data_len);
+	if (rc)
+		goto out;
+	/*
+	 * It is already all allocated
+	 */
+	if (out_data_len == 0)
+		goto out;
+
+	buf = kzalloc(1024 * 1024, GFP_KERNEL);
+	if (buf == NULL) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	tmp_data = out_data;
+	while (len) {
+		/*
+		 * The rest of the region is unmapped so write it all.
+		 */
+		if (out_data_len == 0) {
+			rc = smb3_simple_fallocate_write_range(xid, tcon,
+					       cfile, off, len, buf);
+			goto out;
+		}
+
+		if (out_data_len < sizeof(struct file_allocated_range_buffer)) {
+			rc = -EINVAL;
+			goto out;
+		}
+
+		if (off < le64_to_cpu(tmp_data->file_offset)) {
+			/*
+			 * We are at a hole. Write until the end of the region
+			 * or until the next allocated data,
+			 * whichever comes next.
+			 */
+			l = le64_to_cpu(tmp_data->file_offset) - off;
+			if (len < l)
+				l = len;
+			rc = smb3_simple_fallocate_write_range(xid, tcon,
+					       cfile, off, l, buf);
+			if (rc)
+				goto out;
+			off = off + l;
+			len = len - l;
+			if (len == 0)
+				goto out;
+		}
+		/*
+		 * We are at a section of allocated data, just skip forward
+		 * until the end of the data or the end of the region
+		 * we are supposed to fallocate, whichever comes first.
+		 */
+		l = le64_to_cpu(tmp_data->length);
+		if (len < l)
+			l = len;
+		off += l;
+		len -= l;
+
+		tmp_data = &tmp_data[1];
+		out_data_len -= sizeof(struct file_allocated_range_buffer);
+	}
+
+ out:
+	kfree(out_data);
+	kfree(buf);
+	return rc;
+}
+
+
 static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
 			    loff_t off, loff_t len, bool keep_size)
 {
@@ -3623,6 +3736,26 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
 	}
 
 	if ((keep_size == true) || (i_size_read(inode) >= off + len)) {
+		/*
+		 * At this point, we are trying to fallocate an internal
+		 * regions of a sparse file. Since smb2 does not have a
+		 * fallocate command we have two otions on how to emulate this.
+		 * We can either turn the entire file to become non-sparse
+		 * which we only do if the fallocate is for virtually
+		 * the whole file,  or we can overwrite the region with zeroes
+		 * using SMB2_write, which could be prohibitevly expensive
+		 * if len is large.
+		 */
+		/*
+		 * We are only trying to fallocate a small region so
+		 * just write it with zero.
+		 */
+		if (len <= 1024 * 1024) {
+			rc = smb3_simple_fallocate_range(xid, tcon, cfile,
+							 off, len);
+			goto out;
+		}
+
 		/*
 		 * Check if falloc starts within first few pages of file
 		 * and ends within a few pages of the end of file to
-- 
2.30.2

