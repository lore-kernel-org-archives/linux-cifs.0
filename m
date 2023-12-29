Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8F9610A1C
	for <linux-cifs@vger.kernel.org>; Fri, 29 Dec 2023 11:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g22fvB6G"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-28caeaad2d8so316201a91.0
        for <linux-cifs@vger.kernel.org>; Fri, 29 Dec 2023 03:16:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703848587; x=1704453387; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=aNEoMbQsYY6VE/qFOjgIGkei4vYeIv4KMsEQLqKBWxA=;
        b=g22fvB6GBnBxfe/OFqMkQQzUrAG8ObG0mKwEvURYkOfaNc0rDEdJFa746i6tbKDYIF
         sXD1it9k6gbKtRXJeC9t0CmgkCsWfGWe6iw3+bNJdRil+Q4S36gPND+WryCS6GHMAMzc
         TlapogXs2tdRwiorrvTwuAkn+E7Bbpu+SoVKIUaurTfMRnigSag0ObQpv5ZRsKlNVJcH
         2/G1f0QD9PUklJ5aN3RhR6ZbsYxm715fV+bvZxkrU1TlSY6SU7jVzrfsxCBICzVw9JuI
         2t6HM2OxDKT0WdB30IILv0mPME9xqP4LuGqQ3/9uYRoJur22Ot68xYSJwnvjkeLAe8aE
         3IOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703848587; x=1704453387;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aNEoMbQsYY6VE/qFOjgIGkei4vYeIv4KMsEQLqKBWxA=;
        b=JFASsJMfB2o87z7zImvpl1f3rdnGMmrMR3GbNj3CJ+A/4FwR4NEZuF19DPCm1iYL2i
         LcL1kT17s2FY2QI3Yt083HpB6Jn8vLSZOgWRGE6HojDDQpJ6GnaZ/4Ut0N4InyqzMjc4
         ryJcbzDJ8X+6HAWR4SRRb7xu69wQvuMbgL5qaug2V1FD8wkQZ0PSJTFdBaAtjG+Sg0tt
         zM8dR1W9+DszOHIPrIU3ij9kmh/6HAIagZCZdeb7NluFJYn6By38k0JAtgyoTP/Sy6Sm
         USYOhU8ZHD/S7ka1nXXUW5KBx0I5kDhRN/r7irS6nAy9VP3x1lSAa3zNE9OjN5PJPV3j
         rd5Q==
X-Gm-Message-State: AOJu0YwQbDvh0JgVoEAC6EQ1y3kf2l0yaB6OiC5Hh5yFWK9EEd4ZnuvB
	PdosT9gp4RQ/mT6t0vH5Xns=
X-Google-Smtp-Source: AGHT+IHG3PpjruuF4RRQQB48wL815OjpK9GYyKWL7vg4YMiDt2n7FwdewQS2ztqeqDc4iTpTdGBaMg==
X-Received: by 2002:a17:90a:af94:b0:28b:d90c:c724 with SMTP id w20-20020a17090aaf9400b0028bd90cc724mr3804243pjq.54.1703848586666;
        Fri, 29 Dec 2023 03:16:26 -0800 (PST)
Received: from lindev-local-latest.corp.microsoft.com ([2404:f801:8028:3:7e0c:5dff:fea8:2c14])
        by smtp.gmail.com with ESMTPSA id mf14-20020a17090b184e00b0028ae0184bfasm20347630pjb.49.2023.12.29.03.16.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Dec 2023 03:16:26 -0800 (PST)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: smfrench@gmail.com,
	linux-cifs@vger.kernel.org,
	pc@manguebit.com,
	meetakshisetiyaoss@gmail.com
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 1/4] cifs: cifs_chan_is_iface_active should be called with chan_lock held
Date: Fri, 29 Dec 2023 11:16:15 +0000
Message-Id: <20231229111618.38887-1-sprasad@microsoft.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

cifs_chan_is_iface_active checks the channels of a session to see
if the associated iface is active. This should always happen
with chan_lock held. However, these two callers of this function
were missing this locking.

This change makes sure the function calls are protected with
proper locking.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/connect.c | 7 +++++--
 fs/smb/client/smb2ops.c | 7 ++++++-
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 8b7cffba1ad5..3052a208c6ca 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -232,10 +232,13 @@ cifs_mark_tcp_ses_conns_for_reconnect(struct TCP_Server_Info *server,
 	spin_lock(&cifs_tcp_ses_lock);
 	list_for_each_entry_safe(ses, nses, &pserver->smb_ses_list, smb_ses_list) {
 		/* check if iface is still active */
-		if (!cifs_chan_is_iface_active(ses, server))
+		spin_lock(&ses->chan_lock);
+		if (!cifs_chan_is_iface_active(ses, server)) {
+			spin_unlock(&ses->chan_lock);
 			cifs_chan_update_iface(ses, server);
+			spin_lock(&ses->chan_lock);
+		}
 
-		spin_lock(&ses->chan_lock);
 		if (!mark_smb_session && cifs_chan_needs_reconnect(ses, server)) {
 			spin_unlock(&ses->chan_lock);
 			continue;
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 441d144bd712..104c58df0368 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -784,9 +784,14 @@ SMB3_request_interfaces(const unsigned int xid, struct cifs_tcon *tcon, bool in_
 		goto out;
 
 	/* check if iface is still active */
+	spin_lock(&ses->chan_lock);
 	pserver = ses->chans[0].server;
-	if (pserver && !cifs_chan_is_iface_active(ses, pserver))
+	if (pserver && !cifs_chan_is_iface_active(ses, pserver)) {
+		spin_unlock(&ses->chan_lock);
 		cifs_chan_update_iface(ses, pserver);
+		spin_lock(&ses->chan_lock);
+	}
+	spin_unlock(&ses->chan_lock);
 
 out:
 	kfree(out_buf);
-- 
2.34.1

