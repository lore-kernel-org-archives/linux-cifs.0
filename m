Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 954E6312831
	for <linux-cifs@vger.kernel.org>; Mon, 24 Nov 2025 14:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763994617; cv=none; b=PIYt2ySQuHSw+oC9AkATrqSiJpZGj/SbJ7Fo3Ms4+FXX/FJXMi/972f3Zfxi2QfE2OglIOMX5RVDvtsz5LIA/aK3ZxRuumR7Zr4Ay0ctGHsXKDwrhX9IEALWgYtKLEcmBSWiSbdJ3UTgtV5+ut5LGuPoDVnfK90qv5jRsBCB6+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763994617; c=relaxed/simple;
	bh=zEN3doId9UKmo1rLmAoDue2BHiaeEn8l3OYvCK/ydP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PXYA+O9emC0z2QiKHsPyuFwmZTWnFK3EUMTWva3qnK4N+OP8OrPIRxmCJ3fFKVc8YI6hrJPQ59v8WczH2rx4P0lWQzPeVZqAkXWQ1vUaaC9o8dAQ+JIeZ+h7OkbQJ6ksjeI3owhhR31dhb6Z/9vPw3dSy3WYjiiq3vCqWKBQkwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GW13WELa; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GW13WELa"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-8b2148ca40eso605363085a.1
        for <linux-cifs@vger.kernel.org>; Mon, 24 Nov 2025 06:30:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763994614; x=1764599414; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d+6m+RaUAFXaTtrp8udufW/i4uBYkmLcVK6S66Yx8m8=;
        b=GW13WELaCJZZMZ3DNGQpWMdvXqI6V8QQwIuSRUxUpZvgFRqJGWHu/J07UjUdMK6QqH
         hYOTrQBewdeZ4HteuDK4bwV6o0Qhfap3tQAo3+xxuWvZ8Tgof17KJzPUoTdmPsyUfsZt
         i48RolOTh9pJpMdMIREgY+TJBG6jW8KhH3HLram8CjYXdIM0UqjVzAO0Gw1f1AJk9I3X
         kpSq8P+gxnnikRerbMtp7y55jzCmTaNhgeClYis44G7tr2GjwjVMprJXlfxLqL+NwWK9
         K6PX3ycNr2IW01zcKPf/ZYZwvD+L4XUKNrAg3OH/g2qwOxASXGIh8pftERmmCxKNqWqD
         l18w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763994614; x=1764599414;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=d+6m+RaUAFXaTtrp8udufW/i4uBYkmLcVK6S66Yx8m8=;
        b=pT2ymSNIsVxgNanRimLB9J6vhr7yj+Rzpc9PbVms05ancdKcBiXl+MZS2ty/RM1whF
         Sa1BHmBcvxynZJk/po9P/8DV+tGYlT35yYVJVMXCmBeTI2SSQ4f2DfA+MpAtx6jAZuTy
         DIaSd6Xde19KrB89/XX+FwERbUMSrp+CzbdW6/HRNGoIuGfQpLi1QpW3UGmNvh6MTSXK
         GB6iZSJiv7nc9Oky3uzUKoa/k3GGFtpmi3i/8tLHpAHIaUkG6jZ0SgOSTqXFoZq58Fg/
         jge/f8swvduaHxeYLplv6NZGh00zBEe65rqNOX0vYSIHuZWP+cWUTpOqMOL6duvjMHFp
         Ihdw==
X-Forwarded-Encrypted: i=1; AJvYcCVbItQ9IcnTVfzcwr2/pRDGwD1xMTV1izHNcL6ARylCjcgNkiXdW8DaRloEpFZ++gdmlHxnPuqUuOYo@vger.kernel.org
X-Gm-Message-State: AOJu0YyM29XJIj+qTAdpQMMhaLMDL9ORvMpD0CM7ZGJUCk5F5LaPl1ZZ
	i1usqpKEyh5zLA4CYX9DEaeeXodPzKbvIrxYh8I/+T2Pdyul5qVY9yIL
X-Gm-Gg: ASbGnctbQ9d0bJX+XdGfrpT9mdGJa+lmZ4Q6Y5WbJNehmJWckekGJ2Ylg5O//Ni5KCM
	UaoNBDR/gzf9oS8NXjDcCUd4PRqQnKSCLDe7BDYYyMHh/zkL3q2h51UzncBRSNFl45IbNgpQrhu
	KVULXHB67esnyMuDn46PqOa1FZLUm60/cmxA2ld2RgoymUzygrTSJ7gLiSSB89hoGfBWXHFiWY7
	LDfmWiONBgnCV0E3SG3zw4lNXvhyZyVUZCbCTm1O4sazOtspYcg+NkeGZDlZjrod3yy+l7JPRaz
	+OjQJReuU904wsI6OAVemAO2y369dNf8q5gSGK5Nb25tZTjxy3H0byLPfw/+9hMkjOoYsKOIOhy
	vE8//cYrSXa/sB1ynIqaAoV4qk16CDOQB8/yufOZ/rENrSjts6xqSJI0kbXH41UVRW0jTXAZu45
	ElGXhtU2jsuQ5yxl+m1iOhDDIax78ieABrou8XbM52QVs5h/TG07nYN2mn9h6uQQ==
X-Google-Smtp-Source: AGHT+IH2emMikOVfexZu/RJS4gdkfoIvqPQqU/1PYqEsqJ/9N0M6heG6ovXLI4KANvL5O6yungTZiA==
X-Received: by 2002:a05:620a:319c:b0:8b0:f04c:9f0f with SMTP id af79cd13be357-8b33d498deamr1470724985a.63.1763994614234;
        Mon, 24 Nov 2025 06:30:14 -0800 (PST)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b3294321fdsm929713485a.12.2025.11.24.06.30.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Nov 2025 06:30:13 -0800 (PST)
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
	Andy Gospodarek <andrew.gospodarek@broadcom.com>
Subject: [PATCH net-next v5 01/16] net: define IPPROTO_QUIC and SOL_QUIC constants
Date: Mon, 24 Nov 2025 09:28:14 -0500
Message-ID: <0cb58f6fcf35ac988660e42704dae9960744a0a7.1763994509.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1763994509.git.lucien.xin@gmail.com>
References: <cover.1763994509.git.lucien.xin@gmail.com>
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
 include/linux/socket.h  | 1 +
 include/uapi/linux/in.h | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/include/linux/socket.h b/include/linux/socket.h
index 944027f9765e..b4563ffe552b 100644
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
index ced0fc3c3aa5..34becd90d3a6 100644
--- a/include/uapi/linux/in.h
+++ b/include/uapi/linux/in.h
@@ -85,6 +85,8 @@ enum {
 #define IPPROTO_RAW		IPPROTO_RAW
   IPPROTO_SMC = 256,		/* Shared Memory Communications		*/
 #define IPPROTO_SMC		IPPROTO_SMC
+  IPPROTO_QUIC = 261,		/* A UDP-Based Multiplexed and Secure Transport	*/
+#define IPPROTO_QUIC		IPPROTO_QUIC
   IPPROTO_MPTCP = 262,		/* Multipath TCP connection		*/
 #define IPPROTO_MPTCP		IPPROTO_MPTCP
   IPPROTO_MAX
-- 
2.47.1

