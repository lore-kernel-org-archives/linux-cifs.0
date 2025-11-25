Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C94392FF144
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764093630; cv=none; b=EvkdFGCgqUOetycRF09Mq1dHMLJoZVG/aVqnGoiDEIXsydsTaW00xjI1oPM1QhPKMDONM517bBU4Sd0f1KFHoSLmlnZP4EfGAYzJYoZ4E2+huJ6QdbkDfs4YzxZNz13YcWbtIxs+bN1MMFzkA5fNByE1lvZSxVxqkb4Uvg36syo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764093630; c=relaxed/simple;
	bh=8qanWDTwY3rPHJNunT9f0tQM/Ly/oIp9ZyZXCIwuOEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ivUJpLOXfVCg8oeVfW5iVDGhfkMPflAXaAde4VIWbBzBFiaVW8Dj7+z/G3FiarwrxL+oTh/JY2R5hdTVXJ/1UPZpAZacbTUkYtUkalOhoyX/31gd3UIvwMovkEOPSngJ6iJLnuL5awXu47F/pCicEvZI5yk1kgLi2NNTCkRDblw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=VOGPsKP4; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="VOGPsKP4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=i/QwXzh3u/bJtSjnuwRoopJdyOv4i1gz17T9dmfSnqE=; b=VOGPsKP4/4SvJ1ah+/52IES3sv
	HWYpCnyIIsPfVqjAyKo8rzNhdrLpw80826mJkSw/EFJSfCq6HVdxrf+a4bHK8CQf84J0T6lrxgiD+
	5FT6hRqAVv29B3JYjy3YXj/2orqqDc54oRhxa5OP5rk6AGyzMcecfqNtYgVlRBxHvMMtJw6WWqnoD
	+oNpPAE3Vbrr7FkO4lm/R89MUMnM04PjUySGBZY1gflfvvzxD+oZd5qSIuLNQROU6FPTn4FiQN2Dz
	7hmaykK4uqb0FdcEyoD+pE2M2PlhRBGOM40msRk1CaJu06SkgunJzWzAhNp+MGzvvCFLX4sdCgMtX
	Yd6V0rssT+fmAWgpj9JSAHIu+j9tU16FyoFYzlJLXirmzUFRL/6Occ0icrsUHrpxkU79X94lc4T6d
	k/hQt0tTCm0FDFqF4ulsuQ7fLLGrNWn8G1S+6Tt4WzSmn9lc2VXKo9v9xZrlbnEYBQUmbQ6k72eoe
	wH/YqS6xRtix5/skiLucvZ6l;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxKw-00Fd3a-2J;
	Tue, 25 Nov 2025 18:00:23 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 037/145] smb: smbdirect: define SMBDIRECT_RDMA_CM_[RNR_]RETRY
Date: Tue, 25 Nov 2025 18:54:43 +0100
Message-ID: <a4cc81b54db30a3606b700742e603a36453ab74a.1764091285.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1764091285.git.metze@samba.org>
References: <cover.1764091285.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These are copies of {SMBD,SMB_DIRECT}_CM_[RNR_]RETRY.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/common/smbdirect/smbdirect_socket.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_socket.h b/fs/smb/common/smbdirect/smbdirect_socket.h
index a0076223daf9..eb9e498c2e2c 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.h
+++ b/fs/smb/common/smbdirect/smbdirect_socket.h
@@ -727,4 +727,13 @@ static inline size_t smbdirect_get_buf_page_count(const void *buf, size_t size)
 		(uintptr_t)buf / PAGE_SIZE;
 }
 
+/*
+ * Maximum number of retries on data transfer operations
+ */
+#define SMBDIRECT_RDMA_CM_RETRY 6
+/*
+ * No need to retry on Receiver Not Ready since SMB_DIRECT manages credits
+ */
+#define SMBDIRECT_RDMA_CM_RNR_RETRY 0
+
 #endif /* __FS_SMB_COMMON_SMBDIRECT_SMBDIRECT_SOCKET_H__ */
-- 
2.43.0

