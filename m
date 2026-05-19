Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49B32352039
	for <linux-cifs@vger.kernel.org>; Tue, 19 May 2026 10:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779186304; cv=none; b=nF7OBiiKloArj+w8JJgHPXePqI0/h4kI2l4CvYhL83eIE3MgDaZjFmedMhk9kBVIL+h1m+EsTmfSEPV8SN3v05hHNK4gKAJWI+5B7CO2Nw1yTyYTQMeoMZ13Peirjg6c9wZJWpvlMDu79GGSyhKaTLq1z2F/00ZUtZJyHu69bAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779186304; c=relaxed/simple;
	bh=X0h+5AVptZC7q+xWofUw4swviG9Q3/4vLX7eXdNe/co=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SQToe4RmwPI5lnYE1v4KVbZF4FJUFvQ0iy2Q+GmK5GT0kBCXBCi9lrUthXS2SPczHPYK3oR6PKc1O0Ej0yVYcmoArBX8P6553u+tzTrPVxuS/6RpMtRY0woqW2EkKrwFaJNM7g6TX70G/VHe0yFXzkAHnIrh2m98qtVCYRVq9PM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gL0KzgVl; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gL0KzgVl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779186300;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=d1SaZ+L79QQpkjXffUXdCdtrti4DUONWZdg8TYYyE8Y=;
	b=gL0KzgVla9hxeTt3hHg3NJ/5fnlq+T2CuP0ELfB3+VlgXNmZHc7EcKahZm2p3lxBOZrN0L
	Q4N5oyLkpqyUIiiDOZytVrCfgePpFWQI4WpHPhIHkuIpb/DrvMisLnf5NJYiy0j4CZ312e
	0Hj0t/S/J0h7umhxXk2LedA3Mz51St4=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-577-KEE-ULsUMymotRhuVNfIaQ-1; Tue,
 19 May 2026 06:24:55 -0400
X-MC-Unique: KEE-ULsUMymotRhuVNfIaQ-1
X-Mimecast-MFC-AGG-ID: KEE-ULsUMymotRhuVNfIaQ_1779186293
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A4A5E18005B8;
	Tue, 19 May 2026 10:24:53 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.48.33])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7DD06180056E;
	Tue, 19 May 2026 10:24:50 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Steve French <sfrench@samba.org>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Stefan Metzmacher <metze@samba.org>,
	Mina Almasry <almasrymina@google.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org
Subject: [RFC PATCH 34/36] cifs: [WIP] Rearrange Create request subfuncs
Date: Tue, 19 May 2026 11:21:52 +0100
Message-ID: <20260519102158.592165-35-dhowells@redhat.com>
In-Reply-To: <20260519102158.592165-1-dhowells@redhat.com>
References: <20260519102158.592165-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <sfrench@samba.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Shyam Prasad N <sprasad@microsoft.com>
cc: Tom Talpey <tom@talpey.com>
cc: linux-cifs@vger.kernel.org
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/smb/client/smb2pdu.c | 355 ++++++++++++++++++++--------------------
 1 file changed, 177 insertions(+), 178 deletions(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 01d84f9ece82..6747886024c4 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -1267,60 +1267,6 @@ static int smb311_decode_neg_context(struct smb_message *smb,
 	return rc;
 }
 
-static struct create_posix *
-create_posix_buf(umode_t mode)
-{
-	struct create_posix *buf;
-
-	buf = kzalloc_obj(struct create_posix);
-	if (!buf)
-		return NULL;
-
-	buf->ccontext.DataOffset =
-		cpu_to_le16(offsetof(struct create_posix, Mode));
-	buf->ccontext.DataLength = cpu_to_le32(4);
-	buf->ccontext.NameOffset =
-		cpu_to_le16(offsetof(struct create_posix, Name));
-	buf->ccontext.NameLength = cpu_to_le16(16);
-
-	/* SMB2_CREATE_TAG_POSIX is "0x93AD25509CB411E7B42383DE968BCD7C" */
-	buf->Name[0] = 0x93;
-	buf->Name[1] = 0xAD;
-	buf->Name[2] = 0x25;
-	buf->Name[3] = 0x50;
-	buf->Name[4] = 0x9C;
-	buf->Name[5] = 0xB4;
-	buf->Name[6] = 0x11;
-	buf->Name[7] = 0xE7;
-	buf->Name[8] = 0xB4;
-	buf->Name[9] = 0x23;
-	buf->Name[10] = 0x83;
-	buf->Name[11] = 0xDE;
-	buf->Name[12] = 0x96;
-	buf->Name[13] = 0x8B;
-	buf->Name[14] = 0xCD;
-	buf->Name[15] = 0x7C;
-	buf->Mode = cpu_to_le32(mode);
-	cifs_dbg(FYI, "mode on posix create 0%o\n", mode);
-	return buf;
-}
-
-static int
-add_posix_context(struct kvec *iov, unsigned int *num_iovec, umode_t mode)
-{
-	unsigned int num = *num_iovec;
-
-	iov[num].iov_base = create_posix_buf(mode);
-	if (mode == ACL_NO_MODE)
-		cifs_dbg(FYI, "%s: no mode\n", __func__);
-	if (iov[num].iov_base == NULL)
-		return -ENOMEM;
-	iov[num].iov_len = sizeof(struct create_posix);
-	*num_iovec = num + 1;
-	return 0;
-}
-
-
 /*
  *
  *	SMB2 Worker functions follow:
@@ -2524,6 +2470,59 @@ SMB2_tdis(const unsigned int xid, struct cifs_tcon *tcon)
 	return rc;
 }
 
+static struct create_posix *
+create_posix_buf(umode_t mode)
+{
+	struct create_posix *buf;
+
+	buf = kzalloc_obj(struct create_posix);
+	if (!buf)
+		return NULL;
+
+	buf->ccontext.DataOffset =
+		cpu_to_le16(offsetof(struct create_posix, Mode));
+	buf->ccontext.DataLength = cpu_to_le32(4);
+	buf->ccontext.NameOffset =
+		cpu_to_le16(offsetof(struct create_posix, Name));
+	buf->ccontext.NameLength = cpu_to_le16(16);
+
+	/* SMB2_CREATE_TAG_POSIX is "0x93AD25509CB411E7B42383DE968BCD7C" */
+	buf->Name[0] = 0x93;
+	buf->Name[1] = 0xAD;
+	buf->Name[2] = 0x25;
+	buf->Name[3] = 0x50;
+	buf->Name[4] = 0x9C;
+	buf->Name[5] = 0xB4;
+	buf->Name[6] = 0x11;
+	buf->Name[7] = 0xE7;
+	buf->Name[8] = 0xB4;
+	buf->Name[9] = 0x23;
+	buf->Name[10] = 0x83;
+	buf->Name[11] = 0xDE;
+	buf->Name[12] = 0x96;
+	buf->Name[13] = 0x8B;
+	buf->Name[14] = 0xCD;
+	buf->Name[15] = 0x7C;
+	buf->Mode = cpu_to_le32(mode);
+	cifs_dbg(FYI, "mode on posix create 0%o\n", mode);
+	return buf;
+}
+
+static int
+add_posix_context(struct kvec *iov, unsigned int *num_iovec, umode_t mode)
+{
+	unsigned int num = *num_iovec;
+
+	iov[num].iov_base = create_posix_buf(mode);
+	if (mode == ACL_NO_MODE)
+		cifs_dbg(FYI, "%s: no mode\n", __func__);
+	if (iov[num].iov_base == NULL)
+		return -ENOMEM;
+	iov[num].iov_len = sizeof(struct create_posix);
+	*num_iovec = num + 1;
+	return 0;
+}
+
 static create_durable_req_t *
 create_durable_buf(void)
 {
@@ -2572,130 +2571,6 @@ create_reconnect_durable_buf(struct cifs_fid *fid)
 	return buf;
 }
 
-static void
-parse_query_id_ctxt(struct create_context *cc, struct smb2_file_all_info *buf)
-{
-	struct create_disk_id_rsp *pdisk_id = (struct create_disk_id_rsp *)cc;
-
-	cifs_dbg(FYI, "parse query id context 0x%llx 0x%llx\n",
-		pdisk_id->DiskFileId, pdisk_id->VolumeId);
-	buf->IndexNumber = pdisk_id->DiskFileId;
-}
-
-static void
-parse_posix_ctxt(struct create_context *cc, struct smb2_file_all_info *info,
-		 struct create_posix_rsp *posix)
-{
-	int sid_len;
-	u8 *beg = (u8 *)cc + le16_to_cpu(cc->DataOffset);
-	u8 *end = beg + le32_to_cpu(cc->DataLength);
-	u8 *sid;
-
-	memset(posix, 0, sizeof(*posix));
-
-	posix->nlink = le32_to_cpu(*(__le32 *)(beg + 0));
-	posix->reparse_tag = le32_to_cpu(*(__le32 *)(beg + 4));
-	posix->mode = le32_to_cpu(*(__le32 *)(beg + 8));
-
-	sid = beg + 12;
-	sid_len = posix_info_sid_size(sid, end);
-	if (sid_len < 0) {
-		cifs_dbg(VFS, "bad owner sid in posix create response\n");
-		return;
-	}
-	memcpy(&posix->owner, sid, sid_len);
-
-	sid = sid + sid_len;
-	sid_len = posix_info_sid_size(sid, end);
-	if (sid_len < 0) {
-		cifs_dbg(VFS, "bad group sid in posix create response\n");
-		return;
-	}
-	memcpy(&posix->group, sid, sid_len);
-
-	cifs_dbg(FYI, "nlink=%d mode=%o reparse_tag=%x\n",
-		 posix->nlink, posix->mode, posix->reparse_tag);
-}
-
-int smb2_parse_contexts(struct TCP_Server_Info *server,
-			struct kvec *rsp_iov,
-			__u16 *epoch,
-			char *lease_key, __u8 *oplock,
-			struct smb2_file_all_info *buf,
-			struct create_posix_rsp *posix)
-{
-	struct smb2_create_rsp *rsp = rsp_iov->iov_base;
-	struct create_context *cc;
-	size_t rem, off, len;
-	size_t doff, dlen;
-	size_t noff, nlen;
-	char *name;
-	static const char smb3_create_tag_posix[] = {
-		0x93, 0xAD, 0x25, 0x50, 0x9C,
-		0xB4, 0x11, 0xE7, 0xB4, 0x23, 0x83,
-		0xDE, 0x96, 0x8B, 0xCD, 0x7C
-	};
-
-	*oplock = 0;
-
-	off = le32_to_cpu(rsp->CreateContextsOffset);
-	rem = le32_to_cpu(rsp->CreateContextsLength);
-	if (check_add_overflow(off, rem, &len) || len > rsp_iov->iov_len)
-		return -EINVAL;
-	cc = (struct create_context *)((u8 *)rsp + off);
-
-	/* Initialize inode number to 0 in case no valid data in qfid context */
-	if (buf)
-		buf->IndexNumber = 0;
-
-	while (rem >= sizeof(*cc)) {
-		doff = le16_to_cpu(cc->DataOffset);
-		dlen = le32_to_cpu(cc->DataLength);
-		if (check_add_overflow(doff, dlen, &len) || len > rem)
-			return -EINVAL;
-
-		noff = le16_to_cpu(cc->NameOffset);
-		nlen = le16_to_cpu(cc->NameLength);
-		if (noff + nlen > doff)
-			return -EINVAL;
-
-		name = (char *)cc + noff;
-		switch (nlen) {
-		case 4:
-			if (!strncmp(name, SMB2_CREATE_REQUEST_LEASE, 4)) {
-				*oplock = server->ops->parse_lease_buf(cc, epoch,
-								       lease_key);
-			} else if (buf &&
-				   !strncmp(name, SMB2_CREATE_QUERY_ON_DISK_ID, 4)) {
-				parse_query_id_ctxt(cc, buf);
-			}
-			break;
-		case 16:
-			if (posix && !memcmp(name, smb3_create_tag_posix, 16))
-				parse_posix_ctxt(cc, buf, posix);
-			break;
-		default:
-			cifs_dbg(FYI, "%s: unhandled context (nlen=%zu dlen=%zu)\n",
-				 __func__, nlen, dlen);
-			if (IS_ENABLED(CONFIG_CIFS_DEBUG2))
-				cifs_dump_mem("context data: ", cc, dlen);
-			break;
-		}
-
-		off = le32_to_cpu(cc->Next);
-		if (!off)
-			break;
-		if (check_sub_overflow(rem, off, &rem))
-			return -EINVAL;
-		cc = (struct create_context *)((u8 *)cc + off);
-	}
-
-	if (rsp->OplockLevel != SMB2_OPLOCK_LEVEL_LEASE)
-		*oplock = rsp->OplockLevel;
-
-	return 0;
-}
-
 static int
 add_lease_context(struct TCP_Server_Info *server,
 		  struct smb2_create_req *req,
@@ -3466,6 +3341,130 @@ SMB2_open_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
 	return 0;
 }
 
+static void
+parse_query_id_ctxt(struct create_context *cc, struct smb2_file_all_info *buf)
+{
+	struct create_disk_id_rsp *pdisk_id = (struct create_disk_id_rsp *)cc;
+
+	cifs_dbg(FYI, "parse query id context 0x%llx 0x%llx\n",
+		pdisk_id->DiskFileId, pdisk_id->VolumeId);
+	buf->IndexNumber = pdisk_id->DiskFileId;
+}
+
+static void
+parse_posix_ctxt(struct create_context *cc, struct smb2_file_all_info *info,
+		 struct create_posix_rsp *posix)
+{
+	int sid_len;
+	u8 *beg = (u8 *)cc + le16_to_cpu(cc->DataOffset);
+	u8 *end = beg + le32_to_cpu(cc->DataLength);
+	u8 *sid;
+
+	memset(posix, 0, sizeof(*posix));
+
+	posix->nlink = le32_to_cpu(*(__le32 *)(beg + 0));
+	posix->reparse_tag = le32_to_cpu(*(__le32 *)(beg + 4));
+	posix->mode = le32_to_cpu(*(__le32 *)(beg + 8));
+
+	sid = beg + 12;
+	sid_len = posix_info_sid_size(sid, end);
+	if (sid_len < 0) {
+		cifs_dbg(VFS, "bad owner sid in posix create response\n");
+		return;
+	}
+	memcpy(&posix->owner, sid, sid_len);
+
+	sid = sid + sid_len;
+	sid_len = posix_info_sid_size(sid, end);
+	if (sid_len < 0) {
+		cifs_dbg(VFS, "bad group sid in posix create response\n");
+		return;
+	}
+	memcpy(&posix->group, sid, sid_len);
+
+	cifs_dbg(FYI, "nlink=%d mode=%o reparse_tag=%x\n",
+		 posix->nlink, posix->mode, posix->reparse_tag);
+}
+
+int smb2_parse_contexts(struct TCP_Server_Info *server,
+			struct kvec *rsp_iov,
+			__u16 *epoch,
+			char *lease_key, __u8 *oplock,
+			struct smb2_file_all_info *buf,
+			struct create_posix_rsp *posix)
+{
+	struct smb2_create_rsp *rsp = rsp_iov->iov_base;
+	struct create_context *cc;
+	size_t rem, off, len;
+	size_t doff, dlen;
+	size_t noff, nlen;
+	char *name;
+	static const char smb3_create_tag_posix[] = {
+		0x93, 0xAD, 0x25, 0x50, 0x9C,
+		0xB4, 0x11, 0xE7, 0xB4, 0x23, 0x83,
+		0xDE, 0x96, 0x8B, 0xCD, 0x7C
+	};
+
+	*oplock = 0;
+
+	off = le32_to_cpu(rsp->CreateContextsOffset);
+	rem = le32_to_cpu(rsp->CreateContextsLength);
+	if (check_add_overflow(off, rem, &len) || len > rsp_iov->iov_len)
+		return -EINVAL;
+	cc = (struct create_context *)((u8 *)rsp + off);
+
+	/* Initialize inode number to 0 in case no valid data in qfid context */
+	if (buf)
+		buf->IndexNumber = 0;
+
+	while (rem >= sizeof(*cc)) {
+		doff = le16_to_cpu(cc->DataOffset);
+		dlen = le32_to_cpu(cc->DataLength);
+		if (check_add_overflow(doff, dlen, &len) || len > rem)
+			return -EINVAL;
+
+		noff = le16_to_cpu(cc->NameOffset);
+		nlen = le16_to_cpu(cc->NameLength);
+		if (noff + nlen > doff)
+			return -EINVAL;
+
+		name = (char *)cc + noff;
+		switch (nlen) {
+		case 4:
+			if (!strncmp(name, SMB2_CREATE_REQUEST_LEASE, 4)) {
+				*oplock = server->ops->parse_lease_buf(cc, epoch,
+								       lease_key);
+			} else if (buf &&
+				   !strncmp(name, SMB2_CREATE_QUERY_ON_DISK_ID, 4)) {
+				parse_query_id_ctxt(cc, buf);
+			}
+			break;
+		case 16:
+			if (posix && !memcmp(name, smb3_create_tag_posix, 16))
+				parse_posix_ctxt(cc, buf, posix);
+			break;
+		default:
+			cifs_dbg(FYI, "%s: unhandled context (nlen=%zu dlen=%zu)\n",
+				 __func__, nlen, dlen);
+			if (IS_ENABLED(CONFIG_CIFS_DEBUG2))
+				cifs_dump_mem("context data: ", cc, dlen);
+			break;
+		}
+
+		off = le32_to_cpu(cc->Next);
+		if (!off)
+			break;
+		if (check_sub_overflow(rem, off, &rem))
+			return -EINVAL;
+		cc = (struct create_context *)((u8 *)cc + off);
+	}
+
+	if (rsp->OplockLevel != SMB2_OPLOCK_LEVEL_LEASE)
+		*oplock = rsp->OplockLevel;
+
+	return 0;
+}
+
 /* rq_iov[0] is the request and is released by cifs_small_buf_release().
  * All other vectors are freed by kfree().
  */

