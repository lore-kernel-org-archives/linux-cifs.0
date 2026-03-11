Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D117635DA46
	for <linux-cifs@vger.kernel.org>; Wed, 11 Mar 2026 21:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773263368; cv=none; b=mT6cQpH1fkFgaK0N0hi/YH7BcPcfTRNsTowczisxlLrvOQNm60eYKL48rQ0TLc71DNJ0k0q4bcjLVz2+7+mI13xUrPeMTW7NOeiN/rOcWoi5l75z9NAnRGjqxo9l10S1EsrkY6lp514qlN9BvGKDvjg6lVQnivmldGvAUryZvs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773263368; c=relaxed/simple;
	bh=QRC2zBceQZAw9NVBvIU644ZzsneR1w+YSjwrraWS+AQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=b0U7Rn3oApaJln8+2nRmhKxmJ0ByW3OkfwOcTmjdIawPAHukZux0+8OJMJHWvvzr7VlEuMduZcNA9wkXkwQT3Fb1MGiWlu6HZHNLPwLi5ECYAv6wHT50gS0khbUpAjFd95HdClxc6O09kjhJqPmKU7q3IsM6LpfQz/DSpYS7lVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=eYnw2Gme; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="eYnw2Gme"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-48529c325f0so2126035e9.0
        for <linux-cifs@vger.kernel.org>; Wed, 11 Mar 2026 14:09:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773263365; x=1773868165; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UaaxnmPHTieCJFocp7VqZ1LoooxMAJJriEl5r9r2vlo=;
        b=eYnw2GmenSzafT+VZhiiPjNLBAk66dlBBvdeEMzGDDbPW32tIku4tN9ogzvT0zAEww
         kK5nywA32y0XHPhBTw1yB2+ClcxKB+Az+ypxRRgF3v2DsSzd6ka7CyxfH0fq/WqPonly
         EpA0tfqZeaATbN7XTHQ/z8RfD157qtepS9tf7zrpryWmdpN1Nu5j7HqrUo0aRPdoDKUv
         w7UxXNxEqoi3FOQyZvvV5iw3kChh/0NGhc3mhIenG4TmQVyq+5jGmdpaRSS3lUs0cET7
         cn7EsnmmtVgFqbwt0dPTLClPkA3suoqEYedHJhMqioYp75j9sNA9zdGhfw1gUcOCnuSo
         Z6kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773263365; x=1773868165;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UaaxnmPHTieCJFocp7VqZ1LoooxMAJJriEl5r9r2vlo=;
        b=edvN8TqnzjJpuuo+FV4ffSlrmUS26vFrn6M2cP5Z2rJkZZdkx0nJPimHh2fm7ZOzfw
         6rUE4lFhtCW5wuYYi8v6uPzK9EZU1o9BBlsCgzd4tEN7/WOGCs2tHaQII5lMNlGhasLf
         jEPmUwPKOS9xD/WvY/HS8NfBU6UZC1okoi8QZ4hzzCsgw8o6cymWGSKxCeIX5PnZqwfR
         pdlJKVSsM4IgF01TvZEJ432p4Q2XGSvUAwx5eV9cgVoPZ3TxqljVuiGH2BHS7Ilc2ZRV
         QHKvY0L4zC72IDrOUwftrnh8vt4JQPG8QwR91YicMdSYagXG3eLATJb6O2Hs+G3vcuPq
         Zhng==
X-Forwarded-Encrypted: i=1; AJvYcCXNR+NBqBFB7Brtk8LPUN7Si0SmgitvEOgyR1K1PmxWc9kVVipBWE7YbCCw6H5Y9SJWh4xY7130+0Ev@vger.kernel.org
X-Gm-Message-State: AOJu0YzAZ9DPnFvRPFwIy8PQEzOzF4cHnert204xmFaL44iP7LcxFFG6
	t1msu9kO33STz2+NZ1hkLdW8b5+59DjTr9S1F0ZVOnWLzUNgUvVp88tOZda73x1KjtU=
X-Gm-Gg: ATEYQzxR9KibKup/i4FwWvpeDXJUNusfnwOnq00FehMXuqi6PrQVp81PrjPSufznQpy
	G7oCJC345osUbtSpfYxwOi53+zmmfyY048LLpGYMGPpLVSeWOk9e1+vZtllCTWvXa1LZtBlDZfl
	Py+9zKB/rFrUefnuLPAfJ/qyhKQCUdbCOxcZJ7dKD8TT7/M4n3muA0izPu1jiUnuwTtg6JLgzXc
	wpOHtUbJe6L8tFCFb49ap8+/GehxI0+phdk++Pzb8U2XIwZBg/nxro0+UheRvuBZlJkD2NxfLlu
	KB/ytEM529smttyv3ajoFP8+B06KUrAGYiYQ7lQPJVoD4l6jo6gnjhhsluQtglc6rAo/SLfHTtF
	cbHri3HiYw1rmgTCxXDIpGaqfhNAXLt6FNvAmT5gMY4gtWD7xDjfB/rTtlQfNQnCcqvs/ml5EFt
	X3+c5ohTWRC0ikaTJfMiDq8Wun6t9F7AZYz9D9U6Zlv3jkvJ1biKLxcvU=
X-Received: by 2002:a05:600c:8b31:b0:485:3812:36da with SMTP id 5b1f17b1804b1-4854b0afc13mr69420255e9.9.1773263365105;
        Wed, 11 Mar 2026 14:09:25 -0700 (PDT)
Received: from precision.tail0b5424.ts.net ([2804:7f0:6402:b103:6a0a:3e1c:778a:5cc7])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2be8aa73ba6sm3896702eec.25.2026.03.11.14.09.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2026 14:09:24 -0700 (PDT)
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: sfrench@samba.org
Cc: pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	ematsumiya@suse.de,
	linux-cifs@vger.kernel.org,
	stable@vger.kernel.org,
	"Dr. Thomas Orgis" <thomas.orgis@uni-hamburg.de>
Subject: [PATCH v2] smb: client: fix iface port assignment in parse_server_interfaces
Date: Wed, 11 Mar 2026 18:09:15 -0300
Message-ID: <20260311210915.735288-1-henrique.carvalho@suse.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

parse_server_interfaces() initializes interface socket addresses with
CIFS_PORT. When the mount uses a non-default port this overwrites the
configured destination port.

Later, cifs_chan_update_iface() copies this sockaddr into server->dstaddr,
causing reconnect attempts to use the wrong port after server interface
updates.

Use the existing port from server->dstaddr instead.

Cc: stable@vger.kernel.org
Fixes: fe856be475f7 ("CIFS: parse and store info on iface queries")
Tested-by: Dr. Thomas Orgis <thomas.orgis@uni-hamburg.de>
Reviewed-by: Enzo Matsumiya <ematsumiya@suse.de>
Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
---
v2 -> v1:
- read the port once from server->dstaddr before parsing iface entries
  and considering *server* ss_family
- update the commit message to describe the fix more clearly
- adjust the Fixes tag to fe856be475f7 ("CIFS: parse and store info on iface queries"),
  as the later commit only exposed the bug rather than introducing it

 fs/smb/client/smb2ops.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 7f2d3459cbf9..7a176088c877 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -628,6 +628,7 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
 	struct smb_sockaddr_in6 *p6;
 	struct cifs_server_iface *info = NULL, *iface = NULL, *niface = NULL;
 	struct cifs_server_iface tmp_iface;
+	__be16 port;
 	ssize_t bytes_left;
 	size_t next = 0;
 	int nb_iface = 0;
@@ -662,6 +663,13 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
 		goto out;
 	}
 
+	if (ses->server->dstaddr.ss_family == AF_INET)
+		port = ((struct sockaddr_in *)&ses->server->dstaddr)->sin_port;
+	else if (ses->server->dstaddr.ss_family == AF_INET6)
+		port = ((struct sockaddr_in6 *)&ses->server->dstaddr)->sin6_port;
+	else
+		port = cpu_to_be16(CIFS_PORT);
+
 	while (bytes_left >= (ssize_t)sizeof(*p)) {
 		memset(&tmp_iface, 0, sizeof(tmp_iface));
 		/* default to 1Gbps when link speed is unset */
@@ -682,7 +690,7 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
 			memcpy(&addr4->sin_addr, &p4->IPv4Address, 4);
 
 			/* [MS-SMB2] 2.2.32.5.1.1 Clients MUST ignore these */
-			addr4->sin_port = cpu_to_be16(CIFS_PORT);
+			addr4->sin_port = port;
 
 			cifs_dbg(FYI, "%s: ipv4 %pI4\n", __func__,
 				 &addr4->sin_addr);
@@ -696,7 +704,7 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
 			/* [MS-SMB2] 2.2.32.5.1.2 Clients MUST ignore these */
 			addr6->sin6_flowinfo = 0;
 			addr6->sin6_scope_id = 0;
-			addr6->sin6_port = cpu_to_be16(CIFS_PORT);
+			addr6->sin6_port = port;
 
 			cifs_dbg(FYI, "%s: ipv6 %pI6\n", __func__,
 				 &addr6->sin6_addr);
-- 
2.53.0

