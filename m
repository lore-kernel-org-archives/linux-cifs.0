Received: from mail-qv2-f12.google.com (mail-qv2-f12.google.com [74.125.230.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1A04568548
	for <linux-cifs@vger.kernel.org>; Tue,  8 Sep 2026 15:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788882332; cv=none; b=c+xdAOt6FlP2C5oa3GpEJBPRxkJnbiG3VHKVX3xufX35Vc+BBwdAw29a0l/OWxgKaWZzealW53S8cfUKl2w9FEC6Y/YL4G3t7KYPClDiGhqGwwvzRakm9BaKyjbcwPb8C7IhZ/vRL8azfBG5P4III5FQ+5opv8idAIJV684SY2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788882332; c=relaxed/simple;
	bh=QXArjv15FVZH9C/nOWnq4DoBdtC3m4aUZ2D+uGnCtMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BM/LEuZubD6rtlzuymwmICTSVC/SOTrWhmodCaP3N/bZ1j1rtM1Ce33/utMlau9mhOmWouseMJmTa0aSFHE7RcCGyNGnOWN5jQDxVy0ZGQ0wZTEiI07qHRo7CWz1pwS0aWxItpvFO8xJ+SRywuj0AYEhJdcPLPv1i/01qRhq9mI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DgZ57w2e; arc=none smtp.client-ip=74.125.230.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DgZ57w2e"
Received: by mail-qv2-f12.google.com with SMTP id 6a1803df08f44-90cdfbd148aso784116d6.2
        for <linux-cifs@vger.kernel.org>; Tue, 08 Sep 2026 08:45:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788882328; x=1789487128; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gaNUihdkxM1CZL4kcfrTQvejs/c08bSRJ/ek0fixoao=;
        b=DgZ57w2eMqwBiK+/KAzjKuj3l6X2xWE5WAeAKZVbEHajWfG4ajuJHiz3bq0Ajw6Gt4
         qi2eA5Tp8aHRkxcgIulPHMZC7ZRI5fg6TurR1MryuXok6e4st/u5w8T2r24E+GfOtvD2
         V1jTq2phKFJannX0v1JD/U0d+rerF1ZsoGOwQG1rpH0bD1Q1rbEz1ur2u1ksCgiNhX2J
         SXWHkXUVmGF4gZj1oU95Yx9HPhXKgzWoW3jddJRRzkmEmr2K6nK1LaeIzFRuAzrcdXt+
         LTaSyNpxCzNsBwm1DruE0QeSnSEKQqU/Kysc1rgCdx8anIFu1fgIDrFCfrJIBchTRDcQ
         pJxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788882328; x=1789487128;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=gaNUihdkxM1CZL4kcfrTQvejs/c08bSRJ/ek0fixoao=;
        b=iGw9iim2EWK76Wk++bmqDXIQfQ8Ox/sRQOoX3tyVXEUAvvOP4rWYOihgm5p67A5yTv
         aCywyfHSwC4Uj6CTd8re8y5rdIGIJ6pK3Ltdl26G4/wYVhvin7KXVA1vK8nD90VeyYl/
         tDoZT6Az4RC1yYirDwdU5eQ7MEPeoLDDVxXtgdSTuPs80q82BpZwehPq0OqpmK9rxNjl
         /6wLMBd8OhcRIHOXvOTcQE3q/yXJd3LfpTZHh+8WAj+jZ4QDP5PN4iWfjGmGjK1r0nP7
         p2Op35YibsiMrzM6JqpvfctildM6cJBMsVl9FUXKElHTfJocsFJXkcHa7bjboJCXfHXj
         FSuQ==
X-Forwarded-Encrypted: i=1; AKwUvBxuGeGr4uOC7xvcLaHp0EFjMmPTrfwTwl1Bw+xOXC92ubHt5ky1UjOhgj4CpHsWhDsDIE8whn5HD6h+@vger.kernel.org
X-Gm-Message-State: AFuF++kXEf9ga9Jc0Bz+zpy/16nunJT3CR01si9E3ozo+li9b0LC+Ka4
	lyYmKaFvmcXlNEXiPyN2FDtGakk9lyYz611AdDeXgkm/gK257EVieKUg
X-Gm-Gg: AYBFou2zZGkdDvmetbbRAhj6XgcRVz8glfIiwo+g52nLd62iqMw9r0B7o4f5l9IJ1us
	HbLZclCzYFqjkYV0SiAewYyhGrfHNTjtSRl3+FkVDTLxUfhjVnvFnUFghBt3XQGrJflwjgpTEeT
	a1d115Uu7XEoIXP+7uBMgP1JAcIAp6RwYJLNbfTfSHJlN9JLEjbokP0XOHr2iIJA4f6zrinifpB
	u1ROHk4mn/jm6MzfxMLYteDQVo7VdJM+mGDL6qWofXicuyZcYG/3Ly6OHPjIM5u9malsO4ezUJP
	XHxgFFVVK9bZa5UdSugzeqzqHRbGlmeFQINJ8+Ge5oI/ewWILt4YKKTu9hXQ9A1ialsiUIhBm6q
	MCyNIe97f6UBoXaO3XzwMs2xurorO79898X9jnREN8iq7x84q4drqnQBGr6OrdmI8QrNhbnAUuz
	XCqAhwx43pf6o6ZLe3grz69mxvmQFIwPqV/BDXWbeYkvr3PlLv83rWuMq25lEYbhH8KeXEMQvtw
	BeMUV2VjRORRyr7MXhMFI817LNIMn8QQy1VsthG7GKtnuccYlDFwygMW0gdavQ=
X-Received: by 2002:a05:6214:4b03:b0:910:3451:5801 with SMTP id 6a1803df08f44-9106b42808bmr4290496d6.31.1788882328252;
        Tue, 08 Sep 2026 08:45:28 -0700 (PDT)
Received: from Ammar-PC-Fedora.tail72f32.ts.net ([2600:1702:7bd1:29f:8000::1])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9104049d30asm120779386d6.0.2026.09.08.08.45.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 08:45:28 -0700 (PDT)
From: Ammar Ratnani <ammrat13@gmail.com>
To: linux-rdma@vger.kernel.org
Cc: Ammar Ratnani <ammrat13@gmail.com>,
	Ammar Ratnani <aratnani@nvidia.com>,
	Kechen Lu <kechenl@nvidia.com>,
	Mithun Maragiri <mmaragiri@nvidia.com>,
	linux-kernel@vger.kernel.org,
	Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Stefan Metzmacher <metze@samba.org>,
	Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: [PATCH 2/2] infiniband: trace force disconnections
Date: Tue,  8 Sep 2026 08:44:27 -0700
Message-ID: <20260908154454.10966-3-ammrat13@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260908154454.10966-1-ammrat13@gmail.com>
References: <20260908154454.10966-1-ammrat13@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When we failed to send both a DREQ and a DREP, we have to infer that by
noting the absence of the `sent_dreq` and `sent_drep` trace events. It
would be better if we could see this case by the presence of a trace
event instead. Implement that.

Cc: Leon Romanovsky <leon@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Paulo Alcantara <pc@manguebit.org>
Cc: Stefan Metzmacher <metze@samba.org>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-rdma@vger.kernel.org
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ammar Ratnani <ammrat13@gmail.com>
---
 drivers/infiniband/core/cma.c       | 2 ++
 drivers/infiniband/core/cma_trace.h | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 1f1a8b4e160a..c4eab48a4a9f 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -4834,6 +4834,8 @@ static int cma_force_disconnect(struct rdma_id_private *id_priv)
 {
 	struct cma_work *work;
 
+	trace_cm_force_disconnect(id_priv);
+
 	work = kzalloc_obj(*work);
 	if (!work)
 		return -ENOMEM;
diff --git a/drivers/infiniband/core/cma_trace.h b/drivers/infiniband/core/cma_trace.h
index 3456d5f3aa47..3d05d8e80856 100644
--- a/drivers/infiniband/core/cma_trace.h
+++ b/drivers/infiniband/core/cma_trace.h
@@ -61,6 +61,7 @@ DEFINE_CMA_FSM_EVENT(send_sidr_rep);
 DEFINE_CMA_FSM_EVENT(disconnect);
 DEFINE_CMA_FSM_EVENT(sent_drep);
 DEFINE_CMA_FSM_EVENT(sent_dreq);
+DEFINE_CMA_FSM_EVENT(force_disconnect);
 DEFINE_CMA_FSM_EVENT(id_destroy);
 
 TRACE_EVENT(cm_id_attach,
-- 
2.55.0

