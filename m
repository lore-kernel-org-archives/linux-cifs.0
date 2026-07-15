Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A437E388E4E
	for <linux-cifs@vger.kernel.org>; Wed, 15 Jul 2026 20:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784147525; cv=none; b=Td+56YhsDnsjLnztvYT9snAtJcZld3NUK+y2dKA+6lujYCzkuPZpiuAvNjHcNqjiNjeXJPjN4p/tJvdwnxHelVzizW5+84z1RVW+N+Qj4zrwu5RSfHU0eyKgOAK+4huAG40RWXqW0ar2GeIo7Q7QRMotfaO2N08QWoBwEI2AwNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784147525; c=relaxed/simple;
	bh=+WVprUCU/4+i4zgkUbeM5Zx1SxzVovafBUP+ZokRC1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L6AUcDhs0CZK90qdldOi8VZSF2Vh2IKoRIGNmfB/U88SRGK0DBdSNP2GhiFWW8UbuPvXg70AVxE7Z8OOPF+yqfDJefLddaxOlIGCEJu9ogdIWsgtpH7GYyLlTYmq7rsaujJzQIrlp+53Qdxk6h59czN90RRrTwG2mWDsBz/bOQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IXRw7CDE; arc=none smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IXRw7CDE"
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-8ff88549786so70212036d6.3
        for <linux-cifs@vger.kernel.org>; Wed, 15 Jul 2026 13:32:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784147522; x=1784752322; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fPU3Bo1+xBc66sD6n9dZSyoyYNjeW81XMMVUXjEGtzM=;
        b=IXRw7CDEn59EOyvToWSZerkNcBRXdXh9GI5CjDnrE4ogdkVschlS5GGqtY3RXMh8NQ
         P25d9BJu6P1l4IgIVVVgaHy0gPGz9SEMKRmcZUqPkXoHFVO1VdwJa8qUTFfbZQOHzFwN
         KeOX5d1dtamLjGwFDWRzoRMH6mG/kYbH3Mq/b6fpbkM0r6nWMy65p1ffBl86kuALRBSs
         O3ggr2oJgV3ufXuGW780rwWCXk9g9FusksKpBWG87isB9ZwTnPBWCO1W33K8On+h8Vg+
         9BUJpnnWEhud0AykceNK7j4REXhmgHPAjstMJIjtVmjAQhqo1+KNlJzE3GI6jINz9bQx
         v7Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784147522; x=1784752322;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=fPU3Bo1+xBc66sD6n9dZSyoyYNjeW81XMMVUXjEGtzM=;
        b=rySrpMqpZNQ0PEeKIvrHoS/tp/D11H5bamYXz8lV0wC/AezI0jXHuTXiXD0jKCuaIg
         j8wXZOltk/6YWcm1sC6HvNkmssNj3/14VadQHMdTziyrgbgJWNUU4w5fPex/MhAgFwqE
         s+JrOWTfkcbGbC+Xtht/xveVOT8CfavW4Aa5ciuFs+nB/Z1vKx/VgAP8KbOa2FC9tUkK
         atgSwnCqXqrZi0Td473rzkXxj60v6OuRBXKk1+wTOH95iv1ADkKYwTgSIu2VF314g87Z
         /Bsk+v0/lVdNpRnCNk0X6y8rA1VCkAuSJY31Gpy/Tt/nawzQdNzmPygGBVNta7jDF1CI
         WSpQ==
X-Forwarded-Encrypted: i=1; AHgh+RqUEbamB7LXAYcpaspHZ7GQOtctMBuGe7E5bsIQnyQw++1Yb5KbTmr8eO5CtdSBJcoCApXJI2C3JfcC@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3WGwDSD2Uf3Idc+KkTxQc2sdqaiQGQYoBg5qINnbrlTv4ouf4
	6CPg5/KLPcepAFtiElJL6xGDKdedAxAFVV3Tb9xMIH2JBvAszq1i3qIk
X-Gm-Gg: AfdE7ckw3EeXGfZd1qPdnSkNDZdBls1EHFDSPat+Qg95Kx7qffm8SQ3U8wOsnilmtrv
	JUyO6djSG1kDBrJLP8dbBVkUrhijcWDWs0/ijYtGlNtzpJAJ7lydHfi3P/LtOkLQIvqq0tY1jQR
	emx+1hFr8Uvp/chWu5XdSJiJhb407UBzQafwufuMaGP77HDEL4/JSuP80dDnXT6JpwCpbFoBZMb
	ZneJJ8W+XYY2l3ytc/bZYje4yKKjIBst3p/9V5UE3PiP1hK2dl171Ujb942jwRVSXydZxY9dyod
	fpzCliyB/Tpc7rBA+a6OWISwG30hwps7ciRRCz0cwGQSbSaNFhHF1PU8uQLa9wlSb82B64b+Msu
	/iY0ZySPYSb4yxKGB30WjMfg4a4V4nrhEX4emZYgBWc77GqFVCodWVNzt5g7L7tFJBQnA3vsPhY
	AyUBsUeTuJAhkHLimHaz/Tg05Ph4kG6TUnMjfjLHo1tjJXqtDsK/3yD/xnoxKHLt+YQWJboxPFQ
	mXb3OH+odNVwckuYDWqzEwtesYfi2tDVXxomu+RHGeoYlb+ntZCcdCSlD5ed72n9g==
X-Received: by 2002:ad4:4eee:0:b0:8f0:9d9c:52c1 with SMTP id 6a1803df08f44-90758df4b08mr48950066d6.38.1784147522440;
        Wed, 15 Jul 2026 13:32:02 -0700 (PDT)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ffd248e666sm201326506d6.0.2026.07.15.13.32.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 13:32:02 -0700 (PDT)
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
	mef@scarletmail.rutgers.edu,
	paul@jakma.org
Subject: [PATCH net-next v14 01/15] net: define IPPROTO_QUIC and SOL_QUIC constants
Date: Wed, 15 Jul 2026 16:27:04 -0400
Message-ID: <79a0a6de4d79fd46b0e6911ab90d9dbe9cb3b87a.1784147238.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1784147238.git.lucien.xin@gmail.com>
References: <cover.1784147238.git.lucien.xin@gmail.com>
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
index 2a8d7b14f1d1..9d6ec1b2c50b 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -400,6 +400,7 @@ struct ucred {
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

