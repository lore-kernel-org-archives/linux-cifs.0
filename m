Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B0E3DD87E
	for <linux-cifs@vger.kernel.org>; Thu, 21 May 2026 13:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779371687; cv=none; b=uKH8hpn1jZmcHgsTLW3pabpb4usn3t49VfQeLbt5CdaxR0X1yqwy2uV6oC/8kgoSHt5Ef0870dGkTXl1I3sqXZIbxi/da9AW4dShB6V9B/w3pd+rHa6B9O3CYp9byn7uZAfqNCXzV9YH2Ocg3hw08S0xBwXEpOPA3S4go61YCDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779371687; c=relaxed/simple;
	bh=nYGXdwpc8GcUzVkXS9NXtV+mLT8i/xkjrbIQiskHE/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t4X0oQBlp6pM2zbzYGkVe7ACJGJChCVo9xy+9VFxQ6V4d2vUtwejq3uklzXcY6uwl+e71GAh4Yj7lGVzf/zxaudxbx5te688eCZw2D0JLiYUvUf9ejh48mc2kfH1yc+oFtxj9uVwtVPfJUzXhucvYxW7nQwkWQ4fiyjkIje0xB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ku8+6y+k; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ku8+6y+k"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-c80227c9572so2868377a12.2
        for <linux-cifs@vger.kernel.org>; Thu, 21 May 2026 06:54:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779371686; x=1779976486; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qW+lr0hx7HYrcP+8C0V2LOEx2Ctr7Xu1/3AsyXMtBps=;
        b=Ku8+6y+kvlwX3O3XbnT9AVWNE5P0kDAASJ7J3w9ZOjADVgGxYf2D8guw2HRLDrcKRd
         oq3rHyUeEPw/Fp9YmEImdPH5ocBzqoSmRpbxTA8hj4RXZPu3c4RSTmDRp7TZ1NrAnaqO
         FF9EsUlCcnKXSWsYjBv2SucR0WUWURcIPUC4MSK6BpAlC+uGdRocI8z23KLWNTCn+SOE
         AdHXdHlAGHgkTlqDAXguE/i6Bx5qMTyP9yPFO9kxiR+cWvRilRDRnwve1o8S89ZQD+AD
         p+yJbUaV5eLBbBINZk/hsvdIJuyiyFiJYQ1LWuGxTSiRq6yuUBRx4rKMxK9jm61cNTcv
         otgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779371686; x=1779976486;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qW+lr0hx7HYrcP+8C0V2LOEx2Ctr7Xu1/3AsyXMtBps=;
        b=a1kBEQX5fq/PlY3GGsqi16ULF8wjEUpvJU5/vLeiRdULF0xBmHbduGIGnaP77qXIvY
         PTW/lp+Re5B1kamLLRmJMe3wOZsLPj/dp/+qslY2J7onBYlgU7rj1cD7rqcURpgy0c4s
         EADCpRAn/xhYhaetW5GCdJUb03KWJplEQaVXLPJDYUdXJ0C/DLQB9TubXQRIL/bcG63Q
         j1mSsCN9DwtFq+kzSTFHQtGpaAS+jTC3rDpBhBH9zquYmNncmq0/8wtSNuHGAYm+40ej
         HQoZS+R4QlHwfegPBhlrXB7ErlX8LQxEhdRJBMlnlWWT/utnTSh2in1nyaNqj6t1voDI
         2w4g==
X-Gm-Message-State: AOJu0YxxGr6TPpgNXDLTWoIItpwJSgTrCCTI6ayjg9zpt/pPYG5lgFtc
	BE26XoJl7raTEc9LtB9FtP/ToIVs9hH3iaT1M+OqnyJvBK1kSUHjr9jj
X-Gm-Gg: Acq92OEzqDveuXX6WuaJ1++WIPNlmXjIZ9SVE5tCG829t90RExKVLGJ0Vt0kocQy/MQ
	rs+DxK5GIuzB4Khl+LnOl944z2ZCYi0I0j9edlb1yYrQZakyqyKalWiSiKwg/cqZSLdBK363NbN
	4BWleI4FXkBGt0mKd3z0+WpRTjPAGgUZG+SSXx3FtFlbGqT+HsDZxbRCSbxQBUORxq8bGsnkwX0
	yhYdQJXHg4oqKePClnm1q07jD7ARlKVBa9FkNPzGDImDdDbV91sExbwHlPyZnlX9fSASeIklSxX
	WpVimROTqnu9x2be1LW3Ug7+5zdivEBgGxX/dM89Rp29dKjRkgyr2ax6buAGvx2lpksBV0jTFni
	TIyL1gnLgM9U4h7gJPK+ZZHVP0bnoXsz2D2cI7e7m62okgKheyoBE/1XnwPSDif5mhB6wI5iTy9
	wMVvz2S1Jg1GPUMwofQ3F+B9OOtyp1E2qxImjJqJob9B5ECzOy5OFy9S6LXx3tJAsCK4A2gTQR1
	TDc/h7fxykx01jQ/B80k7ppvyiohNBZJQ==
X-Received: by 2002:a05:6300:210a:b0:39c:4af6:4309 with SMTP id adf61e73a8af0-3b308586320mr3614844637.12.1779371685696;
        Thu, 21 May 2026 06:54:45 -0700 (PDT)
Received: from dev-vm-rm.hzz4ddxqtfeetjrh00qlbgyytb.rx.internal.cloudapp.net ([20.197.52.255])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c85197c72b3sm455378a12.4.2026.05.21.06.54.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2026 06:54:45 -0700 (PDT)
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
Subject: [PATCH v3 2/9] smb: client: block non-reconfigurable option changes on remount
Date: Thu, 21 May 2026 13:54:08 +0000
Message-ID: <2421f42fd19e97a595262946def5131aa1ed1ed7.1779371115.git.rajasimandal@microsoft.com>
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
---
 fs/smb/client/fs_context.c | 137 +++++++++++++++++++++++++++++++++++++
 1 file changed, 137 insertions(+)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index b93d6ef13463..0677aad237e8 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1069,6 +1069,143 @@ static int smb3_verify_reconfigure_ctx(struct fs_context *fc,
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
+	if (((struct sockaddr *)&new_ctx->srcaddr)->sa_family != AF_UNSPEC &&
+	    memcmp(&new_ctx->srcaddr, &old_ctx->srcaddr, sizeof(new_ctx->srcaddr))) {
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

