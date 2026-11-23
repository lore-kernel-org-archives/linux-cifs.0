Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795393802;
	b=OFt60a+wQjdlgLRL3y7vqr2cX/epQ6irntQcYCPHyuOyeOxnRBlGu44Vfq9tugNguyLS
	 1slyfgbqTLaVA1d3scrvy0qdBb5aWicL/8/6Bwd1Ux6E5G+E49fp/4roo4PjjLUiGPyLr
	 7kL1znD4qnNOoLphdxcp36OKiXLlQgaW5LWGuIS6UuMeM8P5Hse0JCWvbnzPBUgIhfV1L
	 9ekVe9U7jo/6nZdiDC35ltglK9ur937HnpQOncGPBo7Sr53mvndxJFKwP8N3urwjOjEiZ
	 mSkHQL8MJDwGdPOHLFT41OcTQbMdMbBBwY/wfuSJwYGmPyIi5olM9POjCXodmblQzZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795393802;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=waKim3nPIl5e0q9cWkwrPM4v5xv0aweoKMihH0crQFQ=;
	b=ISDta1rH0xEsV978new6dvA8Iz7pg0Q9QNDL6rrmifVpWhBG+OQz81QahKEKWjFtmigv
	 W6flSNbUcLA3uo3lNtizNtvPe2rnhRN1Lv+t2b7Gr5itDaDgJJmmOlXviggcmwiL5JlzY
	 BX6Ihe7CfmEKHOwHSOuO7yDc5acFWPn2f7n7LMWd/Fp2qlPBWYUIBgxXuazv4eb0e1LOG
	 8zzWy+oOLvJ5QN2w8rBdukJFKwyGu2AOptOda4kiT9SoDateMt/e/Ee4CvgAa4MhaNCUt
	 rJCYEfOeyxHggb3USQOD8Sz2WOrBsMRLmCT3tR9SQmwnIY8Kva1satnXWDJdfc3Esiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=oDXpp51K;
	arc=none smtp.remote-ip=209.85.222.180
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47416606A32D
	for <linux-cifs@vger.kernel.org>; Mon, 23 Nov 2026 00:30:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 47416606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=oDXpp51K
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-94960131b30so277539085a.0
        for <linux-cifs@vger.kernel.org>; Sun, 22 Nov 2026 16:30:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795393801; x=1795998601; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=waKim3nPIl5e0q9cWkwrPM4v5xv0aweoKMihH0crQFQ=;
        b=oDXpp51KxvNN8qQyGINjwAEBn+3Le4CdEs2wXKXZOxf9AgGr0vPdIFynFFgVhwr93n
         taey9kpMHWGSsg6ovU23kYrW5tDsX33mJOAyhojUDOhcUA9hG0es2Ws4Rry0qA6/zHV6
         FHvbIuIz8ak7uMniPOtzRKsl370kjHG4lwDzk+01HNt8AwTds9KusMsT62BLvkahOJwP
         KTHKG57qGG4Er/VwQO3Zl9RmWiCuXILypr+mT9EvNci8AF7lKp43w7PBCW6qYb/J2XEo
         WQvKGF9soagjHxB3s6WzcDpzmYu2ashuv+I/BpoFKEUR00p3ApFk41/A5hqAPFwrrUSN
         dLEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795393801; x=1795998601;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=waKim3nPIl5e0q9cWkwrPM4v5xv0aweoKMihH0crQFQ=;
        b=DONkeChWNSdot8MM1BMisO97e/wwbg149M3yACbMD6/2bJd2AX+1kqWkvek/ap25lg
         r/cVNNiRtB+o3XkKi/83BYuSB+egPzZ252MazIQegqmtvvQvMxXQbYJdwexQkV1Jm6DD
         PN4IpYCrdgldMRHbjeppKZqI994UTK+7PUGpzemXnLRk/dV9laD8mT7iy7pgbLWEwClF
         IOMQL15s9Q5XPpicT1RN55atue/rNm4NlTU+Aoj/TOyVweZS5wIlqdFfhVbAIgVLvNGD
         /1+Q1xwnrpr+CK8lOt48CzDJIR62fm0gb7RpUrPT6svjDINscPwKXh3iOg+SAJQt0PXs
         sr/w==
X-Forwarded-Encrypted: i=1; AL+hErHduWdU7wonm3HDuWRWZQdz/HLbl6et6JTsEIIboOsjpfihlHcwsDkRjLyIM3LPNvMbHQZLKknLls/R@vger.kernel.org
X-Gm-Message-State: APuU4Z/Xtp5DkC0aL3MqUS6lk6TqlzwBHJkNc4OG2fCWGYnz7j9dHZK4
	Fi0vfcxvF0NskISuiZEoeh0foczInhc7XwSb+CxsWn2qNa0yTcb2Abf1
X-Gm-Gg: AZFdTZdHdZGo9AwFpP4Y9apQXlfQsM3EoU/e8l7Kx9ziZgBDNTaWsPb3t8Fs0gMMEig
	slpVp+ATOgopnTB8T+wSaXVIDhEwtLekFNXR6zKjXZHE3fRxwSlWHbhbTU1TQ1/ZcTrr4GryD0/
	c2ZXKJbp7f7nYp0r6jaXcDoWenuJTEygjEkzJeDgH0GcUbarZabjp9KVBvH2sPPSX9fDeu9OmjP
	dM96JH335UQ3YS8wGl1ZYRh57XEkX/abq8MI3+cOzme+Rt/JEiBcq8Z72+/gPwEK/FbU0tVH44F
	o0bOkx33MsoYfRU0APmJ5nNRfq3ZG1XvZWQ4QwzBBtkFddXYNs2cLKf1EL2Y3ytffPx9sKUz+Iw
	kaLJlcPDtPEWoxc5DvyeBwKkONNUjCcu+EhRHCeeIKNQ/mMVgYxwCmESq06bZVBZuBkh1qLIh8v
	OFCycwMn100Xv4IDKXoZ/z3bwVe8a8Um8oNiB6B9ljSuW3dA8A5g1xMWzhimiqD+iUNbv92/hwS
	cxb9zAgUtYL5sUS71/29gkYya72TUnrvRTS8OwJBRs3FwcOxY4X6QmyvhjXHodL+wiA1SZXI/9l
	yFEQhgqH1YTcWMUTdaHdXgh7s4Fr7gpauXvg03cIdI5H4rcjjDyJB3O0RoI/VmgdVBRvH98PkzG
	Zjvp49jI4WMPN/MFgpYFANTel0IfG7c7hcud7PVUBBMqqmylcOtMsUoWhijF+Lsu0sSM4eIY=
X-Received: by 2002:ac8:59c3:0:b0:55d:3201:308f with SMTP id d75a77b69052e-55d768a4864mr185506171cf.9.1795393801238;
        Sun, 22 Nov 2026 16:30:01 -0800 (PST)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-921349d0f6bsm91433716d6.21.2026.11.22.16.29.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2026 16:30:00 -0800 (PST)
From: Xin Long <lucien.xin@gmail.com>
To: network dev <netdev@vger.kernel.org>,
	quic@lists.linux.dev
Cc: davem@davemloft.net,
	kuba@kernel.org,
	Eric Dumazet <edumazet@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Stefan Metzmacher <metze@samba.org>,
	Moritz Buhl <mbuhl@openbsd.org>,
	Tyler Fanelli <tfanelli@redhat.com>,
	Pengtao He <hepengtao@xiaomi.com>,
	Thomas Dreibholz <dreibh@simula.no>,
	Jamie Bainbridge <jamie.bainbridge@gmail.com>,
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
Subject: [PATCH net-next v19 01/15] net: define IPPROTO_QUIC and SOL_QUIC constants
Date: Sun, 22 Nov 2026 19:27:57 -0500
Message-ID: <ba1d4f03926411d4e61a7587e41a12b0b423d841.1795393691.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1795393690.git.lucien.xin@gmail.com>
References: <cover.1795393690.git.lucien.xin@gmail.com>
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
index 37ddcdfc0377..b8569b5bc060 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -402,6 +402,7 @@ struct ucred {
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

