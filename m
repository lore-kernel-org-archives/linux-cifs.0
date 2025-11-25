Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0695E2264D3
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764094971; cv=none; b=AQE9KP+JCjV0h83g99DO9YQ0GyYywPH/GCAqt103L58nkMKscXXoFYSKorgBXJDjNHoE4utxL9ciW6nJD3HybaFGv6TdhXAgsCYNlZ67R2Slj6Bq6jQYTrxumbE/rKjkALmQJL+wiXMhvq6T5CLF2nsNJY3/izW4MhC0gupwAoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764094971; c=relaxed/simple;
	bh=/ZkWcwS5d+1HqAUzQQrTgfYEsQ6CecfnPLHXz1HLTwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TJIDM58jbVKUQbRqRxwaQqzx+QwM1uaRZ4swB9McZ7lbLP+VFyhHWAnpnZrk+demyqFTYQ85JAKE2HsHoLilVh4XLwiphYI2XZAWklzdRrh05Vi6L0w9UgdxFSb4CTson7xfZSMPbx6VUcno8BBqLA+OU1mRBolUZr/Enlu2WLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=b6+yWbB7; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="b6+yWbB7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=yx29IRSPTEj5WdbgpxQC8gQnfaOTpE2ScNvCf6oxdfk=; b=b6+yWbB7tf1fxHUdUC+f1eQqAA
	GEqbEo3BvpXWab0Br3l4e9mOqOQYSTyOO0jsDNw7Ea+e5TLt9kp1qSH89uZM3vfHqrxMEsKRl+rhK
	qZz3frRXBi6xbEkLO5UbhnB4WHR+ekbegULEtMUiWCp9+zIX9o/GD6UefQF7wOxXPGJxFa9VfA2ks
	1o6wBQFOqKX3373zculLzQZhGNqzw3lRiXqPURjTIwii+03hE5uImQ3Zb9t8KuW3PMqXQr00P8N8Y
	4frbOnu//5DbTSNqNM4WPTTRTVODHicNJ3BofSs3ihtuNw09A45ncZ0D0j6PYVPfD0q62PwZ2+ur9
	QOj2AetTSjsA6UcPkgqPVrEImaSDAzbvbmMWaDBppW9LD++2c8sc54V4QtMsOidAMsQ0PkB2Fru/K
	fwOcj5vjz3kmBXMa3D9HGg8G/RZo30A84G7s8rkzOJrfZNqK9rd3th/F23jlC2rUADGRL5V11vaUe
	4874A7sa5ysnL1yqYX3RnrTO;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxdd-00FfDd-30;
	Tue, 25 Nov 2025 18:19:42 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 118/145] smb: server: make use of smbdirect_socket_wait_for_credits()
Date: Tue, 25 Nov 2025 18:56:04 +0100
Message-ID: <76cb5e35218ac111d61b732f52dcfc617ec36d00.1764091285.git.metze@samba.org>
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

This will allow us to share more common code between client and
server soon.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/server/transport_rdma.c | 48 +++++++++++++---------------------
 1 file changed, 18 insertions(+), 30 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index ca587ed6acce..84ea45058cb5 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -768,27 +768,6 @@ static int smb_direct_flush_send_list(struct smbdirect_socket *sc,
 	return ret;
 }
 
-static int wait_for_credits(struct smbdirect_socket *sc,
-			    wait_queue_head_t *waitq, atomic_t *total_credits,
-			    int needed)
-{
-	int ret;
-
-	do {
-		if (atomic_sub_return(needed, total_credits) >= 0)
-			return 0;
-
-		atomic_add(needed, total_credits);
-		ret = wait_event_interruptible(*waitq,
-					       atomic_read(total_credits) >= needed ||
-					       sc->status != SMBDIRECT_SOCKET_CONNECTED);
-
-		if (sc->status != SMBDIRECT_SOCKET_CONNECTED)
-			return -ENOTCONN;
-		else if (ret < 0)
-			return ret;
-	} while (true);
-}
 
 static int wait_for_send_lcredit(struct smbdirect_socket *sc,
 				 struct smbdirect_send_batch *send_ctx)
@@ -801,10 +780,12 @@ static int wait_for_send_lcredit(struct smbdirect_socket *sc,
 			return ret;
 	}
 
-	return wait_for_credits(sc,
-				&sc->send_io.lcredits.wait_queue,
-				&sc->send_io.lcredits.count,
-				1);
+	return smbdirect_socket_wait_for_credits(sc,
+						 SMBDIRECT_SOCKET_CONNECTED,
+						 -ENOTCONN,
+						 &sc->send_io.lcredits.wait_queue,
+						 &sc->send_io.lcredits.count,
+						 1);
 }
 
 static int wait_for_send_credits(struct smbdirect_socket *sc,
@@ -819,15 +800,22 @@ static int wait_for_send_credits(struct smbdirect_socket *sc,
 			return ret;
 	}
 
-	return wait_for_credits(sc, &sc->send_io.credits.wait_queue, &sc->send_io.credits.count, 1);
+	return smbdirect_socket_wait_for_credits(sc,
+						 SMBDIRECT_SOCKET_CONNECTED,
+						 -ENOTCONN,
+						 &sc->send_io.credits.wait_queue,
+						 &sc->send_io.credits.count,
+						 1);
 }
 
 static int wait_for_rw_credits(struct smbdirect_socket *sc, int credits)
 {
-	return wait_for_credits(sc,
-				&sc->rw_io.credits.wait_queue,
-				&sc->rw_io.credits.count,
-				credits);
+	return smbdirect_socket_wait_for_credits(sc,
+						 SMBDIRECT_SOCKET_CONNECTED,
+						 -ENOTCONN,
+						 &sc->rw_io.credits.wait_queue,
+						 &sc->rw_io.credits.count,
+						 credits);
 }
 
 static int calc_rw_credits(struct smbdirect_socket *sc,
-- 
2.43.0

