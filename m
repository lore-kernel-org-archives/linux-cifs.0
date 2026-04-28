Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88B0829D291
	for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 15:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777391909; cv=none; b=gZ/T2Vbl2qvkwaB5Di1PnWTJeohE3wffq2vfkUDOh+9D+n4SID2HprV0sn0Ee3hMyE/n7P3uIqkYvJFiNgXSXxCNhzFyrIa8w6STFsf9Z3+TG2hmKu3UtPUdLFc6SyipYOKTOirIipbOZSFuS38nL9QLdiDBx7ETLT8HLTfjxSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777391909; c=relaxed/simple;
	bh=7jajndUaHxnO7mBKOUKcC+hvpwMvV7Fyx+SUs+EJDy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rpp88b/fQhJZ2AyIejDtSO46HQP6eZ486VgkF58CBa2HnvFsSf0u7RRskDzeI9L9wwjncBUwRCXhXcqTvMT8A9EN8z38djrUKTc2kG2P7o1Op8dx96qaqLip5ZbB9kg+ZdYiBHrhgWUUh1+g5CmXwnZqV9QY8COf4gzhQmNlIto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=HHBKjo59; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="HHBKjo59"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-488b3f8fa2bso118528845e9.1
        for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 08:58:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777391905; x=1777996705; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=12Q+vhefEhwDztzLby3rXl6SFVTsFUNMgjupbc4MgPQ=;
        b=HHBKjo59fvasaTw9daZ1iglQtW3D+o/+d4WY+oafldScWoxUSZQ1VQoeWBfAFvG+2o
         3bHWkAkBQseZ3SoSR9H0EehXlWojbtGkT0jM560+43VVMykjoz9ZOLKH42KR77tg8oCH
         xCs3lrCW3ZW4TVmAoW5XE6vAnJiExvZZpk5ETOiHTkLMNzG+HdE/WW9ZmVZgSUK/lbiu
         ak7VL+xh5AqXE/oD0Xe8jOz/bI9Jo+kH9FHmyx3eAgYTp9l8pYsE+qlNadAIGXPNbjPN
         9XOaz7y4vLjlG6kQBjc2c4HIqhZgbD9mmwBLGWpn7SAwTDpqvCXM1hg2w8yRzdvXsE/c
         +ONA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777391905; x=1777996705;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=12Q+vhefEhwDztzLby3rXl6SFVTsFUNMgjupbc4MgPQ=;
        b=AYJ1hbULeV6jGICovcRNz3GAdBmx7E1V7I3hW7fQcD3l6W0QJqmqYp/egVxEd62WsF
         KgnJYgZiKkwuAceEJDEeXEyccL0LqAlJJNa5ACc3CZXYZHzNThOV5GDIvBj421iwFytZ
         3V7hiyYipH6mzlFUxmCXq5H62SnA6qLTxICfthaZg6PDZx4gq1xrNIshBoOBDJE8PsTR
         hqNpI+V3ezK12u2VLuEVyDzV3AU54CFu7pof5ydj+m8u029CJKoZbZugOHEpFdlwdzuT
         HzMIeeYHpOqfbUHwqKGxV2HspPOh3SxN7yRVS3eOgO45mf9vXRnsBkMxyM7n1xknh69U
         8EOA==
X-Gm-Message-State: AOJu0YxZzm4juNF/d7UQiT6e4YbisXp6t5E+VfCDUxVty1I1nahss1D/
	p56Da0dzdO8vQY9K3bNCvWUvzOl6cG7VkUk5otcBN705fpmM9Me2myBJZlmNL8iQLFZWQqWcSyO
	Ynap5XY7h4w==
X-Gm-Gg: AeBDiesUJqvItQPIcgKlPsLEWRI4PpyYpCJY5Yvvai9bKmGYLMneLeSll8qfPEDaXul
	6gmmMmhcWhXyymbU9xPPF2G/V+vl34C7jD9CFcb92qm0SQ9qezPhA3FHRQjZtr2a0DRDwWOFwYb
	XMUPnoBCnpL5hxHH/LbDWAvEZXraGd6kkM1//WWuX9iOJ6N7oPDVZyiwWm4CJ2SqHLLdEQwVRhW
	qtP1d+HPjbPSEtOvYy76FJf2a4P1pVm5GmGf1jdNLz2gEGOvnwv9NI/uU2RLZPLpXXdbpYYPF9B
	KWLVavawN7ZIwmnyneuLaJygGlhEaN74qP7k6GZGzk385KYbZCXasF66YSvlvtiErwUYuKJ4u1v
	JeLv1bfSMSg8b0Q3vTev2Da08fKSmSLdnF7Qm5V4+35tg3MtiNiBaCk+89tP6phbhdEeKJAk6Oq
	Hu1Iid1HZnBHJrLbE0oYvVBZWiXlMIcIol70/67SH11B3e
X-Received: by 2002:a05:600c:4797:b0:48a:761:5816 with SMTP id 5b1f17b1804b1-48a78a2f7dfmr31718375e9.8.1777391905476;
        Tue, 28 Apr 2026 08:58:25 -0700 (PDT)
Received: from precision ([2a01:4b00:c007:bb00:be9d:a3c4:18b1:4a25])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a7b560a84sm3409255e9.4.2026.04.28.08.58.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 08:58:25 -0700 (PDT)
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: linux-cifs@vger.kernel.org
Cc: linkinjeon@kernel.org,
	sfrench@samba.org,
	metze@samba.org,
	senozhatsky@chromium.org,
	tom@talpey.com,
	ematsumiya@suse.de,
	Henrique Carvalho <henrique.carvalho@suse.com>
Subject: [PATCH v2 09/11] smb: server: refactor TCP transport definitions
Date: Tue, 28 Apr 2026 12:57:58 -0300
Message-ID: <20260428155759.226368-5-henrique.carvalho@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428155759.226368-1-henrique.carvalho@suse.com>
References: <20260428155759.226368-1-henrique.carvalho@suse.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move the TCP timeout definitions into transport_tcp.h and rename the
peer address accessor in connection.h to a transport-neutral name.

Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
---
 fs/smb/server/connection.h        | 4 +---
 fs/smb/server/mgmt/tree_connect.c | 2 +-
 fs/smb/server/transport_tcp.h     | 3 +++
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/connection.h b/fs/smb/server/connection.h
index 0e87283a9ddb..f874bbdd4b34 100644
--- a/fs/smb/server/connection.h
+++ b/fs/smb/server/connection.h
@@ -145,9 +145,7 @@ struct ksmbd_transport_ops {
 	void (*free_transport)(struct ksmbd_transport *kt);
 };
 
-#define KSMBD_TCP_RECV_TIMEOUT	(7 * HZ)
-#define KSMBD_TCP_SEND_TIMEOUT	(5 * HZ)
-#define KSMBD_TCP_PEER_SOCKADDR(c)	((struct sockaddr *)&((c)->peer_addr))
+#define KSMBD_PEER_SOCKADDR(c)	((struct sockaddr *)&((c)->peer_addr))
 
 #define CONN_HASH_BITS	12
 extern DECLARE_HASHTABLE(conn_list, CONN_HASH_BITS);
diff --git a/fs/smb/server/mgmt/tree_connect.c b/fs/smb/server/mgmt/tree_connect.c
index a72d7e42a6c2..7704d8554591 100644
--- a/fs/smb/server/mgmt/tree_connect.c
+++ b/fs/smb/server/mgmt/tree_connect.c
@@ -44,7 +44,7 @@ ksmbd_tree_conn_connect(struct ksmbd_work *work, const char *share_name)
 		goto out_error;
 	}
 
-	peer_addr = KSMBD_TCP_PEER_SOCKADDR(conn);
+	peer_addr = KSMBD_PEER_SOCKADDR(conn);
 	resp = ksmbd_ipc_tree_connect_request(sess,
 					      sc,
 					      tree_conn,
diff --git a/fs/smb/server/transport_tcp.h b/fs/smb/server/transport_tcp.h
index d122e4b69d65..ef5ba9affc3f 100644
--- a/fs/smb/server/transport_tcp.h
+++ b/fs/smb/server/transport_tcp.h
@@ -8,6 +8,9 @@
 
 #include "interface.h"
 
+#define KSMBD_TCP_RECV_TIMEOUT	(7 * HZ)
+#define KSMBD_TCP_SEND_TIMEOUT	(5 * HZ)
+
 void ksmbd_free_transport(struct ksmbd_transport *kt);
 int ksmbd_tcp_init(void);
 void ksmbd_tcp_destroy(void);
-- 
2.53.0

