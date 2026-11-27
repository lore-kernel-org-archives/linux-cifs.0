Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=144.76.82.148
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795798157;
	b=xQGc5HjwSsRY2KmCdJimdggB0oFhuyAdyuYPAWu3OhvwXWLFW6etoBDiir2sG73dbs/5
	 ggrlpEVsYVDT9uWNthtf4d9UTEeGpctWGj238l2NRRdJELNWDVITKfvg4rHgD04wi5pjI
	 ipyzAc/ZGXlmDxLVVMqR19B0jAJHMj7xQM1HlA2zM2f6YSUL3g7T5c7oj2lMHgwUXRZKn
	 UYBM6SB8OJz2PjVsIbCN9BlI1R5+o21pRwaNIcw9xt8fhNgOGdC2g0E8vdVBgsXFlU4uO
	 sZVIELPA/J4LCE/SS0O7Jt4b5WW9NGKakfp9oi80hI6AK3JzoJD2Rz2fA7kopjuvqSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795798157;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=KMwYeapWiodhxqWdI6xZqU4JLeaoB+JEzzs7Bsry0CQ=;
	b=bNCM9BQfs9LnPWpbOEIhDc2ExkEngo3WdMTwZquzWjmQWHT43TcHJlBQBuZYEp45sVOU
	 SB+UWQKpZ1UHa0AwsFAFDuDl3HDweAShLpb0WoiMiUdpM37Xuv/tVABECOd+fMpPRF1a4
	 UxNkld2PCV+OOBhLmrwFNUKcP8NXwjeO7Xn+InBjBwolVVBwK47mSokE12lD7XPyCBXWH
	 OVTrc8gA8xDZEVU1GTJQDl+RrxCjNEzmULBvnUuL18zaa9dOiWqxQPp0TFU0mucARFFpB
	 ZS+97WyT219uvYXwi1Dw5OD4YCpTPrFfIODuh9e4yhIddXAnMu0BhI5XZ1MsVpAKMkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samba.org;
	spf=pass smtp.mailfrom=samba.org;
	dkim=pass header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=Du8zWnQw;
	arc=none smtp.remote-ip=144.76.82.148
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.3 with cipher TLS_CHACHA20_POLY1305_SHA256 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FD39606A31C;
	Fri, 27 Nov 2026 16:49:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2FD39606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=Du8zWnQw
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=KMwYeapWiodhxqWdI6xZqU4JLeaoB+JEzzs7Bsry0CQ=; b=Du8zWnQw4GDLBtgK2REAV9OcYH
	w9Lih9AhvDQIrFRMgjBYlTTgNtVxsxMFF9v8upxczfmiO18W2dgCEXIR6HoXHR1M6hUkzVLlld4w1
	mfCIzh12XTcXWgLqg4YEMF7ZlEpeW1BI+e2pHExoZXpm/lfGBvmb+JHxk/FeoPrS06V4at+SluW1o
	EaEFszeV/750mrgIqs63Mzv5rQHgwB59Ta91JfwOrQc6JDUw4kJEYQwj5gMNud78hRR5ufQDEdVP3
	8/g/2MBEVe5PmD3yL0PHwBr3pMsGh6fm8ZlChTJhKc7eWcWqZokqSu/Neo5vDrWbbQrgGAlAfPuxV
	0Dv6pJ0uQl641Ge+0vObCmmumJCnmuKACfkfDAsYzavhO0tUDyh6R0ZkLrWg1BeW1UeWWuJQBGFtb
	AD8QtCKcomUu/xKSPMojSwSVHFP5mg+fnL5Ys79rQBqTUCPb3EG2qnD3NoVD+AvUKugcHM/wv7WZ4
	Iv5eDD/e/B7Xn3bvxfpxEQ9d;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1xWz8M-00000001QY7-2eEC;
	Fri, 27 Nov 2026 16:49:14 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	stable@vger.kernel.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH 2/2] smb: server: don't leak the smbdirect listener socket on errors
Date: Fri, 27 Nov 2026 17:48:59 +0100
Message-ID: <17d7f96be20a7eb039cbb3833598f634d786a487.1795797772.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1795797772.git.metze@samba.org>
References: <cover.1795797772.git.metze@samba.org>
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

smb_direct_listen() only assigned listener->socket after
smbdirect_socket_listen() succeeded. If setting the parameters,
binding (e.g. -EADDRINUSE) or listening failed, the error path called
smb_direct_listener_destroy() with listener->socket still NULL, so the
socket and its rdma cm id were never released.

Assign listener->socket right after the socket is created, so
smb_direct_listener_destroy() releases it on all error paths.

Fixes: 2eff5e51f976 ("smb: server: make use of smbdirect_socket_{listen,accept}()")
Cc: stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Tom Talpey <tom@talpey.com>
Cc: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: linux-cifs@vger.kernel.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/bug/linux-983b1ca6-9d6c-4aab-bcc6-2909770bdced
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/transport_rdma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index ee28a4d1cc86..8f44e5c3c373 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -418,6 +418,7 @@ static int smb_direct_listen(struct smb_direct_listener *listener,
 		       ret, ERR_PTR(ret));
 		return ret;
 	}
+	listener->socket = sc;
 
 	/*
 	 * Create the initial parameters
@@ -467,7 +468,6 @@ static int smb_direct_listen(struct smb_direct_listener *listener,
 	}
 
 	listener->port = port;
-	listener->socket = sc;
 
 	kthread = kthread_run(smb_direct_listener_kthread_fn,
 			      listener,
-- 
2.43.0

