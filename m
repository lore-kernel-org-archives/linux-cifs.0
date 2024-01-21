Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D15FE14A86
	for <linux-cifs@vger.kernel.org>; Sun, 21 Jan 2024 03:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705808022; cv=none; b=oGocPSYhYf2sTMNjQU8/jxw+yg4Vlu34hy9UhI1rsGiZOXHlsWkM9rcKUVxqSrRMAjqExktRvcMCKvOShLwL3b5j3wyoq1I7R5THL2fAvSPd6vxM9swdq88hJ1rhgtiT6e/5iQozDVWy5d7mQsDCXiCCrjqXXg3R3l01I6JTKuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705808022; c=relaxed/simple;
	bh=ezL4tFtj37vizPg8VDCsPn5VQNBt17K7UfRKtptiuQg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=H++xp1D0T3aeivl3AW6ybCB9atGo11uNP0cCaNDGp+G+edzkqsyVHgLx8YIHcEvJCIywB3BCOqelqBgNcQYbeQbIuMsCRTwQ0QpZOZuL+bI9t3Ab+NwzAmNAC0WDqdOtPwI/p4B0pgy0uHKGmqGTNF+js0Qw+fVOC6/7mY7815g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YGCObl84; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YGCObl84"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1d51ba18e1bso18597275ad.0
        for <linux-cifs@vger.kernel.org>; Sat, 20 Jan 2024 19:33:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705808019; x=1706412819; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KKSAYhZIbcehbrlijLijLmeT7Q+zPuIM/lOAGoSkaas=;
        b=YGCObl84MFD+oatonuEsMzOfVh/9xrCik7FiFys7J25h+6dwkm4FtYGFqhIXPqzvnk
         Q6hTpz/9X6JqYpJjWngu4SqKZgNaFEqe+yetLseiWTVBB3IASEJXbpFfyfCY/J1AmyOT
         qapaigqmY8jrd6iUkqGFKOQGSSYCF9VfWu4SP6NLc5Mwl1KakgE5ESAIZl9a9UMSDBek
         sNXR1eT0rRNEs3EvQOrWO2+WC4r+tf4RM1vrXIBQSCXFKqs+DxOhR11jW7vqE5pulvoz
         6oGFf1OvBzPzvlyfEFTB9d7h8eA+6oCIHHUeeKTbsz0agb3wegM1wb9SFqWPSWCbgsPW
         STAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705808019; x=1706412819;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KKSAYhZIbcehbrlijLijLmeT7Q+zPuIM/lOAGoSkaas=;
        b=I4fwjye7gl7/ctpKv78KKhZB7C8J3YYG6fpRMcFYwccovp95mjmlq+cCRJBqQBjhX9
         Ff9aJB9r5w0psryCSPGTFcN8NqPlRuXFXABHe6Cu2IP1MTK3XZXmVyaQRQHL9M+0eTRL
         kT9LtMPUGNqipOK+I1coZbOYh/rm4PEyAOj9P7x4mNYy7wknyCFx455fMt8K9qTcfVpm
         3fuhw/TLM8x1JVB218rlxh3bXbPoB4SxaYGkX+NBYxmNRnzYYRqhUGLSL3jIfpe/dN1V
         7RhgUDv89PdoZ1Nv2iEdxnbQnTgIDcnuXqmuSbBFVPf/kMf9WkIoSMX2F2w7YnokWVbP
         GAMQ==
X-Gm-Message-State: AOJu0YzCaMSvPMEG9swK9JZ4hk4UwB2G6lsisWz4R9NuRuc95+NEarSQ
	q1nGvyzwuScf39UT1SEPurbrS8A+z+aQL5ogHbeGOPw0jIKLh82MK/wMQD00
X-Google-Smtp-Source: AGHT+IFvSIAnu7ubFbPyTZmnILpr47eAFwYi81QGR0V31Unmv36WLLbWpEzNmuYxnrM/4VfB0Y3jcw==
X-Received: by 2002:a17:902:dac6:b0:1d7:215a:8065 with SMTP id q6-20020a170902dac600b001d7215a8065mr3559860plx.34.1705808019236;
        Sat, 20 Jan 2024 19:33:39 -0800 (PST)
Received: from lindev-local-latest.corp.microsoft.com ([2404:f801:8028:1:7e0e:5dff:fea8:2c14])
        by smtp.gmail.com with ESMTPSA id lg14-20020a170902fb8e00b001d058ad8770sm5193166plb.306.2024.01.20.19.33.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Jan 2024 19:33:38 -0800 (PST)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	pc@manguebit.com,
	bharathsm@microsoft.com,
	tom@talpey.com
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 5/7] cifs: helper function to check replayable error codes
Date: Sun, 21 Jan 2024 03:32:46 +0000
Message-Id: <20240121033248.125282-5-sprasad@microsoft.com>
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

The code to check for replay is not just -EAGAIN. In some
cases, the send request or receive response may result in
network errors, which we're now mapping to -ECONNABORTED.

This change introduces a helper function which checks
if the error returned in one of the above two errors.
And all checks for replays will now use this helper.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/cached_dir.c | 1 +
 fs/smb/client/cifsglob.h   | 7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index 971892620504..5730c65ffb40 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -367,6 +367,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 		atomic_inc(&tcon->num_remote_opens);
 	}
 	kfree(utf16_path);
+
 	return rc;
 }
 
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 20036fb16cec..6e4cfaec98e3 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1831,6 +1831,13 @@ static inline bool is_retryable_error(int error)
 	return false;
 }
 
+static inline bool is_replayable_error(int error)
+{
+	if (error == -EAGAIN || error == -ECONNABORTED)
+		return true;
+	return false;
+}
+
 
 /* cifs_get_writable_file() flags */
 #define FIND_WR_ANY         0
-- 
2.34.1

