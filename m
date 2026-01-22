Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BBB736CDF6;
	Thu, 22 Jan 2026 17:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769102252; cv=none; b=HnVHzLn2CaFtZCED5JMgm9AzhlodtGESpisg4xaF+YhRpvBAtvptwdno7Ik37mbm2x7jRvRKYld5/jNhDko7+dqlSFvJYcmVr0DgtNs/iEiPSnp0P3lzcrb38QXRLDUhoZYUdqPIZl0rKfgnz6fzwFmH33gEMvdTVh2b89m22nU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769102252; c=relaxed/simple;
	bh=5ksbPQcJyZl7X+h52/8GjNkOpn2hvNzhbPyWBKrSkfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KxYu1KDMra1g2429axtsL2RxdodtVTeYnfmUdYMZtPhCKjxR7QwEfw8CTMn1rkhZSpujatio0fipFGIAAzaKWOxXP545yabydh9hVRoMYchMXF5AxoE6KsFby+CgFdU9ltRVf1USHy4/hDeHMVjXFiqp0HVbNuX7agyjqwJKJUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=dex+anXm; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="dex+anXm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=L2mf9IfuAhPe/tbD0spvYsTzqntmpdhiwcfVo2W5dUs=; b=dex+anXmNiL0v1aOW3zIFRTQtL
	TPoX7wNJmP7DXKPLIuV/wE/TKMFet34wYLohBgVjqtgiaR3IJyQrHIpS9P2jTTc8hcBRcfhoFe7h7
	XZ4pG4zBLofG/vE1PloZc56r4lpf6OXLYQtlfJtkj/oS9js5WjyLv6GRGuoBsiVh31kSxVe1oPJ3Z
	ZeDN/2bWkBGyHKwlL3NnNQLu49ccVxjLrImEc16YI7kRT7jb9NgXfCEDX+sE0GRJiLQRqY/2Eh96V
	cfP/oncHX7PrK77JasPv/DNJdo2AJ888euoiXEV4jRZZtmGx/Oq1DUhR2vLLjeXPl26CWw+AMzgdT
	AS/0N/VcdcOFuFB/+TQXFAndJERvL+5mlKLAAXriFy8xMlVfAjENVy/nWe0xbivevxVqD5222opeS
	RcN6+3EvsvtKv6KcYj+zJG5gczgjC/ASjCsWDxz+FLTBL4C8OFJQm9zretDNNLihHTdSkQB4wLMnW
	/6RiekO8M5KffPHf/2TAS9yY;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1viyJ8-00000001pkV-0MTz;
	Thu, 22 Jan 2026 17:17:22 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	stable@vger.kernel.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v2 02/20] smb: smbdirect: introduce smbdirect_socket.send_io.bcredits.*
Date: Thu, 22 Jan 2026 18:16:42 +0100
Message-ID: <7ae7ed5159f27bc8530c2e263b20e2ad1216db46.1769101771.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1769101771.git.metze@samba.org>
References: <cover.1769101771.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It turns out that our code will corrupt the stream of
reassabled data transfer messages when we trigger an
immendiate (empty) send.

In order to fix this we'll have a single 'batch' credit per
connection. And code getting that credit is free to use
as much messages until remaining_length reaches 0, then
the batch credit it given back and the next logical send can
happen.

Cc: <stable@vger.kernel.org> # 6.18.x
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/common/smbdirect/smbdirect_socket.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_socket.h b/fs/smb/common/smbdirect/smbdirect_socket.h
index 403a8b2cd30e..95265192bb01 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.h
+++ b/fs/smb/common/smbdirect/smbdirect_socket.h
@@ -162,6 +162,17 @@ struct smbdirect_socket {
 			mempool_t		*pool;
 		} mem;
 
+		/*
+		 * This is a coordination for smbdirect_send_batch.
+		 *
+		 * There's only one possible credit, which means
+		 * only one instance is running at a time.
+		 */
+		struct {
+			atomic_t count;
+			wait_queue_head_t wait_queue;
+		} bcredits;
+
 		/*
 		 * The local credit state for ib_post_send()
 		 */
@@ -371,6 +382,9 @@ static __always_inline void smbdirect_socket_init(struct smbdirect_socket *sc)
 	INIT_DELAYED_WORK(&sc->idle.timer_work, __smbdirect_socket_disabled_work);
 	disable_delayed_work_sync(&sc->idle.timer_work);
 
+	atomic_set(&sc->send_io.bcredits.count, 0);
+	init_waitqueue_head(&sc->send_io.bcredits.wait_queue);
+
 	atomic_set(&sc->send_io.lcredits.count, 0);
 	init_waitqueue_head(&sc->send_io.lcredits.wait_queue);
 
@@ -485,6 +499,8 @@ struct smbdirect_send_batch {
 	 */
 	bool need_invalidate_rkey;
 	u32 remote_key;
+
+	int credit;
 };
 
 struct smbdirect_recv_io {
-- 
2.43.0

