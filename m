Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D93E62F39AB
	for <linux-cifs@vger.kernel.org>; Wed, 11 Mar 2026 23:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773271059; cv=none; b=MwcirUmrHZsmNZT2d8vdY1nO6EQPluZAoQLcbv3CeSLgAwe1SvzusxmaIrB0jvPKVT++EvXcMR4cdopYHp+sz6tVvk4veVHGDYZrB7F3xeMbXa35Y4EG1GifcJhAAD81r3aJ6aACjwS1pj2djmFMKWLWf+g49Ggt//RJVYyJBWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773271059; c=relaxed/simple;
	bh=hP8gUqN7Gejq6lxAh55bb13vxMkqUcjPK6Vq0Lt4/zA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EMFZmLlaw0mw5NrMFIOXLD5Fa6RNl5XL0M+cDITeC2hTlV31ajDiJJJhPpax/8jqTPgnoJKnvq11H6E2QpLWN+/VzQnJCt3TyF7XxiKlJ2fHMtpyhzNoUXSDJDHKYmzpSN3Xjm4YG5TtbE131lr1pUnIrjCQt0jYWdHm49QqrAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=bMVoa1Vs; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="bMVoa1Vs"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4853fd7b59aso2136425e9.2
        for <linux-cifs@vger.kernel.org>; Wed, 11 Mar 2026 16:17:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773271056; x=1773875856; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gKtkJ0sICHIojbLRDenDgLx0yniTaA4WdmAGcAVtIqM=;
        b=bMVoa1VsZXA/42LVDUsWbAjiGH/CgzAtwYUwLOVFq+3nIW12b9omUh6NL6h9RtbbNc
         U19WquqmTLg6CzlYDMT7dI/7kOJO0NC2W5pzRDM5JMzqokIzw+kvaRRkK0sURyFHyy+G
         SEtEp6u5hwx2ODvOT2O9KRonKhqBLTQdWDdsdwj3GqXpH+DFJpgZqeu7C4qj0cOK0Nbq
         Q6+74IP9aukZibZnlFgRoZtQbev6Dky91GFO3D9UFAFr5pNVjGJXAcShZ/IZ1v61KGvm
         D5U8jBYSUzRzv9x3xARiydWL7fFOug6/xdBwacR64HfAiJXc/XWrepGMhfw4+cKOmEWv
         HT2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773271056; x=1773875856;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gKtkJ0sICHIojbLRDenDgLx0yniTaA4WdmAGcAVtIqM=;
        b=FXGZz7IComMnHuLutBGGCMVSVEI5MBUehJbnTKfeKm/FVXp5i6dwUGbL2Sl5wULWkN
         6+4NMxc/zWydrCAUetF4FuCTyDBb/ao9BIARDCDyJjt8sYlDxg84p7MYS+sgwRo0hd5n
         jP9y7vZin6f28R385Sv99imGW35L/YFRNoGq74DdGHeBRcC/B2lGD4oEwf+AbEOA0DZg
         Q41BZlIrbXjmeKbZIg+NoMBz54ONdJohz5INVyO4a/ksBPIca6yRa7qzVg4V8nUp5XnN
         DduPNAX+mDpXgRM2RwqVRnfpjkVEpxkSbnjjFyPf77VmYu036aJ6ICW0j5kHkyTYra3x
         m7kg==
X-Forwarded-Encrypted: i=1; AJvYcCWdK4kcteDRLp/+DO6E5dpCB7ox8dT9KRaaufpyDKW+u9ZR3uj+p+pH2yJUqNswfK9YBMi9evIgMoOs@vger.kernel.org
X-Gm-Message-State: AOJu0Ywqv5544PYOSyOsFnVxYG0PP7ihe70/fJXEDfBXOIopfDBtE7Rj
	2G+irFb97lL/c08Ttix+SNohSPvJbeQF/UBDF9kpsbC16AiRFGufhG5+Rmzm8FMAN5o=
X-Gm-Gg: ATEYQzzmoaXYZFa3f3oz0/aTCg1c8k/P6PdDZeFpBkIVW1JHUdfP9dKFXEa7uMTH3XC
	W6OdlrRmLUZFEbr9hTw79jBnxiHqVY8QOkhYU/0HvV4LaC5ZGmxRgwPIQXV9nmBhH5fo9v79e+1
	EY4A/ph56dAoiWn+acfkmiSuBvok+spO3l511sML/EG96rdJfF3ZuRpqnhHxKQSI/2j8olA6lKp
	mvJcxjc8UeMeXRkGkHITAkLX3fuLRUJ9csW9nnce2LtXPzT4xntd0vASCNrdQnECMzGAcsgMNC+
	rWGwtN/hTFhv+6D8F58ZWwSvGYVi+1mu8lvnsHcv+po8vCSnwHa3jYKntOC3nKcVPrGadpUnew4
	u1mTvApkY5xa77MTMrGkJ1jNMdILYaU4i0eBEked/6tRDNYAqeEZiTwMsoURikipb9Pbmdud3Sf
	MBtfUtz/wICEOIMtm7FLL6KqOJxsR4yqWb3D4BolTP1/2q+RIvLuAFUkE=
X-Received: by 2002:a05:600c:4fcb:b0:485:469f:5320 with SMTP id 5b1f17b1804b1-4854b1319f2mr72608785e9.30.1773271056124;
        Wed, 11 Mar 2026 16:17:36 -0700 (PDT)
Received: from precision.tail0b5424.ts.net ([2804:7f0:6402:b103:6a0a:3e1c:778a:5cc7])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-128e7ce6135sm4758290c88.16.2026.03.11.16.17.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2026 16:17:35 -0700 (PDT)
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: sfrench@samba.org
Cc: pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	ematsumiya@suse.de,
	linux-cifs@vger.kernel.org,
	stable@vger.kernel.org,
	"Dr. Thomas Orgis" <thomas.orgis@uni-hamburg.de>
Subject: [PATCH v3] smb: client: fix iface port assignment in parse_server_interfaces
Date: Wed, 11 Mar 2026 20:17:23 -0300
Message-ID: <20260311231723.751558-1-henrique.carvalho@suse.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

parse_server_interfaces() initializes interface socket addresses with
CIFS_PORT. When the mount uses a non-default port this overwrites the
configured destination port.

Later, cifs_chan_update_iface() copies this sockaddr into server->dstaddr,
causing reconnect attempts to use the wrong port after server interface
updates.

Use the existing port from server->dstaddr instead.

Cc: stable@vger.kernel.org
Fixes: fe856be475f7 ("CIFS: parse and store info on iface queries")
Tested-by: Dr. Thomas Orgis <thomas.orgis@uni-hamburg.de>
Reviewed-by: Enzo Matsumiya <ematsumiya@suse.de>
Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
---
v2 -> v3:
- add spin_lock around server->dstaddr access
v1 -> v2:
- read the port once from server->dstaddr before parsing iface entries
  and considering *server* ss_family
- update the commit message to describe the fix more clearly
- adjust the Fixes tag to fe856be475f7 ("CIFS: parse and store info on iface queries"),
  as the later commit only exposed the bug rather than introducing it


 fs/smb/client/smb2ops.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 7f2d3459cbf9..612057318de2 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -628,6 +628,7 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
 	struct smb_sockaddr_in6 *p6;
 	struct cifs_server_iface *info = NULL, *iface = NULL, *niface = NULL;
 	struct cifs_server_iface tmp_iface;
+	__be16 port;
 	ssize_t bytes_left;
 	size_t next = 0;
 	int nb_iface = 0;
@@ -662,6 +663,15 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
 		goto out;
 	}
 
+	spin_lock(&ses->server->srv_lock);
+	if (ses->server->dstaddr.ss_family == AF_INET)
+		port = ((struct sockaddr_in *)&ses->server->dstaddr)->sin_port;
+	else if (ses->server->dstaddr.ss_family == AF_INET6)
+		port = ((struct sockaddr_in6 *)&ses->server->dstaddr)->sin6_port;
+	else
+		port = cpu_to_be16(CIFS_PORT);
+	spin_unlock(&ses->server->srv_lock);
+
 	while (bytes_left >= (ssize_t)sizeof(*p)) {
 		memset(&tmp_iface, 0, sizeof(tmp_iface));
 		/* default to 1Gbps when link speed is unset */
@@ -682,7 +692,7 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
 			memcpy(&addr4->sin_addr, &p4->IPv4Address, 4);
 
 			/* [MS-SMB2] 2.2.32.5.1.1 Clients MUST ignore these */
-			addr4->sin_port = cpu_to_be16(CIFS_PORT);
+			addr4->sin_port = port;
 
 			cifs_dbg(FYI, "%s: ipv4 %pI4\n", __func__,
 				 &addr4->sin_addr);
@@ -696,7 +706,7 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
 			/* [MS-SMB2] 2.2.32.5.1.2 Clients MUST ignore these */
 			addr6->sin6_flowinfo = 0;
 			addr6->sin6_scope_id = 0;
-			addr6->sin6_port = cpu_to_be16(CIFS_PORT);
+			addr6->sin6_port = port;
 
 			cifs_dbg(FYI, "%s: ipv6 %pI6\n", __func__,
 				 &addr6->sin6_addr);
-- 
2.53.0

