Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 389AB22128B
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756154680; cv=none; b=feb3EVUhMlqo/eUZO553QL6p3Clzu7oFH5oJTFtHk42KSoRDtKmiacZT3J9hPipMfkAMaAjhTy4usFcF+s/YaP/2raBV68C7hrVM5bpKqWuJoFUJpg7RPANQ7TA8cQOryfgdU/kJa67qRWbZV9DV5BXvVsVuDrBni6WEmo+aYtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756154680; c=relaxed/simple;
	bh=+2KeEsrRh9jRX/hyPM2v9wAIyz5TxoHwAD93vJumies=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aOKC2gOI1uYxqsz8bIWNFvh9yJPzUOP2aQ6qjPoayD3L3bp+DJKnoKSUnOnDY7rfdfo8W0xlg7Igo5SfL7/zLPrhcSRN2mam6NxguzDK+wTqQgDwr2mz4X80bNGb2vx+oxlxXSjN4KD/cDxe5FrmLeW9uTdgsVwq9rgOctd1j8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=DoFwW3c8; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="DoFwW3c8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=lj6uQaiLT3HZmkLlwrZYpoMhUZU7Lbqo9P/Gonl3d1U=; b=DoFwW3c8S4z6nJlYreeOtSk+BR
	5JZLURu4jU7/nVP899IzmgHLopr/a/pZWl/Xbv1XgiDIsWpJIs8k4VHcWtSEdyfRThGAV83EC5uJS
	XwoP0V10hqdfyCoGyGxY6X2yUiAZl7ydxOEArB4j2x/HX1aAnp+RfHh95oJas4BMPWJSn1Nf1oNKj
	8CbvvFuT+JFgaxcg8ASmlHnwxplmopdDKKITASfE/UtYQuRThhKPBfwVf5lMPVfL9mbaEhYTp23NX
	+IzjTryTqFeIbpOXI6HvYFkPhEHx1y27i6RtaCYkpdKYge2ScH83P9NQPJZSC+p8hgOX2MZUWTbch
	prg765Z9SHOoFne6zRAjGEzH6Yf0A4Hj7S1TONO/i6GmxAjKZYJFQPnYJf740CunyZD0CrtyEkaBT
	9y5c6lfyYR4IzgrKEqXvhDdPSubcBejLK4Pw4jlyCBaoOHDvW17Hx0zf9DD4RKJNuSPpY3G04GDcl
	+B3egArdt84L4Y+ABRh4AnW/;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqe3N-000jfn-1A;
	Mon, 25 Aug 2025 20:44:34 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v4 016/142] smb: smbdirect: introduce struct smbdirect_mr_io
Date: Mon, 25 Aug 2025 22:39:37 +0200
Message-ID: <f1ce60434ddbe74319e74c5691f0b606620f1cf1.1756139607.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1756139607.git.metze@samba.org>
References: <cover.1756139607.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This will be used by the client in order to maintain
memory registrations.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/common/smbdirect/smbdirect_socket.h | 26 ++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_socket.h b/fs/smb/common/smbdirect/smbdirect_socket.h
index c4e37c156f46..588501a0a706 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.h
+++ b/fs/smb/common/smbdirect/smbdirect_socket.h
@@ -301,6 +301,32 @@ struct smbdirect_recv_io {
 	u8 packet[];
 };
 
+enum smbdirect_mr_state {
+	SMBDIRECT_MR_READY,
+	SMBDIRECT_MR_REGISTERED,
+	SMBDIRECT_MR_INVALIDATED,
+	SMBDIRECT_MR_ERROR
+};
+
+struct smbdirect_mr_io {
+	struct smbdirect_socket *socket;
+	struct ib_cqe cqe;
+
+	struct list_head list;
+
+	enum smbdirect_mr_state state;
+	struct ib_mr *mr;
+	struct sg_table sgt;
+	enum dma_data_direction dir;
+	union {
+		struct ib_reg_wr wr;
+		struct ib_send_wr inv_wr;
+	};
+
+	bool need_invalidate;
+	struct completion invalidate_done;
+};
+
 struct smbdirect_rw_io {
 	struct smbdirect_socket *socket;
 	struct ib_cqe cqe;
-- 
2.43.0

