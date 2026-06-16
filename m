Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CC2B3D75B8
	for <linux-cifs@vger.kernel.org>; Tue, 16 Jun 2026 05:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781589253; cv=none; b=h2jotqG4z7nEVu/sg/17X+k5IES+GZq0d5hDsl/dQ3T6a428rdqjhNAsvCYIdR1wfqDli+8ofNpz6iudKrHR2Dn+uiPO5nBzFAkTIzy0qWQiF2UITBYBJ+j1vCQoYwCazFWH4wWwkCREv4tO1mfau4brumCDn+qHrwgn1sm1USs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781589253; c=relaxed/simple;
	bh=ClC1uKuiElXSvWmJTOsgGowv+7R1ofjOVTs9KR2qPRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pp3/XPECScCEWduHNGGxqOnDL14TXJehu+BiV2vPsTetH6rUq5M/MuuD6cSNGMIh/6ZnjB5oYUsUF3BepOiBGvP5g5QYmu+ZgQecYfYNgkLWhSKxnAuCqDQpydAg9wTfPfoeaCg1rOMwq2hNJxi2ORsAmKxcn8sN5aYZS0eEb3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Uvhok5RP; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Uvhok5RP"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2c0c2c7d45eso37062165ad.1
        for <linux-cifs@vger.kernel.org>; Mon, 15 Jun 2026 22:54:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781589252; x=1782194052; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jbIkUPSQ7BygeeUK1aGO1/3MaHE0rFjkGYWuuq22VXQ=;
        b=Uvhok5RPgMx9xqPe6sk0PM+eakJoZz8mRNsRdvj/OuvicHsVq9/8Jih1q4g9aUau6g
         LFcR3FTEgEYkHbYLNaxQR+0RYjNEE3uSf+VCrAEc+sNH8EfJuFDgECAd+0OrM9IYdR9K
         qy4Ue3GaEbZKBgQtLSzFP7ApZqAIs6N0L9KigJwjGRPGZfZYcNJ1ZguL3WOhxBgdrUlE
         RsaJRGqjxl4EA6eu6fOW4XUxo34TiuiiJpthhvg8ybOn0s0haT7zciloDS+Ke9q7l4PJ
         lm40ApslSF4mUta/1wB3u7nNg1iDFmM+2/Z+odGNx86/Rec8souVKtOmBN6SjRqDQ90u
         uBaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781589252; x=1782194052;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jbIkUPSQ7BygeeUK1aGO1/3MaHE0rFjkGYWuuq22VXQ=;
        b=JC8Ur46pHOlt6oquXkQnoZlEGCGeEcLfay/DUBKAvXtylugDubNlJVRbT2rd2qilr4
         48NUbXhk6IsHLR7VixMXLjufOMzHyfZp0x1TTjT27nPPzEPZQFB6x3MKklBdfObl/vI8
         Dyjf17e2Dmx+ZaBWLyu4cxkvCfKfxBmwa7Da32uTFfZdKx6n2cB1+9BYbFjnx+MWkxBx
         /W9gY+dmyzKnTnXAHUht9skvdY8SHdf7/s4mPjE4uItlIpBBI8s8qUphTTcrbO7izh8U
         pUqV2Sy1uNll0uP082c5ZFECamnrSffzCVxtQ1pMZJ1HPwrel+jmV6VrxCfr06WYNCiP
         EDOQ==
X-Gm-Message-State: AOJu0YxWA65abrQZNdb8fkQnaKkkt/WcZW3wTMZVZ5RYMuIEovxg1LUP
	6JWb72JyKSRt11Wg7CrRc0AbyM3QPcNDNkBULOBa+hHn5lcgXGtEZ/GS
X-Gm-Gg: Acq92OH4Uz9rQgkS8QSgRQ7qZsI2eyZFd3PYh7SpCUGa18F3qVbcXsqYwxZE6whe+8X
	EoqjSsFUQVRE/Q6g5mvjPqjKqR+U6OiHnk/Y5dqyPJrhi95ODqAOqobaxvj7KxgVt0wqTxw4GK9
	mprvwfj8j5SQYqYIG5dYk3iNsD1ffc01rZvkqumFaPJN2enKSzrhQxR6eb6H1iOIw7lzUzGINZd
	PwN5qONIFRFZZH3neUpjUifsSBtz+BspKKuPvpJghNR/KFSs9cdLI6dokCQOr6DyfUk54BwdHnk
	rZHCOBy6ardQitsFVCoAqwI2BgA0pbMFgpSzdDR95uZQ+VNhi26JCI+lH30k0y639RceG3BoGXV
	My3D14N5tv1Vx/TC/MkG2YsiR2pYM4+C+eXkr6cQKdLiJF6pZ32z6mvPXScS6RrnlnGMKra87It
	8Tss/jAA4uMIlxRdAESH7G3dS5T6khDR84aTYyhWJVlamJbWVvIdi3BMQEMgb5ThRrGvuYuTJxK
	IXtvUE8T0LgYlmjDduXdlg=
X-Received: by 2002:a17:903:15c7:b0:2c6:8b39:7324 with SMTP id d9443c01a7336-2c69a17a930mr23299565ad.17.1781589251710;
        Mon, 15 Jun 2026 22:54:11 -0700 (PDT)
Received: from dev-vm-rm.hzz4ddxqtfeetjrh00qlbgyytb.rx.internal.cloudapp.net ([20.197.52.255])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c42f2e52b5sm120805275ad.7.2026.06.15.22.54.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2026 22:54:11 -0700 (PDT)
From: rajasimandalos@gmail.com
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Meetakshi Setiya <meetakshisetiyaoss@gmail.com>,
	Rajasi Mandal <rajasimandal@microsoft.com>,
	Meetakshi Setiya <msetiya@microsoft.com>
Subject: [PATCH v4 2/7] smb: client: block non-reconfigurable option changes on remount
Date: Tue, 16 Jun 2026 05:53:52 +0000
Message-ID: <20260616055357.3798387-3-rajasimandalos@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260616055357.3798387-1-rajasimandalos@gmail.com>
References: <20260616055357.3798387-1-rajasimandalos@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Rajasi Mandal <rajasimandal@microsoft.com>

Several mount options (seal, sign, vers, ip, rdma, nosharesock,
persistent/resilient handles, etc.) require tearing down the
connection to take effect, but smb3_verify_reconfigure_ctx() does
not reject them.  A remount that changes any of these silently
ignores the new value, confusing users.

Now that smb3_init_fs_context() duplicates the live context (with
runtime state synced in) on reconfigure, simple != checks in
smb3_verify_reconfigure_ctx() are sound -- a difference between
new_ctx and old_ctx represents a real, intentional change by the
user rather than a spurious mismatch against init defaults.

Add comprehensive checks for connection-tied options with clear
error messages so the user sees why the remount failed.

Signed-off-by: Rajasi Mandal <rajasimandal@microsoft.com>
Reviewed-by: Meetakshi Setiya <msetiya@microsoft.com>
---
 fs/smb/client/fs_context.c | 141 +++++++++++++++++++++++++++++++++++++
 1 file changed, 141 insertions(+)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 576a78b6d0cb..d5a7d4dd402b 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1070,6 +1070,147 @@ static int smb3_verify_reconfigure_ctx(struct fs_context *fc,
 		cifs_errorf(fc, "can not change nbsessinit during remount\n");
 		return -EINVAL;
 	}
+	if (new_ctx->compress != old_ctx->compress) {
+		cifs_errorf(fc, "can not change compress during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->noblocksnd != old_ctx->noblocksnd) {
+		cifs_errorf(fc, "can not change noblocksend during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->noautotune != old_ctx->noautotune) {
+		cifs_errorf(fc, "can not change noautotune during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->no_sparse != old_ctx->no_sparse) {
+		cifs_errorf(fc, "can not change nosparse during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->nodelete != old_ctx->nodelete) {
+		cifs_errorf(fc, "can not change nodelete during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->cruid_specified &&
+	    !uid_eq(new_ctx->cred_uid, old_ctx->cred_uid)) {
+		cifs_errorf(fc, "can not change cruid during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->port != old_ctx->port) {
+		cifs_errorf(fc, "can not change port during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->min_offload != old_ctx->min_offload) {
+		cifs_errorf(fc, "can not change min_enc_offload during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->echo_interval != old_ctx->echo_interval) {
+		cifs_errorf(fc, "can not change echo_interval during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->snapshot_time != old_ctx->snapshot_time) {
+		cifs_errorf(fc, "can not change snapshot during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->max_credits != old_ctx->max_credits) {
+		cifs_errorf(fc, "can not change max_credits during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->handle_timeout != old_ctx->handle_timeout) {
+		cifs_errorf(fc, "can not change handletimeout during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->got_ip &&
+	    !cifs_match_ipaddr((struct sockaddr *)&new_ctx->dstaddr,
+			       (struct sockaddr *)&old_ctx->dstaddr)) {
+		cifs_errorf(fc, "can not change ip during remount\n");
+		return -EINVAL;
+	}
+	if (!cifs_match_ipaddr((struct sockaddr *)&new_ctx->srcaddr,
+			       (struct sockaddr *)&old_ctx->srcaddr)) {
+		cifs_errorf(fc, "can not change srcaddr during remount\n");
+		return -EINVAL;
+	}
+	if (memcmp(new_ctx->source_rfc1001_name, old_ctx->source_rfc1001_name,
+		   RFC1001_NAME_LEN)) {
+		cifs_errorf(fc, "can not change netbiosname during remount\n");
+		return -EINVAL;
+	}
+	if (memcmp(new_ctx->target_rfc1001_name, old_ctx->target_rfc1001_name,
+		   RFC1001_NAME_LEN)) {
+		cifs_errorf(fc, "can not change servern during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->got_version &&
+	    (new_ctx->ops != old_ctx->ops || new_ctx->vals != old_ctx->vals)) {
+		cifs_errorf(fc, "can not change vers during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->witness != old_ctx->witness) {
+		cifs_errorf(fc, "can not change witness during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->rootfs != old_ctx->rootfs) {
+		cifs_errorf(fc, "can not change rootfs during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->linux_ext != old_ctx->linux_ext ||
+	    new_ctx->no_linux_ext != old_ctx->no_linux_ext) {
+		cifs_errorf(fc, "can not change unix during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->nocase != old_ctx->nocase) {
+		cifs_errorf(fc, "can not change nocase during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->intr != old_ctx->intr) {
+		cifs_errorf(fc, "can not change intr during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->no_psx_acl != old_ctx->no_psx_acl) {
+		cifs_errorf(fc, "can not change acl during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->local_lease != old_ctx->local_lease) {
+		cifs_errorf(fc, "can not change locallease during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->sign != old_ctx->sign) {
+		cifs_errorf(fc, "can not change sign during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->ignore_signature != old_ctx->ignore_signature) {
+		cifs_errorf(fc, "can not change ignore_signature during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->seal != old_ctx->seal) {
+		cifs_errorf(fc, "can not change seal during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->nosharesock != old_ctx->nosharesock) {
+		cifs_errorf(fc, "can not change nosharesock during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->persistent != old_ctx->persistent ||
+	    new_ctx->nopersistent != old_ctx->nopersistent) {
+		cifs_errorf(fc, "can not change persistenthandles during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->resilient != old_ctx->resilient) {
+		cifs_errorf(fc, "can not change resilienthandles during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->sockopt_tcp_nodelay != old_ctx->sockopt_tcp_nodelay) {
+		cifs_errorf(fc, "can not change tcpnodelay during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->domainauto != old_ctx->domainauto) {
+		cifs_errorf(fc, "can not change domainauto during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->rdma != old_ctx->rdma) {
+		cifs_errorf(fc, "can not change rdma during remount\n");
+		return -EINVAL;
+	}
 
 	return 0;
 }
-- 
2.43.0

