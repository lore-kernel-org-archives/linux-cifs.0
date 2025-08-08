Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BA33186E2D
	for <linux-cifs@vger.kernel.org>; Fri,  8 Aug 2025 16:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754671732; cv=none; b=RxQ1R/NSl/WADTAcmdHxe4aM2BupG7mtJUNM1Atp5IM/6fwaKNRc0ymFSMa4G4PnxlYYY0St9ry9GYtiF2i79fjy7pSzwlbnvIMjcnMlilBXxLodgNJn5NcrfKnwG8Jf+orRyoOBGr1meWx8toclxAp7Z2cAXDoMVnr1aeucZsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754671732; c=relaxed/simple;
	bh=5LlpdUmnxk/uGUWUd/gnUpN4ZsJ7iM0QdPGEbbkkOlM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j4MiM88tkm55o09CywHtNScM3PwNkYkLUnhtcNpEiYVdsNRM8xhRcYq/bCxk7t6PHZE7rMegeG90B6E0CdPJENX+Uy5c8VoQEJoiIGaRZ0TyeaE4X58rdxftdY8H64rZRSxMTk0bpjV71kh0sAHQ7XLmoSsOUg3hvHral309g0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=2EVPU1yF; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="2EVPU1yF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=ajfeVZwkk1jxAUTyHLfKrwIbk+GwICQLIc8hekLdP/c=; b=2EVPU1yFkIikAao0cULLAEl+Ah
	cKzFHEtalHqNwlJOhsauqvlVVkpqNufoGp34igUurnFVnhZjAAnsiQi6NVbU8Aa5xfv8SoqiG3Ut9
	RkamloArHfVlEw9sQQc/fb8+4Tz0Y+yV1New/tYPfk5MDJrybMaB9X3FG4kuDQ4uPo8e8ilsv+3I4
	LzeLz/14eQq7w+RRD9xUuzckUDeZeiUjRIXTRxKEzOYcNR0h6+YGMXrt88Xddvcz7rh/Ka2Iq64Ck
	7OBFJJk67QL7tMsFWZGcrY404LcEWY5QasQYu6VjYQiDHQnvzloCnnc87tPRs1RmRGzR6BnbJSRYI
	s76+0t0J/CsR4SqOL8hkverwVRNR+kyTNbUyFcs1rJ3SBpfgRoH8Hhx7fcjYXPQkvBXYRbPrqlMl3
	eWRVUy9NWIDHAb7S3C7wC+ti9O4LJoR7kmxvSYFqKxJs9vY04iv+8qbIpaYA3i/aPXkrVtCW7JHwn
	sqBIKJkl1q9bRzqHVxas7hOA;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1ukQGu-001qO2-03;
	Fri, 08 Aug 2025 16:48:48 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v3 3/9] smb: client: don't call init_waitqueue_head(&info->conn_wait) twice in _smbd_get_connection
Date: Fri,  8 Aug 2025 18:48:11 +0200
Message-ID: <30e8bdb47efcdaa1949297a1a427e6699e82b307.1754671444.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1754671444.git.metze@samba.org>
References: <cover.1754671444.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It is already called long before we may hit this cleanup code path.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/smbdirect.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 8ed4ab6f1d3a..c819cc6dcc4f 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -1716,7 +1716,6 @@ static struct smbd_connection *_smbd_get_connection(
 	cancel_delayed_work_sync(&info->idle_timer_work);
 	destroy_caches_and_workqueue(info);
 	sc->status = SMBDIRECT_SOCKET_NEGOTIATE_FAILED;
-	init_waitqueue_head(&info->conn_wait);
 	rdma_disconnect(sc->rdma.cm_id);
 	wait_event(info->conn_wait,
 		sc->status == SMBDIRECT_SOCKET_DISCONNECTED);
-- 
2.43.0

