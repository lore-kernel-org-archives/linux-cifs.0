Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61F0D37EFFA
	for <linux-cifs@vger.kernel.org>; Mon, 13 Apr 2026 19:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776107502; cv=none; b=TZumbtxv6FeRT+aRLsRNopOodrGpmAXNFN51efekOjHaTJtrwUZG6LTm0if5ltq7sxqDmmPTN7laAOyyN7X7Zf/j17USTbCBHQfX2xjXl8j/Ux/OrJ/12LBHwPkhCo04LY5xQU+i/1xI6N3Tk7yjNVbvT9gwwe9vS6UdgsiJ9+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776107502; c=relaxed/simple;
	bh=f9oCGipDy6RcLee8mwGZHQR7Mqjd2U38RG0Ya7eHqI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a2TxeVnl6IBIQGHU2a47TZ+LWBVr7nQCc5toUu6Kl0Na3PkF8VICftmtAxw7X27ml7rjkvlGqIaHpxMXb1myYLOW/UOfgR5f+8P7QAnpxZNZyvXO3urc9pLU+ThbXTpEcsQsu2dv8SrB1ytYQjcO151z5h/jRxaKWH1rStx7+AI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=J3yExkq/; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="J3yExkq/"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-488ad135063so46111525e9.0
        for <linux-cifs@vger.kernel.org>; Mon, 13 Apr 2026 12:11:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776107500; x=1776712300; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3nCfqvin2GADlXqoFK8yPp3FrJJtNV6XYhevnyEsvuc=;
        b=J3yExkq/eUdMKl/tyHfOCOOcCpVY0AhMLrU1K6qAW8AoQfiUMsHzAaBMD7aaJpWqMA
         5b2lMpJvSZ2iEGqAcgDM6KcHFXr9EJClp7rzJ6VACq+YKep3p++aF00kaqg/NZj3t600
         UD+b3J+J2rpEqtGO8Jg/b7e7f11UjTxK9rNLBZbYvscr14t2eEzrLWMvM09qSn8NZaqJ
         Cffy4MVAqm4ENslu71GGnEscMZqdnDr6ACHqHFyj1XuKmIjiJNzuqqZsJHCBLg3sgVRe
         mcXDgadBqisFy1zM1B2v0OxQ8B43rjQNWCsGJ8jlpZzql0BKJ8pUpUSclL7YfCaNq3rl
         WkZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776107500; x=1776712300;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3nCfqvin2GADlXqoFK8yPp3FrJJtNV6XYhevnyEsvuc=;
        b=b7R8fGlGUxEHkLPlQFkjeJJ36eGyuzrZpP7sQXQhDtFGSFY5+RW+x9F99/b0IEJn5M
         86ttFhR8Rj4wCluuXHLeD5bMA0GZaUxb7zka2/Ko42iEThKlxRdfU6ni24L4DsYasnYb
         BB0z7BJrbFiJihBrCjW3U5Wr8U6wcXUBkaO+yVHc0ylYG1d/Nqm+MJcRInr9Pye82skI
         S8tF2qhv8dCqf99LyZmR/JRDElYjmxxwPpVtoLAk7m8Q6081GmEy57Ah3KmnnLC/LQjV
         oSRZ9NezbmNMNjobZq7BCJy5YENEQpAVAd1a4LXha3K1+simugItL7eOe9RZdWeJoOQG
         NKMg==
X-Forwarded-Encrypted: i=1; AFNElJ/Cu/su9qwyUhk8IhVTnzxDKP8KSEDlhAw0OgJJrv430GmLhJYXP2UlEb/3yquAFCpQXEP2YGg1wA2G@vger.kernel.org
X-Gm-Message-State: AOJu0YyBA64AQ1B26x03QD7z+edBSXnngreWb/e/fpFd7lKRAcVJfsBx
	nS7SpoqcQ05wO7xgfRiWadIskQpFUvT8HmcOzCtnzGz4JeU/RrvgTtCS11bYPbiCB2Y=
X-Gm-Gg: AeBDievcu24bMYcXT6j5xYPYdnH1pMrjLGBlZIUFdU1y+MsSXhvW0t3gJCZeigUo8B0
	X/YWAVem66DrpCBY46Rj3oXkCpnnXgFu8y+JmuJTBYXPiHXsYzPRWocAg9F1VJURa/nnytqFiwA
	b4A04g1qnpnMawGv0swxrGnio4mavqQjpqqOQosiQ/v6JwapwXvyRdqCuICflHkZJUtsRnmfuPT
	5uhNAvhvhi7Ta6VUS/gIUKD0imzT8ZNmy9ESirZNFy0DiMLsMRIfqKk4IJxEnwpDGw4znhO8sD9
	t1nfvKAOpflRddzQ+Ci6UlUqMMlBCo9GkGaCKeH5l0lXGlChJVcJPomHARajC+6pJCI9RNutLnv
	upwyD3kOHS4rN1bQI31hEOH9TBBSgmkJwC1uUo9lJ+sqd37nEIoqh8khXcTC2Ws4oecxGm31XtL
	j10sMqf2L+ONSbz8VjOSMlQX5Qa13u2+fTGBvt46J0Ig==
X-Received: by 2002:a05:600c:8b27:b0:488:af7f:775f with SMTP id 5b1f17b1804b1-488d68766c7mr185272365e9.18.1776107499704;
        Mon, 13 Apr 2026 12:11:39 -0700 (PDT)
Received: from precision ([2804:7f0:6401:5290:433e:afae:f475:c9f7])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2d55f5c6afdsm17508032eec.4.2026.04.13.12.11.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 12:11:38 -0700 (PDT)
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: sfrench@samba.org
Cc: pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	ematsumiya@suse.de,
	linux-cifs@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH 2/2] smb: client: pass correct from_reconnect to cifs_put_tcp_session()
Date: Mon, 13 Apr 2026 16:11:10 -0300
Message-ID: <20260413191110.1508848-2-henrique.carvalho@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413191110.1508848-1-henrique.carvalho@suse.com>
References: <20260413191110.1508848-1-henrique.carvalho@suse.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

cifs_decrease_secondary_channels() tore down removed channels with
from_reconnect=false, even when the shrink was triggered from reconnect
context, which could synchronously wait on reconnect work and break the
reconnect-side teardown path.

Pass down the from_reconnect argument to cifs_put_tcp_session() so
reconnect-driven channel removal uses the same non-blocking teardown
semantics as the rest of the reconnect path.

This is a minor fix. I believe this bug cannot be triggered in the
current state of cifs.

Fixes: ee1d21794e55 ("cifs: handle when server stops supporting multichannel")
Cc: stable@vger.kernel.org
Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
---
 fs/smb/client/cifsproto.h | 1 +
 fs/smb/client/sess.c      | 4 ++--
 fs/smb/client/smb2pdu.c   | 2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index 884bfa1cf0b4..b00b2e070ada 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -374,6 +374,7 @@ bool cifs_chan_needs_reconnect(struct cifs_ses *ses,
 bool cifs_chan_is_iface_active(struct cifs_ses *ses,
 			       struct TCP_Server_Info *server);
 void cifs_decrease_secondary_channels(struct cifs_ses *ses,
+				      bool from_reconnect,
 				      bool disable_mchan);
 void cifs_chan_update_iface(struct cifs_ses *ses,
 			    struct TCP_Server_Info *server);
diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
index 698bd27119ae..47bb566c8731 100644
--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -273,7 +273,7 @@ int cifs_try_adding_channels(struct cifs_ses *ses)
  * Otherwise, it disables all but the primary channel.
  */
 void
-cifs_decrease_secondary_channels(struct cifs_ses *ses, bool disable_mchan)
+cifs_decrease_secondary_channels(struct cifs_ses *ses, bool from_reconnect, bool disable_mchan)
 {
 	int i, chan_count;
 	struct TCP_Server_Info *server;
@@ -319,7 +319,7 @@ cifs_decrease_secondary_channels(struct cifs_ses *ses, bool disable_mchan)
 				server->terminate = true;
 				cifs_signal_cifsd_for_reconnect(server, false);
 			}
-			cifs_put_tcp_session(server, false);
+			cifs_put_tcp_session(server, from_reconnect);
 		}
 
 		spin_lock(&ses->chan_lock);
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 2eb13b2665a4..cf7b74a2b9b0 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -206,7 +206,7 @@ cifs_chan_skip_or_disable(struct cifs_ses *ses,
 		return -EHOSTDOWN;
 	}
 
-	cifs_decrease_secondary_channels(ses, disable_mchan);
+	cifs_decrease_secondary_channels(ses, from_reconnect, disable_mchan);
 
 	return 0;
 }
-- 
2.53.0

