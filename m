Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 329F82F261F
	for <linux-cifs@vger.kernel.org>; Thu, 18 Sep 2025 22:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758235149; cv=none; b=jrPcCCShQxHzoD3x15WewA/6qEHAgQzqb+/sojCC/uS5M+OkVO5+s1m3Y9X6GSd4TLZEGgjCZavCf4Wk+pCbZ/8Z5LzPSpBq7tjHG472Ae+tBUz8XZ8kp1CWaw5ir4otbPnII24D00qlqJh0qh9UzeBQ23HbCcGUBa3Ubu7cxu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758235149; c=relaxed/simple;
	bh=AXo1SVGHBK9qT4qVLa9ToApVKadhJSI2IuUi88Evw0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YIzJFAP/ZY8jjPKh1L7QqETP185kAm0kGnBhzMKnMirLKeOTzFkBy7Yj1vy/8e/miOkYg3GV6xSzC7h7Tid8tfZpj1QRw/96/xb5QIaNEGGMM689XKaE2i3uTwg8dKWtb1XiH24PbVJ/NjmTpc8sAg7Du2Wxzo1mZb5ZeXYw7nM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QYehT4OA; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QYehT4OA"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-8117aef2476so151881685a.1
        for <linux-cifs@vger.kernel.org>; Thu, 18 Sep 2025 15:39:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758235147; x=1758839947; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4JTNUO8XZtm3BiSnNgj+nAIXLdP3RxRAv6TMRPMgtSY=;
        b=QYehT4OApJ9JC/CBgIU8WN3v/0pwOMGQqkvDBtCIpOhSR9aL+1Zt7AtRPTsZ1mNxED
         TCoduxl0XnSS3adykRmcjqtcluXmAvMnuAnDYsRPZPOEqfgrqv3QC19IcD8hV4DJJD7+
         ZcE0eCM1BjTLQd1YLbO452GQPJI5F1iwclmUv9saCaCi5gVbiSVNQn6C4+6Z7XHvgszr
         uo2XIfdC8IBjkkEE8fni/XkLzVqDlLq6NWUpPkYP8x6mKZijxuDvhSzXjzXm5btIbh8y
         95KudzRQ75l4TKfxkkDHEVh5D778dUPsxMq1LN/Ut10kG/Ggk2D4ksZBylhdMP8NfdsO
         6Giw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758235147; x=1758839947;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4JTNUO8XZtm3BiSnNgj+nAIXLdP3RxRAv6TMRPMgtSY=;
        b=bA56JUfWZOMhagZbeDkqVyo+vg2ya2Ui1CWXNajXdbawNpyZhDjtRNuzOsp/YPtZV9
         xLJC7lxr1shqe1YhFzQzwlSAfpyxl4jgT2n4CNxjZJ8RGX+eBMoEy+/TneaCC6F88E7Q
         9wdND9Ak+KX3PoeC/v7pd1+rsgpV/2nTI1RoPVppHaAhk+/hqavxcSvqaw+32qDpTuCe
         o+ElG8Louda5BIzasnEfCI3W6Q/zKJFfLC39NpwtfxUlvdbM7i6DNa+uFr6OTO9t6f+M
         CB7ERH0kWN7kmcLqZ2O8dDwpgqgNZeUY3vU4ZoQE9wY3wSv+1Zhdw9NrBl/h6Zh9h4t4
         MDug==
X-Forwarded-Encrypted: i=1; AJvYcCVdx2gD6AhoZjm3TH0fK8IIMSJ9kmZW2MJWg2jTjDiEUrN5UCC+JDNQ7fkK5GfwfjcblK8PInPP/ue9@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5URVQdprK4p2S6MFHcbWe5hA53Om3vngvygEREAIsxMdJ5YnF
	51JZU8Zfg71P4XW12XrJH3Rrj4sSgBMWok0CFOiFvwPeF8Vh6jtavfGW
X-Gm-Gg: ASbGncuUPzrgTJzWxUKsrf3ofSxaSLBFQZWAeWMIhKZVq8azzDAnMBAivLTb5fQdvbf
	QTFhpKF/r7JFjr9kau6l8eFLynouhC2l/uW2eIFWwkjC/xz+O+1UZMKGHwQD93f32gC9OhgEB+Y
	jB8/ZzmAbHSvobxoyqQUyYnvTXArsGoAGRDd4nZq4A3ilLLOuPeMeyIIuwyEiBgy/CyfZ4L4oZd
	+kqM6XyL2Sl9RKy58unddQVlYSWNjIADAEtGHnSIJWLMCyGGtxi/XmV7iFGtpvc1q+qI3wd1T79
	KpAAOCu0dW02FIeC5Xqj5ud1X7WAjeHK0TBMAFUtkjCw5ODrzcCN7/zx64T/JqeZyBNpsQQKgFK
	0A3wBvx77yuVUjLr5b1Ao5d6iisAXIDFRHGVqKJPQx7BWIUeTzjh0zHQaWxVRFGhTBshRT7T+KA
	VYR+T6u3MafNIKN6JB
X-Google-Smtp-Source: AGHT+IFLJPjYJgjIWzKGX74WDXjUp+q+FL8y/nBxd9QzDqyc1Qs/QJy+mr82Z3oWVcS1BUjOQ4TI0w==
X-Received: by 2002:a05:620a:8907:b0:824:ed61:3d84 with SMTP id af79cd13be357-83ba5f4b8ccmr138253485a.37.1758235146805;
        Thu, 18 Sep 2025 15:39:06 -0700 (PDT)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-83630481fc7sm244631185a.43.2025.09.18.15.39.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Sep 2025 15:39:06 -0700 (PDT)
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
Subject: [PATCH net-next v3 01/15] net: define IPPROTO_QUIC and SOL_QUIC constants
Date: Thu, 18 Sep 2025 18:34:50 -0400
Message-ID: <0ac39290eb8089b08482c94870acb928ebedb878.1758234904.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1758234904.git.lucien.xin@gmail.com>
References: <cover.1758234904.git.lucien.xin@gmail.com>
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

