Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214414;
	b=gnsGDAOltzub5x0GS9n30gBkecIHq3KpD9v/VFvv/F7h58tvmNhCwvozza0mwU0OKENG
	 PpE6roHOcCj3CTSUl8WgfdQZT1hkgmQZZhKQ3qSKEFRVWxz/Ue4b/jUCIIoK6pTAUtUx4
	 GsRMr6EHbKzMJkaAsGZvqWA57nc7vFPpNjhq7DvY4FmBKnXkIUChBtAdO776b2TU2nTkT
	 MvpQ+78KSBzH57TOK7cXf7ALorZCVCvWKxSGQ79/W2ruhQ8EsBA60o1Nt+JmSLX+/vO63
	 hqq5hg5gV9HkY+Wpt3s5VwHStYcYAl1tL652RI2t9UwF83shLx+DaQmb6frvwFAA30Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214414;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4SuUF347RMeyDJu4+ND5cOc3hNZ3owVgOjoODkqI22A=;
	b=5drb0FvhtmTumSh+0HC6S0qrUBt6GRoA/85QbxMTgP7XIYZ/8bdC9FOBb0Oc/KwU0l1A
	 Vkbwn3Fi8H/nPhBAAk6M0l4h9w8R9cpPnNB1EsyfqwcG5wFulDQUBcWcgroyzwwY0z9jA
	 vhzPw73i+O75eLBP5g9KD1oiV9tOfMLXqDLYETsfl8FWrwVqLQ0w+5Gxg48GTY8e5qMN5
	 e2mdKascxOAQyKCIL4RlT666EOgZNae5D7a48Rq2aVZaWryV0QB/x4+brnolfe0YOg0Uq
	 JBm5KBXz1pSjUsoWkmUIQR0jh53sLWA0A06Bu8fFsxUgCcYPAK7buvHIEJbHzql0+dg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1O6TPbzR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C330D606A31F;
	Wed, 28 Oct 2026 19:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1O6TPbzR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E62FC1F01825;
	Wed, 28 Oct 2026 19:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214413;
	bh=4SuUF347RMeyDJu4+ND5cOc3hNZ3owVgOjoODkqI22A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1O6TPbzRxksiiGl2+5DQhyfoRZVVVH90JCMl0sq9PCkLGnAhwuO1X+tltS9hQdi/z
	 Sfwftm82/63qBt1kQb85tTPJe9ic/oAO2btkgR8eqxcp1JMHGuAsxKwllgpjsyaEFI
	 WxvxtlIgodm6iMmnYuKubhANkorJAh9L6hHA5/5Y=
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
Subject: [PATCH 6.1 0848/1887] smb: client: let recv_done verify data_offset, data_length and remaining_data_length
Date: Wed, 28 Oct 2026 17:49:04 +0100
Message-ID: <20261028170518.723554286@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d2878973c1476..894f5ffca909f 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -461,7 +461,9 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 	struct smbd_response *response =
 		container_of(wc->wr_cqe, struct smbd_response, cqe);
 	struct smbd_connection *info = response->info;
-	int data_length = 0;
+	u32 data_offset = 0;
+	u32 data_length = 0;
+	u32 remaining_data_length = 0;
 
 	log_rdma_recv(INFO, "response=0x%p type=%d wc status=%d wc opcode %d byte_len=%d pkey_index=%u\n",
 		      response, response->type, wc->status, wc->opcode,
@@ -493,7 +495,22 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
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



