Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A960446851
	for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2026 09:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786614188; cv=none; b=a9pChFe3sKV341UShjRHF2uYl2LUJBoIdQqIw6SyOJEHbOMpfYL+KYrFcgOTSWm7nre+4DwPWgKYKlHr0/aG4JKiRSweekZsl35JeD2GIBndIUvxOV4jqJyh0AwJ8u2/bja3lewIAL39h0H7JcuRWfQo8zFXST3oJ8TtnOucO3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786614188; c=relaxed/simple;
	bh=gsUYnVwatn5Kl2SbyTKwCkMjIxPpKHshq21iM0xLZ9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ImevQynTQPIjG4R3Ue8a6QqFNFsup9cr1vd8JtCYvJVDA5CPJa6DCC8Yxi2WsuWnP6Q/avSgSFmgRI88aynvA4up1cqLedwefRWRB+j3tZ0Jnr0fvMAtdlQBayFo0xg2Bmo/6VJbj7D/uX4rti+TywzPC84sh7hlFWgrhb/6vNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QQvrIkOB; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QQvrIkOB"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-38a0c7e841fso2762268a91.2
        for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2026 02:43:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786614187; x=1787218987; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=INQpddQYGxbdS3AZPQaRlhc8r+29QVvcQA4ufVXdZpw=;
        b=QQvrIkOBsiYHV5g9b6pNsOmxz+wSuT4krxnAUuBmy89rWVjpH3muXw7HDdp2J46y9T
         SLO/fS022qQzHYKdXj1s21krZgJNJ2LrJUHUrccdENoot8I5IcJAKNSy69mQ4IC+zIpS
         eXNDUpvLsysDJ13zfwmZc2ZOKoyrbH4GjrO0+Lh/5LJI9s0QKiPUdj3K7eLufpYBoyXq
         dSomx/7RmRoiixyaxOWF9penelVZAOlz3iV6GDu7zLIeWiNuYGqlILlABH/PkFUJBe9I
         otpZmgsuSa6mNf62TEVkaWT27F+2nO76jjvA6RlcDDdR/DrGEYr0XTu1lJwv7/d/n/92
         nWQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786614187; x=1787218987;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=INQpddQYGxbdS3AZPQaRlhc8r+29QVvcQA4ufVXdZpw=;
        b=ZpYa/opk8JhlQRhSDTfRYMfm+j+uRbvKmxospcYGwU6KZMoyXGEWVZZmKGARGUcZHu
         wHHkIRodAjOn7Ztm14l2dKDfuXxqjO83r+Kf5dXT9tFeT4qaGUTupJP5xq4fzA4fTF9c
         qwtf6DbKHKBuj+wqt6siF0iAsl2Oj0un9e0VhQ3aow2vQ/Vq21jjfDYZCSRoP0VJLef6
         VyTnLIkl/8dKgmdZPVejkGJtwpzl36yGuUgmu9avOlKbg6VH2evwDVjpqXtp/Ky9m5Fq
         oHD1gV9KEGu1P5j0WtutOxzEhT2oWOIqlFpPweS3gOfgoo2QhlKp06wtFaL1ZdxczH7L
         Y30A==
X-Forwarded-Encrypted: i=1; AHgh+RobDTIoMmZUvC75unI1sXuXTunbZ/YdHVal9LEaPiRNiJxegSp/uh38313t8Rk5nUcxxjZ3lBFivz8y@vger.kernel.org
X-Gm-Message-State: AOJu0YxhCRdTQBfydSzWPnrnG2T5sa3e8eBecTaXjjBJnXO+JlPOj4Pm
	e3jSyfCmSdI366AFudl5IFYyFY2cwTPyWmzgcWgxDNHj4ZeIfwmB7vnb
X-Gm-Gg: AR+sD11r9M+19EXx3ulKoIsQXPrN0bQ5h8b4xYOOiOkGf3ABgyWVEQIxItq7hewoV+z
	i9C/50aGTmB2epq+/fCeq7k75xRzUOVD/z1ycvQ0CHKsmZrNzBUF7sPBJGBuzC7+vbx17wibyCQ
	+1E1iLYRYi4WSCronPr/vFHJS+mNMq1Jkgzv2Daq3iy+AN24SyQxyQZD5KYECaKt1h6lNL4ZNQf
	c665HQVwStPecyXHcSfrCkresFjJ8NlojcG1fMv/Jk5VYoJ+XjCh1mhKLhCRTcP8ACvU3EqmJC8
	Bmy1LpIqYMJbA4MSRda+uOE+Sl45HNKpOEfBPD1NGQQ+5y9xobtQOlledoaBcdj7FnSF3xMb9fp
	tfriIzP/iybOtFdJvTKMQKnmOdBJDrujU+jeXiUlP0UStplLta8lw2Zgh5aIKSp7WnDYgRFxeJy
	SrG6aiPsFxT6+tSZkgKmFJfVJbjzydkUH9vIOM11IVcPx00iULcPhhroLIhdEtoWfGiq+grd74m
	YuBuU2XR77MOfZTojTt3aAL/iq04Lf2QUx+aj/q0HRjTtSGWM11SjofbTjEplcPspmqfo40X/9+
	I1cMxz+2vIL8ShUd
X-Received: by 2002:a17:90b:4a10:b0:38e:488f:7068 with SMTP id 98e67ed59e1d1-3931dfdd3e6mr4747661a91.2.1786614186729;
        Thu, 13 Aug 2026 02:43:06 -0700 (PDT)
Received: from dev-vm-rm.hzz4ddxqtfeetjrh00qlbgyytb.rx.internal.cloudapp.net ([20.197.52.255])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31ebc760524sm6409135eec.1.2026.08.13.02.43.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 02:43:06 -0700 (PDT)
From: rajasimandalos@gmail.com
To: Steve French <sfrench@samba.org>,
	linux-cifs@vger.kernel.org
Cc: Bharath SM <bharathsm@microsoft.com>,
	Meetakshi Setiya <msetiya@microsoft.com>
Subject: [PATCH v2 4/8] smb: client: block cache=ro and cache=singleclient on remount
Date: Thu, 13 Aug 2026 09:42:47 +0000
Message-ID: <20260813094251.666373-5-rajasimandalos@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260813094251.666373-1-rajasimandalos@gmail.com>
References: <20260813074517.607275-1-rajasimandalos@gmail.com>
 <20260813094251.666373-1-rajasimandalos@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rajasi Mandal <rajasimandal@microsoft.com>

cache=ro and cache=singleclient are mount-time environment declarations
where the admin promises that the share is read-only or exclusively
accessed.  The client bypasses server-based coherency (oplocks/leases)
and caches aggressively based on this promise.

These modes were intentionally excluded from smb3_update_mnt_flags()
when it was introduced in commit 2d39f50c2b15 ("cifs: move update of
flags into a separate function") — only cache=strict, cache=none and
cache=loose were made reconfigurable.  However, remount currently
silently accepts cache=ro and cache=singleclient without actually
applying them, which is confusing.

Add explicit checks in smb3_verify_reconfigure_ctx() to reject
attempts to change these options during remount with a clear error
message.

Signed-off-by: Rajasi Mandal <rajasimandal@microsoft.com>
Reviewed-by: Meetakshi Setiya <msetiya@microsoft.com>
---
 fs/smb/client/fs_context.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 2fb40e9e1652..4a319c113196 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1261,6 +1261,19 @@ static int smb3_verify_reconfigure_ctx(struct fs_context *fc,
 		cifs_errorf(fc, "can not change rdma during remount\n");
 		return -EINVAL;
 	}
+	/*
+	 * cache=ro sets cache_ro and cache=singleclient sets cache_rw; the
+	 * other cache modes (strict/loose/none) leave both clear and are
+	 * handled separately in smb3_update_mnt_flags().
+	 */
+	if (new_ctx->cache_ro != old_ctx->cache_ro) {
+		cifs_errorf(fc, "can not change cache=ro during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->cache_rw != old_ctx->cache_rw) {
+		cifs_errorf(fc, "can not change cache=singleclient during remount\n");
+		return -EINVAL;
+	}
 
 	return 0;
 }
-- 
2.43.0

