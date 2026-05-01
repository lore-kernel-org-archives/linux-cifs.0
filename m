Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3068A3A16A4
	for <linux-cifs@vger.kernel.org>; Fri,  1 May 2026 11:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777634453; cv=none; b=YYC7cf7YuiBCi7dkp1vtUiur27AI3dWv0QxtZZvHdS7RyvKQdQi+cKko1V2AxW6MvEfA3Q+n/55/2XjFR6W1fdoZ+sBBypyQF9QHee/SkKofPT0SU5WlEuKieqSTUyfTFowsg9hBDz9bUFb4FLVMqnA+iS0CyKZjspig7SuOdR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777634453; c=relaxed/simple;
	bh=ONa3GtbC5SUW+1bD8ti4dtkNr7M9XViKalteZy1lIUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mXXuwbhZPaLisICtY/tOimClUu977B4XIo7eWkZh7YqsRXT3smwI/KkfPC3TE3mUUS7+9NwGXtsQnhCv5sJh8liiRxzxpyCIux4Yk35mry+sfS8lC7TNUCmtSl5ttQJ5QeD/tbl6MDZBOkeg14gPSmk+YTfNsTJTvSNG66zZFGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EJZK/gTN; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EJZK/gTN"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-8296d553142so1244196b3a.3
        for <linux-cifs@vger.kernel.org>; Fri, 01 May 2026 04:20:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777634451; x=1778239251; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ikjKsjhDOQkfHUpZXiLTAQXdSQREIXbYDA4LmwD02I0=;
        b=EJZK/gTNCV/VpNS+J6aYsJZbS8HQwskZetjvl/VK1MfbvGEWXoO7X0fH+6EvT8Kf1b
         8l4/8CsgMviRujN0QRdGIJJBnHudFoBbqPohEnVo3OYvCazzbd7EKsxEZI0rXZOi9Xhw
         MarzY3Q1kqZSSyLH9HjOhAc+vpDX4k0IXUx8asn8z3hJT4SUMMdE4mJSIUYlf3LlmUxG
         gvnCaYRoQtUDjv+lI2KEsUE9WoNp5XM20dSjsLAv9OKQqu1tp8zHU4vN6jmvAcOWC84u
         4vKgrIpobaOoSwzpQNxxovFdykrrqI3715YJP7mz8sjqPERxaA+eNVvDSccdI8vD7ex9
         kdcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777634451; x=1778239251;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ikjKsjhDOQkfHUpZXiLTAQXdSQREIXbYDA4LmwD02I0=;
        b=EJojFJNh5LJT0wNAncqjr0tBbUx2mj8MsDNeG15W6roYKjozEgNBGSsLra7BhheDKD
         OPHXUFWBSZrqgFrezjZ/ZSKKceQtp8nGG823xQrq3bC2ZBKp0uc7KonP9aNo5P/cMaJ+
         qxo1meptYbs6E/3RoxglZ8ji9ilDkGnaQlYvfdJEBDods57P7ZXLWKu14i9HnymsnsAK
         pHe/ehSf75JrIGUHyJjAMUTu0HkMhvKjJrf8FVPQe90cFDgyP8mLSE/55DxTVifZMMnm
         iPApLPUoeOpfvO0T/vxz7qNBrYpoZUBAe2QpWqYTH6BqFLeDoyN03Qu1G10rWkGXRPRF
         6S/Q==
X-Gm-Message-State: AOJu0YwxA0CYkDWbhISuHgYWs6Or2fn+7qp+9MTaKNfTxsdImfWs3+di
	X6QslzhIyFsaAQDXrGSEH6AkYNjYgb/izIeQiaysAPcJSxbPsv4GEsWZr92lh9qk89U=
X-Gm-Gg: AeBDieu10aXGmwsg4tBaM9NmmZFhJv1l3mwwNwb4hWFpkUvRQbnK6taWfGvGwlI12du
	KhnYG3jhwRQzl80ImPkUJXTJTppoq58aQg1Iji3LY7hKdqmL8kePmUn+M1su5nO+EBx7LDVmtu6
	FZBPyoURE4YCscUocJbvVpTVI6WWouoVhWNh5mmYCfflo134rECPnvTGnz1wBdSk1+avyhOlfID
	F1oN2fIvm0F9chl387kfrQEb3E8xwNTtcMgJPUtQ+aT/xyrt3RX/ffiG3uqta4y7R84itYDU8qJ
	4hUoT7R6od31WVslIZwBKwu7JaxbAToCVlpVqqukWBcFtd5/AZn2BIkIHc3Q1MtJ2s8RmVxfPv6
	KhjPGqdtQ15dcsW9V28y7XOtsu13WC1CS63qwFBNyZ2YtLn7GAFlfJZId7A4+2aTl2KKb3/6ztT
	ZxkAh/x2zrvPNfvqGNalubQe+bIHfe9e91jykOcoNu9kuoIVENyQEjNyvkzgERfWrx
X-Received: by 2002:a05:6a00:2e15:b0:82c:e692:1f91 with SMTP id d2e1a72fcca58-834fdcb8d33mr8297128b3a.39.1777634450702;
        Fri, 01 May 2026 04:20:50 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.216])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8351587db67sm2331922b3a.13.2026.05.01.04.20.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2026 04:20:50 -0700 (PDT)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	pc@manguebit.org,
	bharathsm@microsoft.com,
	dhowells@redhat.com,
	henrique.carvalho@suse.com,
	ematsumiya@suse.de
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH v4 17/19] cifs: discard functions to ensure that mid callbacks get called
Date: Fri,  1 May 2026 16:50:20 +0530
Message-ID: <20260501112023.338005-17-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260501112023.338005-1-sprasad@microsoft.com>
References: <20260501112023.338005-1-sprasad@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

If discard functions for readv and query_dir return error, the
callback functions can be skipped. This can end up with hung
syscalls due to the completion functions not getting called.

This change ensures that both these discard functions call
the callback function when discard from socket returned error.
This ensures that at least after the mid for the response is found,
the callback doesn't get skipped, and we do not leave syscalls
waiting.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/transport.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index 24ccadb00f568..a11e6eba008a6 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -1143,6 +1143,11 @@ __cifs_discard_and_dequeue(struct TCP_Server_Info *server, struct mid_q_entry *m
 	dequeue_mid(server, mid, malformed);
 	mid->resp_buf = server->smallbuf;
 	server->smallbuf = NULL;
+
+	/* Once the mid is dequeued, the callback must run to terminate the subreq */
+	if (length < 0)
+		mid_execute_callback(server, mid);
+
 	return length;
 }
 
-- 
2.43.0

