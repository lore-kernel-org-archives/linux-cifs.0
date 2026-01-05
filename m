Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA7B19E968
	for <linux-cifs@vger.kernel.org>; Mon,  5 Jan 2026 14:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767622096; cv=none; b=RvzezbkAqVvxG8K6kzrF7Fbyw5PnbzmjEMAKc88S1Xmmd3MuaKoNMDYrkd5GViUzWncej/UgJSS83irt3qL5LUcGd2Npq+LSLaXd32j3S35nEyu51dHuW3GL6AZvokCvIF+OOwDvwsurfhPi1RbFcDudkx0rjSnydXyfZ1nn2S8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767622096; c=relaxed/simple;
	bh=zEN3doId9UKmo1rLmAoDue2BHiaeEn8l3OYvCK/ydP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YkjxwlhsdCGZqz0QEZc1ugpVsGYvqtUMni4adSFwGqxuplHYou1vy0cx7CIUL7xpJKBNQQCkCpLUiSQxaB/k7smTndcBWnZogblq0Umsr0vHos41OfYPsjofGVUCzploomEuDksJWAM3HlIW/4+cW/RfIVw21vOQjE5InK5pFUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nbs62fZj; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nbs62fZj"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4f1ab2ea5c1so206480671cf.3
        for <linux-cifs@vger.kernel.org>; Mon, 05 Jan 2026 06:08:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767622092; x=1768226892; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d+6m+RaUAFXaTtrp8udufW/i4uBYkmLcVK6S66Yx8m8=;
        b=nbs62fZjoNNrnkNazI/VlOlZH5Z+0L64lVOdlicBv7qhRDSd3uzriUmI2d7AT6j8VZ
         3/0/2pZA9VeJZm7KLlZ5mL+a9XrnWjWkFPJrazCxkABXJ2giG1tQs8AZRZU+AtOgJ6RQ
         d4eCiJYHq30rr9/Mrt/RQcthrJsqocutb3vP63OxOR/s1dztkk7rNcUYlevVKhUFoAda
         JqB2MFTpqwwowx26y5ulIV9bidzOqZTuOgW3f9hXeCtvcJ50JhU+FV8zr/yFMEz/t9wP
         dLqhUmjzVcLUnZU5Hr6XHlffbzD5Xnee4+Z2AbWovpW/NfoOp7/6lXSQdVTJH/8WtVvg
         NfEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767622092; x=1768226892;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=d+6m+RaUAFXaTtrp8udufW/i4uBYkmLcVK6S66Yx8m8=;
        b=MSAunHspKi2JfTEofbthxAHfpJEOPNeBLN7W+VPpUm4egn8CYRnlgHAS9qVcGENJFB
         v/axQH0vB6ruCClyTXmfkoMnQfPCAEZV5H9cLrdJPopxGe9Vdtmr+fjiuHWLAH/DvJuH
         rmsL6YMRfkglb/8oRrdC0TXTa9SduGVTriLdwmksWFn5FiL4Ye4wcnJMpTm/D167/bHK
         VuVJCNdVRRTq+t9ihZtXAv39YbUbl5Pes1u+kN5dXUSS53uTfXYRJouyBo+I8UaoV3q7
         IV5IvPV42fCpRHU9tIGyw88VnBhC7uFwSAqLnMSn1uYn56I6CZGQIiyFso6aA+JRTI8s
         BXgg==
X-Forwarded-Encrypted: i=1; AJvYcCV0TgGZjy7ic34rkY0Ypz4T84n+LSPJAlZX8jdsZg1wOFGrPWVd2OsXZEYHcehl8tD/ZjNzIAXUmL2a@vger.kernel.org
X-Gm-Message-State: AOJu0YwW1eggWY6DSRMKvYpeImDHRADBseXe1gIkXBOO2MveEd3C2Unl
	R6kT9gpnRmOETZNdquEzm/JhJd9PGG3hHGk5xHHBj9tAN5FbV80+Y0P1
X-Gm-Gg: AY/fxX4xibkw1kk+8DSJb9KODShUZYKLoS8rQFcnvCVmU9JUqxuUgb6NyZR/rzUUBfP
	ILQHTP28oERG2E9JZBb9etTfsDPjeOQ3ptzdXw1KApWNklu+5CBTWZhgNf05M626Rhj0TAtoh4M
	Hkwllt1Qh908yph/ka24JhMPqpnPyfeTcKrGCervL+3gCQxAxpMJdJ1ljSViliKPBCO+nnm3F7j
	3zPfvG2oY3JG7A/FqGMsI0+79UwQANLuZlcHwbqbHO1/q1YGoLnzg/KPhpyZ74wKZDgdK9RRkMs
	fVh43xM+8QS7IQ8LDnWh93vNRKBNK7C8Zxm235G7wLiybrUpXuTp3Z17MKdpZSvfjQ9CBQhEGzI
	sOopp+6fjQPsaN77Y1BDwPAIyFb476E+CnBXEKp2rtBw33pqzRqvrLi9iFF0jQktRehy07JLCtp
	6EmssTM5r+hxcXyT6QnwwIwcboqlZiDbyDJLz50drjJ/KFYCNWoIc=
X-Google-Smtp-Source: AGHT+IEHuRM2+t5qnRSVI0kl/We7szrHGppbL3OLinZ2JFHLaZJDDk0NxAF77vZNPlpHu38oz5oaFA==
X-Received: by 2002:ac8:5914:0:b0:4f1:b9ec:f6a4 with SMTP id d75a77b69052e-4f4abceebf3mr885961071cf.33.1767622091533;
        Mon, 05 Jan 2026 06:08:11 -0800 (PST)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4f4ac64a47esm368957221cf.24.2026.01.05.06.08.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 06:08:10 -0800 (PST)
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
Subject: [PATCH net-next v6 01/16] net: define IPPROTO_QUIC and SOL_QUIC constants
Date: Mon,  5 Jan 2026 09:04:27 -0500
Message-ID: <d04504f267ed7dbc7075b96e0da08feb3c301d8a.1767621882.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1767621882.git.lucien.xin@gmail.com>
References: <cover.1767621882.git.lucien.xin@gmail.com>
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
index 944027f9765e..b4563ffe552b 100644
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

