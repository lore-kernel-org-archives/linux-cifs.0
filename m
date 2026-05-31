Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF8EB38C2A9
	for <linux-cifs@vger.kernel.org>; Sun, 31 May 2026 13:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780233081; cv=none; b=K/vyZ3Lj76LW/8ph3hR1RXTrg+Yd26EE9UdrP8zzB0aLnra5vV1Jl/+Jjtr2GfDdZ9+5j2hVC7ZKe0jgflAoHJT66TlEQGx/SVsX2HHblLvM5QNap3xI88efzLMw3oSSdpsZTwhdRjQ9pSz/A6zO8aZa8Dmjn/YxQgJqqKyk2tE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780233081; c=relaxed/simple;
	bh=+r3tYa1O4nzHNXgUenOGoOEDKkt9r6oEsRxV2HklKR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mxBUfnHTelAXqv1w6vifsyoC0PsT0N01jXORDocs0nqb7Ae0hYaxMql4VWKG6walHx0nTPQJgVxk99RUr0V9uK4Or9EFNhw/T1DSbzY/wQhwj0ncu476J7KIkGbIFXgihI0Ki+hPL1NZdK9z5ipHEvs6rWsoc3Em8Ehsc/3ghDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EEWeFCDF; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EEWeFCDF"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-8ccdf8d4ac5so29497436d6.1
        for <linux-cifs@vger.kernel.org>; Sun, 31 May 2026 06:11:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780233079; x=1780837879; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CfoS9zHnWtS92mtRPUnEWGWkqfJ2EjLVIhUjEgbm2M4=;
        b=EEWeFCDFiQf9AhAvLPeEbS02wHJ+SoYg6i99HiHKVhq4nf/Ka4UoVhZo/6PDA4zTmi
         /zvGa0MYJoQ7rrAyFO66WhE0W6qDW16cj5Uj+iRqsClv31IMWO2aSWz1H/GMaUWZ7CoV
         yVI9MP6LBSRRnL6ABaqPi8HybBbYel/RHp8vuBjQJzESYR55mVLfeeGPw6qZmUmRq92m
         LtPiTBqjRqxdQk9Y5lNN2Oc0JvWNLx5hR9lMSWf7SpMW8A+pZm3OGZJqKoo0lO6GFo1/
         8MD4XYvBrCnHYfBxe8t4GEmtiZJzrjoG2zEmdGG07NHqUmi0Nw7i4bkbbTWj7CCB/dvp
         20hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780233079; x=1780837879;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CfoS9zHnWtS92mtRPUnEWGWkqfJ2EjLVIhUjEgbm2M4=;
        b=eHhtj64A/8WKH/tH1vM/h6z9oXnn0XkJ8iCjekOtiVxR6CwBTuuwCl9gchbc5+GCKb
         TDyRa4pmfypM+dgDczyaUkSnPQ1aMot9IsYmCybjV5yUBLXj2EkJmWiHtsjSChTwg9K/
         IvjrMbaoAuZjTqI4po5K0PreLnjcfYYkdELslQgbmrAZrarw0Saos49CaoEEeP76hHRk
         o/YZxHNSvfJ5pTBRdIqbxfg23+kDGCd0/NwKMb1NspEyR86lOt/TvluUfCip4v8lPIYG
         Bb/VKyaBQEyD36YHfqSGG54vxBG0O1E2MOWNaT5Zz4+u4dQszpLogEWQeoHIZayQTtSF
         Lwhg==
X-Forwarded-Encrypted: i=1; AFNElJ+FLf9tijLw++fWCxvJjyyTuz4azRcaOA3f2cKQYFenG2OWFjxLWg5HVBfDVjc+Xqoa5EAPnzKBBnQR@vger.kernel.org
X-Gm-Message-State: AOJu0Yyslz+xKUs58GnFjQDALkQs+Lqw8gjI32FPtkWdbdmlKKxB8JmB
	HIGeGG36glnCSxhlSx141GsAS7of3mGOXHnsiKiLWCRfNHnH/4QrYEDt
X-Gm-Gg: Acq92OEan0JESfA0mVd1cY0DW9ga5zldAu4xuAydEx/BkM4s4jLpm7t90tuMsdTc5Ly
	ovcdWpDwKW0m0O029SMHlWSzKgnymtdLmu6x2v1RI/fsNe3NKf8yk80FhCZ1Q8srwntsRFU920H
	/sROq0WkaKSJwHM9RsZdTz2yNhDjPaTo8UJHPitm8sgBfPJ6/diWsDfYE9adZtGtGF+ZcU3gxAI
	b7laSeGxVBqrOCeydIoEE6GaH3+pxlQ/AiPjss+Yt3ddoIiVU2GEyhgXIUSf9eFxd/NUp9Lq7IO
	pB5C8bl/F9cB/3E0ow56OwtuiKWxWBzK/z5xw0jbng+ZLBHfPku68URjTgNmV4zitnKEDxb5b+y
	5c8wRF+6hYZ5SaLkCZy3JRAg917Q5XJem18OsA2lCwRMyAitH8z5iaMa67ja4CydgzDorAIVF+F
	z71GcOmF7XafyryJY0xbx8X7YV+erVL4qezoyQ6vgTK14fzSRz0nyk2AF2BXwGo/lWJmRtfLp3x
	3TpjOqpfK1CUQIYAhPwe9qRUneyXYEwwuH0sIS3kUrZQEHkVljyEgxbJvD660DNJAHKIJWbsaa/
X-Received: by 2002:a05:6214:2a45:b0:8cc:e102:b491 with SMTP id 6a1803df08f44-8ccefd3d97fmr123451416d6.4.1780233078757;
        Sun, 31 May 2026 06:11:18 -0700 (PDT)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ccea2163b0sm69609746d6.38.2026.05.31.06.11.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2026 06:11:16 -0700 (PDT)
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
Subject: [PATCH net-next v12 01/15] net: define IPPROTO_QUIC and SOL_QUIC constants
Date: Sun, 31 May 2026 09:08:37 -0400
Message-ID: <36cb9b831d8f83dd9a2ae38a8b8d81e502df388d.1780232930.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1780232930.git.lucien.xin@gmail.com>
References: <cover.1780232930.git.lucien.xin@gmail.com>
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

