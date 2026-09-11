Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CAB75921F5;
	Fri, 11 Sep 2026 20:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789159490; cv=none; b=EuercaJdS7MFGpvQwead+3/U/aAsJDBDAyA6P1DLESRUMcLJDXaBH22KzHftn2rBylEDiuNhoBx6b+CUUlGcTEcVzqeGPx1W2ezj6z3UX6bKBQpyRRu4/2rpF9OBPCPPziGFr/DsboDQ3Xzr+U5xwyB4Tx2YQcwnfQhtRYAkHJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789159490; c=relaxed/simple;
	bh=B0QlJJgpQrvNki3VWTTWXX6ET3zEvsgeG+tLBbS2U2E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HtrzCmHxqQNSUxyFGyf1jZBngFYm0RMJ02MA/aW8Vj6vlG5JHzRnNXL0uOI8IzBGgujcPB4Vp1InD3AgdqqmX2f40XwlOFITNpbrltF8wsdVzysP8qB5R3rALSAGYYMhpjOVBSFZlpmDmzBlZYqIpO0JidFf1Wpx2ao5uNHlNBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=DStkJLif; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="DStkJLif"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:Message-ID:
	Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=OlE3EEI1PNpe4LteSgyHnUlkBf/IsEW3LTNzrM3ENzQ=; b=DStkJLifbfJSATHjYXYgB9IgPg
	+cby3zi1/PiyJXrdgV5RbNHtIoQLtku2MYts6sLfDf9STAOq1ynZCXcZANoFIKSTmtwpwVwEq/C6+
	FODDzWnCx7BeuEmBaevwdRRhlp45HCwHLJUX8UmKe5bjE1erE/2yTgG7AYO4xbRSxdfvpFJGdw2Bl
	KauUdUdGaZuZLAPxRZ9P4SGn9d/waGAyY60bv8RFkz3oUfOv6nlZlgvoXYzzyQB4fUrK8pgAxhuve
	/rJHtiQMADqqPfsScfNiuBKMoYRpaOxY22dgx5LkxDKnftMLlxV/HNsZr4yEIizzv47wx+/RlS5Eb
	WuB9AC2Q==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x5874-00000001F3p-2WSF;
	Fri, 11 Sep 2026 17:44:46 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: linux-cifs@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	stable@vger.kernel.org
Subject: [PATCH] smb: client: fix rlist race and missing initialization
Date: Fri, 11 Sep 2026 17:44:46 -0300
Message-ID: <20260911204446.1719356-1-pc@manguebit.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

TCP_Server_Info.rlist is allocated via kzalloc which zeros both ->next
and ->prev to NULL instead of pointing to itself, making list_empty()
always return false and list_add() dereference a NULL ->prev pointer.

Also, cifs_signal_cifsd_for_reconnect() can be called concurrently
from multiple cifsd threads, allowing the same server's rlist node to
be added twice into the local list, corrupting it.

Fixes: df0e03a4fb94 ("smb: client: fix potential deadlock when reconnecting channels")
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: stable@vger.kernel.org
---
 fs/smb/client/connect.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index b6e98eb31673..bb256b60aa5d 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -174,6 +174,8 @@ cifs_signal_cifsd_for_reconnect(struct TCP_Server_Info *server,
 				nserver = ses->chans[i].server;
 				if (!nserver)
 					continue;
+				if (!list_empty(&nserver->rlist))
+					continue;
 				nserver->srv_count++;
 				list_add(&nserver->rlist, &reco);
 			}
@@ -1823,6 +1825,7 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
 	spin_lock_init(&tcp_ses->mid_counter_lock);
 	INIT_LIST_HEAD(&tcp_ses->tcp_ses_list);
 	INIT_LIST_HEAD(&tcp_ses->smb_ses_list);
+	INIT_LIST_HEAD(&tcp_ses->rlist);
 	INIT_DELAYED_WORK(&tcp_ses->echo, cifs_echo_request);
 	INIT_DELAYED_WORK(&tcp_ses->reconnect, smb2_reconnect_server);
 	mutex_init(&tcp_ses->reconnect_mutex);
-- 
2.55.0

