Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E255A3254B4
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 14:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764080536; cv=none; b=Gaghr6J84entbpSLE6pgNkzO8YeuH95Og5rlKovsf7xXR9tRL+LUtXY6cT1fxa2Y2eQ9DTe+7tvewU0EOPq/3fh42+SQpeU+c4Ois9+nQKkjrJdcKgjLiN8n4halfJYioD8rv6AS6h+Aq+yjIF9PN6FtfNYdqps+A/cBPjbBOqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764080536; c=relaxed/simple;
	bh=tcBcw23MLkZvyACyF285nlNGJ0yppijJkckhPBfDZ4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eqlm1rIVm1GVjGt9uM40C1dPRNNpyt+xocS6LujqW/QyPKEgx5Td4qYyvcYuFI5gogtNu9uPLRkeKhGRsBP4cY+VL0jZx7AAwVvsACQ8qSuMnLO+CRCTedS5p2JZQbEtzLgk1dh1QFm/HfXRFY3D3ax6LgznWNwtf5eYm0izwU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=kXEEN4tV; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="kXEEN4tV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=D/JkWB35XQsNbHhZFKGF3tXGeza4iw8+rQmW/843H1k=; b=kXEEN4tVgQ9WqwSGIvLLZ9GN/6
	tBA72E9C02zy1D27B+AaYPCPzkiGtq9OGuUltJGtG2f0hJTd3yfHct6KJh+hp0rHwgBlTC22pzjxp
	ytA2iWXRbkN4qYOnITX92nEULRPmWfq8h065H+tjogBps8FwVnjwsjHz+BBL0MYdmZgqjMepYcCOp
	3QpsMLB8tpDoQdqV78I9nopb/20NVT3fGLp5lS3iFwtx7VDO+kquMJWispWV62MDZVRhUiNg5husu
	9y0JRDdlO11czZCgIUIvMn6u4kcJHZckwDcDbyV8ic33RbyjvB8OptOggC6LbSrdya0xBNN3OQOUM
	ZL4b0DOnKetlo0pRV+JJXoWl+CuTMJqMSUfMoD9pSEurFdwjlE748sZCcBnxsDgxhkYPUfxbGy3r3
	0DPkn8gZLe0UXsxy1tqO3rfcwkfrqKaB10G5MuDqOCGPy8G8+ol4kaIZaR3if29dOIziLESy/ckSv
	/4o0vb6Ovx+9d0B44QHDaDZ9;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNtvi-00FatA-1n;
	Tue, 25 Nov 2025 14:22:06 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v3 1/4] smb: smbdirect: introduce SMBDIRECT_DEBUG_ERR_PTR() helper
Date: Tue, 25 Nov 2025 15:21:51 +0100
Message-ID: <bfe7fd13d3e532a615b3d7855edf585a7c4eefc8.1764080338.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1764080338.git.metze@samba.org>
References: <cover.1764080338.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This can be used like this:

  int err = somefunc();
  pr_warn("err=%1pe\n", SMBDIRECT_DEBUG_ERR_PTR(err));

This will be used in the following fixes in order
to be prepared to identify real world problems
more easily.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Paulo Alcantara <pc@manguebit.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/common/smbdirect/smbdirect_socket.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_socket.h b/fs/smb/common/smbdirect/smbdirect_socket.h
index ee5a90d691c8..611986827a5e 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.h
+++ b/fs/smb/common/smbdirect/smbdirect_socket.h
@@ -74,6 +74,19 @@ const char *smbdirect_socket_status_string(enum smbdirect_socket_status status)
 	return "<unknown>";
 }
 
+/*
+ * This can be used with %1pe to print errors as strings or '0'
+ * And it avoids warnings like: warn: passing zero to 'ERR_PTR'
+ * from smatch -p=kernel --pedantic
+ */
+static __always_inline
+const void * __must_check SMBDIRECT_DEBUG_ERR_PTR(long error)
+{
+	if (error == 0)
+		return NULL;
+	return ERR_PTR(error);
+}
+
 enum smbdirect_keepalive_status {
 	SMBDIRECT_KEEPALIVE_NONE,
 	SMBDIRECT_KEEPALIVE_PENDING,
-- 
2.43.0

