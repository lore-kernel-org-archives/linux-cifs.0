Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 791063AE6E9
	for <linux-cifs@vger.kernel.org>; Thu, 15 Jan 2026 15:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768490100; cv=none; b=d593fNueWI/VAkF992Nek0bGD01wIVLylQLhZblNEMTB2fTEf/kJVkRz9W9x9D4G6IMOwIp73dev5nrrPHR+SWRA9GfS+LeApvpG6BMS4binMfUXEki+02YkiEFtMyNimFObWbhUT6y9mivpypC3qB+D8dwZfFSkVVY3teSHbvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768490100; c=relaxed/simple;
	bh=EmdrmrQatIkWYrWc3Tso6zV2W4IPfCbeSJjTG87cs5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eMrkOUxfmHgy4OqUwmrtOaPFNbgdMPCk+RZitubJssL8AX8sufBqeFDaBiq0wdrOLY5jEp0mNK7ZhJBOaRKI5hOcZXA2bmVClAjG0NTYJ66VtauxP6GwcHZapIth2dI0eKRqcYKWTNdM3JkLTIkkQKsJclI8ny3wvEyQf0VKSk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BBoWYs2h; arc=none smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BBoWYs2h"
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-88a2ad13c24so8877266d6.1
        for <linux-cifs@vger.kernel.org>; Thu, 15 Jan 2026 07:14:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768490082; x=1769094882; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0XFWhnozczQdBY9wOF6c5V46t5MOgQ+lGzwQjjTNU9A=;
        b=BBoWYs2hHEOUT6FyQjNm4QI4AIsE5LVnSjCdAXGzD8YvxFZFVkmNnZ/xT+kOqH9z9n
         MsS0ahH62YfoiSIgriBzvWEtmB0vo1PFHlAQaWDKzDQozcfFRBGQPCzgeVp2zriI4SF+
         HSkE5uvCSjP5HpZSpOd9cV2mCgwhWbSBQ+XC/+IkuSOXzCOpnJbdWkCNWZCj83U9vHUb
         EedyEpXj6Yzy3T3UO6UlPh3YkHcXzBbp2NhWIqLAUSVXL/hWhbPxF9E1stM0L5orYWZr
         /e6nXGYWsGtNa3CHB9TWKFhuwduoGbfX/lrDglH4XwW7mTHSj/Tz6TBHT7cYBCtNglZg
         F2Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768490082; x=1769094882;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0XFWhnozczQdBY9wOF6c5V46t5MOgQ+lGzwQjjTNU9A=;
        b=HENS9FeCx3z7z96fipK+sgjnpigCC4kJPNXFwlJVrE47AeK9qq0yJF6ZI3ES41P+uw
         G9u7vpTaCOTyeQG7YWb5vFQpSOSpVMI8A66vYhMXogcmM7eNW78eXxUy6geCalDv6xOx
         6E4VNg6vbCccaTvuqtT3xKGIBKCstHQ/EguItouMIyy3H4x48CD6O093oll8Af2LjxK/
         IlogUHSwkKeWTZRnim9xQeIJ7R34F4NjUZX2hxknFuD6gqmgADU1bvO0fXMjbxafwa2d
         fT+8GoAPuxvEOxMgJnUxHQ8JkZh8jYx1vXZnn9EDL48QcAA3O8ektNnRXVpMVj+ZjGH6
         b12g==
X-Forwarded-Encrypted: i=1; AJvYcCUPiyyaBZnXXsqzZCGbFNIEBR6BDJBX24LwstPd3UQ3v2tnWWMh0r2sQrNDFdbPC3HEdwkJhuz41m+Q@vger.kernel.org
X-Gm-Message-State: AOJu0YzviORwp8erIq658/WQy0tBBqkpIKFxV0sjWHz8WE8+VezBstRU
	lKv2bhOCZjg0QRWsN6tylrWPyw+Cx29GAkFwfmgqczvXlv7fE+kVxqvF
X-Gm-Gg: AY/fxX4+npbemdWK+gGcrG1cwh4yukeqDrl+lXvrJD+rPHRX6/FBMSaLp7N5RV1WxYU
	yjiBu2wl1WVn5SjztB3RxMT9m5u+ZC96sP7pCGp+3aV0F3aw6/gA/BCYpqYfSxwaRznXEbEsczb
	BSUdKWOu0Ms2C70xV5N+6snLizmc9QWgtQb2cf2Iap1sfgMEL2AS4uuoGq7VpxykKqylf2UJHJz
	rS/5WcQ5AyIWr8mbdMxq/pLmdEpSJUozKVB6a1JDyP6OEHVvKlcPcXpqr6C6vz1zcuzV7NjUwtL
	BtAjpcey9wwAcyUEYI4xhUZ0gMEn49MjnM2D5rGdsS8jz4TgSxyLjoD4Y3swswJsW3QY/6h3Xfx
	XpqvF578mDPnGVA/kCLuOTILEkZAmXn0zhYrS9O/F5ZOcGzajbgEBs9EdmveDuBm2C7Yl11o/zx
	xqC/p7JkVTJ/2XKo6UTCu0v7Rmevr84/1LqeT/5DsY12cQJ33/ako=
X-Received: by 2002:a05:6214:4003:b0:890:58b4:3e7c with SMTP id 6a1803df08f44-892743ded60mr90739606d6.33.1768490081454;
        Thu, 15 Jan 2026 07:14:41 -0800 (PST)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-890770cc6edsm201030056d6.4.2026.01.15.07.14.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jan 2026 07:14:40 -0800 (PST)
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
Subject: [PATCH net-next v7 01/16] net: define IPPROTO_QUIC and SOL_QUIC constants
Date: Thu, 15 Jan 2026 10:11:01 -0500
Message-ID: <87ccdbc3b8abe4fb1df5a97c0baf39d2b943eeef.1768489876.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1768489876.git.lucien.xin@gmail.com>
References: <cover.1768489876.git.lucien.xin@gmail.com>
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

