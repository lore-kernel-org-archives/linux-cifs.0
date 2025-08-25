Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D01128F1
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 21:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155834; cv=none; b=JMOqfIKhm9zltSYdQvxhf5JMAkiN4frP1v7mzzhQY9ghl/U9rSXRenjo+P0Uq08RnfUPlsViQTy9ndDgEayirYWsHEREqXzRLMIfi/nXWeMGDi2V/r27r34Y0yDkjISCE1kM5fgHw3kjQrc4hDX6Y6uJCP+0AE3u3xwsmYQrvOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155834; c=relaxed/simple;
	bh=Tq3WjT6pS4uaX/DP4EFpi6RI8JsPS4HOaF0MttZV+f8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PZo21KMvQHGCJtbqLkjfItvOCDphbqBQf5aKGPBS1ozfu8SxVqPMYhJvyPv1TyJXiU46EBVclfK8iMEgXIKBmUL1aTt2PA5T0U+hmlk08TeHeCNQoApxDeCpcC3DyXL0Bw7mQ3smZR80i0ulgxD+VIktbNvebcX7BEYJrdvR7nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=q2Gz0AuD; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="q2Gz0AuD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=Y7eupOoAXXEC+dStY3lgbtiJEppQQwLLejW9ZOYjnhg=; b=q2Gz0AuDXm/ZGTdhAjU20u0ced
	KIB5aEXKQ9UrD8rMW7P6gdpSoo8KAX0qxkc47j57112pIgOcxxCA2qSjCcHISCvhFuQ//xq2gUiSh
	52YKQJZO9MyWmZVc1sQe29vIhs/bbCRf6GCKDTO85Gqw+B6u7ElL7yL2I0+kmANebj1MZchu5+USP
	e427sfskASjIK5VG5slgUZwwr6BlADaPwf9wzxjswwROGjWeqhK36QfrgL79b1PxEyAg077NACPqW
	X2/23b40GS/dB3kB0c61ipzXTmNAVzoqyDHw9Iw0MkYVUSvXFRnROB/vUx9TLdSv6GZqJ9YCQqH3F
	9sKIjQ5Gg9lYRkLjjCCz25W14ZL9/RRk2kA4IdLrR3u+A6vSZVV01rKXhDovGNehy/iFMyJlSCY+P
	ADbd4viEjVt6+yMcZylMvUN7F5uY4Qqs5FuXOktPpASEXdcSQARrEd3PjibDIxf+o8WvOXi+xqHmF
	3aqnnwJsUVtWpcVYwkyZnzKZ;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqeM0-000nc2-1L;
	Mon, 25 Aug 2025 21:03:48 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v4 132/142] smb: server: pass struct smbdirect_socket to wait_for_credits()
Date: Mon, 25 Aug 2025 22:41:33 +0200
Message-ID: <ccb33477d02502775c28206860e514c33f1ee2d3.1756139608.git.metze@samba.org>
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

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/transport_rdma.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 39ea9c51a24b..370e27bbcf12 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -945,11 +945,10 @@ static int smb_direct_flush_send_list(struct smbdirect_socket *sc,
 	return ret;
 }
 
-static int wait_for_credits(struct smb_direct_transport *t,
+static int wait_for_credits(struct smbdirect_socket *sc,
 			    wait_queue_head_t *waitq, atomic_t *total_credits,
 			    int needed)
 {
-	struct smbdirect_socket *sc = &t->socket;
 	int ret;
 
 	do {
@@ -981,14 +980,14 @@ static int wait_for_send_credits(struct smb_direct_transport *t,
 			return ret;
 	}
 
-	return wait_for_credits(t, &sc->send_io.credits.wait_queue, &sc->send_io.credits.count, 1);
+	return wait_for_credits(sc, &sc->send_io.credits.wait_queue, &sc->send_io.credits.count, 1);
 }
 
 static int wait_for_rw_credits(struct smb_direct_transport *t, int credits)
 {
 	struct smbdirect_socket *sc = &t->socket;
 
-	return wait_for_credits(t,
+	return wait_for_credits(sc,
 				&sc->rw_io.credits.wait_queue,
 				&sc->rw_io.credits.count,
 				credits);
-- 
2.43.0

