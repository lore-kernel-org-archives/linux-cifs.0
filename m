Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793005480;
	b=TPD7Cs+T02kmjHhXwnLBcO+3qHXSA5vJEZ72uFma5K32fsTf8g9gnpkcVW10RIDcybOz
	 +Q8B/UtSZUO06x6X0BWEfbFbaVDWIqrSDNd2p1yk5k1HnlFO98A3u3UXWASlpFAOBuczX
	 phGh/UjKEhf+gKnIcj/mGijdOtHvjSkepG0LTErKpsB9HUv/yY4msadFsPPXLjnmD5a4n
	 C1M1kt55W2ZiEjC8lz2kFSx0Idizi/cIg5P61DAykTdiiNPRHS9gsYigG8P3EdEWHeNH0
	 a5gPVVGY3/wTxscJAJiesyIn5EyHKLj6iAa5EcTgqUTbNOUFsaUTSNCOzo8j6Z2l3qw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793005480;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=COJLm9G5IN4+6WiKNarImJZ79lXIhHhDeZEoEJZbalk=;
	b=ySkDzJSe+WL59ImIPVUfehwAbYgR/01kHJXsSWp0OllBZg/mkbSrbYnB6UTUKNl2EZR1
	 0vhoHGS0wA8LWb61TIrRBDGikvvQa7ozA/esozChhlEXgdazX5gKyBNVI2yJXYxDJ5MqG
	 NAklJkhikJUbCyzkQA1DhUjX0CSUx9c5WrxIxLdzTyrk/Z2cHO592DgVxZD5qZM35n3d9
	 ELgs9sL1MQ9+uNGCjEPDfitUv7GmoBJ63ZO8LNgHbR36DK1bLxScniM56CQNzo8uaDR6h
	 KHqXTJdjXBVwYH3mMpDefJsC6zqDGHT64fp5FvHMRdkY/7A3bv1ohCjxLe1NAgHJkSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=act-marketing.de;
	spf=pass smtp.mailfrom=act-marketing.de;
	dkim=pass header.d=act-marketing.de header.i=@act-marketing.de header.a=rsa-sha256 header.s=google header.b=I922uOVO;
	arc=none smtp.remote-ip=209.85.221.50
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF5AB606A31B
	for <linux-cifs@vger.kernel.org>; Mon, 26 Oct 2026 09:04:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EF5AB606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=act-marketing.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=act-marketing.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=act-marketing.de header.i=@act-marketing.de header.a=rsa-sha256 header.s=google header.b=I922uOVO
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-48afcd7ba9bso1484366f8f.3
        for <linux-cifs@vger.kernel.org>; Mon, 26 Oct 2026 02:04:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=act-marketing.de; s=google; t=1793005477; x=1793610277; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=COJLm9G5IN4+6WiKNarImJZ79lXIhHhDeZEoEJZbalk=;
        b=I922uOVOttgNfKeQzhZRy+gGGQ2BBAgdl/7aZzmVn8ibcJEqN77nsPgxInbR3r30H3
         TwHQAr5+dkw571Q0Mww8ta6dX5BB1omlvcH82HRtvvVpf3WVyZiiERh8F5xtOLyGJPoR
         wsmFybi+265cMofhvjvLWIt4+lv/BKn9b4MBeSBiJvPdH2Rz4zY7gAs6rHvIT97jSoTS
         uStOb196KTMXG2E2LOFnS01fKU4U0kAnewLVQKyVTf+r6b8l18+6hjgcHbnwyDKh72Wg
         skcgCyEZEauFynoGOPs9pH3+hx+Iz+DkGYLG2W/uUqBBS9jqudvXQ0tpjg5KmpvHPy8C
         5s0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793005477; x=1793610277;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=COJLm9G5IN4+6WiKNarImJZ79lXIhHhDeZEoEJZbalk=;
        b=nSYEb//He5LWYqd7FNVdn3SFlqsjTXcn1OsZ8UZ61DyF87xQ4OTxzNFjcJXRvTFkcG
         q+gfsRHzHDIijt6Al4EcGxfI+xzpET/6i15yZz/RYO2XiyolDcwItLX3tT3t1iNVWX0L
         kseAOiIALnIQ/amKZsoqy3U5ayKWjmsdNrpcQzGYj9n6kVt2lgmQqSsl742SqI/Gz44y
         LgPIG+SMMdMsBMiE89VZtWxnGl8iiPnkCwxzdEKP1TiCemEwONskTzX8gJBIj8qZRuKr
         ubiyKKLq3jTrd5Jszh1eS5u2NC/XNIC3TA3rfwq1tXDpeSM7jdtZhMQDy5lY2Gz6wtqg
         dKtA==
X-Forwarded-Encrypted: i=1; AKwUvBwaBZ6HwA2vl/JdYSe8rZBTDgRPJrIV6MB9Job41sRlZqkXFWudLMy6c5dY0F9pTdtun57Ae4u1GwS/@vger.kernel.org
X-Gm-Message-State: AFq9FYJcT7fpQ/ikh56yzFLrjruxMO36hzWnqjNcCLFEu2F9C6fDYFq5
	mISIl9tCHDzD/irkO0deF7hPZfLpEAJTwU4CQjLR9mTnvwBm3GyerjIqHQPB/i+nk1I=
X-Gm-Gg: AYBFou0ztSd83ig7NhZIIuV8kvYdfMi7RI+wPn0Y92Vwl39cD+BaDmgTpbBfE4fH1s1
	oCcrk6581/x4tJovbop12XhKHSTamWIaxGKutIYCVrKCH6WBkzO5I9XJB7Qtip5C4WXzqyX0NxN
	F1kn3AjruZN3kK2YGVAwMFfNq1d+cbvDW+Dm/2AlAd/AMejitiGh0UXNyvuPogkfERCAWcxKG4B
	LXa+oCMce5c8wUzRB8FtUj74TuE91qeCTAE8RuppQXgnmt58Y8Wj1kJu4GvPdCsN1PsxOU5WtC6
	W/j7GJbAmQdnEuu1/RDbEASfEWltbkQAQUKj7Q0TGR62hXkNgXxQ3vdTcNnNmKe6FyXwMEp/gWZ
	hWoyVPWdNJb3DjnzRtm7ujLQ4txZg98+u8F10wzJmD/Hj1VT6fYDyOuL5JVZsjfoHex7SxNiWJF
	4g28UR1hOtETNf0mO6KB15g7GK6tTnOdvkdcF8xF+29DZMRqsOLTbiON6lIIjb6AEz+pN2ELZBt
	jqDMql1/ZmpAOd4CdRDybWqsKQE/QOGtA04NA5nVM7oJFHz0ZltM5dAGH10rBhrBVEC6hMxi//F
	9++0HiyyiJjT7vhg3OQo3KSvsvxO20t2GQtTsVmI/Vp++JyVUWaYCGbWxqRuAYtqta0jROHrx/l
	/3l9fug8=
X-Received: by 2002:a05:6000:4313:b0:487:13f:f612 with SMTP id ffacd0b85a97d-48e3eb94194mr11223168f8f.37.1793005476413;
        Mon, 26 Oct 2026 02:04:36 -0700 (PDT)
Received: from jan-82yu.intranet.act-marketing.com (p5097853f.dip0.t-ipconnect.de. [80.151.133.63])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ecd354asm14329279f8f.43.2026.10.26.02.04.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 02:04:36 -0700 (PDT)
From: Jan Koester <j.koester@act-marketing.de>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Jan Koester <j.koester@act-marketing.de>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	linux-cifs@vger.kernel.org
Subject: [PATCH] ksmbd: ignore network devices of other namespaces
Date: Mon, 26 Oct 2026 10:04:15 +0100
Message-ID: <20261026090420.34283-1-j.koester@act-marketing.de>
X-Mailer: git-send-email 2.47.3
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

With no interface list configured, ksmbd binds every interface that
comes up. ksmbd_netdev_event() does not look at the device's namespace,
and create_socket() opens the listener in the namespace of the task
raising NETDEV_UP. A container with its own address on a bridge brings
up its interface and finds port 445 in its namespace already taken by
ksmbd, so an SMB server running inside the container fails with
"Address already in use".

Interfaces are also matched by name only, so a container's eth0 going
down would stop the listener on the host's eth0.

Only handle netdev events for devices in init_net.

Signed-off-by: Jan Koester <j.koester@act-marketing.de>
---
 fs/smb/server/transport_tcp.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/smb/server/transport_tcp.c b/fs/smb/server/transport_tcp.c
index 4968cfc..b2a3d8b 100644
--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -577,6 +577,15 @@ static int ksmbd_netdev_event(struct notifier_block *nb, unsigned long event,
 	struct interface *iface;
 	int ret;
 
+	/*
+	 * ksmbd serves the initial namespace only. create_socket() listens in
+	 * the namespace of the task raising the event, so a container bringing
+	 * up its own interface would get a listener on its port 445, and the
+	 * name-only interface lookup would let its interfaces stop ours.
+	 */
+	if (!net_eq(dev_net(netdev), &init_net))
+		return NOTIFY_DONE;
+
 	switch (event) {
 	case NETDEV_UP:
 		if (netif_is_bridge_port(netdev))
-- 
2.47.3

