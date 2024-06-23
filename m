Received: from msa.smtpout.orange.fr (smtp-77.smtpout.orange.fr [80.12.242.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F7B52AD22;
	Sun, 23 Jun 2024 18:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.12.242.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719166163; cv=none; b=mdQgJt21YgiZfXTnqZO+7uRFRjClNld30A9Fuh8gnDSOrilOnd5Kbdifc4GvLnRD6kNn+JxyBqpYbq+LsJjS6a/ljkj+9+t9+CKfrgM8dgLY1W5+F/FK8PGfdorGgjom1Opios1SJUDrAiY4aUmqtU8CY9ZOhoEOLzoPrgaH6wE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719166163; c=relaxed/simple;
	bh=J3vMmXnzQe6rhIKhDI1/B7ym+GQlPi5XIJq1ayivNTM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=F6T3cexrO39jfnQG1bPrIbz4/kYVOwqhU123427Rh0Em9mF9v1nBDJh+th/8/QPvNhetTV7itTwRki6ldDJ9u9NOXfPu86CvDHepzzIgMT+hArSnsKEuY+jo0WkKXB97TT0g9UYFbakshY/rp9cgvU/V3pFmOVaS1j3jZPaLEMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr; spf=pass smtp.mailfrom=wanadoo.fr; dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b=LOzMV2Ib; arc=none smtp.client-ip=80.12.242.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="LOzMV2Ib"
Received: from fedora.home ([86.243.222.230])
	by smtp.orange.fr with ESMTPA
	id LRdBslRkGqHypLRdCsRNHd; Sun, 23 Jun 2024 20:08:02 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1719166082;
	bh=zcGRcZWW7cYNaHFvJZxbefnI7dyccoMtktK8GbPAaWk=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=LOzMV2Ib3hYVdxzXTxRS/vIMWOcazC6+fi/DkneBn489NlGZycGOzJqEyKLhkU5xb
	 i8goEQEaHn0Cu7eSsaag/QdckMG25TsdAo5iUkQX0ghm1GiGYqaidXoUDeEH2VhLMG
	 b86ou9M9RHWerz2CUr8QVUkhDKS/V7oteqUklsPqPaO0BrvvJ/qCvnyrNv3kqTYhf+
	 j6tdSDAEN6n94c4ZGUYeyatz9Hf1ShXgDaHA3u9Nz11hzTd9ctfJnSrm3Dd9gNHJlM
	 vcY42aEGZMUZxNZZoRBPsESbZuWS+5U+71nem5bQrG0+gRqHdzJUrSHdMUPiAt3eWs
	 9ztcuhYyLnQeA==
X-ME-Helo: fedora.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 23 Jun 2024 20:08:02 +0200
X-ME-IP: 86.243.222.230
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <sfrench@samba.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>
Cc: linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	linux-cifs@vger.kernel.org
Subject: [PATCH] ksmbd: Constify struct ksmbd_transport_ops
Date: Sun, 23 Jun 2024 20:07:58 +0200
Message-ID: <c06ecbfde4cc106603285ed96febf3b887425286.1719160522.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

'struct ksmbd_transport_ops' is not modified in these drivers.

Constifying this structure moves some data to a read-only section, so
increase overall security.

On a x86_64, with allmodconfig, as an example:
Before:
======
   text	   data	    bss	    dec	    hex	filename
  52184	   2085	    256	  54525	   d4fd	fs/smb/server/transport_rdma.o

After:
=====
   text	   data	    bss	    dec	    hex	filename
  52260	   2021	    256	  54537	   d509	fs/smb/server/transport_rdma.o

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
Compile tested-only
---
 fs/smb/server/connection.h     | 4 ++--
 fs/smb/server/transport_rdma.c | 4 ++--
 fs/smb/server/transport_tcp.c  | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/smb/server/connection.h b/fs/smb/server/connection.h
index 0e04cf8b1d89..5c2845e47cf2 100644
--- a/fs/smb/server/connection.h
+++ b/fs/smb/server/connection.h
@@ -133,8 +133,8 @@ struct ksmbd_transport_ops {
 };
 
 struct ksmbd_transport {
-	struct ksmbd_conn		*conn;
-	struct ksmbd_transport_ops	*ops;
+	struct ksmbd_conn			*conn;
+	const struct ksmbd_transport_ops	*ops;
 };
 
 #define KSMBD_TCP_RECV_TIMEOUT	(7 * HZ)
diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 8faa25c6e129..cf4418f72772 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -164,7 +164,7 @@ enum {
 	SMB_DIRECT_MSG_DATA_TRANSFER
 };
 
-static struct ksmbd_transport_ops ksmbd_smb_direct_transport_ops;
+static const struct ksmbd_transport_ops ksmbd_smb_direct_transport_ops;
 
 struct smb_direct_send_ctx {
 	struct list_head	msg_list;
@@ -2292,7 +2292,7 @@ bool ksmbd_rdma_capable_netdev(struct net_device *netdev)
 	return rdma_capable;
 }
 
-static struct ksmbd_transport_ops ksmbd_smb_direct_transport_ops = {
+static const struct ksmbd_transport_ops ksmbd_smb_direct_transport_ops = {
 	.prepare	= smb_direct_prepare,
 	.disconnect	= smb_direct_disconnect,
 	.shutdown	= smb_direct_shutdown,
diff --git a/fs/smb/server/transport_tcp.c b/fs/smb/server/transport_tcp.c
index 6633fa78e9b9..a84788396daa 100644
--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -37,7 +37,7 @@ struct tcp_transport {
 	unsigned int			nr_iov;
 };
 
-static struct ksmbd_transport_ops ksmbd_tcp_transport_ops;
+static const struct ksmbd_transport_ops ksmbd_tcp_transport_ops;
 
 static void tcp_stop_kthread(struct task_struct *kthread);
 static struct interface *alloc_iface(char *ifname);
@@ -649,7 +649,7 @@ int ksmbd_tcp_set_interfaces(char *ifc_list, int ifc_list_sz)
 	return 0;
 }
 
-static struct ksmbd_transport_ops ksmbd_tcp_transport_ops = {
+static const struct ksmbd_transport_ops ksmbd_tcp_transport_ops = {
 	.read		= ksmbd_tcp_read,
 	.writev		= ksmbd_tcp_writev,
 	.disconnect	= ksmbd_tcp_disconnect,
-- 
2.45.2

