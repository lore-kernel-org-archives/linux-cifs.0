Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F5CF4D2ECD
	for <linux-cifs@vger.kernel.org>; Tue, 19 May 2026 10:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779186232; cv=none; b=RDnXaHPYj2YqgDmlZ7pnoFsmfXoPOcEwoUm+xsrMzTSWAvDqzW9b7z3cI0fvdi0tFAaGKNl7gNMk58fe0H3Og0PGbIUGC7C9aBbB3wcuK2Bvju6ZjKnI27GuwUPriht393madti8UBgoc0Uu5IjKGGb+HzYaBgsY31wBe0j1us4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779186232; c=relaxed/simple;
	bh=51B2rHKys7mbRhtY7XKxWSOvTT02j1bbjwUHdnXS90g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SEI2blw+uYi3SpouU0Tqu32kMlifUx/rFfRLP0kuA2DqVO1pLbZzhh44X935zRUraUWqkwWtB/53/L5r+DrJ0y3VNk17fAJD0GM3l4pwsrBke1Zxr4iqkJF4i9e9XeIxyErAAgggCGiocx3gomykGJJmAU32xzF9RLHPVkJ+TKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AIOKIvOC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AIOKIvOC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779186224;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=roC32dctScvHhnDgsFFj+YvvKQrdeBQEvvpna5yuBKs=;
	b=AIOKIvOCs+VjoB+yHeQHkXuiTPvxVdBUE7uTp+cXbgVKsOgEP838fBTB0BQTcnh1qLc207
	WEUuCw1EmmQVZjL8gdlilmextSFoUO2xgz62FYrA7UrzIJcrUNCmrL9O/EDaSysQKeLiDF
	6Rk79hjaLlcMobwZAPK1PmsEUinDUrM=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-685-aGJtKDLXM6WEZSyr7JyuhA-1; Tue,
 19 May 2026 06:23:40 -0400
X-MC-Unique: aGJtKDLXM6WEZSyr7JyuhA-1
X-Mimecast-MFC-AGG-ID: aGJtKDLXM6WEZSyr7JyuhA_1779186219
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 552EA1956050;
	Tue, 19 May 2026 10:23:39 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.48.33])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6579430002DC;
	Tue, 19 May 2026 10:23:36 +0000 (UTC)
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
	linux-fsdevel@vger.kernel.org
Subject: [RFC PATCH 19/36] cifs: Try to better handle the "Dynamic" flag in StructureSize2 in SMB2/3
Date: Tue, 19 May 2026 11:21:37 +0100
Message-ID: <20260519102158.592165-20-dhowells@redhat.com>
In-Reply-To: <20260519102158.592165-1-dhowells@redhat.com>
References: <20260519102158.592165-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

The bottom bit of the size field of the op-specific SMB2/3 struct that
immediately follows the smb[23]_hdr struct is a bit weird.  Wireshark
considers it a "dynamic flag" and it would seem that it needs to be masked
off to get the actualy size of the struct - and if there is data following
the struct, it is kind of meaningless.

The adjusted value, however, must still be set that way, and if there is
nothing following the struct, it seems that the message must be padded out
with an extra zero byte so that the message size is no less than the header
including that flag in the StructureSize.

Possibly this is a remnant of someone putting an empty data field at the
end of the struct as "unsigned char Buffer[1];".  But whatever the origin,
there are a bunch of places in which the extra 1 needs to be subtracted
off.

Since subtracting 1 is the rule rather than the exception, return the size
with the bit masked off and add the pad byte if we don't have anything else
to add (Read being the main example of this).

This can then be handled more transparently in future.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <sfrench@samba.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Shyam Prasad N <sprasad@microsoft.com>
cc: Tom Talpey <tom@talpey.com>
cc: linux-cifs@vger.kernel.org
cc: linux-fsdevel@vger.kernel.org
---
 fs/smb/client/smb2pdu.c | 28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index ddf127dc27bb..48f56ce73cd3 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -543,7 +543,11 @@ fill_small_buf(__le16 smb2_command, struct cifs_tcon *tcon,
 	smb2_hdr_assemble(&spdu->hdr, smb2_command, tcon, server);
 	spdu->StructureSize2 = cpu_to_le16(parmsize);
 
-	*total_len = parmsize + sizeof(struct smb2_hdr);
+	if (smb2_command == SMB2_READ)
+		*total_len = sizeof(struct smb2_hdr) + parmsize;
+	else
+		*total_len = sizeof(struct smb2_hdr) +
+			(parmsize & ~SMB2_STRUCT_HAS_DYNAMIC_PART);
 }
 
 /*
@@ -1589,7 +1593,7 @@ SMB2_sess_alloc_buffer(struct SMB2_sess_data *sess_data)
 
 	sess_data->iov[0].iov_base = (char *)req;
 	/* 1 for pad */
-	sess_data->iov[0].iov_len = total_len - 1;
+	sess_data->iov[0].iov_len = total_len;
 	/*
 	 * This variable will be used to clear the buffer
 	 * allocated above in case of any error in the calling function.
@@ -2154,7 +2158,7 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
 
 	iov[0].iov_base = (char *)req;
 	/* 1 for pad */
-	iov[0].iov_len = total_len - 1;
+	iov[0].iov_len = total_len;
 
 	/* Testing shows that buffer offset must be at location of Buffer[0] */
 	req->PathOffset = cpu_to_le16(sizeof(struct smb2_tree_connect_req));
@@ -2958,7 +2962,7 @@ int smb311_posix_mkdir(const unsigned int xid, struct inode *inode,
 
 	iov[0].iov_base = (char *)req;
 	/* -1 since last byte is buf[0] which is sent below (path) */
-	iov[0].iov_len = total_len - 1;
+	iov[0].iov_len = total_len;
 
 	req->NameOffset = cpu_to_le16(sizeof(struct smb2_create_req));
 
@@ -3105,7 +3109,7 @@ SMB2_open_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
 
 	iov[0].iov_base = (char *)req;
 	/* -1 since last byte is buf[0] which is sent below (path) */
-	iov[0].iov_len = total_len - 1;
+	iov[0].iov_len = total_len;
 
 	if (oparms->create_options & CREATE_OPTION_READONLY)
 		file_attributes |= ATTR_READONLY;
@@ -3427,12 +3431,12 @@ SMB2_ioctl_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
 		req->InputOffset =
 		       cpu_to_le32(offsetof(struct smb2_ioctl_req, Buffer));
 		rqst->rq_nvec = 2;
-		iov[0].iov_len = total_len - 1;
+		iov[0].iov_len = total_len;
 		iov[1].iov_base = in_data_buf;
 		iov[1].iov_len = indatalen;
 	} else {
 		rqst->rq_nvec = 1;
-		iov[0].iov_len = total_len;
+		iov[0].iov_len = total_len + 1;
 	}
 
 	req->OutputOffset = 0;
@@ -3874,7 +3878,7 @@ SMB2_query_info_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
 	if (input_len) {
 		req->InputBufferLength = cpu_to_le32(input_len);
 		/* total_len for smb query request never close to le16 max */
-		req->InputBufferOffset = cpu_to_le16(total_len - 1);
+		req->InputBufferOffset = cpu_to_le16(total_len);
 		memcpy(req->Buffer, input, input_len);
 	}
 
@@ -4579,7 +4583,7 @@ smb2_new_read_req(void **buf, unsigned int *total_len,
 		v1 = (struct smbdirect_buffer_descriptor_v1 *) &req->Buffer[0];
 		smbd_mr_fill_buffer_descriptor(rdata->mr, v1);
 
-		*total_len += sizeof(*v1) - 1;
+		*total_len += sizeof(*v1);
 	}
 #endif
 	if (request_type & CHAINED_REQUEST) {
@@ -5339,7 +5343,7 @@ SMB2_write(const unsigned int xid, struct cifs_io_parms *io_parms,
 
 	iov[0].iov_base = (char *)req;
 	/* 1 for Buffer */
-	iov[0].iov_len = total_len - 1;
+	iov[0].iov_len = total_len;
 
 	memset(&rqst, 0, sizeof(struct smb_rqst));
 	rqst.rq_iov = iov;
@@ -5597,7 +5601,7 @@ int SMB2_query_directory_init(const unsigned int xid,
 
 	iov[0].iov_base = (char *)req;
 	/* 1 for Buffer */
-	iov[0].iov_len = total_len - 1;
+	iov[0].iov_len = total_len;
 
 	iov[1].iov_base = (char *)(req->Buffer);
 	iov[1].iov_len = len;
@@ -5810,7 +5814,7 @@ SMB2_set_info_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
 
 	iov[0].iov_base = (char *)req;
 	/* 1 for Buffer */
-	iov[0].iov_len = total_len - 1;
+	iov[0].iov_len = total_len;
 
 	for (i = 1; i < rqst->rq_nvec; i++) {
 		le32_add_cpu(&req->BufferLength, size[i]);

