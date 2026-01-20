Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 595B31D6DA9
	for <linux-cifs@vger.kernel.org>; Tue, 20 Jan 2026 20:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768940317; cv=none; b=dK9XV9iSAAaD0GY1wpCWbXsWhQjbzjIhPlmYiW53VY9xyzuDA/XRTC9tZeopQPrxHI6FUMW+WahG17omuhyH5vTHY/g3mkEG/CAf/eoP6LTQF2PMwC323KPyYbGm89nOBmXVvCsc8bfiIfEpln4E+YNhSpMLIkxz5Y1cjL8BgQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768940317; c=relaxed/simple;
	bh=yBxT+m83nb9w1YbD2+jmfMP2icuuejMufFTl4ndUXYA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eG4TIrsKY7Jo7RL13lRnKcl/pVnXBUIPvSHxdcLfL8Ok7ynq+5bR6uTWy/R+QOan3kpCbAB2bcvMvVdsxyF2FQ33NH60NnLEJK4ryGZiWIiFZKNuBHs1IuaxK2ecEZeI/2itfvGHtW52VtHdWWOlPX2a4be5GTE1DMNdKfsZYBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=BcMpE5Au; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="BcMpE5Au"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-47edd6111b4so53396605e9.1
        for <linux-cifs@vger.kernel.org>; Tue, 20 Jan 2026 12:18:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1768940313; x=1769545113; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=oIbsA0Loih7BP/Jtm/8EUYOGygDGkj0hk4PtQDvPBdA=;
        b=BcMpE5Aug9MMk3r5aV+CWD/jJoVQm+zOUCHeEJeEg5oUyiwBIjoKjs4wqoxE4SL7nC
         F0bZDzdi6kaHY58yHSX8OVLjllwzBSYLXANi+f2vQciUOI0y7NhX8Bg1niUGR7XaSK0l
         oKoxwyE+0J01JiWhQtygNjwQLlx57SHzMvBAcJVFoTtySTYq3SkneV1pgcHBnyKGkjhZ
         w6brO6EKiZoGdMK5C4jHGlV466+0C7DDNe4/F0RFqJRmipVefwLdP8KvKowyrhX6N1s9
         Cx4Wulf1lGNr0ighnl63BhttZ2AHnBn2RYT17si/aUvc8FZotZxLFE7uexlYLllCKEoB
         TUIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768940313; x=1769545113;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oIbsA0Loih7BP/Jtm/8EUYOGygDGkj0hk4PtQDvPBdA=;
        b=TGXxEUqTYatzvLLQVCH0NC9fZ0EctV5p6b/v0J/E5pFag3GVnkXf/LlQDU/DBPFpo8
         wRHgaybmnSc0c/OikHy5dpEdkpW1Y4m1hCv3BC/New9T/LCucKv1G7VQVjkgS4WgPqk8
         5iSkXYyZ1rodivpeTkyCf7i5MDlaHTboSGdsaGDSVUDL6RVUmsXxWIHk0KhLediELNnB
         yq5O3aFzOQaRONEl8UxUacZBzGWhNntf1Q49E6KROa0rzN7TVrgLkMaQG9y06ykHMYZB
         F/qx9PLSFIJ0aUMe1wDOyuX+lHVpabA/7mJDqtwbsTWZMoQr0FRPuHlCH/tPmqQquon6
         rMKw==
X-Forwarded-Encrypted: i=1; AJvYcCUGQg0b9fOPF9N2UW/aQrvJibSdPgptRRlgD+4lUjEEgjAfSOXhTkAeoWrz5Z19PViP8DIeA9qb85aL@vger.kernel.org
X-Gm-Message-State: AOJu0YxVBvAy0+jDrVR70SRjW5UhL9M5i8Ja2tEBtRPiwD6hA/qcyYdO
	KWaKf7vMlZRbpmzpc4p5vDBJi6lj2XcfkOXMlHAhEWvnxDS6rx79vI8Rvddw5t8UrHIPl2nvPNm
	Gj07r
X-Gm-Gg: AY/fxX5anDXLMbHjVdkdgKeAdC0L137dockADhKFVk/UBJzmdqIctRIhh/ArO7svQI8
	YpKM3yOfQqEr11vT1Y8DOmVkJ2ryOF7fXVNbZinsp+MAznm3dy+lyPD+6xZYduQsVQIJEVkXxPg
	0RMKKO3wuT5rZXQscdabuB7uGUdpfaj6YzuOGNjYP2fV+HkXTbQFWsRQt8g/T1UhyovSXbc0HNF
	NiKxV7ih3i7AKa/l8QWZ8KI1lHDUueqwnZ3njBbVZkLOfHGmDhNy/PT4cdXNKtXlOUo4iuGNCIe
	sZMjzcuA0M1J1Tc2Jclhy/dk8Z5Rt9E58VSWY1TxCjsia05nXxkLGP6r6vI37vvyvTEwIsqhsUW
	xyuDLuKuC64CX2M1M3B6tW/feaZy5yH/ljhNBlsAXQTmUlwqTT3gc7ULGxQ22OMwjfL8PpVk9zt
	321mYmzG9Ur2C7HUYq
X-Received: by 2002:a05:600c:8705:b0:47d:5e02:14e5 with SMTP id 5b1f17b1804b1-4801e2f057emr171947805e9.5.1768940313380;
        Tue, 20 Jan 2026 12:18:33 -0800 (PST)
Received: from precision ([177.115.49.199])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b7093325e4sm2041281eec.28.2026.01.20.12.18.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jan 2026 12:18:32 -0800 (PST)
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: sfrench@samba.org
Cc: pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	ematsumiya@suse.de,
	linux-cifs@vger.kernel.org
Subject: [PATCH] smb: client: fix cifs_pick_channel when channels are equally loaded
Date: Tue, 20 Jan 2026 17:18:22 -0300
Message-ID: <20260120201822.2218308-1-henrique.carvalho@suse.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

cifs_pick_channel uses (start % chan_count) when channels are equally
loaded, but that can return a channel that failed the eligibility
checks.

Drop the fallback and return the scan-selected channel instead. If none
is eligible, keep the existing behavior of using the primary channel.

Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
---
 fs/smb/client/transport.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index 75697f6d2566..26987f261850 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -807,11 +807,16 @@ cifs_cancelled_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 }
 
 /*
- * Return a channel (master if none) of @ses that can be used to send
- * regular requests.
+ * cifs_pick_channel - pick an eligible channel for network operations
  *
- * If we are currently binding a new channel (negprot/sess.setup),
- * return the new incomplete channel.
+ * @ses: session reference
+ *
+ * Select an eligible channel (not terminating and not marked as needing
+ * reconnect), preferring the least loaded one. If no eligible channel is
+ * found, fall back to the primary channel (index 0).
+ *
+ * Return: TCP_Server_Info pointer for the chosen channel, or NULL if @ses is
+ * NULL.
  */
 struct TCP_Server_Info *cifs_pick_channel(struct cifs_ses *ses)
 {
@@ -850,10 +855,6 @@ struct TCP_Server_Info *cifs_pick_channel(struct cifs_ses *ses)
 			max_in_flight = server->in_flight;
 	}
 
-	/* if all channels are equally loaded, fall back to round-robin */
-	if (min_in_flight == max_in_flight)
-		index = (uint)start % ses->chan_count;
-
 	server = ses->chans[index].server;
 	spin_unlock(&ses->chan_lock);
 
-- 
2.50.1

