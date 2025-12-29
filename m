Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15707330B09
	for <linux-cifs@vger.kernel.org>; Mon, 29 Dec 2025 17:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767030784; cv=none; b=rwI16jb3BNDJKpfYGs5jfeLBdX1bjvHsxo6ug+0XCZmZsCCivqqmXKojnZy/wSZSDipShnBvkqozeedpyBjEEni0ZSDBTvA7MyYI+rwgeDVi+FcoGnGEQBdLd5lVtll68a0mTA4GTxi6AgQ2NNNm9hXR7sL5LjC02/bYDTK9CRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767030784; c=relaxed/simple;
	bh=+pI6xLEmP6bXRe8o5LpV8U3MAC29YDx7NYnH3HBLo/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Hcnl06r0+NkA7HebN/muAy8llUCKUff4dV/o3MzCYLwN7Qwwwx2w2TAEBxXyOkxYGfzz96mvZ31wh5YUNf0ei+O1ws4+R5VuzNZD/vuYvXmcUSdJRsmslo4hY0jbD2hAjY9CHA56eGt9p97bgudlByecw3SYX0h/wRjJMaNPPOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=IPCDnv1U; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="IPCDnv1U"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4779adb38d3so60882555e9.2
        for <linux-cifs@vger.kernel.org>; Mon, 29 Dec 2025 09:52:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767030778; x=1767635578; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Lg1jtrb2AI963EYpsge9p5JD8TRck3oSpQDxInvSiew=;
        b=IPCDnv1UcnwyD3tOawB54/RNIIvdIzst0smgsBjtzNrnM60f7BMj5bbs6ruKyQho7X
         7bwmyKV165+tBRF1/nu9svnrni0mvhJQVBZ6v892jvaHcf1BPT4oSi10p7ItKeJvGugU
         O9T39oNvwgfOp2j/uLBe2EeU7E9LKlqqRCtii0DzBBr37LjjEWYfoyiuAIdh66El9sEo
         StfvVMX1DS90r9l3NjM+SeMZtt3AfADSLcGodtarrSeASPDu0/nfwc4TDFkLBU3iysJG
         RQLRL701FYi6GWz3V44n35BiHF+wMyOxm5WwVxM1ZFto06KR8SsTSDaVV7s+DIKohQ/X
         a8Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767030778; x=1767635578;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lg1jtrb2AI963EYpsge9p5JD8TRck3oSpQDxInvSiew=;
        b=PWXjhjUuj1phTpyIzY473cUdicdqXjL0BVzqa7n5B6FFo2aU8V0S8RTlZmLFcP9IU9
         aPMvrsEZVvkLHzDV9fvYzg757ftH6WkMtvXactMREvCJ5qkIdXy5PCj+UN/YJvtkpgiN
         k+OXDar9ZW6LhdZ5zjK2LIlbKFhb8n+AHTncb2pwXUQJQjXVLnRdFRsLaLcOv/fsnpuP
         edMHr+Nk34nNT195bZBKKaEMjhTppLF/UfzJamUEWT8oYmvkXOHQSpPwXcCYGYgbAEVV
         /zbPxUAxEBHHcZ25l2ga/LhXoKI5p8Surfu9GaJvDjbyo/0LX71h9TEUI+J5TkRRHzVj
         FFzA==
X-Forwarded-Encrypted: i=1; AJvYcCVmjOd0NEKaljOhoDCaz1QuMAQG2iGAWQuYCz3t+meNRmLrZJkdQmufW3/ccUrMMeo0YPRW72d4ZY7O@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1NtVs7orxmuVzHgCAOxmbVVR/TumLclvGYM/lcYGqz+vZCAXy
	ZqTcUtT1rp79WwUsd1KuCa7U+ghHgXEkUCyhmTssuglcotXi0ERKmf2t+meXVn8l1YU=
X-Gm-Gg: AY/fxX4jpeIbc1mF/z+J3+qVvRNzAqkIDPOfEOmghC64ZoNhWksP+WHTR7SWJohkRZj
	WDSVMsk0E89QCBHzYcKcuk2l4s/EwKIsm7UMl3ti4xl/iYoMHw1yFrL59PbP9xEUXDn1eNXNixN
	l3CNIC/FitTNKPeCeJNDenpipCiWH8gGGJJW2BMpYO5vR49MVZTqEcGvWPJIwuKKFgF2CcPR0Ut
	gzy7zbQgBD4dDzAFBgBJ7AIFR3YZ0h96fEy8iKThVIQltLZyAxCaDDJigx/jbr7PrR0PjQhjoOO
	l3Hp2czT5sXq0GPcK/9MEE7Lstz4Zvo54dmCrCYIFs3xVnNhgsfguPPySdIG2AensUrIc6RThhq
	NGtRQ2WcQpKKMcjyHkAvcvAvcsBEgHHiaCEFiALu/5FqFqgeEmIiouqoD7G4KVVsrUdRxH20+Hc
	LOnEWqTLhSHGAdcd1a
X-Google-Smtp-Source: AGHT+IEkw/JKIbI/DY/zrK/Q54NC6F7GItnSbYxLcqVgEnhHKCjCm7APG41wgxnMm4Wd7D8PpyICRA==
X-Received: by 2002:a05:600c:c8f:b0:47d:3ffa:980e with SMTP id 5b1f17b1804b1-47d3ffa9d47mr177116145e9.28.1767030778415;
        Mon, 29 Dec 2025 09:52:58 -0800 (PST)
Received: from precision ([2804:1b2:1845:dd80:7c23:54c:2a4f:cf03])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-121724cfdd0sm119144282c88.4.2025.12.29.09.52.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Dec 2025 09:52:58 -0800 (PST)
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: sfrench@samba.org
Cc: pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	ematsumiya@suse.de,
	linux-cifs@vger.kernel.org,
	chenxiaosong@kylinos.cn,
	Youling Tang <tangyouling@kylinos.cn>
Subject: [PATCH] smb: client: fix UBSAN array-index-out-of-bounds in smb2_copychunk_range
Date: Mon, 29 Dec 2025 14:49:43 -0300
Message-ID: <20251229174943.49814-1-henrique.carvalho@suse.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

struct copychunk_ioctl_req::ChunkCount is annotated with
__counted_by_le() as the number of elements in Chunks[].

smb2_copychunk_range reuses ChunkCount to store the number of chunks
sent in the current iteration. If a later iteration populates more
chunks than a previous one, the stale smaller value trips UBSAN.

Set ChunkCount to chunk_count (allocated capacity) before populating
Chunks[].

Fixes: cc26f593dc19 ("smb: move copychunk definitions to common/smb2pdu.h")
Link: https://lore.kernel.org/linux-cifs/CAH2r5ms9AWLy8WZ04Cpq5XOeVK64tcrUQ6__iMW+yk1VPzo1BA@mail.gmail.com
Tested-by: Youling Tang <tangyouling@kylinos.cn>
Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
---
 fs/smb/client/smb2ops.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index a16ded46b5a2..c1aaf77e187b 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -1905,6 +1905,12 @@ smb2_copychunk_range(const unsigned int xid,
 		src_off_prev = src_off;
 		dst_off_prev = dst_off;
 
+		/*
+		 * __counted_by_le(ChunkCount): set to allocated chunks before
+		 * populating Chunks[]
+		 */
+		cc_req->ChunkCount = cpu_to_le32(chunk_count);
+
 		chunks = 0;
 		copy_bytes = 0;
 		copy_bytes_left = umin(total_bytes_left, tcon->max_bytes_copy);
-- 
2.50.1

