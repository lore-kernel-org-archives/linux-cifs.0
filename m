Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FFAA3A5E7A
	for <linux-cifs@vger.kernel.org>; Fri,  1 May 2026 11:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777634434; cv=none; b=EhO7+uJTTXyENBe4OUOudj/xjqQUuF+ZGx8/OoFgYjfNtsb2vXToroGngVZEojXvKByadk3bvzHOiFl6n1lwMUBY7KHK6WFgadNY6XBUPXq8YUZOPEpwY1OduKoBs7pkuSVOMqPaqHSJlzR1FoXujCb8eBEelQWXGDXVRZ7QO/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777634434; c=relaxed/simple;
	bh=eG9ghrqyHv+FTgYWiTsJuJFnXKn0gQTXBQyL1yWQTYk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Nf2OIqcQhLQY8IiTxFsGhqr7jAWhmXOgR2iW1Up2tY9l+C1kzf/50R/ElTOAhqRUqQ/WESY/pi9tYsX6vEgS9IBGE/PBvNJHhnxkaOEw04N1JLNkaYC5lmYaTUch+il0z56SydcaBbAJWHPsx1ft7E1ZkixeOGBrJuhtEUp88s0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZV8e87Cs; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZV8e87Cs"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-82f69adeecbso825266b3a.2
        for <linux-cifs@vger.kernel.org>; Fri, 01 May 2026 04:20:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777634431; x=1778239231; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=k085XqsDoPGBdb9RzNl+RVKDoAd53m9lIegek7QU+Yc=;
        b=ZV8e87CsC4UZ+ujPnUqB2ExeeFuHE4clcfW0tjgp6E7xmL7RETu2shaVWEOZNhsrGc
         2LZhBGUgopqMeZhTWchV7iaWSAtlonuuZVLe2/3H8hksgmWtlnjysc6mS1v4ouGk2Qll
         OjFcXwAbq1llOWoPIm3KgLlnbEzqw4UeCBsqIUSNKXqMa4qUvG9tc80v9pxqeXB5W8uU
         62d+YI6brUWjcmEQVQCfk96IjvZjVLZaukheNvwgUyf6kgWeB7mhuVtJHIdrfyd3raB+
         J/v6l+K0CFyF6opmOv6nYim1jkCHgnNQSz5CCfBkUH8gqPmm/WuUAa19jXjREz90qpwZ
         vp9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777634431; x=1778239231;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k085XqsDoPGBdb9RzNl+RVKDoAd53m9lIegek7QU+Yc=;
        b=NhpxuZ91SLtCEHxKgSfCcjkUCF9TUYcYhKjOJmVl95+EFsL/YVP/gybqno0RSHrMRA
         1CowzFxGYYqPzm+xuUUuM/Bijf2WVtrZWNR4ysXZk5yAlgtKNcfTvTNZXv68smXA8xS0
         20apQ4Kfe0Qryk+ona73uraXW0ughPc6I7ndc+ue/t9zY4baPaEoa+7W4Zsyg1uKsIHf
         nm3YrlhTheoChKcrs/G3er5xl3iG+1LQqvkqsp33nNYY4wboTKK6Q32HljbVPVu+l1CF
         ilaXO/CKZcGkNikkWY/sl+SRQDxGQqs7brkyvKaD2J7UrpnXem7mzn23ALn7rBHgYN2w
         OhQQ==
X-Gm-Message-State: AOJu0YwU695EZmdKADRpScOFOp6Vfr2dNjkpKcXt29ujhC2Iv/p7fHu2
	wVVKAGvG7Epe4vmZhae1KOFwAoh4keNnaYhKRlRtm4AJDg6oZmkk54KyOIraCM5tjek=
X-Gm-Gg: AeBDies+HASG9KT0Wk8N9Waj+tNw2IbC0DPmEPaiqiOk00B/XzV3KrkdNnqxBSq3oy9
	1zOjKkhgH85fHioh74sMByw4IMnEyVWnxzj1x6LJoP2Jo8AFnfQrgBEhmWnzClnxlvNSdwpdt4H
	P/JT82vmcZmNQHv2Y1INiuOYUr/qQaO1kPkS0Lm47340yfqvGtdItVGnI0s0rDQL0RgNsdGekUC
	ULpnnxCTva06QlysJ63FAY3BeWPsy0hhNm8FOMl/K1USy/nHNt9Tkv5AYkzicF5VBzoUYbRzPEx
	1uNSji24W6zYvHpEb7L8AWnoHtND8Z/x1JNUWfNx05CLrU2SymKOT0pWHFVp5NcxmPD9rzuCVQE
	+pRAHBCZGNpNq3j7Tbs9UNTrlneq2/UvQlgxKXasnxjPUvlHDqqZ/QwESPgvDLAEEPUsn3CervH
	Xx+D4bH46VnyUXE9j1t1VUX6LPSmDCWBFtuF5Ols0BtRk9IV60KNNUo2y0zjBfzPBUIp8ZElHoU
	1Q=
X-Received: by 2002:a05:6a00:ad88:b0:827:3914:f130 with SMTP id d2e1a72fcca58-834fe200ef0mr7412087b3a.36.1777634430884;
        Fri, 01 May 2026 04:20:30 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.216])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8351587db67sm2331922b3a.13.2026.05.01.04.20.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2026 04:20:30 -0700 (PDT)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	pc@manguebit.org,
	bharathsm@microsoft.com,
	dhowells@redhat.com,
	henrique.carvalho@suse.com,
	ematsumiya@suse.de
Cc: Shyam Prasad N <sprasad@microsoft.com>,
	stable@vger.kernel.org
Subject: [PATCH v4 01/19] cifs: change_conf needs to be called for session setup
Date: Fri,  1 May 2026 16:50:04 +0530
Message-ID: <20260501112023.338005-1-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

Today we skip calling change_conf for negotiates and session setup
requests. This can be a problem for mchan as the immediate next call
after session setup could be due to an I/O that is made on the
mount point. For single channel, this is not a problem as
there will be several calls after setting up session.

This change enforces calling change_conf when the total credits contain
enough for reservations for echoes and oplocks. We expect this to happen
during the last session setup response. This way, echoes and oplocks are
not disabled before the first request to the server. So if that first
request is an open, it does not need to disable requesting leases.

Cc: <stable@vger.kernel.org>
Reviewed-by: Bharath SM <bharathsm@microsoft.com>
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/smb2ops.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 509fcea28a429..a9d68e5fcea91 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -111,10 +111,21 @@ smb2_add_credits(struct TCP_Server_Info *server,
 				      cifs_trace_rw_credits_zero_in_flight);
 	}
 	server->in_flight--;
+
+	/*
+	 * Rebalance credits when an op drains in_flight. For session setup,
+	 * do this only when the total accumulated credits are high enough (>2)
+	 * so that a newly established secondary channel can reserve credits for
+	 * echoes and oplocks. We expect this to happen at the end of the final
+	 * session setup response.
+	 */
 	if (server->in_flight == 0 &&
 	   ((optype & CIFS_OP_MASK) != CIFS_NEG_OP) &&
 	   ((optype & CIFS_OP_MASK) != CIFS_SESS_OP))
 		rc = change_conf(server);
+	else if (server->in_flight == 0 &&
+		 ((optype & CIFS_OP_MASK) == CIFS_SESS_OP) && *val > 2)
+		rc = change_conf(server);
 	/*
 	 * Sometimes server returns 0 credits on oplock break ack - we need to
 	 * rebalance credits in this case.
-- 
2.43.0

