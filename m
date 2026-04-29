Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 277F737472D
	for <linux-cifs@vger.kernel.org>; Wed, 29 Apr 2026 21:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777498539; cv=none; b=hFhx3xqaxg74niQTflwZCP3Szt4rNg7/DyFW3lnAkBl7T8tp98jdZH5Ul7mWK+IYASmRMEnXYQScI0TSMiz6GzEc/05UqsqGTiCYe3SkQvIsPwmdkTm0aqh3IHriMIkEKcT1cAsDDRyqOfyhdhJ6k9Ps72UV8OC530QCAoVHaKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777498539; c=relaxed/simple;
	bh=OCy9Ao5J71zcrOapnb2HkESAFaMyMsMNa3UUjUxU/hM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZFElVordcYNe5bQGyTlLX5Qfod55grvdVa0xBGI9wFX5VC3E4l8SGgop8Tj48QrlZw3spuRmNCcDD0AKd5WHGwthiNVHCV2G3/1sGWnStVrWmV6emetWS80z0b80hPOFTZD91aQfp+wa/2tFUt8FWxpgUVpceIdP8+I3/vuFJeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TuL7um63; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TuL7um63"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2a7a9b8ed69so2009645ad.2
        for <linux-cifs@vger.kernel.org>; Wed, 29 Apr 2026 14:35:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777498537; x=1778103337; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=d4qFM2xY0uWIBy0/+YAa6gQ04zbbRjdE4sek5AAXClk=;
        b=TuL7um63zZeA9QFc0LHK+KUGh/IOK0rsA+fGfd0iyO15tAu0OM64a1IaqO8Suq5COI
         UfI1CiOL05lxVvh6blXXGK8maMeYpZWd16yFzVKezxNT2KwTToIvmNL5zevq0l3Ajq8d
         dIVcatmB6x5TXtNx4uHYQvwr1bRfBtIZ54K9+HgBgPaTIQdqxL1/1UzfUZkHavuTE4DL
         pJWYyhy5BPbDnH9RLtUdFy7pW2lRSOCQ+VJ/PSowdAXCybnUf+2f13V60kF+Sxe3z9gM
         Vr7TZxajqSSCL86WV7DEUsDUw+iqX0nYbtMr7OxrCOgRCw2CogB0V5mM3k0nCY3KY6ud
         rFzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777498537; x=1778103337;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d4qFM2xY0uWIBy0/+YAa6gQ04zbbRjdE4sek5AAXClk=;
        b=kjnndbFaiOYBaR+zWEwHRx82tFNtCSNOYqU7TRpqZ14xE+mEnIIoyN9cQ22peqZxM5
         4krmStXQbKvjmDtCNPc80eKKGHUewzyHSEhhU4QVDYgIx6ufP+t9tW1eYmVIqcUikhNQ
         wWDOKJp8touLHxwqQ5t+JJMwgBt+TyeCxkplAYwQ6vchr7ui9hHVQcbRbSIGN6MV4O7j
         nuPHZiTnyxKyfaUqPdB7S7cx3nfFKF0r6HMwGqAyB0r5QfPl339RIdnDv4dt6GKJ1G/2
         rb80Lb8XcLrxtZ1HC41nqQ0V8cWtnpAAUL0bTpzTpKE+LDnF29eLm4B3DI/S9UouzBrh
         mDRA==
X-Gm-Message-State: AOJu0YygBuFcyIWt2jFvD7O+RB/IseCrrYBP/+AWXUqdTiENtyO0MCKl
	ArMyAuFLlGe58Dl2a4b0dfi/IQHmlgseTY7T++WSeg9jg7DPn1x/BMph
X-Gm-Gg: AeBDiesI+fHHNYoTB55NKYYNoprEL6am9pv1Lv/817ueDLseGGyuLi65j0nYcYKIHRD
	AKhME08QEBWU4Q9Mp8+aTlg2P1X3Az+NeL9alzqpiuaVvwDaeFM0NoZZDc0azppDi93yStB7WsG
	yHStO7tcrjw+NB3S7PtSrNacp2bCMkNB62y8Jom5eQy4DgvBO4+AXSW1tu1FcwIdAfXXHQqNJR0
	T2z1tGjF/Q88r3eBxSyK76VxP4a2srAzG5yDwbXZmnyZvHgmocnOZL9p/eghjhXvzbhk5kZDgN3
	9e7UjvLENZwIQnip3tRADKpW76K+g88O/cyWXSns4vrWwTeP/8Q6G824e3BrNITlObxr9oR5e14
	Mav9VWazTDwjAHyX9yHYs2eTtSwbK8UpmdIye+izHlfZQUhQBQRMxSv5A4ADn4/oOXjp6t4EQ6b
	11CsOfq6zggOrfVw7m1eDR320H9ckYoBq/lgK4ZNrBfUbH89iMLVWM
X-Received: by 2002:a17:902:7d96:b0:2b4:5f19:1d34 with SMTP id d9443c01a7336-2b9a235e262mr1101845ad.17.1777498537422;
        Wed, 29 Apr 2026 14:35:37 -0700 (PDT)
Received: from FredPC.orting.wednet.edu ([164.116.47.202])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b98899055fsm32612315ad.80.2026.04.29.14.35.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2026 14:35:37 -0700 (PDT)
From: Fredric Cover <fredric.cover.lkernel@gmail.com>
X-Google-Original-From: Fredric Cover <FredTheDude@proton.me>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Fredric Cover <fredric.cover.lkernel@gmail.com>
Subject: [PATCH] smb: client: change allocation requirements in smb2_compound_op
Date: Wed, 29 Apr 2026 14:34:53 -0700
Message-ID: <20260429213453.26235-1-FredTheDude@proton.me>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fredric Cover <fredric.cover.lkernel@gmail.com>

Currently, smb2_compound_op() allocates
struct smb2_compound_vars *vars using GFP_ATOMIC, although
smb2_compound_op() can sleep when it calls compound_send_recv()
before vars is freed.

Allocate vars using GFP_KERNEL.

Signed-off-by: Fredric Cover <fredric.cover.lkernel@gmail.com>
---
Please note that I am new to patching the Linux kernel.
I appreciate advice.
---
 fs/smb/client/smb2inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index c6dd282fc..286912616 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -230,7 +230,7 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 	num_rqst = 0;
 	server = cifs_pick_channel(ses);
 
-	vars = kzalloc_obj(*vars, GFP_ATOMIC);
+	vars = kzalloc_obj(*vars, GFP_KERNEL);
 	if (vars == NULL) {
 		rc = -ENOMEM;
 		goto out;
-- 
2.43.0

