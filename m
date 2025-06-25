Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B10D315A86B
	for <linux-cifs@vger.kernel.org>; Wed, 25 Jun 2025 08:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750839414; cv=none; b=ZHdYt0VmEMkQhG8aZBjlOT1cGqs02eDMj0VS2EtvBum7uilD2EQsYo1+m0nHdZ5UjgQtr4zRKYIJT+0aXoZ4HZgDwNX5cdTGtJ7OdMBK/J5jLdWsG8lgTFqPaJbMys+ahlAG3ZjyEcTqZQ6DOMHN6B2JV5fVeUGWlUQj3vfRq1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750839414; c=relaxed/simple;
	bh=UcZP5U1UP8OGhsmtYDb1DSy/O44NVDxs+wP5nnJuzw8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=AK9G4CO0nS92we8iYC/hO6OGy1PRIp6U2F/k1p+dAOXi/VQldZkMEHv7lvRnyUB9aM4GsfRiV6gKyE0i49dDMVapK8qNJEflMv3mhWA/tCXZSjDbMG9fXZlSOpZcz77pZpVjs1+VdHU76M87dFH4uflN3GUuKl9bdCy94Pi5Up0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=UkVv2Idc; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="UkVv2Idc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-Id:Date:Cc:To:From;
	bh=GXNhUz7dkesmKFXVgfaZQO3otUQc051IhBmmn+n6xag=; b=UkVv2Idc2R3yueHPCMMYlKUQxP
	ksufF2n2tVZc0OVLS/CGOZfU9z2BFgP4NWXI1bwF/657TiUs+ggFr22YtBZUsXpsK117yS1jdxOtc
	/DgcQRHtZMEij3RqmCH4xEhpqsB/IKxiTSZGIMiRlkQzDqCO1er3uPX9lUCqWxKKc3Hc39VqlcmJd
	TCaSb3+OyvANPemJ2dVsUclpKgWXSBTNOUfjhrePFaBnSfJjyMLHkEeRdPsHjT/NicQwGySVBJFOW
	g1RCSDbcccv/nyvwRwUbQRAgJAENlfPvkrQM/rS31UmjWQstYkqyVEfiNHxysmr3tHej1W/f1ihsG
	E4uFXPOqfwjL6DM0iLK0O95ROebE5L2qgFvivONZanThT9vpXZpBWgKLixWGEb8D31bR87BIpBm0t
	DEdgWB3wdGzifoMZ8FBjyPwPYuTVJ/ZFw38NXVFUtaGdfI/caIg97gKISJPowwooh9Ci4Nk8BaSZS
	Y0lfH037TQnC2VU5u5/6w/Lb;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uULJJ-00CNyz-2T;
	Wed, 25 Jun 2025 08:16:49 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <sfrench@samba.org>,
	David Howells <dhowells@redhat.com>,
	Tom Talpey <tom@talpey.com>,
	stable+noautosel@kernel.org
Subject: [PATCH v2] smb: client: let smbd_post_send_iter() respect the peers max_send_size and transmit all data
Date: Wed, 25 Jun 2025 10:16:38 +0200
Message-Id: <20250625081638.944583-1-metze@samba.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We should not send smbdirect_data_transfer messages larger than
the negotiated max_send_size, typically 1364 bytes, which means
24 bytes of the smbdirect_data_transfer header + 1340 payload bytes.

This happened when doing an SMB2 write with more than 1340 bytes
(which is done inline as it's below rdma_readwrite_threshold).

It means the peer resets the connection.

When testing between cifs.ko and ksmbd.ko something like this
is logged:

client:

    CIFS: VFS: RDMA transport re-established
    siw: got TERMINATE. layer 1, type 2, code 2
    siw: got TERMINATE. layer 1, type 2, code 2
    siw: got TERMINATE. layer 1, type 2, code 2
    siw: got TERMINATE. layer 1, type 2, code 2
    siw: got TERMINATE. layer 1, type 2, code 2
    siw: got TERMINATE. layer 1, type 2, code 2
    siw: got TERMINATE. layer 1, type 2, code 2
    siw: got TERMINATE. layer 1, type 2, code 2
    siw: got TERMINATE. layer 1, type 2, code 2
    CIFS: VFS: \\carina Send error in SessSetup = -11
    smb2_reconnect: 12 callbacks suppressed
    CIFS: VFS: reconnect tcon failed rc = -11
    CIFS: VFS: reconnect tcon failed rc = -11
    CIFS: VFS: reconnect tcon failed rc = -11
    CIFS: VFS: SMB: Zero rsize calculated, using minimum value 65536

and:

    CIFS: VFS: RDMA transport re-established
    siw: got TERMINATE. layer 1, type 2, code 2
    CIFS: VFS: smbd_recv:1894 disconnected
    siw: got TERMINATE. layer 1, type 2, code 2

The ksmbd dmesg is showing things like:

    smb_direct: Recv error. status='local length error (1)' opcode=128
    smb_direct: disconnected
    smb_direct: Recv error. status='local length error (1)' opcode=128
    ksmbd: smb_direct: disconnected
    ksmbd: sock_read failed: -107

As smbd_post_send_iter() limits the transmitted number of bytes
we need loop over it in order to transmit the whole iter.

Cc: Steve French <sfrench@samba.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: <stable+noautosel@kernel.org> # sp->max_send_size should be info->max_send_size in backports
Fixes: 3d78fe73fa12 ("cifs: Build the RDMA SGE list directly from an iterator")
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 31 +++++++++++++++++++++++++++----
 1 file changed, 27 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index d00adce37f09..7162c0e3acb1 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -907,8 +907,10 @@ static int smbd_post_send_iter(struct smbd_connection *info,
 			.local_dma_lkey	= sc->ib.pd->local_dma_lkey,
 			.direction	= DMA_TO_DEVICE,
 		};
+		size_t payload_len = umin(*_remaining_data_length,
+					  sp->max_send_size - sizeof(*packet));
 
-		rc = smb_extract_iter_to_rdma(iter, *_remaining_data_length,
+		rc = smb_extract_iter_to_rdma(iter, payload_len,
 					      &extract);
 		if (rc < 0)
 			goto err_dma;
@@ -1013,6 +1015,27 @@ static int smbd_post_send_empty(struct smbd_connection *info)
 	return smbd_post_send_iter(info, NULL, &remaining_data_length);
 }
 
+static int smbd_post_send_full_iter(struct smbd_connection *info,
+				    struct iov_iter *iter,
+				    int *_remaining_data_length)
+{
+	int rc = 0;
+
+	/*
+	 * smbd_post_send_iter() respects the
+	 * negotiated max_send_size, so we need to
+	 * loop until the full iter is posted
+	 */
+
+	while (iov_iter_count(iter) > 0) {
+		rc = smbd_post_send_iter(info, iter, _remaining_data_length);
+		if (rc < 0)
+			break;
+	}
+
+	return rc;
+}
+
 /*
  * Post a receive request to the transport
  * The remote peer can only send data when a receive request is posted
@@ -1956,14 +1979,14 @@ int smbd_send(struct TCP_Server_Info *server,
 			klen += rqst->rq_iov[i].iov_len;
 		iov_iter_kvec(&iter, ITER_SOURCE, rqst->rq_iov, rqst->rq_nvec, klen);
 
-		rc = smbd_post_send_iter(info, &iter, &remaining_data_length);
+		rc = smbd_post_send_full_iter(info, &iter, &remaining_data_length);
 		if (rc < 0)
 			break;
 
 		if (iov_iter_count(&rqst->rq_iter) > 0) {
 			/* And then the data pages if there are any */
-			rc = smbd_post_send_iter(info, &rqst->rq_iter,
-						 &remaining_data_length);
+			rc = smbd_post_send_full_iter(info, &rqst->rq_iter,
+						      &remaining_data_length);
 			if (rc < 0)
 				break;
 		}
-- 
2.34.1

