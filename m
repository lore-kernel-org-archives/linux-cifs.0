Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E4B4326951
	for <linux-cifs@vger.kernel.org>; Sat, 17 Oct 2026 01:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792199073; cv=none; b=oAjU+nzdpnLXTD9CdB980+/kMtDeQ/mkJgMwSn0tyRvN6fL3aZCx/NDLX+pUElmedVzHqZjhIVVrFjKVWpgBFKbeT+a00CNBBLiyBTjB8cQo65VNzj75abgOPZQjurgxexiHmUlK8nsrzTqGmpu8iR5v4YLwdhGaXsWfvfdh1Tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792199073; c=relaxed/simple;
	bh=yzX2IkZvjhm7fNg1wq+jnTYkNwqeGXs/RZDXy8GAeCM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sj76H1QMY4hgIUK4MYRwK3XndbcKWm1pTxH0DbcPKwCKNqHYYaXGywuPXuRPCCSXvTPi3A2tMBkmLCNMTq4UZf3Y+00F7jZpujGj89ogrx09nHC0ScMvMESCoCpj35EZiaGIozMngL7vf7wJJfIuacAPQsCs4BM8D0+oH+pmF2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OGyB1mzP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OGyB1mzP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F6851F000C5;
	Sat, 17 Oct 2026 01:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792199072;
	bh=0BARvTh+Gf1ljgIJuZ0OsDyfL+kSU0Sp1nhQE6YPy0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OGyB1mzPQV8ZobqgwMX8WRBHz16vy3E7vgNbPYv5K46OtgaXCm+Wm1QPebyNcxNvm
	 VAyCQRGTQjJpFS2SmdkroizHTX6fbMRseBfd54g3AEuPrpfY7YBTETiAGPeRVyKpQL
	 Wonaf4TRZ4V43uHsWnz6e8tpYVT4zORFF/+k4H8Qg6WUdpOHuLScpOGEk6DtFFO4MG
	 fc8X/sDFwY3rAu5TmljroQQlhpT1OHezG/zvmhyF266P3EgnwuP/8ALjrTkerZihQs
	 +QOvfT9ChhrIvHje/CzNe8O5o+zqkYCZ3jfkm3XwXLppm4WNlQec6J5hLvIp0CeDch
	 TVChQ66/CjEbQ==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	chenxiaosong@chenxiaosong.com,
	chenxiaosong@kylinos.cn,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 15/22] ksmbd: apply byte-range lock checks per open
Date: Sat, 17 Oct 2026 10:03:37 +0900
Message-Id: <20261017010344.11478-15-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261017010344.11478-1-linkinjeon@kernel.org>
References: <20261017010344.11478-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Using the tree's POSIX extension flag to skip byte-range lock checks
also skips them for ordinary opens on a POSIX-enabled tree.

Base the read and write lock checks on each file's POSIX create context
instead.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/vfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index f917f6aeb84d..de08e63a7794 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -362,7 +362,7 @@ int ksmbd_vfs_read(struct ksmbd_work *work, struct ksmbd_file *fp, size_t count,
 	if (ksmbd_stream_fd(fp))
 		return ksmbd_vfs_stream_read(fp, rbuf, pos, count);
 
-	if (!work->tcon->posix_extensions) {
+	if (!fp->is_posix_ctxt) {
 		int ret;
 
 		ret = check_lock_range(filp, *pos, *pos + count - 1, READ);
@@ -547,7 +547,7 @@ int ksmbd_vfs_write(struct ksmbd_work *work, struct ksmbd_file *fp,
 		goto out;
 	}
 
-	if (!work->tcon->posix_extensions) {
+	if (!fp->is_posix_ctxt) {
 		err = check_lock_range(filp, *pos, *pos + count - 1, WRITE);
 		if (err) {
 			pr_err("unable to write due to lock\n");
-- 
2.25.1

