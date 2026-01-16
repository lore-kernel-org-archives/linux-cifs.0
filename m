Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8389918FC86
	for <linux-cifs@vger.kernel.org>; Fri, 16 Jan 2026 03:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768533750; cv=none; b=EwmrvOlWxawUHZT0w0t8AlvvlevicSrck7Tiz1e1sE3fEc25CbLYZ2wW3RNC2Gb7Cmg5pmv2kDAncLCzIno8/6unwyLAlWpRB+Lks4G1xdJ7q95Co/1Jo7Sz7yiS93G2rCzpRv9ltkt0wB7pu0/YmipHqxkj7Z2KSRaVnPp8Oq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768533750; c=relaxed/simple;
	bh=y3b0eFwFnH+FmmwMGh0Dh4hhLm2vRLFJTLLyuupuGHw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=HMnftgi0fbz567kGtzoxK31032iI1/fNRd5jYusL549C6gp+p70za0pHBzRd3QnQZI0MxHS+TPwRJsjfLevqAsjoLuEc/hjv6v97PFHAsPVLWfjb8wir5RMfPRj4M6fzMgSv14ge4HbTtKmLe3vR5BtexIV1fuy3n1HFEA+SYxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=UrV7M9C8; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="UrV7M9C8"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-47fedb7c68dso10274385e9.2
        for <linux-cifs@vger.kernel.org>; Thu, 15 Jan 2026 19:22:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1768533747; x=1769138547; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rFozD146JH0iaQDw6HGaLZDOAz76WWuQGB/BIflepsU=;
        b=UrV7M9C8CmFTObhaU+z2ZvhavKgiX53n0u8+FSwoXFmdMJHOcAvBIT+aSgAzV7Axai
         b8x/ZpOHRj2QKbtDOfrx87KMSHSP1ub05S6Q9FLFVOUn6h0gl+ZmF+NCqNXJl1caCb0P
         wjQybgb8e3nBs+FBhSbV6AX54eU0mnb41hxbnfckIcAq8Wds1CKK4gaskrbJgsPncBid
         /O+2a+eD/r1M2/pOVgeopth3reH2MMQvh60+XM0ZCEUu/k0QI3PlS0FInlvKCt3uH+BD
         8EjNCFeZACA1r9jJPgh6+ajX9gpbabIdhpt9JbtYRbApmApZILvTRS33qhFvJ0gY/Q/n
         UI3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768533747; x=1769138547;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rFozD146JH0iaQDw6HGaLZDOAz76WWuQGB/BIflepsU=;
        b=QUyNVvEW3lvVnsVjVX72exkHxaBVjYqaNnfcTuyXkYRNr/7p9LY4LkZPmx3EIAcUzs
         BplWFIBiL5lWbMq499QtIQfHvVRYHOH5VqmHhwrOTUnOW/9E1YPtohFrnblirzFV0EB8
         OS2Igmmu6JBIv3+Ku/RpdIBht8HVH5tsFydtQOrpCjdtzVT6zRLRW8XTvf8DXqBHCV+4
         0+JRQHgkZTLRYXYI1yAvmF0zNrcU0kF7jn73jYti2Y3J3juJS1ryFUmfBS7G70hFkNqE
         jwE5+OYx4ZhEHaBeEYSpzJsGEB+6UjAQ0/T7QERtCMP+dZS0yHz8HipRGmJM/6tZbdoV
         knCg==
X-Forwarded-Encrypted: i=1; AJvYcCXpnjMe/4AmI5fXWFcPpMBZszymS0lbiDmHbL694ADlIYmcjwZiykcVZ4dfwlBudh2E87XdOeYJg+nP@vger.kernel.org
X-Gm-Message-State: AOJu0Ywib6KeO8Fn4qvKESCCkNr0rb9LPlLyE9Dv1JgMTyYd4CehiTQh
	PSZoABY/WhRa8Mm9FPv4X+4HQYBX/MdSlj5BKNncTux+Y/flyzS+054objTWYfr9qdk=
X-Gm-Gg: AY/fxX5EcywDvrQaj/E2DkC2GMqurgKAuLJPvpT3nV4B5667vVg2I94otCsrY2ddex2
	//31CKo9byddPtbn1d+Fu1X12KQn+oNb8HQVsKmbz4S8tHwKIPMx4augz1vWIe97r4Q00MyE7wi
	w6bmNqIoPiVsCv/K5s9rtemv8CQQr0zQyj7p4M9TfWg2aO01+ezPNWij41PgeFOEm5iBJ6cbyAa
	tI/Y8q2f6NGZTrmOZijF8XT6jBB/U+r1I5NlEDfpaAB0rMDmS8tazPtt54HQWsy1LEhqID5cfsX
	ESazfGqGn54wan27eJprLY1Ox59Z/BGkOSo/oZUHnSDHNzs1dDkkS3bd/3YeBOMAiY8Z1aIj5sK
	uaTXu1zJfvhYYAX8kWqzrQ53+CO0vf2hLr1QRBSgYaEtHsN3gF76sHc4cdCBGeadWe6wFAreQze
	lmKCADm6UJ0yyg5Iq8jxy+5HnxLFmxxTQjaXLF
X-Received: by 2002:a05:600c:1387:b0:477:df7:b020 with SMTP id 5b1f17b1804b1-4801e34301amr19215085e9.18.1768533746866;
        Thu, 15 Jan 2026 19:22:26 -0800 (PST)
Received: from precision.tendawifi.com ([138.121.131.195])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8942e6d87b1sm12576146d6.53.2026.01.15.19.22.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jan 2026 19:22:26 -0800 (PST)
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: sfrench@samba.org
Cc: pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	ematsumiya@suse.de,
	linux-cifs@vger.kernel.org
Subject: [PATCH] smb: client: split cached_fid bitfields to avoid shared-byte RMW races
Date: Fri, 16 Jan 2026 00:18:58 -0300
Message-ID: <20260116032204.181201-1-henrique.carvalho@suse.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

is_open, has_lease and on_list are stored in the same bitfield byte in
struct cached_fid but are updated in different code paths that may run
concurrently. Bitfield assignments generate byte read–modify–write
operations (e.g. `orb $mask, addr` on x86_64), so updating one flag can
restore stale values of the others.

A possible interleaving is:
    CPU1: load old byte (has_lease=1, on_list=1)
    CPU2: clear both flags (store 0)
    CPU1: RMW store (old | IS_OPEN) -> reintroduces cleared bits

To avoid this class of races, convert these flags to separate bool
fields.

Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
---
 fs/smb/client/cached_dir.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/cached_dir.h b/fs/smb/client/cached_dir.h
index 1e383db7c337..5091bf45345e 100644
--- a/fs/smb/client/cached_dir.h
+++ b/fs/smb/client/cached_dir.h
@@ -36,10 +36,10 @@ struct cached_fid {
 	struct list_head entry;
 	struct cached_fids *cfids;
 	const char *path;
-	bool has_lease:1;
-	bool is_open:1;
-	bool on_list:1;
-	bool file_all_info_is_valid:1;
+	bool has_lease;
+	bool is_open;
+	bool on_list;
+	bool file_all_info_is_valid;
 	unsigned long time; /* jiffies of when lease was taken */
 	unsigned long last_access_time; /* jiffies of when last accessed */
 	struct kref refcount;
-- 
2.50.1

