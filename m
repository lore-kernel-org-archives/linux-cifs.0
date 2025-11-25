Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34CB232AADC
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 17:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764093477; cv=none; b=BerbwFVJFqOBNDGXJguyeYd5Su564ZtKOowlhIjMOMfKCFEMLgisVrpEI+SIshO370NQKT0UP90Mg2Hc+Sm9QmaJFj5hcNHl4K6ZU/Pvp+qFujArGvAfSnZzW2GrJEyy9qnsP6KuNC0izwnMf+ubt6ZYUJ5lHVedWfdnPNITJ2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764093477; c=relaxed/simple;
	bh=9eWs2c+8tIsu0R245a9qKpFqLGBdAGM+e7cIWNuhaAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tgoXOfjiSg9L854bzNP7fGy75lwcHF2ZFnlnkZgnhXqWQDCSrcp//pAyY/AKpwBiVtnfkNDzs42RKRKcwEM2baKAd7h/+CdIo56zVcS34kwod2SxahHr7TiNcCs9SzOa/NpuNnkYckAHp7lM0kiBv4tSSkpGQ82tfPgSJPyHQHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=1Bpes26w; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="1Bpes26w"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=xXg/ga7QYryW4xZy2aHLO3396tv7jshh5KqEsbMMpPg=; b=1Bpes26wCEqIF+JALfMFx8dH3v
	d39/BoHEAfxu4E7o+kbc8N2nZEAtv6OTiPWbDdBYh6e4FFgh98NHVqYK/Fs4U2ep0v9vT3y0lNp1U
	Xcs7mZswylX1RIw00TeNx3Hok837d+JNFJpYGuQTcbV3d8KaxDDzqU9SHZecYw1Bf5hFAnHdyglN+
	dl7l9tD25S0sZgqhBGLETh1Yesv8XO0jEaWfNoSj/5g3ccwQG3TYwZ9bZUFIzPja9Ztpo3Py6vI+g
	Ygbvy9P1i/VfYShlNiY8TwyTx+nmexH3tU+JJqCiZvCxQ+sCBKidhAeeX3emXKiJwaJlJkggL65+1
	gekmbjCIq4EE3SnswiVvhcS0xnKZeh6JWUsvvMWRccRgrbCxfOkxwUuPVJoOHtoDtc2Dtn7UeLOmW
	jKJ1WQN4N6sVMG9PWJCCSdUqKukdzXDp0qiRoKDtc/PWfgO8E08ZfdmSw8IOkC0NVMDMjhY293Lk6
	mO+udyWmDYLUzKrunBEPJ5Ha;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxIV-00FcgP-2D;
	Tue, 25 Nov 2025 17:57:51 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 012/145] smb: smbdirect: introduce smbdirect_socket_wake_up_all()
Date: Tue, 25 Nov 2025 18:54:18 +0100
Message-ID: <d570a3917fe080a7172f37646cc1015d77cc48e0.1764091285.git.metze@samba.org>
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

This is a superset of smbd_disconnect_wake_up_all() in the client
and smb_direct_disconnect_wake_up_all() in the server and will
replace them.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/common/smbdirect/smbdirect_socket.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_socket.c b/fs/smb/common/smbdirect/smbdirect_socket.c
index 6c2732496cf7..a249e758379f 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.c
+++ b/fs/smb/common/smbdirect/smbdirect_socket.c
@@ -44,3 +44,21 @@ static void smbdirect_socket_set_logging(struct smbdirect_socket *sc,
 	sc->logging.needed = needed;
 	sc->logging.vaprintf = vaprintf;
 }
+
+__maybe_unused /* this is temporary while this file is included in others */
+static void smbdirect_socket_wake_up_all(struct smbdirect_socket *sc)
+{
+	/*
+	 * Wake up all waiters in all wait queues
+	 * in order to notice the broken connection.
+	 */
+	wake_up_all(&sc->status_wait);
+	wake_up_all(&sc->send_io.lcredits.wait_queue);
+	wake_up_all(&sc->send_io.credits.wait_queue);
+	wake_up_all(&sc->send_io.pending.dec_wait_queue);
+	wake_up_all(&sc->send_io.pending.zero_wait_queue);
+	wake_up_all(&sc->recv_io.reassembly.wait_queue);
+	wake_up_all(&sc->rw_io.credits.wait_queue);
+	wake_up_all(&sc->mr_io.ready.wait_queue);
+	wake_up_all(&sc->mr_io.cleanup.wait_queue);
+}
-- 
2.43.0

