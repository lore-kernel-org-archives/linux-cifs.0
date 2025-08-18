Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com [209.85.219.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85DAA3376B7;
	Mon, 18 Aug 2025 14:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526344; cv=none; b=kdWhd3SRW45YkaBelRKgj01syFwDOyqqjNO9oeQ4ix/5Wo8LzFxclYQtazYj4LylG65/f1jjQ3ASwb12RyyFOBd1PKZM24L48lGAmHcs+iKHoUdK8j9kskzVQhvZjDmG9U8BzmLmH27kftG/5lA3oFrvF949qY/2Ja5SfZHlRDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526344; c=relaxed/simple;
	bh=AXo1SVGHBK9qT4qVLa9ToApVKadhJSI2IuUi88Evw0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hRgKyg1x5DhK4Pkk8FkJuOf74y+S1hMOQwTJIOdQ5VIR46dxW2IJGYxDzVI/vG33dBSH1UEsn9bY/VHUQbmWp+tIuHhSVkyaUyU9eznV6NcbT2YhOkfwjQfcqUykBVY+tth3itAMqaOSaMrsDeC5K+daOuue3GZMqO/wQ+muvHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m6JidxIZ; arc=none smtp.client-ip=209.85.219.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m6JidxIZ"
Received: by mail-yb1-f169.google.com with SMTP id 3f1490d57ef6-e932ded97easo2695663276.1;
        Mon, 18 Aug 2025 07:12:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755526341; x=1756131141; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4JTNUO8XZtm3BiSnNgj+nAIXLdP3RxRAv6TMRPMgtSY=;
        b=m6JidxIZxYoLk5xP7dLdF+9JW54EPeuE/4eYHOJUblAmZyh2/D1eXjNzriex4h6irG
         8SSeHAsQAz4w/syfq9n/VNOCg+u6kEaNMaFyUZtsQIOo/+ydL/o1JusOiAjiOKvqCRLp
         KNghiPhW+LgR6iwG1fJ9+hrQljwzFRkOupUobNXeQiNnmoTiZvB2JCQEj23B+a4l+bMQ
         7RCuqOahYcfiRekoulO73moBTtdw6ZQym/oRYWS+ZFuDTHn2XhzBFE6YImf5rBLesO9/
         htF7lmJfdpuSPB51WWYFB3Qh10/wYNI1/t2CBi3aon255R127wcAWERSfdidX45dlNkE
         TrXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755526341; x=1756131141;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4JTNUO8XZtm3BiSnNgj+nAIXLdP3RxRAv6TMRPMgtSY=;
        b=ZA5i7vukUSt2v3hVPELZNWNXBVgZmjYrN5WJ/1Eee3vMIqSHKs3If74FOITbMZtyGD
         Scf0eUqo61KvD9AyaCbUHLrjwwQrJWIq2M7pxlhHGtbooA+VBe8IMKRWxbkNkIPGMeuB
         CINIEnSCCHZ9FWWG3OlZLjUTvpcAJP6kOY65ZdrGHjfzIhBMbB3gWb3GUpqQFRnEGh1/
         kpLzR7wfMyDMB+g0YOw2qN8jLh9GtqFHUpm1C9hEbu7SuqnzD+rq7seKrsv0GVrEycfX
         JeTY/5I9UkNtRdohpcG2g0QhfBtlJBBrKo8EySlxkP7n31UmVO5n55cVlXjleClpVgZh
         3yHw==
X-Forwarded-Encrypted: i=1; AJvYcCUBpqm+K+sucUOz0XjxeXKH9Gr/k0GkCCdiFA+C1Vbj0AhKZ8m535ZQe3PaYHMLlMxQz2eu39ROx3P3@vger.kernel.org
X-Gm-Message-State: AOJu0YyA+yGEKi3oTs/KwSZwfYoa8xx8Yn7D1NOCk9VANlbBFnZPNCws
	/8Nxhx4i6sK0AQ0JmVJfWmQJCPcKOEpzybj/00F/6gO3FznPGLh0d2GiRkFj6pfdwow=
X-Gm-Gg: ASbGncvtE573JB9sNs2zBo3+xdzauRbVSOlzHcIiSyYXxj5ggBulTCYGO5ttHRs+vpi
	FYXJOPd/+OcjCTfjCmiIqb9J6zBDjZjsHMXz2K0fxlyN3d/90rf7dYQe/96/YPMSCee1VZdoy2W
	ny1+j4PSVzvGOwjDOhXv7ppSjmXwwRxVW7jF3wwz+GIlHcl+0Uhgr/GYf7QxoPahoMwX1Zk146q
	A/2tdHGb7cZy9L9JIg4ZpeX/l4UOb7b7pUec18MlxN1BEkpvrdsBdcLAV0DNij7vPhhE/P+DJni
	U/4C2cB8lVNG9lafUjRVPAIzd+edfKbntsICLXtKMUTzBFtNj2AzgEareUNQ4wU5V7OW2NGKZoZ
	kyPs/PzwXdeJOdYqYPeq2hDclXNYB/Hw1zMjGXLzC47rSdsTd4fafpCNPCIM5pReWjj0lEgYOoA
	==
X-Google-Smtp-Source: AGHT+IG8HKunRKRbgCe+XL/NaaHMh3wfAZKIYILVWX2Ompn9UMBJB17qEcA9PFqPOHmRrPLA6THDAg==
X-Received: by 2002:a05:6902:2002:b0:e93:4a3f:9e65 with SMTP id 3f1490d57ef6-e934a3fa476mr7593654276.12.1755526339129;
        Mon, 18 Aug 2025 07:12:19 -0700 (PDT)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e933261c40bsm3157451276.8.2025.08.18.07.12.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 07:12:18 -0700 (PDT)
From: Xin Long <lucien.xin@gmail.com>
To: network dev <netdev@vger.kernel.org>
Cc: davem@davemloft.net,
	kuba@kernel.org,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Stefan Metzmacher <metze@samba.org>,
	Moritz Buhl <mbuhl@openbsd.org>,
	Tyler Fanelli <tfanelli@redhat.com>,
	Pengtao He <hepengtao@xiaomi.com>,
	linux-cifs@vger.kernel.org,
	Steve French <smfrench@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Tom Talpey <tom@talpey.com>,
	kernel-tls-handshake@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	Benjamin Coddington <bcodding@redhat.com>,
	Steve Dickson <steved@redhat.com>,
	Hannes Reinecke <hare@suse.de>,
	Alexander Aring <aahringo@redhat.com>,
	David Howells <dhowells@redhat.com>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	"D . Wythe" <alibuda@linux.alibaba.com>,
	Jason Baron <jbaron@akamai.com>,
	illiliti <illiliti@protonmail.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Daniel Stenberg <daniel@haxx.se>,
	Andy Gospodarek <andrew.gospodarek@broadcom.com>
Subject: [PATCH net-next v2 01/15] net: define IPPROTO_QUIC and SOL_QUIC constants
Date: Mon, 18 Aug 2025 10:04:24 -0400
Message-ID: <50eb7a8c7f567f0a87b6e11d2ad835cdbb9546b4.1755525878.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1755525878.git.lucien.xin@gmail.com>
References: <cover.1755525878.git.lucien.xin@gmail.com>
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
---
 include/linux/socket.h  | 1 +
 include/uapi/linux/in.h | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/include/linux/socket.h b/include/linux/socket.h
index 3b262487ec06..a7c05b064583 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -386,6 +386,7 @@ struct ucred {
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

