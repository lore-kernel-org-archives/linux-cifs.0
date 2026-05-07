Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8220034A799
	for <linux-cifs@vger.kernel.org>; Thu,  7 May 2026 13:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778161517; cv=none; b=S0j3AFV1qtqBTNMAET7Li/8xNHPwRB87xEYE/J7U31EBb9YLT2RcsRWAAfPev5ubbRZvvknX0W73ov5BjbIXa5m5WmpHobFJlpdxKVH27Tv9eHDWLXVQqOjtJUr4mUkbwFZdKYkEkCrfPPAiE1+tkmbAaqsJnYxg47NtQsQzZeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778161517; c=relaxed/simple;
	bh=H/TmBncLOcxFuwc0tet6DqnEMFhA5f6x3Hxc7FRYcZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GNTTWmWIajx00qhnmQ5NAw9qJA/LkFBJlBxGLlMF/zR94ijJCgUndoYPmkdHR5/tZ7fH8lhUD7AF5CJcZBTWeNN1otiUXuFPtxB9DyzfFHZDaW4hrew5X4iKbJ1jfsMFCgr1IpxGD0eLu5cz9vajkyUE1/cJtVoJBPSJTbXufQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T7prRjFu; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T7prRjFu"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-365212191f6so619990a91.3
        for <linux-cifs@vger.kernel.org>; Thu, 07 May 2026 06:45:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778161515; x=1778766315; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V6v+/rdiPCutLxy/3nZlBfdgZyD1Ljc5FShzNpAtPBs=;
        b=T7prRjFuBwqJbECSIMOUbqpieJizHHoLZO64ZmIYYpZ5Gs1ZIo3G1dnqSLTj++/R4A
         WZq2HUtv+JfpjzOpmnVAPN04XxNpUF6yTjrAhXHhvIu7FvFHYeRpoyA/QiVtEGIH0rLu
         yxz2o2+lto1n8W2oW6SG79kvFuCmTWVBxbw4pIngSuspxy6P7UWnNa4nbZFMr7CbmnUy
         fuEIj/M++Tfr1b3iUfAHiGcPy7Zo7ZlWHymaiaRtZd6vbVs44gYYDvdEY3sJ0dXtTgwG
         GYiQeRnf1KkcoxbuLxNk885rS0JfehUwh+fGywWh/EE5wESu+/NlvWgNg+QfK6N7kB1J
         p68A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778161515; x=1778766315;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=V6v+/rdiPCutLxy/3nZlBfdgZyD1Ljc5FShzNpAtPBs=;
        b=g6yazTpxS2Kjaqs18s5AIE9VWu2zMtKKeU2tWwItTgSgX3N8lyEMh17Uft+N+wUcQh
         HjKtsYi9dzHmr5injZEOxfm2oqB7i9uW3+9QPCn9tTHiJU1dKM3SzVDYn9HZpBzdmcej
         MrcU2KR51peONydbAPNVCYQRhl0wDG6dOKYdNRBApXnWYLcJegJjcKUoSgE9qyVohg8q
         /L+rM7OWIHZdMHfp1MzcnrPBeC1mpuw2JmusHJ1oyhfcxDT6rWtW3QQ9NS6TzJNoX3CH
         zTzNtoeIiBKyjC1hgjO4Qc6WxR7iyOZa/ooOS0XLSXxyHwDGkFhxwNtjnAp+FAoBEPvq
         u1lw==
X-Gm-Message-State: AOJu0Yws5AMFOwKJoMLwf1/4xAUw9i/nszr7oOwmEDVs/DCai6MYUz2E
	DdEjbiJ49+3BZywtXNcA/MnnSBNAPNIhW1WCVCPCnlYWrExVR25Zyso6owoaDg==
X-Gm-Gg: AeBDies7clABnwk8BoV+38hXT5lM4vDtrBo4LFtAQfKKwao01piTJXIRn470EFoJQIf
	VDPeQuvL2f/pvTb9UzodchdwwZNbyvE6POsZ2u7rkDVF1ae8uiZ2IWnA4ISiA4jtQCSk/5jp4Gw
	tEIbRnn8N9yAQ42i6airTHcFSBZ/A5LdtZOicPIOHcRRFMlZ7FrQNuh4Vf4jEsWIR5vazJm6kRV
	Svf6lQX9QS4QFcXJffc5pwihQqyM3WUduCFbVG/lbtypjP5asPJFFGyDP2z5jiacE3+GKhWG1dg
	EQgzgWp09Dsvg6q+GOLmiUbU9ZXwI/I0wgrCIqehIQ0nWY1ThQP5SV4p6IGteWFu9HwuVUXTWfq
	Xk8BNnMMgwKFQvOADMxj+RKVmIOvpgHT6Ioi9nL8ZtruFhB1xd6iS+Av/l/ClguMIa53BPa5aCC
	Rqm6pdG0j/Xrn2Yg8yPSkTMqTwhboNlgIG97pJrdyX5iyafytLKb6/a8alkoiTm6F2IZUjfuBfV
	s13TM7/UYKKFfMMwCTWfYXboIHgKQDSLA==
X-Received: by 2002:a17:90b:3804:b0:361:4521:d311 with SMTP id 98e67ed59e1d1-365ac080741mr8221812a91.18.1778161515408;
        Thu, 07 May 2026 06:45:15 -0700 (PDT)
Received: from dev-vm-rm.hzz4ddxqtfeetjrh00qlbgyytb.rx.internal.cloudapp.net ([20.197.52.255])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-365b4c8a8e7sm8316609a91.13.2026.05.07.06.45.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 06:45:14 -0700 (PDT)
From: rajasimandalos@gmail.com
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.org,
	sprasad@microsoft.com,
	bharathsm@microsoft.com,
	enzo@kernel.org
Subject: [PATCH v2 7/8] smb: client: block cache=ro and cache=singleclient on remount
Date: Thu,  7 May 2026 13:44:47 +0000
Message-ID: <20260507134448.168602-8-rajasimandalos@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260507134448.168602-1-rajasimandalos@gmail.com>
References: <20260507134448.168602-1-rajasimandalos@gmail.com>
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
---
 fs/smb/client/fs_context.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 01c57adb0ef1..009b9480b5cc 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1207,6 +1207,15 @@ static int smb3_verify_reconfigure_ctx(struct fs_context *fc,
 		cifs_errorf(fc, "can not change rdma during remount\n");
 		return -EINVAL;
 	}
+	/* init default: cache_ro = false, cache_rw = false (i.e. cache=strict) */
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

