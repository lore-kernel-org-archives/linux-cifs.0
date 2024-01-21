Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D81014A86
	for <linux-cifs@vger.kernel.org>; Sun, 21 Jan 2024 03:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705808011; cv=none; b=J1I/bNNjWPSCCdxYhkdstmB6zOlhobRDQy06lzj7umHR3KINh5oALVHj3Zj8Li/mAoCIkAcIaTMSaO+hLQPc/C0K77mb+2tF9R458vvCpaBJtNhdt01eQKsAnaZ5zAUhMKch8ssXpqq705kJzcwBumQjwERxGZHpFcnarZpn/Kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705808011; c=relaxed/simple;
	bh=uqDbmFSByVvRNeTTZHSXk4I5Gv8FrqP+WbBAk4QwjIM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Xvfm4ad2JFXA3L2ofJWLQzfmn1b3DAJB+H0BHTzFEY0Bqrcaeawi6R2YDfmTU4dVM9oOO0M0Ijqcru2X2x3NK1DGu6ID5U4hN2gYZHVtQ+6/8YSp6kYWbYRS38/DDhsQGzXff3uHrXSP1oyQnXUmx4JkCKYqBebObh0Q2YxfuUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FgT+j4YF; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FgT+j4YF"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1d711d7a940so18109505ad.1
        for <linux-cifs@vger.kernel.org>; Sat, 20 Jan 2024 19:33:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705808008; x=1706412808; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mQY07eVENXJvJY2t9RANhSsCrPeLpydJswtQ+6Z2+y8=;
        b=FgT+j4YFQKzdTOITb3XFfBQS86MYDt7znQmB0Q1qyJXOrAWmCkkiKLhcslHOtmy9pu
         ZE34A5UGkfeY02NUFYDaQjXyqmxJ3tQpwRo1WeHmPyzav4pmr0xD1m5y7gYOuQ6tX9JG
         xD2SNLDqW+/nhoTCfSXKnwlYP8jT37+Dkq+EazeiUWlhypcDGRwB3W/X1ErqHZvSgxR0
         4BZN4kPzKsYBlFd6D3tI1feAia8I8iZd1nSvlUNSxFqUynsnS7qra44/anP9jNtDAidR
         zSAYEUuzs3i52tqETlvADg0BM6wBjYlqK9CoXNkHY2sJopQAj1rCfDz4dAH++ZMwZV2D
         WCvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705808008; x=1706412808;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mQY07eVENXJvJY2t9RANhSsCrPeLpydJswtQ+6Z2+y8=;
        b=kCzrDlhrJWnSrhRgvHquHV14a2DjN1MB3C/YvaxIiKTHlmtIVQtIJGjRdyLRRwjBBL
         fmFhDn+LZJZT7u3LAisTwmiiPgWW9GamQu51ilnsipEXhOVHB5Dy0eoWF0Fky4XTe8e0
         RPdNJmJ2lifOEiS1jaQuwN9+28PvSeubGh07UuY5eUSMzTrWgMmSpqnbPQGNpZzb4I5f
         1ebC00nU9f205yPSEbZkQNvshZs/UXKbm8/mGD4X/TFSqrE4+m8+gTYYj4csF18PNYaR
         v931iMH7sdYspiwU2C4kv8NNVNpisEyF6ihAhYXS/2uuW0uz1t4qu9XWAQpfjmAhnsz3
         IFlQ==
X-Gm-Message-State: AOJu0Yxf9+W3g2f4pPdgSkyLWs5RDDXobD2XLguwCw1p+XWhE3VJlII2
	WzSuz5PZvy4mRMxHCHWL9ATveQ4r2AxBbvw7+uK87y3PoHNAMln8dt0S1gP9
X-Google-Smtp-Source: AGHT+IGxJHMnHo5be5oP2Ov7u8IwstQ/LVfGweLBPG95I3/Pe0vsxLbOcr33g9M/L6s892TTNeVMHw==
X-Received: by 2002:a17:902:ed4d:b0:1d6:ff40:665d with SMTP id y13-20020a170902ed4d00b001d6ff40665dmr2390496plb.93.1705808008385;
        Sat, 20 Jan 2024 19:33:28 -0800 (PST)
Received: from lindev-local-latest.corp.microsoft.com ([2404:f801:8028:1:7e0e:5dff:fea8:2c14])
        by smtp.gmail.com with ESMTPSA id lg14-20020a170902fb8e00b001d058ad8770sm5193166plb.306.2024.01.20.19.33.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Jan 2024 19:33:27 -0800 (PST)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	pc@manguebit.com,
	bharathsm@microsoft.com,
	tom@talpey.com
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 1/7] cifs: handle servers that still advertise multichannel after disabling
Date: Sun, 21 Jan 2024 03:32:42 +0000
Message-Id: <20240121033248.125282-1-sprasad@microsoft.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

Some servers like Azure SMB servers always advertise multichannel
capability in server capabilities list. Such servers return error
STATUS_NOT_IMPLEMENTED for ioctl calls to query server interfaces,
and expect clients to consider that as a sign that they do not support
multichannel.

We already handled this at mount time. Soon after the tree connect,
we query server interfaces. And when server returned STATUS_NOT_IMPLEMENTED,
we kept interface list as empty. When cifs_try_adding_channels gets
called, it would not find any interfaces, so will not add channels.

For the case where an active multichannel mount exists, and multichannel
is disabled by such a server, this change will now allow the client
to disable secondary channels on the mount. It will check the return
status of query server interfaces call soon after a tree reconnect.
If the return status is EOPNOTSUPP, then instead of the check to add
more channels, we'll disable the secondary channels instead.

For better code reuse, this change also moves the common code for
disabling multichannel to a helper function.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/smb2pdu.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 288199f0b987..5126f5f97969 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -167,7 +167,7 @@ cifs_chan_skip_or_disable(struct cifs_ses *ses,
 
 	if (SERVER_IS_CHAN(server)) {
 		cifs_dbg(VFS,
-			"server %s does not support multichannel anymore. Skip secondary channel\n",
+			 "server %s does not support multichannel anymore. Skip secondary channel\n",
 			 ses->server->hostname);
 
 		spin_lock(&ses->chan_lock);
@@ -195,15 +195,13 @@ cifs_chan_skip_or_disable(struct cifs_ses *ses,
 		pserver = server->primary_server;
 		cifs_signal_cifsd_for_reconnect(pserver, false);
 skip_terminate:
-		mutex_unlock(&ses->session_mutex);
 		return -EHOSTDOWN;
 	}
 
 	cifs_server_dbg(VFS,
-		"server does not support multichannel anymore. Disable all other channels\n");
+			"server does not support multichannel anymore. Disable all other channels\n");
 	cifs_disable_secondary_channels(ses);
 
-
 	return 0;
 }
 
@@ -441,6 +439,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	}
 skip_add_channels:
 
+skip_add_channels:
 	if (smb2_command != SMB2_INTERNAL_CMD)
 		mod_delayed_work(cifsiod_wq, &server->reconnect, 0);
 
-- 
2.34.1

