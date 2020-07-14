Return-Path: <SRS0=KB7a=AZ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4603CC433E1
	for <linux-cifs@archiver.kernel.org>; Tue, 14 Jul 2020 22:18:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 110EF206F4
	for <linux-cifs@archiver.kernel.org>; Tue, 14 Jul 2020 22:18:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eJCZzq2M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726619AbgGNWSW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 14 Jul 2020 18:18:22 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:49902 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726187AbgGNWSW (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 14 Jul 2020 18:18:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594765101;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=GNCHxADUa5o8yhe1WwYcE7lZvr+56rFlJe2JLR1mNIU=;
        b=eJCZzq2M/tI+LddNPPsW8W1S8qldbN/+EN9iMRdUtvr5MHLDGCaQMA5Xd0T8bkob1zQYEG
        DcyAQ8iUzGygO3RnaRFakU9wsp+WQqOY2MrxSNVxZqBhIRN8r/0O9N2BbZizYGMfr2+aUD
        naepi7xem3IvjR7TM0nY9QAeT4ZS4hI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-286-TfeBgpKpO6arrAmnpmZyJA-1; Tue, 14 Jul 2020 18:18:19 -0400
X-MC-Unique: TfeBgpKpO6arrAmnpmZyJA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 61BEA8015F3
        for <linux-cifs@vger.kernel.org>; Tue, 14 Jul 2020 22:18:18 +0000 (UTC)
Received: from test1103.test.redhat.com (vpn2-54-135.bne.redhat.com [10.64.54.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6EEFA1992D;
        Tue, 14 Jul 2020 22:18:17 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH] cifs: smb1: Try failing back to SetFileInfo if SetPathInfo fails
Date:   Wed, 15 Jul 2020 08:18:05 +1000
Message-Id: <20200714221805.3459-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

RHBZ 1145308

Some very old server may not support SetPathInfo to adjust the timestamps
of directories. For these servers, try to open the directory and use SetFileInfo.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/cifsproto.h |  2 +-
 fs/cifs/cifssmb.c   | 39 ++++++++++++++++++++++++++++++++++++++-
 fs/cifs/smb1ops.c   |  4 ++--
 3 files changed, 41 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 7a836ec0438e..c1cd3fff0b60 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -344,7 +344,7 @@ extern int CIFSSMBQFSPosixInfo(const unsigned int xid, struct cifs_tcon *tcon,
 extern int CIFSSMBSetPathInfo(const unsigned int xid, struct cifs_tcon *tcon,
 			const char *fileName, const FILE_BASIC_INFO *data,
 			const struct nls_table *nls_codepage,
-			int remap_special_chars);
+			struct cifs_sb_info *cifs_sb);
 extern int CIFSSMBSetFileInfo(const unsigned int xid, struct cifs_tcon *tcon,
 			const FILE_BASIC_INFO *data, __u16 fid,
 			__u32 pid_of_opener);
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index bf41ee048396..eac525c1be5e 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -5914,9 +5914,41 @@ CIFSSMBSetFileDisposition(const unsigned int xid, struct cifs_tcon *tcon,
 }
 
 int
+CIFSSMBSetPathInfoFB(const unsigned int xid, struct cifs_tcon *tcon,
+		     const char *fileName, const FILE_BASIC_INFO *data,
+		     const struct nls_table *nls_codepage,
+		     struct cifs_sb_info *cifs_sb)
+{
+	int oplock = 0;
+	struct cifs_open_parms oparms;
+	struct cifs_fid fid;
+	int rc;
+
+	oparms.tcon = tcon;
+	oparms.cifs_sb = cifs_sb;
+	oparms.desired_access = GENERIC_WRITE;
+	oparms.create_options = cifs_create_options(cifs_sb, 0);
+	oparms.disposition = FILE_OPEN;
+	oparms.path = fileName;
+	oparms.fid = &fid;
+	oparms.reconnect = false;
+
+	rc = CIFS_open(xid, &oparms, &oplock, NULL);
+	if (rc)
+		goto out;
+
+	rc = CIFSSMBSetFileInfo(xid, tcon, data, fid.netfid, current->tgid);
+	CIFSSMBClose(xid, tcon, fid.netfid);
+out:
+
+	return rc;
+}
+
+int
 CIFSSMBSetPathInfo(const unsigned int xid, struct cifs_tcon *tcon,
 		   const char *fileName, const FILE_BASIC_INFO *data,
-		   const struct nls_table *nls_codepage, int remap)
+		   const struct nls_table *nls_codepage,
+		     struct cifs_sb_info *cifs_sb)
 {
 	TRANSACTION2_SPI_REQ *pSMB = NULL;
 	TRANSACTION2_SPI_RSP *pSMBr = NULL;
@@ -5925,6 +5957,7 @@ CIFSSMBSetPathInfo(const unsigned int xid, struct cifs_tcon *tcon,
 	int bytes_returned = 0;
 	char *data_offset;
 	__u16 params, param_offset, offset, byte_count, count;
+	int remap = cifs_remap(cifs_sb);
 
 	cifs_dbg(FYI, "In SetTimes\n");
 
@@ -5987,6 +6020,10 @@ CIFSSMBSetPathInfo(const unsigned int xid, struct cifs_tcon *tcon,
 	if (rc == -EAGAIN)
 		goto SetTimesRetry;
 
+	if (rc == -EOPNOTSUPP)
+		return CIFSSMBSetPathInfoFB(xid, tcon, fileName, data,
+					    nls_codepage, cifs_sb);
+
 	return rc;
 }
 
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 197ed455e657..80287c26cfac 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -688,7 +688,7 @@ cifs_mkdir_setinfo(struct inode *inode, const char *full_path,
 	dosattrs = cifsInode->cifsAttrs|ATTR_READONLY;
 	info.Attributes = cpu_to_le32(dosattrs);
 	rc = CIFSSMBSetPathInfo(xid, tcon, full_path, &info, cifs_sb->local_nls,
-				cifs_remap(cifs_sb));
+				cifs_sb);
 	if (rc == 0)
 		cifsInode->cifsAttrs = dosattrs;
 }
@@ -783,7 +783,7 @@ smb_set_file_info(struct inode *inode, const char *full_path,
 	tcon = tlink_tcon(tlink);
 
 	rc = CIFSSMBSetPathInfo(xid, tcon, full_path, buf, cifs_sb->local_nls,
-				cifs_remap(cifs_sb));
+				cifs_sb);
 	if (rc == 0) {
 		cinode->cifsAttrs = le32_to_cpu(buf->Attributes);
 		goto out;
-- 
2.13.6

