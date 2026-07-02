Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AE463EDAD7
	for <linux-cifs@vger.kernel.org>; Thu,  2 Jul 2026 11:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782992153; cv=none; b=j5kZhhwLmFzuTV3EtXbdQiLtWZBHR8axCG7Q4wvWqopaZ90rOiBtWhBz2JuUMdxkeGt30GDFoZGS+wMVgw6kUHV/Uq1dDYvj7thDNO8wMS9P/m5DMn5t+FjpD8mTy8nhpL6DLs5sFop1IpEp4GLxWRjx1aXchJGgdMPV+DzXTZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782992153; c=relaxed/simple;
	bh=ClC1uKuiElXSvWmJTOsgGowv+7R1ofjOVTs9KR2qPRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u0GXqy5fvo1xSN+rZ+YxtsGUkW1kx12sJjBCG5l8tABUN7Y0Jjpzk3JnY1yY1xXYjdWBHL+8l4XXLP8pWv3l3SmidWF9fKAYjqPd+bY/EfD9OEDPun3sx9iGGfQXIO+NeJEjTN4i3h+d09wP0esspy2gSnhVgUu5emlrIl3Gyfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hTM+NAWM; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hTM+NAWM"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-37e0fb87b75so1603304a91.3
        for <linux-cifs@vger.kernel.org>; Thu, 02 Jul 2026 04:35:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782992147; x=1783596947; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jbIkUPSQ7BygeeUK1aGO1/3MaHE0rFjkGYWuuq22VXQ=;
        b=hTM+NAWMeiAOReTpGoF5NAh2vN/XqQeq5zJKvv/kyFefH02ybltwnIe59AAVwR3klC
         gdIOZ1aI/eEiaD2g7omXJcNcsRNqPeFuzSklgrrSvzZA4yA+kaXEV3zNoPCrSYW0JrLA
         Us0NwB6LQkQiJUPhRBpzZDjDDyHcK4kzjgpp0tvEIWX02LzHqyKPazr1bUbE/VcVRJhe
         MEHbSmkQtVdQDpF3OBC0e8T2HGb7BplWigft8n7Nlt8gMHH+o+MC+fNt7nSJJqpGQQCM
         dVcxaeMYJ9B+4f8v6kcEDHH8gDp/FJXZD3Py26vh3nwhTSAjtPGp0TBQ7aa/Agd17ioL
         pI+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782992147; x=1783596947;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jbIkUPSQ7BygeeUK1aGO1/3MaHE0rFjkGYWuuq22VXQ=;
        b=pK4nVdxSwoiyTPeEkxteYeHr69PQ522QRVbBjpMLPE3v1yOwtFRLDAj3yO9lP+88Dj
         lq7Cb77jvjuPuXB7Dl/VQz88keiT6SGTJn+VCV5PdLYFTAKFeLaYOxV1hpR4mvpipc7X
         YFJOd7Hh8hA2orO3MacIqApna/9Nf/DTxXh8SLJv09PIvFle8671T5BfjKdoBIAJQ3oh
         1w0I5V1oKgUc7YG96Js0JUOo8ts244uow9oB4UtxQ/TUJkvhAfYwoKA2cVt4QImITJHO
         CaOu9QEYVsdJ4lmBRJZZ0ia04caWKy3pSJjwqRGup3tC8XUluooRdiJjjptJAfK+gHm0
         aiTg==
X-Gm-Message-State: AOJu0Yynba41U+4vzqRPc6/RVGC+h5HCEY8dOCPJtrvNnBiyBxONZ5u0
	Qdi5cL6960BIjzdQolTsPZX2qnsaMDs2LMx0iOgLggnCOm4MtkRsC5fxH58AOQ==
X-Gm-Gg: AfdE7cl7opcmKnkT2eftiYu/mSCEGWVaFkIsA5Cke8IQSe8nm7iiTAfXFxXBaT6R1Il
	nA07I2lUF30BOtBsTg50XABr+GPFVUgvRQwichckPt05d2VOwiMT1FD8ypG5fp2GNc1lsZxYXlz
	fet0xDRvM7EI+EchKUHf+sIFc1kvEp5hCPEBKOOm5aKpE5+JoqI7MWUif1Wi4E30sd9jfTvRd0J
	vpOavh7kKYCCD20MIpnZ3omAIpjxIBA+571RI1QvB7didRkdZHJdGCyEzkxVlWyXfKloCp8Cvjm
	95hvANQuZvSUBSOamuiFzMf/oHd9/S3tZ6QHBqyMkHx1i6XUVQDnj/hppmuMGi+Jg/QNfe++cV/
	O1ltp5mPy/wT21G7LmKnRXKu8DUsPbak9ReEHJQV8EcsdnsU9osPTXQIhdQDWIMHUHAXnzV6Y1p
	BRWo2M9EdgJEjKAP3Eq2G5+fY814pl34oOuSKLe2qlLcxO8FqtgyYK2vwU/HjVSIqD4AEcar54G
	7QWo7v4ZXEk
X-Received: by 2002:a17:90b:3c4f:b0:37f:c22a:c188 with SMTP id 98e67ed59e1d1-380aa07e1c1mr6069289a91.4.1782992146896;
        Thu, 02 Jul 2026 04:35:46 -0700 (PDT)
Received: from dev-vm-rm.hzz4ddxqtfeetjrh00qlbgyytb.rx.internal.cloudapp.net ([20.197.52.255])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30f0bb7fd75sm9444824eec.19.2026.07.02.04.35.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2026 04:35:46 -0700 (PDT)
From: rajasimandalos@gmail.com
To: linux-cifs@vger.kernel.org
Cc: bharathsm@microsoft.com,
	msetiya@microsoft.com,
	smfrench@gmail.com,
	sfrench@samba.org,
	stfrench@microsoft.com,
	Rajasi Mandal <rajasimandal@microsoft.com>
Subject: [PATCH 2/9] smb: client: block non-reconfigurable option changes on remount
Date: Thu,  2 Jul 2026 11:35:28 +0000
Message-ID: <20260702113535.4044308-3-rajasimandalos@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260702113535.4044308-1-rajasimandalos@gmail.com>
References: <20260702113535.4044308-1-rajasimandalos@gmail.com>
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

