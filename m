Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92B4F1F16B;
	Sat, 17 Oct 2026 17:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258151; cv=none; b=fc1X1wAgecZ8cKQvESd2Bg266YlRCvg4RNcqvMH2LWbhvt3iDmp9sOlBsRsYt4uck2w9nZRarho4bXubMcNedNZKy/PhrWTBYgn6X/c/pC6tgFhFHR8FYstzv684dUeH5yq0duI8v/Auc3dSGgFIfkssfpN63KwSrXrBeZHdx1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258151; c=relaxed/simple;
	bh=HXdbwhT2S/4HhN2HunFr5ZFlA1AZBs4LLShxf6zFmRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c1v40k/h/geLo3TQzIC8aNfvTIknksrJG4FaTdPUahtikCVBAkgRF1M4W1wy7kB2qGJ/M/qjlZ5Rem9JxYiP/gZfwAumCs47sVrx4ww4qYOq+FKZQf8x5fXSmWy763hypvUg+5o1sQ4T5TO/O/l5Goud8scvGFnJNviRCqdRPQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yeysZP55; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yeysZP55"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F06DA1F000C4;
	Sat, 17 Oct 2026 17:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258150;
	bh=OxUHcoFzPsDp6qlaG53MUFmGtbJnOg6gqliI+iDvNUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yeysZP55UGArUH8wfBMeunRtSflIUbHvXH0ipE6zqIm+MSpI3eyMUWcXEEpb5fKbO
	 QuwvNBB2owww6CPm6H4CvrAYTZsy3DvWTCwHU3YCE18RcPZxFo7i6HvNAnH0RxKD0q
	 yVsF4IxZxAtqRf2K/Y+667WZWEodXZ2vPQERO1Fg=
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
Subject: [PATCH 6.6 0788/1674] smb: client: let recv_done verify data_offset, data_length and remaining_data_length
Date: Sat, 17 Oct 2026 17:51:00 +0200
Message-ID: <20261017160451.329969222@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 fs/smb/client/smbdirect.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 359ab64e17d99..5b99ea2f5728f 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -473,7 +473,9 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 	struct smbd_response *response =
 		container_of(wc->wr_cqe, struct smbd_response, cqe);
 	struct smbd_connection *info = response->info;
-	int data_length = 0;
+	u32 data_offset = 0;
+	u32 data_length = 0;
+	u32 remaining_data_length = 0;
 
 	log_rdma_recv(INFO, "response=0x%p type=%d wc status=%d wc opcode %d byte_len=%d pkey_index=%u\n",
 		      response, response->type, wc->status, wc->opcode,
@@ -505,7 +507,22 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 	/* SMBD data transfer packet */
 	case SMBD_TRANSFER_DATA:
 		data_transfer = smbd_response_payload(response);
+
+		if (wc->byte_len <
+		    offsetof(struct smbd_data_transfer, padding))
+			goto error;
+
+		remaining_data_length = le32_to_cpu(data_transfer->remaining_data_length);
+		data_offset = le32_to_cpu(data_transfer->data_offset);
 		data_length = le32_to_cpu(data_transfer->data_length);
+		if (wc->byte_len < data_offset ||
+		    (u64)wc->byte_len < (u64)data_offset + data_length)
+			goto error;
+
+		if (remaining_data_length > info->max_fragmented_recv_size ||
+		    data_length > info->max_fragmented_recv_size ||
+		    (u64)remaining_data_length + (u64)data_length > (u64)info->max_fragmented_recv_size)
+			goto error;
 
 		/*
 		 * If this is a packet with data playload place the data in
-- 
2.53.0



