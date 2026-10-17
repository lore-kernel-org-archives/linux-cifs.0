Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DF9F380FCA;
	Sat, 17 Oct 2026 16:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253454; cv=none; b=nil7PTy2N0vfzbWTpapdNQ7Fa46IUVJuP0tpAlKh5/GhB2uTnEgwDs9eKjEEE2HuggOkx9fnPLClmqFhFV3AEQmoRiXlAay3DyPVZM4YcFquTLQjRkVGrWhemM0wApcZuiJalImuODKarDSjiEFvHygqGjlSUbEwOWMtVod6P7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253454; c=relaxed/simple;
	bh=Uoe+zLEqJM3V3bZNq2c5nUBLzJVA9JILgZU731hPRXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qG2A5700iSGLz+io6OVBPJVf8aqMw+uJ4zJ+xoKtjfg5dGcHMrxzaRS/oKn+GJbM9Fvplc9IBxUgrwxiDQr0qV/Cuq5ZlYAJEj7UAJtW7TNgS/8G3epSY6ZWGUCtXQ8bk80Sc7nWsXymNm1B3NVqvwru+087NYJbVdBdJHn1YPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UA1rPon7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UA1rPon7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DADA1F000C4;
	Sat, 17 Oct 2026 16:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253453;
	bh=iEhhytkcpKvki31qGDJNoT766RU94OA+Kdr4WDHFi6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UA1rPon7vC1+6yEKGy9kt/L3tjnEIY1qGWUb5kGWn+3inTQsbp55C7AF/rBYoCG9S
	 BDE85MBo43Iz7xKdZIdmhqPVlmmz5JML0UW8j1i+/PvGjGrz0t2UFfZyaJ+jJLetWV
	 m3tosTRymeRVQYlQwg51WeNOdJ12o8FFIMakT6Vg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Stefan Metzmacher <metze@samba.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 124/869] smb: client: let recv_done verify data_offset, data_length and remaining_data_length
Date: Sat, 17 Oct 2026 17:49:25 +0200
Message-ID: <20261017160040.219693474@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
User-Agent: quilt/0.69
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

[ Upstream commit f57e53ea252363234f86674db475839e5b87102e ]

This is inspired by the related server fixes.

Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Fixes: f198186aa9bb ("CIFS: SMBD: Establish SMB Direct connection")
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smbdirect.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 07f71a9481a36..c4c1435e8114f 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -460,7 +460,10 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 	struct smbd_response *response =
 		container_of(wc->wr_cqe, struct smbd_response, cqe);
 	struct smbd_connection *info = response->info;
-	int data_length = 0;
+	struct smbdirect_socket_parameters *sp = &info->socket.parameters;
+	u32 data_offset = 0;
+	u32 data_length = 0;
+	u32 remaining_data_length = 0;
 
 	log_rdma_recv(INFO, "response=0x%p type=%d wc status=%d wc opcode %d byte_len=%d pkey_index=%u\n",
 		      response, response->type, wc->status, wc->opcode,
@@ -492,7 +495,22 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 	/* SMBD data transfer packet */
 	case SMBD_TRANSFER_DATA:
 		data_transfer = smbd_response_payload(response);
+
+		if (wc->byte_len <
+		    offsetof(struct smbdirect_data_transfer, padding))
+			goto error;
+
+		remaining_data_length = le32_to_cpu(data_transfer->remaining_data_length);
+		data_offset = le32_to_cpu(data_transfer->data_offset);
 		data_length = le32_to_cpu(data_transfer->data_length);
+		if (wc->byte_len < data_offset ||
+		    (u64)wc->byte_len < (u64)data_offset + data_length)
+			goto error;
+
+		if (remaining_data_length > sp->max_fragmented_recv_size ||
+		    data_length > sp->max_fragmented_recv_size ||
+		    (u64)remaining_data_length + (u64)data_length > (u64)sp->max_fragmented_recv_size)
+			goto error;
 
 		if (data_length) {
 			if (info->full_packet_received)
-- 
2.53.0



