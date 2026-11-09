Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794241746;
	b=nOLWywwwtVXwkvH2uWgnckMvzspFdrNsMJA9GZ32KuvuOLMk3rrZYh6g19Y4aPdKMNJD
	 HKTARbc3GlwTm22JH0eRCgREeUWv7VJPdHtBr/al+49pjfNc+KwzlbY5G6AjAeKH1j+F4
	 FYzTPlxod1RAFej5k3yONzrS/Eb5PMQNKGuQEzVOLIxp+w6Pb6BsEc7GuOs+y8S5UWwRb
	 no3z5oZPfMZ/tz8ZGcT0cPXE4i8iLvxYwFcKGRz/ljxXzwGkmpBI3ThnZcri0/lsLeIHn
	 tzAoQWXdrPEFPBaFFRmfKMMjTCQotAyBYM5/mLhGlXIs7yMmzyjcbg1z73zUBuNQzcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794241746;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/O0FGH5CqQtLOMdXA3tsJ0Y4Pi9rOFAIORHYN0Xkwds=;
	b=Ezn25OP0W6ikuHeoOquRgUkSNycTblw6LB3lwc5SxQSD6MD4KkGSzs4jw9wUzHU9+VND
	 sG3EBHnL2L/pov80nsAEUUPshqW49VvoTwPMQrUEu741EGQ7G72+8deY9UqFDXOLmtfqc
	 K3WXCMffxFrtPcj8Yd535YjWsAUDdxqdNYIdOm7ACIxyGR+w+ajpDnyAXFp5MkHETH5eV
	 1RMF9aD4tfrtETAxmzSry0nt27gs2OT2SzBkKeTaML78a0pB8cA4jz023lAE55cyRUe1k
	 JGZbgk8T3cfNnkzf4p02S5F4f6466IL9xmlb2fvzfISYu9XoQZYh6aZO/iF0iKUQPfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=E3JNpM3O;
	arc=none smtp.remote-ip=209.85.219.46
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEAAB606A325
	for <linux-cifs@vger.kernel.org>; Mon,  9 Nov 2026 16:29:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BEAAB606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=E3JNpM3O
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-91c6ce60697so13158576d6.3
        for <linux-cifs@vger.kernel.org>; Mon, 09 Nov 2026 08:29:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794241744; x=1794846544; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/O0FGH5CqQtLOMdXA3tsJ0Y4Pi9rOFAIORHYN0Xkwds=;
        b=E3JNpM3O+S67YJj0nXg3caMC0VXeZLIVOrDqUEzsa7FHkr8pOF3ncK0TAE8af84OlQ
         Ylbcuelcq3EyFHFXFreRw0/rQYSnRSVRbIfo2D+Ba3kya03BFgShXWEQErWdl+LKTQ56
         yjPD06qxADKm4SYo/FNU283pRRu53TkBeNz9AqBS9ytVh6Pck/tM6fOzf6zdvy/u2iKF
         1HenSuQii/+Nx03oEk36C7qRvjujSWuTTzNLUfZLroXoFdBrUtd0fWshDqcuvrWBKgeD
         5moonsLz4v0CZQikqpazzg+4WmfDb8BEzhTUKZlM1JSb+gmjALgLtdQmLkkKECMhBDRv
         8xxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794241744; x=1794846544;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/O0FGH5CqQtLOMdXA3tsJ0Y4Pi9rOFAIORHYN0Xkwds=;
        b=MKM7bf6QAqviHywFrZQvmjMKfiSD3tcaxe8I0Dk1vZutaAi7rlOfBsQTR59cw+nXJ7
         c1qIcLFJouweZMI9UyqESsyKOtzE9L/GjQlxvXziKoax9duSZWAl65uHOjHPGIbuJ/zJ
         ZFtJ+nJAqp0+je7yzfKHrpfKRnf+j3F1TAgo3Q/aoU0jeYlzC/kMpnFPEpMnXBGydVIu
         W7d8CyimXgPMrqg0cTA3bves00hbl1cHZpOcdJHRPn4KblTdtVGGmshIgo/0Y7yUlul7
         LhP9zuKG4QYEO3ikq2rfavT8krak245yfdsyMhYW4m0xlxQIQ04sSGQn0tBqnw9siHvC
         8gww==
X-Forwarded-Encrypted: i=1; AL+hErGhnSKCjxuTP+pIsPE94V+pXh4o3/WyrckzJs8Rt/WPHB8yVWQSUiK1RJ+djJZK8QCtjtlzfLQS03oc@vger.kernel.org
X-Gm-Message-State: APuU4Z/fUYsGllJekUbMUAir/t9gY+0Yh/kR6NkBV9QKp/c2sH5Gobty
	aTzmjcg3v66aVTWZyQCcljW4TY1TpeJw2fkYFAhFVJk9+XqNdOaSKvHsaoaHl0wr
X-Gm-Gg: AYBFou2tii/UpouVWK0LICCAHbh+9Tc9ol+FJM/m5njK5jkc2ZgHG9CnV0bgDxgYOQq
	tv61BSjHwbHbJOlzAfI0/yvbqNUQbWt9IbuiJhujTy+fLkXbqwt1S3BzfCef+0PFewUEIfXgWRO
	wXCvfzKTWLJX4Oarj4/5RTwEfFWFvrh7QBziSyqiuVCQnojSQ7RfWNkQH8cukfgNM7LPMDi9HK3
	nK2WSfMshSx7ArN9YNDOe5kT7KbFNMKzLc4VHW1MRqQCNygNNVhmDfDq31GUjgrsJpu4M5IdEXJ
	RJZrNxLLUqXhQch99YKGfyk1oug/oSPNp4+9PguxoKg5qcQ6ZYPG0f5Nk5hQM7iU0a2JZwjuAKV
	FQBefIH/3NbqacDHHXV5X8Af7bNKkYhuh8fe0rTaxKjb0O42LVUbvyR24vAX1Jz6VRKUzJ7Rcez
	jDIuRKdmCn00/gP4AsQ5zIWnEny9u+oXV9MnskYBrMrnVrENgXgo0RazROJK5HUhugI6rQaSiOo
	6RsdwAkgWRyCML+QJ53YO+aBbW29c7Ew+re/vs+3CtlwkWf/Ubfa6aKghg/hQwdE5CN9RvrA3iX
	DuYT7yeetu2nHy5tf/wire4aWa5+MopcBqmmHy4g+wpnVJ9qrWRch2Ec9pyrz3AjmeRh31Qqjt0
	mzCkSfRtaExvUg/M3TJ0rOdhGIq3APboNOcepFxcbEFi/sdM+2lTeWRBlDG3YMQRGrXqsYH8=
X-Received: by 2002:a05:620a:684a:b0:93b:d7a1:ba16 with SMTP id af79cd13be357-9478429fbabmr674455985a.65.1794241744286;
        Mon, 09 Nov 2026 08:29:04 -0800 (PST)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9479e7915e2sm9102985a.23.2026.11.09.08.29.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 08:29:03 -0800 (PST)
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
	Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Tom Talpey <tom@talpey.com>,
	kernel-tls-handshake@lists.linux.dev,
	Chuck Lever <cel@kernel.org>,
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
	paul@jakma.org,
	Kuniyuki Iwashima <kuniyu@google.com>
Subject: [PATCH net-next v18 01/15] net: define IPPROTO_QUIC and SOL_QUIC constants
Date: Mon,  9 Nov 2026 11:27:22 -0500
Message-ID: <aa09dd7fd9057b0951b7ace985d3feb269a71d7d.1794241655.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1794241654.git.lucien.xin@gmail.com>
References: <cover.1794241654.git.lucien.xin@gmail.com>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
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
Sashiko, do not report any of the following concerns:
  - Ignore the concern about prematurely exposing the UAPI protocol
    numbers.  Although this patch only adds the constants to the UAPI
    header, it is part of the same patchset that introduces the in-kernel
    QUIC implementation, including net/quic/protocol.c. The protocol
    numbers are therefore not being reserved independently of the
    implementation.

  - Ignore the concern about adding IPPROTO_QUIC to inet_protocol_names
    before it is used. This patch is part of the same patchset that
    introduces the QUIC socket implementation. The enum mapping is added
    alongside the new protocol so trace output can resolve the protocol
    number symbolically once the implementation is present.

  - Ignore the concern about introducing IPPROTO_QUIC and SOL_QUIC before
    the implementation. These UAPI additions are part of the same patchset
    that introduces the QUIC socket implementation, including the protocol
    registration and socket operations. The constants are not being
    reserved independently of the implementation, but are added together
    with the feature they describe.

  - Ignore the concern about the gap between IPPROTO_SMC and IPPROTO_QUIC.
    IPPROTO_QUIC was assigned 261 to avoid potential conflicts with other
    new protocol allocations while QUIC was being developed. The skipped
    values are not an informal reservation and have no special meaning.

  - Ignore the SELinux protocol truncation concern for QUIC. Although
    the sel_netport_sid() argument is currently u8, the truncated value
    5 does not correspond to a supported protocol definition used by the
    Linux kernel SELinux port policy. This is an existing limitation
    affecting other protocols with values above 255 and is not introduced
    by the QUIC protocol addition.

v11:
  - Set maximum line length to 80 characters.
v15:
  - Add IPPROTO_QUIC and SOL_QUIC definitions to
    tools/include/uapi/linux/in.h and
    tools/perf/trace/beauty/include/linux/socket.h.
  - Add IPPROTO_QUIC to inet_protocol_names in include/trace/events/sock.h.
---
 include/linux/socket.h                         | 1 +
 include/trace/events/sock.h                    | 3 ++-
 include/uapi/linux/in.h                        | 2 ++
 tools/include/uapi/linux/in.h                  | 2 ++
 tools/perf/trace/beauty/include/linux/socket.h | 1 +
 5 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/linux/socket.h b/include/linux/socket.h
index b17fdb7d38a7..7677133953ec 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -401,6 +401,7 @@ struct ucred {
 #define SOL_MCTP	285
 #define SOL_SMC		286
 #define SOL_VSOCK	287
+#define SOL_QUIC	288
 
 /* IPX options */
 #define IPX_TYPE	1
diff --git a/include/trace/events/sock.h b/include/trace/events/sock.h
index b5310439536e..ed43fe6d2705 100644
--- a/include/trace/events/sock.h
+++ b/include/trace/events/sock.h
@@ -20,7 +20,8 @@
 #define inet_protocol_names		\
 		EM(IPPROTO_TCP)			\
 		EM(IPPROTO_SCTP)		\
-		EMe(IPPROTO_MPTCP)
+		EM(IPPROTO_MPTCP)		\
+		EMe(IPPROTO_QUIC)
 
 #define tcp_state_names			\
 		EM(TCP_ESTABLISHED)		\
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
diff --git a/tools/include/uapi/linux/in.h b/tools/include/uapi/linux/in.h
index ced0fc3c3aa5..e4072152f2e6 100644
--- a/tools/include/uapi/linux/in.h
+++ b/tools/include/uapi/linux/in.h
@@ -85,6 +85,8 @@ enum {
 #define IPPROTO_RAW		IPPROTO_RAW
   IPPROTO_SMC = 256,		/* Shared Memory Communications		*/
 #define IPPROTO_SMC		IPPROTO_SMC
+  IPPROTO_QUIC = 261,		/* A UDP-Based Multiplexed Secure Transport */
+#define IPPROTO_QUIC		IPPROTO_QUIC
   IPPROTO_MPTCP = 262,		/* Multipath TCP connection		*/
 #define IPPROTO_MPTCP		IPPROTO_MPTCP
   IPPROTO_MAX
diff --git a/tools/perf/trace/beauty/include/linux/socket.h b/tools/perf/trace/beauty/include/linux/socket.h
index b17fdb7d38a7..7677133953ec 100644
--- a/tools/perf/trace/beauty/include/linux/socket.h
+++ b/tools/perf/trace/beauty/include/linux/socket.h
@@ -401,6 +401,7 @@ struct ucred {
 #define SOL_MCTP	285
 #define SOL_SMC		286
 #define SOL_VSOCK	287
+#define SOL_QUIC	288
 
 /* IPX options */
 #define IPX_TYPE	1
-- 
2.47.1

