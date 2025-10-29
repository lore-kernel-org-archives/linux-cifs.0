Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7B4E275B05
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744321; cv=none; b=C972cocfIvr0G4p4VIQvSAq8RfskWhmUE/Cx0LxrwkJ4YfwdpEmLo4fFtaB22Kuxj+hqhoATJNmeENcYOiIef3kIcOOEyPbteLwNFfVbLLUvr9tyJk8U/fzmJkUj3GMMrwWmcCTCMTCuwpOZoZ4KsxwUGjj0kZFeVGCPQ3qvWkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744321; c=relaxed/simple;
	bh=fmzeDnTV4ynYogZDK8Ih32ZmwtLWcseHP/n9KSs3YqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fy+7XmtZiDCjXNcM1x0euHGam1UVt3RgrbkYStiZzdhd4ijwUaBkpUBFJqU0Rm9apq/3FM206SEucwbG2tniVPbsTGzY3U58g6msi4e9FsHOHRdOL7f4ixByPRX9dDYIcP2KzqFv2ImJ02SLbP9J2zWYKIkBKK19oAsgYPF8VwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=PaN49msV; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="PaN49msV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=9eW71573X0MGQI0YwDNN6+HY3cAEUv9tVvSPL9BTa8E=; b=PaN49msVFKbfGqY84NvGxI2GwC
	9AxQnyMuyN8mR6QOgcU7aMMFmGZfniZfBekgX4RqnTjrcQ8iqHTyc01EjB2wtWgQ0hu8uWOciuIl0
	eiZx9x3gF5YfIzMfw914aVcTHOsRJdITVnY1iyYNu9C+lHinpn2qAwUSlTgDcP5eugtYJV+D2gRG4
	j0omg0GYstckEjZLsw1kpJPVM7dV0elNWqIdf28RhiFM1uAaqVOsIxXH73jdmb+DsbUTMIOLxtf+M
	/p0F+BK27d2x4prkRi04SFU9WbArFyXkSk4yJUycS6Emod80fRvXfCwwIYIdb9lyP/yEOCK2zBGNf
	9emaIZ8y1VQNE03TnAJ5nCxUQnykUb7kywhl+Xkd17jK1YGKEZJl+ql0cjBiDRB6LgzKSGjtQ4Zn8
	GrU3qyQacDDXSehDddKdMaaPxTWm7upR6u7OsFcMzMjwOvCuU4/PbiO6aNsmng1MrZIPX7lOnKyAS
	LQMVBsqED4AUZ+5A1fTjcOFY;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6At-00BbcS-2M;
	Wed, 29 Oct 2025 13:25:15 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v2 028/127] smb: smbdirect: split out smbdirect_connection_recv_io_refill()
Date: Wed, 29 Oct 2025 14:20:06 +0100
Message-ID: <752ba3a9cb38bf0b0d092e882b274a4128b0f361.1761742839.git.metze@samba.org>
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

This will allow us to refill the recv queue in a sync way
after negotiation.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 .../common/smbdirect/smbdirect_connection.c   | 36 +++++++++++++------
 1 file changed, 25 insertions(+), 11 deletions(-)

diff --git a/fs/smb/common/smbdirect/smbdirect_connection.c b/fs/smb/common/smbdirect/smbdirect_connection.c
index 95e212877e9f..c1281807ff8c 100644
--- a/fs/smb/common/smbdirect/smbdirect_connection.c
+++ b/fs/smb/common/smbdirect/smbdirect_connection.c
@@ -881,16 +881,13 @@ static int smbdirect_connection_post_recv_io(struct smbdirect_recv_io *msg)
 	return ret;
 }
 
-__maybe_unused /* this is temporary while this file is included in orders */
-static void smbdirect_connection_recv_io_refill_work(struct work_struct *work)
+static int smbdirect_connection_recv_io_refill(struct smbdirect_socket *sc)
 {
-	struct smbdirect_socket *sc =
-		container_of(work, struct smbdirect_socket, recv_io.posted.refill_work);
 	int missing;
 	int posted = 0;
 
 	if (unlikely(sc->first_error))
-		return;
+		return sc->first_error;
 
 	/*
 	 * Find out how much smbdirect_recv_io buffers we should post.
@@ -936,7 +933,7 @@ static void smbdirect_connection_recv_io_refill_work(struct work_struct *work)
 				"smbdirect_connection_post_recv_io failed rc=%d (%s)\n",
 				ret, errname(ret));
 			smbdirect_connection_put_recv_io(recv_io);
-			return;
+			return ret;
 		}
 
 		atomic_inc(&sc->recv_io.posted.count);
@@ -945,7 +942,7 @@ static void smbdirect_connection_recv_io_refill_work(struct work_struct *work)
 
 	/* If nothing was posted we're done */
 	if (posted == 0)
-		return;
+		return 0;
 
 	/*
 	 * If we posted at least one smbdirect_recv_io buffer,
@@ -966,11 +963,28 @@ static void smbdirect_connection_recv_io_refill_work(struct work_struct *work)
 	 * grant the credit anyway.
 	 */
 	if (missing == 1 && sc->recv_io.credits.target != 1)
-		return;
+		return 0;
 
-	smbdirect_log_keep_alive(sc, SMBDIRECT_LOG_INFO,
-		"schedule send of an empty message\n");
-	queue_work(sc->workqueue, &sc->idle.immediate_work);
+	return posted;
+}
+
+__maybe_unused /* this is temporary while this file is included in orders */
+static void smbdirect_connection_recv_io_refill_work(struct work_struct *work)
+{
+	struct smbdirect_socket *sc =
+		container_of(work, struct smbdirect_socket, recv_io.posted.refill_work);
+	int posted;
+
+	posted = smbdirect_connection_recv_io_refill(sc);
+	if (unlikely(posted < 0)) {
+		smbdirect_connection_schedule_disconnect(sc, posted);
+		return;
+	}
+	if (posted > 0) {
+		smbdirect_log_keep_alive(sc, SMBDIRECT_LOG_INFO,
+			"schedule send of an empty message\n");
+		queue_work(sc->workqueue, &sc->idle.immediate_work);
+	}
 }
 
 static bool smbdirect_map_sges_single_page(struct smbdirect_map_sges *state,
-- 
2.43.0

