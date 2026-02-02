Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2E7536C596
	for <linux-cifs@vger.kernel.org>; Mon,  2 Feb 2026 14:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770042595; cv=none; b=GFbAckbfsd+zSMZ6fkHpxZv63ZgZPzg7hVgVAYgdhrbJgKcZk5tiYpABAEyeBhWhqKOJkLNsIKY7NcqZosYMJzMz/HHIgv+/W/BEvktzn7lkgp8oKP5mmNmD8rwLbbs3EvZDwyNaimRSRdnU3CIu4/0AgUd9xY1/VMgFP5/u224=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770042595; c=relaxed/simple;
	bh=EmdrmrQatIkWYrWc3Tso6zV2W4IPfCbeSJjTG87cs5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bNwKHkuVqWxlya5V/FSH9T92vqLUoRUbCJWPLd1YNROcRSq8hwVJtHC9h6pZqHFxXK0OL6k2L29r2uQRdxLGiOkMMLOdQq6H4eFopuAr9t5w8oLReHm0J7ojYAE75g9utg0QDZEcef+Wt6sGUSor5SDhaLz6SDWH5EJSOUuj+Vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XAa/Rnxu; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XAa/Rnxu"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-501488a12cbso55178141cf.3
        for <linux-cifs@vger.kernel.org>; Mon, 02 Feb 2026 06:29:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770042593; x=1770647393; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0XFWhnozczQdBY9wOF6c5V46t5MOgQ+lGzwQjjTNU9A=;
        b=XAa/Rnxud4FgrJ2tug3uvaSccjsKXHQCDQ3L/FdW++C2FV/jwmFBX7zwBYdSGh7d31
         RDESBc5jX47/lEzObyowh4x+qP9J79h3cDtuznoUUWPvpESSirgUlULMux2HsTS7AeHw
         iyPZ35htKVo1SDHWY7pA318EReM6WJ77643E0UwowHzRc4b+26QhixZibiWN+kVAm6rg
         WDNCSg9rgIpvNHhyUwJFdxWeA+KTtD8xc6QoBFoo9NlTzCorwQiiuNLJ7qwKEk1khc2D
         OLdQx/ixz9DtbCYuGcA2auXdbg6Lkk06aLfv5GjNmjdX+QA9THLLEzkKxwFcFgXcIBtc
         Wo7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770042593; x=1770647393;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0XFWhnozczQdBY9wOF6c5V46t5MOgQ+lGzwQjjTNU9A=;
        b=DnAcBCoezh3Ug/ZF1owk9qLsbLMYyuxTQU9zO/W3BK1Ya3/R6xJdywdD7lTT2xftpm
         iVL8AsVaL95H9xztjgJy7C5k5UJIAjHOHlUey/u92PLx8iD+OoYwipEsq/AH33uFlfxL
         CrBgQodeTJkWXAfqP7TjUgGdKYngm1MChmHYbmIAuGBrb75F4fyBVW0i1E2IZBfxTX0+
         m/UqHDVUf9iH052BMihNWbgddAOv7r/MdGEAzwX3R8ZDGoeBLSqj1OuR4zHhFOfz7wmZ
         0lMv9Bgv96xfbXy2guDANIPulL+iXmVmX6CX1NR+BN3KbbpQW0geV8QSX0yHn/okBwrL
         nqjA==
X-Forwarded-Encrypted: i=1; AJvYcCUVvXqcic7QNlnzI/yYSgxqOcgzMoXhhxlyQITJu+qd0z6FJ4eypiPsUhAkDoa58uLb7ryEbfloku3D@vger.kernel.org
X-Gm-Message-State: AOJu0YxC6tzLVyrak3klQJW6NaLcWriQ1Rno5jz8SNQUpzJ9gIAn3bMl
	k55e96raOjIvQaWN2yGibHAZSJgOpRK8bdwvWzXBJIRIBBve8mZQsIhL
X-Gm-Gg: AZuq6aKE2h/ZoTgQvN8oTTqrobid34Fe5jvrZTTOIccqjM6llPqiTJIwHXLVHCqidd0
	PGvpbpsIvBz/M0J48WUrmF8KlbWt4mZzJGHomdOTOLyUVXA6BOsFziLXX87+DvWcXbH0SxGbWio
	kNcf9Iw+H6BmbJHlawAbj0tilmN0wPaQ4tEXAUlQ5K0xPlR+Z4pCildGShgURsgdByBhPQmBvjh
	/iw/lSDYDBxAKhHU4iUOVh7YRLIlcSV71VQihYt14v9B690fsaOYO4qDZJkV/C3maQO/BQyDFMx
	bd+eE56/oBivdoCHW66dZECc9DW4MSUcaVr74ne0+5BD0JB3+iAb5nlmy6qR1zWu6rmt2agkmJN
	aunadaKH/piQTTvr0mQ1kAlehZZrMxlg5BkeT0mPB1RRgKiNT+opvfUHp/7ahrMY9SKvDdaxtBI
	RLa0QHE6uQHvRX5N0vUIz9eEdQMB+wIG9iN1kbcYjAhoMxZ/bIQ8c=
X-Received: by 2002:a05:622a:110f:b0:4dd:ca89:8d7d with SMTP id d75a77b69052e-505d2288fd0mr169731871cf.56.1770042592748;
        Mon, 02 Feb 2026 06:29:52 -0800 (PST)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50337ba3981sm106865171cf.16.2026.02.02.06.29.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Feb 2026 06:29:52 -0800 (PST)
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
Subject: [PATCH net-next v9 01/15] net: define IPPROTO_QUIC and SOL_QUIC constants
Date: Mon,  2 Feb 2026 09:27:27 -0500
Message-ID: <d774ce5dc1fdb45b2d68b63fed3975da91c1729f.1770042461.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1770042461.git.lucien.xin@gmail.com>
References: <cover.1770042461.git.lucien.xin@gmail.com>
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

