Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794498145;
	b=Wcu5InB4CMqbZpVXcll1wZsJkXE6B+usKohydbj33LZbOWLUi/BvJLisJdz/SIYReHYr
	 AoPYVYvqBP4OMZ39KUPvtU63eG9NUhsSxnvOtEhuzNN1tbcw9UnFr+O2+8fmlh3eRWUsn
	 pbwAVI88FZuFaVOeKjdZpyoE9CLvtJY5gkDpw3YU1flLNIz5n6krK+f1voEcD4QJ6Rjmu
	 L6L9KwCe53/W9cPwAl7HG6KxnlFSMYHRsPHUM/m/zOJZBou6elyNfo+3XfV1+OlJxDE2r
	 MHJa31j9cGcrz31zE8R31spnsznyoh5vYngoOnHPJyJ6l39BwSGFXFpy2xuaNrVm0Rw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794498145;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qPdK+vh8/g3uS3dMRmESD66VYLEkQ0XCEscEZnuHhMY=;
	b=LhAvXUYMuh86B6Dd10/7GS2WwmRKt6OmH6n2ghGcD1OQCy/ljqL83Ul9xFv3SySQgiLA
	 XaZCpEFUjDFcGI+utGIDRn8NLTV/wpdZqVAEzmY0EvJu+bUDd15XJvcmjtEeuLMgt9h8V
	 pvqvTvjUx4eCm1vhmEQERneu3/kkd/NrEjSiAlMWR71PrtJDDMiQk7rmawWeL5t84Q64q
	 0rpZF9bqD7nJwUjuvtU/J5hVMvvaCZvxkKjmhF97xuxmj9XaU9NumUvkyzmPD7p6J5e7k
	 Q8FaPpYCyGmCeQigHFbBDNUY0qKGz/VeyKLlezUlWXarCivCui/+cbqZl1LpZRj9rUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=UNzXi57n;
	arc=none smtp.remote-ip=209.85.210.182
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4504606A321
	for <linux-cifs@vger.kernel.org>; Thu, 12 Nov 2026 15:42:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C4504606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=UNzXi57n
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-8b6399ebb41so3900047b3a.0
        for <linux-cifs@vger.kernel.org>; Thu, 12 Nov 2026 07:42:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794498144; x=1795102944; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qPdK+vh8/g3uS3dMRmESD66VYLEkQ0XCEscEZnuHhMY=;
        b=UNzXi57nIEINpiLTnoJVLHkb3iSpvqvZxAH5zhOTFLYYq3JC2pBwTtCUqR8HLWWJl7
         dvWdgn8wrADdnYvaeFX/6i5X9sWXAY8dacQSJHpex7H2cPFJjHpqvyb162Z/U+flSnTM
         yI0nxbIsMix1Gdwd5Qgg91zBnzU0CsqOFM/glgCb+b3W5ftAKLobixe5X+rPKSDr8jPp
         UNz3vCCdBePGqrOih0FXIwxBvUWNTzJmSOngSzsivXe1+V1R0yO5dm+s24qtTCHIzPY8
         z5D287sbnTS/dZgPYoIlqyguRO95+dC+xkLVtW7x3xdRJg76TcqVosKokof0NIHRmWRk
         +QYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794498144; x=1795102944;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qPdK+vh8/g3uS3dMRmESD66VYLEkQ0XCEscEZnuHhMY=;
        b=BWkdpcmb5Yhb1rOOW6pWK2aD8Qyk7O3xSKj/OtL3JpnU3IMfbzBBm3WIzT9UHEP7Al
         5O5QJOc/SqjiDQMN3lLPKX9bvQs066A7hNk08WUCy3+l2FWogZQB0YT1Oa5Iqej4HUNY
         OmKr6SISWKC+BiBQM7MhmzfzZb50KFfXxBTFhRwifbItuf8/k0wht1BixwrUJhps1L/H
         cCGIvyEZXdMBNHV1xvsYQs5vSdLTq9HCDv5JnvSVuESAXcf1u8V11fjRRzolXpu9X859
         Ap7doj7xwES6XALv/9//TYTqKtfZ6dCtv07E7hap30aFdQb2ZFJ5f+itVvBWDCRGGlwm
         yR7g==
X-Forwarded-Encrypted: i=1; AL+hErFCLX9R8bf/fvKu//Vy21XH1cwAGyyPjuUFS/Cyp09otmzh1szMQFWUeATWf9zZ325FGbW+eagKD/LH@vger.kernel.org
X-Gm-Message-State: APuU4Z9IiKxgd0BJVSTp4PemkqMEJ/FF4jqvFQ3d4R72gSgqSrqAWREW
	LfA9dCioOEIsLa9jQfisha69p4Ih0QbXBfaKipyUkzte3bZ7nj2H1stZ
X-Gm-Gg: AYBFou32Vl3rwM4jIZukeXdNL7t43CYzV6n478XltO/ceahISmnVftj5rIdGZ4t9adp
	tRyfYoUSNmEXBqJIHU3N8PS1CptCc7sqlvPC8gm18FibIcBoOXIXhueYt5bx2Xt6dk48rspMeoU
	VT6XUVU2+w5LAmja6yHR4lROSW1UEB2KGAOWpuuJ85GIheYbSHQC1GH7C7TyaAqrYZ6t19MYjXh
	97QkMRKs9OmxdbgKGnFIREBhEe3eoptcMMWl+QzyYdTQMYO2B6jKMl1u2r3pJPnLxJeyduUUctv
	3Eq56DG1UoOM+IA6/F/VYzLBr6slfp/D5EmkLABh3YsGtNTk5+X2q7TLpms8sMHsMHDaBCXIAn6
	s7o12dJq6++NVSS5T49sdqi+Eml5BQTjzfNdzWyqEcNoxlmyBDk04krl2WHOOaOapUaCuaXo2Fg
	AnqOQZ2RgaQpUNDy28krb3+Z1k2bBDZLcktzY6pfaB+iyL3CamU8wbsR6fB6Z5514zY32In/84P
	VEbUhWn72OtIP3FR3vBFPpmNtfiMT/iZK89j1JckBZNDR3l05Isn7VK5G1Urh6shmqnDF1Eq6Dy
	pIwcWmLuLYZJ1Kt+ktGOUirXEtksnCYSKXslOTIPIXxoOJgg/WcLUEu/n9D+as/XRRw/5esb+0R
	O51zcNkuQIbcSg/qwU2TkRufeeG4=
X-Received: by 2002:a05:6a00:21ca:b0:89f:1b32:29a5 with SMTP id d2e1a72fcca58-8bc195038abmr5834051b3a.7.1794498144019;
        Thu, 12 Nov 2026 07:42:24 -0800 (PST)
Received: from localhost.localdomain ([2405:9800:b901:33ad:21c4:c32f:67c1:d87c])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8baa7de3619sm3790596b3a.5.2026.11.12.07.42.19
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 12 Nov 2026 07:42:23 -0800 (PST)
From: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
To: linkinjeon@kernel.org,
	stfrench@microsoft.com
Cc: icb@fastmail.org,
	senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	ematsumiya@suse.de,
	lsahlber@redhat.com,
	hyc.lee@gmail.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michail Andreas Michalopoulos <mike.michalo@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v6 4/8] ksmbd: refuse a binding request on a connection that is already a channel
Date: Thu, 12 Nov 2026 22:41:51 +0700
Message-ID: <20261112154155.20255-5-mike.michalo@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261112154155.20255-1-mike.michalo@gmail.com>
References: <20261112154155.20255-1-mike.michalo@gmail.com>
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

smb2_sess_setup() refuses a binding request for a session that the
connection already uses, but is_ksmbd_session_in_connection() only
knows the sessions created on the connection, not the ones it was bound
to as a channel. A connection that is already a channel of a session
can therefore bind to it again. The new binding legs are verified and
signed with the session key at that connection's MessageIds, and on
completion generate_signingkey() replaces the channel's signing key,
while register_session_channel() keeps the old channel entry.

Refuse such a request with STATUS_REQUEST_NOT_ACCEPTED, as MS-SMB2
3.3.5.5 does for a session that is already in Connection.SessionTable,
which a binding adds the session to (3.3.5.5.3).

An AI assistant was used to draft the patch and as an independent
reviewer.

Fixes: f5a544e3bab7 ("ksmbd: add support for SMB3 multichannel")
Cc: stable@vger.kernel.org
Signed-off-by: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
---
 fs/smb/server/smb2pdu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index a15dd200645bb..186a497f83c62 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2765,7 +2765,9 @@ int smb2_sess_setup(struct ksmbd_work *work)
 			goto out_err;
 		}
 
-		if (is_ksmbd_session_in_connection(conn, sess_id)) {
+		/* This connection must not already be using the session */
+		if (is_ksmbd_session_in_connection(conn, sess_id) ||
+		    lookup_chann_list(sess, conn)) {
 			rc = -EACCES;
 			goto out_err;
 		}
-- 
2.43.0

