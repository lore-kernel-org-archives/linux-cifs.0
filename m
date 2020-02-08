Return-Path: <SRS0=LZk2=34=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDE46C35250
	for <linux-cifs@archiver.kernel.org>; Sat,  8 Feb 2020 14:51:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5380320726
	for <linux-cifs@archiver.kernel.org>; Sat,  8 Feb 2020 14:51:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727381AbgBHOvO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 8 Feb 2020 09:51:14 -0500
Received: from mx2.suse.de ([195.135.220.15]:39606 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727335AbgBHOvO (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sat, 8 Feb 2020 09:51:14 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id BDB2BAC2C;
        Sat,  8 Feb 2020 14:51:11 +0000 (UTC)
From:   Aurelien Aptel <aaptel@suse.com>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, Aurelien Aptel <aaptel@suse.com>
Subject: [PATCH 2/3] cifs: add smb2 POSIX info level
Date:   Sat,  8 Feb 2020 15:50:57 +0100
Message-Id: <20200208145058.10429-2-aaptel@suse.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200208145058.10429-1-aaptel@suse.com>
References: <20200208145058.10429-1-aaptel@suse.com>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

* add new info level and structs for SMB2 posix extension
* add functions to parse and validate it

Signed-off-by: Aurelien Aptel <aaptel@suse.com>
---
 fs/cifs/cifspdu.h   |  1 +
 fs/cifs/smb2pdu.c   | 95 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2pdu.h   | 44 +++++++++++++++++++++++++
 fs/cifs/smb2proto.h |  2 ++
 4 files changed, 142 insertions(+)

diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
index 79d842e7240c..8e15887d1f1f 100644
--- a/fs/cifs/cifspdu.h
+++ b/fs/cifs/cifspdu.h
@@ -1691,6 +1691,7 @@ struct smb_t2_rsp {
 #define SMB_FIND_FILE_ID_FULL_DIR_INFO    0x105
 #define SMB_FIND_FILE_ID_BOTH_DIR_INFO    0x106
 #define SMB_FIND_FILE_UNIX                0x202
+#define SMB_FIND_FILE_POSIX_INFO          0x064
 
 typedef struct smb_com_transaction2_qpi_req {
 	struct smb_hdr hdr;	/* wct = 14+ */
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 7d4d7cdb2eb4..174ae2ef6310 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -4290,6 +4290,101 @@ SMB2_write(const unsigned int xid, struct cifs_io_parms *io_parms,
 	return rc;
 }
 
+static int posix_info_sid_size(const void *beg, const void *end)
+{
+	size_t subauth;
+	int total;
+
+	if (beg + 1 > end)
+		return -1;
+
+	subauth = *(u8 *)(beg+1);
+	if (subauth < 1 || subauth > 15)
+		return -1;
+
+	total = 1 + 1 + 6 + 4*subauth;
+	if (beg + total > end)
+		return -1;
+
+	return total;
+}
+
+int posix_info_parse(const void *beg, const void *end,
+		     struct smb2_posix_info_parsed *out)
+
+{
+	int total_len = 0;
+	int sid_len;
+	int name_len;
+	const void *owner_sid;
+	const void *group_sid;
+	const void *name;
+
+	/* if no end bound given, assume payload to be correct */
+	if (!end) {
+		const struct smb2_posix_info *p = beg;
+
+		end = beg + le32_to_cpu(p->NextEntryOffset);
+		/* last element will have a 0 offset, pick a sensible bound */
+		if (end == beg)
+			end += 0xFFFF;
+	}
+
+	/* check base buf */
+	if (beg + sizeof(struct smb2_posix_info) > end)
+		return -1;
+	total_len = sizeof(struct smb2_posix_info);
+
+	/* check owner sid */
+	owner_sid = beg + total_len;
+	sid_len = posix_info_sid_size(owner_sid, end);
+	if (sid_len < 0)
+		return -1;
+	total_len += sid_len;
+
+	/* check group sid */
+	group_sid = beg + total_len;
+	sid_len = posix_info_sid_size(group_sid, end);
+	if (sid_len < 0)
+		return -1;
+	total_len += sid_len;
+
+	/* check name len */
+	if (beg + total_len + 4 > end)
+		return -1;
+	name_len = le32_to_cpu(*(__le32 *)(beg + total_len));
+	if (name_len < 1 || name_len > 0xFFFF)
+		return -1;
+	total_len += 4;
+
+	/* check name */
+	name = beg + total_len;
+	if (name + name_len > end)
+		return -1;
+	total_len += name_len;
+
+	if (out) {
+		out->base = beg;
+		out->size = total_len;
+		out->name_len = name_len;
+		out->name = name;
+		memcpy(&out->owner, owner_sid,
+		       posix_info_sid_size(owner_sid, end));
+		memcpy(&out->group, group_sid,
+		       posix_info_sid_size(group_sid, end));
+	}
+	return total_len;
+}
+
+static int posix_info_extra_size(const void *beg, const void *end)
+{
+	int len = posix_info_parse(beg, end, NULL);
+
+	if (len < 0)
+		return -1;
+	return len - sizeof(struct smb2_posix_info);
+}
+
 static unsigned int
 num_entries(char *bufstart, char *end_of_buf, char **lastentry, size_t size)
 {
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index c84405ed603c..4f30c745ed88 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -1613,5 +1613,49 @@ struct create_posix_rsp {
 	  var sized group SID
 	*/
 } __packed;
+
+/*
+ * SMB2-only POSIX info level
+ *
+ * See posix_info_sid_size(), posix_info_extra_size() and
+ * posix_info_parse() to help with the handling of this struct.
+ */
+struct smb2_posix_info {
+	__le32 NextEntryOffset;
+	__u32 Ignored;
+	__le64 CreationTime;
+	__le64 LastAccessTime;
+	__le64 LastWriteTime;
+	__le64 ChangeTime;
+	__le64 EndOfFile;
+	__le64 AllocationSize;
+	__le32 DosAttributes;
+	__le64 Inode;
+	__le32 DeviceId;
+	__le32 Zero;
+	/* beginning of POSIX Create Context Response */
+	__le32 HardLinks;
+	__le32 ReparseTag;
+	__le32 Mode;
+	/*
+	 * var sized owner SID
+	 * var sized group SID
+	 * le32 filenamelength
+	 * u8  filename[]
+	 */
+} __packed;
+
+/*
+ * Parsed version of the above struct. Allows direct access to the
+ * variable length fields
+ */
+struct smb2_posix_info_parsed {
+	const struct smb2_posix_info *base;
+	size_t size;
+	struct cifs_sid owner;
+	struct cifs_sid group;
+	int name_len;
+	const u8 *name;
 };
+
 #endif				/* _SMB2PDU_H */
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index de6388ef344f..c0f0801e7e8e 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -272,4 +272,6 @@ extern int smb2_query_info_compound(const unsigned int xid,
 				    u32 class, u32 type, u32 output_len,
 				    struct kvec *rsp, int *buftype,
 				    struct cifs_sb_info *cifs_sb);
+int posix_info_parse(const void *beg, const void *end,
+		     struct smb2_posix_info_parsed *out);
 #endif			/* _SMB2PROTO_H */
-- 
2.16.4

