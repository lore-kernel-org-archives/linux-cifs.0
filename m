Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795084708;
	b=ZUjwxexamrw2PkPcsz4MJcctiMlxpfe/Ydw/GnppSugn04Rb8I0nUOLH15YQfGcKaFNY
	 6+Wyb+4J+Pc8i8P3U1c97xnx1gwiF/iCuvvCJhoit37aevagA4iZCw6YapgyM8IM01TNJ
	 K3/h0BCSsoPNGbqlPzmsfnG8hfXuK5Hyi/DM1YNOgp/wDRi6WmHw9TQrOd9r81CDGo4lh
	 ab4i8JqB0EoTKCBXYEZWov8yO6h4EEKQ1+ry/qnPX/wJJF1Vs5ZUgE5tVkOMPVO4mYFm2
	 GvGVcIP9kCOw0IIKsanaxDLhscCGJ1fgepHfO7j87ZCLvJDSri1yU4NTTKUFEnhFImg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795084708;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=+E6zgJc4jVliXxYANjctFUvwjdQDu9JHnJVdMIDdVJA=;
	b=NNDAaT2uVy37aaXDYHAfeFyvwI80KZtqD31BHRQO5kM3Au5bE0r0qKOktG767POFd3OM
	 i0KHi2zl3XRGQNn8+dCXwM7reCCDAAPE/ceQ7fMdpncbYmdW/04h4oa7bvf/WbdOr0EaP
	 tbmPC/LbbLs3hA80vsNuVLgcA4TDsNOH1mwt7AS4iahhx1HNoIOuiQDtQdf+d03OuryUz
	 SJ3I9Mgb+iffWBwWyVVcOQZORN3gaWqBL9wMqJByHTsuNmomjGkt/IxxUFjq1zSFdC13U
	 RZWbg8uyY5rIP1PvEaVXjfEI/7Cp9FnwN26Ro3t63RMQ4071AyTupeOFo12/2YSInhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=rootsys.at;
	spf=pass smtp.mailfrom=rootsys.at;
	dkim=pass header.d=rootsys.at header.i=@rootsys.at header.a=rsa-sha256 header.s=google header.b=hMDDprux;
	arc=none smtp.remote-ip=209.85.221.47
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B34B606A324
	for <linux-cifs@vger.kernel.org>; Thu, 19 Nov 2026 10:38:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4B34B606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=rootsys.at
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rootsys.at
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rootsys.at header.i=@rootsys.at header.a=rsa-sha256 header.s=google header.b=hMDDprux
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-492f0a1b685so1460792f8f.0
        for <linux-cifs@vger.kernel.org>; Thu, 19 Nov 2026 02:38:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rootsys.at; s=google; t=1795084707; x=1795689507; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+E6zgJc4jVliXxYANjctFUvwjdQDu9JHnJVdMIDdVJA=;
        b=hMDDpruxf5RGJTIjQMJrXCzAhJ+5D5P+NvxMnf06PEx58cG/UYLQsNac4O4m4T50aL
         Y6j7YJFydryRnXO0l0PchXdSDXkPabgdEWyduPk8vvZZCjCWZRYYJXM/z2iFxKua8vmZ
         KZ4B4Gb8hoNGqkU/km7rktsr0UrEtkydke9IavYMZjI6suPHEQpFE8RnFmsnxMtJYV0+
         sa8IgY0IeI+3+zlvBz0qV6BN8m250vhnjINYfbRSCvKcpqgos4t+Ulzz8vKkGowcK8go
         PwwTfLRe5yBTSpSGO5ilC9N7XDK1Yeb+9JRZXZbTMMwM2rQnHNOr3h4/T9KMI7lMFKMz
         kPzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795084707; x=1795689507;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+E6zgJc4jVliXxYANjctFUvwjdQDu9JHnJVdMIDdVJA=;
        b=b9hukHwEytNJ4bP3dTEglWvhsO286nqEeZskPU+pP1vOeg7E+qxaUsWbyO6N1A1iiy
         g+zZiR2gfIZlW/olpn0u6lULHQKudBgFcGNlb4bo4/Eh6KFjTsSMEToP7PWBvcqYO83u
         PfQon/hwE5UtzyNreO2/8IS8K/Ul7FrNELsLfi+9V8c4Q+U0hR9dzoCF4OungGL5yyaS
         X0WnHPEwJuWthoLnxW0X3Pbuj2/4XWBaeU3fjrxRpi6dfD57KnoRwwINzlW5hOGLYoff
         CsRtY85KCJ6DeHvWzN5hbkZeAiseD/aPkwDtiSTOOMDKKm8WlisD4lw9ihFesf3FXgLN
         6BxQ==
X-Forwarded-Encrypted: i=1; AL+hErEzC8zlaJ6QhwuLjyT+WDTsJSL8Ky3YgRCD2zFOHJ8UKivVIN8KFmFTM72SJkLJLx1Lrvrwjau4xGdA@vger.kernel.org
X-Gm-Message-State: APuU4Z/wiS4GDey6JoGxXdaZ4Mef22y1jNFOtfRnPz1ZVGaTYx/W0zUY
	biQK2Sh4QnMVJfPkKA/2elA1lGFJrcH7GuCMAsGyUyT785VHUfsOiXdB2t2d4OfU4YT9
X-Gm-Gg: AZFdTZelY/HbNLrkoiFJrKjJR2om5vE7NZBv2iwlE17gF9xxbJCtgtGKd9T9PFkIbYN
	8m585tTS+Ecn51OzEozXQVriNtsvHJxA6unxKpAVamx5coWVpBvv+22PUCgpwdiVLnmqygCDw2U
	7qFtN3FpudmQ2ClabXMFilF2kfQVjaJ3sWEVmCMdU/kI12X9fZpw5ZdeO7tXOWu9yT6Rrp6vQI8
	2N5OnaPRBgo12IL8wL5v1w5g3SdJRHJ0tVmApb4gJ/1kcfMwAeVLhMYkogx3gZx/+FDnA05qYLc
	G02Ujfru/DGgaqeOZqlaBnakRLgPtKOkfoskvgDknItUKBdZR2+nd8NQorg0PC02HxDubtFhZBc
	aIjlEpaKE1IhvG9AsSl3AvOV2w9XbOgTDDO3pXoblkvkNbmPSPI3Pq0rRU2umItJIPlYJv8fw32
	ed+cjyEDHFFj4/N/V4Abga020Dtwrntdo3AbkQOt6aAhSGZqlZ5QFwd8HLeLG0XYpOEGY/CM1xX
	+4gNgZA89wWPmRnYv3ozO559RqjPKmFfD3nhahdx1UzJMXZ9nuX3Xqum5oH/eWnKzd4cYHpTcjq
	/8CQlHJIFklQxM1ZABtQKX2Pl02+2ymJ0dOYg6cnNucplNzT3d3wf6k/MrUYohwLHG2H2g==
X-Received: by 2002:a5d:5c05:0:b0:4a8:98fe:5f9a with SMTP id ffacd0b85a97d-4a898fe6055mr5559719f8f.18.1795084706703;
        Thu, 19 Nov 2026 02:38:26 -0800 (PST)
Received: from rootsys.at (clnet-p094-053.ikbnet.co.at. [83.175.94.53])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4a655f9f4a7sm10030927f8f.34.2026.11.19.02.38.26
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 19 Nov 2026 02:38:26 -0800 (PST)
From: RootSys GmbH Research <team@rootsys.at>
X-Google-Original-From: RootSys GmbH Research <research@rootsys.at>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <stfrench@microsoft.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	mike.michalo@gmail.com,
	linux-cifs@vger.kernel.org
Subject: [PATCH 3/4] ksmbd: refuse tree connect without a cipher when encryption is mandatory
Date: Thu, 19 Nov 2026 11:38:04 +0100
Message-ID: <20261119103805.29514-4-research@rootsys.at>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261119103805.29514-1-research@rootsys.at>
References: <20261119103805.29514-1-research@rootsys.at>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ksmbd.conf(5) documents "smb3 encryption = mandatory" as "clients that
do not support encryption will be denied access to all shares". The
kernel does not do that: KSMBD_GLOBAL_FLAG_SMB2_ENCRYPTION only makes
the server advertise the capability and set
SMB2_SESSION_FLAG_ENCRYPT_DATA on sessions that negotiated a cipher. A
client that offers no cipher (SMB 2.1, or SMB 3.1.1 without an
encryption context) gets an ordinary plaintext session and can use
every share. That includes an attacker relaying a victim's NTLM
authentication, who chooses the NEGOTIATE contexts itself.

smb2_tree_connect() already refuses a connection without a negotiated
cipher for shares that carry KSMBD_SHARE_FLAG_ENCRYPT_DATA. Apply the
same check when encryption is mandatory for the whole server.

Found with AI-assisted code review and testing.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: RootSys GmbH Research <research@rootsys.at>
---
 fs/smb/server/smb2pdu.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 05af8f196b17..9dc46553138d 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3120,8 +3120,12 @@ int smb2_tree_connect(struct ksmbd_work *work)
 		rsp->hdr.Id.SyncId.TreeId = cpu_to_le32(status.tree_conn->id);
 		share = status.tree_conn->share_conf;
 
-		/* A share that requires encryption needs a negotiated SMB3 cipher. */
-		if (test_share_config_flag(share, KSMBD_SHARE_FLAG_ENCRYPT_DATA) &&
+		/*
+		 * A share that requires encryption, or a server configured with
+		 * mandatory encryption, needs a negotiated SMB3 cipher.
+		 */
+		if ((test_share_config_flag(share, KSMBD_SHARE_FLAG_ENCRYPT_DATA) ||
+		     server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_ENCRYPTION) &&
 		    !smb3_encryption_negotiated(conn)) {
 			ksmbd_tree_conn_disconnect(sess, status.tree_conn);
 			status.tree_conn = NULL;
-- 
2.43.0

