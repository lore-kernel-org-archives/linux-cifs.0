Received: from mx1.cyberprotect.ru (mx1.cyberprotect.ru [185.232.107.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E1E7081C;
	Sat,  3 May 2025 18:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.232.107.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746297811; cv=none; b=Po14UiayQ99ERbm+7xMSRqLK0w1A3iknYInLCfuZRZNAkVBTy8YM3/d+10n+eejPjG6Xehf7EMQ5o1SWkbY1jjB98bdgIM87dIyyv0RIn3V0it2r6YTdNDgK8z5mYyrVibk6my9+OQ5HNeVLBxyWNFxu9ru3q2ixZcA0XQ3eaAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746297811; c=relaxed/simple;
	bh=USaZuTsR8q/Z19BZKpqGh4iXZ0cGELGuZYmQNFyB+TY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=jqs02RsGLJsfSIQiVyg2xeQ9lEDt2xl62xP2vzURWQ0DeCKnLtd7wrGb8tZ22JoCRztpjZyd+RdHrM3kJjbxHJUqUetNUWdtq8c0tyo2yTrVDq5zSaO9C4FqwO6vFngYCDKHBmWWCSl2ItOVOgDhLkKB+3Wfg202p1grGUsfIhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cyberprotect.ru; spf=pass smtp.mailfrom=cyberprotect.ru; dkim=permerror (0-bit key) header.d=cyberprotect.ru header.i=@cyberprotect.ru header.b=8ZqGtmvY; dkim=pass (2048-bit key) header.d=cyberprotect.ru header.i=@cyberprotect.ru header.b=KGkdryGF; arc=none smtp.client-ip=185.232.107.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cyberprotect.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cyberprotect.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=permerror (0-bit key) header.d=cyberprotect.ru header.i=@cyberprotect.ru header.b="8ZqGtmvY";
	dkim=pass (2048-bit key) header.d=cyberprotect.ru header.i=@cyberprotect.ru header.b="KGkdryGF"
DKIM-Signature: v=1; a=ed25519-sha256; q=dns/txt; c=relaxed/relaxed;
	d=cyberprotect.ru; s=dkim; h=MIME-Version:Date:From:Sender:Reply-To;
	bh=/SyZKvqdJwrb2CSWfcnGSl3g9y4CF8icT7ILLzdG87I=; b=8ZqGtmvYqzie0st09pRbdH0VRz
	LaUaxUI/in3xRF1pZpJdMoMGmmasMN13AO/ZukxE1DGVYDGCa0sqPvSBcHAw==;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=cyberprotect.ru; s=dkim-r; h=MIME-Version:Date:From:Sender:Reply-To;
	bh=/SyZKvqdJwrb2CSWfcnGSl3g9y4CF8icT7ILLzdG87I=; b=KGkdryGF98IC+ihtKbQlTiXLRb
	KJ7UxEr14q0rC7X7wXx4cuiNsvANjNxGAKpTMu6/vZQ7qx00NJJiU22EONhwbuqtjUBlJAWyyTfkd
	unX+jboqfqFc8Xa+pxW9lTQQ3hBYZJN+0E/DjGpJiFKGcM18mKMVCIJThP/aIchq8N0mctvLqzhjL
	vMIe9dNMLI4Q/NA3Kgp7ScZieesKuzU4nabWzrvZpqNrcXbw13FJNQrhdKhfu+KjZ/ti1MiXApFiN
	SLZV/bghoH1zi5E2H3pYme5eWKrlpaVJKxD8bYJeOPXTRDY/oyRxlGYQ6JQJBeZkNexz8LR9XCcR+
	X8XXsWjg==;
From: Pavel Paklov <Pavel.Paklov@cyberprotect.ru>
To: <stable@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <pavel.paklov@cyberprotect.ru>, Steve French <sfrench@samba.org>, Paulo
 Alcantara <pc@cjr.nz>, Ronnie Sahlberg <lsahlber@redhat.com>, Tom Talpey
	<tom@talpey.com>, <linux-cifs@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <lvc-project@linuxtesting.org>, Jay Shin
	<jaeshin@redhat.com>, Paulo Alcantara <pc@manguebit.com>, Steve French
	<stfrench@microsoft.com>
Subject: [PATCH 6.1] smb: client: fix double free of TCP_Server_Info::hostname
Date: Sat, 3 May 2025 17:57:56 +0000
Message-ID: <20250503175819.2818701-1-Pavel.Paklov@cyberprotect.ru>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Pavel Paklov <pavel.paklov@cyberprotect.ru>

From: Paulo Alcantara <pc@manguebit.com>

commit fa2f9906a7b333ba757a7dbae0713d8a5396186e upstream

When shutting down the server in cifs_put_tcp_session(), cifsd thread
might be reconnecting to multiple DFS targets before it realizes it
should exit the loop, so @server->hostname can't be freed as long as
cifsd thread isn't done.  Otherwise the following can happen:

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
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Pavel Paklov <pavel.paklov@cyberprotect.ru>
---
Backport fix for CVE-2025-21673
 fs/smb/client/connect.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 01ce81f77e89..2b0657fe2a3f 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -1066,6 +1066,7 @@ static void clean_demultiplex_info(struct TCP_Server_Info *server)
 	kfree(server->origin_fullpath);
 	kfree(server->leaf_fullpath);
 #endif
+	kfree(server->hostname);
 	kfree(server);
 
 	length = atomic_dec_return(&tcpSesAllocCount);
@@ -1688,8 +1689,6 @@ cifs_put_tcp_session(struct TCP_Server_Info *server, int from_reconnect)
 	kfree_sensitive(server->session_key.response);
 	server->session_key.response = NULL;
 	server->session_key.len = 0;
-	kfree(server->hostname);
-	server->hostname = NULL;
 
 	task = xchg(&server->tsk, NULL);
 	if (task)
-- 
2.43.0

