Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83E9D49620
	for <linux-cifs@vger.kernel.org>; Sun, 21 Sep 2025 21:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758491241; cv=none; b=Sk84vBKGGVl7hBBvzYqNL6IkfSv7ns2MrvXc23pg84OFMUzH3rqCLRXBDfGi0R76GiyOQpb0UTzC6XKf9vRbS+7zEHcr/gLrBcs70PXNteIrnivqtnL7+/bCnNJD+4qJUAnw+/q5gsUzowGcYE7sm4+phLCkZm7UT01G2TRF5x0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758491241; c=relaxed/simple;
	bh=4cw9gBE9KuYuvB+CJp6JQdS0eTl1Aerv1AiM/Zl+GT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O2QalLHMCf5458Ey9TOgfzKrpJ4nD9kVbAN1DmYoOQheWyyXrLwjJcevVIFEiv0aIDlWMycPRjNruqmfrIEqO1j5Q9YYBFeHqCXherd6+Ng8UfXjRTvEEAnF5R/HlflhYQ1m75LpQDSjVe8r4ry8bQ5GimgMY0eXix1ocnboGRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=EnZH2J+E; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="EnZH2J+E"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=bf+TrMOyPQbDKyj9ELLaPC6mkkrLSxRiQ7BfobwYfL0=; b=EnZH2J+E+XXb8O/R82Ds0AJ6Xk
	TOe1YOKvmJuYTWnofCTnVgr5S5WiUi0k5G1uGP0MFXu1U/jLMY1i0eJcCF8xbGkMVMX0JfF+xmmHo
	mc1geePXd2LLn2ivUZfmAfiDdlnz8X2lcZYG4Rl5/DfTeeodxBnpPI/9QWCz2bmi2f7MjMafD4VSv
	lJw6VasxNsyFjLIrb+BL8la8Zebs/YNiwu4ZZozqXaHWu/6H6CaQXcwA6LkgTsqgx6sfW8kc8lDoK
	T2MxPb9/Mb0vIWqhrR8Ox0l9qpzw64c+crJtCkgp3xkqie76OMrQ6SRt0EhoPS/W92YNh6TV2FZBF
	ipSBjFQhQeEnaF/pcwZn96EUIjbl/sbtDtKLcBB5Q9W2VDnEELpnY8mdNRiSdozCaztPSLmPkcvZx
	zJVc5zvBhcyGwA0REo2nvgz90nyTOxb50ELFZqZtcOtIuj4tT9brYVkbwccFd1h1U1zMNJ8m+JqUL
	aBqH/fT+TSqncn+c4bXCbVY4;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1v0Rts-005Geu-1g;
	Sun, 21 Sep 2025 21:47:16 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 14/18] smb: server: let smb_direct_disconnect_rdma_connection() disable all work but disconnect_work
Date: Sun, 21 Sep 2025 23:45:01 +0200
Message-ID: <120a2b6e803489e0b96f1faabbbf1dae8f634572.1758489989.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1758489988.git.metze@samba.org>
References: <cover.1758489988.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There's no point run these if we already know the connection
is broken.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/server/transport_rdma.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 44fa0af21b45..cd4398ae8b98 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -262,6 +262,15 @@ static void smb_direct_disconnect_rdma_work(struct work_struct *work)
 static void
 smb_direct_disconnect_rdma_connection(struct smbdirect_socket *sc)
 {
+	/*
+	 * make sure other work (than disconnect_work) is
+	 * not queued again but here we don't block and avoid
+	 * disable[_delayed]_work_sync()
+	 */
+	disable_work(&sc->recv_io.posted.refill_work);
+	disable_work(&sc->idle.immediate_work);
+	disable_delayed_work(&sc->idle.timer_work);
+
 	if (sc->first_error == 0)
 		sc->first_error = -ECONNABORTED;
 
-- 
2.43.0

