Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F9913248D
	for <linux-cifs@vger.kernel.org>; Tue,  6 Feb 2024 15:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707231662; cv=none; b=e1MJ0HiEXrTFyzM8BCRYv45XzbawssUfBlh1u0WACTX+AzBN5VzFPN0tBZEpN/MRtmS6a7DAYnkewT9Jp4zZOpW/P4g7dMfB8kl2bHxYVU5OnFPzSlKAvFzkRS1pp54rRueR+TDMUqCLbWI3bE7Uo0r3mv4HQsTu7SYX0+nBfcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707231662; c=relaxed/simple;
	bh=nXYhExoNdAA56mNtCf1unIHCwtDCOVvXfIfY4OA9mw4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CNjutQHiaqRo8TLEHWHLRFD0rti3HdBmA98q6TcBRIoE9/Ye46V82NPhmL46nRGq1vNFg7Y/iWhyHlPhuZgobsFzzaf1TaS7Kk8zD74xCfN8mwoW4iJ2xtphDPrLKiMX6rUTya307+dM+5XAR2zb8i5Ub0IezSYvZazaQgGgfes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LrFRJ1yu; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LrFRJ1yu"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-5d8b276979aso832445a12.2
        for <linux-cifs@vger.kernel.org>; Tue, 06 Feb 2024 07:01:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707231659; x=1707836459; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aoxc2C9ooRZCcJ35WSoZUMfVMEHXfSDdllFFAd+NNIw=;
        b=LrFRJ1yutqFrI1Z450E6rDuWyC7D41Lkb+ll3bCnx8WCeSjS7JOL93p0HPjvwwtuT+
         4nOXzOeI9qX1ABujnwyZ8FWPCzy59HDL/Ubb82F1nFh7CkhZkDHqUUHT5bEND78YEk6E
         gc/LFmlARwOqbEcLSo7C4bH65JgYyGR34TQaQ8Zbg6LUxRyhfcqrU1E7jERPD9qEaOfo
         NkXX6W4iSv+UJ+Z45wfGrySQa4vHsZ1VwNF+s1SfU4x85jPh8ymJrecWFgoVpaW9iMad
         C1mqIpxbi+Ha7CDj07meb+TlaAIc/zgMOjszCIfMKfysVUuu9ZTKzgc4iPnZTpZwMlZz
         zFKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707231659; x=1707836459;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aoxc2C9ooRZCcJ35WSoZUMfVMEHXfSDdllFFAd+NNIw=;
        b=ZsNMEOK/3BTTT0ZjSYWJro78hrHxEw91qEopVMcyrInwIKb9TSPA4p4dzmEvJyObwP
         fvdRbHkd+ypn0Ec+pUzNBQCexy2sNXSGbMNfEEImAOT3ck+iFA1bqJB882j+8kBk/Di/
         BuU8CzlKTorzxXH/uzzv9jOByd8JiLmCU+c94HkSxcyja5mFeXrSQ0qYtEY0cvZlBC66
         SOAyoBE2cuSX6TjPxW0W/ArmgTuBySV431E+bCabEo+ScvTuDCvBWKy1P0gXm1If384e
         h6k95ghvt6zgb36qUErBrpdIabiwCxMulPz0XpJTswxI0kNAjIbErbqqXieUFxzvjOjh
         iWrA==
X-Gm-Message-State: AOJu0Yx2iA+zwUQHKAh3Jmm9u/yKoeZgr2VXr1NIXRWNLiCJvzOU+sZj
	/5YtUJ1r2I0vQqDUeqlYRmM8Z8gUkjpCsr7bTMbYjSOU9aurb+0aFXSJel2u
X-Google-Smtp-Source: AGHT+IECZ7iXjdwQ0cpGTQKe8BjSpg1c1l4AvjUaVOIE4oqxybQMM+QP54IiCRWLOClng+y+kXp0SQ==
X-Received: by 2002:a17:90a:7506:b0:296:696:1271 with SMTP id q6-20020a17090a750600b0029606961271mr2866497pjk.43.1707231658717;
        Tue, 06 Feb 2024 07:00:58 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCWIa9Jm3+nOGrQ9UAvVMTT1/nZnIe9PWDwqKB9z3jMVBxstsswTuDUQxmwaJ+Lnc6aQvf92f7RecyAUxW/X1m8oC3dldL6B7rBw4oTlRXhNWwZeHFZdXKvPp9bD2mh2d4gsDfe8kRXGDEzFiWEL/ORVHROz0PDoShJYNWgKIg==
Received: from lindev-local-latest.corp.microsoft.com ([2404:f801:8028:3:7e0c:5dff:fea8:2c14])
        by smtp.gmail.com with ESMTPSA id mp7-20020a170902fd0700b001d8f81ecebesm1963075plb.192.2024.02.06.07.00.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Feb 2024 07:00:58 -0800 (PST)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	pc@manguebit.com,
	bharathsm@microsoft.com,
	tom@talpey.com
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 2/2] cifs: handle cases where multiple sessions share connection
Date: Tue,  6 Feb 2024 15:00:47 +0000
Message-Id: <20240206150047.29046-2-sprasad@microsoft.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240206150047.29046-1-sprasad@microsoft.com>
References: <20240206150047.29046-1-sprasad@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

Based on our implementation of multichannel, it is entirely
possible that a server struct may not be found in any channel
of an SMB session.

In such cases, we should be prepared to move on and search for
the server struct in the next session.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/connect.c | 6 ++++++
 fs/smb/client/sess.c    | 1 -
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 28cacdd90bbf..c984d802d2f7 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -233,6 +233,12 @@ cifs_mark_tcp_ses_conns_for_reconnect(struct TCP_Server_Info *server,
 	list_for_each_entry_safe(ses, nses, &pserver->smb_ses_list, smb_ses_list) {
 		/* check if iface is still active */
 		spin_lock(&ses->chan_lock);
+		if (cifs_ses_get_chan_index(ses, server) ==
+		    CIFS_INVAL_CHAN_INDEX) {
+			spin_unlock(&ses->chan_lock);
+			continue;
+		}
+
 		if (!cifs_chan_is_iface_active(ses, server)) {
 			spin_unlock(&ses->chan_lock);
 			cifs_chan_update_iface(ses, server);
diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
index 476d54fceb50..8f37373fd333 100644
--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -88,7 +88,6 @@ cifs_ses_get_chan_index(struct cifs_ses *ses,
 	if (server)
 		cifs_dbg(VFS, "unable to get chan index for server: 0x%llx",
 			 server->conn_id);
-	WARN_ON(1);
 	return CIFS_INVAL_CHAN_INDEX;
 }
 
-- 
2.34.1

