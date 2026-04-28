Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B36C44D001
	for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 16:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777392517; cv=none; b=Kc0Mg98IECqnQivOnKysuoosVO3EmjmuNl8ARqQ+Cjpd05t4wSlGZNYp3tF1yomq5ZA6mBqG+TCgjEvojF7k2Y+rHzj3u9wDjvxBijIruakopqHXc4nQv/mUc/e/5nrmZ/901sQ3ussKg4len/mRlcPkyRA3SbRYkYUBUNZtIjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777392517; c=relaxed/simple;
	bh=cd1aVc8KltC+CUDcrep3mlAszsJrMaOGPYZE+DIthaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cBT1E8kR3q/RQsUJTJvPDVXqNUhlsRgnZDXFtV07UjBxcvuDrbuJECQXQ0zDpSPISXuDxpqkaHcuNpRkc5Xp4jZCedBgciZ4JgKGOYyCE7W/GtqRJgzRyhOqlU//3vCC7mrJMboxmp5GbXdGMmLdnoYuAITCTlnYnAP0wEm1xAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Dcu1c4rU; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Dcu1c4rU"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2ab39b111b9so48057945ad.1
        for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 09:08:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777392515; x=1777997315; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=80fkFcmUjREJVCHsSaKwaXRr41jj+Db13dSZWbgH9lk=;
        b=Dcu1c4rU9bbxOjTn8Iah69wsFmoOTgMBw/CP6TNRP3hpcqz2RMc0hj17/E8QkthWwM
         nLI1r/GBpuD+WUwBUGlbtzeXAFjz8FutusQR5xVzvfEcNbV8tea9AhPvAonplsul1fIV
         Wys8msa0QpBaAHKYOZygk/7yO6TZw83ibGRxRnklzXOQoQUURcKwQrQ9L2UJDFrSKLUW
         kDXx4mIh9A2cCMYfgjfjf2qtrwrgAyMNTEeP2huqt1li4K0ySw2niiR1vt1Dh5MHv2ZB
         kCagpixPn+2lABE9FKPVJS+6bZ4C+OLdI5Wh3XzatJKZGr3oKpp1ALqkHMJ0DQ6JYN/z
         xdzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777392515; x=1777997315;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=80fkFcmUjREJVCHsSaKwaXRr41jj+Db13dSZWbgH9lk=;
        b=UliUwW/4m+1isb4VUwmsWQK+PmQMzb4HIeF2RYf+i04r6phB7eZQaJ2MBxuPv024pj
         uN7+es0tS/56Mi+WU21igi7Z7IaQJ2NdrFBQ/julJhNkDP4LCUpQfMzi+PQqNVwHPka/
         PTRWSoWZEuOgt8ygDBk/QKV5eL64UCH6CikCxjogJ0gwG/EuMPxucnCx7QD74phzhZr3
         7ee+MxZ0Z6P4xLVYNVOM0rCzg2rUR1Bal5ahy7O+2JNJwE3H9irooJJVuzSxtMAEptrK
         WbKXrkO450xKaD/1tG+jAl0dqm/jW/zrR6hH1VcK0vRZ+/EterNUZvisEJLRO+tRdV3L
         xFUw==
X-Gm-Message-State: AOJu0YxRFt0P7ouqNaQJ292O1HcDJFRh2WPKdnBX0aK3x85wPP+SOIBv
	gzy8Srw76vDmRIfy3R6O/8dmn6pE9vpdywttYAbcT9+cDoaQaChbE6ZRNPAqiKW5wfo=
X-Gm-Gg: AeBDievhMxdKkGfqVQewCgZPTkCjQ/ZYIwPLwpnQp22XeENqTQ8RS2jFch7JvzXjS1C
	tEwJi7WUeZxLXGvnOZFoiYpdskm4ZzAFAMlYtgRJjCCzIsfKe/7BvLFQ6PELvlMRFyecfH1cCYy
	CTQHY/V4W5T6SUPglnwfwg4+cxI8PCJerNiX+EzEmtDCMYb+FEDkLSLM+uKiK2cA/yZinXrZt5I
	0NiO31Ljlh+5t5OA0kzy7584IeFX0yiYrWEX8DSxgjiGYC1urY/tRhYiCnQuG8Ov56o/yTrC7hS
	gJ8DXy0APO1xWszQ5VqHW/7jjOTGHIivl+0iCxEM19Fxd/A3nOlSHKZ4AS/9gbcYSDQeqBWff+M
	5frv5tRTYRZo50nKrwYOXp709l8cusXSvM7vJa6O3w+5KMP744I6Q1RS410pgNwAMkt54wBq91C
	OikR4gjCCmtvulDzX6KlBmrYPrL18S0/ppL0aSVfAVNjNRZcAx73aV49Orz2/v3tSMl9XfOwYrf
	MM=
X-Received: by 2002:a17:903:3c48:b0:2b4:61cc:37a8 with SMTP id d9443c01a7336-2b97c452764mr37751685ad.17.1777392514990;
        Tue, 28 Apr 2026 09:08:34 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.216])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b97ac7894csm30864465ad.50.2026.04.28.09.08.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 09:08:34 -0700 (PDT)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	pc@manguebit.org,
	bharathsm@microsoft.com,
	dhowells@redhat.com,
	henrique.carvalho@suse.com,
	ematsumiya@suse.de
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH v3 17/19] cifs: discard functions should not return failure
Date: Tue, 28 Apr 2026 21:38:02 +0530
Message-ID: <20260428160804.281745-17-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260428160804.281745-1-sprasad@microsoft.com>
References: <20260428160804.281745-1-sprasad@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

If discard functions for readv and query_dir return error, the
callback functions can be skipped. This can end up with hung
syscalls due to the completion functions not getting called.

This change ensures that both these discard functions return
success even when discard from socket returned error. This
ensures that at least after the mid for the response is found,
the callback doesn't get skipped, and we do not leave syscalls
waiting.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/transport.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index 1e9e6f3f9a06f..85fa5751781a8 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -1137,13 +1137,13 @@ static int
 __cifs_readv_discard(struct TCP_Server_Info *server, struct mid_q_entry *mid,
 		     bool malformed)
 {
-	int length;
-
-	length = cifs_discard_remaining_data(server);
+	cifs_discard_remaining_data(server);
 	dequeue_mid(server, mid, malformed);
 	mid->resp_buf = server->smallbuf;
 	server->smallbuf = NULL;
-	return length;
+
+	/* Once the mid is dequeued, the callback must run to terminate the subreq. */
+	return 0;
 }
 
 static int
@@ -1158,13 +1158,13 @@ static int
 cifs_query_dir_discard(struct TCP_Server_Info *server, struct mid_q_entry *mid,
 		      bool malformed)
 {
-	int length;
-
-	length = cifs_discard_remaining_data(server);
+	cifs_discard_remaining_data(server);
 	dequeue_mid(server, mid, malformed);
 	mid->resp_buf = server->smallbuf;
 	server->smallbuf = NULL;
-	return length;
+
+	/* Once the mid is dequeued, the callback must run to complete qd_io->done. */
+	return 0;
 }
 
 /*
-- 
2.43.0

