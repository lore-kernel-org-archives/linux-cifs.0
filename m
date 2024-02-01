Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEFC115B995
	for <linux-cifs@vger.kernel.org>; Thu,  1 Feb 2024 11:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706786148; cv=none; b=cIQCpuJIeGH63vp653NTvUC3ZxiPaB/FJLALPs5GCYs9Y4vdzS8vK5NMAeo60CWMmBXutUhmdV2YSQ9DKZ1xcYB1GPexNp/bvSfrPdJHmrrE0u6f0ixELSJaeKk0YwFTKidU0Tfd0HluAnecT5xHKvVBQHmNIuUIL8mojficoUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706786148; c=relaxed/simple;
	bh=oNmmTMO7rOwaVme3DvinibUY2cfpn+t6Zgwg8eU4VBs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=m5iFsqiEN47YzCL0KX5u8KTWxoH4rIbZWGs5gyF6T9MekNTT9XSSybP00Z9dOiR7k/pS5JtpTePv/EkQbLfsf234xulyDSsmCo4ghvhg3f21GeJqG6OZXy0MSvAci+zMuEW/4E2hk84G+NOzuns9M/5wjAfdvLzn6HaftVksHB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EB35kQiz; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EB35kQiz"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1d73066880eso6692645ad.3
        for <linux-cifs@vger.kernel.org>; Thu, 01 Feb 2024 03:15:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706786146; x=1707390946; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UWYUhLumUFEGz6dKMdxqU7bBIDX9o62TKGXvyMevSgA=;
        b=EB35kQiz64wWL+llJ4EiaCN9QrD2SNshrbw9IwM4cXM3CS4//ZKKyowu1V97SYDOJU
         jSDrViRmrBiTAvOEseVoms+/5jTy2jkC+Pq/OCE0zpbVBCBoWvX4f2IQLJKQYHL7B++t
         /BuG6Sgb4Rlf9/PPBdGJn0lCRppzqnGgn03BdLD1M7CUMTtQI6eXJ5DUsH1hun5X71/M
         VjxA11OYBEAHEDdaxEA1WlXAZ2maRUj61cdbT0lri04XBkndc0bOGr6nXwkKyZl+glaj
         pGTwvsVVkZLY5IEkPtCa8+hu+xmmWqOPDdIVqCHZpW8jV4W12wCWtVpfe32RLfMkomMt
         F80Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706786146; x=1707390946;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UWYUhLumUFEGz6dKMdxqU7bBIDX9o62TKGXvyMevSgA=;
        b=TrjDyCbXP7+mGKBm1BybpYkq0idm1jrFr9BLGiokegJPJ7qIsjZOlPIlLKCeDW3z2T
         braQkZlhKRxirpTi7dvmtrd5E2YsQvxDx/wo5Jv/tozNB7PPJhkLDKhIMwEbZ71Qxw7M
         WtVXD1In3z+IinbCTN8wiGwfQgy3IJ8xzgcezLL7dIEI5476VodigrBTzryqw+WEX8iB
         4qqPVCvrPJcRp8jWoqyXENmjuDFG5/zoiIaSsGTgWISnL45HvTbE3cUukZgraQ5dKzn1
         0KU+7Hx8jQlBxp3+XcHzBPwGplCJgnq1eVRBxgGGJfjmDWDdpJOcbQkgQLgEVaE1e/z3
         6GCA==
X-Gm-Message-State: AOJu0YwbfVb8tjZRDoiUJvB2nSG6Vj3mbmDrd17+ScNnq2RCXYAA5rKr
	8mHbkL0AHy1kXmzrclyOwSC+Wz+tSoHbp36adGcVPzJbix+iv1bU5JDQJ7z7
X-Google-Smtp-Source: AGHT+IE5sNL+4bDkBs3Jnigb9Gc/BZBNR64+sGn1VdPPJqd3wrW2uzpWqvv7Jjq4X/axHiSQAxchug==
X-Received: by 2002:a17:903:248:b0:1d9:1359:75ec with SMTP id j8-20020a170903024800b001d9135975ecmr5825036plh.30.1706786145791;
        Thu, 01 Feb 2024 03:15:45 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCVZC/SyF9RD80LDpn6oF/0lLzF63k03/+ccefA3gGh5SxiS387vbTGEFVbhwu4Z14FXdiHI1XGR8mYYfH5nTw4kNmVJYpVHpOD6EsQAl7Fr+f9CH/44vhJIzaEC/ClvVNIjnobHvBdlHfQ2EAjy
Received: from lindev-local-latest.corp.microsoft.com ([2404:f801:8028:1:7e0e:5dff:fea8:2c14])
        by smtp.gmail.com with ESMTPSA id l19-20020a170902f69300b001d94c4938b3sm1129926plg.262.2024.02.01.03.15.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Feb 2024 03:15:45 -0800 (PST)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	pc@manguebit.com,
	bharathsm@microsoft.com
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 3/5] cifs: do not search for channel if server is terminating
Date: Thu,  1 Feb 2024 11:15:28 +0000
Message-Id: <20240201111530.17194-3-sprasad@microsoft.com>
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

In order to scale down the channels, the following sequence
of operations happen:
1. server struct is marked for terminate
2. the channel is deallocated in the ses->chans array
3. at a later point the cifsd thread actually terminates the server

Between 2 and 3, there can be calls to find the channel for
a server struct. When that happens, there can be an ugly warning
that's logged. But this is expected.

So this change does two things:
1. in cifs_ses_get_chan_index, if server->terminate is set, return
2. always make sure server->terminate is set with chan_lock held

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/sess.c    | 4 ++++
 fs/smb/client/smb2pdu.c | 2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
index cde81042bebd..3d2548c35c9d 100644
--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -75,6 +75,10 @@ cifs_ses_get_chan_index(struct cifs_ses *ses,
 {
 	unsigned int i;
 
+	/* if the channel is waiting for termination */
+	if (server->terminate)
+		return CIFS_INVAL_CHAN_INDEX;
+
 	for (i = 0; i < ses->chan_count; i++) {
 		if (ses->chans[i].server == server)
 			return i;
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 75713559e69f..cf5665f6f220 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -178,6 +178,7 @@ cifs_chan_skip_or_disable(struct cifs_ses *ses,
 		}
 
 		ses->chans[chan_index].server = NULL;
+		server->terminate = true;
 		spin_unlock(&ses->chan_lock);
 
 		/*
@@ -188,7 +189,6 @@ cifs_chan_skip_or_disable(struct cifs_ses *ses,
 		 */
 		cifs_put_tcp_session(server, from_reconnect);
 
-		server->terminate = true;
 		cifs_signal_cifsd_for_reconnect(server, false);
 
 		/* mark primary server as needing reconnect */
-- 
2.34.1

