Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68FDD449EDD
	for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 16:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777392503; cv=none; b=F12ZW8bMnKJFVC+lpojl5szdGKXdGA7uvQ3QmMQplOI30xyhsr4AEjkcqnqMe3xhvNh5rAfbGY92ldQb+45Pyjld7b4gWvkwZHYOGufkIQlADnt77Fd2Ce73sQyDuoh+sR4LYK7y3NfQZed3zwf3GKTa7cTt0Jc8PKozCWW/auk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777392503; c=relaxed/simple;
	bh=8qx2DRUX1B48lgDcMV0H/JoKZ5REdvkIb7aId73YRXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LsYj3/5nhq4GnDKusSzs7juopZc4EuY8fKTISLwbxRHGB/e1oVUe5CxCjhLWhOXAXS3t96XknfG7IrcNofLpNf5oQbTSP8Y1VwGDqQj5tcNSOTLaNe6g/Pj0Sxi6bMEkYD2otKJl11QTwGSRlBFycowPUQbyRMMd8C6G53o6jcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QF8o9uXw; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QF8o9uXw"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2a871daa98fso76051295ad.1
        for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 09:08:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777392501; x=1777997301; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tMpfJfDPYLUjScq5XH3LfedUkhoimyWrZal8ssI+6ww=;
        b=QF8o9uXwTNB6iqsDHqVB2oAVGPmUvmiQ27OsnWe3YCOZoikJdJgbsOFBGVVaHIpwBQ
         xcP3sJ2Z04SM28XEbj5irhEKHN6GmjtLNFyIJQIZcbzkyFiUgwzGF+4v9E5B9xUKPYuS
         iBCaOPMzRTX3MMy7jXNTS0NWbwCnBVkY3/ywGrb8xkSU5aWzlYiR+BprkfiHjSIYNYlF
         c2pMUs8M7FUCsc+TPk4csacEsNX8N3+IrCqrneYYKqgrxwkdKT1bJ2+IRbpBJBXH+q8l
         jctJ/VxG16DrpifgEQdAJpcUhAYrf9QARtZQzdqzsfUBKr/YZQb29CaMcD/7c/dhiDPq
         RzuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777392501; x=1777997301;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tMpfJfDPYLUjScq5XH3LfedUkhoimyWrZal8ssI+6ww=;
        b=O4pEO0poRn2uJyCQYOCOr8e4Y1vsLvapuYTB88m80rwnVB5F73vXmkuXIcYkdeuLXt
         GzSYrPqbcQ/sKq91uwmaOAorlrzzy2fny8doD91jHwSII5HAkUax7mgzWD0rueeVOjut
         4n+Eq7aDUM+xp7T80BdHkyDPCyYbQ8pzwwP71nQC5zkA70v/ywyMDtHD478A/NQCGcjy
         2Gd8yEll0aaO6Ab7yOjNpNCoMS2gBT/9tGDsGxZLxAibp0nyG/KjPHn3GGQJepTOK/0a
         hpBnoJfrGAYjkCp+ALJRThxNtyWVHm21IhSii+ds9BMD0yMZTxxuj3/DG1iNssV1LA11
         w6OA==
X-Gm-Message-State: AOJu0YxufoPAnN/h/Txud7y1yHnbAwU6Xc6bNACWdPb8v+TLSOgtQmDD
	qqXNjbFsIRoPyt+RFPbyJcwilB3W9jWvQWvtNbZt30423Gd9NEwweXUVQt3ORaWA
X-Gm-Gg: AeBDieuPs+wKCEblJgKplVLpBRo3Geifscf8bTlHyKAMhmLzU+Ns34aNFV97aCHc32n
	C145Hg1tJW/Qe3sC9nL6TJc+ovHvF9wFei83yeOOuqFRImvbBvOvL82AR9gBXcjQGRnKRmqV6V1
	1vR+4wWd2oem+PCCxYg5TUyXGAWaxaU6mX4Z/RpJ2d5YKZJMYJhY9X8zo71wom9I0OrpId6rOCJ
	tC8k7fFB35UdXenG3xbRl9iwf5rOphHInOLoM5fDXD+JgSiwNzlaCL1yxEtmuJhiRCCAln5TSmt
	3Jd2MvmK5RgWZGvLJwbEvjz9cwjyeJ2XKJye1ff6EXEOS+PavLa5m7CjKBl3bu8bY78XUK3acNX
	Xt3KcuPqM5vxMBDROmpq+2aOgEZifcUGDnsfoVvaqcFtUrzTWEuEdJkdybv4m6V8sD9VjdopgNf
	cvxGJG08jmhGwJwZrhjpaPWBogEW/rsyA8Ld6bpu4WpAFhIOrVWSSMYqiH2p2AzeVK
X-Received: by 2002:a17:902:f550:b0:2b2:5491:e32b with SMTP id d9443c01a7336-2b97c462246mr39487505ad.23.1777392501215;
        Tue, 28 Apr 2026 09:08:21 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.216])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b97ac7894csm30864465ad.50.2026.04.28.09.08.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 09:08:20 -0700 (PDT)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	pc@manguebit.org,
	bharathsm@microsoft.com,
	dhowells@redhat.com,
	henrique.carvalho@suse.com,
	ematsumiya@suse.de
Cc: Shyam Prasad N <sprasad@microsoft.com>,
	stable@vger.kernel.org
Subject: [PATCH v3 02/19] cifs: abort open_cached_dir if we don't request leases
Date: Tue, 28 Apr 2026 21:37:47 +0530
Message-ID: <20260428160804.281745-2-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260428160804.281745-1-sprasad@microsoft.com>
References: <20260428160804.281745-1-sprasad@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

It is possible that SMB2_open_init may not set lease context based
on the requested oplock level. This can happen when leases have been
temporarily or permanently disabled. When this happens, we will have
open_cached_dir making an open without lease context and the response
will anyway be rejected by open_cached_dir (thereby forcing a close to
discard this open). That's unnecessary two round-trips to the server.

This change adds a check before making the open request to the server
to make sure that SMB2_open_init did add the expected lease context
to the open in open_cached_dir.

Cc: <stable@vger.kernel.org>
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/cached_dir.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index 04bb95091f498..64e22c064fa0a 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -286,6 +286,14 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 			    &rqst[0], &oplock, &oparms, utf16_path);
 	if (rc)
 		goto oshr_free;
+
+	if (oplock != SMB2_OPLOCK_LEVEL_II) {
+		rc = -EINVAL;
+		cifs_dbg(FYI, "%s: Oplock level %d not suitable for cached directory\n",
+			 __func__, oplock);
+		goto oshr_free;
+	}
+
 	smb2_set_next_command(tcon, &rqst[0]);
 
 	memset(&qi_iov, 0, sizeof(qi_iov));
-- 
2.43.0

