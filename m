Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8907C328628
	for <linux-cifs@vger.kernel.org>; Mon, 19 Jan 2026 16:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768841110; cv=none; b=BIsSUMyI/cE1Wlps/bz9di5fr8WOae0PoAlcGYxhJlyUYLfULTMN6wSiJmqZgawf+uydTrvZjyETAYoua6+OvDxp35pVNXgZVb2nKRy02eyU2wJFUh/G45+cp1dLB0+Ov2/e5YzchqRoS5VdGhfFMvhjxJk8dTt03Zjx8zW68Qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768841110; c=relaxed/simple;
	bh=vg1HJ0lASWRUSg99l/JqDVbMo7uWC0RAD98DWUZjV84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FPwgYXV/Y4BZrS4F9nHDHsi2jZMnWVGLzlGJrnhG30Ib8/g2e2e3DDUtScu6SHIgie9pAJ9fTMTbgClqSFlzDxD9L2/bb1Q5MDJ0TxxJbvmofo6myyoN+QBMq4FSbZhTVMfowArzgE496o45PWhwTA/GUSSRpCt4em7Uv0ym7lM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=AfADqyjz; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="AfADqyjz"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-47ee07570deso30453785e9.1
        for <linux-cifs@vger.kernel.org>; Mon, 19 Jan 2026 08:45:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1768841107; x=1769445907; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jPIXkPo3hRlUydy85BsqpMv6Vo8VAERg8M4WsTzUfYM=;
        b=AfADqyjzmxoRTLeEVI7zGWLqJbP49GtFm6yrpTEA1lqkrp5ShghPAAi5HArUKAMqYS
         hK0h+2Lcl4tSqQ2F5twDlib6qMlnE+GbLAUAmMJ6YBCBqWuYRMXz+pRL5Br+iqTm6WWG
         K8YWW8UwRwE1gqk4SQcdbp4ytFzBYXBcHL4ccgvwG+FFGjDTdBZJCyYiKegStyxkTUXx
         FJKmUh3hqcSmSgKs34gxp+lwOgaW5vANGYXRy4TcvnJK4hiFtmH+f/IoD8V9TGq0CBu9
         +6LPXM8qkJPAhAzX65GBSOZWLuFIrwdmPqHiePPiCC9Rbp1f0mCHcB06xYVpcx6Hif6Y
         qXMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768841107; x=1769445907;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jPIXkPo3hRlUydy85BsqpMv6Vo8VAERg8M4WsTzUfYM=;
        b=JAqfRLexe0S2AOXa+vnz/mDqMZPyJXkw1j6sK13aV+Imz3EiCt5w1VPb17/7zY4eeJ
         gqJkEjeQ0dSKc0rAkjZ5S8Xb8n7686gN+JMMqo+hwVUihWJRx6gGq8GQPjHgp16Fwnhr
         qQbVarKNsb5pE4Fs5g2iKhJM+C6pjJY7EVGJul7+CugLt8mEffXuBR5be3DhMpxRMTwK
         52rPHdTYOOE+CO19VLD52gNWI23aP6sH7Tr9OIon9xAD4fIayciS84+RSuPmbduN2OPp
         m9f2r8+R/ieylmrpxyi1uNZg3SsD09rClmJXTFdEkASgGkm/rbv5DeS/DYxQeQJLVYSd
         Ukuw==
X-Forwarded-Encrypted: i=1; AJvYcCW9H/FA95YZnVWOqFVW/IgCAGal/pYfglFc4jtbNavdAGTwNIjVUgpkiRL9FJxD8b2cjJCaeWc4raDq@vger.kernel.org
X-Gm-Message-State: AOJu0YxWrtPydFvUHo5W4k/T2v22sv3Ep9JXc80EINEME3qwsc3JB1X5
	NJQmpN0Qs5NXf+JR8kxCvwWBuTwihCpisZp1LshOK2CJjvHiLGDbJscMIInfD4VNZbM=
X-Gm-Gg: AY/fxX5xCZKnIETSlaBY4lmquxen7VN2nLfSYlosgsDUccE0jm9oK2FcpGmgmXGZZAg
	tC4oJuv3QHTcYmLSoLsG8wtbMain6+FkZ0Ti9wvxkNKQE7L+oMI1lWdm6SgjyL0BUHRliCLrU+3
	SWObZeGbl0oDwj9iOlbAARXOkSSu5Ddw2h4izqUoOXOVdybWFqg6eyvWLmeal8qO+Ut8NHDd2Y3
	NCkkTDTP6InLiJixF48bp9ZnLqP9g5oWch+wlDznn+ZVsusnfkCvZYUgV6Lud+boU0uTFO+47Es
	XavzXtthZ0ZSRn7duyTXRg2927/gILvLRqRyzjlk3mKx0ARO7nkIIVrUb1LIhAVlhhMOX5rmBcz
	0jdA7/DmB7p3hWk4JOLAl1KTNqs1xINg58cgDBXUZES+iE9dzPj4GugXlD7UCEM2yjw5KRlFr1q
	OcxvhL6PBjwaTDwJAh
X-Received: by 2002:a05:600c:4e93:b0:46e:4a13:e6c6 with SMTP id 5b1f17b1804b1-4801eb09274mr125799035e9.19.1768841106692;
        Mon, 19 Jan 2026 08:45:06 -0800 (PST)
Received: from precision ([177.115.55.201])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b6bd8e7cd9sm12539518eec.16.2026.01.19.08.45.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jan 2026 08:45:06 -0800 (PST)
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: sfrench@samba.org
Cc: pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	ematsumiya@suse.de,
	linux-cifs@vger.kernel.org
Subject: [PATCH v3 2/2] smb: client: add multichannel async work for CONFIG_CIFS_DFS_UPCALL=n
Date: Mon, 19 Jan 2026 13:42:13 -0300
Message-ID: <20260119164213.539322-2-henrique.carvalho@suse.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260119164213.539322-1-henrique.carvalho@suse.com>
References: <20260119164213.539322-1-henrique.carvalho@suse.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Multichannel support is independent of DFS configuration. Extend the
async multichannel setup to non-DFS cifs.ko.

Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
---
V2 -> V3: changed the subject so it's clearer and added Shyam's RB

 fs/smb/client/connect.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 1b984669de29..d29f7deace28 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -4000,6 +4000,7 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
 {
 	int rc = 0;
 	struct cifs_mount_ctx mnt_ctx = { .cifs_sb = cifs_sb, .fs_ctx = ctx, };
+	struct mchan_mount *mchan_mount = NULL;
 
 	rc = cifs_mount_get_session(&mnt_ctx);
 	if (rc)
@@ -4027,14 +4028,27 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
 	if (rc)
 		goto error;
 
+	if (ctx->multichannel) {
+		mchan_mount = mchan_mount_alloc(mnt_ctx.ses);
+		if (IS_ERR(mchan_mount)) {
+			rc = PTR_ERR(mchan_mount);
+			goto error;
+		}
+	}
+
 	rc = mount_setup_tlink(cifs_sb, mnt_ctx.ses, mnt_ctx.tcon);
 	if (rc)
 		goto error;
 
+	if (ctx->multichannel)
+		queue_work(cifsiod_wq, &mchan_mount->work);
+
 	free_xid(mnt_ctx.xid);
 	return rc;
 
 error:
+	if (ctx->multichannel && !IS_ERR_OR_NULL(mchan_mount))
+		mchan_mount_free(mchan_mount);
 	cifs_mount_put_conns(&mnt_ctx);
 	return rc;
 }
-- 
2.50.1

