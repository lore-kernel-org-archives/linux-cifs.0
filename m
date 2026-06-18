Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA4D2FB965
	for <linux-cifs@vger.kernel.org>; Thu, 18 Jun 2026 20:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781814942; cv=none; b=d4eQfTJeE76NNINfA0V9i+XEq66kn1DFflJ7vOjAVZogJaFBn0dOiXEwUkEjTJtqE0zGXZliHMsZd7bqkGzVa2K4DdtTYl02PYZpdIr1VJ5Tt5i+6H1JRFbBfr2HA1yU45H+XPJG5wKQie55gRG9AMb/lVAoRwYVqlMaaiwo4XM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781814942; c=relaxed/simple;
	bh=rlNzpkvf5TaB1kuI5D5dZfuSx58VuZ5dYBJMUFiTcbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I3Ggh7eR2IccboKCwLIDfySRLhsdJKf1rXmBJtF6mdawUrV4DJ3VhbmvgNvj33ymiyYck75lH9k+7ncJym2PgaRgRFRyRDIS/ofw5n7xpQva3RzJDbWtc845nwzypGp03m48RBToWUeRkM1SNE8/L0/LnYt+Gjv0+S3Ft59R+Fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=M7qbtCCX; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="M7qbtCCX"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-49230a567a9so7073195e9.0
        for <linux-cifs@vger.kernel.org>; Thu, 18 Jun 2026 13:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781814940; x=1782419740; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+YhBDKclcp9zxleiGadSELRGFuYTxQeocDmhDejXUgo=;
        b=M7qbtCCXVMwhNnn/9u0yEmYnVUABgO6Ld/NnhCubfVz1Xi47yZB8aYe7OLnB+UuX5D
         jQCHk+RpxniS+2VG9VqjJchW9xACvqBwpiE0Ey0tlnoMctELyAO9SXeJ2aZAg9eIrkA4
         d2rSHAPnsvhnZ//ZS4oRz7IsiSuwbkeEy2loqnF6arND/2RowWxcwowFEV5MMiiPjWH6
         eCv2rxSaQcHx4qLsZNsAB+Jp9xwOxaRisFzKkz0dD2ufcapNpL71jHJKI/VvxNe8xjtL
         //oo4dSqA5yUBiFWnAHJHxkqMftVyWRvTXMSdy0ulsyVwq0tnsako7J4Sa4T54dT7XPP
         5Dlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781814940; x=1782419740;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+YhBDKclcp9zxleiGadSELRGFuYTxQeocDmhDejXUgo=;
        b=o0eR/D+iISbbsiH+YpzX25i5BfhStW7n269bHFBA90XVzYlCGcvrkL0YCXxuTTHeTh
         Q7+vU6acltv6Ijb2Pav/xNLQ6dkhpIyYwwKP5lIiRcSfxrC+Yg9YbCDbO5GTVDyUXXvr
         SfX6UV4vJUoIgDrPRCQUf7ZaD1QqNtrM9HQ2q/7qzyHW32+ULTheS4zXcsGCCZmF3HnU
         CKZq0WkfgYjrtoc8E2G3DGcn9f1zU6fYhT8FKM9pedGZxqUDIDMcEnWzpd3dcA68OMHW
         L1pXdLxBmL1SxoGgl3ZBrOYReRnaiaQEQTBYDEL2M9hM2PjywHMnvc9bvusqEo92O1fR
         7T9w==
X-Forwarded-Encrypted: i=1; AFNElJ/bN9moBbeV7ZCNe8xr8Dex61WyQvX2TgNGiE9NziztOPx+utDZ4R9kcRssQoi5Wq/f3JIvLn78mZcm@vger.kernel.org
X-Gm-Message-State: AOJu0Yydeka5IhNWdxBhFdEXhI/dDV82K4OYgozWuyPFt7DQolMIx8uH
	M2lAppnjaAxYTbCb72d51F5KRLQ5E202HrA2Ic7mAF4t5hwaxevcL7eHZHqleB2bl1U=
X-Gm-Gg: AfdE7cmHXr3MFHpxdwUs0+X7D29FtQRSMxceYWh2Ex5HNhpWQSyJ0PHSYgRO+4ZK0mj
	h2L4u3awmMg8y3bGspFVUIOV7KY64V+3DpKJdq7WBq2Ux97mx2rUsbmhfwM10lo7y3R/k6G7QQl
	qcvs0Jumi9MEY4LDgviGEVtAUlllJ0QK9aoJ8xbRvpxI8eUENjWF9bwrzhK+RAquzrRJrvG/G6C
	SWTnZ7netB9nezCuSHF8yY8k801n7g1Vg5mFM9E/ZLf5G7niZwjUNUX0Yy2Itnp+hwqCLGikrk0
	P7rZIahq3bDLOgIXZsBck6Qp0vlTknlqYlPtJBIsvMVbcZNDqoRmfItHC+rAhnH0201/XX/Ctbl
	i/EwLFTPoNDtHRRNTKB6Yg1TnJ080D9QIHpO35vAbdQ8fvtMWNk8hSUkab7lBt9RTbXp+OECbWu
	OGG5cD6DClhX825xbtcaBN
X-Received: by 2002:a05:600c:5784:b0:492:3778:d452 with SMTP id 5b1f17b1804b1-49240e42865mr6663165e9.14.1781814939569;
        Thu, 18 Jun 2026 13:35:39 -0700 (PDT)
Received: from precision ([2804:7f0:6401:b508:d1d9:f1f3:d91c:79af])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-966fc32849fsm439109241.5.2026.06.18.13.35.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2026 13:35:38 -0700 (PDT)
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: sfrench@samba.org
Cc: pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	ematsumiya@suse.de,
	linux-cifs@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH 6/6] smb: client: fix query directory replay double-free
Date: Thu, 18 Jun 2026 17:34:38 -0300
Message-ID: <20260618203438.667881-6-henrique.carvalho@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260618203438.667881-1-henrique.carvalho@suse.com>
References: <20260618203438.667881-1-henrique.carvalho@suse.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A response-bearing attempt can return a replayable error and free its
response buffer. If SMB2_query_directory_init() fails before the next send,
cleanup retains the previous buffer type and frees that response again.

Reset response bookkeeping before each attempt to prevent the stale free.

Fixes: 4f1fffa23769 ("cifs: commands that are retried should have replay flag set")
Cc: stable@vger.kernel.org
Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
---
 fs/smb/client/smb2pdu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 7d4b37b776c5..85642ea992d5 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -5720,6 +5720,8 @@ SMB2_query_directory(const unsigned int xid, struct cifs_tcon *tcon,
 
 replay_again:
 	/* reinitialize for possible replay */
+	resp_buftype = CIFS_NO_BUFFER;
+	memset(&rsp_iov, 0, sizeof(rsp_iov));
 	flags = 0;
 	server = cifs_pick_channel(ses);
 
-- 
2.54.0

