Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794512874;
	b=TDTafSs1AH/5fpU/7ph2Xf+fYvqzmexVvwXdxjL09jBJW4z9seRldRo+ugEj+0TEpFTt
	 CsKN4q1f3OBYzCKaGV0HmJk+J2DJkga9NU+CtqfPabOgQ1I8igkk4Ke4MKuqfmEb8ShY6
	 mDt4u4GMzc65WbIUSqIsmH7rXXtqOTveU3boivKNwNDh9u9o6LHKb/JdAoM/XFbmLkWTP
	 eyCER3EFwiRmn1waQ9goKJxGWMNykwaCdvM9pQPW1CghHNfJvCyFgUUpvCewYKyNmTng8
	 0LdufaemEHHCAK9WYMAOdn0zktIIJkw+WfNY7hqDnZynY4YKQdHMTJ8XARE1D9O7BRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794512874;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=d/WZP9qM01vcu0iQY3R3zS6LO6sreSjN5qCF0e0Ekh4=;
	b=2g6msD4lTScb4Dan6RVuEa9pw+EAXqizwZsjzmIsXKEXuFp7sSfG7JDGfbPzAUgNKS01
	 s1WaYHOKXeIckjGxIzPeE+PERdJvv3ko9ZGLFvOyLEll+eGmEq960s3VWvT4cG/l+JWi3
	 4yNazjIs5ZEd0HVsc4Pcg1oO+1h3OT3EGF6bR9MzoA7Y0g8f0XvHFd+LWT3fcGfEkKAEo
	 ZLQ/+5OF0YkDMTO+pKvkxM+R21EmmX9RIfM6DTiqtX7tP213wZdx5sZYGYnv8zuwNNQ1F
	 FyWBLJNQmF3JT2K0dbSGL8/SFmCnrHBVeMIMub4VhzgA1XyEY6vzZoSWDrl0T+ioovg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=y3bxZrcN;
	arc=none smtp.remote-ip=209.85.215.182
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B798E606A321
	for <linux-cifs@vger.kernel.org>; Thu, 12 Nov 2026 19:47:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B798E606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=y3bxZrcN
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-cdb9d5c1c8eso148636a12.0
        for <linux-cifs@vger.kernel.org>; Thu, 12 Nov 2026 11:47:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794512873; x=1795117673; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=d/WZP9qM01vcu0iQY3R3zS6LO6sreSjN5qCF0e0Ekh4=;
        b=y3bxZrcNobyjj6gh4ZbLbGfWGGBHOmGYqRc9kybj3NjnsJYkuynSeg2mi09OqnGtZN
         yDiqHTPSP3UTpC1cyEnIXEM8S6IP65y6FRvTtWh+JGi9+GzyUeDqxqKU7MMMNSTSberR
         qlSUY3f0PpVd/VBih7VjoFCGL/OYpMkPtkNo93MineN8I3NPNF0eIavAUPsv86tM+qFh
         sVPLSHjkWVBXtcMG1nQ7HrIFiKBfWWXj22UCa/MqB3ShqTDCflC9Q5rsCTLxGjkQYBrt
         FfGpoQlYtt36FY7TbKnhh/xUEv0om8e0brg6G/DEQjmm5t46xLEQtzwW9arBwLiq2uQ7
         zvMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794512873; x=1795117673;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=d/WZP9qM01vcu0iQY3R3zS6LO6sreSjN5qCF0e0Ekh4=;
        b=oHFihPQGOHYANAwWWb1e1NpxRioUTVj531W9u1uFyngRFeGbFmpjyA5knzDB9nbYYr
         vvq/i0+WurVcwAfcFdw4NdkN21BDBcmmZBfjeFy4R3lDNBiMWKcNeDEb7CQ0kmf4DyGP
         /+zUfQbLoKMq5126XUkVBW6JKOu0CmooS/FJXcY7JJsP3DMJoo22qbUWKqZFNCqq7yJy
         uIvCcFrIquc3lJ+QmQhlhLJT2d5tpL+JN/n52IVqLN9PXMZZdPtuHvTsxOdlNJO6wsI1
         qj46LVwlsmvQmj3EELi/NvoGOZfFStZ/Ldlr54CpFgua8QlnMaMLSVBs/Zy0/8hNKzWG
         sfPA==
X-Forwarded-Encrypted: i=1; AL+hErHfKfvE0aFPMulgJDhXZXzQacagf0KYeEIZ2klFS2MRuVmiBdx99bXYw8kgGowHVAIMwoJ77q7y1vTx@vger.kernel.org
X-Gm-Message-State: APuU4Z8001WBcbthY3JJ/BMJjzrKTl7OLmVyJEqQooUDv8M7S3f7wRnF
	rgksTRu+A0mB/02f1rNbd36fw6NeqUsC3MscHYO9cl5X/x1qQerDgQN5
X-Gm-Gg: AYBFou2SBqEQ+t4EDkZk1Ob3fskdW1+yxw7DWDADeHgk/mXDYGE9NK887EuxfHlG4A6
	Pi6ZWXz28WlPwLanSn9C2CE2whIEJc1ir0q4urcRp89eWC43gfjqzbhfD7Dksmt03vxgnkbcvns
	uEvghLclmoxDB+0EyoETpPyVRUbWKmX7gyLgxhto/ZpMq2CvxC9U7VRnjkybVrmaIbfjUa3mgYu
	wqUr2tY4ClZwjDeUzOW97hyVWZgtpAX3vx0iMhMXs2OhF9FmkwV+O1cgGRGhs458wDlJ8E1PjAe
	NK4K/ONxtDJUeeUl8lQ6aTJ8s7bAhQGskSzIabnx7pF5LMhnI53iHuAgSJ86d4I3VeXXZuPpq4r
	mb4Iz7/5uDMYuPxGrbT3PyS3MSXkbDRlD/xUbvNvLQ2shvWegypVxfoSoF1vK95fRMKRtXkSx4u
	ah5G9nVSDYDmCEmUm8/SWsrQh4DqrkCpJmj23YXQ/AjK5KuDjxyJKlUIlxK2o9/tdMWIwQkPSDQ
	jAYdbwrvzPtCuj+FDWbGH0JmI9YQ7uZhQgMPABYnoK/dOzyCJJYNkStEBDD6jLmpy/IrvxoCQtc
	FlyGPQsXRaIQyXp/65TCYuNm4sCVfJvdQ1b5et3d1YaeSO1RQVQ8XVcZgwzA+8s3kSZ+ToS9nI7
	RxlPl+zwKehtJE33UfQqEN6WeuQ==
X-Received: by 2002:a05:6a21:8885:b0:3e9:192a:4a7 with SMTP id adf61e73a8af0-3f7a79c5a31mr173095637.48.1794512872891;
        Thu, 12 Nov 2026 11:47:52 -0800 (PST)
Received: from localhost.localdomain ([2405:9800:b901:33ad:cbb:dbe2:bd9d:a035])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1ae8be5adsm839012a91.0.2026.11.12.11.47.49
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 12 Nov 2026 11:47:52 -0800 (PST)
From: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
To: linkinjeon@kernel.org,
	stfrench@microsoft.com
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	icb@fastmail.org,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michail Andreas Michalopoulos <mike.michalo@gmail.com>
Subject: [PATCH] ksmbd: sign the last response of a compound that ends early
Date: Fri, 13 Nov 2026 02:47:44 +0700
Message-ID: <20261112194744.47047-1-mike.michalo@gmail.com>
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

is_chained_smb2_message() ends a compound early when the next command
does not fit in the request, or its response would not fit in the
response buffer. Since commit e2b76ab8b5c9 ("ksmbd: add support for
read compound"), __handle_ksmbd_work() then signs ksmbd_resp_buf_curr(),
which is_chained_smb2_message() only moves to the response of the
command just processed when it chains to the next command or reaches
the last one. On an early end it returns without moving it, so for a
command after the first, the previous command's response was signed
again, over the iovecs of both responses, and the response of this
command was left unsigned. Neither signature verifies at the client.

Handle an early end as the end of the compound: pad the response to 8
bytes and make it the current one. smb2_allocate_rsp_buf() leaves room
for that padding in the response buffer of a compound.

Only a compound whose NextCommand points past the end of the message,
or whose responses fill the response buffer, takes this path. Sashiko
pointed it out in its review of an unrelated series.

An AI assistant was used to draft the patch and as an independent
reviewer.

Fixes: e2b76ab8b5c9 ("ksmbd: add support for read compound")
Signed-off-by: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
---
Tested on a KASAN/lockdep UML kernel based on ksmbd-for-next: a signed
compound of two ECHOs whose second NextCommand points past the end of
the message gets two responses whose signatures did not verify before
this patch and verify with it; ordinary compounds and the compound,
encryption and expired-session tests are unchanged, and the Linux cifs
client works.

 fs/smb/server/smb2pdu.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 5b046f10e2ce4..438f3d29dc416 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -699,7 +699,7 @@ bool is_chained_smb2_message(struct ksmbd_work *work)
 		    get_rfc1002_len(work->request_buf)) {
 			pr_err("next command(%u) offset exceeds smb msg size\n",
 			       next_cmd);
-			return false;
+			goto last_rsp;
 		}
 
 		/*
@@ -716,16 +716,21 @@ bool is_chained_smb2_message(struct ksmbd_work *work)
 		if ((u64)ALIGN(get_rfc1002_len(work->response_buf), 8) +
 		    next_rsp_sz > work->response_sz) {
 			pr_err("next response offset exceeds response buffer size\n");
-			return false;
+			goto last_rsp;
 		}
 
 		ksmbd_debug(SMB, "got SMB2 chained command\n");
 		init_chained_smb2_rsp(work);
 		return true;
-	} else if (work->next_smb2_rcv_hdr_off) {
+	}
+
+last_rsp:
+	if (work->next_smb2_rcv_hdr_off) {
 		/*
-		 * This is last request in chained command,
-		 * align response to 8 byte
+		 * This is the last response of a compound, also when the
+		 * compound ends early because the next command does not fit.
+		 * Align it to 8 bytes and make it the current response, which
+		 * is the one the caller signs.
 		 */
 		len = ALIGN(get_rfc1002_len(work->response_buf), 8);
 		len = len - get_rfc1002_len(work->response_buf);

base-commit: a4277e7b7682540e23334fc927f201e5bb7df5a3
-- 
2.43.0
