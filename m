Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2374014A86
	for <linux-cifs@vger.kernel.org>; Sun, 21 Jan 2024 03:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705808019; cv=none; b=QCbnJtntxeci9vYNyqYVt6sSQTWTgJZU2h/HZd0KULkfnhbmPVVapvDYeVFP/dir3C9ot3wfWoPaYtH/5s37DG1GGszs9Sd20amNQ1GLhB/AwZZXHaUEbaPeAnUBk6LEjh/N7he7JD0dsZ6akJpHf2Mfg4OfJU6VRmCmRfdSKnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705808019; c=relaxed/simple;
	bh=i61PuFh/wQd+kXhI4UUBpYJWFFE3nBkckJ8tFi9JYHw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Q6yC3gXDYQliBjh5VVj8KzxHJ+rVWcNOFRmhjhhrQJfPkTG2Oue4Jcnf3h9JhcPHXwSGxQYrhndgoKCtU3hF0R0M2YHvvsvfSlmHKtuOYW0F4r6kqzswvLw2xWxBpu7JvM1NGCFJd/iuemxBVg+54zsHPITl8hYSdGLkU/dtY7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PIveEs13; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PIveEs13"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1d50d0c98c3so24948655ad.1
        for <linux-cifs@vger.kernel.org>; Sat, 20 Jan 2024 19:33:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705808016; x=1706412816; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EST9085IKoYTHTEDL2YdtVvlycK0/tJ49SC7HqvCQM0=;
        b=PIveEs13IVHDNqzEYR76bYbPFh1WniZKUR5zwRy9OZ0f2Bo2U9TDGQ1xoNLhpyvC/A
         hRFRBMK+Vf1A5KrtCpiCeLx7Ej84K9AWOk+Gu5AfIvw1prm10EOKN2giMpaGeKoY8d59
         cQ/ofyzBDcyRycLwkrlZHCJCWZu0a5s+JXi9ZS3BDj6z4QkieErG3GrD0+/8lgu2XGi4
         CRk2QXhroKSnGyMMTxyQ66af9j5w2sCYWpkjFRw0wQOswU+/9NogObLXZBLaznAg0Y3z
         nUKLcxEHQumz8KkKRAD8CDhzEyLt5hYxH96PvWTcK6FErzfUnesdzt2UpRC6QIMiIHBU
         r3kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705808016; x=1706412816;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EST9085IKoYTHTEDL2YdtVvlycK0/tJ49SC7HqvCQM0=;
        b=QfX+2VuZDAS+64p7+4zkK6jviIkoJmHeQ8hPjiEFtqGnWzdts7qdN4N5ohaWLcwj2X
         jrNdtvaY517pgX775FRwR13n6/b27kM9o544KIXwP3jiBjvTV7EzquGT1MpxsFlfUWL5
         KsiIy07itnlmVPlGDmgEEiQA5r8/RRTh0/46fxHP/VSHRHlVRMHiy+ApyslUTLY9tVRn
         jj1uMJWrKOia0Yycseig0fW3NHy0+7efeBESnbhb1pX8i3Nr7fhOIPS0cZCGl6Xq9ueM
         EWt7/CEcRhmuujDirA+kHIZdkLi7VIxwv1DGp2WDUoO3SPtzAigwUs6g2IcMwA6520EO
         JwrA==
X-Gm-Message-State: AOJu0YzD15Fv0a6hhznWZeYOF82wHxJQPG0cSgoF8nQOz16qFdaxjY5D
	gwdAyIOa/FhFXvX6eryzNIO1Ne1Ch7LkMdmkvdt1ylhm9lALZp7jHTObkIiZ
X-Google-Smtp-Source: AGHT+IHKSku4zCmHXp8q229sKRSYzHiRP/Udfyn7rIgZvJLODv3i0iJyMlfLrvGdKcGQH6UQKypCMw==
X-Received: by 2002:a17:902:ec06:b0:1d7:271f:b15f with SMTP id l6-20020a170902ec0600b001d7271fb15fmr2972158pld.25.1705808016534;
        Sat, 20 Jan 2024 19:33:36 -0800 (PST)
Received: from lindev-local-latest.corp.microsoft.com ([2404:f801:8028:1:7e0e:5dff:fea8:2c14])
        by smtp.gmail.com with ESMTPSA id lg14-20020a170902fb8e00b001d058ad8770sm5193166plb.306.2024.01.20.19.33.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Jan 2024 19:33:36 -0800 (PST)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	pc@manguebit.com,
	bharathsm@microsoft.com,
	tom@talpey.com
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 4/7] cifs: translate network errors on send to -ECONNABORTED
Date: Sun, 21 Jan 2024 03:32:45 +0000
Message-Id: <20240121033248.125282-4-sprasad@microsoft.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240121033248.125282-1-sprasad@microsoft.com>
References: <20240121033248.125282-1-sprasad@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

When the network stack returns various errors, we today bubble
up the error to the user (in case of soft mounts).

This change translates all network errors except -EINTR and
-EAGAIN to -ECONNABORTED. A similar approach is taken when
we receive network errors when reading from the socket.

The change also forces the cifsd thread to reconnect during
it's next activity.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/transport.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index 8695c9961f5a..e00278fcfa4f 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -400,10 +400,17 @@ __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 						  server->conn_id, server->hostname);
 	}
 smbd_done:
-	if (rc < 0 && rc != -EINTR)
+	/*
+	 * there's hardly any use for the layers above to know the
+	 * actual error code here. All they should do at this point is
+	 * to retry the connection and hope it goes away.
+	 */
+	if (rc < 0 && rc != -EINTR && rc != -EAGAIN) {
 		cifs_server_dbg(VFS, "Error %d sending data on socket to server\n",
 			 rc);
-	else if (rc > 0)
+		rc = -ECONNABORTED;
+		cifs_signal_cifsd_for_reconnect(server, false);
+	} else if (rc > 0)
 		rc = 0;
 out:
 	cifs_in_send_dec(server);
-- 
2.34.1

