Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B3A32FA26
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764094189; cv=none; b=ZDd9bMgF9FSyPnfM/xeZg4Yx267UMfsnhbKefF4Ux7klqHg3hyXTcDB1eLbtMWkKTKHt/zxW2NUtTwcoIicRXlEAiEg1RFTGnc/tq3JmBYbjipJnYedI+SsHouxwbZn4frD62jAMtv7IaTFVebmIdfChJB0OqZTylLaD/zZlvMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764094189; c=relaxed/simple;
	bh=YXAzDamvjzHfNPljM0ZbwLvBaE49YBB+WCAcjr1XQ8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H4vQkD/NCMnCbLf8Sma48v7yhfmqlxahysGtTS+WYyHqiq3zaf/Rul7WVQbXFiyC4nZV18PwYJZtUWw5CHqJOHjNtf+t/nRuKkV3a/8yqgsf1H9s24ZkCEgYZNop/H5NbZBugxveh8I8kT2uWrB5UMYw8kgW1wT+gCgIQFsu9hI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=uYH6x9lD; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="uYH6x9lD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=r0KUAx3Qlam8o9Y6BtQRDDN753USx9Jau3sHXoSmAg8=; b=uYH6x9lDAjrvp46NxQv/x0pKd3
	/vKucJzGFCl1jOuHaatiF+p4sWbe3mCEvr55Qh+PY68IbQMwgOCAIvMjrAvGm9ebH5S/HKc0C/qu8
	zOXh2kMZUzxwnNA2DLSkieT7FDoFAqye69DVCXacyos9NdgNUOPq/1O+YPxJy0N8322S2wwUoRCrX
	cS+inuCJ2zJ46lRJT5RyINqmtazCinB8mURIEj1IP7B6O2pR/hZEMGlCtSwGp5mI4+lsdDPnDhswx
	GEkQs6GYOJ1R5GFnLvncKKnrtaDl2iiDacqsVj0PlYc3O6Kfk595jt1wNfEy4MvnLxRKh59pbOsPr
	a65/mHFFqy4Tf15CAK7tCswkHByR51dzL4j5LhVpJ9tn5ghCgmlZWWRlZc/peVefoKQixmXJSZgSa
	nxl4IidCutSDv14MN0jYeEjfA4vkxV/X3l8ImTeYLQEk3K3d5aeTbk0CVvaAtmdDwZ/aMvSk9+xI8
	Ks7IY8MCZ8HQF35fCBC2Rqk2;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxTS-00Fe6g-0T;
	Tue, 25 Nov 2025 18:09:11 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 091/145] smb: client: introduce and use smbd_mr_fill_buffer_descriptor()
Date: Tue, 25 Nov 2025 18:55:37 +0100
Message-ID: <ef4709dd8b44f416f8dbc8022ad34d8514f9abde.1764091285.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1764091285.git.metze@samba.org>
References: <cover.1764091285.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This will allow us to make struct smbdirect_mr_io private in future.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/smb2pdu.c   | 8 ++------
 fs/smb/client/smbdirect.c | 6 ++++++
 fs/smb/client/smbdirect.h | 2 ++
 3 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index ce56237928a0..72062bafbbaa 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -4518,9 +4518,7 @@ smb2_new_read_req(void **buf, unsigned int *total_len,
 		req->ReadChannelInfoLength =
 			cpu_to_le16(sizeof(struct smbdirect_buffer_descriptor_v1));
 		v1 = (struct smbdirect_buffer_descriptor_v1 *) &req->Buffer[0];
-		v1->offset = cpu_to_le64(rdata->mr->mr->iova);
-		v1->token = cpu_to_le32(rdata->mr->mr->rkey);
-		v1->length = cpu_to_le32(rdata->mr->mr->length);
+		smbd_mr_fill_buffer_descriptor(rdata->mr, v1);
 
 		*total_len += sizeof(*v1) - 1;
 	}
@@ -5068,9 +5066,7 @@ smb2_async_writev(struct cifs_io_subrequest *wdata)
 		req->WriteChannelInfoLength =
 			cpu_to_le16(sizeof(struct smbdirect_buffer_descriptor_v1));
 		v1 = (struct smbdirect_buffer_descriptor_v1 *) &req->Buffer[0];
-		v1->offset = cpu_to_le64(wdata->mr->mr->iova);
-		v1->token = cpu_to_le32(wdata->mr->mr->rkey);
-		v1->length = cpu_to_le32(wdata->mr->mr->length);
+		smbd_mr_fill_buffer_descriptor(wdata->mr, v1);
 
 		rqst.rq_iov[0].iov_len += sizeof(*v1);
 
diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 18b71f58e387..4ad1d13de812 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -1196,6 +1196,12 @@ struct smbdirect_mr_io *smbd_register_mr(struct smbd_connection *info,
 	return smbdirect_connection_register_mr_io(sc, iter, writing, need_invalidate);
 }
 
+void smbd_mr_fill_buffer_descriptor(struct smbdirect_mr_io *mr,
+				    struct smbdirect_buffer_descriptor_v1 *v1)
+{
+	smbdirect_mr_io_fill_buffer_descriptor(mr, v1);
+}
+
 /*
  * Deregister a MR after I/O is done
  * This function may wait if remote invalidation is not used
diff --git a/fs/smb/client/smbdirect.h b/fs/smb/client/smbdirect.h
index f600dc4a8eba..9f14f5cb4a38 100644
--- a/fs/smb/client/smbdirect.h
+++ b/fs/smb/client/smbdirect.h
@@ -60,6 +60,8 @@ int smbd_send(struct TCP_Server_Info *server,
 struct smbdirect_mr_io *smbd_register_mr(
 	struct smbd_connection *info, struct iov_iter *iter,
 	bool writing, bool need_invalidate);
+void smbd_mr_fill_buffer_descriptor(struct smbdirect_mr_io *mr,
+				    struct smbdirect_buffer_descriptor_v1 *v1);
 void smbd_deregister_mr(struct smbdirect_mr_io *mr);
 
 
-- 
2.43.0

