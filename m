Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 177322EA73F;
	Tue, 22 Jul 2025 14:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193751; cv=none; b=D/W8o4tHFQubsF9Ysoepmqpngw4/8wIcJvvkZKOtLailaJW3CZVzRT1TiRu5gxqIFMVxqd+JZYL9rsMcPrpEF9JZOcdSIieIzgGI39zcXEiaaoYph+b7iBM6EiPySTH+uaXuq/isgIO15RgEhoiAqfUj+FAa/9lwDAn4HDID2II=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193751; c=relaxed/simple;
	bh=A3weRIkRFQRmSCT/QKBrfiFJLQO1VwQsATEhs2KYl9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r5ro5eaWddLKt+qJ2izsSxExYqDPy0Pfthli7HH03grcHqMJYFziNrTITkvy5yT1dzkuK+cOw87auW9aWICDEyGrp+nCZR2/v2KnnoKwz7lvGQs02JiiXGBoPA/t0Y+ZBv9V56LKhD7nk3GUSySVtcW/1g7JNfA08JOjAAEJAr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z5trTLAO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z5trTLAO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74C1DC4CEEB;
	Tue, 22 Jul 2025 14:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193750;
	bh=A3weRIkRFQRmSCT/QKBrfiFJLQO1VwQsATEhs2KYl9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z5trTLAOZjXtyKLcjicCSHFrjx/VmY4ul8JG7Tekme9gO3aGK4Xjync6QwtoIqiyZ
	 /e3cOnLa1Tx3USrqgZkcd98Jif7ugfzgmJgl/HzpAmYhscN2TMxDqPFTf2qWK8NCSX
	 +wFHx9eSL683ns5L0gIiQOdrrvY++AG35ZPWDvWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Meetakshi Setiya <msetiya@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org,
	Stefan Metzmacher <metze@samba.org>,
	Steve French <stfrench@microsoft.com>,
	stable+noautosel@kernel.org
Subject: [PATCH 6.15 187/187] smb: client: let smbd_post_send_iter() respect the peers max_send_size and transmit all data
Date: Tue, 22 Jul 2025 15:45:57 +0200
Message-ID: <20250722134352.730381369@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Metzmacher <metze@samba.org>

commit 1944f6ab4967db7ad8d4db527dceae8c77de76e9 upstream.

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

Reviewed-by: David Howells <dhowells@redhat.com>
Tested-by: David Howells <dhowells@redhat.com>
Tested-by: Meetakshi Setiya <msetiya@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: <stable+noautosel@kernel.org> # sp->max_send_size should be info->max_send_size in backports
Fixes: 3d78fe73fa12 ("cifs: Build the RDMA SGE list directly from an iterator")
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smbdirect.c |   31 +++++++++++++++++++++++++++----
 1 file changed, 27 insertions(+), 4 deletions(-)

--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -907,8 +907,10 @@ wait_send_queue:
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
@@ -1013,6 +1015,27 @@ static int smbd_post_send_empty(struct s
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
@@ -1962,14 +1985,14 @@ int smbd_send(struct TCP_Server_Info *se
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


