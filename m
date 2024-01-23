Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0B1D4C7B
	for <linux-cifs@vger.kernel.org>; Tue, 23 Jan 2024 20:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706043024; cv=none; b=a0ZZRolSq3XJCrkDcqJHLUqmU7VpX3/n+LIzHPKTDxOZLmek+R0ffZQibGurwmhmb7kRfh+b4sxV9p6WFX7jKMt4wzcKcVPwucNZizI/lymPNknWL9DQY1yOkSICZ5gL7kN5WjiaviKMb7q5e8RQcg4sE7KZ74SrwG79wy66QXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706043024; c=relaxed/simple;
	bh=MiYZmYYMrLmyj1MfMvdJLticCMBbB3Yg0/Tv3yNlqfE=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=c94IUiCpQd7IBXtEb/g/2X8LLH5kZyXvcUBc70z0XkkvGKDJy5POkr7eIokVKO3TcudYim2rgJFn96KWPYs6KQXu88UegNJffYTf0yjRI2++N1SzWAaj7pOGHcP8dfHzHdk9miuSmKCiQB6uYFhnkVscNoNe1I2F1zCdYfns8Mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DTsk6xSP; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DTsk6xSP"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1d73066880eso27315895ad.3
        for <linux-cifs@vger.kernel.org>; Tue, 23 Jan 2024 12:50:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706043022; x=1706647822; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5LF7enKIFNTOUznrYEEtapJ8sft39y4HKd2BucZR1Mw=;
        b=DTsk6xSPTBXlpONpAYfxTe1dWk8KaJBP3OXEbqwY+mxKHjGh0p13aii/e09YZrz2t6
         nlRpUUxD9/aY55pM8sgXbJHX1T108oLpaGLt+UoKm8hQ8AR8z/SZqDUIVJH3wiypztqN
         kjO9B+XkKMTDY7hffOHnSXA5jM0s7zauchjfVyXoOPRVnDf9lW9gY6mAidV6GV6hD2PU
         pS+SCXOR4H+2dEc5j+JrS1J42L9W0SY1aSwzIT3sCrZ1lnf8rFloVbkyC8xdO7j9L6Ea
         Vqk34WArCF6IIjHmMXB2dB2TumXj+w9crb/JRGN8uB7c+o1/gEDHhQEETFINnTn0yXeJ
         e9SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706043022; x=1706647822;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5LF7enKIFNTOUznrYEEtapJ8sft39y4HKd2BucZR1Mw=;
        b=lVf3F0oqDI4OxVAr066MwFJrRnqngTxHBUrqJBCy96jinBRklS84z1/IjlWo5qC5Vu
         ThUsmA0VdiXDT7F3RJo+ccYvNWKsT1TIUWdiT7jBLJyhXCs3aipoFl/WKrxQSaaw++px
         RbiFy3AB1fi4Duw0Bsizd4YSQYuBf45Rj0ed8RQgvaIKka2Z7wHQZMiB43sKiI0L6CMp
         NGSS9QeDfmeEXQTTCs3yclfcc9CqSqBBIxFDWxOT1xFfzpLOopeTbx9Zn6uABBVk8+ZW
         VsD57NvnUZy9LvxeB+EcFtR8qXmqsl8ygwq9I5TjNMFsB8w/pA/eREPy1fAzMfQZBUkw
         nALA==
X-Gm-Message-State: AOJu0Yy8Sxc3377tQo9M8FzNC87m8iSRvbluj7GbmB64Kh8J9fW+f5/h
	0jp6UdaZaj17IpV3x0C7pZTy0xnmC7CXtGE4VqlRx020TRVp0Emr
X-Google-Smtp-Source: AGHT+IHdVI184z55d5YhUolFX5crq2ms343Z3EOUHGOQkMLHUdodRWz6ayfcD7zn9uBDx+Z8RFQvNQ==
X-Received: by 2002:a17:902:dac6:b0:1d7:1e5d:ab41 with SMTP id q6-20020a170902dac600b001d71e5dab41mr9094949plx.29.1706043021874;
        Tue, 23 Jan 2024 12:50:21 -0800 (PST)
Received: from westworld (209-147-138-147.nat.asu.edu. [209.147.138.147])
        by smtp.gmail.com with ESMTPSA id s4-20020a170902988400b001d7180b107fsm7792973plp.228.2024.01.23.12.50.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jan 2024 12:50:21 -0800 (PST)
Date: Tue, 23 Jan 2024 13:50:19 -0700
From: Kyle Zeng <zengyhkyle@gmail.com>
To: linkinjeon@kernel.org, sfrench@samba.org, senozhatsky@chromium.org,
	tom@talpey.com, linux-cifs@vger.kernel.org
Subject: [PATCH] fs/smb/server: fix off-by-one in ksmbd_nl_policy
Message-ID: <ZbAmi0VQRY2zdLN6@westworld>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The size of the policy array should be one larger than genl_family.maxattr, or it
will lead to an off-by-one read during nlattr parsing because
gennl_family.maxattr should be the *largest expected* value

Signed-off-by: Kyle Zeng <zengyhkyle@gmail.com>
---
 fs/smb/server/transport_ipc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/transport_ipc.c b/fs/smb/server/transport_ipc.c
index b49d47bdafc..185db4d7f2b 100644
--- a/fs/smb/server/transport_ipc.c
+++ b/fs/smb/server/transport_ipc.c
@@ -74,7 +74,7 @@ static int handle_unsupported_event(struct sk_buff *skb, struct genl_info *info)
 static int handle_generic_event(struct sk_buff *skb, struct genl_info *info);
 static int ksmbd_ipc_heartbeat_request(void);
 
-static const struct nla_policy ksmbd_nl_policy[KSMBD_EVENT_MAX] = {
+static const struct nla_policy ksmbd_nl_policy[KSMBD_EVENT_MAX + 1] = {
 	[KSMBD_EVENT_UNSPEC] = {
 		.len = 0,
 	},
-- 
2.34.1

