Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 580382C9A;
	Tue, 22 Jul 2025 14:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193129; cv=none; b=nW41QH2sW0fyAx9V2vwX0AGEuilm5r2hycSyETCBMjVati636bc2i9sYAwcyc4dY8kGt0xHZZfw+Gr0JOeGqaBaHQZhe+aOfFpgckNVpXXVd6DxWgt1AZj0jp4xAH2Gx/M3v05Rh2i1/AB0GPun6LeLWb2k5ti+PmdIEMIDbBHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193129; c=relaxed/simple;
	bh=xzvSeHrPGh2XlznE+GlKpmSmENqkZILt9kxSivrFbt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HTENVJ3jbkXVag9cVNTQo7lhe41k2vYGdsxFamjXJIc+kyvr63lVIoBCngIOOZm8djHIkBu/pmaCKiqtaqMAfTX9zgJ+p6R7N/W6jpByjdIxhIB8EGJQvSg4uHaTCu2k1uNQlv78cLNwRa/g2SXtByHFwCTVNWwbJdp/O8dt/IU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gdktgeao; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gdktgeao"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DF8DC4CEEB;
	Tue, 22 Jul 2025 14:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193128;
	bh=xzvSeHrPGh2XlznE+GlKpmSmENqkZILt9kxSivrFbt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gdktgeaoYOz3VSTzHFliA9m/q8afnYNmHO1/O8jVfAH48G69RRy6OD2twPQ3klIgL
	 tshJy3Gj9OgKmUNQZhqCPanqLau6qQ78p0uyqUwUCdpPL6ozOqAXObjaNscQSwcMpI
	 msqEKJ1kZoceofqAIvtKwk/W0v4rbJUrT5DZ5abA=
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
Subject: [PATCH 6.12 158/158] smb: client: let smbd_post_send_iter() respect the peers max_send_size and transmit all data
Date: Tue, 22 Jul 2025 15:45:42 +0200
Message-ID: <20250722134346.605211690@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


