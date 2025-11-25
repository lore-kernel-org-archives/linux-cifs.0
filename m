Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0866330B2C
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764095577; cv=none; b=pJ8DBcJwTJ46YJVPfk1Kq2Rfdsdrds063fd0uCZVnrM2v9qGMTV8NYDD3QP2rLGcLs4p3Cu0RrwTTrSYSWXHqIAn7z0V0CKUU1pHez6ghPdj89AOHK8LwosrKoF4y1i6n/ITIa+ofbUKrRZtcUAdYklfO53sIyNthx3hf951QVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764095577; c=relaxed/simple;
	bh=uVLAF5I62Z9pQHWmMVI4In30ym6pJ8NtN5MkfLGrND8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k+VLUpr7B6qT+kojo0hZsboujE7/GRUzigArflZeyYEqsKuzR6xuzlWfVXEKOwImdM+nHbAVKbc11OAod2V7i5r8qexzrdZq0ZhFfhL19m3Yq3Og3KvRmnlcrd3nQXR4AVCTRgeChYhKlP8idBQ0+Xhp7fkKjxa+WtJlnDB/5+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=ByaKSsK3; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="ByaKSsK3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=qrL9upO6WvwxJBCTVkiReFOcALYutsNVTLN7azJA+F4=; b=ByaKSsK3qXE253w2ynYWhDbhSD
	ys5rronvE7YrzXQBge/enPeAUVeBn8GBnt1B04JGvy+/1OyObWG5+CCeqq0EdCh7ZsaLMHU7j1xaS
	xjYkKj2WPaHu44vNnfL+Cp5h080ls+Qhqf428ORMonwAyfHL7Cx5mq4VlTcUtZPuIw6UGu2AwUusT
	kX5ijLHvG9asFbPCkRAJBa9VeWVnBXaRfuj0JqpZeAL05lyxsEBJXBjqYxuivlSkejJHGX6c/ZLtZ
	1rNVwbQbDnyz82/ipp9bmLwpnnZLvyohorBgf1hRhv1iVEYS9CF82/LUZg5gEkJa0D64lUwvkBo/V
	awwsLe2MDBwOSYXD+MZ3pJ4ri4hq7an8nfQFdY1BB7m38zvpDABX9KwektfTS8XAEu8/96iZ3BTYP
	6p7QAean7DXvu3wrpG4b8uVulWjEVluRsrXyK4WwpMHOivDute6PZv8DaG6QPv7ZzVui3c0ObGuoW
	WIZcnlTMnixI4D0BebozWgA3;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxn7-00Fg0x-0x;
	Tue, 25 Nov 2025 18:29:30 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v4 140/145] smb: smbdirect: split out smbdirect_accept_negotiate_finish()
Date: Tue, 25 Nov 2025 18:56:26 +0100
Message-ID: <5115bf0558a79ae53e02d5a47988ae201e20c3e2.1764091285.git.metze@samba.org>
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

This will make it easier to support the listen/accept socket interfaces
in the next steps.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/common/smbdirect/smbdirect_accept.c   | 24 +++++++++++++++-----
 fs/smb/common/smbdirect/smbdirect_internal.h |  2 ++
 2 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/fs/smb/common/smbdirect/smbdirect_accept.c b/fs/smb/common/smbdirect/smbdirect_accept.c
index 2ff61a4617be..d8818a0a8286 100644
--- a/fs/smb/common/smbdirect/smbdirect_accept.c
+++ b/fs/smb/common/smbdirect/smbdirect_accept.c
@@ -292,11 +292,7 @@ static void smbdirect_accept_negotiate_recv_work(struct work_struct *work)
 	u32 preferred_send_size;
 	u32 max_receive_size;
 	u32 max_fragmented_size;
-	struct smbdirect_send_io *send_io = NULL;
-	struct smbdirect_negotiate_resp *nrep;
 	u32 ntstatus;
-	int posted;
-	int ret;
 
 	/*
 	 * make sure we won't start again...
@@ -397,6 +393,24 @@ static void smbdirect_accept_negotiate_recv_work(struct work_struct *work)
 	 */
 	sp->max_fragmented_send_size = max_fragmented_size;
 
+	ntstatus = 0; /* NT_STATUS_OK */
+
+not_supported:
+	smbdirect_accept_negotiate_finish(sc, ntstatus);
+}
+
+void smbdirect_accept_negotiate_finish(struct smbdirect_socket *sc, u32 ntstatus)
+{
+	const struct smbdirect_socket_parameters *sp = &sc->parameters;
+	struct smbdirect_recv_io *recv_io;
+	struct smbdirect_send_io *send_io;
+	struct smbdirect_negotiate_resp *nrep;
+	int posted;
+	int ret;
+
+	if (ntstatus)
+		goto not_supported;
+
 	/*
 	 * Prepare for receiving data_transfer messages
 	 */
@@ -424,8 +438,6 @@ static void smbdirect_accept_negotiate_recv_work(struct work_struct *work)
 	 */
 	atomic_set(&sc->recv_io.credits.count, posted);
 
-	ntstatus = 0; /* NT_STATUS_OK */
-
 not_supported:
 	send_io = smbdirect_connection_alloc_send_io(sc);
 	if (IS_ERR(send_io)) {
diff --git a/fs/smb/common/smbdirect/smbdirect_internal.h b/fs/smb/common/smbdirect/smbdirect_internal.h
index 4cb5c8f07e8c..8a032078175c 100644
--- a/fs/smb/common/smbdirect/smbdirect_internal.h
+++ b/fs/smb/common/smbdirect/smbdirect_internal.h
@@ -139,4 +139,6 @@ int smbdirect_connection_create_mr_list(struct smbdirect_socket *sc);
 __SMBDIRECT_PRIVATE__
 void smbdirect_connection_destroy_mr_list(struct smbdirect_socket *sc);
 
+void smbdirect_accept_negotiate_finish(struct smbdirect_socket *sc, u32 ntstatus);
+
 #endif /* __FS_SMB_COMMON_SMBDIRECT_INTERNAL_H__ */
-- 
2.43.0

