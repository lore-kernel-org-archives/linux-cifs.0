Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C84A286D5D
	for <linux-cifs@vger.kernel.org>; Sun, 27 Sep 2026 06:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790490827; cv=none; b=CiQaI2/ftFPZ7iwSYyMKg/6xjQbvbjfSCrHzULMaq+rP7/M8JxiyJ7cyZEe+w00s4nDQ54JyykRM0/wJpgL34RH2vYYLSV0epPh+v1atvDwZYsgXu7zHKc36EioE4zca0s1EXhE+BnntcG9WfIIkGnVhdbx9Q11SJxKszDwZDeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790490827; c=relaxed/simple;
	bh=yKYsbQaSNbfxpL9AXn+Dk6w0376LevsziE0CM3vXnRg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tNhqGef7K4kEwZBJ1JR49MiFQ9Ejg5yd3mNaodxr5EOjBQZ8JI1UFpn0F4VSvEp6NWT1DXsx63sCnQJUy9n8nYigg+X7PR/GSIvkKatYe2+GsEbWPatoko4700WhGISF5lNp70wM91M5OOjDDikHB6Sj8aC/5Cf8UTNATuXokHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iicfrTKc; arc=none smtp.client-ip=74.125.227.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iicfrTKc"
Received: by mail-pj2-f13.google.com with SMTP id 98e67ed59e1d1-396ccb65437so1178553a91.3
        for <linux-cifs@vger.kernel.org>; Sat, 26 Sep 2026 23:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790490824; x=1791095624; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=x5E4VrjMKmWAeZuEbOPf8+lhLbvIn9eYFgM5VNzNGZ4=;
        b=iicfrTKc1PAxp8WsHiF3LMwU5EowI+39ZBCp3xjDwgxk9MpZ0P58raaCXjzmhPkohs
         UD4iNN9KPhE2o9epeIYkFDWtQEvMNyMq7jkM5DLqf/qUT15FLZUGGH5Mk35N+bPdQal/
         fK3h2d6+FW3/n6mchLLrulwMo+FJt4tbpQe82UaIzXE9+K5lJQANUb+k6EztFvAau0yv
         X3HKVMt/XlkMNWLyPGT5545Nxqg3ywZ/woBW8gQv4at+fbFSZhbEIWDrqKoK+xOZuLfs
         0SFcEX+99vsgMLsL5exCzCk90S8YkSQEPW2lgy/K/g/K+Mm9duObf6RCGPvjvAF6Vru4
         4sBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790490824; x=1791095624;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=x5E4VrjMKmWAeZuEbOPf8+lhLbvIn9eYFgM5VNzNGZ4=;
        b=oeW7EyG22e2EtcB48eEFBX82fV9LD0s3XAasOMNplFsGsco+hxt/fs5yIzf9l8cBlG
         4TGO4d7A+JpE0oOjXwrUOt/fskKF6MK78aGyaPTSpCM95RL6iuob/m07Po0kWQVv7itz
         3Ufr+WaYfWiaHa1BssqLq2AJXRaCJdNVmoW5dLq4CA48KAuBAPNm8V7NY7bwro7TleJt
         AKnP9xMosN5UtyyecgcBR0h/tuwnRbRMEp7plChiD4whP2zDqjSU+1tt767lC6XytruW
         uvqf294IHVhOglyP44hkXairEzTL6lTABWyvJD91gOPcFIB4rYBAnFNSNAbFQMx+P2ru
         ikNQ==
X-Gm-Message-State: AFq9FYLTxe0+3OTvTgBb6IvTrIf+c14LyCttArnYok0TpXe45XH3ia8f
	aCfvCML3A7ejRT0CvgLaE3pYV7x5N6Ueq6Rxtw3DJKNxZqn3Mi8ePI3et16hyTYuLqf9z28B
X-Gm-Gg: AYBFou0GOz4BZ131xLvi6l4/+dHaB+yGSIeGZ6wW+AEEokqtD+DXAw+c9ot/tbDw84Y
	rdv5F3M+1DwdiVnKwDBpbuOR1DWUBYqnr8hTvoNLl2x37X4mSChl2VLk7GP8OoUTojXcalWs51g
	wgpHqIeZNhAa2RDrNCpagWq1WEdasW4iCA0oM9XZm3mg5cosJT/h5EOP7g8XjlZtARhHW27nDcd
	8k9axcBAUgsOkL6LdtC9AbEr6d6DZ+GRF4dOgVHuN0IJKwyJG/pP+BWz6/rDrf8LMh1kOchfJ2B
	GMSXgojuLNKRnnbSsV1QBDMWEe+LC2uuaa/GtaU8mAENCKW4ral39jJAapUcG8I2ddeGPNqJecR
	sg5MtWsMq+3/Yx9AjSIDO3Xb++0v4qdFOmstAG5ETZCLui6G2j7G3HOMRzUamAiBKpZ8O3mdSDw
	CbTgnjGLjWLCys4NBh9E8B/vESIvw5VUi7iatUBSkymR68/u34jrOxr2M74wqXndURV+ztp7PEP
	oTt
X-Received: by 2002:a17:90a:ec83:b0:39e:6c6a:4b77 with SMTP id 98e67ed59e1d1-3a098e43948mr7363556a91.65.1790490823764;
        Sat, 26 Sep 2026 23:33:43 -0700 (PDT)
Received: from localhost ([8.219.239.189])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a09773e7c3sm19804747a91.17.2026.09.26.23.33.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Sep 2026 23:33:43 -0700 (PDT)
From: Dairui Zhang <zhangdairui@gmail.com>
To: linux-cifs@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Dairui Zhang <zhangdairui@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] ksmbd: fix OOB read in ksmbd_validate_name_reconnect()
Date: Sun, 27 Sep 2026 14:33:39 +0800
Message-ID: <20260927063339.1731061-1-zhangdairui@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ksmbd_validate_name_reconnect() indexes
ab_pathname[share->path_sz + 1] without checking that the path is
longer than share->path_sz + 1 (d_path() fills the buffer from the
end). A durable fp is not bound to its original share, so a client
can preserve a file from a short-path share and reconnect it on a
long-path share, making strcmp() read past the PATH_MAX buffer -
with a long enough share path this oopses the kernel, and on a
mapped page it also gives a byte-equality oracle on adjacent heap
(the reconnect succeeds exactly when the out-of-bounds string
equals the requested name). A same-share variant with the durable
fp at the share root reads 1 byte past the buffer
(strlen(ab_pathname) == share->path_sz).

Check the prefix before indexing: the path must be longer than
share->path_sz and the next character must be '/'. The comparison
for the valid case is unchanged.

Fixes: c8efcc786146 ("ksmbd: add support for durable handles v1/v2")
Reported-by: Dairui Zhang <zhangdairui@gmail.com>
Assisted-by: LLM
Cc: stable@vger.kernel.org
Signed-off-by: Dairui Zhang <zhangdairui@gmail.com>
---
 fs/smb/server/vfs_cache.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index 293dab9..52e83cf 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -1714,9 +1714,13 @@ int ksmbd_validate_name_reconnect(struct ksmbd_share_config *share,
 		return -EACCES;
 	}
 
-	if (name && strcmp(&ab_pathname[share->path_sz + 1], name)) {
-		ksmbd_debug(SMB, "invalid name reconnect %s\n", name);
-		ret = -EINVAL;
+	if (name) {
+		if (strlen(ab_pathname) <= share->path_sz ||
+		    ab_pathname[share->path_sz] != '/' ||
+		    strcmp(&ab_pathname[share->path_sz + 1], name)) {
+			ksmbd_debug(SMB, "invalid name reconnect %s\n", name);
+			ret = -EINVAL;
+		}
 	}
 
 	kfree(pathname);
-- 
2.53.0

