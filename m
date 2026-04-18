Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82D0E199385
	for <linux-cifs@vger.kernel.org>; Sat, 18 Apr 2026 15:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776527150; cv=none; b=QE0DS4DirIm9/hRzpceFR28B718O5TNhTO5ZMyFIw0u1lt6qKo+QwgOIM2456235KqmIpg+P3/XZbxqI7IUFl3LuB8kmKWy8R4rtCB5t8DPPJIz0LMfIQo2ntwt2ICUCpDzumw7fjnSGnDfkBEF55uSCZ0dlp7dTcVdNK+dq88A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776527150; c=relaxed/simple;
	bh=sX27uXV1JVZhbIDBUsq4KYLX5oQryToCfrgcG5bZcQA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tm0jXzGXu21mVGCO+OFa38lMdGz06Lfn17Oiauta5vLPeK7qZ33kWmNFbutRWvzahwd9gAJeh+EJlRIf7sGfndgAwIA9qfGazBam2RfFsHXpSYzw0r7CwVKrx1bJH6vmTFOWM7xRuCAKULD7hk3m8RxqV1WjyyandCL0mllJMLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f9cbbP1T; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f9cbbP1T"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2ad21f437eeso10769375ad.0
        for <linux-cifs@vger.kernel.org>; Sat, 18 Apr 2026 08:45:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776527149; x=1777131949; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Nixch5XpAUlwvDbeIvi1QyFB/G5nvIJ1ufdy7DtrBwY=;
        b=f9cbbP1T75icNfJrimxW+GIoKVb1jXxem9FGOKm6xkpo4FfzHnZgPtq4zsdeNmPQYT
         lO1B53OA6zXcrSi8WvKrVxigq29GT5kQsTC7S0g9dqGH72pNBtHVazr8lOhO4Udkcmfh
         gZMQrK+QMEkAkJRfOyLSyIsJI5BQbcuGjRDJg45M3YJQcdW5Pejz4YcOHMJc4MJ/DXKt
         Tp/0zyZ8IXr5uNKdx9OofIY5gmqAyAApHp/ymAiM0Moqib70oc9wgsYFQSSMMn9njyUM
         Kuu4gsWTkAWEk5gcYghtknTFwhvqQYiuocxUClg8bcZbcfHqigUvRPs10VWDucMUDQwC
         +A1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776527149; x=1777131949;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Nixch5XpAUlwvDbeIvi1QyFB/G5nvIJ1ufdy7DtrBwY=;
        b=dgz1kTHi1kFYVRwGWscFgdohoWzUMIS2DDmzb6w4tDEA9270SSZ9eg9FiLHknl8No5
         yRTtS+xgUFAMzt6wGsRwL0foWGCim/4oRO+AEwhSriwl0cBH7PkSgK63J84E9JjfLmUB
         QyjqNtBQuBTeKHqPeFZdeMjSPyijFqxVDiLuVKdSMmOFhycNZEJ4cQ3o/4gyAYxyWSBf
         lx2gjCBqVTQ6GvuOWnWWiceaPLAPkz/ohQgD8damzfp1vNdMVQnrHAt/DNnGAcXB/Rdo
         Sc/j/xTA6B/OoAlbOAIOeTHDOrvVpBct6hlMG3ugdANIQhfHiJDuDusIpyW59LwwSuWP
         vGcw==
X-Forwarded-Encrypted: i=1; AFNElJ++tRGi99Pk3JxhZ3A6oK7wtyNQWRglT45v/vn3Qez6L4rRpuy9Rk6Gw5Bp1SBxp0RfW1iXhDBR/cqY@vger.kernel.org
X-Gm-Message-State: AOJu0YzGyD2SMFqo6N45xG0U8U1/zhzzFFTqky9qDuvUSCkOEF8Uawr8
	AI56me8C+9/c6br3rA7tazvzaLEZ2kwrrhgu7+/q0pMR+akl1J6y2cWG
X-Gm-Gg: AeBDietXE7pk1IvCMt/KFfxjdatvU7YGFFZio9amgs4DlJqZzlM078rhGtFi8nQuMxf
	nSo6rW8NsCd1PS3AgeJFnyfON/TN98Mg+0wUnyHiyrGoFgtPCcWgWe9I/utUSKaZwYcsnZDf0tk
	hlPLkr5TEos2sS6i1zFVQLKzKMExG9UyJCBuMSY6ZsziL/PyUnSZ1e4glTYjBgahRtfJCN/GDoL
	g9uyxHHqKpJc+68ax5dQnQIQr9KjTllQQyZfa76Rq4XFQcbW9JZU0NmXav05AwCLvH2TJ/gClPM
	kKKhGbsRjyeb55GRVWmdKI0VwOLrZe/0UMmXMZEIPMTvJMRHj54/iwE5RdHm478kpMaiSMIJzb/
	LvABxY1Q55Ep5eqOBO+bRJjQEGJY6rFUiGg1dK5djk34kuAG+JMgkJTjK2/ducDyp/I+T1O7GGa
	YNqizlWHUl+KzQVm8VL53wNCH7iLJiWCaK+wtD6UVBV9ipYwHGYbuoXcCOAj02cFk=
X-Received: by 2002:a17:903:1aac:b0:2b2:54db:3e93 with SMTP id d9443c01a7336-2b5f9ecb056mr57628515ad.23.1776527148805;
        Sat, 18 Apr 2026 08:45:48 -0700 (PDT)
Received: from localhost.localdomain ([205.254.163.141])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5fab4cc47sm54703385ad.82.2026.04.18.08.45.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Apr 2026 08:45:48 -0700 (PDT)
From: Akif Sait <akif.sait111@gmail.com>
To: linkinjeon@kernel.org,
	smfrench@gmail.com
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	linux-cifs@vger.kernel.org,
	Akif Sait <akif.sait111@gmail.com>
Subject: [PATCH] ksmbd: fix O(N^2) DoS in smb2_lock via unbounded LockCount
Date: Sat, 18 Apr 2026 21:15:05 +0530
Message-ID: <20260418154505.84684-1-akif.sait111@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

smb2_lock() performs O(N^2) conflict detection with no cap on LockCount.
Cap lock_count at 64 to prevent CPU exhaustion from a single request.

Signed-off-by: Akif Sait <akif.sait111@gmail.com>
---
Hi Namjae, Steve,

smb2_lock processes LockCount lock elements using a nested loop where
each element checks all previous elements for conflicts. With no cap on
LockCount a single authenticated request with LockCount=65535 results in
roughly 2.1 billion iterations inside a ksmbd worker thread, pinning the
CPU completely. A few concurrent requests hang the host entirely.

Cap lock_count at 64. The MS-SMB2 spec defines Open.LockSequenceArray
as exactly 64 entries so 64 is the intended ceiling. No real workload
comes close to this in a single request.

Let me know if you need more info or a reproducer.

Thanks,
Akif


 fs/smb/server/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index ee32e61b6d3c..012f0c3585a0 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -7492,7 +7492,7 @@ int smb2_lock(struct ksmbd_work *work)
 	lock_ele = req->locks;
 
 	ksmbd_debug(SMB, "lock count is %d\n", lock_count);
-	if (!lock_count) {
+	if (!lock_count || lock_count > 64) {
 		err = -EINVAL;
 		goto out2;
 	}
-- 
2.53.0

