Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 631872836BE
	for <linux-cifs@vger.kernel.org>; Sun,  7 Jun 2026 18:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780855427; cv=none; b=TClSAzQJBf9IQLwwBekEKVXExy1Ayj4lEuLPcmkoWq6DcpyaPSaY8cMwo1kRviLdOWVR7AEBveD+t83YkJCd0DLXZiuCyeEq+ErHp1hTrzNYekkzW6QzrkxxglBQ26VoWAo5KX0Xy0PtoF82VYe2unSUgvHxl370TnVR1fCzrn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780855427; c=relaxed/simple;
	bh=Oq9uMBA7F1231B6O729WkmXV78Ehl8cbE8bTwDhokAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d88qAVkPQHxxlRS3XcQfMCh/enYYQ09nWm4rnUE7Ik9hsc5thvDiyIFMm2XQ71tPAGlvSVv++RJ3OwEkKHgvkVQZfUbIZDH2ZupORTm2XVYc31/sCd0NR8JopMcDYfAxj6tKd4TTiVr+iJYdsQ4zlpMv2dZp8BfUH2vSYwkU5o4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f3MEM2CG; arc=none smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f3MEM2CG"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-8cceaacd07bso40584936d6.3
        for <linux-cifs@vger.kernel.org>; Sun, 07 Jun 2026 11:03:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780855425; x=1781460225; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=36vd5FRxf1iF0JtG6WtjCmp2BwAM71UYEOie/h60d3k=;
        b=f3MEM2CGUp7ob3mOFbo4SLwHPUyRNi+cZ9PSqVtwmiMU6cP53MZ9QVAfnb4VE/OKUM
         mxMCxS0C91t6UG8j+ivrcU0QeaehJ1jMKTk+jS45Az0l8IHbe9h8WB7PGGmVLi4jCkqc
         4FpugGC94Ixi+Smb9dRoSG4J3o5Y7zC+LJf5wYVr3HMmfq12biVMX0wGPP6/qmbaQiXP
         vPYpjs3BciOg2CVsVL96CIhuKBwbYQQLwLRI/C0AJfwwr6LoZJHdDPFsA+i7uC/rZuWV
         /AlsA/DRSzUtNdiuDR69FazW9FASw+6QOD4s5N7iiujleLPc4+7uvsvEjQxr695+dHjy
         AjGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780855425; x=1781460225;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=36vd5FRxf1iF0JtG6WtjCmp2BwAM71UYEOie/h60d3k=;
        b=qMYEbTLdisE8PyIjT38GzTuv8bIjkWeDZsCxqplfwyKbpyaW3NHbzecgMdEsFqIdrm
         NdO2aDtAE4Erw2vxSduqQ7rSaz9OVF2xthQzj102zUwJh2rA6HWDi7rWUEWovwdR08Ld
         cLSGWNVb1EgFlhHrbbS0h27kkd0yisARfqVtQs2LhD/W+XC5AywDQAlAYpH7Sa6qLf3r
         xIBPjc17beYln2yeHe6Unhwrde4ukA1Vr9PN8GOLe1rerBO7M4Ii61/8Uyi1ClG4ryJJ
         jMTH4uRRaOSOfU619dttPhkrn9WvmSdVZFs8eeAVaNUdiy/DffFH0D5lSWbnMZ5C8UjM
         V2iw==
X-Forwarded-Encrypted: i=1; AFNElJ9sk0Te/JHkt4OMg+mmQwYzvKWFDV6ZehyXBgL2scA0InilBVHeYV3yUlaj//QISWHsAk4UsKyKc772@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0/CjigMWoiksnPNMOb+vYBqfvKwI67sN34JunFIvSH03xlNOW
	yWH3sih/8eBZekON9asf2QTcB+tRvVz91z7Sg1kl1Waim1W7Nd4UutRn
X-Gm-Gg: Acq92OGAHMp+Amm4Wx/Rs4Sheh3reiOiwxa5ZuBpBDdIz/KzXW2GI+Nvvr413EsjdoM
	6fbSOBo0S1Ett7YKW7nl5Dn94cprKXIgxDlxn7BA5C0Aluv/JKXVLMVCtq5pfzWEV9VNQlxjToi
	fAY+ZaLO917uOBMd8gyRv137LhAI3X3ePAaVSes3YiCUMC1o5C0jGKoIpNOZz/hmplDBbDlHwu2
	ISXDTaTsbhaaEbak1pfNBl8VlsH5i8u4WeYVO8JTbdqmdSsXP1aPAoPXqBeGcaMxZr+FjK0dNOt
	YkNteE1W3OFRyKp7RasdueoL3UYr9tcwrqpE/91NEzLyHTfx15vq6FjFEtBIZgq3OpDgyu3OHI6
	7kl4rC4PaPMrM0+m8XZkkNlJr2a1jg0wMFb2w0d1bou8uO7xIpACflTCCPwVjywiDT3cAapI+U3
	Umt+9geENvXHjz8Wmf9uzGc1fguxIy1kIKOuWm7Zhm6YCnoUgDg9zz1pj7Hx0Lrp8/Avolz9bh/
	pOePvVZUg9AjZck8+ZaDxcpJN4I2n+7B/Z0n5YrF0msDF/vEbfWBtWwEG19ZAX3A7VoLxGKicKk
X-Received: by 2002:a05:620a:2910:b0:915:8594:68dc with SMTP id af79cd13be357-915a9e05dbbmr1997918785a.55.1780855425365;
        Sun, 07 Jun 2026 11:03:45 -0700 (PDT)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9158a2359ecsm1489771785a.14.2026.06.07.11.03.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jun 2026 11:03:44 -0700 (PDT)
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
Subject: [PATCH net-next v13 01/15] net: define IPPROTO_QUIC and SOL_QUIC constants
Date: Sun,  7 Jun 2026 14:01:23 -0400
Message-ID: <686819eebb82be0eed7beea4f468284288c37536.1780855296.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1780855296.git.lucien.xin@gmail.com>
References: <cover.1780855296.git.lucien.xin@gmail.com>
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
index 1a4d0d128a13..77bcab269b3c 100644
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

