Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4AA24DA09
	for <linux-cifs@vger.kernel.org>; Thu,  1 Feb 2024 11:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706786146; cv=none; b=tBhYBerYcAVPkU88M0yKUG1O6xOzHw2ZZjvkQvrkJw91C0jCIXWGnGDNRl5lztGqoXfZjUCuUqiWba4kqjs2QhSDTNxA2xDwZ6l8oYXUQjRjifnYM8inBsLAe725bHtJWjzEAIpbHkxzOREGpzwUyoitp5axvjsHx7GYz/uN5RU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706786146; c=relaxed/simple;
	bh=jWCwM+dz7zmxxLgmoFUfeics0bg7kaREotoJtJzQMkI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VyR9659bqo97eO6gsUYizAV/pZvFdBh64z7Vc7di7eBo5QV8fl0UgQTOQV1vQN3Jocj0+TZR4caeU8aAWFq2+zgTT3TRhtAPAQcL3QLycfymbvvOLSEBbj0t4ZYipG6w0ncn8lA4ibxfcuntSlptOR9AxzB1qe7sD7GZsmDoFx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lrmKmDuV; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lrmKmDuV"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1d780a392fdso6251515ad.3
        for <linux-cifs@vger.kernel.org>; Thu, 01 Feb 2024 03:15:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706786143; x=1707390943; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mpkD3EdPNyQmzA1vf0wbH+Lbz7c9ADTNYXdIFyYPGuM=;
        b=lrmKmDuVOsJ6oDtsZVt/bG9svi9U3fqwpopjfNMqSoyQVDDTfz+ryEWy0xyaXEDhB0
         Pf8cgdS1png8kl5gmrwGnFeeys3Y7yF1tCFQ+bLsSUhJX8oSt3uYcLxKrIShpNKjMn6C
         O3Uc3aW78OEqxQkugBqxkUCFmbio15iBqtxr0CfeW7WAK04L5zyK+6nyWwdV6IvzwI1s
         582qHsOwQcw+oz8zfC9gSPFV/34Yq3fTnxzR9hPBi2LFw+rbHoDD3YyIbywt9bkcLcgx
         RWgKkiW/wBme77AvjWVTqJfXke3IqtRg5e2jBPEPdIiUAEhQjAkkyX0N0IDdiLXErFuF
         bA1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706786143; x=1707390943;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mpkD3EdPNyQmzA1vf0wbH+Lbz7c9ADTNYXdIFyYPGuM=;
        b=vQvrAtC+gMvHG0Nwu2MpXFfwSzmuoE74vDbjsaZ7uJvF87bFUzRy5fWvD5gL7EpRDi
         hyGbDbjPQ3OkunCJ6QUwgaZzVVinK1cskBBwgJaGEvV3p0gJo6TnrLhAe+jQ3ErFNkPp
         O6QZe9YbDoiy+5JtRTajcA9fjXcULrLcMEAXdS2YGtYotajD5gj7k4YKH1G5zN9CPwyP
         T2P5ESSFmB8E0cYcmHEPGEIToK6nH1F6eGD7nRVGrHQQ/jaIjNMyeQie0KWa2xxX4OW9
         ymuskWyaatNBnwcIb76+4IzlqwYxBPoOqDExlhd9fXb3SLHCazOowWGtLFZHIOKqrbnE
         DG6Q==
X-Gm-Message-State: AOJu0Yw47ixc9hbeZQgi0JT3BpLfQzUfmKeBBE0fdZt70AZlKaHlrVBJ
	Lm7pOFC4dA+/dJwg2gO8UG1+J2Csc1qbMtcDkaWWlt/b+5CDcrLe80gxCqFZ
X-Google-Smtp-Source: AGHT+IFEk4vYxNtrrw+n2w/TFImv3keXbDhk2TJ4Pbc9YADyQYgIzb/2MGUUYClPO6ifrxJKI9bagQ==
X-Received: by 2002:a17:903:4289:b0:1d8:d6f2:5ee0 with SMTP id ju9-20020a170903428900b001d8d6f25ee0mr1939947plb.8.1706786143202;
        Thu, 01 Feb 2024 03:15:43 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCWPy5nE1hhFr83L0ao2qGG16BD7L3xhz4B8TN22AQV3Q7T45NWeBUYL2B5YDKn3OZcCLJJn+qrw2lv8N41jTByFz3vU5JO9GWjPdorcbl67tij6yo/GpVlZ/jEUDfnBNRDGgzzAfGwqZUXn8+KJ
Received: from lindev-local-latest.corp.microsoft.com ([2404:f801:8028:1:7e0e:5dff:fea8:2c14])
        by smtp.gmail.com with ESMTPSA id l19-20020a170902f69300b001d94c4938b3sm1129926plg.262.2024.02.01.03.15.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Feb 2024 03:15:42 -0800 (PST)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	pc@manguebit.com,
	bharathsm@microsoft.com
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 2/5] cifs: change tcon status when need_reconnect is set on it
Date: Thu,  1 Feb 2024 11:15:27 +0000
Message-Id: <20240201111530.17194-2-sprasad@microsoft.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240201111530.17194-1-sprasad@microsoft.com>
References: <20240201111530.17194-1-sprasad@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

When a tcon is marked for need_reconnect, the intention
is to have it reconnected.

This change adjusts tcon->status in cifs_tree_connect
when need_reconnect is set. Also, this change has a minor
correction in resetting need_reconnect on success. It makes
sure that it is done with tc_lock held.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/connect.c | 5 +++++
 fs/smb/client/dfs.c     | 7 ++++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index c5cf88de32b7..28cacdd90bbf 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -4230,6 +4230,11 @@ int cifs_tree_connect(const unsigned int xid, struct cifs_tcon *tcon, const stru
 
 	/* only send once per connect */
 	spin_lock(&tcon->tc_lock);
+
+	/* if tcon is marked for needing reconnect, update state */
+	if (tcon->need_reconnect)
+		tcon->status = TID_NEED_TCON;
+
 	if (tcon->status == TID_GOOD) {
 		spin_unlock(&tcon->tc_lock);
 		return 0;
diff --git a/fs/smb/client/dfs.c b/fs/smb/client/dfs.c
index a8a1d386da65..449c59830039 100644
--- a/fs/smb/client/dfs.c
+++ b/fs/smb/client/dfs.c
@@ -565,6 +565,11 @@ int cifs_tree_connect(const unsigned int xid, struct cifs_tcon *tcon, const stru
 
 	/* only send once per connect */
 	spin_lock(&tcon->tc_lock);
+
+	/* if tcon is marked for needing reconnect, update state */
+	if (tcon->need_reconnect)
+		tcon->status = TID_NEED_TCON;
+
 	if (tcon->status == TID_GOOD) {
 		spin_unlock(&tcon->tc_lock);
 		return 0;
@@ -625,8 +630,8 @@ int cifs_tree_connect(const unsigned int xid, struct cifs_tcon *tcon, const stru
 		spin_lock(&tcon->tc_lock);
 		if (tcon->status == TID_IN_TCON)
 			tcon->status = TID_GOOD;
-		spin_unlock(&tcon->tc_lock);
 		tcon->need_reconnect = false;
+		spin_unlock(&tcon->tc_lock);
 	}
 
 	return rc;
-- 
2.34.1

