Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D776926ED59
	for <linux-cifs@vger.kernel.org>; Sun,  1 Mar 2026 02:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772333001; cv=none; b=BoDguhBIUIJeEGApl+En2Luh9OBGnIU34zWbQNIpIHU4oz/5q83JDZG6FaEn0DQQgp+b+uxy/ZAOaZKjGpJH38nre2qKvx2jtRT4nrzOerlml3u6/ThEktgjiAhuUxjzEcXOSeeIVoKB18hIQ4LYCLzSLyVV8G3gwSOKPKW4RM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772333001; c=relaxed/simple;
	bh=StiYaJg5TnIgR97jqI7sw8c91dqPU9OEJIf6O1a7rcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D23vrBJe0Qr7ZvYTZxux4TIa12PDbXHOrM2RwmBqZRPb9Kda1/7XaKr3Mu6V56k+OuuwwW6+GrM63mA9zT4faswPK9+KOFtqHS8AeDjEtZY7mgaCxUSfQ2wVPTCU+lLhMdGKgFO4jKd9YEpW6fvsDujBUvZRrnRT8BXjOrdvBew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fk+/fKfa; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fk+/fKfa"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-c70fb6aa323so1092443a12.3
        for <linux-cifs@vger.kernel.org>; Sat, 28 Feb 2026 18:43:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772333000; x=1772937800; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k/4+K7t1AmwyZhD8tmPo2E9QsgNK7fdWts0ll2jiHOI=;
        b=fk+/fKfadFRQ7MYgVDN1VuVfl4regnAJCFFnKsnVI6r492dj1JHXFRU4eg4nF1DnfX
         Yejzn8vJxjB9ZRgtAQM6GbRb0H5XgmWZk7XhDfs2CEUFjNExW2nQeOnOdG95VvIA92UL
         mbfZDSpSfP+g/sXHSgCK6xRxdgYXcUmT9fc6kJv9vwn/IsqP2GNTyIhsBw0/fSXiF4fz
         P17VaME0dRXVtQeQIRiama8JI8O+jWqqxq8GGRFKr/81fgM7D+mS/TCjXyDPJDTUNVdN
         vAEwp+EeCbW1EGte+BnFhO6V09fE+E9mOqsN4noP8ILIRhWi4zBKgsb1EwThyvmWjzMS
         MMiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772333000; x=1772937800;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=k/4+K7t1AmwyZhD8tmPo2E9QsgNK7fdWts0ll2jiHOI=;
        b=SO8e5gVjNZ66Izw7RKB+qX0v5Np0IwpauBcswrBKJN59czQHw6wAcdDypSPmwMfI0W
         DRs5SLf67rIyawOpF+x/f3RXILd6oxHASWYZJ/A0riJQmsJ4jkqqItJQyxNOVp0pG+PZ
         /Ds8cZEoUnk5pQeWSW+R4/Xv3Nk8gyciRiNhAz4rTX7Lj2IAD9Eer8tQv8SNWHJF7ATT
         1YgD/oCorVHeSU1EWXo3ZImUtgjUwyoB+NtjbvlZCbf6yMdggxJW2J4IAfCuMo3+L6Z9
         h21sz3S0D78L6PFo5lxKQAcdLPeTcCIpQ3C7+lSlewJnfuAhezKayjD289qMjeXh+yaY
         i+9Q==
X-Forwarded-Encrypted: i=1; AJvYcCUCkNi0OEwR6fhca57Loe5z6AtEFUr/cU0Jnl6dfjy9VMS3JZGwbgEn3dRBw3Y2kqKhNaKB7EOKt4my@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4eFAZNFcSEPHnXY5k5RaWW+NRK2h/ubg+1lF4LPLbVb80F2wn
	5l4XkhlYHTLmQt6CwZM0xQdPT4wZXKM6did0WS7gKsARXQp7w5IV1/xc
X-Gm-Gg: ATEYQzwUIm3YFSspI5mFWjOMaIrNexzo/dCSpOmBP8BZNODwFaseq36HB7lpl46bWKm
	T9acqzcxmMadKsWnrmmqfBIW1EQmlr4/8R4DQ2gU+bcKOa4pXRHilBPSbLT3Z9RhE7OQohCcAZ9
	PcHf8xf74NbCIL4zf4at7vl21DUQJ3ae1TR2HW4+4Obu7+IIwxYB/cGfKknD178jeiW56bvAe6g
	Eoo3aN7KtOTHJBtq4iSuTKLMzROfEuq0S2D+17Oqx/gSCWwtafYtE3dJsWZ7pdC7Z0ia2T3iQPK
	01KG2gqJJt8eYT1XQu8weV8y1RwEtu3Z6csXyxifP7o9V6OFHl3zE60lAVe+YH136PHsViOrg1q
	1tMpQ+4G/ee//3ICBsDoPlXO8Qke97yCJH9drDaSah0EmTOPWg9ynqpZ103hcOqnx9XrepDT87k
	kZMT/TabmAdkC49PfxSgWsVPidaRLxnOFnaink8Cf2l56vhWdyH0FnBAM=
X-Received: by 2002:a05:6a00:b42:b0:81f:9c54:65df with SMTP id d2e1a72fcca58-8274da052f5mr6154918b3a.50.1772333000173;
        Sat, 28 Feb 2026 18:43:20 -0800 (PST)
Received: from localhost.localdomain ([222.109.75.221])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82739d55216sm9299322b3a.11.2026.02.28.18.43.18
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 28 Feb 2026 18:43:19 -0800 (PST)
From: Yuchan Nam <entropy1110@gmail.com>
To: stable@vger.kernel.org
Cc: sashal@kernel.org,
	sprasad@microsoft.com,
	stfrench@microsoft.com,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Yuchan Nam <entropy1110@gmail.com>
Subject: [PATCH 6.6.y] cifs: some missing initializations on replay
Date: Sun,  1 Mar 2026 11:43:08 +0900
Message-ID: <20260301024308.80078-1-entropy1110@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260301013911.1700044-1-sashal@kernel.org>
References: <20260301013911.1700044-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

[ Upstream commit 14f66f44646333d2bfd7ece36585874fd72f8286 ]

In several places in the code, we have a label to signify
the start of the code where a request can be replayed if
necessary. However, some of these places were missing the
necessary reinitializations of certain local variables
before replay.

This change makes sure that these variables get initialized
after the label.

Cc: stable@vger.kernel.org
Reported-by: Yuchan Nam <entropy1110@gmail.com>
Tested-by: Yuchan Nam <entropy1110@gmail.com>
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Yuchan Nam <entropy1110@gmail.com>
---
 fs/smb/client/smb2ops.c | 2 ++
 fs/smb/client/smb2pdu.c | 1 +
 2 files changed, 3 insertions(+)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 138b3ed..4239b68 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -1147,6 +1147,7 @@ smb2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
 
 replay_again:
 	/* reinitialize for possible replay */
+	used_len = 0;
 	flags = CIFS_CP_CREATE_CLOSE_OP;
 	oplock = SMB2_OPLOCK_LEVEL_NONE;
 	server = cifs_pick_channel(ses);
@@ -1545,6 +1546,7 @@ smb2_ioctl_query_info(const unsigned int xid,
 
 replay_again:
 	/* reinitialize for possible replay */
+	buffer = NULL;
 	flags = CIFS_CP_CREATE_CLOSE_OP;
 	oplock = SMB2_OPLOCK_LEVEL_NONE;
 	server = cifs_pick_channel(ses);
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index a8890ae..595f043 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -2850,6 +2850,7 @@ int smb311_posix_mkdir(const unsigned int xid, struct inode *inode,
 
 replay_again:
 	/* reinitialize for possible replay */
+	pc_buf = NULL;
 	flags = 0;
 	n_iov = 2;
 	server = cifs_pick_channel(ses);
-- 
2.43.0

