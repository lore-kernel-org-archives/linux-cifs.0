Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBC2B72621
	for <linux-cifs@vger.kernel.org>; Sun, 21 Jun 2026 12:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782046157; cv=none; b=rIjjVu8lL3UeGwgUxGg3k/qubXpyjXSWSIEB7pntIH8Sai9INke+biON/h7t0tAMYPcqNIDhQqBaMvALZMyOlJt9iaFHMadcDWJ6VMjvDKHI49NYEOLh2AAH2yQFZ2pFiMZ/N3+ux87vxmkuyifkKAu4Ku6pazTgTEL6SHPuWc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782046157; c=relaxed/simple;
	bh=diY5Rr5uxyF9I2wWMWC76CJc4QRyGZdebmYH48Qr7AM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZURpZNZjbFnznIkzfc1scbnkuUAmMHJKvUkSYhitXvAmWe2RJ9mj31UVeVIzvgXwdx5e+PTe0D0MRFAU3q/1EjtorEofl3rB7RGn2Ye9u/xowCz1/d0cXRIvAPtKN5WxEvCSMkoyDd6LyXbnFYsILQCcEU6JmC2O4ectLeyy4+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f90ScvvD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f90ScvvD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC06C1F00A3A;
	Sun, 21 Jun 2026 12:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782046156;
	bh=+vZ7gxjz56TCx2G4C6hhSc2eESi5Ps/XZF1J3Q4YW2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f90ScvvD3sauB/cuUH2hSHv8qQCQZfPaNmf1RwWBjSltnjDftjLLSn96k8UWNPuLB
	 LFi5E4qDfbw3B1KkfsWlk9TdUgEGTDlccedR1aNvnDeOJGNQE2xwvCn9acTfUC5ggI
	 5fGdV18I+EBnKcx3kaKCg4uTKRWuFCUiytsImXPHLhymJSGJQwE/NSoykAHvph2If0
	 /Ny/whTq5QI5ewNeQj3oAfkeJkpxfq8ifX/GHFGMrr6AN4JugBgefM0nia9RaQ8w4z
	 VKwswdnQ4UKiNCGHNXiwqwX0/YaCAoc7GmjEXIkD/ci69PMT8OJXOhuGz+1u8dmQ/C
	 /uD/tSm6/0ZKg==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 13/29] ksmbd: send pending interim for last compound I/O
Date: Sun, 21 Jun 2026 21:48:28 +0900
Message-Id: <20260621124844.6235-13-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260621124844.6235-1-linkinjeon@kernel.org>
References: <20260621124844.6235-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

smb2.compound_async.write_write and smb2.compound_async.read_read expect
the last I/O request in a compound request to become cancellable before
its final response is received. smb clients mark a request cancellable
after receiving an interim STATUS_PENDING response.

ksmbd handled the last READ/WRITE synchronously and returned the final
response directly, so the client never observed STATUS_PENDING and
req->cancel.can_cancel remained false.

For the last READ or WRITE in a compound request, register the work briefly
as async and send a STATUS_PENDING interim response before continuing with
the normal synchronous completion. The final READ/WRITE response remains
unchanged.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb2pdu.c | 30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 35f23b427bd1..cc9cd9297557 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -7176,7 +7176,7 @@ int smb2_read(struct ksmbd_work *work)
 	size_t length, mincount;
 	ssize_t nbytes = 0, remain_bytes = 0;
 	int err = 0;
-	bool is_rdma_channel = false;
+	bool is_rdma_channel = false, async_interim = false;
 	unsigned int max_read_size = conn->vals->max_read_size;
 	unsigned int id = KSMBD_NO_FID, pid = KSMBD_NO_FID;
 	void *aux_payload_buf;
@@ -7248,6 +7248,14 @@ int smb2_read(struct ksmbd_work *work)
 		goto out;
 	}
 
+	if (work->next_smb2_rcv_hdr_off && !req->hdr.NextCommand) {
+		err = setup_async_work(work, NULL, NULL);
+		if (err)
+			goto out;
+		smb2_send_interim_resp(work, STATUS_PENDING);
+		async_interim = true;
+	}
+
 	offset = le64_to_cpu(req->Offset);
 	if (offset < 0) {
 		err = -EINVAL;
@@ -7283,6 +7291,8 @@ int smb2_read(struct ksmbd_work *work)
 		kvfree(aux_payload_buf);
 		rsp->hdr.Status = STATUS_END_OF_FILE;
 		smb2_set_err_rsp(work);
+		if (async_interim)
+			release_async_work(work);
 		ksmbd_fd_put(work, fp);
 		return -ENODATA;
 	}
@@ -7317,6 +7327,8 @@ int smb2_read(struct ksmbd_work *work)
 		kvfree(aux_payload_buf);
 		goto out;
 	}
+	if (async_interim)
+		release_async_work(work);
 	/*
 	 * RDMA responses are transferred through channel buffers and encrypted
 	 * responses use the encryption transform, so only normal SMB transport
@@ -7330,6 +7342,8 @@ int smb2_read(struct ksmbd_work *work)
 	return 0;
 
 out:
+	if (async_interim)
+		release_async_work(work);
 	if (err) {
 		if (err == -EISDIR)
 			rsp->hdr.Status = STATUS_INVALID_DEVICE_REQUEST;
@@ -7465,6 +7479,7 @@ int smb2_write(struct ksmbd_work *work)
 	ssize_t nbytes;
 	char *data_buf;
 	bool writethrough = false, is_rdma_channel = false;
+	bool async_interim = false;
 	int err = 0;
 	unsigned int max_write_size = work->conn->vals->max_write_size;
 	unsigned int id = KSMBD_NO_FID, pid = KSMBD_NO_FID;
@@ -7545,6 +7560,14 @@ int smb2_write(struct ksmbd_work *work)
 		goto out;
 	}
 
+	if (work->next_smb2_rcv_hdr_off && !req->hdr.NextCommand) {
+		err = setup_async_work(work, NULL, NULL);
+		if (err)
+			goto out;
+		smb2_send_interim_resp(work, STATUS_PENDING);
+		async_interim = true;
+	}
+
 	if (length > max_write_size) {
 		ksmbd_debug(SMB, "limiting write size to max size(%u)\n",
 			    max_write_size);
@@ -7593,10 +7616,15 @@ int smb2_write(struct ksmbd_work *work)
 	err = ksmbd_iov_pin_rsp(work, rsp, offsetof(struct smb2_write_rsp, Buffer));
 	if (err)
 		goto out;
+	if (async_interim)
+		release_async_work(work);
 	ksmbd_fd_put(work, fp);
 	return 0;
 
 out:
+	if (async_interim)
+		release_async_work(work);
+
 	if (err == -EAGAIN)
 		rsp->hdr.Status = STATUS_FILE_LOCK_CONFLICT;
 	else if (err == -ENOSPC || err == -EFBIG)
-- 
2.25.1

