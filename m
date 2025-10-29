Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 756E12877F4
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744360; cv=none; b=Q989rpAtdz9oLeJ/3rg+LJUkl2JF1cVGIwfOBn2MCCNNKkB+JedlalW76Jr2ft3ioiwHOJtp7GC0slo0RWCB0zhpuT9SYe/17RCQM9LKfnDDgrqZDH8LGMjW5tvWX5GAjmQM/TRpfN9EFOlROqAEayoGUzzfQkszK0iuvsaGiXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744360; c=relaxed/simple;
	bh=78BLqlfCvg4ZUUcR1nnTh2H0IJNX/CVz2by6tFk0y3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H4kqNg9wbMOVuRSDFv8W8tV49KW4Mvcg9nkxBip+apJtgXd8enwnFu2Lkf3Fz6SqyXt0kQxA8hgocIh2ypoG4r6+ZN8+aeEyQq5sipg4TlyYw4PgOf+nJhKDyWVFS2kYLoDJu/IiINBqqdIpLQsoTqblnXR2g/psaboa7VV5uC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=QeHCZq7w; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="QeHCZq7w"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=pfC+cCjTHct7mk1V52JruYkp2LBY0zWVMoqgwj8Mnc8=; b=QeHCZq7wI0UCEYFE5glOcpZgxf
	4eL5Z8LCfiKdYyhoQgvdzLq3+4PPq02kYN0nWlk30p1Un6moWE2752dhApB8QS3d84UlIglw5wVJo
	G+aaVScbfFuZBU/nApn3ZuesRprO1IfUPta6rPXHuSuAGz3jrARbRnFzQ/RQUbrscW8qeqi1i2uV6
	peXsQv8Ayyob45GFeEAbU+rIDQQoZgQ0VdC/9p2PjCBxiGOJDph0VnQGfGFhx/g8Tr1J8BJlInp54
	Pn7tN1Jj3lhHMrc0t6nd1FguCm1+X3CWCfKMacbEUexSnMvhNnUa1HQNKLxZDt4hUQunCtSC8iqd3
	OLBP2O3N/ssJNHJh2cQ33LhvHlSRVlM++GpyTkGRE6hLcJJRQMOxRAnjpFzHiyKL79xyuhejbwNnW
	eZB5PSQT2AtV4x3aFne1Hm01Ie8pn34tWYGwQD9N4ynIOMWTCFqDUoQnfjagqFTa5a06q9pD11qCj
	nq56N2WURAI8En7WzUHrUY8e;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6BX-00BbhG-1I;
	Wed, 29 Oct 2025 13:25:55 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v2 034/127] smb: smbdirect: define SMBDIRECT_RDMA_CM_[RNR_]RETRY
Date: Wed, 29 Oct 2025 14:20:12 +0100
Message-ID: <389edffd757302120f2adb5a7385eb6d50d9a204.1761742839.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1761742839.git.metze@samba.org>
References: <cover.1761742839.git.metze@samba.org>
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
---
 fs/smb/common/smbdirect/smbdirect_socket.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_socket.h b/fs/smb/common/smbdirect/smbdirect_socket.h
index 14c5d8503fca..795ce4b976ff 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.h
+++ b/fs/smb/common/smbdirect/smbdirect_socket.h
@@ -655,4 +655,13 @@ static inline size_t smbdirect_get_buf_page_count(const void *buf, size_t size)
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

