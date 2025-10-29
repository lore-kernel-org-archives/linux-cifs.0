Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EA56350298
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744672; cv=none; b=Y0GSiyHS9lTjbRYp8O7nGp7hOASZ27JtF6rDmwChUaVaIHX+U41/wWfbaa/ofkfqWh2dF1bp4/ut5kryZF5AK96SPhOxLNF8xpWBW37dPo/KQea68ONbAtTQk80YzXSPNMP97/DVTgqYRMbu9xPs1/FKtBhUp/njM/unwj1MACg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744672; c=relaxed/simple;
	bh=Gmv7EnGy+9pcxkUnnS4TCeFKrvr6Up9sVVyZaD3TMh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BJvaTxIKLdoav4AyrRUDPRz42sa+tLnsxchaK5LhP2zRjqwZGgMqGTZtjDYGAjw5+M+IXwtLpjapNKUG8U5CH0lMtSEP6aeCw/emjsbynCUVTWfPDBl20c2r5GPGZnL0VJAy5sQhTPiiraG5IRQ+rQjxCNjJPK8ohhiwKpMakDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=iWiEdmOU; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="iWiEdmOU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=Lyw+JIk9kUaRQH5MY4lIkRc7yplHwKTmnToOqUwYiCw=; b=iWiEdmOU7vU5T8mV5FfhURLS43
	A9xe/34pPYXQA48uMTQhJQK097qYqRcJbLLbyo7uJU8PNqNwsyCyVsmtkdbTpbQqinic62htItaBr
	pulkLtYl119VsFovciGVGbfB878FhVwRvwc5mvciB+tVELK/tRwdQjGpPvLcijvvJr5sgtwe5qobv
	n58h5u4E2M1nASEAXp55mvsFUDUri8vA4eQ51iSJSb4EPzZw7ADjbUBMcqo8RgeqzSOIt3NbSfpL/
	3H081Xd/NmW4tzr/NCW3cOSuPthkoyY/PdfIGqdDEvUJVLeCjdpuz2QKFJOuyazNW6TEKx4eEzvDQ
	mXS5FKx+GFeUR+vkH+MELXLf9SefWgRE/Gm4rtNoeT1b0SroXLVdnX6BLPd14Sofydc+t5KtO1A1D
	9I1Qnp/oULhnhQJQtjP1SmeJ3xzdd2FPtDuCIjEuX+4U9IPAH4FkmhFFlNaeOKR8s/cFfaBcyyVru
	ZrEcBLK0KarzWd2kPZEreqvT;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6GX-00BcUP-0x;
	Wed, 29 Oct 2025 13:31:06 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v2 086/127] smb: client: introduce and use smbd_mr_fill_buffer_descriptor()
Date: Wed, 29 Oct 2025 14:21:04 +0100
Message-ID: <77144f3024ca8209b1165a999e4cde36741ac773.1761742839.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1761742839.git.metze@samba.org>
References: <cover.1761742839.git.metze@samba.org>
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
---
 fs/smb/client/smb2pdu.c   | 8 ++------
 fs/smb/client/smbdirect.c | 6 ++++++
 fs/smb/client/smbdirect.h | 2 ++
 3 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index b0739a2661bf..a9a04c4db6dc 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -4480,9 +4480,7 @@ smb2_new_read_req(void **buf, unsigned int *total_len,
 		req->ReadChannelInfoLength =
 			cpu_to_le16(sizeof(struct smbdirect_buffer_descriptor_v1));
 		v1 = (struct smbdirect_buffer_descriptor_v1 *) &req->Buffer[0];
-		v1->offset = cpu_to_le64(rdata->mr->mr->iova);
-		v1->token = cpu_to_le32(rdata->mr->mr->rkey);
-		v1->length = cpu_to_le32(rdata->mr->mr->length);
+		smbd_mr_fill_buffer_descriptor(rdata->mr, v1);
 
 		*total_len += sizeof(*v1) - 1;
 	}
@@ -5030,9 +5028,7 @@ smb2_async_writev(struct cifs_io_subrequest *wdata)
 		req->WriteChannelInfoLength =
 			cpu_to_le16(sizeof(struct smbdirect_buffer_descriptor_v1));
 		v1 = (struct smbdirect_buffer_descriptor_v1 *) &req->Buffer[0];
-		v1->offset = cpu_to_le64(wdata->mr->mr->iova);
-		v1->token = cpu_to_le32(wdata->mr->mr->rkey);
-		v1->length = cpu_to_le32(wdata->mr->mr->length);
+		smbd_mr_fill_buffer_descriptor(wdata->mr, v1);
 
 		rqst.rq_iov[0].iov_len += sizeof(*v1);
 
diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 1e17daaac227..d52ded68dee4 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -1195,6 +1195,12 @@ struct smbdirect_mr_io *smbd_register_mr(struct smbd_connection *info,
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
index 577d37dbeb8a..09f7dd14b2c1 100644
--- a/fs/smb/client/smbdirect.h
+++ b/fs/smb/client/smbdirect.h
@@ -60,6 +60,8 @@ int smbd_send(struct TCP_Server_Info *server,
 struct smbdirect_mr_io *smbd_register_mr(
 	struct smbd_connection *info, struct iov_iter *iter,
 	bool writing, bool need_invalidate);
+void smbd_mr_fill_buffer_descriptor(struct smbdirect_mr_io *mr,
+				    struct smbdirect_buffer_descriptor_v1 *v1);
 void smbd_deregister_mr(struct smbdirect_mr_io *mr);
 
 #else
-- 
2.43.0

