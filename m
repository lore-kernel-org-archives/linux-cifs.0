Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A3DA10A1B
	for <linux-cifs@vger.kernel.org>; Fri, 29 Dec 2023 11:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mmcePY6X"
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-204fdd685fdso893092fac.2
        for <linux-cifs@vger.kernel.org>; Fri, 29 Dec 2023 03:16:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703848594; x=1704453394; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WVwjTZpQPXw6hJ+MPHao/5EGGQg5qHnQKXAGEkHljDs=;
        b=mmcePY6Xk01bssNxznw2TEUgGoW3oP1Jlw1k9s02lXzarrgCyv9MFgISSpZJD9b83V
         2WREtuhR6XJ+5reHek8pkFMri4E2GBaa8Jw5eXy+0sbGG/Bc5g1CGf6l1EO9zZn2TAWV
         nmElQcbCHdjXdBvYR07uzV1rR5iogwcSGzjXa7uusufQhRT2ZJktcj+sjftVQhvrIbj8
         G7mB+8kbbYdhY3aSd0xjmBMCvcjyRMzqYI8VAadV2I1vuVpMVlwp824+n/wmzg139f+/
         Kl3gL7z+6Dbi4izMkKStRvgSJV4Tg7u8c/CZSNNJ5m6PLyZlTEDoUrvYzRJfKVCr3uFY
         tIYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703848594; x=1704453394;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WVwjTZpQPXw6hJ+MPHao/5EGGQg5qHnQKXAGEkHljDs=;
        b=FxV8s8Vn2IoS7X55DjA6NoYFAXzKZOs5rSw1+3UcsK8/cgDCIYFChh9KcKz9B3rbBf
         441X4fwSIrfrY1WGa3PtE11C/dO6ApxdZkGLqILXI5bLZXBRVwIYAp1FBk2lOkiC11Dt
         y2rigDqBpQzoWC68hkCWJ3p6kTVCjbUHwGF+U62mR1NoCau0PHeUBC077ANb3a181Ssu
         KDf8MMd6yHwtZQNTdcxWUx/Th56WyYGygKTM/T3q0+kk5q4YO0Qy5h0vZjZdexr4Zyhv
         NdKN2uAlFbjPMeCflssQj7pgGdfGBwpQMiTJGL7zls1JnObwzJbRfjWtOPLUDXyaajjD
         RjgA==
X-Gm-Message-State: AOJu0YyetYo1g9MtnSaFs92SxeEo6P2gqbm4MtFrIQtu6epv6FTX1lad
	dismzL3FYOEpvRMGjMxHlws=
X-Google-Smtp-Source: AGHT+IFxav5mrgGM+xj6ZRo6EvN7uhA8CNV09L9eJtxpEdy1yvWe43x0vSaWKgnx7hYhWrgM9Esl5g==
X-Received: by 2002:a05:6359:1c13:b0:172:da29:a8c3 with SMTP id us19-20020a0563591c1300b00172da29a8c3mr9749360rwb.63.1703848594422;
        Fri, 29 Dec 2023 03:16:34 -0800 (PST)
Received: from lindev-local-latest.corp.microsoft.com ([2404:f801:8028:3:7e0c:5dff:fea8:2c14])
        by smtp.gmail.com with ESMTPSA id mf14-20020a17090b184e00b0028ae0184bfasm20347630pjb.49.2023.12.29.03.16.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Dec 2023 03:16:34 -0800 (PST)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: smfrench@gmail.com,
	linux-cifs@vger.kernel.org,
	pc@manguebit.com,
	meetakshisetiyaoss@gmail.com
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 4/4] cifs: fix in logging in cifs_chan_update_iface
Date: Fri, 29 Dec 2023 11:16:18 +0000
Message-Id: <20231229111618.38887-4-sprasad@microsoft.com>
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

Recently, cifs_chan_update_iface was modified to not
remove an iface if a suitable replacement was not found.
With that, there were two conditionals that were exactly
the same. This change removes that extra condition check.

Also, fixed a logging in the same function to indicate
the correct message.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/sess.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
index 2d3b332a79a1..a16e175731eb 100644
--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -440,8 +440,14 @@ cifs_chan_update_iface(struct cifs_ses *ses, struct TCP_Server_Info *server)
 	}
 
 	if (!iface) {
-		cifs_dbg(FYI, "unable to get the interface matching: %pIS\n",
-			 &ss);
+		if (!chan_index)
+			cifs_dbg(FYI, "unable to get the interface matching: %pIS\n",
+				 &ss);
+		else {
+			cifs_dbg(FYI, "unable to find another interface to replace: %pIS\n",
+				 &old_iface->sockaddr);
+		}
+
 		spin_unlock(&ses->iface_lock);
 		return 0;
 	}
@@ -459,10 +465,6 @@ cifs_chan_update_iface(struct cifs_ses *ses, struct TCP_Server_Info *server)
 		iface->weight_fulfilled++;
 
 		kref_put(&old_iface->refcount, release_iface);
-	} else if (old_iface) {
-		/* if a new candidate is not found, keep things as is */
-		cifs_dbg(FYI, "could not replace iface: %pIS\n",
-			 &old_iface->sockaddr);
 	} else if (!chan_index) {
 		/* special case: update interface for primary channel */
 		if (iface) {
-- 
2.34.1

