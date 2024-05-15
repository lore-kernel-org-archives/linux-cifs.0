Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA1114AB4
	for <linux-cifs@vger.kernel.org>; Wed, 15 May 2024 13:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715779722; cv=none; b=W2xOJhWzMpEG9Ofb2PprU+P10qxP0wNFP3Yn8fJ84iZeUWmJ/hlclmGONzBmgsEvim7eVyyKQhtXHbxD8owEqTNQqpr1Qe7NNGJY2CzKiWZXBIPIKNHrIHIRW4NDTHRHx1dtUx0cqQYbU4IlE+eGftu9k/9QrZ65rgM5+QjYUHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715779722; c=relaxed/simple;
	bh=p5lebHXQksvGthtMMXnQ9T5AwcX+SWEw8glSh4lz2V0=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=BE/yn1RIJyTM+RW7e3eNphvi6dIsrrBaeFxKzE2U+LgJtn0wpspZo9mM1dK2E3o3lrndjLP5XFil4MRSNY5Cr18G5FC7Ty2G1IVY+bDpLe48EMUenNmdTYlXF4goPJjbPdLAF+nhbI//MV91iF2v71/us8wkYVzhrIBH6UgC83o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zry.io; spf=pass smtp.mailfrom=zry.io; dkim=pass (2048-bit key) header.d=zry.io header.i=@zry.io header.b=E9DjPfK8; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zry.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zry.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zry.io header.i=@zry.io header.b="E9DjPfK8"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a59e4136010so174553566b.3
        for <linux-cifs@vger.kernel.org>; Wed, 15 May 2024 06:28:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=zry.io; s=mail; t=1715779718; x=1716384518; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=YXFJqyc0Y6qLJk5IFdIgJqO5OtD2A4l59rY7UI6yqUo=;
        b=E9DjPfK81d2eJOJC/UQypfmYOdexfo+yLe+fgGjmdBnYWgPj2tDVHQZZ2XYhaXtHfe
         /+EapqGcudH1APBzbt+B5LM6YfyRWzaGPd+qGsAuf7sj1S8LWq/oR4SCxXffyo+5QwSz
         nS4G9FKqHVfHWYlQhAYKghbM4rWM91e/MvCtzhKdAurignjfJ3dUjsonF9v85uCrcQcY
         4Je0apQFL7nWRw9IT0NrfFv8KeW/Crn3MFy2bB2HIbGxV2t1KtcYuV8JZLIoCVJkcu90
         A5ZYBfxquATq+1/RtHH3+UZ94AYBdqcvV7ABpFkgUzu3D2gGA0cDfOFRFt8mnEWagQlF
         Jyyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715779718; x=1716384518;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YXFJqyc0Y6qLJk5IFdIgJqO5OtD2A4l59rY7UI6yqUo=;
        b=HxNc3MyQJ6yVFqpMIII7qqriZPdKJA7G+mfNU79YNpUSDTTryNwb25U13bX57NvOPr
         MPpV8SgpaK60AN7Q9LcaQIZhddNci7lMbQzIAaMPeBOVIDdSXaS8cb0R1ZJCuLvQsJDW
         4PWs5WIxBq9ibY8ENHLXzE8Nt1/mqfvMgVEoHU5OWL0MaI8uijh2N90Jhq9R3ahiBnhq
         2PJj0HywfAwZmFgr7j/MMXDKE9/dodT/olYiqEq7x5fa/Rqw58hAbinHahODooItyS+b
         tmEkpanUfpHZzDx74JETcFa/1WGlut4Oh4Pca1GDMnjjGxLNdzRAq2hiSOFbCpvJxsjO
         NhPg==
X-Gm-Message-State: AOJu0Yw2m8fIOGPU8Q/PKUZNa0UoHc4NMlnj4GjxZuV4i4j8erErjoDB
	YBeJTUSJQc9GbLX7n+ampysFsNI1Ppou0hiK/92e8U9LSr1Ot4DD5CqZKX6W0jiPS29U9WAnGB1
	t50XkbsC/72oCArwIW5U86OOz+0Ne6BgQFlE/SoeWsXcf67KpVQpU5Q==
X-Google-Smtp-Source: AGHT+IFAT7bEMgw0cVnv0ZK4zvty+BG+WFp6gRDV3dZQx5ucYxNm6jUXs8G03ctCj4yBfUbqqIg4v47VwbyKJiNPtCQ=
X-Received: by 2002:a17:906:75a:b0:a59:a0f7:7ddc with SMTP id
 a640c23a62f3a-a5a2d53adf9mr961297766b.2.1715779718250; Wed, 15 May 2024
 06:28:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: zry98 <dev@zry.io>
Date: Wed, 15 May 2024 15:28:26 +0200
Message-ID: <CAG-2b+3KYcFuHtRx3LQ8d+_VK_zMvwzPVkQwqfapjDKmfuUZ8Q@mail.gmail.com>
Subject: [PATCH] cifs-utils: fix error messages missing newline
To: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Add missing newline characters to two error messages. This commit
fixes an issue where some error messages were not properly terminated
with newline characters in mount.cifs (e.g., `mount error(111): could
not connect to 192.168.1.2Unable to find suitable address.`), it
improves the readability of stderr outputs.

Signed-off-by: zry98 <dev@zry.io>
---
 mount.cifs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mount.cifs.c b/mount.cifs.c
index 2278995..6e49811 100644
--- a/mount.cifs.c
+++ b/mount.cifs.c
@@ -1517,7 +1517,7 @@ add_mtab(char *devname, char *mountpoint,
unsigned long flags, const char *fstyp
        atexit(unlock_mtab);
        rc = lock_mtab();
        if (rc) {
-               fprintf(stderr, "cannot lock mtab");
+               fprintf(stderr, "cannot lock mtab\n");
                rc = EX_FILEIO;
                goto add_mtab_exit;
        }
@@ -2267,7 +2267,7 @@ mount_retry:
                case ECONNREFUSED:
                case EHOSTUNREACH:
                        if (currentaddress) {
-                               fprintf(stderr, "mount error(%d):
could not connect to %s",
+                               fprintf(stderr, "mount error(%d):
could not connect to %s\n",
                                        errno, currentaddress);
                        }
                        currentaddress = nextaddress;
--
2.44.0
