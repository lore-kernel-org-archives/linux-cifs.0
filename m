Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED9491547CC;
	Mon, 22 Sep 2025 19:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570420; cv=none; b=P2qx5MYzCovrJ8fIFHURejZV688/VTKwzyoELDf9PAPBTXjCmKrjWIaG6aXfoCFd8lUyR9UI5EozQQmRY2xZAumBbE9q4kGkm3E72Ml15+wU7Efuc4d7auGEamOq1Xlalh1en+Tw6f/Eq4HgvXddx1ZnjugpirSaTWJ2J24QsVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570420; c=relaxed/simple;
	bh=tvoSxf6hdtkwBNE9TpWwI9JJokdMMOiXgW7lSDeqwl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lc7QKg/+4WYu3DiG44NanhC2lKe4vKYdys4pnwgexr3lKOBM89v1cnYLHcuNNhVyqyFW5yJQJ2vgU3Jroe8JlUPBNk3fSC9u0ImsANHrIekNDKxZByUpr257Orl4WH62dlgCOhi8IfzbJPLvrp1HUMJeOBNNLyobXnX2FsLAmdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dMHmqrxr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dMHmqrxr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85532C4CEF0;
	Mon, 22 Sep 2025 19:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570419;
	bh=tvoSxf6hdtkwBNE9TpWwI9JJokdMMOiXgW7lSDeqwl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dMHmqrxri4BdZqHh2jcu8WujmPNPhdjs8XoI/Gmm7nEhzLM2o7hyJLOfc7h8DyROc
	 poJ0UH+C7USjY97FvCg9aI3KWQybPrUij+4sq5AP0HLjWKlKvK0aGx3v5ZBLf6mAQ7
	 RBAnGAUq78z6i97Vn00hGH/J/XWS25AH4gmNl+Dk=
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
Subject: [PATCH 6.16 130/149] smb: client: let recv_done verify data_offset, data_length and remaining_data_length
Date: Mon, 22 Sep 2025 21:30:30 +0200
Message-ID: <20250922192416.152368551@linuxfoundation.org>
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
index 18702c67c8484..65175ac3d8418 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -446,9 +446,12 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 	struct smbdirect_recv_io *response =
 		container_of(wc->wr_cqe, struct smbdirect_recv_io, cqe);
 	struct smbdirect_socket *sc = response->socket;
+	struct smbdirect_socket_parameters *sp = &sc->parameters;
 	struct smbd_connection *info =
 		container_of(sc, struct smbd_connection, socket);
-	int data_length = 0;
+	u32 data_offset = 0;
+	u32 data_length = 0;
+	u32 remaining_data_length = 0;
 
 	log_rdma_recv(INFO, "response=0x%p type=%d wc status=%d wc opcode %d byte_len=%d pkey_index=%u\n",
 		      response, sc->recv_io.expected, wc->status, wc->opcode,
@@ -480,7 +483,22 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 	/* SMBD data transfer packet */
 	case SMBDIRECT_EXPECT_DATA_TRANSFER:
 		data_transfer = smbdirect_recv_io_payload(response);
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
2.51.0



