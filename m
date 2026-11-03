Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.113
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793697369;
	b=HhQGqnEMxupHzp3w15t2epK8vN7kZ4Vp8jAhZJhUTPHJA3NE/nSLrqkdMMUDq3Fl9lDN
	 8znEOy4lw5tFF8R1Y9rkacuqIvsNzeUzDJprMZXQvQjo+kHFc92vmY+LJseuRAzalxf1e
	 RCbsW1CmHkrkDaS4Of/gTfRgBYwCuIDqANQYewkNIiOfquoARpKYavNx7V4rcZxJF9Wbx
	 wdqoNNe4TLJQZD4Cs4mdHi+2A1271ADURU7YM0V4mDTAKqFUg4o6hV1fJm6rIyMr7ywdk
	 hSXiq7iz67dBF3uhd1eX27DfR8spHhWf4CYDfS8/6HxnKgBhZKLEGSEPk03Snj9N6Kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793697369;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=pl3ngFE4BZhkAYH7ootOT4rmNGgs3H/HLtfaAhRIIhs=;
	b=nc9cNliK19KzjCOD1mbFbKaH5WFs9H6FncvFPvYOaiRO4K0fYYCrLMvX1uQvGOXNNLZ0
	 4GbX1zAvEByOZAAvyeR2YEOeR+oPgZszormT8fA9eRb6IcaySAZlNcXlmhbNjBoInW+Pc
	 tJIBh35u2r7PsbI+bFiwTlX4NSBUeud1OoTUEYytGSYFsegtOt7lcCUJJF8f5+3PAYn28
	 1ZYF8V0gPNqxW/hTnV/Uule+AkWv9Git8L9RtydVT/kQbu670NLxxfz2S1xRYhwLRWZ86
	 v803qAMVYkjRFl3+r52XYA5gQ2d9jWgl6llcYiWNywTNhGW1Bg9k+Dmd2Yb0QWHVa/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=MZShlwe5;
	arc=none smtp.remote-ip=115.124.30.113
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FDF3606A32C;
	Tue,  3 Nov 2026 09:16:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9FDF3606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=MZShlwe5
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793697359; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=pl3ngFE4BZhkAYH7ootOT4rmNGgs3H/HLtfaAhRIIhs=;
	b=MZShlwe5fSv41JrmirE6gmOKU4OgZngx1CBB/TqX0oepf8SJJRNwN0zQQPykm39Ntbx6ocVVTVRQCpsaLf0BFmlJwPCS6ngYEGXs8geG8sn5o716jQj4J5FPjnQUWYrX+ozup010JKzWj9jj4ANlFRJjuu35zZQRhZbFuHn7kzw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0XE2F58U_1793697358;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XE2F58U_1793697358 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 03 Nov 2026 17:15:59 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] smb: client: hold server ref while queueing reconnect work
Date: Tue,  3 Nov 2026 17:15:57 +0800
Message-Id: <20261103091558.2342761-1-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
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

When query_server_interfaces() returns -EOPNOTSUPP on a secondary
channel, smb2_reconnect() calls smb3_update_ses_channels() which for a
channel runs cifs_chan_skip_or_disable().  That clears the channel's
slot in the session and calls cifs_put_tcp_session(), which can drop
the last reference of the channel and tear it down.

smb2_reconnect() then falls through to skip_add_channels and queues
reconnect work on that server, using a server that may already be
freed.  The send path obtained the channel from cifs_pick_channel(),
which does not take a reference, so the session's channel reference is
the only one.

Take our own reference on the channel before calling
smb3_update_ses_channels() and drop it after the reconnect work has
been queued, so the channel cannot be freed while it is still used.

Fixes: f591062bdbf4 ("cifs: handle servers that still advertise multichannel after disabling")
Cc: stable@vger.kernel.org
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/smb/client/smb2pdu.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index f85595136ef8a..8e53e9e02df6c 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -253,6 +253,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	struct cifs_ses *ses;
 	int xid;
 	int rc = 0;
+	bool hold_server_ref = false;
 
 	/*
 	 * SMB2s NegProt, SessSetup, Logoff do not have tcon yet so
@@ -470,6 +471,20 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 			 * treat this as server not supporting multichannel
 			 */
 
+			/*
+			 * If server is a secondary channel,
+			 * cifs_chan_skip_or_disable() called below may
+			 * drop its last reference, so hold our own
+			 * reference until the reconnect work below has
+			 * been queued.
+			 */
+			spin_lock(&cifs_tcp_ses_lock);
+			if (server->srv_count) {
+				server->srv_count++;
+				hold_server_ref = true;
+			}
+			spin_unlock(&cifs_tcp_ses_lock);
+
 			rc = smb3_update_ses_channels(ses, server,
 						       from_reconnect,
 						       true /* disable_mchan */);
@@ -498,6 +513,8 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 
 	if (smb2_command != SMB2_INTERNAL_CMD)
 		cifs_queue_server_reconn(server);
+	if (hold_server_ref)
+		cifs_put_tcp_session(server, from_reconnect);
 
 	atomic_inc(&tconInfoReconnectCount);
 out:
-- 
2.39.3

