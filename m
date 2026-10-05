Received: from mail-qk2-f43.google.com (mail-qk2-f43.google.com [74.125.230.235])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88520372661
	for <linux-cifs@vger.kernel.org>; Mon,  5 Oct 2026 19:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.235
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791227128; cv=none; b=JRJfEnLZDH822FTAM/sDaYLeCAxszbKlZ5dICw+u+j5GNs62LZFDMTl8O9C9pRgn419yhFG42FgJSd1rZGwN62L18qom/2FVmpmZ5ENeu8KVXZCnUcJjOuIqn65GuiT+vJgwHKltTLlGXTFrFv+F1bc4FCInBkLhVsWWxA3HWIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791227128; c=relaxed/simple;
	bh=175nGo8AlzGi7Kq4YgHmF57Bf3sUbWDZgesKoC1sABY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=La6Zj4Wdjgz6PHOH2bOg8t3VrGwyCzld64pih1fDVEpLqx4QP01CZGaJKxaKMezEbWC6KsmfPkXzaShoaE5tfcerQxIdSM3gxvQqPyO2hew8nRlkpi0aV94jHldMoVMBIPNVzxlfnBUtgJ3tSP44ugnZZcgmo23s0b9PJWofrkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fbuFtdKA; arc=none smtp.client-ip=74.125.230.235
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fbuFtdKA"
Received: by mail-qk2-f43.google.com with SMTP id af79cd13be357-93ca50c8ba6so252823185a.2
        for <linux-cifs@vger.kernel.org>; Mon, 05 Oct 2026 12:05:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791227124; x=1791831924; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zPHnIYBbCayxMoJCPrlDTfFp1FR5Ql/EZ+xFQdJmHw8=;
        b=fbuFtdKAeqNY0h575UzhsupNCB4BrqvgHAEyXKGdGOpYEUhweC+RWF2w4S5vEIcoKh
         PEA+RgtH/o/+3YDOTcB6AV/+NR+QU3DOqnRbWYFXnTgXo69/KJOjsy8weuv84S1uoc9s
         zvr3CPsW6bpPml7PzEip7sl/JBuEbZF6gGGUB4nkUVFOcV5gs1PNPr1k7++ZndZBqUwH
         EfRpdkgE0bw5RslXxcsgavA9PhHQdHAxGBU3LvFMHIjsXd62cvSNsrTpsmjdgrOMXP+z
         rxRIA5KfIfXzLPoc0yxY74hDJAAZHnarf56KXgvpg1I/BeUZWmnOMpxphFdv4IVN0jJE
         4swQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791227124; x=1791831924;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zPHnIYBbCayxMoJCPrlDTfFp1FR5Ql/EZ+xFQdJmHw8=;
        b=H2e1Ys4coBDJEjjkbuX7WmgiJ5zOqsF/9X95Cw+2Ne/6hVKyz4OU+lpqNc6CSzB5ZV
         9YC8cxRm6XI/9Shy8JPWpL96pV7eXPcgOR/Y3Q4WJtsl5iXSepSxqwUqM9yH0ad4odJu
         3oWNLnyzWUrCW/QEFw++IXFZ+fnnZXhxgtuq8XJNQrM0SvXyePyxv0AGZMVwuvvbotqW
         sSdj5T1VBMb9iR4IWop6nGg5KgkGLvFtK0M/66tRp3afhjFS9xx+FONCZdbBNTcSQDMN
         YZjl3WT3Fx2iajE+UCP+dGy7ETAwpSKSOZ20NQdATEXTgln0o+zSQL+W7RjP6luMCEsr
         d8Pw==
X-Forwarded-Encrypted: i=1; AKwUvBxf/rlw7OgLc6j7PFDKWrtdDIw+trk5y73NwMkv5qlaz1cpq3TDcpMY8vzCrwN6jlvcHEuviJP/sSGL@vger.kernel.org
X-Gm-Message-State: AFuF++nHI3TN+Oc5N2GrWVRy4gtqJITQmudNhzTeOoAzt/chRs7rhtLS
	NbmumxtxIRjXwxjwCoJJkPXurez+xFglAOFIN3V67xEW/Q8a8p3q45vw
X-Gm-Gg: AYBFou0T+BUbfWJYE130e67CjpXmZW6jD4KaddHrOV1mLpCEzOYLHRixqFoow9Q0WHD
	+w2qdcWAuaEP5fFJQTUHObBiSqxSo6Fp0dx4YzcXX4J2ZdQPsN/fAgB2qJdz2ZRL+6xJQaKGjP9
	leSPjzjTb0OXlypmOjU19mKcOeU6aj9mzmJBNRz2PBkVDDqQ9eVOFEl+pMqwFsIoNcHYhrSEZtT
	c8IIC9SxX5WNQInq12geE+iRpA4PLpRLj5FQqFIElMMqHXFnlKR2ebfKPZmY6SQuZvqZvDTc7YH
	pl9rQUuA92wshzhqh/KM1wi/KBreF1Usc9iNBCerhf4IPggUe+/p7nPMvYhM6clSJc7RJzpntlJ
	TT9vTyJKUnjeIp/HbPvjgOpvNvwfvCwYis0B+tkwrg5FrRKva3lQl+sT8UGOy97KNkdu1aTYFx7
	9mJzhrXhKHYLDbgRsUUVBydSO0DHQCHvWLGDF5rSjgOImB/LcFDJjFkZvIYOHzWTeNydcnFIEyn
	/oQOH97IkxiGhNOrK4NqeWVAyiSZxLbfufXrC6DWiDHDCJst/nA/oun1QrPDx+aO1frwomukOWN
	PukKp4x/z7Y2IVfppwSfzC4O4o/qrlSWfQxReJAzMT20cE7/
X-Received: by 2002:a05:620a:7087:b0:93a:2e8:5af5 with SMTP id af79cd13be357-93ce7a80f36mr2181764485a.6.1791227124283;
        Mon, 05 Oct 2026 12:05:24 -0700 (PDT)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93cca263708sm927117785a.31.2026.10.05.12.05.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2026 12:05:23 -0700 (PDT)
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
	paul@jakma.org,
	Kuniyuki Iwashima <kuniyu@google.com>
Subject: [PATCH net-next v16 01/15] net: define IPPROTO_QUIC and SOL_QUIC constants
Date: Mon,  5 Oct 2026 15:03:56 -0400
Message-ID: <dc4b829cd94b7f6a0834ea43e35141884f9e409c.1791227050.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1791227050.git.lucien.xin@gmail.com>
References: <cover.1791227050.git.lucien.xin@gmail.com>
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
index 5a5eb1250103..aeea3baa9673 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -400,6 +400,7 @@ struct ucred {
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
index 2a8d7b14f1d1..9d6ec1b2c50b 100644
--- a/tools/perf/trace/beauty/include/linux/socket.h
+++ b/tools/perf/trace/beauty/include/linux/socket.h
@@ -400,6 +400,7 @@ struct ucred {
 #define SOL_MCTP	285
 #define SOL_SMC		286
 #define SOL_VSOCK	287
+#define SOL_QUIC	288
 
 /* IPX options */
 #define IPX_TYPE	1
-- 
2.47.1

