Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB91C1F4C90
	for <linux-cifs@vger.kernel.org>; Sun,  1 Jun 2025 17:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748798555; cv=none; b=Gj2eHJJwEX0hVM47TwjauuQW7IDrCVaOzG/1CXIRgZ9T0mgoQGJSBgetKfHh2ptT2NMDvGfZmTUynSGOWmBO8/swl5M4VB+HfJcniCZgO4FfeLSZJGIoUpkDrbtRWditJBRBKn+JbyG8oyoe9xxAJ/RrgWmn7VTLInVbDEyodcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748798555; c=relaxed/simple;
	bh=QmtvthWHMpl0SbbV2cqJtc9tdM7X+QI3BEO4MBmIE8c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fQk3G57qDtjUrLZiLsv19ZK+ziWjWPHGYwfx966m1hRaoOO2KnMEqDq4W3gKbGaZbmJD9Bvc389Ab3XvbJ/Q5JuofzQM3cfVaJ1k0/mKadCn2wimuEqZn/bplDsRN71lIxEe+9XXJkHbODxoJh6t+c7MijbFI1+e/SfwORL9Nwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y5rVN2Ou; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y5rVN2Ou"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6020ff8d35dso2315232a12.0
        for <linux-cifs@vger.kernel.org>; Sun, 01 Jun 2025 10:22:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748798552; x=1749403352; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KWUixeIdl1/vUcoyOrFOPqiz+H0sA5DDf9cCQ0Qcqik=;
        b=Y5rVN2OuPaxksctN8asqGSopZsdq3FHnT/B8yqGd/y6j7yW4hmeWIDQBhqFs2IPH5M
         gWAFdsIDRgHyWjOWYbu8kYMhlsA5ufHZD3aNkOBWLygC9O9SEXG5f3cgw1+r3FhWtOk4
         y2YAVMKK8NJL795yeUtIbRNUkoL027YO7XJIoJoAh57zrSQTHJ2hU7DngQv1gDc4Y7N/
         owECFNDbtCyR0gV63OqvorM/zvpIR4xkUJbzd4HLeJXXWF9NQKoKa/mVbd/Q5S3OB9a0
         WZEqmKchm1zAHa1IsajIvEJxATuNDxLP2pM6EG41dci4gkP6MJk6dpvzPGxTudCl3MaC
         +KFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748798552; x=1749403352;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KWUixeIdl1/vUcoyOrFOPqiz+H0sA5DDf9cCQ0Qcqik=;
        b=X6oWKtV4C6RhoegIvQp984zMWhZu+GAHNed7p+aSQDM6wCioHMZmNqaLYz8LgYiq1f
         UhY8JaH4/RuOXSBu59lZaBGuf7Yf5lbanhoVFq+x9OoAuZihPzayTGXVke6LIvXM2Rnr
         jeVGgEZgtxcCHvafaQ8MDVDaYW3CrQ4wnoz6SyJYEsQdJAGKlb70j3AB+1Xqs94B0lmQ
         wj+Y2l/oQOulKLmaU7F8Wwd159pD6L/CKGoyNxvvNpMPkLexHPB0k/CHnAo68oBRL3wR
         N3P0Ggd4SjWmsGsk5+nSufWymUvaK8cAtBvzW1JNbXhg73u6oL2S+iXCWx/FJdsH1dcF
         rRpQ==
X-Forwarded-Encrypted: i=1; AJvYcCUJyWA6c/FLJfaxat0BDn8lBSmdEmNw+KTud5Gqoln8rt/wRvV8PDcMQJxyr2kUdPFv1urHEorbbaGa@vger.kernel.org
X-Gm-Message-State: AOJu0YyPmzMKgGhFvqr1LNrBAz7NX4iq1iJLcxB+j+PIhNiAxInzwZ0O
	RPyUEG9IHvK8T5DL7+bMncRj6E40VR4zNlEOo4VccPLMaeiH7aPB7PJO
X-Gm-Gg: ASbGnctHsuXfmYFxuyvFfoYFjiUFFwJFZUvvJPYAkOjlwNYKI9U0ppzKLGAPLi+np20
	Gx808Omz0p6UBNvWkfovbRexR7qmE7YAcWOVpaQ2D1PqcG7s3bP9IfnR01io0rVeke/Asu6ecRi
	s6CXFTc2QnOCssXuAEAtBztLMFH+t3YuVJFvuDJW04jlcwYECS26zfMWbXTMIu1YSGfHpy4i7ea
	5lEz7cZqABMbl1G7CtT4KdrAu7zHIXcajWxPPSP8ZVuRoyxFDpe9JQ0cjtNUBouDmqMiQkFYtl1
	DqIptLQL1c6Ul5YQLE9nHT268Jw1Xmg+hzJIGf8SR8ESWoAW88sHviLJ9dUPors+2kmorA==
X-Google-Smtp-Source: AGHT+IHG+aMIRUd8i9W9aQa4gYCTc8AyBhoMUFZ79K3T8BHWN6mCYXkKpUrOEfxLXLxJ8zFOLY7fCQ==
X-Received: by 2002:a17:907:d649:b0:adb:301e:9fab with SMTP id a640c23a62f3a-adb328ecaa9mr978228566b.2.1748798551887;
        Sun, 01 Jun 2025 10:22:31 -0700 (PDT)
Received: from localhost.localdomain ([2a02:a03f:e6d8:fc01:121f:74ff:fe57:106])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-60567169cdfsm4832010a12.70.2025.06.01.10.22.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Jun 2025 10:22:31 -0700 (PDT)
From: Ruben Devos <devosruben6@gmail.com>
To: sfrench@samba.org
Cc: pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	linux-cifs@vger.kernel.org,
	Ruben Devos <devosruben6@gmail.com>
Subject: [PATCH] smb: client: add NULL check in automount_fullpath
Date: Sun,  1 Jun 2025 19:18:55 +0200
Message-ID: <20250601171855.12268-1-devosruben6@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

page is checked for null in __build_path_from_dentry_optional_prefix
when tcon->origin_fullpath is not set. However, the check is missing when
it is set.
Add a check to prevent a potential NULL pointer dereference.

Signed-off-by: Ruben Devos <devosruben6@gmail.com>
---
 fs/smb/client/namespace.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/smb/client/namespace.c b/fs/smb/client/namespace.c
index e3f9213131c4..a6655807c086 100644
--- a/fs/smb/client/namespace.c
+++ b/fs/smb/client/namespace.c
@@ -146,6 +146,9 @@ static char *automount_fullpath(struct dentry *dentry, void *page)
 	}
 	spin_unlock(&tcon->tc_lock);
 
+	if (unlikely(!page))
+		return ERR_PTR(-ENOMEM);
+
 	s = dentry_path_raw(dentry, page, PATH_MAX);
 	if (IS_ERR(s))
 		return s;
-- 
2.49.0

