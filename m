Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E58E238C08
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744281; cv=none; b=gBQwmWCZJZ1jCR8f9smbpYrS61CheLNWA1RBQ16UVROCGNZ3cwX15qXCFecQcsrftKbNe2vvcC1jEWEVXCHNPTwk/QfXMbeG8SbCSrebsYqHj/upVYlsufSb7Ecw07Nf+mp1wG+FvTqB0Swy2STHRoiXBUvnkr3H9BwnUrkd7u4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744281; c=relaxed/simple;
	bh=Jx4iMTsZez/X3oV3cY6aLv8lQ2IFnfzws4xeO8OzcHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RJMWodhZo/4mKGX6C76Zs3WkHudHIkpI7w3RdeOi8s2J0n1BIaeBr5N7OODJVYgBoGk3KFkegHHAYJCnFkqR9xs2gZWAUhD0ZTKVJCHxqysHB6ihv/xArDdwcbgvtlCH6kIOgCJdGKoNr0o4feiviPffZ2sLrSRGrZsOBwbHIb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=wUyOnGsE; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="wUyOnGsE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=iLhQ1rVS4zBVrUO4h6jXSyy7sC7Q7umdC7HGDw2OaBc=; b=wUyOnGsES+QZqq5YqyXQo3H/lV
	rQ4ipXnDXCICi8ILjuS6wDoY7en/xWSvfnoaKP7cj6lWLfkA7W2Iz18hw6eLxl+Nl9SI84+F79ku3
	E0c1YFHsth9JxQLyi49yPndICMnCSAd06xf3j6K8w4RJI8eisLVYmkXUh2wNwon2yCO45+Tz83hs7
	XQdpTooVT0HJ09eikzWkCox786Qqi+SE6FfDKDQLwqo1fgRi7PHY2UAzA6T4+XY52C5MNnKPTE/sA
	UZBjFoBpUWo8MOkZjMgwrOF/hbN90uUHLUaVjpn+7bWZ88vSjv8QYxCMsWzzSobYOma+Kh6qlQezM
	QaXiZ8ygLlzatKAQvTzeRRn4EGMtSlAIG37nGpOscjxUzeCZBq40sSsGqVPTcQFKzhe2uiMQOB9Cz
	imDRdjF5/hifsLpwohA/J8Ez9AUfkS4+pXx1YN4Mji+HnwB9Zwuf3g3Eti0HUualfQ/pwFDKB7Nhi
	PlOIz8agQSPQzrniv8bRH6mR;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6AF-00BbWN-0i;
	Wed, 29 Oct 2025 13:24:36 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v2 021/127] smb: smbdirect: introduce smbdirect_connection_{create,destroy}_mem_pools()
Date: Wed, 29 Oct 2025 14:19:59 +0100
Message-ID: <48774548952e318fe7c920425702a6f1ae8e8558.1761742839.git.metze@samba.org>
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

This is based on smb_direct_{create,destroy}_pools() in the server.

But it doesn't use smbdirect_connection_get_recv_io() on cleanup,
instead it uses list_for_each_entry_safe()...

It also keep some logic to allow userspace access to
smbdirect_recv_io payload, which is needed for the client
code. But it exposes the whole payload including the
smbdirect_data_transfer header as documentation says
data_offset = 0 and data_length != 0 would be valid,
while the existing client code requires data_offset >= 24.

This should replace the related server functions and also
be used on the client.

It also abstracts recv_io.mem.gfp_mask in order to
allow server to keep using __GFP_RETRY_MAYFAIL.

It also uses struct kmem_cache_args consistently
as that's the currently preferred version of
kmem_cache_create(). And it makes use of the
mempool_create_slab_pool() helper.

And it uses list_add_tail() just to let me feel
better when looking at the code...

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 .../common/smbdirect/smbdirect_connection.c   | 107 ++++++++++++++++++
 1 file changed, 107 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_connection.c b/fs/smb/common/smbdirect/smbdirect_connection.c
index 05a68991587c..dedc47916e0e 100644
--- a/fs/smb/common/smbdirect/smbdirect_connection.c
+++ b/fs/smb/common/smbdirect/smbdirect_connection.c
@@ -88,6 +88,113 @@ static void smbdirect_connection_wake_up_all(struct smbdirect_socket *sc)
 	wake_up_all(&sc->mr_io.cleanup.wait_queue);
 }
 
+static void smbdirect_connection_destroy_mem_pools(struct smbdirect_socket *sc);
+
+__maybe_unused /* this is temporary while this file is included in orders */
+static int smbdirect_connection_create_mem_pools(struct smbdirect_socket *sc)
+{
+	struct smbdirect_socket_parameters *sp = &sc->parameters;
+	char name[80];
+	size_t i;
+
+	/*
+	 * We use sizeof(struct smbdirect_negotiate_resp) for the
+	 * payload size as it is larger as
+	 * sizeof(struct smbdirect_data_transfer).
+	 *
+	 * This will fit client and server usage for now.
+	 */
+	snprintf(name, sizeof(name), "smbdirect_send_io_cache_%p", sc);
+	struct kmem_cache_args send_io_args = {
+		.align		= __alignof__(struct smbdirect_send_io),
+	};
+	sc->send_io.mem.cache = kmem_cache_create(name,
+						  sizeof(struct smbdirect_send_io) +
+						  sizeof(struct smbdirect_negotiate_resp),
+						  &send_io_args,
+						  SLAB_HWCACHE_ALIGN);
+	if (!sc->send_io.mem.cache)
+		goto err;
+
+	sc->send_io.mem.pool = mempool_create_slab_pool(sp->send_credit_target,
+							sc->send_io.mem.cache);
+	if (!sc->send_io.mem.pool)
+		goto err;
+
+	/*
+	 * A payload size of sp->max_recv_size should fit
+	 * any message.
+	 *
+	 * For smbdirect_data_transfer messages the whole
+	 * buffer might be exposed to userspace
+	 * (currently on the client side...)
+	 * The documentation says data_offset = 0 would be
+	 * strange but valid.
+	 */
+	snprintf(name, sizeof(name), "smbdirect_recv_io_cache_%p", sc);
+	struct kmem_cache_args recv_io_args = {
+		.align		= __alignof__(struct smbdirect_recv_io),
+		.useroffset	= sizeof(struct smbdirect_recv_io),
+		.usersize	= sp->max_recv_size,
+	};
+	sc->recv_io.mem.cache = kmem_cache_create(name,
+						  sizeof(struct smbdirect_recv_io) +
+						  sp->max_recv_size,
+						  &recv_io_args,
+						  SLAB_HWCACHE_ALIGN);
+	if (!sc->recv_io.mem.cache)
+		goto err;
+
+	sc->recv_io.mem.pool = mempool_create_slab_pool(sp->recv_credit_max,
+							sc->recv_io.mem.cache);
+	if (!sc->recv_io.mem.pool)
+		goto err;
+
+	for (i = 0; i < sp->recv_credit_max; i++) {
+		struct smbdirect_recv_io *recv_io;
+
+		recv_io = mempool_alloc(sc->recv_io.mem.pool,
+					sc->recv_io.mem.gfp_mask);
+		if (!recv_io)
+			goto err;
+		recv_io->socket = sc;
+		recv_io->sge.length = 0;
+		list_add_tail(&recv_io->list, &sc->recv_io.free.list);
+	}
+
+	return 0;
+err:
+	smbdirect_connection_destroy_mem_pools(sc);
+	return -ENOMEM;
+}
+
+static void smbdirect_connection_destroy_mem_pools(struct smbdirect_socket *sc)
+{
+	struct smbdirect_recv_io *recv_io, *next_io;
+
+	list_for_each_entry_safe(recv_io, next_io, &sc->recv_io.free.list, list) {
+		list_del(&recv_io->list);
+		mempool_free(recv_io, sc->recv_io.mem.pool);
+	}
+
+	/*
+	 * Note mempool_destroy() and kmem_cache_destroy()
+	 * work fine with a NULL pointer
+	 */
+
+	mempool_destroy(sc->recv_io.mem.pool);
+	sc->recv_io.mem.pool = NULL;
+
+	kmem_cache_destroy(sc->recv_io.mem.cache);
+	sc->recv_io.mem.cache = NULL;
+
+	mempool_destroy(sc->send_io.mem.pool);
+	sc->send_io.mem.pool = NULL;
+
+	kmem_cache_destroy(sc->send_io.mem.cache);
+	sc->send_io.mem.cache = NULL;
+}
+
 __maybe_unused /* this is temporary while this file is included in orders */
 static struct smbdirect_send_io *smbdirect_connection_alloc_send_io(struct smbdirect_socket *sc)
 {
-- 
2.43.0

