Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59D1838F949;
	Sat, 12 Sep 2026 16:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232107; cv=none; b=QgdKk+W7URmPNe4eE/eJFHVc1AZ3sBZuZjHNrpXa7I/cGQvQvAlaXv9PJJwp35ZHaRWI3Ewbn5reWWAtPT5M1q60YIzwbhzu5pDA4N0tYgTJlTJCVcNSytZvnm48BR2xP73Bjmh/C/gD7BMArvawkuJmpMsQWvoZeTjH6llObQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232107; c=relaxed/simple;
	bh=/jmm2aVW9UAYOf+kSwMbHi29736SD+qrLU7zbDLQSRE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NQzJdwqZugKpeMhHt/qc/pOAvCdhZbWh3PVi/FIOgZyy6o2zvYVGrxJivxQb0VDDO5dUYSLVUJZB+NVS1BvTVlgtOFN0Nrg+CpGofavfxNjNn2lhYkksNGamucSQ2Dh9BxVG2edwOCGdMgNzmaNK6Mgk3dkj4rc/1P94zXrurXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=RIl5A/NU; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="RIl5A/NU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:Message-ID:
	Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=VJapbbZr2P/EcJp0eQ7mmRwmw9vSY38JTmHMxvMZEys=; b=RIl5A/NU48cUSGJ2AuXLY/lx+Q
	+v9AtDXvJfQ4VcG4IK63NCXnZPrmAefg5B4BVMtWMUOSYwbvNCH7dovN5dA5NlqbGqvm/eDDZAxt6
	Rlnv9IO1qfzZwsOopfYdLncERFn88cZC6Ensv9e5YcycI8h5mNOwm58AKwZeBQjlDAUNZtEl2k/zT
	SC88WAiZPhOfmUkaIX+5XZ6mqK/UYwgIocr5ERzYfyjz4CrT1P6ECa4HeBfOzyTkyp9SJL1WgSnrb
	KYc/T8UacuNbAv2JqRFmAV++6THceIA26wppbM2bnfGo2ujyIcdepUnnVygFPJfubfPEw7VxvyCQQ
	YzctsVag==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x5R0J-00000001Htq-2Zin;
	Sat, 12 Sep 2026 13:55:03 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: linux-cifs@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH v2] smb: client: fix rlist race and missing initialization
Date: Sat, 12 Sep 2026 13:55:03 -0300
Message-ID: <20260912165503.521597-1-pc@manguebit.org>
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

Closes: https://sashiko.dev/#/patchset/20260911204446.1719356-1-pc%40manguebit.org
Fixes: df0e03a4fb94 ("smb: client: fix potential deadlock when reconnecting channels")
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: stable@vger.kernel.org
---
 fs/smb/client/connect.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index bef710d9a3c3..4bd9f9fb93bb 100644
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
@@ -182,11 +184,15 @@ cifs_signal_cifsd_for_reconnect(struct TCP_Server_Info *server,
 		}
 	}
 
+	spin_lock(&cifs_tcp_ses_lock);
 	list_for_each_entry_safe(server, nserver, &reco, rlist) {
 		list_del_init(&server->rlist);
 		set_need_reco(server);
+		spin_unlock(&cifs_tcp_ses_lock);
 		cifs_put_tcp_session(server, 0);
+		spin_lock(&cifs_tcp_ses_lock);
 	}
+	spin_unlock(&cifs_tcp_ses_lock);
 }
 
 /*
@@ -1824,6 +1830,7 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
 	spin_lock_init(&tcp_ses->mid_counter_lock);
 	INIT_LIST_HEAD(&tcp_ses->tcp_ses_list);
 	INIT_LIST_HEAD(&tcp_ses->smb_ses_list);
+	INIT_LIST_HEAD(&tcp_ses->rlist);
 	INIT_DELAYED_WORK(&tcp_ses->echo, cifs_echo_request);
 	INIT_DELAYED_WORK(&tcp_ses->reconnect, smb2_reconnect_server);
 	mutex_init(&tcp_ses->reconnect_mutex);
-- 
2.55.0

