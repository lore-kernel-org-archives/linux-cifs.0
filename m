Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADE1D269CE6
	for <linux-cifs@vger.kernel.org>; Fri, 26 Dec 2025 20:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766780407; cv=none; b=fWbj2gfTWUzV0Yo8FA+tHaoiZc4Z3Le2mjqRnt45C9MWVfNhPM9munD27uEx0LZOz2LCAtkB1bue/NRGyfUBSJ3ZOXtSjx5nyeDHLBcMDdnLmMXPkeQuWu8hRv0hdb1pPSZyvEW4B9rT/qziSt9cKtdcZQyOkfmwOljvvXIn4mI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766780407; c=relaxed/simple;
	bh=e4F2nAzJ607ZTguxP+58bxu3fH2agDrP/Gt4OrB0H5c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Few0x5VpX7KV1qA0Ie1uxOtT2kpOTQi28ekpE7GpgRymXDCA/tISiJuY/UJC9RsPKgND2VE9XWq0EF1dsfYB4dU70q859pHzMuUspnTMV0r1ASrlp0LVeQ3uJymrIvOmLinryZgxG1dRzF/xqUgEGGkM/S6OuwjID8/4EcKzHAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OnAPj9xW; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OnAPj9xW"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2a097cc08d5so17192985ad.0
        for <linux-cifs@vger.kernel.org>; Fri, 26 Dec 2025 12:20:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766780405; x=1767385205; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1FRUp2JQxVKmdWvwYP9Oq102CoI/Npw11/ASCLtINbg=;
        b=OnAPj9xWeAu134KX0i84kgzV89nRmP3FB2WD5cyB3C4DcR0t+BFpY+FfEz14VTJ+vH
         Bh4wtPWS3eikomwuhShWGhfJVP2OuttKEBz+UUyHHOSkkn5PZQN7YW0KXw9gICLevp7a
         wR8VUeLTfunO+u+9UOhxGj/1nqlZpqYPfBmF5ebtfh+FZ/gyVR+AQ/Sfxcl2zdsv3nXv
         bR+KTKQYdHhQl5PqfPVrF6SwuAd6QM+BgDMBBJQnbuE3U/iynROZ1IMqAFFpHFEWeSgt
         6JEqBpJ2WuxpwKQaTb3Homy9nFZQQ5TaEVaYBvbs6CLdDwIJq3o/sO9XNEkQ+M0whoby
         i0LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766780405; x=1767385205;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1FRUp2JQxVKmdWvwYP9Oq102CoI/Npw11/ASCLtINbg=;
        b=eBinY5CUA8NG2r+uBf2Ht5v8LkWsgWKsxhrrq+6/Vatpmb71F0qhpT9XcUVtACjKSs
         CTGpkdCAhMiPIlz5CrxkpmjH6LN8oafGa7Q3axff4VoQKWkFaDAlWQ9gV5DdD1cPACYR
         TKvkOGrRiGwdRQKRhNBgm5QPmdRRvf5K9QUlFeczMNeaLk4fkL+/G45xZHbWwx/BAbQc
         rK3DBAflq0lFtat1EtXN4f1QoSD75ac7mvJT1s1VfcssnKo57A2ycxbt4e5JySJvGiIy
         o8dvXGc5PicPkyrxKYL/yIg0EnO9gffLHDQKOhlKfl6pXh7oXsrJNKNLdnxWI7kRSuGC
         a7yw==
X-Gm-Message-State: AOJu0YyO1m/XvOcKNVbHWoVAN2IgmWHpCNv/KHP2F17ZkzoMymJHCLBA
	yv7lCVRECp7wY8kxTho+ZTYRbMmFqCnywhU43nFE4jpKocUB9cN5snek
X-Gm-Gg: AY/fxX4SOAavOIdDy6lWBhNvUzIFz0nrouZRXzNkFgB7aUfpuEEyiFqpOC5GrAe+S+X
	5Yyju5HgynoHQ42HGBf6ow2ow6y2f7bgLogXHD5/FpOP1m4ul3dcPDV8bGSq/TgXB3GBBrIqpph
	7jRJG1VfoN4RtHnfc2ZIion/8vdYZNcmQTFGtllNh10GN/ff2XvW32Zrs6FSlhWk0/uATCoLikz
	yaSjPhfNSN0FYqVN4b3JlqM/xNJZG3WJC4ZipXF9RxR+lSyUhzLfefH4yvrubgJb+1Y9g8QUmEv
	tJucQe9CNCtl266MhP+GkTA2A2+AjjvTo9XTQ7WkfQnWM3/oUA3krpyhw+2Sdf+COn7EX64bJhH
	rF5zdI+k/U7d3xIf8pqqTLgQGWUyMP3I3wvzj5TXMzJLYtpPDe31b2tglyunEoBXu1zJC+VqbHV
	6RyLlY/aSLDLC0gps=
X-Google-Smtp-Source: AGHT+IHGDzJCm7bct33WIgTTOPlQytWsNInrq7w348+L37xLovpr3QoOyBsLGvQDTR5hOUL48ecKbg==
X-Received: by 2002:a17:903:1105:b0:2a0:c495:fc05 with SMTP id d9443c01a7336-2a2f21fc6abmr158100925ad.2.1766780404786;
        Fri, 26 Dec 2025 12:20:04 -0800 (PST)
Received: from morax ([2405:201:4039:48b0:c6f2:57d3:9f1d:7d73])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-2a2f3d4cb3csm214725345ad.58.2025.12.26.12.20.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Dec 2025 12:20:04 -0800 (PST)
From: Aaditya Kansal <aadityakansal390@gmail.com>
To: sfrench@samba.org
Cc: linux-cifs@vger.kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	Aaditya Kansal <aadityakansal390@gmail.com>
Subject: [PATCH] smb: client: terminate session upon signature verification failure
Date: Sat, 27 Dec 2025 01:49:39 +0530
Message-ID: <20251226201939.36293-1-aadityakansal390@gmail.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, when the SMB signature verification fails, the error is
logged without any action to terminate the session.

Call cifs_reconnect() to terminate the session if the signature
verification fails.

Signed-off-by: Aaditya Kansal <aadityakansal390@gmail.com>
---
 fs/smb/client/cifstransport.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/cifstransport.c b/fs/smb/client/cifstransport.c
index 28d1cee90625..89818bb983ec 100644
--- a/fs/smb/client/cifstransport.c
+++ b/fs/smb/client/cifstransport.c
@@ -169,12 +169,15 @@ cifs_check_receive(struct mid_q_entry *mid, struct TCP_Server_Info *server,
 
 		iov[0].iov_base = mid->resp_buf;
 		iov[0].iov_len = len;
-		/* FIXME: add code to kill session */
+
 		rc = cifs_verify_signature(&rqst, server,
 					   mid->sequence_number);
-		if (rc)
+		if (rc) {
 			cifs_server_dbg(VFS, "SMB signature verification returned error = %d\n",
 				 rc);
+			cifs_reconnect(server, true);
+			return rc;
+		}
 	}
 
 	/* BB special case reconnect tid and uid here? */
-- 
2.52.0

