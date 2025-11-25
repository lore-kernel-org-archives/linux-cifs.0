Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A728720C48A
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764093671; cv=none; b=B8uCBQnt9UTBmkSascAaK6leTmjGMyVZzcBpLHB+we9PoKEnkecjRSgPk+plMXztUQqVr36ib8PulQKm5KrCBFYgg1BarUlKlyobUwLOVWywgeGD97hMy4MXC5PlLusC2Z/KhP7nhUTafHGAeM5Mb9iZq7waBZVeJ818TcLuGBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764093671; c=relaxed/simple;
	bh=pPif6ej8+aSErewUfEtrTOzgqL8kxK0VrCiUvuzeT8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j4ZCjJk8+BlWQceHCBHhI3dUWaGd9NkboX3kRwxgad88wZjCYcAh9nF/JUo7XGd8HQ8K4aBg1s+LyJ2E8ixzhfwAkUUi1GeBP7D04jS+461H2ZF++/EzigCX8PmFAAelcD50sZWuURxgSQkIvYIgcuPActJ/Dc+a0gAgVJNH/Gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=xu8kQoUC; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="xu8kQoUC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=Ot/g2X2p3USxlU4/6ctFi0yjrKOMYk59FL1Ot5hIGbY=; b=xu8kQoUCm+H56q0NMfFfp59Th7
	M7Mbaw5yY8y5E1OGQvcnMmkfeiLdSjhAMhXDb0bJ2dYvQPxUuAaHLDA4s8jm35NKRrD1yVmtHQ1dG
	kD6pKSIcX7PJTwt3QoDHuuVe2CgyqYwAD533on4XI1wG0wprxlaV0fkhTXyKlxeDx9snzt41Y2wcQ
	8euiko+r7z6njQVCfSG+8i5IxCawZHUWHwWfTCOGusdu0m8vVrgCr8okyqp95reMt6JjQyBJwqJN3
	6NhME6E5pd5MYL52kDApeVBS2homXLWBf04SXF26ukoW4F5Py+W/IG2TzWLDo02aMy3IWvD+kDlOA
	rO/eiu0mhlebLEgp0xnVJmhVo3TuAgFIe9GKnor9Q2uelvWWIAzFxopO+u3Nc3CyXiq66+ggvq8SH
	CDkfan0dK7ExvMGx6SCSWO3FjPJiJEWr8y5cB4hww3EpBQnMVQKuJ7c3YhAN+nRSCuNCHMmjRiYD+
	zR2HxiTJphD8WSegjQu1NBy6;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxLX-00Fd7s-2w;
	Tue, 25 Nov 2025 18:01:00 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 042/145] smb: smbdirect: introduce smbdirect_connection_grant_recv_credits()
Date: Tue, 25 Nov 2025 18:54:48 +0100
Message-ID: <5cd8c3c57d16740da9de79b93b56177fbdc9272e.1764091285.git.metze@samba.org>
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

This is a copy of manage_credits_prior_sending() in the server.

It is very similar to manage_credits_prior_sending() in the
client, the only difference is that
atomic_add(new_credits, &sc->recv_io.credits.count) is done
in the caller there.

It will replace both versions in future.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 .../common/smbdirect/smbdirect_connection.c   | 20 +++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_connection.c b/fs/smb/common/smbdirect/smbdirect_connection.c
index 71d2ee4030a2..6dce0f0c126a 100644
--- a/fs/smb/common/smbdirect/smbdirect_connection.c
+++ b/fs/smb/common/smbdirect/smbdirect_connection.c
@@ -704,6 +704,26 @@ static void smbdirect_connection_idle_timer_work(struct work_struct *work)
 	queue_work(sc->workqueue, &sc->idle.immediate_work);
 }
 
+__maybe_unused /* this is temporary while this file is included in others */
+static u16 smbdirect_connection_grant_recv_credits(struct smbdirect_socket *sc)
+{
+	u16 new_credits;
+
+	if (atomic_read(&sc->recv_io.credits.count) >= sc->recv_io.credits.target)
+		return 0;
+
+	new_credits = atomic_read(&sc->recv_io.posted.count);
+	if (new_credits == 0)
+		return 0;
+
+	new_credits -= atomic_read(&sc->recv_io.credits.count);
+	if (new_credits <= 0)
+		return 0;
+
+	atomic_add(new_credits, &sc->recv_io.credits.count);
+	return new_credits;
+}
+
 __maybe_unused /* this is temporary while this file is included in others */
 static void smbdirect_connection_send_io_done(struct ib_cq *cq, struct ib_wc *wc)
 {
-- 
2.43.0

