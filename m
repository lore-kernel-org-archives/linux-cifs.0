Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43262296BA2
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756154577; cv=none; b=Bdgkla46ftIfndx5UYGmDHD2loXY144LHXNeM1+rzFwG3EhVZ/TDQzrOTTLVZNzLO+16z4SW4ZMWR9O1rLufN1PrDNRKe+XGN0NohMg8ckFSatbCDcfkYoHxWQ0zRkpWIcamNhTQBJeCUKtiH8SNsiqocb1xmTpkXsygCoIsB5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756154577; c=relaxed/simple;
	bh=gRqkY2YQLqPHPlAD7o+EGJRWkqWvrSHT7g5NB1t5rNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZrtN5kzwVuBjTW1/4UGfu/VYkYAtlpJRYeU0ElaRZYIsaThOq0uOsIvq6REGPLCuyzHwI4b1uOBAZ5gSZuuu/HVmq1Nedlvq/nQms+Ip+/XU6P/lYgpwrDYyQ/SrH2NSVvQaeHmF4y/ii3qcC9e9ITOVwPaXrvUZzi3qserInsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=Y3NmvPCp; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="Y3NmvPCp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=NjNkhDBw5z9qx1Sd2yFZ9YwmtUY03hiScUqRma92TIE=; b=Y3NmvPCp3BA/r2y2UXEJBjgfy9
	wTqJVPGY6lk9pF0Y0cu+6PPrseEyjNUR1UDPGb9sIGJm+UDuXmHsni702OvyX5GsjRqB48lLkOEF+
	r6AyvUqFKqMyn+AibRppeCpZeGg3J95AO8FcBpnS+xt9yltWU+G+O9lyA7JB5fcqx99ISsjvqNR7s
	swPnk4SSem0TlW8XiKgm9Ud2n3D1+prSgG9J301RjR33RDtA3/vVncUl3ANNJ0coonV00Vve81yK1
	XbuG4vTaMoXMabP4DUe5OqA8KP9+XWpwqfTrSaauIjAvtZ224EtLBA8FCRfSsk0Kdh30WegkmDhBP
	60EuZFZny5c3+uBVTDnb8ltEy4RC7TfocB2W3satLhv6RSTZFoYeTliFmXWVTVtkXWIWdRiTChZpp
	pnKjCeb2CXqIdaFwiLUlTEZN9e/DFRHyaB1/Q+WdQMaLXglH6Dv5ZGr7qyl9FdjICvrQGy2Qv7hen
	toPZ6Tlg3jblMNZAQwVsegBs;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqe1j-000jNf-2F;
	Mon, 25 Aug 2025 20:42:51 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v4 005/142] smb: smbdirect: introduce smbdirect_socket.send_io.credits.{count,wait_queue}
Date: Mon, 25 Aug 2025 22:39:26 +0200
Message-ID: <53c154928e2debc07615bf71e0b09f0990ae34ba.1756139607.git.metze@samba.org>
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

This will be shared between client and server soon.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/common/smbdirect/smbdirect_socket.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_socket.h b/fs/smb/common/smbdirect/smbdirect_socket.h
index bfae68177e50..fc52c85a32fe 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.h
+++ b/fs/smb/common/smbdirect/smbdirect_socket.h
@@ -55,6 +55,14 @@ struct smbdirect_socket {
 			mempool_t		*pool;
 		} mem;
 
+		/*
+		 * The credit state for the send side
+		 */
+		struct {
+			atomic_t count;
+			wait_queue_head_t wait_queue;
+		} credits;
+
 		/*
 		 * The state about posted/pending sends
 		 */
@@ -131,6 +139,9 @@ static __always_inline void smbdirect_socket_init(struct smbdirect_socket *sc)
 
 	init_waitqueue_head(&sc->status_wait);
 
+	atomic_set(&sc->send_io.credits.count, 0);
+	init_waitqueue_head(&sc->send_io.credits.wait_queue);
+
 	atomic_set(&sc->send_io.pending.count, 0);
 	init_waitqueue_head(&sc->send_io.pending.wait_queue);
 
-- 
2.43.0

