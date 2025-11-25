Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1AED202963
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 17:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764093598; cv=none; b=V5xONIoGl+wVryiHxiBxlwDIdcmgT7tQ1Qqdr/x1DED1ugIDSTI5vArUezYdqh2QpFUmMVAmXmLB5PNU0rErd7aCSnD6xXkpCP5YM7bPwlQnyqw8+kiVavyz8Z8Brul/g+rA3dzchnlfuiYaWRPzhejmb0qVa1sx0qpQ917+z0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764093598; c=relaxed/simple;
	bh=VRByI23ym+BbXvYOsRsDD9725FxBnXP0LOTnq2nHm9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PosoD1mM9RCFhQ+K7P8FWPuJWi7lsNp0DBKg5ulevEZqI6BtVBR8OvfC6179f4FesggSMkBZDH3TQjO2aF4Mcf9kFGXhKDea0g++EuG/5AQkSPbuKKGtxTLIbWiOebrzH9Q/rb6vuWpnqh1ymLx0MT4DiBHOP3CpAkAesrkvM98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=uEVKLoda; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="uEVKLoda"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=Ouu9OqeY5hrf0ivd9FFmXgodcF2fguTRVOP0wBn9uE8=; b=uEVKLodaYhAW6A6ooS7FwhM3Oj
	/AutBe7RsRW05izeTbZYBjiXhFMFkNKL9Bj4TcPkqDwgT9KxnVla17a+PKecLQNPeLlrP3Gbot54L
	YjwacfqHqs6t7dGabUGOQy0+N4KXhXCOKGA/9VAW/uSRlrIoyqTwoS/TeHGAoN8WB2UE/uMsizNG9
	VnKckRIv7rItmkbsfSkss+n+Yz9zzv2ObRna1+TQKZWaU9nC2OxpNnUjiDmQjmWzEYJBAUwqgK++P
	kkXdWOywEUdzS141tx9A0Gsf69QitNVelAfPFXnl9ym72dT4XpAzzialglw1tq2d31oREmpzmB1Qn
	8QaoL/yZEUmf5gITxLS1zU3FImz6YbHK5e4o2vfvFkgl1wRVapW20afR5iLDQGzgFBbypzZ3jgh8D
	DeocXkJFy7haJKloxoB317xcYzlDuxlYqjRE9fU4pS8VzoSVJcfrbmEuslCaSyyefJI3L7hWsroY2
	/81Z/7NEQHkZZ39vnQYWav07;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxKR-00Fcyu-0j;
	Tue, 25 Nov 2025 17:59:51 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 032/145] smb: smbdirect: introduce smbdirect_get_buf_page_count()
Date: Tue, 25 Nov 2025 18:54:38 +0100
Message-ID: <379a160360afef2a77e9dab9d45723e077a1ab10.1764091285.git.metze@samba.org>
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

This is a copy of get_buf_page_count() in the server
and will replace it soon.

The only difference is that we now use size_t instead
of int.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/common/smbdirect/smbdirect_socket.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_socket.h b/fs/smb/common/smbdirect/smbdirect_socket.h
index 66582847530c..3a10e688a762 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.h
+++ b/fs/smb/common/smbdirect/smbdirect_socket.h
@@ -712,4 +712,10 @@ struct smbdirect_rw_io {
 	struct scatterlist sg_list[];
 };
 
+static inline size_t smbdirect_get_buf_page_count(const void *buf, size_t size)
+{
+	return DIV_ROUND_UP((uintptr_t)buf + size, PAGE_SIZE) -
+		(uintptr_t)buf / PAGE_SIZE;
+}
+
 #endif /* __FS_SMB_COMMON_SMBDIRECT_SMBDIRECT_SOCKET_H__ */
-- 
2.43.0

