Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794509474;
	b=M1pf260YTahI3hE8WibF/ZdQ/nErvs+PZdLsghxmpXvWfNh+AnUqaR3UQZFs7sLETi7z
	 /JhBrpAXy+WFzouheAwBqOUHIoziXK8Jm8XM1GYwgQyFMi/ynGxOy2cWuD4dmStkyOMGS
	 AQFC5u9qK3ONVehI9kp7X0YelyxrQ6XXwEDIntQ+S+lqu6GL92CRiWPBw+tsk1KUHdzAa
	 ENYja0+mhGGIBKq6AaUTSEetyzz3WYhPSone3xVWw6N7yuUrZ5hU/rlnYGgSTri11IBSr
	 gy72jFTPahpKe/9+PsQu5b+8Hb1q4/3vvewOZAe57PEtrI3iRG42JefCYlErXjRTe/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794509474;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gFSI+HHYT4seNa8BU1xKJtAjCfEadHjjO87I98TwLD4=;
	b=3BQlFNqIO5DJvqfYw9+8HBDiPjBhM/D4loheFKKbYb9Z2nFSu4JDXSVyK6KYrLVfwZHe
	 XB4nxt32Nen5rjfElFuKo2Dfaq8T7NQDcy21wLFT+d51OKg990O58X6vNbza3AxpXi+sV
	 LVfclZ52ZCoybGH65Maq8akrFOmTBaF7dIX65rCeprhYLKAgtlLtXUAPo9sWWuV0pupEC
	 dSmfyR6Q9H4/QQehLr9/CdD1tDU02+Ubvpdv2RcpRuRoCZSsNg0dGUp9Zq4eR7rHHjhva
	 sWOYj6HUUmm4/R33bTLS4+ZMb8Cl9pJjaiT0HhNS3/6N3hBXxLOQitLXovHxrMuePIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qGxwyCqo;
	arc=none smtp.remote-ip=209.85.214.174
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5184A60A261C
	for <linux-cifs@vger.kernel.org>; Thu, 12 Nov 2026 18:51:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5184A60A261C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qGxwyCqo
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2e99b1e5b4cso1404125ad.0
        for <linux-cifs@vger.kernel.org>; Thu, 12 Nov 2026 10:51:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794509473; x=1795114273; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gFSI+HHYT4seNa8BU1xKJtAjCfEadHjjO87I98TwLD4=;
        b=qGxwyCqod/rexmsG9ZsOYcnBQFKqr5u+tQrTqRJDpclqKc0CTeDOjoWjisWvRO1o90
         mMvxdQ6y99AnMT/jEkLgWrm2SLatXYb8/Di9++wMqyJTl9JBFwSurP1QvxXMFX5xBYnI
         bYPaHXa8aRuXEOvar1OOCt7OIeJqrc8zwkQgT51cRYGrbQMux66VLAcpxrg6SDUAfAHn
         uGMeUjQAqvx7WG9MqK6MI9Ua4grYSKr9XmGAPSFxUdIzgw7rJf5klXW2d23P4B0wEth5
         vsmKzsBANTXwvSnX5Ft5No7JEffewoaUmvLbHtE6dfQzcPjNCf4pVRWcIGNtbQCPDXvV
         U3qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794509473; x=1795114273;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=gFSI+HHYT4seNa8BU1xKJtAjCfEadHjjO87I98TwLD4=;
        b=06UcS0y9Tq11OOOR/wWG7gvR6nAAXG1w51B4ZaQKTo3yfFYDNwc/JX6qZr+2Un6Flw
         e3nXAuzkSfI0d1S63B1ScJKubenxHWGXKrP0SqRw4IAwmJuI7+HC3qvZo4Ci7x19oFCh
         SVDUq7nbubk9g4Peruo86ftGRQsBgxWynFhs/iHw7Lg+BN4D6477nShEO2I2a+XFe67/
         oegIPOVmevoq2TZEg2yW2bq+Iqn3LBfJe8nlQyaiYwUvyAbIQ+NhO8xZlWqUVe8hmBkM
         1hiNzQAy6nQ/4oBGKmNAQk5FVqQlqRigDvvninMTovrORJHJSbY/hWxn0zpp4V2M/IWM
         uZ9g==
X-Forwarded-Encrypted: i=1; AL+hErF0GGhsnA5wBXRm/gmiPCWpl7vg9qBVdD+GmHRTgJfq9o6X60ZmXLESSlpXQLijcucLL0rcsEW1iZRE@vger.kernel.org
X-Gm-Message-State: APuU4Z9PS99mGvxyPk4Kjh2swL/RalPlWwiQce1plHkW4Wlt+C5QD/iz
	LP6zg4/9r/nCz4HcMpM4wHBdy5G/YQWBBQcwPjwtEATSSzSUWcy5HSUk
X-Gm-Gg: AYBFou2K7DrexmoD3PuK4krTGSkRyWBp7ifVQVNPAkecqVy4mW1JRNZvM/RzR5sKScO
	NouDtj4Qs6MsDuFtg09IGj/r3Mnlab4GraLvk4Na7c/C6sh9ZMpc2UthTFZ1CrKFupv7ZiPx2sB
	9kv6F35UXnpf9itvMeVBjqWmIcB7JBR+LfZnrltX2+W9EoLbkzyH4fpaNtR4CgnX9FHwhfqCVIt
	yS06zkGKP2UEZ2faA1HqhYobxe7k1bqAfw9akD4jriwuo6xXB8NlGUEy4hiQIUbHSTeVzjurdlz
	wRqlKxtud1ePwwwSzaPDMnYvB7a1WEm9wVHZYkSn+Q0HkKfvtg9PTRcDIcEBPIQK+tTx/4JYIUi
	bw19sHSERWnob7FJaFIARLEP3hznzN4jvlM6dO2bfD/nptYWmQLqr+jZtuftPfb47tYWwiZsCcS
	5n1iB7baKj/rBd5mY7gErCv9nT1aFspao1957+F1XnWt398HX+aZkWjVeWOEggZirlK5F9NgT0f
	Ngz8gjTkws3N/JEDjlat0xNbbf+h+B1FohURVA52CMdE0cV2KFxZftoLbKsAoev+wcVHPwJMLQD
	/P3s6fJaaVyJORzQ94DuttgtUgRAR+wFv+yGcu2ffSw6mRqgX98GKMUrJM8IKP9VcOhzczhnRGi
	I2aYnZggTZI2N8Vuk8L0aLlxDZcrhO181iYVAxzCq7ZQmvjw=
X-Received: by 2002:a17:903:3887:b0:2ed:2810:7cc5 with SMTP id d9443c01a7336-2ee0dcc6d2emr2280895ad.56.1794509473534;
        Thu, 12 Nov 2026 10:51:13 -0800 (PST)
Received: from localhost.localdomain ([2405:9800:b901:33ad:cbb:dbe2:bd9d:a035])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ee0f7cf7bbsm66205ad.29.2026.11.12.10.51.08
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 12 Nov 2026 10:51:12 -0800 (PST)
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
Subject: [PATCH v7 4/8] ksmbd: refuse a binding request on a connection that is already a channel
Date: Fri, 13 Nov 2026 01:50:40 +0700
Message-ID: <20261112185044.41571-5-mike.michalo@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261112185044.41571-1-mike.michalo@gmail.com>
References: <20261112185044.41571-1-mike.michalo@gmail.com>
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
index c6e6cf60b1afa..7790aa618fcbb 100644
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

