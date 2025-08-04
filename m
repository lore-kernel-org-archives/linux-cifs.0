Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D2452580E1
	for <linux-cifs@vger.kernel.org>; Mon,  4 Aug 2025 12:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754309813; cv=none; b=uDXNVsq4iu1+/cSWzdbnd/ic8CwN0MuA8mTFSgNIIbKe+P8w0NldEExwiMgLStWtZCu4mUGOSKPP1hmi+M4anoLnOkKZJpqyyiluvoO0wRTj5GjSpBtx/+amdWjzyZGCBFx7WYT1tZ4xdToHkZ7Frj4P1Y6X9ujwCrFp+eoKoIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754309813; c=relaxed/simple;
	bh=D5vyEZdQ9GHri8zu2xpG1i1CyKfkf2H5G3+mYxKL9bs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t6x/wv10/97N59cDqvQ8Xx7Mf53eRhDP2Onev/bjG2dGpg87xxRmL9CeUz8ALuXm4pk3DGVNUr2BDFx3VyuMTm1M4k7Is8UmglyZ2sDAuqbW8lYrOT9byTz0cptS84PcH3A64Oc0y7GfTls1xgmLOBj5Tfae3kIZW+V0PjBbcNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=EeswnoR/; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="EeswnoR/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=vpYNfHJCm2TKf3k81xlz/NPMEPzdDJamDlwUAHDZ3Aw=; b=EeswnoR/dQjL0ZIIYmNJmvpxLw
	5wYKObylEhgAh7gb9igoz7WFSn+zONY2s6Am+Krt8Ic6ncvPmEpra4BULYM4vb0LrIeQnmXVzMfN1
	MinyHpWGhwc7MoUIdjHEOifolktD3LginFK3azRQoM1LRARwP/g9FT954+9s7Jl5SRJcSMv0DHrD4
	hLY/zGzPDx2EBRex09Kf+WDEKGAlJhmrfgvPlgUve3g3f0Jm8BwEBwWQ/8z0ON6zv5GFH6fwMbTGz
	cQJs6UqXe97QSEklcSPkVluMOnT3uvbXutbsvzCjfQsg3GealZrMGAH349U4OSDyVa79z1UqCH6qE
	QBqmv1vE2/GUC3KkuOWELaDeHwRAPhLIbTVGnLLuan/jEjhPAJe/z2OdqgVStIih1pPf1Rs1fFD84
	94SFnv9qY+gzZi4/jtMVhIgMysDD6zzJMnvl9wANyV2pbo0h6RRcqWuxhDq9dL6lAIJcSyfMTQuSf
	dnpg5kAOj9oPbsfYeml4DOSN;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uiu7U-000wHH-1t;
	Mon, 04 Aug 2025 12:16:48 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH 4/4] smb: server: let recv_done() avoid touching data_transfer after cleanup/move
Date: Mon,  4 Aug 2025 14:15:53 +0200
Message-ID: <111d25fd9256d158e9521db36b6196972bd68b9d.1754309565.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1754309565.git.metze@samba.org>
References: <cover.1754309565.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Calling enqueue_reassembly() and wake_up_interruptible(&t->wait_reassembly_queue)
or put_receive_buffer() means the recvmsg/data_transfer pointer might
get re-used by another thread, which means these should be
the last operations before calling return.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Fixes: 0626e6641f6b ("cifsd: add server handler for central processing and tranport layers")
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/transport_rdma.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index cd8a92fe372b..8d366db5f605 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -581,16 +581,11 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 			else
 				t->full_packet_received = true;
 
-			enqueue_reassembly(t, recvmsg, (int)data_length);
-			wake_up_interruptible(&t->wait_reassembly_queue);
-
 			spin_lock(&t->receive_credit_lock);
 			receive_credits = --(t->recv_credits);
 			avail_recvmsg_count = t->count_avail_recvmsg;
 			spin_unlock(&t->receive_credit_lock);
 		} else {
-			put_recvmsg(t, recvmsg);
-
 			spin_lock(&t->receive_credit_lock);
 			receive_credits = --(t->recv_credits);
 			avail_recvmsg_count = ++(t->count_avail_recvmsg);
@@ -612,6 +607,13 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		if (is_receive_credit_post_required(receive_credits, avail_recvmsg_count))
 			mod_delayed_work(smb_direct_wq,
 					 &t->post_recv_credits_work, 0);
+
+		if (data_length) {
+			enqueue_reassembly(t, recvmsg, (int)data_length);
+			wake_up_interruptible(&t->wait_reassembly_queue);
+		} else
+			put_recvmsg(t, recvmsg);
+
 		return;
 	}
 	}
-- 
2.43.0

