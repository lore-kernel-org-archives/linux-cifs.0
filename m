Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CCAA36495C
	for <linux-cifs@vger.kernel.org>; Fri, 10 Apr 2026 20:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775851895; cv=none; b=TiBGT1BOjXAL9pto9YAmRPoG2yXhdscZegwq/A5cVQk/3AsUuUW1i/iQPClLGVtzwC8mDMKxgmCYMG9zs80x0cOGaXNhBUYOAHp8nV9XDYDb1KHxlnA90d3L/0i3JagDsPU5KkWb23a2eQ/Yagzq3n/bSeL58WKigLIcrsn1nrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775851895; c=relaxed/simple;
	bh=YgjxrizYOG/1Uuc4mAZ5nhBDyGoXgZWywBfReaL4UW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QtECTNyqkc+F/bS0xwQwALhB/1SGiAyK+dczQ/hv4Lt/6mWML9yfy4MQuz7AFPPll+OhnYDDLWFcuYd3Zaf+LRMZXazrbTnLFVj/vklvhqyBSnNg/5MoK6xg/00246dO5sfRuLj+8Cbp84jLpsPS3IwVjxH7ul9Z7og69hq/7FI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=Z+uKM9SX; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="Z+uKM9SX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=MX2bO6SmuNqe5sP5rQJtOeCfyZ0XKDKRKHFExphHsX8=; b=Z+uKM9SXKRVlnC4jG3z5dgz2Lu
	PG69pAGZ1i6fbeEsGRa2klNeFF8w74JEKxgO34X73Cz9jTxW++FyGjYUwzIcDvbU9cie3zUMOPUeI
	/qyd5Qpa/4s+hEMNUTtRJNb3eQPwTf1wLcFHFd4mleskCIkbSTitAEDwi8dsSrPmFmN6F0nSSDkYI
	LDk+/AwTZRuzXlfgnPtF6IXjDHwTQqQIfxZ3aXcPpnnnVqSkNzQvtjLJHbRh/1hfdjOq+wCTNhvGQ
	mmMxu5D+uSwb0VhcSH10bgJyedeoBLx4gtP4FoumP/5gWMT3dQWVdrMkj6MqykBDNyBnMDnctwyVF
	FvQ3Q1tjVeBqa/zOD2IPRMeRJTxQNIIloo0hBaVJ+XcSvQZl238OzqFtArfvQUMOkaw8r8bzb/KbF
	gPNAMy04m/O+41Iz5Vg884FXtb2+M3k4wybgn1mAmDuHjoGDk8AOMav6YjsVBFFB71alLsDiA13Xp
	/LVNJA3pjxUBCK3onF/VDBSA;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1wBICR-00000000IJT-0Sx8;
	Fri, 10 Apr 2026 20:11:31 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Ruikai Peng <ruikai@pwno.io>,
	stable@kernel.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Paulo Alcantara <pc@manguebit.org>,
	security@kernel.org
Subject: [PATCH 2/2] smb: server: avoid double-free in smb_direct_free_sendmsg after smb_direct_flush_send_list()
Date: Fri, 10 Apr 2026 22:11:01 +0200
Message-ID: <8fcbca55c57c7cadefd6cef79e73b199e8c039c4.1775838249.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1775838249.git.metze@samba.org>
References: <cover.1775838249.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

smb_direct_flush_send_list() already calls smb_direct_free_sendmsg(),
so we should not call it again after post_sendmsg()
moved it to the batch list.

Reported-by: Ruikai Peng <ruikai@pwno.io>
Closes: https://lore.kernel.org/linux-cifs/CAFD3drNOSJ05y3A+jNXSDxW-2w09KHQ0DivhxQ_pcc7immVVOQ@mail.gmail.com/
Fixes: 34abd408c8ba ("smb: server: make use of smbdirect_socket.send_io.bcredits")
Cc: stable@kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Ruikai Peng <ruikai@pwno.io>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Paulo Alcantara <pc@manguebit.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Cc: security@kernel.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Tested-by: Ruikai Peng <ruikai@pwno.io>
---
 fs/smb/server/transport_rdma.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 188572491d53..dbc8dedb85dc 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -1588,15 +1588,21 @@ static int smb_direct_post_send_data(struct smbdirect_socket *sc,
 	if (ret)
 		goto err;
 
+	/*
+	 * From here msg is moved to send_ctx
+	 * and we should not free it explicitly.
+	 */
+
 	if (send_ctx == &_send_ctx) {
 		ret = smb_direct_flush_send_list(sc, send_ctx, true);
 		if (ret)
-			goto err;
+			goto flush_failed;
 	}
 
 	return 0;
 err:
 	smb_direct_free_sendmsg(sc, msg);
+flush_failed:
 header_failed:
 	atomic_inc(&sc->send_io.credits.count);
 credit_failed:
-- 
2.43.0

