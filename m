Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDE403126C4;
	Tue,  7 Apr 2026 14:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775573264; cv=none; b=Cz4pk71yOJTqoTuxgwyUhFDrkswrfXhm/fTyRZ4IeBGJF8IVRoOcbgElo1gGyKSZgi14JreAoPL94S2qzSEIbj7GyPCB5qE4rr55qxZVu7XCkFeEurm4/NAa7I9vTDxf5SlZW2V9Ziqn/S7kjVLxztkFRIe7p18ZABXf7/jV51c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775573264; c=relaxed/simple;
	bh=LEkhz9RNk6tC5NYe6F1u2WXpjMlteUXxksP1aHu2o4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rMAQ/2vqISESc4uuI6kFc7CsSTGNh9PaZvKKzPnb+j1zEKMIC2PYtAPCyBhU/fldaa53uyqFG5sjW8gNvOurMHlUrwSCyWaD+H9C1DuU2rXiEOdqIz3KfqsPwMQJOnQzAJXB+vm1/MlmnBUy5+RcyyRWHmOb0+3b78ezWUHWIJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=uEzIW+wb; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="uEzIW+wb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=9bs+E70xzu5LpaFuUzNo/5yPnyZdKVdBaQo2fRz47yM=; b=uEzIW+wbkTBxfbOC2ciOptE7dO
	+g3IMOMNJ5GDsssalXpuq63yKaVv1S8YOH3AJ9yegOkYm3UmPXECFc9EaKYxyky+JAao7vsChSJx+
	xVgrMxW9vcT/t7NLxE8ZyWDd3Ox40W+N+q0y+CZkg7QUlC7cf/1TbxaSfyyaZc+zOsE/XTijN8o/N
	tiichYGtpziwETQu6ouyEXtgSLNvX61j4qpC/LL0EODtzUG3Q15jBrJJY/WCNvgcMFKwQUe9VJM3T
	Qzlbk9vJyONZbww7JRyJqp4YffIewObgcNWgI83buD6dyzUgH9xgV5+8TgndYbDtpX+qJueezmzyY
	oIoRmwvolOV9nKcEBYlhev4X1G6oIeDgDV+jCueSe4x54zQPwGQ7rPjAdUcNfiJ7DOHgak45ZQMty
	b+CRxcHiHopXsYaPlurKPNZuT3bAJaPJZwPwnYQs+Isy6h10Lpom6HEz+efVxPAMPh4DTnuAIhLxo
	8cwKxDDHQk/lRNGcviNpF9fH;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1wA7iH-00000007WPz-3q2b;
	Tue, 07 Apr 2026 14:47:34 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Willem de Bruijn <willemb@google.com>,
	netdev@vger.kernel.org,
	Xin Long <lucien.xin@gmail.com>,
	quic@lists.linux.dev,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 5/8] net: define IPPROTO_SMBDIRECT and SOL_SMBDIRECT constants
Date: Tue,  7 Apr 2026 16:46:31 +0200
Message-ID: <af3d81da716943128dc98b5aefd44d1aa52c1094.1775571957.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1775571957.git.metze@samba.org>
References: <cover.1775571957.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch adds IPPROTO_SMBDIRECT and SOL_SMBDIRECT constants to the
networking subsystem. These definitions are essential for applications
to set socket options and protocol identifiers related to the SMBDIRECT
protocol, defined in [MS-SMBD] by Microsoft. It is used as wrapper
around RDMA in order to provide a transport for SMB3, but Microsoft also
uses it as transport for other protocols.

SMBDIRECT works over Infiniband, RoCE and iWarp.
RoCEv2 is based on IP/UDP and iWarp is based on IP/TCP,
so these use IP addresses natively.
Infiniband and RoCEv1 require IPOIB in order to be used for
SMBDIRECT.

So instead of adding a PF_SMBDIRECT, which would only use AF_INET[6],
we use IPPROTO_SMBDIRECT instead, this uses a number not
allocated from IANA, as it would not appear in an IP header.

This is similar to IPPROTO_SMC, IPPROTO_MPTCP and IPPROTO_QUIC,
which are linux specific values for the socket() syscall.

  socket(AF_INET, SOCK_STREAM, IPPROTO_SMBDIRECT);
  socket(AF_INET6, SOCK_STREAM, IPPROTO_SMBDIRECT);

This will allow the existing smbdirect code used by
cifs.ko and ksmbd.ko to be moved behind the socket layer,
so that there's less special handling. Only sock_sendmsg()
sock_recvmsg() are used, so that the main stream handling
is done all the same for tcp, smbdirect and later also quic.

The special RDMA read/write handling will be via direct
function calls as they are currently done for the in kernel
consumers.

As a start __sock_create(kern=0)/sk->sk_kern_sock == 0 will
still cause a -EPROTONOSUPPORT. So only in kernel consumers
will be supported for now.

Once I have developed a stable interface for the RDMA read/write
handling using sendmsg/recvmsg with MSG_OOB and msg_control,
it will also exposed to userspace in order to allow Samba to
use it.

As the numbers of IPPROTO_QUIC (261) and SOL_QUIC (288) [1]
are already used in various (released) userspace applications,
I used 289 for SOL_SMBDIRECT instead of 288.

[1]
https://lore.kernel.org/quic/0cb58f6fcf35ac988660e42704dae9960744a0a7.1763994509.git.lucien.xin@gmail.com/T/#u

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Cc: David S. Miller <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Simon Horman <horms@kernel.org>
Cc: Kuniyuki Iwashima <kuniyu@google.com>
Cc: Willem de Bruijn <willemb@google.com>
Cc: netdev@vger.kernel.org
Cc: Xin Long <lucien.xin@gmail.com>
Cc: quic@lists.linux.dev
Cc: linux-rdma@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 include/linux/socket.h  | 2 ++
 include/uapi/linux/in.h | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/include/linux/socket.h b/include/linux/socket.h
index ec715ad4bf25..e00cbfdaa8d6 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -401,6 +401,8 @@ struct ucred {
 #define SOL_MCTP	285
 #define SOL_SMC		286
 #define SOL_VSOCK	287
+/* 288 reserved for SOL_QUIC */
+#define SOL_SMBDIRECT	289
 
 /* IPX options */
 #define IPX_TYPE	1
diff --git a/include/uapi/linux/in.h b/include/uapi/linux/in.h
index ced0fc3c3aa5..933d243b1780 100644
--- a/include/uapi/linux/in.h
+++ b/include/uapi/linux/in.h
@@ -85,6 +85,8 @@ enum {
 #define IPPROTO_RAW		IPPROTO_RAW
   IPPROTO_SMC = 256,		/* Shared Memory Communications		*/
 #define IPPROTO_SMC		IPPROTO_SMC
+  IPPROTO_SMBDIRECT = 257,	/* RDMA based transport (mostly used by SMB3) */
+#define IPPROTO_SMBDIRECT	IPPROTO_SMBDIRECT
   IPPROTO_MPTCP = 262,		/* Multipath TCP connection		*/
 #define IPPROTO_MPTCP		IPPROTO_MPTCP
   IPPROTO_MAX
-- 
2.43.0

