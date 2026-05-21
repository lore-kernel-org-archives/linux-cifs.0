Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21E9C3F1ADB
	for <linux-cifs@vger.kernel.org>; Thu, 21 May 2026 13:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779371698; cv=none; b=UO64wJ3tZQFm5KzWcl7s6qgS/6gQ3LdZb4tzr+B8ZkZRQ5Fjg5kIRsO7hxHPmoYF3HvGde40TAcEapNsZ2jcyHXkAftJ3NJKCJrEKfR2eUIVpNsPOyc2HFaC646R6Mag0S+BtcxHZiBLEo8mxjgFQQ6dZ785hwy9mom2XVLYQy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779371698; c=relaxed/simple;
	bh=xWvLi1yoyODYnbCiHfDSS3dj1D9fHN52L3gXpnsCibM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VNWURO7QKR98EbY6uZNeG/uSOvbFnzw5delrt4xSTiDSn81Zkz3NdThsU3NZw13oNumFTpk9C3dXMBMug3nnyhzItuyh0VapTGujpVGP1o31mhl/ywkHncVMKhpwfNT59CtPZ9xQ/ad8E8w73DEpJyOUuXoqTmvvvJJeVCoBzCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Rtyz4kvm; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Rtyz4kvm"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-3665b67ed66so3955390a91.1
        for <linux-cifs@vger.kernel.org>; Thu, 21 May 2026 06:54:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779371696; x=1779976496; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3d46WJ7zTqrz6IjbcLi6dDK5vW5zDJ3cwMKUR6qKmug=;
        b=Rtyz4kvmPjrfs21gaYwDxc22Ux2t+OcoOFZxogyzCynZW/RdXrtMlxb4jCeF3dED/s
         EGFWCH2HEsFAf7/Q6BKgNvdDC1F+RIUWnNa1nhzW2hA06bES+GqzZ4Q+fXdDrGXYcz/d
         eZCQS6nJFER+d9Zf4bzaWduYciImmVvN/zl13+1FQrmBuYeRJNFCCRvk92LALHNzcw/8
         F4Ya5Pg8Aa4fy3L7+A/i2gG5WqXNPzcguhQBrZfRvwLY/tiicgyab3k+TcrAgT+AqlwA
         dNF1Cd9oqGcqVBD8xwRObfQVhsMlbH1Bdf3sx4pe2pRdojn4hKYk2s8AH2rrMZ//G30K
         Es4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779371696; x=1779976496;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3d46WJ7zTqrz6IjbcLi6dDK5vW5zDJ3cwMKUR6qKmug=;
        b=Es5g+intCWfZ650qQtYRn5+ASWT1svlxG67MY+gYVKe1dEkoqwcX+qqTTBnVuqzq5V
         uigro59+vhLmYPi2QD0MYySSNYsaU0M5KgurUVbsE+N0yJTwBkKjGiGfSGo/GH2xzDYR
         9FlUODhvM2Iq3UWaSdJDqJa9EhEKfiiJRC/Uzw98jtKjWb4LC4R7UYO8TyZc6me/ytvz
         hfZ5O/JAsSwihfJNk9N2lxCAzYkdNwtqkrSfyGugJVlDe7fZpcE9xtX2/DQCbQ9dOds3
         +63p9hEGQM/FOrqxx8l7KGdHf6fj6Jl3qgradRM+KONP0s5lpF519a1noZyVqeqqxetl
         oCxw==
X-Gm-Message-State: AOJu0YwDkEyW+xWy7l7Cs6X1A+6C9ZunmbuflzyibfuED3v2O5WdV2n/
	MvRrk8ZF8YAQqFZ/bNmfZu05BBkM3xhHERHWZPS39gT+33F9fx530yny
X-Gm-Gg: Acq92OEkFBx4JxpUV8cN55gNANbB6vXnwbcCq6I08fqKPNDQ45ftid8zfsSwQqaAxIZ
	j6+b9cg6qO0I9DclaGOse4pFxHxrXmJaefZqkqOfN07ZbsCdfx//lMDajyJeWkcH0n6ZfLpxOhg
	QvUQxaWrD/DeEbAe7FtApulmm+Uf1iQcHb3Ozx5D1at2LyuoGbB1TKitvLRQT7YoUYocoa4mNnD
	5oEX8Ha6I+mqTiohsfQNy0VI2rFxz2IhHHnGrsULdUY9QIpQVSohw6NE+enTm8Fa5rbA/PWl+sH
	rdw22L/yp7hdPQXp1vqMqgO4sjIOrpi8UK7cVjumyuPx5vPJWApl8eS42yZMiRxax92kO5fPo8y
	sy198tplxUJAi47VQBSh157llmcKOE8aHg4hsHdHhJ02sR7ZPwrQdG3i/nPBSznk2F8sQfH1k2b
	tqLvWwcw2NOqKDLoiKtGMxcGv5cMIwuxN9HlFOZoHJSNASatq+Es2eMIm7SRt/YHaCrgEKNDbAv
	KRMxXakJfXYrMSRFVlXcbc=
X-Received: by 2002:a17:90a:d644:b0:369:bddb:79bd with SMTP id 98e67ed59e1d1-36a45779371mr3110115a91.25.1779371696234;
        Thu, 21 May 2026 06:54:56 -0700 (PDT)
Received: from dev-vm-rm.hzz4ddxqtfeetjrh00qlbgyytb.rx.internal.cloudapp.net ([20.197.52.255])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c85197c72b3sm455378a12.4.2026.05.21.06.54.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2026 06:54:55 -0700 (PDT)
From: rajasimandalos@gmail.com
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Rajasi Mandal <rajasimandal@microsoft.com>
Subject: [PATCH v3 5/9] smb: client: sync echo_interval on remount
Date: Thu, 21 May 2026 13:54:11 +0000
Message-ID: <bc9c5a81ee3f24c8d2c296d334b26c3e86d5cbc5.1779371115.git.rajasimandal@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1779371115.git.rajasimandal@microsoft.com>
References: <cover.1779371115.git.rajasimandal@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Rajasi Mandal <rajasimandal@microsoft.com>

echo_interval is accepted during remount parsing but
server->echo_interval is only set in cifs_get_tcp_session() at
connection setup. A remount with a new echo_interval value silently
has no effect on the echo keepalive timer.

Add echo_interval to smb3_sync_server_opts() under srv_lock so the
new interval is pushed to the live server struct. Reschedule the echo
delayed work via mod_delayed_work() so the new interval takes effect
immediately rather than after the current timer fires.

Signed-off-by: Rajasi Mandal <rajasimandal@microsoft.com>
---
 fs/smb/client/fs_context.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 903b4060d5d0..f09ad5d470f3 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1307,9 +1307,9 @@ static void smb3_sync_tcon_opts(struct cifs_sb_info *cifs_sb,
 
 /*
  * Synchronize server-level options that are stored on TCP_Server_Info
- * at mount time.  These fields are consulted at runtime (retry logic)
- * so remount needs to update the live server struct in addition to
- * cifs_sb->ctx.
+ * at mount time.  These fields are consulted at runtime (echo work,
+ * retry logic) so remount needs to update the live server struct in
+ * addition to cifs_sb->ctx.
  */
 static void smb3_sync_server_opts(struct cifs_sb_info *cifs_sb)
 {
@@ -1319,7 +1319,13 @@ static void smb3_sync_server_opts(struct cifs_sb_info *cifs_sb)
 	spin_lock(&server->srv_lock);
 	if (ctx->retrans)
 		server->retrans = ctx->retrans;
+	if (ctx->echo_interval)
+		server->echo_interval = ctx->echo_interval * HZ;
 	spin_unlock(&server->srv_lock);
+
+	if (ctx->echo_interval)
+		mod_delayed_work(cifsiod_wq, &server->echo,
+				 server->echo_interval);
 }
 
 static int smb3_reconfigure(struct fs_context *fc)
-- 
2.43.0

