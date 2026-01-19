Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A05312DE6FC
	for <linux-cifs@vger.kernel.org>; Mon, 19 Jan 2026 17:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768845322; cv=none; b=DSitekU4i1k7qX+AMZ9B4HapWMSWDs8RGFLNEmEh9X6n/TRUn4bhKldOt8bFxpD8PBOyaCllQ9vMuwY51TdmwCvWB9jJ9jtaTMatPVR+U2aiEcILOrOgpO/oa9N3ztu6Tnl9CN9KFa0DZc1vsGboXp/glcgpiUi4CZmhb00dnFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768845322; c=relaxed/simple;
	bh=43nn79Hs94Ljp7Sl8Wsdqu6rCT3iShIZw6YMLukYev8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ULz2DcP304cbncxzopxmoANPF6Db8RibCf0xeKXgMl4oEJzxTY5kveEiLxUv7dIJ4G3VvcZX0EU9wSFJ8jfcWSm4uNkGRclKLXQ1Dv2w3STgZkOTEz2p4wOApII2ZQTcXNk5dbsNd7IoXhTvficRiqn2LSn3Te+GLz0g4eK85SU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=c2AaTphi; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="c2AaTphi"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-48039fdc8aeso3849505e9.3
        for <linux-cifs@vger.kernel.org>; Mon, 19 Jan 2026 09:55:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1768845319; x=1769450119; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HCoIMDd3EjeyRhViBCt+hHLPkU+uin3ABseJF+5sjWc=;
        b=c2AaTphiSfAxeZ+Sjs64F1ax8Raach9msHxy7VFt+jtV9zK0hoxEr17tS1rWe9dc7p
         B4GThTqxEgoCyiy8EXq27Oq2+PsUW/z6XObw70d/+I7upJII/9lhZweHboBBFo8PGgUX
         ds5FDgxmtpQzPvAjyq0QGzhbYunPHjRD4zZH8wlJuC0fKY/T2fdg8hL1/Kkl8ouBvdXg
         7sU1mjs9/Jt8cC/p4XwwPBqFx4CVKX43T2uE1oDuUkUzZUaUjua+LgMC7BfgJkkqkL8Y
         9TXcMCpbU/Ixm7FFb0XCyxgFK5rGPHVnzJbXX/m8cWvOghc2OpbpKq5FrZ0dvs8GL5PP
         zj9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768845319; x=1769450119;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HCoIMDd3EjeyRhViBCt+hHLPkU+uin3ABseJF+5sjWc=;
        b=DS7ID3jLEPsYdqiol//3eNyukl5AZ29ktPhrzF1Uh6F2y9EgUXqUwHEOD1cfNuDovF
         sKLrPgqH2a/PYUhtSsRHtQCn6BnIbrbSfRXO6CSg/2huV1C2pSLkydT7RTMzcjsfgXop
         dpIzqIxaPOS+c0uzNNZpvOz+ZX6R7YqkOl94vMis/qQgpxEed3Nr7j2iOLaSQQxQBAjJ
         0hjnXNJgAAK6DAKIZ/XiXqbPCwkP70BxA4LTxAjIkdRaVuhgu+zSY0OetDD6akuY8lDb
         TyIbJslhaOC4ciQ/MQnU1AzCKQfeM/HeDPMyretRjPDjNOJE9NZNbyqt4WSGlrtr6P8+
         1QcQ==
X-Forwarded-Encrypted: i=1; AJvYcCUmxqivF3Vy1qN+o1cUS42n6kPIwmaoKGKUOq8aLp0ewMV4v2Y9aRjLrg2p/HWBYWRouDuAmjU5aRaU@vger.kernel.org
X-Gm-Message-State: AOJu0YxpDSep2Yb9lmHegPP8WAUj3N/1naYQtVRj+4RTDBoK+9f5Miy8
	JQe4XTNLx9GqbewNbNX4tNdoz6FTWU4JK7GE9vFaFCcJe5XX32MVJOibpONsD3vQamo=
X-Gm-Gg: AY/fxX5GcWLWgqktOLcyI+6XF4OHMVJRMHhFqKfxUGrcL9nuCUadB2QnnGkKaTbgXii
	l6SRMdzl1k7AGbvbJza5CJFs2i2rRWD1LbYPXkLkPLEjaMc3OouqTb0mwg0xtYXD7O14pS97Z3D
	VNwgw/2nkI5JsIKXw3fWdwwjewsdsQ+2eaLUqSqpGhXgMmTs1Y57g4MR06JXxVGqUip8rusCOM5
	XNZTMhsRLDA1qcf9feQgzbwVKAR9UM+wWt21GZB113OCWnvJ85ayMejONNqYsVW1tQ1Rkdj90zI
	D1AfhfmEBQ5dgjGabYJIJNbernTOBUtO8lb92oww6GETYiSEQmZciDdGcnsRajgEYg2gvyuAfml
	wTu4R1glxKoF/rPapud7BWYypLz9bjnRDlzC5Ah0wR2A7jzQhZk27Fca4DuY/8QX59UgEwkHgJ3
	uP+PUKZ88OfoWrrEZI
X-Received: by 2002:a05:600c:4e50:b0:47e:e946:3a59 with SMTP id 5b1f17b1804b1-4801e3503fbmr153654785e9.34.1768845318932;
        Mon, 19 Jan 2026 09:55:18 -0800 (PST)
Received: from precision ([177.115.55.201])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b6b333ccc5sm15045595eec.0.2026.01.19.09.55.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jan 2026 09:55:18 -0800 (PST)
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: sfrench@samba.org
Cc: pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	ematsumiya@suse.de,
	linux-cifs@vger.kernel.org
Subject: [PATCH 1/2] smb: client: prevent races in ->query_interfaces()
Date: Mon, 19 Jan 2026 14:54:44 -0300
Message-ID: <20260119175445.800228-1-henrique.carvalho@suse.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It was possible for two query interface works to be concurrently trying
to update the interfaces.

Prevent this by checking and updating iface_last_update under
iface_lock.

Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
---
 fs/smb/client/smb2ops.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index c1aaf77e187b..edfd6a4e87e8 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -637,13 +637,6 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
 	p = buf;
 
 	spin_lock(&ses->iface_lock);
-	/* do not query too frequently, this time with lock held */
-	if (ses->iface_last_update &&
-	    time_before(jiffies, ses->iface_last_update +
-			(SMB_INTERFACE_POLL_INTERVAL * HZ))) {
-		spin_unlock(&ses->iface_lock);
-		return 0;
-	}
 
 	/*
 	 * Go through iface_list and mark them as inactive
@@ -666,7 +659,6 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
 				 "Empty network interface list returned by server %s\n",
 				 ses->server->hostname);
 		rc = -EOPNOTSUPP;
-		ses->iface_last_update = jiffies;
 		goto out;
 	}
 
@@ -795,8 +787,6 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
 	     + sizeof(p->Next) && p->Next))
 		cifs_dbg(VFS, "%s: incomplete interface info\n", __func__);
 
-	ses->iface_last_update = jiffies;
-
 out:
 	/*
 	 * Go through the list again and put the inactive entries
@@ -825,10 +815,17 @@ SMB3_request_interfaces(const unsigned int xid, struct cifs_tcon *tcon, bool in_
 	struct TCP_Server_Info *pserver;
 
 	/* do not query too frequently */
+	spin_lock(&ses->iface_lock);
 	if (ses->iface_last_update &&
 	    time_before(jiffies, ses->iface_last_update +
-			(SMB_INTERFACE_POLL_INTERVAL * HZ)))
+			(SMB_INTERFACE_POLL_INTERVAL * HZ))) {
+		spin_unlock(&ses->iface_lock);
 		return 0;
+	}
+
+	ses->iface_last_update = jiffies;
+
+	spin_unlock(&ses->iface_lock);
 
 	rc = SMB2_ioctl(xid, tcon, NO_FILE_ID, NO_FILE_ID,
 			FSCTL_QUERY_NETWORK_INTERFACE_INFO,
-- 
2.50.1

