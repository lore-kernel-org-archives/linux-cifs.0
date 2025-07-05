Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 460402E36E6;
	Sat,  5 Jul 2025 19:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751744329; cv=none; b=be+/TQDWsmeNCPUrZqLI/zg7w/egEVyXEKBEu0P7M9E3N18bnbNtJ6nbsVGFZgnZ1rfJ1a2E2E4ejzVAtyVSFg7O9L2DUHEQMB5/QTnnbbTXy4Xh3b7bZHn+RwL9fEiBHRQ2NjJTqLoqjDu+GcyzHNGwhihJsvSnYsw1oQqHTWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751744329; c=relaxed/simple;
	bh=AXo1SVGHBK9qT4qVLa9ToApVKadhJSI2IuUi88Evw0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U0ZHY5sDVAyXEeEs8poEhQicul498QgrSkXlWkjWM8gWR8431I9OXk+H36tNYUWoVmdDHqNEDYxRNIfgSXA6rNRgbuw8opbM4INcu2FNt9aqKCh+Li6gDiL0bcRsDgOXYysN8nMS+pRb3hiMh59h/XIBI2Fn6NV753sksIhMd38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QU+4vG1c; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QU+4vG1c"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4a58f79d6e9so24238031cf.2;
        Sat, 05 Jul 2025 12:38:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751744327; x=1752349127; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4JTNUO8XZtm3BiSnNgj+nAIXLdP3RxRAv6TMRPMgtSY=;
        b=QU+4vG1cq/8/oarSR0DkZR5OyFfGxfTjfVjX9rwc4fY3IHDOti56FcQQD9hJIEzP3n
         cUGCjHjes+U9eseyrFh8van/pLSURVaAisLMVDmiIxo/xbu1UvzCSlvLg4g/t1UMRjhQ
         IS7cbTSFJ3jsEtRHU4zLnt1pLL4lIn+mTH3TRYzYZbnPBEA89f7hAjMbK5iWf0JJZBNp
         2VzMEgSLzpb3wWH8afHdIGS+Efxe679RvLSvFudvM/cggYfyWIC9yPMSmEZirMKBXCeW
         m4ncHxBuoSSsoClQcH8JGTtDk6bLNhnz7Iq+rT10K/vZhDd2TBX+IClGO9xi+DEFUmFQ
         JREA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751744327; x=1752349127;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4JTNUO8XZtm3BiSnNgj+nAIXLdP3RxRAv6TMRPMgtSY=;
        b=NL4Ntd3P/07PoHyI3Hdta52XbtUGP0WmkKdydPbHaxWJUfyWbi4StQioh+Y1gMv9ea
         bkvx9fly+uLJ1C9uyHj3o/oiZUZrhwoaFgMT2N5GrA+vdwA9d8N7zEtgPGhP0v9K6sTK
         nzc3ynoCNpObvTWBrcmrRFjYDMUvFMx/hKDnlQ36KBZWmnt0YOtqzmzZSWGtPbW5wtEk
         3buPro6NU2dwNBbcmmgCciEUfTHRNQHoOPwqWGUoLrDzFSytmDxUsLjeT+OT4BrVRGj9
         GpAFI8x/rXqnsUwsz7RoIgR3N9KDydzHfaQ+kH/pes8pPi0kPy0pSCScGaHffXc+J3gw
         q/Bg==
X-Forwarded-Encrypted: i=1; AJvYcCWNtohM/276BE9E5gSiop0ve7GdgUcjWaw53Yv0WSKV1qJ08xQG+cLbxiSW0NUq0PO0gzG5Xb4Wmm1Z@vger.kernel.org
X-Gm-Message-State: AOJu0YyczB6T21A2vmjTmnYgBFFH7w7oigujiTtX0KO0FYTNGiPA7lD9
	9hMP8HNOKd4vVoc2Y/Pbq5vNTY+gg+hLgA69kAeEXzMNy0mDn33rOd8VTijzUKmpwrY=
X-Gm-Gg: ASbGncvNTIqBb79o38e+NLmdG4zF4LkL0vLkJQrNjdLgteV1ScFp+aP/iWwhxO8t25D
	VU5glno9C0VtdUEpRtrQiyJurcJaEujB78TxF7Ns6pQE1kYZ1Y0lL4sDJpg0abdZ/gjvV5Fx6DD
	fjlPtYxN3r/EUeS3BGh9OhVwmAmCZEmMl3KHoYNdxs9oRdwcNs8YoatxC4nMKKZbBuSDK0rDaAT
	Eu6xzftupEqe1RNvn5ezhW4N9lDUl1nCcCN1rK6NUA9Xu40uGJwv1fZFC/WFYUfMJ50XKP9jDOX
	vlla3Kr6uxVd5gOkS1LnIEgARTp+x7p5HHFOncuAsvhvQcQVKXZZ0VpotKSvSv6wVs9T9SWx28+
	rRMgYxzj8rg9D5YVyHJmMhHWK3DM=
X-Google-Smtp-Source: AGHT+IEdiBxD8IhSzegliZ7lg0v5y7M1Waev7k/rLUdBJz9W7FEuUWnrco5GH6CjIuAy99BitTUOJQ==
X-Received: by 2002:a05:6214:440b:b0:6fd:75e4:982b with SMTP id 6a1803df08f44-702d16b4f52mr47781956d6.33.1751744326971;
        Sat, 05 Jul 2025 12:38:46 -0700 (PDT)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-702c4d6019csm32999146d6.106.2025.07.05.12.38.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Jul 2025 12:38:46 -0700 (PDT)
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
	Cong Wang <xiyou.wangcong@gmail.com>,
	"D . Wythe" <alibuda@linux.alibaba.com>,
	Jason Baron <jbaron@akamai.com>,
	illiliti <illiliti@protonmail.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Daniel Stenberg <daniel@haxx.se>,
	Andy Gospodarek <andrew.gospodarek@broadcom.com>
Subject: [PATCH net-next 01/15] net: define IPPROTO_QUIC and SOL_QUIC constants
Date: Sat,  5 Jul 2025 15:31:40 -0400
Message-ID: <c845d376a23ac03370dd26f96fc006f6cc8070e8.1751743914.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1751743914.git.lucien.xin@gmail.com>
References: <cover.1751743914.git.lucien.xin@gmail.com>
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

