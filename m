Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 678113E5EDD
	for <linux-cifs@vger.kernel.org>; Tue, 14 Apr 2026 13:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776175172; cv=none; b=EckOK9sHGl3fmnuLWEOP6DsNneF3IT3pNq5Kv3SKO0n7K66X8SvLVoqMvEXWqZXjp6xKgeTzEXoKISTgsLjQMFn17YTJBDiry7jPUqqv+xmtVVlfgBSe1TjlJq7fq0F7Uv1G4VGveinUqfX9/ZiGK6aYv1r2dNmVJWVUuEje4Tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776175172; c=relaxed/simple;
	bh=0HL5ZEFnxyEbq7XV4UUOrpynXy9ORh0SIFW4oCxfPLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ab+O1dAne39AiXo/3WBLW5Q4Fw2XX0GiH8d//yybobTDAxCWA8Idid2tq719yZagUJ8UL1Wpp2YlVLN2HdWCwVV2uMuZWG4YJm7wEWrUUTnLOj0EQMkZFIkdibtPdeTRGtan/NsDOd0fuz20cp/I32q3/nNTDxW3r2D4aHhckXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JzNxhYC+; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JzNxhYC+"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2b458ca2296so16962545ad.0
        for <linux-cifs@vger.kernel.org>; Tue, 14 Apr 2026 06:59:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776175170; x=1776779970; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KPwOpTfrLZUEPYuYw9st6aLdCBfwnzGfzeTwyPnHP84=;
        b=JzNxhYC+nJ1DGmjQCh8UvcRuS33G/s/dDNb0eIECWrcuRWLEL5y+8h7DBHDwnTv8ly
         IDfoVCExlGrCUeSwMWihBIaYF+x+P4TPvQow4F2VL17dwd9jLCflMCMXEN66FUOEcyjA
         JlgEEO60ut2XwNXiCq+qPnamV/PTly7StkqmzTUYpsRawTyxkGdrdgy+2hSBkUvIl0He
         h24/Qz06a0giTm8PG5wC/8nMqjTkRhoTlszN+AoHAHsFtXC/SQvXDpYtjCzzKi9LVJfU
         XVoiiObBa36mFFDt+1EBefyQL4pErpRetzaKYhkA7EVbpEdfH87Ia1N6cZ0UNRmVNlN/
         zmUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776175170; x=1776779970;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KPwOpTfrLZUEPYuYw9st6aLdCBfwnzGfzeTwyPnHP84=;
        b=HKgqswK+MM8aW99siS9uErUCt+4AQqcmXLnk6H3KcnUKxbPlXUzhruBerZIR5m0ukT
         x24/ss71Db1YeEedxrpllonTi4cAoLAYRi3wOYK/wb+vg1hlp17s205OdlZRQTxSLSaO
         +vtrt+dmg9RCw91fiEWNqoI5tKj6bCbp+8kHxB1jwmcxNnD/uH5AfquWuAibUX+ti6/j
         mcg7COrN1fU6aa3FVmNhntElGuJ3ArKip1pRj5JeffPFkuFHx00ob6DJCsXXlA1U/8Xd
         xY4ejDFfu4YvczOefKuH2dnq3e9jklDHq/Sxkt1V6dYGb6TBANN2hDI60Is0viCB2tR6
         0hqQ==
X-Gm-Message-State: AOJu0YxRbK9R0ZIsBd9PYJ0kRomfvAYirOy2vrhxWZhcuJRt7YZkUDBZ
	hb4sIUWHUhm9EWsE3EsM1PYPT2lap38wVyC8aqykoi9u6XFQ/RPOL6p30jATOPNprb8=
X-Gm-Gg: AeBDievyC054eMU1wvI+0/SBcW3DsZHQOaXX0xx4WR3dUPHPljXJXleFokv4nXJXNqG
	0XSeiYI1UUoYhMhbceo05rY20K6wqgYfmEXvIjEuUFBO/+FC7DoZaaBLTczm66EGqwrwhbqvgVK
	BFNxCJSqn4/MR/CcZLkPvBJ8ifHnc6uiHGsiGeErc7GgQaMLnHdqB01ItfXMiG6tfWwfCrtD3DE
	ZtruuXivrw1oKLOVlpP389BFsysadxP5zisoihaHATog91u9UvVtfsd9NjVSEIM4sLn0c7WvAes
	7Lz7MXyfclcs/PWvhDZVnYskxTMnB/pu1v5HNEL/OHnWPqtB5cxns+qIBT3+KUgpWN5+Spxfi78
	D0VsFL1AaWpCOY+Qiisr+/FkyFVRnLINASMh+HNBJsx6gZIzjH84B17GD06scbGthAKpKbJff+q
	3Zk0dKLD7LLT/aYIMS+0VVXMdb+VMXSjRmJfuju4lkAgSbZtsIPOc1
X-Received: by 2002:a17:903:943:b0:2b4:5f83:a9d6 with SMTP id d9443c01a7336-2b45f83adecmr84289345ad.34.1776175170450;
        Tue, 14 Apr 2026 06:59:30 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.184])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b4612e60dasm59779895ad.38.2026.04.14.06.59.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2026 06:59:29 -0700 (PDT)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	pc@manguebit.com,
	bharathsm@microsoft.com,
	dhowells@redhat.com,
	henrique.carvalho@suse.com,
	ematsumiya@suse.de
Cc: Shyam Prasad N <sprasad@microsoft.com>,
	stable@vger.kernel.org
Subject: [PATCH 2/7] cifs: abort open_cached_dir if we don't request leases
Date: Tue, 14 Apr 2026 19:29:13 +0530
Message-ID: <20260414135918.279802-2-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260414135918.279802-1-sprasad@microsoft.com>
References: <20260414135918.279802-1-sprasad@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

It is possible that SMB2_open_init may not set lease context based
on the requested oplock level. This can happen when leases have been
temporarily or permanently disabled. When this happens, we will have
open_cached_dir making an open without lease context and the response
will anyway be rejected by open_cached_dir (thereby forcing a close to
discard this open). That's unnecessary two round-trips to the server.

This change adds a check before making the open request to the server
to make sure that SMB2_open_init did add the expected lease context
to the open in open_cached_dir.

Cc: <stable@vger.kernel.org>
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/cached_dir.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index 04bb95091f498..e9917e5204b00 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -286,6 +286,13 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 			    &rqst[0], &oplock, &oparms, utf16_path);
 	if (rc)
 		goto oshr_free;
+
+	if (oplock != SMB2_OPLOCK_LEVEL_II) {
+		rc = -EINVAL;
+		cifs_dbg(FYI, "unexpected oplock level %d for cached directory\n", oplock);
+		goto oshr_free;
+	}
+
 	smb2_set_next_command(tcon, &rqst[0]);
 
 	memset(&qi_iov, 0, sizeof(qi_iov));
-- 
2.43.0

