Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2FCA313550
	for <linux-cifs@vger.kernel.org>; Mon, 26 Jan 2026 14:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769439180; cv=none; b=F3gU0bSIEdxtzkdGjGnuQVGWZBA0jT5UalzOyFBnn9/pyT0Rho//KuGi8ktEsKRrBtlaOAZONnNeiu9B+KKsSvmHgbcNRsRF1M4ZedQO8QWYZOOg9NWFGmlMtmX9hUSQ4X3MuTVwdpHPbvpYWSHjn+oa5+TgklNLDU673iY+yuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769439180; c=relaxed/simple;
	bh=EmdrmrQatIkWYrWc3Tso6zV2W4IPfCbeSJjTG87cs5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VOQvnipxgC5yqQnoUBaYHNwXB4tspOcTF0tqQG/17fI7/uiJ6UteQ9Flq4A5f3jFo8lkz+4WED91Y86anysTRf3/XBKnjHTukCYcdkG/59owp75mZPWXb/Ih0pYx5+Lz6Wqvrdx1GPcXFc2sL4VMDoSNrRAukzxZt298Wtjhcq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VfRDDCKM; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VfRDDCKM"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-8c6a50c17fdso518711485a.2
        for <linux-cifs@vger.kernel.org>; Mon, 26 Jan 2026 06:52:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769439178; x=1770043978; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0XFWhnozczQdBY9wOF6c5V46t5MOgQ+lGzwQjjTNU9A=;
        b=VfRDDCKMrqDWX8AYXvj6Eo/MVLJzPs7hWwdXq47jEpvhuoXSgEpYFrkWUPii0xv4Qc
         KLARZdRW/PJC0WhOTS3TBcQU/4y7aScNg1TgCOjGQ2f+30GzAsUAb6LtxWBqd15Wqd4H
         3QKnzXetBKeaKtwHhB1EKzzaxddCCj0jhGau8qELLLyh8dzc5khlk8CRgyFfb589txdz
         sBwsMjZoi4hTbBy08doGv6Jt7vfUIQdijEdlpaxvhFowZwcMdbJ5OX6iqclb9O6rZh/g
         YSxmzQxpTKD5nV75eYHfnODh6WO5BzMr415UtncTComlWNkXusF/LqBycrZzsxhkf/Vi
         yDpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769439178; x=1770043978;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0XFWhnozczQdBY9wOF6c5V46t5MOgQ+lGzwQjjTNU9A=;
        b=gq4xl0FaCE7R/K5GSch2JV+Cl61GjqLeeyB/e7mAy02jWGmwn6HJuGTjeNkYECO5xK
         nJeIKT1TnSsm0XA47ultvYXptW3Ze5WqAQN6Nf4VFMU6vFmaFJTNSP0AiSr0wfWpyYrF
         xOnZ+NNEQhR35tOUnBYlfdRNMLoPk6kEo3H5Xk5sof2nB3rpCm2XJ1hTiLIkmABjxvmf
         CQAj2/o4SJjo7zeBm6CVSrfu7MtJzYfDiwRDicEjtflH/6DSWgapHFRY0SqZ0QHCBVoI
         1IdqvBT9PEQw2WvLj9xgMGaNorjlZxFtKAH2X2UT/SjZ3uOKpDXrMtBPqdPzKWE7wjuL
         vfKA==
X-Forwarded-Encrypted: i=1; AJvYcCVxLX/F58ofN1CETeyMgJs5kb3U8i0o/CveVYzKLL+37Ui59bSgoAKUlABhP43I02tzMlvOV35aEvuB@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7IohqMav/KreZw8WM+GJvR3i+3FXZOh2P1OGV1Y8Z55TP43AG
	FOVapBi0MMtNMaPRE0ine3oZD0o+Rkc490N8GKDNtpCrsOqXMu4vQcRV
X-Gm-Gg: AZuq6aKFiHGZ0ucMzcWksn5vrbFc/W7EQCxkHkDEHu/Kr3ulQusyvl1S8FkavpJUWmX
	wCYgKyV8DGq96Qaym0YOvUWMP266LuVMFNK9qtcKz4cmC3g+05woszosDjDplAl78AZ78weKYs9
	6itt/AMBpzcsKtLJUKZr9bpXMgJG04uyhZ+lzNeHnvGpcQ4HWy6+4RwainV1b3K3Q/WSwoBHyHB
	gnHoM6FnSxXDTrMh/X9sLP9vRaRFlKiYatRwa0T27drQsy8dT9GW+B0Ag0342C0+kjoo8CPMYNf
	2iQvQbKqa/6GX90dobM8KSLtb4R8YWuIAdpH+pH8zvUJ7mwOCB2SPtWirNVOvRPYcCBZTfWCtpl
	5Kf2u7nSX7HeJVhOEHGn78Qab3cxOXEnmutnOHaTAA2XD1XTodhJjA/ovy+91PmI58XfkxRtA79
	E43c9wOP7vUdk8dZn7O0mrOpY30ElQL20S78tZ/JQvtcqe+cj4XqM=
X-Received: by 2002:a05:620a:2a05:b0:8b2:eb66:c64 with SMTP id af79cd13be357-8c6f95c5255mr555017185a.29.1769439177669;
        Mon, 26 Jan 2026 06:52:57 -0800 (PST)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c6e37d2422sm1018611585a.18.2026.01.26.06.52.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jan 2026 06:52:57 -0800 (PST)
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
Subject: [PATCH net-next v8 01/15] net: define IPPROTO_QUIC and SOL_QUIC constants
Date: Mon, 26 Jan 2026 09:50:59 -0500
Message-ID: <d774ce5dc1fdb45b2d68b63fed3975da91c1729f.1769439073.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1769439073.git.lucien.xin@gmail.com>
References: <cover.1769439073.git.lucien.xin@gmail.com>
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
index ec715ad4bf25..dc80de8d8c50 100644
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

