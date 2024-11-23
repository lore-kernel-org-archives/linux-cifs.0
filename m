Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A3FC2F5A
	for <linux-cifs@vger.kernel.org>; Sat, 23 Nov 2024 04:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732335451; cv=none; b=sllsUFG2Q3X1pQ6nWrUny4x3IQAJU+3fBPVNdz4apBpM/2eNuB0FxEnsjsoIOTq8IVotGV8T39KiopkuH2gVc+mPLIjEiup6fQgBtC6QlCa4wy/CczPbuqiH09G25YqYVBwBjhX2gjH5YsAa2IDogXwM8gIN1xgT6FP5cE+vFwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732335451; c=relaxed/simple;
	bh=vtDD94taRJVz7umoL58jmGAGvtjPOyC5J+sh9uYujr8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=J+h1VWemi4vpRZ/RHENtrP5bACuU90kCIJjTJKUs1ZcXrVPl5uvaMULmlyNRPgC/HbbBU9pn1VULxA7aOPl/9q3Q6xvLo0Ife19n/mxMEQDRnliKz6a8Kur8aDorw6QcA3VSBTZjNysHqk69/8gdhsxaWCpv/g0lyb4JFQbunEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-724e1b08fc7so1271394b3a.0
        for <linux-cifs@vger.kernel.org>; Fri, 22 Nov 2024 20:17:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732335449; x=1732940249;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=61hZmkrwIDZcFv2rjjEIlJLgIJemKfgpT2QsJ/H1eMA=;
        b=W+Eh1aJBEfAW3YT5sa2fg+HRGSoqgcazETYarH8cY0ojdhChAs/YRKLIS77o1aiETo
         jkOJr9xnXqKz6IJ65XRUtTdIUhaTeXocoMn3wLwG6J0sPzJWEKcsHEXunK8xGeDWY3mI
         o48JFJBUMi1F9do/50jA1se2otZPyNeWOuyU0IFI7EsZfYpJioLA4805rtwP5r8ql0SF
         L9aMOcDH0CLzpgNgPhj+LPUXCXKZOG0etl9w6TBcnXAZQpBOsslav0UUWz3ChfhfVOHN
         4bwm2rulGQj3BxAhIKGEFJJOGSU2bi/HJo+8XCjQbllBcyiFK7J+FSwgULAVNYN9ZgvF
         Z7HA==
X-Gm-Message-State: AOJu0Yxv1CZJduyPz3JVsbTf+wWNWygt7LzZ7hKMZZDkRBsIR3hSpdhE
	1EXNrwSO+aJN3Hy/ttmv0qJxoKWEZ4oZePlEnil14xZs2Ei7mWsWObiCwg==
X-Gm-Gg: ASbGncu1hQueCahj/2EKvb25wghs1AABl6qWi0dx1xDDqcM2sr00xm4cmbRAiICG34e
	qxqeUWfddz0PPz09S0dimC0GclPD/XZQfhhOnqfkFqyougdjX8tIFxxDYgCk+1BQvcmCxQ2E+6o
	xaIC7gyFK1Gy3clfbjqZ7696CRHxdZOg7z+wDFfVIQFxrEfy4gPnwnrzHsjbUoX9ekrZ+SvhO3o
	SpNeMsMs2fCC8+R6aTdKg/42+bz2SOwh6eT+PqmwJMuAeGG9QbEDYVfH9hx0tze
X-Google-Smtp-Source: AGHT+IHP7Ksm3jck7gp2lerF/NZoliTnjv+awDXk2DY3uQ//eDLEY/eDDctO3/MF7J43LRUTXV9W7A==
X-Received: by 2002:a17:903:2349:b0:20c:8907:908 with SMTP id d9443c01a7336-2129f81ef81mr72212235ad.44.1732335449311;
        Fri, 22 Nov 2024 20:17:29 -0800 (PST)
Received: from localhost.localdomain ([1.227.206.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2129dba20e2sm24437805ad.94.2024.11.22.20.17.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2024 20:17:29 -0800 (PST)
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 4/6] ksmbd: add netdev-up/down event debug print
Date: Sat, 23 Nov 2024 13:17:04 +0900
Message-Id: <20241123041706.4943-4-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241123041706.4943-1-linkinjeon@kernel.org>
References: <20241123041706.4943-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add netdev-up/down event debug print to find what netdev is connected or
disconnected.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/transport_tcp.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/smb/server/transport_tcp.c b/fs/smb/server/transport_tcp.c
index cc77ad4f765a..0d9007285e30 100644
--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -521,6 +521,8 @@ static int ksmbd_netdev_event(struct notifier_block *nb, unsigned long event,
 				found = 1;
 				if (iface->state != IFACE_STATE_DOWN)
 					break;
+				ksmbd_debug(CONN, "netdev-up event: netdev(%s) is going up\n",
+					    iface->name);
 				ret = create_socket(iface);
 				if (ret)
 					return NOTIFY_OK;
@@ -531,6 +533,8 @@ static int ksmbd_netdev_event(struct notifier_block *nb, unsigned long event,
 			iface = alloc_iface(kstrdup(netdev->name, KSMBD_DEFAULT_GFP));
 			if (!iface)
 				return NOTIFY_OK;
+			ksmbd_debug(CONN, "netdev-up event: netdev(%s) is going up\n",
+				    iface->name);
 			ret = create_socket(iface);
 			if (ret)
 				break;
@@ -540,6 +544,8 @@ static int ksmbd_netdev_event(struct notifier_block *nb, unsigned long event,
 		list_for_each_entry(iface, &iface_list, entry) {
 			if (!strcmp(iface->name, netdev->name) &&
 			    iface->state == IFACE_STATE_CONFIGURED) {
+				ksmbd_debug(CONN, "netdev-down event: netdev(%s) is going down\n",
+						iface->name);
 				tcp_stop_kthread(iface->ksmbd_kthread);
 				iface->ksmbd_kthread = NULL;
 				mutex_lock(&iface->sock_release_lock);
-- 
2.25.1

