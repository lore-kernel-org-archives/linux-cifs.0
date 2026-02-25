Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CF0D285C85
	for <linux-cifs@vger.kernel.org>; Wed, 25 Feb 2026 02:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771986937; cv=none; b=HVp1IgNvyGt0sv0wPhtsQIXTwxKfjtiptd9hv2cptrwxjxp0tKKDokqZxiS2gjLU53YAy7twRQy4JA2JWnwSt8iUBIOH6P6gzR6VD66eorLz04OtO48cRY5ZNQVWZMTQcr2X+D8yU83JCiimDKryu2MzRWYnEO78musq7odm/JQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771986937; c=relaxed/simple;
	bh=EmdrmrQatIkWYrWc3Tso6zV2W4IPfCbeSJjTG87cs5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W3bz8yc182sWN+Etl9X0rVoshAO2maZn3yOlLxzSSVDylHIK1xUGyXK76CHt6okq5Ubj9fizv3/2sW+PD7U/tpdGxh11am/tacxYwstylJoGHGi9A40kDYEg0/WBQMU8ewVfmIqae0/SdvJn/lZuzu7RWbvT09MyWz1LXzEVXWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DhRm5ca/; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DhRm5ca/"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-899a5789b5bso22776576d6.1
        for <linux-cifs@vger.kernel.org>; Tue, 24 Feb 2026 18:35:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771986935; x=1772591735; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0XFWhnozczQdBY9wOF6c5V46t5MOgQ+lGzwQjjTNU9A=;
        b=DhRm5ca/9kXnZ9A7f59m5kWNeZeCOMRPWhaIW25VPoJUiOSzvwpbron85i4oxIxdGy
         9l62kSv4p3qBegbxpCPjczAxdPUAzcAE8ljLp+mrILcs6qMtOmAczzlYFlwk5XChWvxh
         HeQP7mS3IKKi1aWip5sY73lWuBpZlT+0kRm1c3FV0Y7aA10zKPHn4Ca1g6gMsT6lPqSw
         mUpS4lr00fQHEb7sC4Klm1UPEhI0UF1+e4jhb26E2y0sALdhs0RUAtNsR2Qe8jDS8Fvj
         aOp3uNWSFafRc4jbbU6/EOdgQ/KfCx4XZyW0uoS8ZkTSGqzxOrxF3N2hm97LFRbE8Pj8
         T+Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771986935; x=1772591735;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0XFWhnozczQdBY9wOF6c5V46t5MOgQ+lGzwQjjTNU9A=;
        b=RZpLAb3TltmgmpPBDN1rwjLn34cpIkfIqx+6D+EhlNx660XCAv20clRc6bQAQTZTli
         ntNvWwQakW0AWn0vzzPtiwfGnP1ili+6SCuaiEJJw0Xs1dXTdtIo6T1eFzj8CUE6oUvR
         XMtJgcsEGLf9F0BkoTuszjuEA0jmYcQRaDbqWh9nHhyYO/MTY73PAzhqt0WZ3gwrMG0N
         E/8dtBS1d9gAGus6hLYRZT78p2TGsaEPUSB9OCUaO1OY2uFPuQft/qYF8YoE1ATfFGcw
         GhJ2WnS3jzLYOVXBF9xSuWqmbQpZ4VFOXnxpJ6wEHLJxgK47WM7D8cCHGwLKgRhAyql/
         QIqA==
X-Forwarded-Encrypted: i=1; AJvYcCV2KID8X91KDygOve5TpgWso4xiPuxk8m3sHu+8gDS4AQl/e4OxZa4U4RtocSqKwyUxXoYfgWP0Fwwq@vger.kernel.org
X-Gm-Message-State: AOJu0YxUyTx1Hv4IQWKQ/MvJqFA90mVlmSlMITsEJ1/a9Eisr2Xtzxk6
	TdUSR6bRbYp8fbwZDf0hI8IjN7RqDkByLMGD/ZzqGzbg18Po7+Rf9AWI
X-Gm-Gg: ATEYQzwaCdfA8runFmVcZMBZF0RinZolPDDgAZgkBh0UofZmqUPnmeWFUbCVBCDrSM/
	7znHHIXsP8VQz9YgGkaW+XOJ0RIE77BpDsXC+PrdpeJQF7Qrr23NPk7EJbJJ4hJfq+0NK6KMTTM
	nqlQpsAhKCZ5MWkV7rD20SmEq8L3vFck6C0TwcjXhL/l87nLrti6GcBUDlq8vN1p22SbWpK8rEI
	NBLALFXwIHU8AnO31GEDw1O0bUVkknbjSqMCh/+6267XXKgmhic0DMlf6iD6XJkDnqgBcNkH+hO
	txV6k+vDEY6nW/Bfbzv3xB2axsHgH8bxdCWMQ+sjxJH6yjewRyfaBtey4SJ8lHsZlQX5y73BK2e
	GdCpCMfnpJUuqylzam/GfRQFpNRv72qg43r3ZLfQe3rdepTBOXPXANx4JkfoLwPI/E3Jkd+B7j0
	c3k33FOsus6DNab8cStE0Mf8KAFrUZdPYMZWUJ7G16rnD4unnqeq5AqsgR07ibq4gU+/dKTYhNc
	0c4ZNPKOkiPEfmw/CHSks+WI6lOTyKJV2v1cU4P6sqMp/iN9Cq1GiV5b6KJED51gQ==
X-Received: by 2002:a05:6214:e4e:b0:87c:2c0d:309e with SMTP id 6a1803df08f44-899b8c1ee0bmr10279896d6.37.1771986935317;
        Tue, 24 Feb 2026 18:35:35 -0800 (PST)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8997e62f453sm112363586d6.36.2026.02.24.18.35.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 18:35:34 -0800 (PST)
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
Subject: [PATCH net-next v10 01/15] net: define IPPROTO_QUIC and SOL_QUIC constants
Date: Tue, 24 Feb 2026 21:34:07 -0500
Message-ID: <d2fd583ab20f2c8fb9ed91bd4ef1afb1d75a8797.1771986861.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1771986861.git.lucien.xin@gmail.com>
References: <cover.1771986861.git.lucien.xin@gmail.com>
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

