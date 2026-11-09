Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794254303;
	b=O0Pp5z6tKo9fntDuY1oUpj7LKeyQQR/OqcjJPnjoJc9jIUseTD7brJYE16Bvriiht9LH
	 rlTjNUOfeHYeib+jS4R13bfyGCFVJpWKHqb55SpyNd/0+vWQmNzx3bkhYBd9eTAVHB02a
	 tdJqbuojlUtTq73UnSJXxv2XHzpddpVXHkynBwiUQW94UxOECuQDTwAJZZe8EH6UN6T9c
	 FZ2j1n/WFQLawjv+e/lR5mO01OKHnsg9TuNjIx9mP6qee7k6GbNOiUYAxPLyQEnv4CuFB
	 uEhNcuigPKV9qrXKttCF/X1vs91EPTh/1kam+VWaqc420bTkGEa4USiGEchBNePgHuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794254303;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=LjlIdWOtAx4vgBSOIZMhE9Gxzn2GjEyrd7gwD+Ba4Y0=;
	b=la+SXNUA3mYjKp7TNybv46htyvWZ9ixQxrW9JZGA8yl7LoxNzpzFgYdEM75ci5i1G3Y6
	 fbYNwblD5zHekeWqrgyfeprkfWHPIEW4s6hiy1o9jkHl/H7YKXoTk5mRSK47yRMS5V9Ys
	 4qcHa1spbP3q5BZQ/AFWRjwxeCqFdEOy8DF85kdMdH5MMQelU1qSL+OpxXf8EfxD6R0/V
	 FIueov9iZ4P1KyFizl+BPcgejxRxKA6sMYHfwHTGxCA6YTB6NP6fpiXiOpRp7RQlhu4lK
	 e2pawpIHxJXilm6noaJ7H0DutpHOY0UpW9/XrFO4gJU/IWTovkjnb4pIAidIL/SQ2zQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="R/1WuOAu";
	arc=none smtp.remote-ip=209.85.210.178
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C9BE606A334
	for <linux-cifs@vger.kernel.org>; Mon,  9 Nov 2026 19:58:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9C9BE606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=R/1WuOAu
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-8b5efadd183so583412b3a.1
        for <linux-cifs@vger.kernel.org>; Mon, 09 Nov 2026 11:58:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794254302; x=1794859102; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=LjlIdWOtAx4vgBSOIZMhE9Gxzn2GjEyrd7gwD+Ba4Y0=;
        b=R/1WuOAuCnN/JHW6ktRQlo8KATUbKPdmjv9knkQlezuppBKQ2QFjLENs6otezsL2xP
         eTi11KqJIzewO8F4GEX9Pf6o4wLrfbGRV4H9OSeZy3ikk84qdvC4VMdEMg/MHDhDNLVv
         yv4ssmwMsCkU4txSd9s/sNEluf8Pigwe2x3/j3/gXS/kK2AAnjAD+0PdFvTVfnpnzLh/
         fBvyKMdHhUoSFRmcYglCQljvABVmnVeCkXj1NCgIQil7Gk/POjf49qomsOEd0fN8NByQ
         wbFuKhXBaMycT4NEbjJxj+bT9JfZWmsfDPrZ9S7aOK25smaHJEJaVgMkSFajcl+3hg6B
         jaCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794254302; x=1794859102;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LjlIdWOtAx4vgBSOIZMhE9Gxzn2GjEyrd7gwD+Ba4Y0=;
        b=glb3h8tr8NItZzCnD3ulrPQcTZAdHxXUkplIRM1AQlrkn9sjhkztJPku6Z7E/CHR/M
         WxFL8he1aVPTxqbOGKepazzN6ma3f94bGeH0wOF/h3Gt4XhnbjzZNKGAD4Z2m15NFdVL
         yyBwTatg2OKjktcV4jD0xVL6JOVVGArD+rJdohOtzDc/QYqyaoRoulsl4AEAp8rxb7Jf
         aKfrwN++GvAF87THlOgWfqHLt0RLRDLUMzEO9c53P4bwas/iljyeDdbNtcVmts7Vg2Pf
         17h+eQQPz47gDK8XUYOmh4TmNiY7RNa7vy57TSDOa30TBNvA3q6aVnwVPOxkGDtpRfjX
         COtQ==
X-Forwarded-Encrypted: i=1; AL+hErEcHjlmXBo21ot1OnQilSlP1R+kSkqdrEee4XKuR7uhF+WDkTxLMYhe6amXvmuAoi7KXBu5OhrL3fKt@vger.kernel.org
X-Gm-Message-State: APuU4Z9S4LXIlHCT3DykHI9r95mNz+aFGBkEI1zZep5RDVI69EcAGZ4s
	rsi4N0ICta3RzaPtOX1saNfPi2FsTQI3Z5vlSfWt+zDNTvD+J6Thf/FO
X-Gm-Gg: AYBFou2QtKFp7eOF+VeDjTg7c6sLH5RYxEEG02H+ThyxCO5VrTnFG0p+j55RcS7r51i
	WYX1QpFxvZd/E7EqjUwGLoXvHSJ+mnaoUt9RNsWGBuA9aSyS6EU0HAMWxoZbnDK4C8AetsTvm54
	y2YlycuEmpsMeNkxFfzR9lFqRmn7IKyLpH0hnOzX5OQK7nwI+Hxz1s+yDkOz66cG6X+u/b4z32g
	Pp6pHWUb0osOWriKEZR0DM+opfLkIymztex7XdIGO+AoHTEJXXB+fHf+cBrtJ6LRf3UFKHO4rM4
	gjemEI1Br1gZqXliJhHCdjb/9WwJXFYHwhSuQWOhxDtKv9vRscE/G3XVhwGoISr6z+CqgzVDyIF
	BHbiNTebhFZyeg5b8a0/AUJAHZM/NOZZUJ/V1fKdHoO7VmtwX4wQaeHeDRMc2tt2AXo2gOHErI+
	/7OK3Ec1KxoIszGWcnpKVoAM0snaO08VIMQt79XjkXrhFTYlUSgbpmLDclLwCzZJvpSwQhDK4HK
	JynuHNLC/S/VOa14tJDlzTTTJWQ5MenVwkOKWheka0lC51g9gxBrbvnSb6ZLImOY3744raZP6sY
	3W+cleVs6R3pnE+lP9GdE6ZZ0/AZF2AfqEgf82OevrOai9zjJgjWyKUn0VI+Q5tdxxcS8uuILki
	TGrmhPA9/0ejSEWZfo6HoKfgMsb/Pf/Bq8j46+UTaWsEGSwY9LfbfBD8=
X-Received: by 2002:a05:6a21:110:b0:3e2:4e6e:6ca3 with SMTP id adf61e73a8af0-3f18fb8127amr165601637.34.1794254301572;
        Mon, 09 Nov 2026 11:58:21 -0800 (PST)
Received: from localhost.localdomain (mx-ll-183.88.2-201.dynamic.3bb.co.th. [183.88.2.201])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8baaa2a7fbesm61629b3a.11.2026.11.09.11.58.18
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 09 Nov 2026 11:58:21 -0800 (PST)
From: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
To: linkinjeon@kernel.org,
	stfrench@microsoft.com
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michail Andreas Michalopoulos <mike.michalo@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] ksmbd: refuse reauthentication of an expired session as another user
Date: Tue, 10 Nov 2026 02:58:13 +0700
Message-ID: <20261109195813.24238-1-mike.michalo@gmail.com>
X-Mailer: git-send-email 2.56.0
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

When a Kerberos session expires, its owner can reauthenticate it. For an
NTLM reauthentication, ntlm_authenticate() only compares the new user with
sess->user when the session is still valid. An expired session is in
SMB2_SESSION_IN_PROGRESS during the reauthentication, so it takes the
other branch and simply sets sess->user to the new user:

- the session's open files, tree connects and other state, created under
  the original user's identity, now belong to whichever user just
  authenticated, and a later Kerberos reauthentication is compared
  against that user rather than the original one;
- the original struct ksmbd_user is overwritten without being freed.

krb5_authenticate() already refuses a different user in this case, and
the valid-session branch of ntlm_authenticate() does too. Do the same for
an expired session: compare with the existing user and refuse a different
one with -EKEYREJECTED, freeing the newly looked-up user either way.

An AI assistant was used to find and fix this and as an independent
reviewer.

Fixes: a47634cd729b ("ksmbd: expire SMB sessions when Kerberos tickets expire")
Cc: stable@vger.kernel.org
Signed-off-by: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
---
 fs/smb/server/smb2pdu.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index b084cca8813cc..234439c1526f9 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2365,6 +2365,17 @@ static int ntlm_authenticate(struct ksmbd_work *work,
 			return -EKEYREJECTED;
 		}
 		ksmbd_free_user(user);
+	} else if (sess->user) {
+		/*
+		 * Reauthentication of an expired session: as for a valid
+		 * session, and as krb5_authenticate() does, it must be by the
+		 * same user. Replacing sess->user would also leak the old one.
+		 */
+		if (!ksmbd_compare_user(sess->user, user)) {
+			ksmbd_free_user(user);
+			return -EKEYREJECTED;
+		}
+		ksmbd_free_user(user);
 	} else {
 		sess->user = user;
 	}
-- 
2.43.0

