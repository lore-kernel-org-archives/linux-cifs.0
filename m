Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E8710A36
	for <linux-cifs@vger.kernel.org>; Fri, 29 Dec 2023 11:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k1jqgZtO"
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-204301f2934so4917929fac.1
        for <linux-cifs@vger.kernel.org>; Fri, 29 Dec 2023 03:16:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703848592; x=1704453392; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gEW/phCz+wqV6eqiM4uMTnsGnQEdVB91+sIAZ2ujQ/I=;
        b=k1jqgZtO6Oev6uRiA9QOqoJaUG0Fk7PSh09/aBU9M8APX9X/HMmcanlNdSGKyvykR/
         y0JBP3rAEUNqPECykl6m4KfM0RXBvChNkoiJqit/KMUmanjqz3oojYl55aswkwV6L8Mm
         weMh3MkPh+TCsFgIoZ1rkv1hqLgwSsOL/cwc5h2AraQpchcdB0zWXY+lyeNNgZWxcbVQ
         RuL4KJTfj9RGiNlDx1LqffrgNn9aUbs/i+Zu+q5hCl8I/UcM8N3cRLBFLR5PY/tYdgQ1
         FLLeg2ucSnWYEO9gHxJ7KeRfbSCFnRRBYjUJvE1F4JJiaTpHw1YC8/actj9xqXHs2VCh
         0wnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703848592; x=1704453392;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gEW/phCz+wqV6eqiM4uMTnsGnQEdVB91+sIAZ2ujQ/I=;
        b=rThIfkt8z454tId1dU1bkWi6htCVbVFEFeeQcrp3CODYSdB8OJ44dMZ+3J7dyM3K/A
         oR1iUwcvZtmfOsaNn30aL/Hw/F/hL9wxM9DkCxJDi0jN0g+pMa3YXkTbLaycif8Mguxw
         ZwZg9kuYeimUrl7AaJeQNV1OdQhKt/OGYkeokCJgbZbxIC4r/GazZO+5nIScwtp8sCS+
         w+tnaE7o8kDOzJqhl9LBz4N+m63XnpEe+MxzNByzG5bIwA8RWZ5McfuPXNT7JJ0FZtVn
         bDGnDDa+an4tj9enGvgp2f/2M+ARUuIYY0KUui3dpzD3tvLL2JZd/8KRzJmfi9FjLoo6
         Qy/A==
X-Gm-Message-State: AOJu0YxDqk6F7tK8p7ZWor9qszajzI+BL9sdeXJ9o2M3lydNMicde56V
	vqcTu5gAjtXb0P23ix88GEQ=
X-Google-Smtp-Source: AGHT+IEwMFZGZDjOEyRYRhq+Af/7ztsiyOi+wLiwn4O24eaHReYnDU2zOOuqk5K7CUl20LXGEL5d9g==
X-Received: by 2002:a05:6871:810:b0:203:f156:3e94 with SMTP id q16-20020a056871081000b00203f1563e94mr14494946oap.92.1703848591869;
        Fri, 29 Dec 2023 03:16:31 -0800 (PST)
Received: from lindev-local-latest.corp.microsoft.com ([2404:f801:8028:3:7e0c:5dff:fea8:2c14])
        by smtp.gmail.com with ESMTPSA id mf14-20020a17090b184e00b0028ae0184bfasm20347630pjb.49.2023.12.29.03.16.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Dec 2023 03:16:31 -0800 (PST)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: smfrench@gmail.com,
	linux-cifs@vger.kernel.org,
	pc@manguebit.com,
	meetakshisetiyaoss@gmail.com
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 3/4] cifs: cifs_pick_channel should skip unhealthy channels
Date: Fri, 29 Dec 2023 11:16:17 +0000
Message-Id: <20231229111618.38887-3-sprasad@microsoft.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231229111618.38887-1-sprasad@microsoft.com>
References: <20231229111618.38887-1-sprasad@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

cifs_pick_channel does not take into account the current
state of the channel today. As a result, if some channels
are unhealthy, they could still get picked, resulting
in unnecessary errors.

This change checks the channel transport status before
making the choice. If all channels are unhealthy, the
primary channel will be returned anyway.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/transport.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index 4f717ad7c21b..f8e6636e90a3 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -1026,6 +1026,19 @@ struct TCP_Server_Info *cifs_pick_channel(struct cifs_ses *ses)
 		if (!server || server->terminate)
 			continue;
 
+		/*
+		 * do not pick a channel that's not healthy.
+		 * if all channels are unhealthy, we'll use
+		 * the primary channel
+		 */
+		spin_lock(&server->srv_lock);
+		if (server->tcpStatus != CifsNew &&
+		    server->tcpStatus != CifsGood) {
+			spin_unlock(&server->srv_lock);
+			continue;
+		}
+		spin_unlock(&server->srv_lock);
+
 		/*
 		 * strictly speaking, we should pick up req_lock to read
 		 * server->in_flight. But it shouldn't matter much here if we
-- 
2.34.1

