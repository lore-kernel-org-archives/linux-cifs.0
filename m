Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 883132E7F22
	for <linux-cifs@vger.kernel.org>; Fri,  7 Nov 2025 22:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762552989; cv=none; b=PThTn36ZM/EJg1/221r3TrgUngAa+MS3LlViqZRA0bzh0Eho/kq2sKD/0+NRknSkDrpC4gLN9P7d1w1jiGwYvPBBBP2U9XhgkhXoFQQr6hC9bjSk3UAMSHq2h8jj12s7pPbkwLgqzPbWlXLQp0m1B63UyXmMWK7X3cxiEnk8trc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762552989; c=relaxed/simple;
	bh=fO21NbkdQNfR7Mv9J6O79Io7dXowoIYE+qE+u5UBCEY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EHudrvyMmnEqroChWWpe4zfTpKB4hUATXo4AjduRwQiDAK3vNrFHJOAuDeZzdakUZYm9URFl1gQaDtp2BrBmV+D5Xfxblq11E5HumtFpB1uYKa3PqH1EqZ5i/BRZ82WXdSeAkCbyGhcS17vEqOlYXpVj5PAyvCx4aEn6pEV6fDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=MNOMQLJG; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="MNOMQLJG"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b3e7cc84b82so232221366b.0
        for <linux-cifs@vger.kernel.org>; Fri, 07 Nov 2025 14:03:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762552985; x=1763157785; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=kI1EkV1pIyQF8PjpBSc6MpnlpbLKwfT0Jjn7Jf+R9rU=;
        b=MNOMQLJGi3h7DZJ3l4hOoO3F/rYkDXtCTLn09oXtNnJGXQjxaVlJN5QaezyiAH/wo2
         Adt4XlBKZnG3aizhHNmcb+Enc+FjWQOQhhs5sNquF0TmCFdcD3mmRN23kxjiuAuAPGE1
         ruBpHRfBWzKG1Sb8nVQ/ynv1nWhRUBcfNgw6U3RsVy+eAeixNjONT3bNYWPZKsQoyyz/
         UEv+4kMzF+xIYLYYHNNoDA6SGrUK0IbzLF4wohIM9HP5IwOyGWEGf+QO8/d7EuFf04ey
         cRjlrfb8+2tydnGd70XAaF+dmJexAwEmYE5KkIJ8wVBCbye+uwqr21NicZVCkoyYzAub
         hLrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762552985; x=1763157785;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kI1EkV1pIyQF8PjpBSc6MpnlpbLKwfT0Jjn7Jf+R9rU=;
        b=dZfl+QjFwrxJPXnwO7ibBfL7fnDlOtJ6SxsSahGgCbwTDSG2pUQGFNMxYMtbFPqVb6
         KSndqCVoQab+S1YXPcjrLdjiyavKppp6AYV+L7jf+BD6m6THQEPMZ+q92++hoPTNyQyh
         MRCrUedQiZQEgSB32EnDF1hOhBNJRtyhrayQmtqFmAuRG8vcfopCkUq4/pA3NttYnTZG
         eBPgPT7r/1hxHQ3q5S7UHaVo7HC4joqF1SZbhZk1RCrh7CtfY7SZ9NeLhWKScdWLT4Pg
         SkZDM6NnAt7I365S8D0XTb9+TS8eluExI+aUc3KTAT3lY8tMq0kkB9gl95WcnWollAEI
         6q7w==
X-Forwarded-Encrypted: i=1; AJvYcCUFFUp1z2a99eTzrAa/8S5ETD9YFqqqKaCBaAAR7YDJVabfqAY/XWjfFDADJCGsPQOcS3ZZr4Owk3+w@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0o/5kcYZ6SUjQSoPn6Y3WLCxnM/w8st6Fan4DtUq+wDw61KwU
	Uezw+br248Eqw9+pcdY6JLzD9bE9B+e6oltASi3zgcZxzcTMY4gom2AOWz7yCPFP4022+TZTCZ5
	JO4i0
X-Gm-Gg: ASbGncsNCa7aa5nQQ7+L7Uw2ZLd4WR9mD29in2c5OP8yHIjtqzGOFf8fCGY01TCv3Ch
	hkCSeynSEmuqHbeUoQcgZnC14q3ggxY1FZoSlJ2a3s1e/00AII+nEI4bawfMFrHmC7bvgj7SocL
	3r3shkVt8JEC84r84WO18BazOXD7ZVTSnQ/y6gHGpCgJ+al6YIKuwNV9g37zyHKFuUX6iKKsANS
	a4tAwmRjhl7BPzDrBHe/H4lHPOl/Kk4yYT7sPaFHjrC68rAkBaCSE5vJJd3BHkY2K6/unyeL1hA
	f+ZPlM4A7uXnW0VBRnUE4m9CA6cREwjrbOn/3Bt/PPELUkFcqYprKr/EIZ6Q33eq+mlsrkQRsCT
	ppGxQTPZlOtFKNxtxJHODM582Z/pHfBNINiIFKHziiG68+5KRyyySHtlfFUV78GGHKO6QLXITJU
	hwCh1+3IAdr6VF2qk=
X-Google-Smtp-Source: AGHT+IFTNcu5mPFMtGA/nJW7bssU/3YxBhT76QzSRtBfC54AISwg6wpDctXEJHR5a2LwCZ7XpyRdWA==
X-Received: by 2002:a17:907:944a:b0:b71:df18:9fc7 with SMTP id a640c23a62f3a-b72e04843dcmr74424766b.29.1762552984749;
        Fri, 07 Nov 2025 14:03:04 -0800 (PST)
Received: from precision ([152.234.106.4])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-45002752ca9sm2848505b6e.14.2025.11.07.14.03.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Nov 2025 14:03:04 -0800 (PST)
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: sfrench@samba.org,
	sprasad@microsoft.com
Cc: pc@manguebit.org,
	ronniesahlberg@gmail.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	ematsumiya@suse.de,
	linux-cifs@vger.kernel.org,
	Henrique Carvalho <henrique.carvalho@suse.com>
Subject: [PATCH] smb: client: fix cifs_pick_channel when channel needs reconnect
Date: Fri,  7 Nov 2025 18:59:53 -0300
Message-ID: <20251107215953.4190096-1-henrique.carvalho@suse.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

cifs_pick_channel iterates candidate channels using cur. The
reconnect-state test mistakenly used a different variable.

This checked the wrong slot and would cause us to skip a healthy channel
and to dispatch on one that needs reconnect, occasionally failing
operations when a channel was down.

Fix by replacing for the correct variable.

Fixes: fc43a8ac396d ("cifs: cifs_pick_channel should try selecting active channels")
Cc: stable@vger.kernel.org
Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
---
 fs/smb/client/transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index 051cd9dbba13..915cedde5d66 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -830,7 +830,7 @@ struct TCP_Server_Info *cifs_pick_channel(struct cifs_ses *ses)
 		if (!server || server->terminate)
 			continue;
 
-		if (CIFS_CHAN_NEEDS_RECONNECT(ses, i))
+		if (CIFS_CHAN_NEEDS_RECONNECT(ses, cur))
 			continue;
 
 		/*
-- 
2.50.1

