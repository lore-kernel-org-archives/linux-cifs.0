Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A436744BC9F
	for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 16:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777392502; cv=none; b=Fwv/pX87poAOXDH6XF7D5IxPPkySkAvPOGh9E/dNOzLPLnnaBB584WrsPyh11fH0Dorv9L5Wji3PVXOPD0mou3KIXkui1L0ufAHm5oaIErcuUYIU4eSvLnoF0hRZZ7U08RWGl7HGMcYlMlIuj+lmh1eB7i+lHGz1brXVHtWwhQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777392502; c=relaxed/simple;
	bh=eG9ghrqyHv+FTgYWiTsJuJFnXKn0gQTXBQyL1yWQTYk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OgiX600xL91iK9POgGqBbDWEJahsh9+Flye+V8kT97b2XZ54M8SClJLFDS/ZdqBbkmnY33bI8CUGaOgf3udxElaywH6H8QgMU/ygl1qaixRMzXjbQwYHgfX3khikXvTRl7xpnAtqrDW5VOxMwbkBq7CKBLtPTsIN7XzfjyVlmvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jVdewnI+; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jVdewnI+"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-35e576110adso8061652a91.0
        for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 09:08:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777392501; x=1777997301; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=k085XqsDoPGBdb9RzNl+RVKDoAd53m9lIegek7QU+Yc=;
        b=jVdewnI+emo4vuLxuv0R0wNaG70YNoIyCaqSlsWYXMqK06tq1A8BNQjU/JhbJNDaHs
         oNdgYlZnueHN8PcP8VU8/M6SyNPNfqMsrByxnfySxmVmFaJDepUfzJUjodUZSLDfH2H2
         JzPW+Cgqs+9y9vprTiUs86esSpS/mBZ6tW9iq8Ks0VcQMIhx/Hc0J/4tPTyxulI2Hqz6
         Q/rqQXerJE3L3y7i/Oc3EBdAMLagFcgtf93qnw7WMKoHKwNf8/ekad5jt8GhQpwsa4nY
         wlBPBJn3zCFTiB+D6uiaCjdeBdTjDNcYzmqq0k8GwqVpxnY6HKe34Gi0rH9uGP8sOTjy
         er6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777392501; x=1777997301;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k085XqsDoPGBdb9RzNl+RVKDoAd53m9lIegek7QU+Yc=;
        b=hM5UY3dkvIK8s3eVnlw3ofYsFcSRCiE63McVq7Ze7TxyLeQItMjc8g74+spUwGgyYU
         DCCv8ghq+aMIfZF1tLHVuZfOIx7/AxFKcAAEL03JyE53AUcvVtekh3LHGSvZMQLv3aRr
         eDkWUHF9g1RqUtwm5dI8Xi+nuK20b9v9/iZpYnJyK+YYDDphg0Xcb3JVb2CWAlj31GVn
         7ZlZkbt5r8C4/hxBN8W4j7Mx0b8ZLMoUgdwVqxqKRJMB3nsSRPIGYl6uQdWesLmE4npD
         65uKiwEbEkpryiPA8EJ99u3iWeiG7+M5II2pBCFWc+zOTorCP8gyTPEPals4M3DDkyYe
         Ctyw==
X-Gm-Message-State: AOJu0YwxpmTImClwt6qAm0N1MLOeBhWSmuDJYY6fvCsQ4LaFPW7xZgrB
	cxWHDgFfzbp+U4IKAdJks1JvAsrp/tigng46mIs7Tz6OSry1sCj1nLYBPrn4O86i
X-Gm-Gg: AeBDievFcBbWhCktIMzRjq4CszM9SSUh8Ahq7kBztQbPqQqB7LBWSaNAIcToB7xOgzX
	wqAML3LnQMQY5mmUKQxEPmMI5IcIu3+NoIUxKLW4hrwgq028ulErUMdcaq72z53TdIa5RnCtmDi
	/TFNv0ry4FHWBPYN+g6aV/9W20FSsBEbccUFK6IL41gvYYbYl4qfOswAQZubSjGO7hL3/sjLBOM
	MaXrliNPYMSMFdAISHFmPCFcO9cTq18jrRIozeWTUd6/2lyG4ogsDDjQvRZafcu8/cIlTeJLegG
	dY/vwT89R+lH3J5ypY/NoFpL1jPdRjX9cm5WCCBHhzE6J2cAuGalOCLomHmL5TQUdLiviGCKjTh
	1MqslRIiLtb4aZlg6xlAm8QK88OR6drBVGFM1mgUqs9Z5vhWZiP+hn2nw7xT9dPcmC9M9JBnSMs
	D4bx8G+ngz5nJLDr9QdClTnSwxccsw38BGYAviJA7bX9DQFEaf13XMPtJlc7jqjfwO
X-Received: by 2002:a17:90b:48c5:b0:35b:e4d4:8290 with SMTP id 98e67ed59e1d1-36491abd42emr3672699a91.9.1777392500390;
        Tue, 28 Apr 2026 09:08:20 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.216])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b97ac7894csm30864465ad.50.2026.04.28.09.08.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 09:08:19 -0700 (PDT)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	pc@manguebit.org,
	bharathsm@microsoft.com,
	dhowells@redhat.com,
	henrique.carvalho@suse.com,
	ematsumiya@suse.de
Cc: Shyam Prasad N <sprasad@microsoft.com>,
	stable@vger.kernel.org
Subject: [PATCH v3 01/19] cifs: change_conf needs to be called for session setup
Date: Tue, 28 Apr 2026 21:37:46 +0530
Message-ID: <20260428160804.281745-1-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

Today we skip calling change_conf for negotiates and session setup
requests. This can be a problem for mchan as the immediate next call
after session setup could be due to an I/O that is made on the
mount point. For single channel, this is not a problem as
there will be several calls after setting up session.

This change enforces calling change_conf when the total credits contain
enough for reservations for echoes and oplocks. We expect this to happen
during the last session setup response. This way, echoes and oplocks are
not disabled before the first request to the server. So if that first
request is an open, it does not need to disable requesting leases.

Cc: <stable@vger.kernel.org>
Reviewed-by: Bharath SM <bharathsm@microsoft.com>
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/smb2ops.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 509fcea28a429..a9d68e5fcea91 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -111,10 +111,21 @@ smb2_add_credits(struct TCP_Server_Info *server,
 				      cifs_trace_rw_credits_zero_in_flight);
 	}
 	server->in_flight--;
+
+	/*
+	 * Rebalance credits when an op drains in_flight. For session setup,
+	 * do this only when the total accumulated credits are high enough (>2)
+	 * so that a newly established secondary channel can reserve credits for
+	 * echoes and oplocks. We expect this to happen at the end of the final
+	 * session setup response.
+	 */
 	if (server->in_flight == 0 &&
 	   ((optype & CIFS_OP_MASK) != CIFS_NEG_OP) &&
 	   ((optype & CIFS_OP_MASK) != CIFS_SESS_OP))
 		rc = change_conf(server);
+	else if (server->in_flight == 0 &&
+		 ((optype & CIFS_OP_MASK) == CIFS_SESS_OP) && *val > 2)
+		rc = change_conf(server);
 	/*
 	 * Sometimes server returns 0 credits on oplock break ack - we need to
 	 * rebalance credits in this case.
-- 
2.43.0

