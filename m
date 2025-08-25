Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D1128688E
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155252; cv=none; b=tMyKKv39rxBab/bfGOF0iK4jJM3e+15cs11FI6SqQnx58ARPtdE03gLwZ1SHONI7mQQ7/5b6w4y2dMA9Garf/j5VWYwcZi1WRoqgws+6Gd8cSlyJwfjErenVjBvL0EJBVgbBCdtSQAtoPnDPvb0tnLqtdfWSw1SUzie6wY+Y814=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155252; c=relaxed/simple;
	bh=mrZ8jSMgci1hVAvPxweeLdBlENWBIKKATeCrshNT9Hs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nvyY7DO4A5ti4QSSFthcavCpmHjk6Njs7Kgdiarux/z2zKywwvvNChJh/XXZnYbfnGgY4GkLAwxeg0W1wWuaN+ghn3rcoqZvy08vdD7WixZtyP+j0bS5ZiBJU6SdBZc5XvL8bEn1+isvjE+TuMSH9/pn5+lPp4zUKstNsMaKu7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=BHGio5iP; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="BHGio5iP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=Qye+0QmLAvFWq1VgYHM/0X2DGFzZNINKYU6v7i08nwQ=; b=BHGio5iPbrGwtIK6CMZlxdw+Ea
	nTfCCtS8b6yKp2KNsBGEeZ+u/bQjygf+Qs2C5SsF4UeDscV5SbdLujGJ8o4oI2o1iyh1LJ0N7orI0
	QJrBoshNaLzO0x+L5SEadC8ZpB+lSq2i1P9Ydxf8YVtSngB1eCAb47Fz6derzlKmU0Mmm24zkXqn3
	2fJvHo55Rv8ZqNC5H0qfBFlVpYHOvXO8purqc+/rwofI4x+aPf9Hf9Xp6TuXPegucYvRtiVjE7WkO
	ipAZcWiqQqMEYXaz1rkc15WkbtCR0Vh6oZxMl/W3Ct1peaUBnX1dzrDZA5mjxBLSWb+bzQND8Kjfj
	/ZU1EKH2ox+ZLj+2l7+YQLTYqhOpjRZ6fvQmgP+JZOND5gpuKHXaTakxo0p/Etot40DX0PIaQ8Cqq
	eoiVvxRCt+8c45dewJI/5TMqcq9fzeSdwglgIZ4ZDqXkGrsLKLWkeneOyiRELAlwLAapYYwGf1AVe
	EZl9UwxRFukAgm0cDhCk5HoS;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqeCd-000lhF-0t;
	Mon, 25 Aug 2025 20:54:07 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>
Subject: [PATCH v4 074/142] smb: client: pass struct smbdirect_socket to get_mr()
Date: Mon, 25 Aug 2025 22:40:35 +0200
Message-ID: <a681d33b42355a4246fe60d0b2d809e91762b914.1756139607.git.metze@samba.org>
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
index 04f86fde11fe..8033be07bc77 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -2281,9 +2281,8 @@ static int allocate_mr_list(struct smbdirect_socket *sc)
  * issuing I/O trying to get MR at the same time, mr_list_lock is used to
  * protect this situation.
  */
-static struct smbdirect_mr_io *get_mr(struct smbd_connection *info)
+static struct smbdirect_mr_io *get_mr(struct smbdirect_socket *sc)
 {
-	struct smbdirect_socket *sc = &info->socket;
 	struct smbdirect_mr_io *ret;
 	int rc;
 again:
@@ -2364,7 +2363,7 @@ struct smbdirect_mr_io *smbd_register_mr(struct smbd_connection *info,
 		return NULL;
 	}
 
-	smbdirect_mr = get_mr(info);
+	smbdirect_mr = get_mr(sc);
 	if (!smbdirect_mr) {
 		log_rdma_mr(ERR, "get_mr returning NULL\n");
 		return NULL;
-- 
2.43.0

