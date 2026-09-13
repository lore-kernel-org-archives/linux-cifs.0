Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9487E38DC5A
	for <linux-cifs@vger.kernel.org>; Sun, 13 Sep 2026 23:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789342097; cv=none; b=H+rPnCKCcChFaf2ADWMFmZLPYCHFnk5Dx9W7G4jZGwr2pM2JprXtyY45vJvlws7FafmEKQjCcOiPDq/L4xVCNADvNGxQ6ivEWbkEZcvEVCbTUUE8k2fr3BlO5PfYEIIGcu66f9sasMf9wbURKuYRWY8Y7cY2s5qP6g5+hi973Hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789342097; c=relaxed/simple;
	bh=NRSNQiedtmyO1EmftchigZrmdIYPRvtPCgXbRznGx+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LM0I/LbpZd+kXTdNHezufKx1GZM+xnHpc9cckc1AYJxJg3fqGdaHSlTqbFs2RBJTK072byiJL3yVKXSSHKKLX5xEtzBbCBHVVQdp3BAxZg1iLIzIWNLNTdwTgP0zQLnpIKlc83tjMM06CAOGipgPek2KaPMoAtNP9Y9iKif+7+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VPHeMc6K; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VPHeMc6K"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49e79a408deso404675e9.2
        for <linux-cifs@vger.kernel.org>; Sun, 13 Sep 2026 16:28:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789342094; x=1789946894; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FHGh8Z/iQTWAr7ks0eD3K/QZN7oUordure7S8A/Ywjk=;
        b=VPHeMc6Kst6OhEMZyA6bhqh874IDRB8OlKrPYUKcDn0tObn+avJyj/cIVON1ajEWGe
         UBoWVqNYpPAPuevX+cyqY7CHE/iMcSTdRUk/SVcwswG5O2CGKofVv6D+qi9yo2SoqTO6
         +HkQr1h9X4/bxa6wc+2W1T5It/Pilyz9HNFO4CwoRzA2BSoV1vLvB7kZqzn0+kvpJco3
         CSdtLq5EnR6ngYzzuEs4TLnv3S0IloN/N6Z8dB5QGdwDmMR5Urv6SPRHL/3//YOxteeK
         YVta43uoxqZkWHp9WrvxgBQP/LA0WtHgw/0EpEG5Oc3rOEW7WiStkSML36zrnwTdD2nZ
         WtKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789342094; x=1789946894;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=FHGh8Z/iQTWAr7ks0eD3K/QZN7oUordure7S8A/Ywjk=;
        b=FL3LfuMrODp91p7pNeumRWkQqxu5JbbZouMsEl+MmWxgelYXRBQqF4wZgF2MZYp75D
         F3oQoIgxLWrxLzc6987V6PSRFRTvkMUf2OVVV426G0lYpWLyw8y6J2QACRMkS8oWcswp
         uUhVOC4ilgloH1DJM/t8XgEFkMGg5hYnntHJiGH9qW08bPo8tTLBsxaZTjH3pOj5+pky
         mhHGZfV3Dau6S3J5GAH5hMa5G/DaWfgJfbCnocTfpLHXEwSqdMRuouidJ20c/AVMyvLW
         KK+9CGFZ4b3cE3cw8LZj9azBMBmkmm7ig+mJr2zYwcog2b3fCEmQ/Te0hDjcdTkvSOu3
         uQRg==
X-Forwarded-Encrypted: i=1; AKwUvByleJ0ckkVQNiA8K1STjhWDF+CUvsZhIlK8ywW21JB/+bMeSGkEw/wfKGjNZ3PpCbl1HW2yLOu2qmhg@vger.kernel.org
X-Gm-Message-State: AFuF++k61BFs3r7ERiTSdLOetGiRnBlvMrAZQhcT4IiHCQBVz0HcuJ2l
	edUQ6ad5xEor25yhkH3OwRwMMb3v2oFZ0UXKAGYEj5qg1YCHR2Nj/snY
X-Gm-Gg: AYBFou2E+gU+BcETRLHjTEM+faUETPCu6xbfhzPvVW633/+95QxMXiI52nPPdOFcUEa
	0M1dNHyzP+w/zAgH7KhhGJGIr4sPk4BHnpjVTDG+9b+mdPOiqLzSnyJMkWsSPOaG1X1K4H7CBrS
	ONuC9vK4zebQd9WHs40mE0vayd5QygfOqYlq5M29lCorrfQ9QPmOnVB6uHEYmrZjV1+31gAV69H
	JYXUtKtWwdnl6MJ68m/6rioZh5gE3WEP5ePKWtJLhtlpSbnEtJnqg/JQSEQzT0DHKUPXRnvbbQY
	vBCXvu9eGRN9IEZoPnCdZj3c0CvMcsTd2NG2uXup+j2ZFhpOzAQ0rUtFkf0oeVkjZimGobjXrMf
	jwOFcluej0Qh4aUwrnDwlsy/vexhze/ScHGWBx6TmMlykGxeNSORBvJX4TSF27RwKRZLmPbi/Kp
	3Mb1QEvCzd7n3GmNb1/7eddq2zaBvd7twSN1pYCDUDOYDUs4fZ2QctCPXiRUHuREk7vwAzR4Mur
	M79ARhGYCel3O6j2Id+lA==
X-Received: by 2002:a05:600c:4e89:b0:49d:7f5:4cdd with SMTP id 5b1f17b1804b1-49e7a68d80emr1010335e9.27.1789342093649;
        Sun, 13 Sep 2026 16:28:13 -0700 (PDT)
Received: from macbook-air-de-gael.home ([2a01:e0a:821:3a80::37ba:9a3e])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49e6499d57bsm396657625e9.3.2026.09.13.16.28.13
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 13 Sep 2026 16:28:13 -0700 (PDT)
From: "=?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?=" <gael.blivet@gmail.com>
X-Google-Original-From: =?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?= <g.blivet@me.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Gael Blivet <gael.blivet@gmail.com>,
	linux-cifs@vger.kernel.org
Subject: [PATCH 4/4] ksmbd: print IPv6 client addresses correctly in procfs
Date: Mon, 14 Sep 2026 01:26:38 +0200
Message-ID: <20260913232737.51704-5-g.blivet@me.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260913232737.51704-1-g.blivet@me.com>
References: <20260913232737.51704-1-g.blivet@me.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Gael Blivet <gael.blivet@gmail.com>

conn->inet_addr and conn->inet6_addr share a union, and three procfs
printers choose between them by testing whether inet_addr is zero. For
an IPv6 peer that field aliases the first four bytes of the address,
which are zero only for :: prefixed addresses, so a client with a
global IPv6 address takes the IPv4 branch and is listed from those four
bytes. A client at 2001:db8::1 is listed as 32.1.13.184.

IPv4 mapped addresses begin with zero bytes, so the listing is correct
until a native IPv6 client connects.

Record the address family where the address is stored and select on
that, in the client listing and in both session listings.

Fixes: fe4dc5987d7d ("ksmbd: expose connection runtime state in procfs")
Signed-off-by: Gael Blivet <gael.blivet@gmail.com>
Assisted-by: Claude:claude-opus-5
---
 fs/smb/server/connection.c        | 2 +-
 fs/smb/server/connection.h        | 3 +++
 fs/smb/server/mgmt/user_session.c | 4 ++--
 fs/smb/server/transport_tcp.c     | 1 +
 4 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index d211861ff86f..cc600b89cfdb 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -114,7 +114,7 @@ static int proc_show_clients(struct seq_file *m, void *v)
 			sessions++;
 		rcu_read_unlock();
 #if IS_ENABLED(CONFIG_IPV6)
-		if (!conn->inet_addr)
+		if (conn->is_ipv6)
 			seq_printf(m, "client:\t%pI6c\n", &conn->inet6_addr);
 		else
 #endif
diff --git a/fs/smb/server/connection.h b/fs/smb/server/connection.h
index 371f17b4f02a..2026a2afa5e4 100644
--- a/fs/smb/server/connection.h
+++ b/fs/smb/server/connection.h
@@ -68,6 +68,9 @@ struct ksmbd_conn {
 		u8			inet6_addr[16];
 #endif
 	};
+#if IS_ENABLED(CONFIG_IPV6)
+	bool				is_ipv6;
+#endif
 	unsigned int			inet_hash;
 	char				*request_buf;
 	struct ksmbd_transport		*transport;
diff --git a/fs/smb/server/mgmt/user_session.c b/fs/smb/server/mgmt/user_session.c
index 44dc3f800cd4..1321cd6c84e7 100644
--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -130,7 +130,7 @@ static int show_proc_session(struct seq_file *m, void *v)
 		const char *name;
 
 #if IS_ENABLED(CONFIG_IPV6)
-		if (chan->conn->inet_addr)
+		if (!chan->conn->is_ipv6)
 			seq_printf(m, "client:\t%pI4\n",
 					&chan->conn->inet_addr);
 		else
@@ -231,7 +231,7 @@ static int show_proc_sessions(struct seq_file *m, void *v)
 			ksmbd_user_session_get(session);
 
 #if IS_ENABLED(CONFIG_IPV6)
-			if (!chan->conn->inet_addr)
+			if (chan->conn->is_ipv6)
 				seq_printf(m, "client:\t%pI6c\n", &chan->conn->inet6_addr);
 			else
 #endif
diff --git a/fs/smb/server/transport_tcp.c b/fs/smb/server/transport_tcp.c
index 4968cfc1a572..09eb9a34a2a8 100644
--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -77,6 +77,7 @@ static struct tcp_transport *alloc_transport(struct socket *client_sk)
 	if (client_sk->sk->sk_family == AF_INET6) {
 		memcpy(&conn->inet6_addr, &client_sk->sk->sk_v6_daddr, 16);
 		conn->inet_hash = ipv6_addr_hash(&client_sk->sk->sk_v6_daddr);
+		conn->is_ipv6 = true;
 	} else {
 		conn->inet_addr = inet_sk(client_sk->sk)->inet_daddr;
 		conn->inet_hash = ipv4_addr_hash(inet_sk(client_sk->sk)->inet_daddr);
-- 
2.53.0

