Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E455B28C5DE
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756154546; cv=none; b=i98uPbi5irjmFjUaq/xdp0nMsrQiHwud9SGi+ULs25m8aknq2q/eSsK98BWjPQoQMA/GHbANuLhl5S6SbdxvPeTSEXa0nB8zbj5/VsKxnB5fhFQyrUy38gZc+pn4C4nahi7pNk9ZKLXbqpdP/1i6kFhJHWJTmvzezuUna4+kvK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756154546; c=relaxed/simple;
	bh=UXyOal4m/4zkhDxKY7OqhlhP7HMTka1op31cs3+XQmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JaJVvELtWoNqcu/+3YrHSNpwk767fIvWQ8yR4m7zEpOqBQ4X3Jrrq49hVYrYBWQMpDjS4tCck35rTRv5sW/wnaNuYgYfnK4VVNnncc1icg3nACbGREq5QbD7zdQ38ZvhfSQFCdm6Hti5krzhndRzgI5eE/Mj1HCoP41x8caukWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=xE5pl2nj; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="xE5pl2nj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=sz6yHpwvKEmIA+54vUxdZfhda39ILYhx4ggitLwtg0M=; b=xE5pl2njfSbYT/u0IsHP+gzYA/
	cKMiAP3S45cvzPIHy1e+h7rVD8vfh0x74TwSVLpdIVVGC2iGqnwmJKrvNHmkYY3590MYQtlwOZtde
	CHRAbUT9P87ti2e+CC4fvPnu1mu9PcSm5h+0ku45tiCYz3atoNx4GzoutLNGKjO2LssvfqSFMdfOB
	MOdYXBHUPvGAxOpwSnwUVhJH9SuwPRFJCSFqe7NP4XDdQDKGRhEsilcKj0Mqb+HJPlNmszFLKRv7H
	ZfN4/0ecQMCUdZPD4CqpDs38Nz3M4BtjxAaMP2vYWk9H1D0+RlDka9bOBn2XuFie+v6Pm3aSM5EQJ
	PhYwtldEDGPxc65mqmVBZxp6w5ygOUqdHOOoLOVeXK5d9I9jw6ULar4if4KdgFToiiKOyH/Mta0jM
	5rHBzW1bhWpMa9hWcZ6Up/HdfgTPnnzcdB8R8UOBUCQOetPxrDrBYF7Odurb+gFR6dDJz18RpcrFq
	VmUVMHDoOLrvJqiyomYKyQVP;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqe1G-000jJK-1l;
	Mon, 25 Aug 2025 20:42:22 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v4 002/142] smb: smbdirect: introduce smbdirect_socket_init()
Date: Mon, 25 Aug 2025 22:39:23 +0200
Message-ID: <d7723fb1372fccfa3b54a9b8455fabbf9edf5174.1756139607.git.metze@samba.org>
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

This will make it easier to keep the initialization
in a single place.

For now it's an __always_inline function as we only
share the header files. Once move to common functions
we'll have a dedicated smbdirect.ko that exports functions...

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/common/smbdirect/smbdirect_socket.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_socket.h b/fs/smb/common/smbdirect/smbdirect_socket.h
index 80c3b712804c..5c94e668b8ae 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.h
+++ b/fs/smb/common/smbdirect/smbdirect_socket.h
@@ -113,6 +113,22 @@ struct smbdirect_socket {
 	} recv_io;
 };
 
+static __always_inline void smbdirect_socket_init(struct smbdirect_socket *sc)
+{
+	*sc = (struct smbdirect_socket) {
+		.status = SMBDIRECT_SOCKET_CREATED,
+	};
+
+	init_waitqueue_head(&sc->status_wait);
+
+	INIT_LIST_HEAD(&sc->recv_io.free.list);
+	spin_lock_init(&sc->recv_io.free.lock);
+
+	INIT_LIST_HEAD(&sc->recv_io.reassembly.list);
+	spin_lock_init(&sc->recv_io.reassembly.lock);
+	init_waitqueue_head(&sc->recv_io.reassembly.wait_queue);
+}
+
 struct smbdirect_send_io {
 	struct smbdirect_socket *socket;
 	struct ib_cqe cqe;
-- 
2.43.0

