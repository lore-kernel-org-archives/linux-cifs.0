Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15792143C61
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155193; cv=none; b=niVBJt+vJSzpYhYQjkA2yPKdBAg8ystgnl5MpX3IOsNFPQt8iDIoHD9n2djHxouBXNsLSrk6YYNlorXWhnxp/hK2ga7AsTsxEYn7YqUgSL7PZFlFUiWjtec+kPbqK2oSz9O2slIiBJ6SZWW4ANrlW58vGkhIKc9UnKP6m9+jPkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155193; c=relaxed/simple;
	bh=X5qSGeP7serkhYD919TgTgQZR9gW0SVFZI2RmTvcSxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=emkfmP1Y4p8XJlzq+hEBBP+BBQG2JI1rGCSfFsVyxUZbUdHYcOVwgjMxqdgpZWhwjQQajIKSpXkQZPfAp8tjp0hx1GhiTaRMww37dVqirhhAoKJS33aDbR0ZvGLVt35/xtZn/ZbPWUG8B+MIF+5S1y789GyCubt3V1hugMEGAxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=laNKxDKD; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="laNKxDKD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=zLf2RtM76VRdg4KdmDxGvFQs+F9fuU4yNYLuLom9MUs=; b=laNKxDKDkrQqAmZghJk0YPkkzQ
	0QrOMdxjZD+mdOC1Ydn6ycBiZgTa4dBbHOV22CPSWJ7OwE/wdCnJGkC1djM+qCbNu5yiyn0esOysX
	NfYVqAKl+1WSt39FA3XQxOfOJFmLXpTooVgzaKwRG7PS4fa5hmHyCsDNWpzeMRZJWKnmB0pPRoZEd
	aYxQbv40bHqJSRxYQK7heKx1gPRYuDspjsmIyXMudXpqQTF2KP6mNoNw6kHKNJDHf7CtGAKva5n3s
	wgwV/g+5IDkT0ELiqDOfglnE+0yFLsDPy76Grore+SCGKi0weCZOveSZNB/VmT5iUXYdF/taOkT4j
	IDRqJWyXyWvQ45+sRUp9pxxe6dponyNhCGLs2G70PCodMkgon2zdsiWxe9ABx87mOMXpU+7hcV+Pe
	MBV9Y61o/YAQMuyHxSj/ngWxssVtSKRs2/7R4Fe7w0YZB66HEJLLXIrLliqkkUT5TU6f8ndsSNkoN
	/z+ux7kCgSp8CCccGwhz4vHS;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqeBg-000lV3-0j;
	Mon, 25 Aug 2025 20:53:08 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>
Subject: [PATCH v4 068/142] smb: client: pass struct smbdirect_socket to smbd_conn_upcall()
Date: Mon, 25 Aug 2025 22:40:29 +0200
Message-ID: <50246a1a2cf8439610d387254b848745ad56902d.1756139607.git.metze@samba.org>
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

This will make it easier to move function to the common code
in future.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index baeda2192a27..8ef4d8319833 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -223,8 +223,7 @@ static void smbd_disconnect_rdma_connection(struct smbdirect_socket *sc)
 static int smbd_conn_upcall(
 		struct rdma_cm_id *id, struct rdma_cm_event *event)
 {
-	struct smbd_connection *info = id->context;
-	struct smbdirect_socket *sc = &info->socket;
+	struct smbdirect_socket *sc = id->context;
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
 	const char *event_name = rdma_event_msg(event->event);
 	u8 peer_initiator_depth;
@@ -684,7 +683,7 @@ static struct rdma_cm_id *smbd_create_id(
 	int rc;
 	__be16 *sport;
 
-	id = rdma_create_id(&init_net, smbd_conn_upcall, info,
+	id = rdma_create_id(&init_net, smbd_conn_upcall, sc,
 		RDMA_PS_TCP, IB_QPT_RC);
 	if (IS_ERR(id)) {
 		rc = PTR_ERR(id);
-- 
2.43.0

