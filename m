Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48440242D95
	for <linux-cifs@vger.kernel.org>; Tue,  5 Aug 2025 16:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754410323; cv=none; b=CrOxzuIUKOCiaCP9QFJIatw7AwJcUUp0flAZtXEbRUaoybyIGzDUTPUYlaLzx/BwMdwlPKKYLZ13j6DTofWLnjwrz0OT9tQLF5R6MyFW8hq+9rQsY2c7lzaskgM3Ooz/jgjQN0cHwaqE829iNO7O9SuZKkCj9uLFOZ87aels1dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754410323; c=relaxed/simple;
	bh=hCXgOTnbGYmpivNECnmwvVdollVDxqRdYJGgYJoXyks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bcXwC1R3u5KlqaUYWz+A4weaNpO3YsCYsWXHVBCSgSr4eagw19DQafAiWI06HSe4SeRqlL9MzZdIhPAPR3TYrBTi4rpbevvHG6C/WGkIdD4A/Pv9yilb93b+oXuhZkD6SONca/2003iLUGFbG0wt4L9Dcatkcy8hSDNx0v33P+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=YKyT3mUo; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="YKyT3mUo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=Bh68EdVExnVkeLOMNqsgNTCQscf3EXNVbkCB3TL2LJU=; b=YKyT3mUoSlTBWqsUgqnqcRdkAx
	TpgdcPjQxdCgVc4S/hHhp3kpiPsJbCosqK439nySYMm6dappDGM4EuDopi0313zLJBIshHHSeVbA8
	xUADe/FjXAfNKbA+lGd+8iZ6mE5iT/gnyBzduom4ZoaL7bgymWkr6LU1dnyLYX8NE4EG6C8Nu+6Ly
	U9GWR0a1j/komt7o6DhY0eDjvi3+tkL6RvOGzCgEmUcBjOH+XvcQ8GAZr30jm/C0nEXlYkf0bp6iM
	nJ2a2Fb82hZEjoCKZjujEks+PcyugsdR2TSRWHiOkIhYVxm1FyElF8DFFjQ8NjL6n6zW471h064fc
	9zYMk4iBDHWk+/m+RFKCqRcbUfsmRZwvqeZTYhbURNfZx3lsMsW4y5YD9BvNFjOO6QBGeANJQv5dm
	AticqjQOAludFQ8tE7Kg3CkS4EXU+3CHQ16xgBiQh24fRlzDcUYA/CDhvKu75+tTMnJH+Mdy0eUhr
	xtjUGE3/f/BICVn8eoGeT0ou;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1ujKGd-0019Yw-06;
	Tue, 05 Aug 2025 16:11:59 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>
Subject: [PATCH 01/17] smb: client: remove unused smbd_connection->fragment_reassembly_remaining
Date: Tue,  5 Aug 2025 18:11:29 +0200
Message-ID: <23c4c45dba966820bebcf579b8937596a6333c8e.1754409478.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1754409478.git.metze@samba.org>
References: <cover.1754409478.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/cifs_debug.c | 2 --
 fs/smb/client/smbdirect.h  | 1 -
 2 files changed, 3 deletions(-)

diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
index fe107ef8c4cd..d462fed843ee 100644
--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -467,13 +467,11 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 		seq_printf(m, "\nRead Queue count_reassembly_queue: %x "
 			"count_enqueue_reassembly_queue: %x "
 			"count_dequeue_reassembly_queue: %x "
-			"fragment_reassembly_remaining: %x "
 			"reassembly_data_length: %x "
 			"reassembly_queue_length: %x",
 			server->smbd_conn->count_reassembly_queue,
 			server->smbd_conn->count_enqueue_reassembly_queue,
 			server->smbd_conn->count_dequeue_reassembly_queue,
-			server->smbd_conn->fragment_reassembly_remaining,
 			server->smbd_conn->reassembly_data_length,
 			server->smbd_conn->reassembly_queue_length);
 		seq_printf(m, "\nCurrent Credits send_credits: %x "
diff --git a/fs/smb/client/smbdirect.h b/fs/smb/client/smbdirect.h
index ea04ce8a9763..a2026c542989 100644
--- a/fs/smb/client/smbdirect.h
+++ b/fs/smb/client/smbdirect.h
@@ -75,7 +75,6 @@ struct smbd_connection {
 	atomic_t send_credits;
 	atomic_t receive_credits;
 	int receive_credit_target;
-	int fragment_reassembly_remaining;
 
 	/* Memory registrations */
 	/* Maximum number of RDMA read/write outstanding on this connection */
-- 
2.43.0

