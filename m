Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34C3E2F0C52;
	Mon, 22 Sep 2025 19:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570176; cv=none; b=m+3C2Ty3n0TxKH208l1Dyrx7L5aEuqB+8A+2wp//qEBIk8L+86zsKycojojwox+vs8qof80stFJ3KiCPKGlrcv+CwhS9rsDN9SgVfgrgxgjcp1wa8etuHWLSxR8NtBf9z0WWNGgTPVPIq2xxkKZxh4uhx6QI9yuTWYIvdBjxVZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570176; c=relaxed/simple;
	bh=LZVFAzAkz14Y3PzlpPR9pgCME3fikYE98/LZNNSFZhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IXuqtFWjnNX/edf9fxHpHp0VeXFusAad5m0K4TjL12sSBj/4kMRuHRO18QTLSuab4bg20J2JpbQzoT905sVoUCnR2ZlFAwlldl/3shRO+a4K0i/kG/0OydTKDm3r+ANlHO8DkaKaupEuRuCTJ78ZdGPvaKM95Mv+xtEMJuPx0BE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T1J4Uttw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T1J4Uttw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C20F6C4CEF0;
	Mon, 22 Sep 2025 19:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570176;
	bh=LZVFAzAkz14Y3PzlpPR9pgCME3fikYE98/LZNNSFZhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T1J4UttwB5Bjl/yLEIRkucsTcsnbG9qT9jYK0+IsMQWzJ6n1uerjCbhCkRt9lRAv8
	 UPdT6rxPnlY0cujBqCXXKmimnYeevlNol/gEm9pnPg1HXB4nh70pofvgUmJnECj8v3
	 for8CU2Ahr+n1XfTolNj9WvsNQU7PMjnMlbBLpfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Stefan Metzmacher <metze@samba.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.16 048/149] ksmbd: smbdirect: verify remaining_data_length respects max_fragmented_recv_size
Date: Mon, 22 Sep 2025 21:29:08 +0200
Message-ID: <20250922192414.072735894@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Metzmacher <metze@samba.org>

commit e1868ba37fd27c6a68e31565402b154beaa65df0 upstream.

This is inspired by the check for data_offset + data_length.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Cc: stable@vger.kernel.org
Fixes: 2ea086e35c3d ("ksmbd: add buffer validation for smb direct")
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/transport_rdma.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -554,7 +554,7 @@ static void recv_done(struct ib_cq *cq,
 	case SMB_DIRECT_MSG_DATA_TRANSFER: {
 		struct smb_direct_data_transfer *data_transfer =
 			(struct smb_direct_data_transfer *)recvmsg->packet;
-		unsigned int data_offset, data_length;
+		u32 remaining_data_length, data_offset, data_length;
 		int avail_recvmsg_count, receive_credits;
 
 		if (wc->byte_len <
@@ -564,6 +564,7 @@ static void recv_done(struct ib_cq *cq,
 			return;
 		}
 
+		remaining_data_length = le32_to_cpu(data_transfer->remaining_data_length);
 		data_length = le32_to_cpu(data_transfer->data_length);
 		data_offset = le32_to_cpu(data_transfer->data_offset);
 		if (wc->byte_len < data_offset ||
@@ -571,6 +572,14 @@ static void recv_done(struct ib_cq *cq,
 			put_recvmsg(t, recvmsg);
 			smb_direct_disconnect_rdma_connection(t);
 			return;
+		}
+		if (remaining_data_length > t->max_fragmented_recv_size ||
+		    data_length > t->max_fragmented_recv_size ||
+		    (u64)remaining_data_length + (u64)data_length >
+		    (u64)t->max_fragmented_recv_size) {
+			put_recvmsg(t, recvmsg);
+			smb_direct_disconnect_rdma_connection(t);
+			return;
 		}
 
 		if (data_length) {


