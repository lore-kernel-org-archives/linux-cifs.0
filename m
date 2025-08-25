Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF85828751B
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 21:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155906; cv=none; b=Zw6XJcYckKN6qkxwuKkTpJERpuMKhcu7I/BnLiGxs0APJyCvBJk51x27728Wk1NRANc1CGKughWR57jC9+l5+Kiu33XZTFHzDpybdAk0sCqFMWjrCdojV5MLlDq1H1db2AEpxj6mhrQz8asV2Qz4GA+ZTszILPuQBhcghOHxY6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155906; c=relaxed/simple;
	bh=+LueSh6+gOmP/tOY50tt/ppmmaxXZ45EhpvwQ7Y5DeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ffNIvQdxkVSmcZzMSvDfJ5g2lEGjxpa43h2RGmAQ6Z7ZcolaLxGNTlLecUxf9AgF91dIlUYgxGVzngddaLFfyz3FyqWn4czKmo9K5G38EeVSyQYKDm/v6wy/2NKpCs7GLFuPX43ddjhygthyijK5HO9MKyVs4dCiHfNV703vQz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=gcp3yE98; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="gcp3yE98"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=RJ8ch65eUboITu5ixn4t4Z+9kEC41oIacj4i7Z+Jjbw=; b=gcp3yE98tSkxswMqFd+13e297N
	wLCiYwxtHCIvmg7I5fnKTyzqi5iMO7pwfiCo4Aq6iKOArQ8j14QXTudVGSKhEnJGbV/vtdWdyRf8V
	ICriqj3zIuwTgNjSe0aL3JZJQfKLEhn43gBFlnuyLgYP3r5A+KMiN5AnxjqbdghKQoDeGSjUtxvJs
	TJBBcOTcQ9uf+5RQLC0B6PNrCbR2MzmEaLdUSwcvkTlPjks+j+9qZ86BcbGJ6wlVRuVnLuqzDC0/a
	TGo8QLypMhPsJ/RcYmjQqMRHxyLnAmrfyve3s1bdXmMhPBmYvkcMh72lujun91UmJ5M56oRa8ERrT
	4QBlhwmjg3f0MyZxgeT1uuewRepfl2WrUbl3l3VB9pTQ1LT7+YDx+gEfwYcA0p1jdUH5+9tpPEGyd
	zxbpbDMf5dRdEUNthCxU1H2Fn4OolwpA/ilyTzX88PMi5GDjctf/tRbKFBWpl3eryOfa+X05lliyp
	u7qaJOBySVKc8wmo4aJdBeUT;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqeNB-000nrJ-0N;
	Mon, 25 Aug 2025 21:05:01 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v4 139/142] smb: server: pass struct smbdirect_socket to post_sendmsg()
Date: Mon, 25 Aug 2025 22:41:40 +0200
Message-ID: <47101bb14a30c9d368d00c1edda236c83333f52e.1756139608.git.metze@samba.org>
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
index 0c11855a2a8a..289325640a04 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -1104,11 +1104,10 @@ static int get_mapped_sg_list(struct ib_device *device, void *buf, int size,
 	return ib_dma_map_sg(device, sg_list, npages, dir);
 }
 
-static int post_sendmsg(struct smb_direct_transport *t,
+static int post_sendmsg(struct smbdirect_socket *sc,
 			struct smbdirect_send_batch *send_ctx,
 			struct smbdirect_send_io *msg)
 {
-	struct smbdirect_socket *sc = &t->socket;
 	int i;
 
 	for (i = 0; i < msg->num_sge; i++)
@@ -1199,7 +1198,7 @@ static int smb_direct_post_send_data(struct smb_direct_transport *t,
 		}
 	}
 
-	ret = post_sendmsg(t, send_ctx, msg);
+	ret = post_sendmsg(sc, send_ctx, msg);
 	if (ret)
 		goto err;
 	return 0;
@@ -1625,7 +1624,7 @@ static int smb_direct_send_negotiate_response(struct smb_direct_transport *t,
 	sendmsg->sge[0].length = sizeof(*resp);
 	sendmsg->sge[0].lkey = sc->ib.pd->local_dma_lkey;
 
-	ret = post_sendmsg(t, NULL, sendmsg);
+	ret = post_sendmsg(sc, NULL, sendmsg);
 	if (ret) {
 		smb_direct_free_sendmsg(sc, sendmsg);
 		return ret;
-- 
2.43.0

