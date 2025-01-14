Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC0B423242C
	for <linux-cifs@vger.kernel.org>; Tue, 14 Jan 2025 15:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.235.159.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736869742; cv=none; b=oQ0SZB+alrdJ5lLnsXmFE/lPSRIAsFT943qzSx/e4ykhUEILkWFBvWEQV/muH0/lMUyMG2txJrUT5Qv8mDUPonxTyeHOi6topx0xwgst7O/EZkMJHzPIyanBhpHczJfrc5GB5O0Swidjr92hHIkuViRvslsHxNN2lII+lHyaIHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736869742; c=relaxed/simple;
	bh=5Mhs+lFA8+VXif7VnMARvz66UHkAheVCmYKSoMqyGeA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AoEIjUt3isGQ4HkvgA9gto5M1DDrxisB5+SxITqndRhh2BcDwtUH/k4Iwblq6lGkJD0+OPHvFM0dwYi1CVFAqtpxDYGQAzOYq6TxMbBlTGDKSoSHEgF0XiZ7PD0MDTuiKHPPwm1tsuA7F6/f+kojucpMwGQE6afVuAQiUkwrUvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=eyK7C6tA; arc=none smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="eyK7C6tA"
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1736869732;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=VXKMiGQmSd1nUUn+N1a2D0oLZWldx8I8PD5GFA0H9Zc=;
	b=eyK7C6tAehxUtByGv3uQDKFyRZIX6swi/iTzzJ0nDpqA16RyZc69dS3Ci0PdaZ+5i3XfiG
	TpQdpjyF/xSnsMvQszkrlAdyPEtFKOnzpdS0NTNhWWp8cSrYaZ4VFUrvTs1pndOHm0AZNC
	GhhIiyAwS7huY917seSXNFOPq0ADCLAf1yKq25a5m1RAvKofBZUA5oAJe1pWQXPeNpjKUS
	pe9VViK/tkQHIbwItUbDNdtVDI213VcOEs5zeXlATRCQ4MWX4lN4J+2SPpVo0s7jtBSwxO
	PNyOZVqeXgAWyWiXz+7dlrBrD7srd0a137ybn+r4/zNdzexJOh8URn+qmf2YbQ==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Jay Shin <jaeshin@redhat.com>
Subject: [PATCH] smb: client: fix double free of TCP_Server_Info::hostname
Date: Tue, 14 Jan 2025 12:48:48 -0300
Message-ID: <20250114154848.43584-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When shutting down the server in cifs_put_tcp_session(), cifsd thread
might be reconnecting to multiple DFS targets before it realizes it
should exit the loop, so we can't free @server->hostname as long as
cifsd tread is done.  Otherwise the following can happen:

  RIP: 0010:__slab_free+0x223/0x3c0
  Code: 5e 41 5f c3 cc cc cc cc 4c 89 de 4c 89 cf 44 89 44 24 08 4c 89
  1c 24 e8 fb cf 8e 00 44 8b 44 24 08 4c 8b 1c 24 e9 5f fe ff ff <0f>
  0b 41 f7 45 08 00 0d 21 00 0f 85 2d ff ff ff e9 1f ff ff ff 80
  RSP: 0018:ffffb26180dbfd08 EFLAGS: 00010246
  RAX: ffff8ea34728e510 RBX: ffff8ea34728e500 RCX: 0000000000800068
  RDX: 0000000000800068 RSI: 0000000000000000 RDI: ffff8ea340042400
  RBP: ffffe112041ca380 R08: 0000000000000001 R09: 0000000000000000
  R10: 6170732e31303000 R11: 70726f632e786563 R12: ffff8ea34728e500
  R13: ffff8ea340042400 R14: ffff8ea34728e500 R15: 0000000000800068
  FS: 0000000000000000(0000) GS:ffff8ea66fd80000(0000)
  000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 00007ffc25376080 CR3: 000000012a2ba001 CR4:
  PKRU: 55555554
  Call Trace:
   <TASK>
   ? show_trace_log_lvl+0x1c4/0x2df
   ? show_trace_log_lvl+0x1c4/0x2df
   ? __reconnect_target_unlocked+0x3e/0x160 [cifs]
   ? __die_body.cold+0x8/0xd
   ? die+0x2b/0x50
   ? do_trap+0xce/0x120
   ? __slab_free+0x223/0x3c0
   ? do_error_trap+0x65/0x80
   ? __slab_free+0x223/0x3c0
   ? exc_invalid_op+0x4e/0x70
   ? __slab_free+0x223/0x3c0
   ? asm_exc_invalid_op+0x16/0x20
   ? __slab_free+0x223/0x3c0
   ? extract_hostname+0x5c/0xa0 [cifs]
   ? extract_hostname+0x5c/0xa0 [cifs]
   ? __kmalloc+0x4b/0x140
   __reconnect_target_unlocked+0x3e/0x160 [cifs]
   reconnect_dfs_server+0x145/0x430 [cifs]
   cifs_handle_standard+0x1ad/0x1d0 [cifs]
   cifs_demultiplex_thread+0x592/0x730 [cifs]
   ? __pfx_cifs_demultiplex_thread+0x10/0x10 [cifs]
   kthread+0xdd/0x100
   ? __pfx_kthread+0x10/0x10
   ret_from_fork+0x29/0x50
   </TASK>

Fixes: 7be3248f3139 ("cifs: To match file servers, make sure the server hostname matches")
Reported-by: Jay Shin <jaeshin@redhat.com>
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
---
 fs/smb/client/connect.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index ddcc9e514a0e..eaa6be4456d0 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -1044,6 +1044,7 @@ clean_demultiplex_info(struct TCP_Server_Info *server)
 	/* Release netns reference for this server. */
 	put_net(cifs_net_ns(server));
 	kfree(server->leaf_fullpath);
+	kfree(server->hostname);
 	kfree(server);
 
 	length = atomic_dec_return(&tcpSesAllocCount);
@@ -1670,8 +1671,6 @@ cifs_put_tcp_session(struct TCP_Server_Info *server, int from_reconnect)
 	kfree_sensitive(server->session_key.response);
 	server->session_key.response = NULL;
 	server->session_key.len = 0;
-	kfree(server->hostname);
-	server->hostname = NULL;
 
 	task = xchg(&server->tsk, NULL);
 	if (task)
-- 
2.47.1

