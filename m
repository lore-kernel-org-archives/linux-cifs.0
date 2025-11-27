Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 922CF3328F4
	for <linux-cifs@vger.kernel.org>; Thu, 27 Nov 2025 16:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764260604; cv=none; b=c5sdy2JYkGNPBxWDIeNIdkp/y32kT9bdSkn05f2Ewrlji/SI0HKC13FjbrG12fly/2YygDbPtBWavT4iIYQAAbN7aTmWIBwRyE+aDNDeoF2h791ckxvJBYmqmZ51I/fjYR42eh1AzLMooiJDk7me2PwehgaHjbVlL4QwzgQ5WmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764260604; c=relaxed/simple;
	bh=pNR7D+TTJBjGKiiyUlc/Pf9HJdEzwSoj6SuAHFN2e2M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FeJxtXIbzhW2qSJmV7Gn7FrG+n1CFjkAC4clc2G0tNnQBIRFnH1R/esrYkKyCdbkEeWI/EUHekczgCYqPXC0qp6VzKNjuNLt2hA3125BtztdQuwHdu5iVUn4Q3vx56sdfdCnV3cwnixIrMvSCTRZJLHCAxWc7mjHk4pzykWkQSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HXU6cyri; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HXU6cyri"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-59577c4c7c1so1991935e87.1
        for <linux-cifs@vger.kernel.org>; Thu, 27 Nov 2025 08:23:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764260599; x=1764865399; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=PJKUTXxj8oW3QwBeXifjlm7tJpNcI4cl2p7YPGSDDcQ=;
        b=HXU6cyrim4D93vikc/JSqTpU7fOU4+zEr+YJN9XJG0gryx63Fhk8Qhf1fduS673C6k
         y9v5ESvpBoMLnpp0OvaKm2euTU2YPt7i9V7BvKMPXwWupZGMOF3bElxcpIyxD0qttLI+
         N9hIEtoa37MQrU9Ss/hCUJsvaFf47yf7XM4QScYnyB0MgbxrsalS19T7os8Fkh1KoEc0
         8LryDX79Vg72l9ArdA9RInYEegRIbIp86QQU6B+KE/cuyW9mGTT2Qh8nSrGXSKrxRT+C
         bcjIJLkBsg7rLWRXcAC24j1euAvggulbLQke2CykkkimxRF65Uk8sOavgdI07LW8iVRf
         rUng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764260599; x=1764865399;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PJKUTXxj8oW3QwBeXifjlm7tJpNcI4cl2p7YPGSDDcQ=;
        b=NBy1jzPAEw9GLqYiN4lM3/8ic+vTjsu/lO2QKNYArz98hKbUcxESBvydZp0CZyBuBD
         M6IJBkN1p+bFkj16rXe5Zu8Zl25gFFzpYIJBKqWLROxT1KM+KeABDhBit45ooFt5kju9
         qfS/WMtHzplDfVEubDYCEKjvuZCeWz5e1k10YSgW6E1iNlhR7NUOXYho24c7z8t0Hn+U
         yNMNJx5JS9zO0bANMobmmbaR5adVBDT0jYaRGtuXjxfTnl7yvY2/5cTGiZq6KMlWYbKm
         1Bpe/vfY1TElssCe0Ui5e2WT6oRN7mnndwBo/uheRc5CaTWWoZUGfMrD/Ua/ryY0mgMc
         HXgA==
X-Forwarded-Encrypted: i=1; AJvYcCWDOVT+3msi7IrBUFK1DUJ1y4Wjq+s3U5gxIb+Mr3nPObTwl+S0CXEuPE8DYAxULrbxizBwv9yzweIr@vger.kernel.org
X-Gm-Message-State: AOJu0YwkAoi6TylqalbztGxZ0FXuHNMqNvMeE17vuMnC6xqgidZxYOSU
	bQqJ2GYsohQ+1LMFKYxrLzdm+4huf9iiShalCcD8srRsM2NG0mbn64ie
X-Gm-Gg: ASbGncsJg6G3mlRsDGujrUp8dARcJ8nbAre94RXnKRSMpktjAYB0WnGuljz+0X4uJ8J
	O1Q86BgwHrC/zFAM7dxTlgOpDWN0T817cd250Z1Rs+ySVjanDnPd1M4VB67057d74OwPvS9HEq1
	UrW1/VDfgsdtwGAFiDLVWfP7hXxhi/zE7QpcjPBECxcq5JlqDs2H/Ik7m9z41HjwhpgXlY+52BK
	0QUfLdCkjWnn8P6GAukNFki/aMTvHEq2oqhO04eec11V94WDtaFzH2aM0k2mJXh/6q3OpgP48mm
	hKc9tTn9qYm3GI16/h1tvFnGVyJq3LBGhTVEZgbCkmRZqlcGu2wniaamveaZunhZ07aN9wgRzA+
	jfnAVTT3YkzTI6Ewkcw7cZT8YRTA8hMeA3NVHcfozxujdp4iwPW+FP2dIM4GzT3pLqoNOjUbpzq
	0VpEZL4clo9oyaeFgruw==
X-Google-Smtp-Source: AGHT+IHWThZT2IhgINOAb1vObq596aimRrqw0VBy+vwKTlft5laJGKAnkt0Wk8x+sRxaQF5pz/mWMA==
X-Received: by 2002:a05:6512:3b9d:b0:595:9195:338b with SMTP id 2adb3069b0e04-596a3794b94mr7873039e87.20.1764260599009;
        Thu, 27 Nov 2025 08:23:19 -0800 (PST)
Received: from cherrypc.astralinux.ru ([81.9.21.4])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-596bfa43eefsm505644e87.65.2025.11.27.08.23.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Nov 2025 08:23:18 -0800 (PST)
From: Nazar Kalashnikov <sivartiwe@gmail.com>
To: stable@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Nazar Kalashnikov <sivartiwe@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <sfrench@samba.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org,
	Sean Heelan <seanheelan@gmail.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v2 6.6] ksmbd: fix use-after-free in session logoff
Date: Thu, 27 Nov 2025 19:23:37 +0300
Message-ID: <20251127162338.7276-1-sivartiwe@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sean Heelan <seanheelan@gmail.com>

commit 2fc9feff45d92a92cd5f96487655d5be23fb7e2b upstream.

The sess->user object can currently be in use by another thread, for
example if another connection has sent a session setup request to
bind to the session being free'd. The handler for that connection could
be in the smb2_sess_setup function which makes use of sess->user.

Signed-off-by: Sean Heelan <seanheelan@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Nazar Kalashnikov <sivartiwe@gmail.com>
---
v2: Fix duplicate From: header
Backport fix for CVE-2025-37899
 fs/smb/server/smb2pdu.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 9f64808c7917..a819f198c333 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2255,10 +2255,6 @@ int smb2_session_logoff(struct ksmbd_work *work)
 	sess->state = SMB2_SESSION_EXPIRED;
 	up_write(&conn->session_lock);
 
-	if (sess->user) {
-		ksmbd_free_user(sess->user);
-		sess->user = NULL;
-	}
 	ksmbd_all_conn_set_status(sess_id, KSMBD_SESS_NEED_SETUP);
 
 	rsp->StructureSize = cpu_to_le16(4);
-- 
2.43.0

