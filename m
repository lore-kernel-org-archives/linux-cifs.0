Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E273D6CD8
	for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 15:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777391916; cv=none; b=Nn/5p6P8X4j2yBxwrM9S1o9EakNVGUbzwmwM40ABCDiLXK6eBz6OiHtVbGGNLvKQqaTIfzz51ltokuvnHTvIaQRazTI9Ty51iFb8ud+KycN+m+ny/BX80Yuh0BOHFTAaxR+CbhGFisKJje+nsvmcEcdujfL/wHoLnExZTbwFTuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777391916; c=relaxed/simple;
	bh=KPDUAM/B7dwjOMD8wuZQR8c8CPU0KWccASaAffXaxAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H6lGSb6fNKld6pAhkFFvJi2MI+8+TZpS8BYy2nelgWKxt2Xiej6MHxSc3VkxKPiEN7EVjf2y5s7idTgZMqYupZ2fsL4Ex5P/7GdKC+YKs8A0yfkfeAEvn9z4z0jPi09INUsYo6vaRFx+6Sjkk4zBVbLIBWaXnJnxZA8VaXri7+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=MgpbytK9; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="MgpbytK9"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4891c0620bcso80134005e9.1
        for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 08:58:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777391913; x=1777996713; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7Ld0FBcSpGP2eiiSXkF6apkU8lf6UUEovJRC91J2+Aw=;
        b=MgpbytK9nPMK5H4eN6vT09Nx317hJYQGTm/9OfXmDSN88hfy+J6H9Jg3CN1GFdqfFw
         HZ1po3zOYSaQGP8ryKxTCPlLjtqD6TyXgJGEwUAnpaQdZNzlh67PKdXHpiEaxR8cS2pL
         FfQYi6M5rdfY/qxkxl5ePtzejfKY4bed9lzje8bUozQ11kRBRGyDOIOqLAg9nbqbd5tA
         lqJ0iDutRZEWVlzSujJx0/wKKTwlJuIQgsFl0oFPRPlv7EQoC+2m/ecnQUDH8vUzvz65
         JT6P6NH92l9PPhShdbrrFWmEKIAEwrlVq9k7XsFv1G+3jC3bsJs+cC0vRSBnlwduItyJ
         WdlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777391913; x=1777996713;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7Ld0FBcSpGP2eiiSXkF6apkU8lf6UUEovJRC91J2+Aw=;
        b=TSPAGtaXlZDF2uKtN6UK1W0w4mZiyVm2oVIJjaGVURl/p4HLp4GP7nxQqEolmXqm2+
         dVE2Ayu1bfZ4jNJMD4QYyoO0j8/2o3Fiy7XP2n1pHygPuNALrIwqUdBRG+BSgEWHq6km
         3hw3uHGFnmboUt6nAWviiaQ18rSt9vazaJBIAsB3Q9TDdE+nzr6DOxBfFQLNOH84GMig
         KADv3y2Mf9X/eN8rYCgd+GB8C4ilrTq6cTPc3KqGu7uIzx1K2eT747K86bbLlLXTXvl6
         dLFed8TkB1ji3Um1U+EPZa4gv7qyMNylsgfcb/ngj+CA3gIJAQ6/cuPLpDELJWSmU9L8
         Im2A==
X-Gm-Message-State: AOJu0YwSTY/7dnqv6eOAmbTEfvnVls4j3+o1j4fsno2d4YJ8LAde9CHw
	wm/K2NpMxmcR61w4CCk1OjCxbPmUWplGfevE9ZjlZu5b4rD/U/5ZMRt40M62xsNSBvO4sUG5BGZ
	jg42/iVKZ0Q==
X-Gm-Gg: AeBDiet+J/N950jCrisXGn1oA161lWReMMuhVAsqkHR/6aXhSHGBHyCSIP7utWq6e47
	xJKDQJDTUbRxjFVwZ9XLtEQrMomyzXMCLL2gddNZD/7K8F5UyGqPIvHwxsAmBxcw8t9CnyuCrid
	cg9CBa27tPQz3VLUrD5kYLj+7usDDXzgODto4Y3jNge4AYSZne39kvY0uT4ZTCwvvo46bo6BuB/
	b6qGv1860EZY1lB8zruAAeXHIFqoFPWu7Vhq4mJUHfBoPn/n/eBS1Q2MX92y54IT9GFqhdgGXyE
	woP0Cb468rRfXOQweVH7zIt5tZAGlsMkIv7C00n7sClO1FIZTe+Evot8VqpvXONaUIiwFIi/3cm
	WdvhKNam6lW1xBVAg7nmh3QIgSla9ftV0mblb9btW3d4f/mNiuVjMVwbBUmnAVlr/FFLrjgU2xM
	bCBrctMPi9axeN1SBYS6Xn3YG05YbNqLu+SkQS2Ck67bGH
X-Received: by 2002:a05:600c:3d90:b0:488:b239:77ec with SMTP id 5b1f17b1804b1-48a77b1781cmr62293975e9.17.1777391912061;
        Tue, 28 Apr 2026 08:58:32 -0700 (PDT)
Received: from precision ([2a01:4b00:c007:bb00:be9d:a3c4:18b1:4a25])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a7b560a84sm3409255e9.4.2026.04.28.08.58.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 08:58:31 -0700 (PDT)
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: linux-cifs@vger.kernel.org
Cc: linkinjeon@kernel.org,
	sfrench@samba.org,
	metze@samba.org,
	senozhatsky@chromium.org,
	tom@talpey.com,
	ematsumiya@suse.de,
	Henrique Carvalho <henrique.carvalho@suse.com>
Subject: [PATCH v2 10/11] smb: server: track TCP and QUIC listener state independently
Date: Tue, 28 Apr 2026 12:57:59 -0300
Message-ID: <20260428155759.226368-6-henrique.carvalho@suse.com>
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

An interface can host both TCP and QUIC listeners, so a single
configured/down state is no longer precise enough once QUIC support is
added (e.g. a TCP listener may already be up when QUIC setup fails).

Turn iface->state into a transport bitmask and track TCP and QUIC
listener bring-up independently. This lets NETDEV_UP retry only the
missing transport and lets NETDEV_DOWN tear down only the listeners that
were actually started.

Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
---
 fs/smb/server/interface.c      | 61 ++++++++++++++++++++++------------
 fs/smb/server/interface.h      |  6 ++--
 fs/smb/server/transport_quic.c |  2 +-
 fs/smb/server/transport_tcp.c  |  2 +-
 4 files changed, 45 insertions(+), 26 deletions(-)

diff --git a/fs/smb/server/interface.c b/fs/smb/server/interface.c
index 25b8e7f44059..272c4aaad347 100644
--- a/fs/smb/server/interface.c
+++ b/fs/smb/server/interface.c
@@ -17,6 +17,11 @@
 static LIST_HEAD(iface_list);
 static int bind_additional_ifaces;
 
+static inline bool ksmbd_iface_transport_up(const struct interface *iface)
+{
+	return iface->state != 0;
+}
+
 static struct interface *alloc_iface(char *ifname)
 {
 	struct interface *iface;
@@ -31,7 +36,7 @@ static struct interface *alloc_iface(char *ifname)
 	}
 
 	iface->name = ifname;
-	iface->state = IFACE_STATE_DOWN;
+	iface->state = 0;
 	list_add(&iface->entry, &iface_list);
 	return iface;
 }
@@ -80,20 +85,30 @@ static int ksmbd_netdev_event(struct notifier_block *nb, unsigned long event,
 			return NOTIFY_OK;
 
 		iface = ksmbd_find_netdev_name_iface_list(netdev->name);
-		if (iface && iface->state == IFACE_STATE_DOWN) {
+		if (iface) {
 			ksmbd_debug(CONN, "netdev-up event: netdev(%s) is going up\n",
 					iface->name);
 
 			if (!iface->net)
 				iface->net = get_net(dev_net(netdev));
 
-			ret = ksmbd_tcp_create_socket(iface);
-			if (ret)
-				break;
-
-			ret = ksmbd_quic_create_socket(iface);
-			if (ret)
-				break;
+			if (!(iface->state & IFACE_STATE_TCP_UP)) {
+				ret = ksmbd_tcp_create_socket(iface);
+				if (ret && !ksmbd_iface_transport_up(iface)) {
+					put_net(iface->net);
+					iface->net = NULL;
+					break;
+				}
+			}
+
+			if (!(iface->state & IFACE_STATE_QUIC_UP)) {
+				ret = ksmbd_quic_create_socket(iface);
+				if (ret && !ksmbd_iface_transport_up(iface)) {
+					put_net(iface->net);
+					iface->net = NULL;
+					break;
+				}
+			}
 		}
 		if (!iface && bind_additional_ifaces) {
 			iface = alloc_iface(kstrdup(netdev->name, KSMBD_DEFAULT_GFP));
@@ -106,44 +121,49 @@ static int ksmbd_netdev_event(struct notifier_block *nb, unsigned long event,
 			iface->net = get_net(dev_net(netdev));
 
 			ret = ksmbd_tcp_create_socket(iface);
-			if (ret)
+			if (ret && !ksmbd_iface_transport_up(iface)) {
+				put_net(iface->net);
+				iface->net = NULL;
 				break;
+			}
 
 			ret = ksmbd_quic_create_socket(iface);
-			if (ret)
+			if (ret && !ksmbd_iface_transport_up(iface)) {
+				put_net(iface->net);
+				iface->net = NULL;
 				break;
+			}
 		}
 		break;
 	case NETDEV_DOWN:
 		iface = ksmbd_find_netdev_name_iface_list(netdev->name);
-		if (iface && iface->state == IFACE_STATE_CONFIGURED) {
+		if (iface && ksmbd_iface_transport_up(iface)) {
 			ksmbd_debug(CONN, "netdev-down event: netdev(%s) is going down\n",
 					iface->name);
 
-			if (iface->ksmbd_tcp_socket)
+			if (iface->state & IFACE_STATE_TCP_UP)
 				kernel_sock_shutdown(iface->ksmbd_tcp_socket, SHUT_RDWR);
-			if (iface->ksmbd_quic_socket)
+			if (iface->state & IFACE_STATE_QUIC_UP)
 				kernel_sock_shutdown(iface->ksmbd_quic_socket, SHUT_RDWR);
 
-			if (iface->ksmbd_tcp_kthread)
+			if (iface->state & IFACE_STATE_TCP_UP)
 				ksmbd_interface_stop_kthread(iface->ksmbd_tcp_kthread);
-			if (iface->ksmbd_quic_kthread)
+			if (iface->state & IFACE_STATE_QUIC_UP)
 				ksmbd_interface_stop_kthread(iface->ksmbd_quic_kthread);
 
-			if (iface->ksmbd_tcp_socket)
+			if (iface->state & IFACE_STATE_TCP_UP)
 				sock_release(iface->ksmbd_tcp_socket);
-			if (iface->ksmbd_quic_socket)
+			if (iface->state & IFACE_STATE_QUIC_UP)
 				sock_release(iface->ksmbd_quic_socket);
 
 			iface->ksmbd_tcp_kthread = NULL;
 			iface->ksmbd_quic_kthread = NULL;
 			iface->ksmbd_tcp_socket = NULL;
 			iface->ksmbd_quic_socket = NULL;
+			iface->state = 0;
 
 			put_net(iface->net);
 			iface->net = NULL;
-
-			iface->state = IFACE_STATE_DOWN;
 			break;
 		}
 		break;
@@ -213,4 +233,3 @@ int ksmbd_set_interfaces(char *ifc_list, int ifc_list_sz)
 
 	return 0;
 }
-
diff --git a/fs/smb/server/interface.h b/fs/smb/server/interface.h
index 94ffb73fd635..d99b1f3c8bc0 100644
--- a/fs/smb/server/interface.h
+++ b/fs/smb/server/interface.h
@@ -10,8 +10,8 @@
 
 #include <linux/freezer.h>
 
-#define IFACE_STATE_DOWN		BIT(0)
-#define IFACE_STATE_CONFIGURED		BIT(1)
+#define IFACE_STATE_TCP_UP		BIT(0)
+#define IFACE_STATE_QUIC_UP		BIT(1)
 
 struct interface {
 	struct task_struct	*ksmbd_tcp_kthread;
@@ -20,7 +20,7 @@ struct interface {
 	struct socket		*ksmbd_quic_socket;
 	struct list_head	entry;
 	char			*name;
-	int			state;
+	unsigned int		state;
 	struct net		*net;
 };
 
diff --git a/fs/smb/server/transport_quic.c b/fs/smb/server/transport_quic.c
index 84067225c1d3..da089b655e6c 100644
--- a/fs/smb/server/transport_quic.c
+++ b/fs/smb/server/transport_quic.c
@@ -314,7 +314,7 @@ int ksmbd_quic_create_socket(struct interface *iface)
 
 	iface->ksmbd_quic_socket  = ksmbd_socket;
 	iface->ksmbd_quic_kthread = kthread;
-	iface->state = IFACE_STATE_CONFIGURED;
+	iface->state |= IFACE_STATE_QUIC_UP;
 #endif /* CONFIG_IP_QUIC */
 	return 0;
 }
diff --git a/fs/smb/server/transport_tcp.c b/fs/smb/server/transport_tcp.c
index 1496f0336af6..81bf6996a6f7 100644
--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -208,7 +208,7 @@ int ksmbd_tcp_create_socket(struct interface *iface)
 	}
 
 	iface->ksmbd_tcp_kthread = kthread;
-	iface->state = IFACE_STATE_CONFIGURED;
+	iface->state |= IFACE_STATE_TCP_UP;
 
 	return 0;
 
-- 
2.53.0

