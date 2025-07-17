Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DBA32BD5AD;
	Thu, 17 Jul 2025 12:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752754019; cv=none; b=fhz3tvheddc22vMQpT29OfUfYB8t2/8B7qSPQWIp9dseu1BuL46ocplXYufRv2MxwX9PUv5lHj3gMEuJoFw0CpjsjdA6pBorWwpkZV1D0J4rJcC6qd1UfLQ0Go2QWQvlkJQOA83ctZTYOuJvZVwwcHpDjAuI0gxNeBddsbvw9Hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752754019; c=relaxed/simple;
	bh=QuHoZlkG7wU20buB1pEULfD68M1CdlQvHmaO/SLSYA8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Xq55fnP56Ewj+DGj3l3UD8t6vDmv9mYk0CXlDtYXAPTk44ObeWCTM9sUgam/5O4dIrId5gvif/Afh3r82jcGYih93dkOWOkDfs8L9/0tC9BRRnjg3oF72zqHgwzYg1XBs9YQ3FaxjNs/VFxPHdOLltBW9OrVjLiHE/VaKe9+Zjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z2eq9xJL; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z2eq9xJL"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-23e210ebd5dso14180265ad.1;
        Thu, 17 Jul 2025 05:06:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752754017; x=1753358817; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LGIe7U1LfcAzZBymcz3jEJJmTQwnGUGGqTaGankc0vI=;
        b=Z2eq9xJLaMO99+FXOUlmKKn+kONhPg/PnTldjOmgaTcr0+vHX5WM45skpEnQ/w0CZS
         zP1dCQCgNqFp+ImOeE/GJsapJRN2hsowILEDJYWbnJQ7gJ+I3Yef96fnRXAsMU+TYURh
         //GW3M2hY54rILeu93Xfu+UovTRfCKGDXo48OOqNnddADBLcwnemjzXllCRGK/OAMGSq
         1ZVS3QX73qsPedpzmFXjiAQAYucQJK/3B+5vObv5M1OwqNjnPSq2kEuAKHe6/cEO7QJV
         K4ygOjWIrzXcv8pDttvxvqtwbMaoUxn4iUUgly+BS8x4YaLO3+sXY7CaNwdsdpglatR0
         iZVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752754017; x=1753358817;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LGIe7U1LfcAzZBymcz3jEJJmTQwnGUGGqTaGankc0vI=;
        b=DPjYHNQY+ricGYBlkxyIhA8nmTt6f5v0NrVzLrkALfYrE5edX+Jw/883OhDe5CGIe8
         lOb/9d7kNuZFSLjJv5bhuZfmNbqNAjZr3T3PoYSYA1N24yrJd5uuHsBC6EtqgcSm5R0U
         orryUchEKXAyW2r2w7x4Ik1wj6KrHNc+aBIOpWwtQp78/+I7ZEwZTmrPXFnr0mRx1KH2
         C3NJKnz7hbb+CchKw2Icnc7KYvl4t6lIAzQvYq9y5mXthEFfnYGNntVSIkr2DXiPqs86
         xr/dkSCeUQMPX5a3vRRtHMDto0NUwU8c4QtBMLvnYjiwVWP/+0i7vN/iRPXHXi7p9ePO
         rR3Q==
X-Forwarded-Encrypted: i=1; AJvYcCXztYgDA+QJDCAhpXMv1B/QgpAhuQIjZR8sXLZntrsmcZKEzAzWC7LSchNiLdlcDlKbEbhFYic=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9jBQwdiyfyJlnmDuE9LvYBxfDl4XbBNgC5QAT58yJC63MhCL/
	kXEzapdCv3mqUMjDwAmYpKXuk7lLYq3p01+h5YEyCiPy09P8b6iBJ2fompAASAj4
X-Gm-Gg: ASbGnctQq573vQzKgYyZy/PH4BlnA9FYwQisuVGKQwyAbEHR/sh3qtyPp8XhInHfTpN
	wv2IVbM3X2Zdh0tyk2uWiomxmfzgNWawrB52axZDSKwPny4cXy+HBtDG8nQIJ7zAbXH1zMysJAZ
	c4IKnIBirI2QrxbAHp5JQ3esn6DJEhK3YDpN53EuRkaosyQUSOtlKsefgKMvNy6uHUqxI4E9/q3
	IocjUkb1+yWMSUr4s884Z8ifQf+VapupvHnv9E6zzumb4OaJ+N0Usm4PMWuXR/WCvrkhtTjbdFJ
	2bFnp7/q0HyA31aA/ozezQ7WvvJD/GKh8qr+DK2cs8OCO79BSs5s03/thRfNBvCbPVJayKgpeD1
	OVnSZcYqNA5if67YWwI1eYOu2S9XYPQuQ/yDMYDrMCKdo2w8Lr1Q=
X-Google-Smtp-Source: AGHT+IH74DOfq1lN98tnSkcQQqAz/ZdvS6iMaQ50v4XlHmRmcbN4OmfdOXr9de2GQ0Jp0TLDfMKVJA==
X-Received: by 2002:a17:903:240f:b0:235:efbb:9537 with SMTP id d9443c01a7336-23e2f35a006mr46702545ad.3.1752754016669;
        Thu, 17 Jul 2025 05:06:56 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.72])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31c9f1ba622sm3156203a91.10.2025.07.17.05.06.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jul 2025 05:06:56 -0700 (PDT)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	bharathsm.hsk@gmail.com,
	meetakshisetiyaoss@gmail.com,
	pc@manguebit.com
Cc: Shyam Prasad N <sprasad@microsoft.com>,
	stable@vger.kernel.org
Subject: [PATCH] cifs: reset iface weights when we cannot find a candidate
Date: Thu, 17 Jul 2025 17:36:13 +0530
Message-ID: <20250717120653.821375-1-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

We now do a weighted selection of server interfaces when allocating
new channels. The weights are decided based on the speed advertised.
The fulfilled weight for an interface is a counter that is used to
track the interface selection. It should be reset back to zero once
all interfaces fulfilling their weight.

In cifs_chan_update_iface, this reset logic was missing. As a result
when the server interface list changes, the client may not be able
to find a new candidate for other channels after all interfaces have
been fulfilled.

Fixes: a6d8fb54a515 ("cifs: distribute channels across interfaces based on speed")
Cc: <stable@vger.kernel.org>
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/sess.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
index 330bc3d25bad..0a8c2fcc9ded 100644
--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -332,6 +332,7 @@ cifs_chan_update_iface(struct cifs_ses *ses, struct TCP_Server_Info *server)
 	struct cifs_server_iface *old_iface = NULL;
 	struct cifs_server_iface *last_iface = NULL;
 	struct sockaddr_storage ss;
+	int retry = 0;
 
 	spin_lock(&ses->chan_lock);
 	chan_index = cifs_ses_get_chan_index(ses, server);
@@ -360,6 +361,7 @@ cifs_chan_update_iface(struct cifs_ses *ses, struct TCP_Server_Info *server)
 		return;
 	}
 
+try_again:
 	last_iface = list_last_entry(&ses->iface_list, struct cifs_server_iface,
 				     iface_head);
 	iface_min_speed = last_iface->speed;
@@ -397,6 +399,13 @@ cifs_chan_update_iface(struct cifs_ses *ses, struct TCP_Server_Info *server)
 	}
 
 	if (list_entry_is_head(iface, &ses->iface_list, iface_head)) {
+		list_for_each_entry(iface, &ses->iface_list, iface_head)
+			iface->weight_fulfilled = 0;
+
+		/* see if it can be satisfied in second attempt */
+		if (!retry++)
+			goto try_again;
+
 		iface = NULL;
 		cifs_dbg(FYI, "unable to find a suitable iface\n");
 	}
-- 
2.43.0

