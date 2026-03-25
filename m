Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C275D2DFA46
	for <linux-cifs@vger.kernel.org>; Wed, 25 Mar 2026 03:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774410566; cv=none; b=ZniyYptmL10EB+LkEIY1/4on3hgNmdj0F7vCuq7uk6j9rodomfj0D8g5Ea6LTfo9ibG4icUp+qXDak1ZdwbtbAp0o6uq0r6JyTMXgUbQLLxLFbF5Ujc2j6lNlsAHwUJjsaR0tbueeLC2L5VwCD834GKiMNm8SvdfH/6gRSgUrxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774410566; c=relaxed/simple;
	bh=+r3tYa1O4nzHNXgUenOGoOEDKkt9r6oEsRxV2HklKR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hIIhQ/u7x2T9mjKflKWLQcH/kOikMMU8X48f0RDMxyO5wa9DLT8IaLABphNcvE50trPWjjyItwo+3JDJ+JdWN7Kw6z3R5FJ0eh2JDEQ7FrCqJOC2ZhOO/KaVsCkqQiVhzn3sI9LC4GhOg3D/R/MMUPzznNF5bSjh+YhSPo7E8fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V0Kf0gSe; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V0Kf0gSe"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-50b4001af28so48031711cf.1
        for <linux-cifs@vger.kernel.org>; Tue, 24 Mar 2026 20:49:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774410564; x=1775015364; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CfoS9zHnWtS92mtRPUnEWGWkqfJ2EjLVIhUjEgbm2M4=;
        b=V0Kf0gSeT3F669KSka82mKuzlY/dgtTlEf40TAs98ct6J8A/3+ybwJWPCsQbHuKb/K
         Pxg43s8/7hLYBIvKaRqOFMkZV5YvmLR0uuASkWJX1QHcEOWWBX4HRVTeEHvSaM5RvTeW
         9DUb59NjKrkS7IHgKkLr7EgLmZGL4GwB8sPN+yZDDt9g4vGObr+E7qjbtqtxhCek23u/
         IzhIOOjmAR8VuNpIOlhJiTsSfT516+GPIFg2r9FZhL87+UtQOoLREeiS3HbKJyiLkAbp
         MrIGtRZBTAV3BYeybz8V9l6EeB9eRaxTjFHeideMXHcotmMGjuD+lHmZkAeYEI/199s1
         xapg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774410564; x=1775015364;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CfoS9zHnWtS92mtRPUnEWGWkqfJ2EjLVIhUjEgbm2M4=;
        b=B/m4HZxX/sXhgwGDAHgG8bbsvMH4m3GrvTjI8C5bOuB7Am5G/9ONsyWFv1VAYKn1SM
         H20/c4oEmtitcZaV56GcAMmuTcs1z/sQCDlviF3vBjyAD/Bk2KnrOPISTuDIA0g1L9og
         ekP47UzQLBnsDuz3NUVyeZXBD9nEFCg+pdqNYOGFBR5fxqigeMxsdpkAm89+G6Cgcna3
         zXwdBqsCGlxgdma7hMT09w6vOpjYYcJeGMYnhtadjS8nZBQTz+AqwTUwpPtzB942Tuqv
         edV/MGC+UON50BTKwr/lG7fKb5nikP9pj8Rv61Bms0VJIPn3BQYAm5DQhbA08cLzX3Zq
         uP+Q==
X-Forwarded-Encrypted: i=1; AJvYcCURylBavcJ3cbyfcswRxprsx/VpfaXbcE3uuiKMSfnjnS6hIPWwnxHsqWDD8XMRV3MeI5P3Y4jlvBqx@vger.kernel.org
X-Gm-Message-State: AOJu0YzKb9OY7j+GQkAnGsEp4zytGvfSOlduOHN6BEElBmZEwsP7ryGc
	sfEZTxdxfz81FrtNhPbgt9TEpNRJ9+GRIrjdtaHAp9ZEkK6mKQZ58R8F
X-Gm-Gg: ATEYQzxmVLREHz1mKNHzEq83mS1eEcrvQ1v9HJGQYsuOygMB8/qBlFuGL56Jc5gR5DI
	tyhMl8FO3Y3eFiqR0ZA9dsA2MIZU+Qy7kur+E1Zh1d2jqJEkfdD/BkeiPN3m5yGjZL9oQ/hBE8R
	TphdiXeUswbtCbF9xR/pxLnzjPI/FxGARsVFlMlo1xA2kynLcRvCADoePreY2UFmKl3IiqK4mde
	MZOVONBVUK/7FMkNf05ETocYEOlP0QmqfYSnI58/uEr7rGBSs4rv4sDX3OyXoVT0qDKkN0R8Wbp
	WV4FUTncBY1inY8RKaQZ2zNETbqZxgjDZhCRYO5wubNwlAjycSdz0w9rIWbv0cKPdRe0RUvASut
	D6pfUZAJLm1Kohd2NB7PYvR3/nRgz1WGGsdxCfZTClOP7e/OPGh0d4dt7akziWGdFbx9/Scsn3M
	4B9360aGIg5FsLFoLkYdO5yZHMYbai9mcjQ63UIbIppGZXd5P86dBKIWDlXlyC+B7GSok/Jeqqw
	a0LUlAag+DeQ5zBcLCJlCjdDanX2VPKqFnq3UWuE2bMFDbknC6GGqqMZcXmD3kOoQ==
X-Received: by 2002:a05:622a:5c95:b0:50b:483d:3669 with SMTP id d75a77b69052e-50b80e82d15mr29039691cf.62.1774410563747;
        Tue, 24 Mar 2026 20:49:23 -0700 (PDT)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50b36cb2e29sm150093001cf.1.2026.03.24.20.49.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2026 20:49:23 -0700 (PDT)
From: Xin Long <lucien.xin@gmail.com>
To: network dev <netdev@vger.kernel.org>,
	quic@lists.linux.dev
Cc: davem@davemloft.net,
	kuba@kernel.org,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Stefan Metzmacher <metze@samba.org>,
	Moritz Buhl <mbuhl@openbsd.org>,
	Tyler Fanelli <tfanelli@redhat.com>,
	Pengtao He <hepengtao@xiaomi.com>,
	Thomas Dreibholz <dreibh@simula.no>,
	linux-cifs@vger.kernel.org,
	Steve French <smfrench@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Tom Talpey <tom@talpey.com>,
	kernel-tls-handshake@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	Steve Dickson <steved@redhat.com>,
	Hannes Reinecke <hare@suse.de>,
	Alexander Aring <aahringo@redhat.com>,
	David Howells <dhowells@redhat.com>,
	Matthieu Baerts <matttbe@kernel.org>,
	John Ericson <mail@johnericson.me>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	"D . Wythe" <alibuda@linux.alibaba.com>,
	Jason Baron <jbaron@akamai.com>,
	illiliti <illiliti@protonmail.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Daniel Stenberg <daniel@haxx.se>,
	Andy Gospodarek <andrew.gospodarek@broadcom.com>,
	"Marc E . Fiuczynski" <marc@fiuczynski.com>
Subject: [PATCH net-next v11 01/15] net: define IPPROTO_QUIC and SOL_QUIC constants
Date: Tue, 24 Mar 2026 23:47:06 -0400
Message-ID: <e5cb44e7a6ba57b63a3b13f853947ac88ec97335.1774410440.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1774410440.git.lucien.xin@gmail.com>
References: <cover.1774410440.git.lucien.xin@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch adds IPPROTO_QUIC and SOL_QUIC constants to the networking
subsystem. These definitions are essential for applications to set
socket options and protocol identifiers related to the QUIC protocol.

QUIC does not possess a protocol number allocated from IANA, and like
IPPROTO_MPTCP, IPPROTO_QUIC is merely a value used when opening a QUIC
socket with:

  socket(AF_INET, SOCK_STREAM, IPPROTO_QUIC);

Note we did not opt for UDP ULP for QUIC implementation due to several
considerations:

- QUIC's connection Migration requires at least 2 UDP sockets for one
  QUIC connection at the same time, not to mention the multipath
  feature in one of its draft RFCs.

- In-Kernel QUIC, as a Transport Protocol, wants to provide users with
  the TCP or SCTP like Socket APIs, like connect()/listen()/accept()...
  Note that a single UDP socket might even be used for multiple QUIC
  connections.

The use of IPPROTO_QUIC type sockets over UDP tunnel will effectively
address these challenges and provides a more flexible and scalable
solution.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
---
v11:
  - Set maximum line length to 80 characters.
---
 include/linux/socket.h  | 1 +
 include/uapi/linux/in.h | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/include/linux/socket.h b/include/linux/socket.h
index ec4a0a025793..9b6c3cd766ca 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -401,6 +401,7 @@ struct ucred {
 #define SOL_MCTP	285
 #define SOL_SMC		286
 #define SOL_VSOCK	287
+#define SOL_QUIC	288
 
 /* IPX options */
 #define IPX_TYPE	1
diff --git a/include/uapi/linux/in.h b/include/uapi/linux/in.h
index ced0fc3c3aa5..e4072152f2e6 100644
--- a/include/uapi/linux/in.h
+++ b/include/uapi/linux/in.h
@@ -85,6 +85,8 @@ enum {
 #define IPPROTO_RAW		IPPROTO_RAW
   IPPROTO_SMC = 256,		/* Shared Memory Communications		*/
 #define IPPROTO_SMC		IPPROTO_SMC
+  IPPROTO_QUIC = 261,		/* A UDP-Based Multiplexed Secure Transport */
+#define IPPROTO_QUIC		IPPROTO_QUIC
   IPPROTO_MPTCP = 262,		/* Multipath TCP connection		*/
 #define IPPROTO_MPTCP		IPPROTO_MPTCP
   IPPROTO_MAX
-- 
2.47.1

