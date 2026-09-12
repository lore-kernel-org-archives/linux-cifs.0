Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CD673264D4;
	Sat, 12 Sep 2026 15:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226416; cv=none; b=hsUZL+9pMYzchLl/m6DBszoTDjoSMoEJ8LyIZimZDpYvYY23IvMClw8l5K1G7IUbIq+86zepxipzW/qOSYqql6oXYI7bUDazLdhg7LfLBpnss0IuqZf3cyv3VU7m5Tgt0yJg7ijYKUQW5ALxgAWHM8bUQSV4BT+rvewTPWUQSDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226416; c=relaxed/simple;
	bh=BrpOjzRvfMacMNezEnHboF2vo8DDz14l/uX51eIv46I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QcUzIAN+cdEDoG6mC8fRELYuz4Pruvp9uZMY6hK7UsWLO8zg9zVLvI2hmf+rjsp2mMa4wYPH4+5OmodtxB5rlfBNKr+Igr14YIl0MnwpeopeHPvcP/lMQ8xTxJA0uD4i6vYwqnKM+jpsPAieXx2lIdFuXgv5ipV2I9Dd2ud9Jvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=7fpvNKw0; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="7fpvNKw0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:Message-ID:
	Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=m+z8IGBcOx5mhev39atHGZpRwjVfvx6kUraHWgM4et8=; b=7fpvNKw012eTxZLyGANTiZIvvP
	/UazygCBsTu+1HagcvVyR8sPDyTAgqKQaE1cqN1ZuZkuPN8BCFVfP3BhQ1IXLeGzHRyXhmCOymvyJ
	SDKYyFLByMJjEi+9GyEKUs63LBJTbpcAQV/WM4k21r4agKf7BhFOIIEaMalHRELTUZbUKt1NVfwgQ
	yrIaLtBCJ1IqeET68ao7jjsRz3iXXy7UuBATWRi1UDCvtOJBNWXrjC3q49/OAQoIDYxLoLmPHaB/V
	2YkvraXVSaICUGWRnJu4qIVe/O2QMky/sQKcdFn6kuSnn+B2oiCRuzRPNWQZIaw9+JbVDuDNTO2kv
	Jan0JIwQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x5PWT-00000001Hhm-0HAg;
	Sat, 12 Sep 2026 12:20:09 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: linux-cifs@vger.kernel.org
Cc: syzbot+5003556314abc915a71f@syzkaller.appspotmail.com,
	David Howells <dhowells@redhat.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH] smb: client: cancel reconnect work in clean_demultiplex_info()
Date: Sat, 12 Sep 2026 12:20:08 -0300
Message-ID: <20260912152008.392251-1-pc@manguebit.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

clean_demultiplex_info() cancels server->echo delayed work but not
server->reconnect, which can cause a use-after-free when the
demultiplex thread exits while a reconnect work is still queued:

  cifs_demultiplex_thread()
    cifs_readv_from_socket()
      cifs_reconnect()
        __cifs_reconnect()
          cifs_queue_server_reconn()
            mod_delayed_work(cifsiod_wq, &server->reconnect, 0)
    clean_demultiplex_info()
      cancel_delayed_work_sync(&server->echo)   // echo canceled
                                                 // reconnect NOT canceled
      kfree_sensitive(server)                    // server freed

  ...later, on cifsiod_wq:

  smb2_reconnect_server()
    server->srv_count  // UAF read of freed server

Fix this by canceling server->reconnect delayed work in
clean_demultiplex_info() before the server is freed, the same way
cifs_put_tcp_session() already does.

Reported-by: syzbot+5003556314abc915a71f@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/r/6aa4a12d.f81106d8.2ab401.0023.GAE@google.com
Fixes: 53e0e11efe92 ("CIFS: Fix a possible memory corruption during reconnect")
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: stable@vger.kernel.org
---
 fs/smb/client/connect.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index b6e98eb31673..bef710d9a3c3 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -1067,6 +1067,7 @@ clean_demultiplex_info(struct TCP_Server_Info *server)
 	spin_unlock(&server->srv_lock);
 
 	cancel_delayed_work_sync(&server->echo);
+	cancel_delayed_work_sync(&server->reconnect);
 
 	spin_lock(&server->srv_lock);
 	server->tcpStatus = CifsExiting;
-- 
2.55.0

