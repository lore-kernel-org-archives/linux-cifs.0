Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26DEC14A86
	for <linux-cifs@vger.kernel.org>; Sun, 21 Jan 2024 03:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705808013; cv=none; b=Halc1lCmXoXgoCEc87QGMlI+kj56lk7le+eX7NnwgLbreXre7FSbKSQCkZtfWBXlICUJgYnngB2eKq4zlY/AMIWFbhVXW+3Jv4XgipaNow1y+atkVPNxVpCg3ooIgMFJo4qdhz6wQJgmUxWLVyiwpoQFoFku+BVZcgHLL0VZ9Oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705808013; c=relaxed/simple;
	bh=d7xOoPr+emIgghq+1AeKqK9EZdJF6HM3+bTGH2FGkpc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UK79M/l4g5+UEsQplEaI2nw+ac7ncC0rqx6YwOUiMbpkZtLdqgSm/+U7iqKgMWAPOKL3zFRS/J9j/MTYZ4twLlHgNhihP9JzSCU8bVAFJvmil0iY2SQT1KxmorEJ4HfaA2AVtpBfDZgzzxOqOmH4I/YElMTIEY9VBTcu1+nlVno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Nlee4Nvd; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Nlee4Nvd"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1d70c3c2212so13939885ad.1
        for <linux-cifs@vger.kernel.org>; Sat, 20 Jan 2024 19:33:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705808011; x=1706412811; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MyF2ti/xOtbycXy2eQXdfyxSKLKFCqbz6fPNhn1NIO8=;
        b=Nlee4NvdSJOb1NzBQJa1jqmbh2A9zVPTTDZtVq9qBXRHIVzQ5gQl6BkSgdpTI72Mce
         8I9Y78wfbSJFUryyn+ai7EzOjBYLrZrbaKRzcRqt7KjNLuOySTvQHE2bxHgwbdY3QzkO
         t2SMxJ4+9kCr6Z6dKZuilOMWTnKxpu0xr/84hrIg0eywI2WJPf5M/irmE2T6QegwNLL4
         Mc7JnW2fef06YkpIPJIYtP0JFOFm4MBu0OqM/knTUKl6tW/CET+EBPO/PlrlX3V9mFSF
         LcHKZLZcyWjIxQV0hi20j2sxCAEH4RHH7qLY3/ojwYvFaSaeIK37wWnXtoZHXkk7qj9Z
         W8Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705808011; x=1706412811;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MyF2ti/xOtbycXy2eQXdfyxSKLKFCqbz6fPNhn1NIO8=;
        b=RxorWXQpaCqvSdnT043E1pQU+9oYXU9057ivh3AoV0bwFyKh5NHcbocBK6SqW/wX+v
         h0qUA184xFDVhSdziG+H7SZm1tk5sn2hQ/LWb7KncziXklNZ24RRoATAIzK9KqN5hg3i
         HDbmgxT3IllsI5a2H5Owq6UkPd6lhvQPD74s3QT5GstMxvOrDVteRdpnEtyDOBRp4Db1
         0IDwnqRIajNuvy8FCSukGQhJQroVZri+8STWhdY356fKo3CjKD25ZffwSwExGT4ILIV2
         i4OY/CjwXOm4m02BMFlePmUy5kY/22ENvn6hXH1hNqfFzUETRwlRmOEnrWTg8JNr9VdF
         lHpw==
X-Gm-Message-State: AOJu0Yw8Wukqp+AibnU+eIhw1wkEaPsA+UNal9qXEOb+N/GpbQU8MHfw
	BcNM23v0qitzuJ3fAS6pabkGmy4B6SKTe/NNF70sVCms8q6SC9bFiyZ3fA5I
X-Google-Smtp-Source: AGHT+IEEYt2d/omRRZBnR3pVTH8bexj4Zhoj+CVO3R0E1zb7ArdG/ErgdIyQgvcEIQAVc2IdXFac3g==
X-Received: by 2002:a17:902:bf0c:b0:1d3:edd9:1f13 with SMTP id bi12-20020a170902bf0c00b001d3edd91f13mr2291504plb.67.1705808011091;
        Sat, 20 Jan 2024 19:33:31 -0800 (PST)
Received: from lindev-local-latest.corp.microsoft.com ([2404:f801:8028:1:7e0e:5dff:fea8:2c14])
        by smtp.gmail.com with ESMTPSA id lg14-20020a170902fb8e00b001d058ad8770sm5193166plb.306.2024.01.20.19.33.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Jan 2024 19:33:30 -0800 (PST)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	pc@manguebit.com,
	bharathsm@microsoft.com,
	tom@talpey.com
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 2/7] cifs: cifs_pick_channel should try selecting active channels
Date: Sun, 21 Jan 2024 03:32:43 +0000
Message-Id: <20240121033248.125282-2-sprasad@microsoft.com>
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

cifs_pick_channel today just selects a channel based
on the policy of least loaded channel. However, it
does not take into account if the channel needs
reconnect. As a result, we can have failures in send
that can be completely avoided.

This change doesn't make a channel a candidate for
this selection if it needs reconnect.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/transport.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index 4f717ad7c21b..8695c9961f5a 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -1026,6 +1026,9 @@ struct TCP_Server_Info *cifs_pick_channel(struct cifs_ses *ses)
 		if (!server || server->terminate)
 			continue;
 
+		if (CIFS_CHAN_NEEDS_RECONNECT(ses, i))
+			continue;
+
 		/*
 		 * strictly speaking, we should pick up req_lock to read
 		 * server->in_flight. But it shouldn't matter much here if we
-- 
2.34.1

