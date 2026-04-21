Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 515A619F11B
	for <linux-cifs@vger.kernel.org>; Tue, 21 Apr 2026 06:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776753613; cv=none; b=UUeRDMWzkNwvGzK7HaYi1D72qGPB9eJi1H6+rkMAS0tQM5V8QBAJjhDmYX8eiUJnccfYzZPjxvR38EaedUQYtWBhnVqv6qhFqC2BQnrD0hvOCGBCt5L1Y2e2A7G7ydzjCLWp9VUyEN/e5+FF8rt7uzFEKV6DXKC2mH4weiyhN/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776753613; c=relaxed/simple;
	bh=i7moRks1Em5xSeDJRGmHijtRZlYJUx95CBNBVmpOReA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZAQD2qPTuvH282CHxOGHIw1uu9TMScs1+CmXkkFVV+g/n47hpZxwGX+yvT5KWyH1ixgZ/LJjm08s73tGY2j+gpfQlwDnZG3LrHlqMlX6ck8gM+BtkmuhXq19G36y3+ztFfdXDfV5I8mhy/h/1JP8MaUnWAeHe1b4ML+yAoUdrQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BUiY2fy9; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BUiY2fy9"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-c795f441ff7so2736938a12.2
        for <linux-cifs@vger.kernel.org>; Mon, 20 Apr 2026 23:40:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776753611; x=1777358411; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=AoTQHgaXiOjxnBKbofO+VMkVOBU/6hoNuKav6Pyb85M=;
        b=BUiY2fy9uTBBU5LqkCQV1ct5ht+GKS6JFM80TjK+tkEYYj/FHS6TJ2fN4oPf/NsL8v
         ybjt2ZErZ8JA1evLFGkIXHQxYEMzmw0UG7t1ZoQdD1vzKfyqlBUNMGOUbmmWHYtLdrKi
         ZoCQrOoMuYEAecNDkuzuAn5VcrS7hLl27fQ6oRnS/9MmZt+KoG5EBGVYs97gdEp8oQPq
         YuaEEyYnx/AZc9A3XzjohK4MixEgEwgdD422XqFE6ZdK0lWjPRtyysqVi/Ev7aleOXln
         3DjUqhiD9MzUC6zfQ9me4SpYy/07z7Sd/4Wf++JE3pd1cTWEUla9tQTk0D39AGRbtmN1
         /sFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776753611; x=1777358411;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AoTQHgaXiOjxnBKbofO+VMkVOBU/6hoNuKav6Pyb85M=;
        b=Xg+wAxSjtIeCmznqLbEwR1uCj2bZGD6dDovxwMkEZbnuSqS3yBUSTcjaMejAhbufLE
         PFXtzZspMKp25KReMpRsxfoCG74fEWI+9gkLkXTuBFLHS/JW2PHy88XVpmLVrNGZiWFU
         8z36aK87wQpu18xdGwP8UKn0E3+MVrOMFLeb8O8NgOMeAenjGeiSMChS2ndlUnzpTqC/
         BzypcnDom96Nx00yysGQksJ7q2lQDPzkyaj110BPoYXVTQeZQWX8K7qowJPMZU74OUsc
         zz+1ao6KnYLb0leOQEkK3iwFlmX+Hpa385CSIrhW/torSRL3Km0EMLKuWDq1KrgZBpIN
         ExBA==
X-Gm-Message-State: AOJu0Yx0lXstO1K4Nhrs3PFfXk2kMIyqt4GA6zXbDRfsCi6I89ug4Umc
	84sM86pzaIiPyVdSLjYwpoXODz6wXnJ8zmR26nu9srt1QQW8O82u5r9HMrJ21YxQ
X-Gm-Gg: AeBDietmiukTam3bTstPOjr3NaF5hX6rslrU0Sj/Mu31dfdE9nuwZjABc93E9Xb9p+/
	K4m6DHDd0FUBfGz6yzlZs3U2cWXHmZMrRy/7JVHp6L94YWj5dRtmcQWTexmywSYdZsYl+MgiGNH
	0swLqHQDPXZJpuSEUvZvOhywle0eEbtGk426nAlgLi5XkE3EWLE4ODR+gNHvw4eYRrEC6KeatN/
	t4C+NB6PsihA67uVguGyrkioWrYvFkT9/V1LUX12tW5CHlDshuoaWPBAaR8XbdKaKqT+0VSvaU6
	TtcMzOK69RfbpIfNUcwqF5l7U+H9J86o0/sFfVtpfGlOq5eN2VQdq6Y8SD7DA+ZO2uD/+3FjoiA
	xoCDUVGnwumjKS/5BIFH6VkdQxfytCxvxJz14lvJTdt2GGJlClCca3HPu6DPN3qrpZYlvxthgGb
	XB2yl1oGp+NIjQLGlui/mzPIku1tQ2FXdnA/2Gd7V6VlM306sgxDM/c/kh6HoG85GWfayNdFn/h
	Bw=
X-Received: by 2002:a05:6a21:e082:b0:39f:2dd0:65bf with SMTP id adf61e73a8af0-3a08d8d9a7amr17966685637.28.1776753611314;
        Mon, 20 Apr 2026 23:40:11 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.184])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c7977031729sm10032811a12.25.2026.04.20.23.40.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 23:40:10 -0700 (PDT)
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
Subject: [PATCH v2 1/7] cifs: change_conf needs to be called for session setup
Date: Tue, 21 Apr 2026 12:09:49 +0530
Message-ID: <20260421063955.99164-1-sprasad@microsoft.com>
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

This change enforces calling change_conf for the last session setup
response, so that echoes and oplocks are not disabled before the
first request to the server. So if that first request is an open,
it does not need to disable requesting leases.

Cc: <stable@vger.kernel.org>
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/smb2ops.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 509fcea28a429..3625030d1912f 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -111,10 +111,19 @@ smb2_add_credits(struct TCP_Server_Info *server,
 				      cifs_trace_rw_credits_zero_in_flight);
 	}
 	server->in_flight--;
+
+	/*
+	 * Rebalance credits when an op drains in_flight. For session setup,
+	 * do this only when the server actually granted positive credits (>2) so a
+	 * newly established secondary channel can reserve echo/oplock credits.
+	 */
 	if (server->in_flight == 0 &&
 	   ((optype & CIFS_OP_MASK) != CIFS_NEG_OP) &&
 	   ((optype & CIFS_OP_MASK) != CIFS_SESS_OP))
 		rc = change_conf(server);
+	else if (server->in_flight == 0 &&
+		 ((optype & CIFS_OP_MASK) == CIFS_SESS_OP) && add > 2)
+		rc = change_conf(server);
 	/*
 	 * Sometimes server returns 0 credits on oplock break ack - we need to
 	 * rebalance credits in this case.
-- 
2.43.0

