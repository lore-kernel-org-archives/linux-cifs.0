Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF6F1F1932
	for <linux-cifs@vger.kernel.org>; Wed,  8 Jul 2026 02:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783479407; cv=none; b=bMOjJYUdfelUYigkjZMVlRDMxFW3+VMuKnwAUhxyS/x5OHTOI8qB6Uv0sMdUvfhSSABJkfRUj3Q8HGT4VTw5SUObNNrI0LkqoLWtHfGCEs4Wew+u2Pq22nEX36OXsPG/PUhrkbZGYqELuLH51Are8qEQnWQiixSACtOaRxnUDho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783479407; c=relaxed/simple;
	bh=K6r02tFtSkvNac6uI19dj/l6WLGOKbiq/3Qocq9TjcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qprKqAI3lZN0lMT2Mo1EDklnAkJvaqeSS5MfCgc46W9+c/oTNXv7mIj8b2zlpGgd6UA/wNxM+u1zgtl1JSoB18BYDsWm18Vzhx/eOs/sRngV3AD6i/dY72K6e/HUlRIsFtq2FgD9rCLPWBdVyF6ST5YTi8OXxa15Zg2kjedzeHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=blEIJnUg; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="blEIJnUg"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1783479401;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7QImQ0FX64csu6+wZdZMvdxu980lEIWjQwLCS5KlRjM=;
	b=blEIJnUgcn/HWKzJ1wG/AP/HCP0QSyOEFdSlaer5g6hTfu4muMRWH6dGP9Se8t42h7XhXE
	AaegVNawczigOU0F83jGz/UAcCJ3f3bgGAJ04yANi8+vEP6us3uVwkusk2a6Rvp8he7Otq
	cT7MqId9wDkA2xTgpErlgGfLRiOSiwwMzHvnI+m3hUwFv7QpWXxcNBDpOQ55s0DVoPkAck
	hQnQGNqiOsSmzv0YCmy3HOz38v1zR39iFucTR/HBxJit9eavQiQHS5Uq2/WXbrgAoQV1FV
	xanlRe7Esao+uS1ygafQqXKcF6p0JxSVeT9JTxNL/pHUouQB0P9FkoyrF6ijrg==
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	metze@samba.org
Cc: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v2 1/3] smb/server: send compound prefix before async pending response
Date: Wed,  8 Jul 2026 02:56:13 +0000
Message-ID: <20260708025615.145390-2-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260708025615.145390-1-chenxiaosong@chenxiaosong.com>
References: <20260708025615.145390-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

When the last request in a compound request becomes async, ksmbd sends a
STATUS_PENDING response for it. But the responses for previous requests in
the same compound request are still kept in the same response buffer.

Send these previous responses first. Clear NextCommand for the last
response in this part, sign it again if needed, and reset the iov state.
After that, the async request sends STATUS_PENDING first, and sends the
real response later. Both are separate responses.

Example:

  smbtorture //${server_ip}/export -U${username}%${password} smb2.compound_async.write_write

  Client request:

    Write Request Len:64 Off:0, File: compound_async_write_write; Write Request Len:64 Off:64

  Before this patch, STATUS_PENDING Write Response is the first of
  several responses:

    Write Response, Error: STATUS_PENDING
    Write Response, File: compound_async_write_write; Write Response

  But STATUS_PENDING Write Response should be in the middle of several
  responses, after this patch:

    Write Response, File: compound_async_write_write
    Write Response
      SMB2, STATUS_PENDING, Write Response, MessageId 7
      SMB2, Write Response, MessageId 7

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/smb2pdu.c | 45 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 0ab05a8e575e..35f8476bbb6d 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -839,6 +839,48 @@ void release_async_work(struct ksmbd_work *work)
 	}
 }
 
+static void smb2_send_interim_compound_prefix(struct ksmbd_work *work)
+{
+	struct smb2_hdr *req_hdr;
+	struct smb2_hdr *rsp_hdr;
+	int err;
+
+	if (!work->next_smb2_rcv_hdr_off ||
+	    !work->next_smb2_rsp_hdr_off ||
+	    work->curr_smb2_rsp_hdr_off == work->next_smb2_rsp_hdr_off ||
+	    !work->iov_idx)
+		return;
+
+	req_hdr = ksmbd_req_buf_next(work);
+	/* Detach only the final async command from the completed prefix. */
+	if (req_hdr->NextCommand)
+		return;
+
+	/*
+	 * The responses before the async command are sent as a standalone
+	 * compound response. The last response in this prefix must terminate
+	 * the chain.
+	 */
+	rsp_hdr = ksmbd_resp_buf_curr(work);
+	rsp_hdr->NextCommand = 0;
+	if ((rsp_hdr->Flags & SMB2_FLAGS_SIGNED) && work->sess &&
+	    work->conn->ops->set_sign_rsp)
+		work->conn->ops->set_sign_rsp(work);
+
+	err = ksmbd_conn_write(work);
+	if (err)
+		ksmbd_debug(SMB, "failed to send compound interim prefix: %d\n",
+			    err);
+
+	work->iov_idx = 0;
+	work->iov_cnt = 0;
+	work->curr_smb2_rsp_hdr_off = work->next_smb2_rsp_hdr_off;
+	*(__be32 *)work->response_buf = 0;
+
+	rsp_hdr = ksmbd_resp_buf_next(work);
+	rsp_hdr->Flags &= ~SMB2_FLAGS_RELATED_OPERATIONS;
+}
+
 void smb2_send_interim_resp(struct ksmbd_work *work, __le32 status)
 {
 	struct smb2_hdr *rsp_hdr;
@@ -853,6 +895,9 @@ void smb2_send_interim_resp(struct ksmbd_work *work, __le32 status)
 		return;
 	}
 
+	if (status == STATUS_PENDING)
+		smb2_send_interim_compound_prefix(work);
+
 	in_work->conn = work->conn;
 	memcpy(smb_get_msg(in_work->response_buf), ksmbd_resp_buf_next(work),
 	       __SMB2_HEADER_STRUCTURE_SIZE);
-- 
2.54.0

