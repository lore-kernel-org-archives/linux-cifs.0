Received: from va-2-37.ptr.blmpb.com (va-2-37.ptr.blmpb.com [209.127.231.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34912386562
	for <linux-cifs@vger.kernel.org>; Mon, 13 Jul 2026 07:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783926744; cv=none; b=JOfYHMY6HQVNFEIyxXiiRn3pG837gyy7FON1bnXEtpJYY7/hGiWERnvIiEIS3/atEHv/5ZCKk87Ly8hFQyQYBAbXTnIXJhfcZK1dMBZtCzI+1asYCp5X2M/g+lhyLuCGm/CBTBDrJkp6bQsJUSJNxbymlBPWKvyrqPtsW0FhVMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783926744; c=relaxed/simple;
	bh=2nFA8ksd9tCNvD3AMegQgqMCJDUorA1CPovrmmOLUsU=;
	h=From:Date:Message-Id:To:Cc:Mime-Version:In-Reply-To:References:
	 Content-Type:Subject; b=bxDTpWOZAsESNTYKiH588waxBTY4ZziYxvY2X+H4iHjyvlCcYbCxwg3J4kKo078u2xJSFaEyMzVOGPZr0hd6jSMBTKJ5Q/Wp0yuc+sHxoQO2vOGlWFGHpI5LhV+0hByYMmcLq0iG4Y6WznzoQxY1XT0PzhaJHiJBm3lWo45X0ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=3OidMsm4; arc=none smtp.client-ip=209.127.231.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="3OidMsm4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1783926732;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=vTs7L++cZmkN0GWVBWEMa8mxMyPGIfkDisZ9cd21MDs=;
 b=3OidMsm4CN0dsnf3y766rv1MDKBtm2raaPZ1/6ZG2W/U6DMHLFsxKwvqN7LH9OLbM0aCnM
 HCisENl/rEUB9x5G0PqmG97IsOgRpe9Tx4M5v5FKpzfQziiu2yApmaGjsKe5UeSls9CEcE
 +3M0gpJPuaHLAjVAeXNwPGP1gOcXjHzAblr7dK/XOK1iPUQKG4iiYMgiXHcVZwgYD7ruzs
 R1vBa+9hi+NUdbdarG6oLKJgfN8AWC8niyd/WocmMY/t+R3yF9vXQj9wgCQyqXnrZIWNzC
 2YJb0UE7jL/yQJPSWGYa5NM77Xj32Ef8O0m2DcoHfzodgEtlKV5bAEixVLRbSw==
From: "wang zhaolong" <wangzhaolong@fnnas.com>
Date: Mon, 13 Jul 2026 15:11:40 +0800
Message-Id: <20260713071141.3909087-4-wangzhaolong@fnnas.com>
To: <linux-cifs@vger.kernel.org>
Received: from localhost.localdomain ([183.34.174.151]) by smtp.feishu.cn with ESMTPS; Mon, 13 Jul 2026 15:12:09 +0800
X-Lms-Return-Path: <lba+26a548fca+f1541a+vger.kernel.org+wangzhaolong@fnnas.com>
X-Mailer: git-send-email 2.47.3
Cc: <linkinjeon@kernel.org>, <smfrench@gmail.com>, 
	<senozhatsky@chromium.org>, <tom@talpey.com>, 
	<linux-kernel@vger.kernel.org>, "Wang Zhaolong" <wangzhaolong@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
In-Reply-To: <20260713071141.3909087-1-wangzhaolong@fnnas.com>
X-Original-From: wang zhaolong <wangzhaolong@fnnas.com>
References: <20260713071141.3909087-1-wangzhaolong@fnnas.com>
Content-Type: text/plain; charset=UTF-8
Subject: [RFC 3/3] ksmbd: use splice payloads for simple SMB2 READ

From: Wang Zhaolong <wangzhaolong@fnnas.com>

Use the page-backed payload path for plain TCP SMB2 READ requests of at
least 64 KiB. Unsupported collection results fall back before response
ownership is committed; permission, locking and allocation failures retain
the existing error handling.

Keep signed, encrypted, compressed, compound and RDMA requests on the
buffered path because they require signing, response transforms, compound
response layout, or alternate transport handling. Streams, non-regular
files, O_DIRECT and DAX reads also remain on the buffered path.

Signed-off-by: Wang Zhaolong <wangzhaolong@fnnas.com>
---
 fs/smb/server/smb2pdu.c | 67 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 67 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index b73167785e87..a4a80ecc6d2f 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -7304,10 +7304,38 @@ static ssize_t smb2_read_rdma_channel(struct ksmbd_work *work,
 		return err;
 
 	return length;
 }
 
+#define KSMBD_READ_PAYLOAD_MIN_IO_SIZE	SZ_64K
+
+static bool smb2_read_payload_allowed(struct ksmbd_work *work,
+				      struct smb2_read_req *req,
+				      struct ksmbd_file *fp,
+				      size_t length, bool is_rdma_channel)
+{
+	struct ksmbd_conn *conn = work->conn;
+	struct file *filp = fp->filp;
+
+	if (is_rdma_channel || length < KSMBD_READ_PAYLOAD_MIN_IO_SIZE ||
+	    !conn->transport->ops->write_read_payload)
+		return false;
+	if (req->Flags & SMB2_READFLAG_REQUEST_COMPRESSED)
+		return false;
+	if (work->next_smb2_rcv_hdr_off || le32_to_cpu(req->hdr.NextCommand))
+		return false;
+	if (work->encrypted)
+		return false;
+	if (work->sess &&
+	    (work->sess->sign || conn->ops->is_sign_req(work, SMB2_READ_HE)))
+		return false;
+	if (ksmbd_stream_fd(fp) || !S_ISREG(file_inode(filp)->i_mode) ||
+	    (filp->f_flags & O_DIRECT) || IS_DAX(file_inode(filp)))
+		return false;
+	return true;
+}
+
 /**
  * smb2_read() - handler for smb2 read from file
  * @work:	smb work containing read command buffer
  *
  * Return:	0 on success, otherwise error
@@ -7316,10 +7344,11 @@ int smb2_read(struct ksmbd_work *work)
 {
 	struct ksmbd_conn *conn = work->conn;
 	struct smb2_read_req *req;
 	struct smb2_read_rsp *rsp;
 	struct ksmbd_file *fp = NULL;
+	struct ksmbd_read_payload *payload = NULL;
 	loff_t offset;
 	size_t length, mincount;
 	ssize_t nbytes = 0, remain_bytes = 0;
 	int err = 0;
 	bool is_rdma_channel = false, async_interim = false;
@@ -7418,10 +7447,48 @@ int smb2_read(struct ksmbd_work *work)
 	}
 
 	ksmbd_debug(SMB, "filename %pD, offset %lld, len %zu\n",
 		    fp->filp, offset, length);
 
+	if (smb2_read_payload_allowed(work, req, fp, length,
+				      is_rdma_channel)) {
+		nbytes = ksmbd_vfs_read_payload(work, fp, length, &offset,
+						&payload);
+		if (nbytes == -EOPNOTSUPP)
+			goto read_fallback;
+		if (nbytes < 0) {
+			err = nbytes;
+			goto out;
+		}
+		if ((nbytes == 0 && length != 0) || nbytes < mincount) {
+			ksmbd_read_payload_release(payload);
+			rsp->hdr.Status = STATUS_END_OF_FILE;
+			smb2_set_err_rsp(work);
+			ksmbd_fd_put(work, fp);
+			return -ENODATA;
+		}
+
+		rsp->StructureSize = cpu_to_le16(17);
+		rsp->DataOffset = 80;
+		rsp->Reserved = 0;
+		rsp->DataLength = cpu_to_le32(nbytes);
+		rsp->DataRemaining = 0;
+		rsp->Flags = 0;
+		err = ksmbd_iov_pin_rsp_read_payload(work, rsp,
+						     offsetof(struct smb2_read_rsp, Buffer),
+						     payload);
+		if (err) {
+			ksmbd_read_payload_release(payload);
+			goto out;
+		}
+		ksmbd_fd_put(work, fp);
+		return 0;
+	}
+
+read_fallback:
+	payload = NULL;
+
 	aux_payload_buf = kvmalloc(ALIGN(length, 8), KSMBD_DEFAULT_GFP);
 	if (!aux_payload_buf) {
 		err = -ENOMEM;
 		goto out;
 	}
-- 
2.47.3
