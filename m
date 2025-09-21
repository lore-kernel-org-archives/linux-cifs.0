Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8AC22D0C92
	for <linux-cifs@vger.kernel.org>; Sun, 21 Sep 2025 21:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758491150; cv=none; b=LuXvOaSRB5QutIEmXrKA8dNiDGwXie2a8R+lE1xSO9LQcOux1Vi93viZAS+JpPM4plkaC10yILFvJ6nMnvQRusHkJ2j4SAl7Xubb7ZbjEPBOKaPRkIFUAJnAIrVHJYvPWeXYFGWsXaKM7DkqYgH7j56sjmqWEAGPK/2iCM7/CMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758491150; c=relaxed/simple;
	bh=yPL4zyzqQhJXVPeCer0JH5K8Zw57NaTcfV/lI3MthTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NE6j2F2T8L4RGbrmrJE129Ody7Lz9itM3p8vItCRXthQ89Dbzwt0DyGRghejTg8yO8dN3zcffZfrRQE2Kx48+nsr8d31ovOWmwFioYqrsJ9TaP1lbDj+1+D5dNZt/CkVZm++9PEyJzlCs3tpOVF04sf9QtkqXQ02y5x+o2LiZWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=Y6Wv5NpA; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="Y6Wv5NpA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=Tvcib6dIRKFpE5R5lvG/nteozSxdGuOWP980KtNsmVc=; b=Y6Wv5NpAC3DOg6EtkcmH73YLQQ
	vi4dD24dmx7PooVAlqoyeVxIyG6biVE1dNrbeTiH+oKhvTWCjqIlAnbqTYXYfqBQw7MEsXaTFWQiW
	ONVr0TximFyt7xODtUiAw7WQAyawID9hVdi2f5lbw3dK8ZxSfYDppfVSg2afx29QUsHEWzWHljwL/
	suQjrTCd+Fay0KnrPhNn+sG0OrZPz/d4OMiXtbO3pEHVKiKoFEeKqfa0/iNPL04DoXnhu0XLrEHk/
	wDARoP0dStzbEfR2gkjmQqbL90kZi1hMfqdLJNFGbWn+MDqTVo/T+4liro5YSefYUljgskenmZgv4
	Vv90VOAgrv8kNIPy33gl9xu71NQFmiQaDo/wW/ZQ2pdjZvkyQ+u5nOqmj8PnTtl5LQvMKCqn+T6cs
	vrmvYbnQHoKBK57tXw7FI4FBu7UwHC+WfxU3xt6wUyCFD1km0i8UUlq5FfDypRocqQbAs0xwDdNyf
	W86zBQhGje4EuRHTIlSL3vk4;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1v0RsQ-005GMe-1J;
	Sun, 21 Sep 2025 21:45:46 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 03/18] smb: smbdirect: introduce smbdirect_socket.first_error
Date: Sun, 21 Sep 2025 23:44:50 +0200
Message-ID: <d45911e332bfdbf2b2948d1f5e460abe85c38581.1758489989.git.metze@samba.org>
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

This will be used when a connected conection gets the first error.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/common/smbdirect/smbdirect_socket.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_socket.h b/fs/smb/common/smbdirect/smbdirect_socket.h
index 5e25abc02364..db22a1d0546b 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.h
+++ b/fs/smb/common/smbdirect/smbdirect_socket.h
@@ -83,6 +83,7 @@ enum smbdirect_keepalive_status {
 struct smbdirect_socket {
 	enum smbdirect_socket_status status;
 	wait_queue_head_t status_wait;
+	int first_error;
 
 	/*
 	 * This points to the workqueue to
-- 
2.43.0

