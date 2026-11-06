Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793962205;
	b=wjtAJRKbHoibkqT8ZVftp8dMJqDYwVs9NBUQ+LFS05zjHgld/zJzIpqMAnRqtVyhjlK/
	 U1ynGaiu5qayYK4p67bNrn6mUU32BR1vnodauDTNh9h2UZdguodf+Vv4s6SIqpz/6sQgQ
	 k4MrOb7+ckNwfGbtotn9ggRCKAfaUaNXhPTORLzQK9UeKzpz/LXbUIUaAXX/jXk9cN1IQ
	 cKXvc6o/wSz2uC6ivhonXFZvsE4X+sO7QQetbGgETRoQ8vkbI4XMB/j1sSrYutDF4aQjx
	 h0MLVVD3s3TEickpJdIbTULzt0fdKzvH0dZmlCDW5H76vllbVg9j2C13czhXzJgJ6iw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793962205;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=QahgxAOniDGOjtfpZ1n4Ry8HYxG8g0wBOjcAHvQSKfo=;
	b=bdkpwgZzwO1Em1ZrCGbGt/nJadQqUbGZ6c5VwbNk14ZezSlIP/fiIATWcslNxSYkI9/G
	 QHmFAlQYdayk9LfuhORQzlWm6tDga7ozPoYy1M6KFZ/A2Of0XEjFv98rDCKbuAvR/2Vqv
	 8wCtZ8a/m63v3BWL27VJ06lq+viC9IFtkzGRZ6P+qG5H88pOe2nK8uff6JtN73YrtQsVX
	 e6ZMWyHL9FVBRvRyW69jcLbRagkRxY23gunpm9MGHs1qE1/ZyZIQJm35Ft26rKJpujYcD
	 qQQJ+FJ/za0I/pB6/nbKZr3qKK/NB8l1N93akPBHSYPyl/euHmPB9CsWTzRqjA2nSjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="LFlV/hVZ";
	arc=none smtp.remote-ip=209.85.215.177
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F09A606A33A
	for <linux-cifs@vger.kernel.org>; Fri,  6 Nov 2026 10:50:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9F09A606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LFlV/hVZ
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-cdb760113d5so56685a12.2
        for <linux-cifs@vger.kernel.org>; Fri, 06 Nov 2026 02:50:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793962204; x=1794567004; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QahgxAOniDGOjtfpZ1n4Ry8HYxG8g0wBOjcAHvQSKfo=;
        b=LFlV/hVZYEZRbLURykHsMu5EENfHzqIIeLZj6/7bnWet38E327WCVVzH8NkrNU4E4J
         QtkEmEehrOE34q1jTu9gLw4kz/ZZ5I2O61J2taEQZ+0QjBfGoeu229EjAj3DSoqfbjkL
         +id15aPMbiPzuQEgZCHIJalOV1rBs4QV0V7oJ0yia0vXHbfjrGXe1CKtVhIk56kM2wl4
         ZOXDpvUOW+J1RoCHtrdx7tB2p0kDNKrzgyxE+zkbkbhFHGWiKzMVS4CgNQEygRhe/mnm
         O94uGlLjgWT2t9OXpxTyDFEkuZW1MnVGw66ounIbkcZqNCJtqglMY0g2hnaBr2xv5yXD
         Frpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793962204; x=1794567004;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=QahgxAOniDGOjtfpZ1n4Ry8HYxG8g0wBOjcAHvQSKfo=;
        b=Qq6j5C7tHHvYIprtxr21QcNruNDtNMPMbpaO+bv66H0lUadUplMgF29Jqz4kjmK5fa
         4na5bxATygwzFjHRbNuAXPuShkkMgFLwWCqI0LZS0dnKiqQmX0UKQ0Cj7w8Wt3kMmAhH
         Nc3YFyj3lZXePOeqCbbQWgSQOyN02v3fGjFpI6sOdsD+GaY9/XWUypfPipgcoGFNYdxG
         RBSoQJTaZB6SXHR5u7OePrTBdU/JLac0z4T/ZmkmpOg3fQGSJHtZ8HZ2HUa0OQG/e32+
         HVECYBZiidkunn1+9KRFp0WS4hfaMf3EQKK1x8EYuzFfvrtoYobpUAsk7sYjKHMVVoFr
         jbrA==
X-Gm-Message-State: APuU4Z+/3+aBcMiLxWR/jIwp0x+pR+R+YZRNL5wVhS4YygswOOYA0jPp
	ZzWQKEzA9Os82tVSCkK1PlmAwcNbDVuA7bjbnUmVxvYWQTINwr9gW74H
X-Gm-Gg: AYBFou0oOAkjksSTiJG/sbvBNScdINRyWX7klEtx4A3tJL+YOKM1dehCFVJNB+K6PIW
	Q6mtD+VBurk6XONHNOqzzuwzZn8Qd0Z4ImLx4VqxnD+LB5A5YZnS4S/6/JOfBDQMiLP07ChWjZC
	AaLHAP5IRfxXEH++XULGVo11IHx36k1QZK25YOWjbr50TpQeiqa4Fg1cM76sks7VnKlH2xtckbv
	0K1QDJE7/yKqM0jXSMLf2tbGho+J8AUk1nd4k/mH9D7JdkZ6g7tU0RZ1lWdKRSBWsxN38Y0bGj8
	46orvqiTnORgiqETKplII7ZvZUFp2LzG29Or3Fz5t2dBnLRdzVyQe+6q9CmBe0Wr5Y/6qtLGqYZ
	xaC6kazQb2Rx8GiRpUMhzcGkkZEpl2wg2fgcBMEKOQo/7tkCYsH6BRUmz4p66eP5bpWqFko2s8l
	jLshwAzwUioGJJ0FsHDVfvPS0gMH6je+221tYlUspl9WWEtZ5ntiMVIrnr7wMQMnz5Lchx5ycSj
	QV5onqRr62P+snPkc/McUzDdlLSQZRkE0sIbi3UXWKSksI/bSyAmPY5/txWgw4QV63vbWSbDe1y
	OpFLRdqeRbwD7Ai/ILAQRQq6skTylgB54SZrFfCndw==
X-Received: by 2002:a17:90b:2786:b0:3b0:9e2f:cfc7 with SMTP id 98e67ed59e1d1-3b0db6febbbmr1956273a91.44.1793962203947;
        Fri, 06 Nov 2026 02:50:03 -0800 (PST)
Received: from localhost.localdomain ([183.62.176.219])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b0d7c8a3d9sm3747364a91.10.2026.11.06.02.50.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 02:50:03 -0800 (PST)
From: liuyong <pkfxxxing@gmail.com>
To: Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	security@kernel.org
Subject: [PATCH 2/2] smb: client: compare owner and group SIDs using their encoded lengths
Date: Fri,  6 Nov 2026 18:48:36 +0800
Message-ID: <20261106104842.441067-3-pkfxxxing@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261106104842.441067-1-pkfxxxing@gmail.com>
References: <20261106104842.441067-1-pkfxxxing@gmail.com>
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

populate_new_aces() compares owner and group SIDs over sizeof(struct
smb_sid), including storage for all 15 possible subauthorities. Received
SIDs contain only their encoded subauthorities. The comparison can read
past the security descriptor, as shown by the supplied KASAN report for
a 44-byte descriptor during chmod.

The input SIDs have already been checked by sid_from_sd(). Require equal
subauthority counts, then compare only the fixed SID header and the
encoded subauthorities with memcmp(). The count check ensures that both
validated SIDs contain the number of bytes being compared.

These issues were discovered and fixed by Qihoo 360's Tulongfeng
multi-agent system.

Fixes: 0f22053e811c ("cifs: Fix unix perm bits to cifsacl conversion for "other" bits.")
Cc: stable@vger.kernel.org
Signed-off-by: liuyong <pkfxxxing@gmail.com>
---
 fs/smb/client/cifsacl.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/cifsacl.c b/fs/smb/client/cifsacl.c
index f9f61c758..e420943bd 100644
--- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
@@ -1134,7 +1134,10 @@ static void populate_new_aces(char *nacl_base,
 	 * updated in the inode.
 	 */
 
-	if (!memcmp(pownersid, pgrpsid, sizeof(struct smb_sid))) {
+	if (pownersid->num_subauth == pgrpsid->num_subauth &&
+	    !memcmp(pownersid, pgrpsid,
+		    CIFS_SID_BASE_SIZE +
+		    pownersid->num_subauth * sizeof(__le32))) {
 		/*
 		 * Case when owner and group SIDs are the same.
 		 * Set the more restrictive of the two modes.
