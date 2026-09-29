Received: from mail-wr2-f34.google.com (mail-wr2-f34.google.com [74.125.225.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABD6D345CBE
	for <linux-cifs@vger.kernel.org>; Tue, 29 Sep 2026 09:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790673510; cv=none; b=B7EQzR3SOIBJ3XGSraMn+LRB8/CHbemrGXVlEFvXG1E1LhsfT8M1p6SWcig/ir8T7MjHZyaQ60ya1AxZKo9dtFQv98wJ2b0sN83FAPSYHAppsYLQSefWrqFkCYUqmBTlfbjx1XIVQv0nisZoyQ6rCqqG36t/HEE9PBYXayadSXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790673510; c=relaxed/simple;
	bh=bS5Bl0xa81rzIkxNbApegWs2WZzqmBmCIE8TNuw54Pc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=foxms6hS8xM8SAsCo6V6Nz2csPjuCuqKC1jkJqDRR/NV/DKM097RzTCTEI4CI8RYHyOdq1XyuE2YXwJ0sVW9QLLaWzmkpmSHjUveXZI+W6PwX+2VDLQiitjr0BRRZygcFmnEdKwMZCquQLTKi041Zzeoy79i7e9df/FRNZc2vqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bynar.io; spf=pass smtp.mailfrom=bynar.io; dkim=pass (2048-bit key) header.d=bynar.io header.i=@bynar.io header.b=j9O14ToK; arc=none smtp.client-ip=74.125.225.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bynar.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bynar.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bynar.io header.i=@bynar.io header.b="j9O14ToK"
Received: by mail-wr2-f34.google.com with SMTP id ffacd0b85a97d-48af0707d41so316759f8f.1
        for <linux-cifs@vger.kernel.org>; Tue, 29 Sep 2026 02:18:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bynar.io; s=google; t=1790673496; x=1791278296; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UwebXvzDIraGE65KpDBsvLxOFDUyckzx1+RkdFrULNo=;
        b=j9O14ToK61ZEHyLSgktne67vMgvUXX2wobpBc+69iuPOYNrv/E981ATSbE/EiS2osg
         MNBxHeafkpZCPcndngKT+CawhQHG86Jb8xeHyfIF6/StLNC8rMTSREiXYlvmagE7n39w
         2ZWUOXVnJghxTJORPyyE0WP/ocnUf41m2s/eA7ct5l/TZGkL/lZYj+TOJygWPn3kg/Xz
         uhme4ygPKWH7fxxIh1KQbm9gfWIpc0L68w77OtNSQt/pZ88Kb42zhYd+7qAmqfKIo5db
         3I7urDwhDfW1gtmKvnfRuJpKbgy4WoVxB+4iIdVX2LcuseZkEMBZhMsb11IeEvHfFVHi
         hpNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790673496; x=1791278296;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=UwebXvzDIraGE65KpDBsvLxOFDUyckzx1+RkdFrULNo=;
        b=FWWMQe9VAWR4xLwdG7eVFXZc/ofuyXwYhgoKfmpo9AJVNy87d6GR69TP7wulpZvle+
         NEXwzuRkmg5Y79QUQ1VyFN8vQK1utQ7geV6AWiKG3U8wIg1X8KLxU/90bplNjX0miLGk
         iGOTzbXZrCF2OTd/cbaCCO73hw73H+CXdyO87y7bhHI1rHcoGfKAfJEyN8B8vFrgsiZ/
         Il7DKm4PhYawCyMRvNzycYU9mzyRisns7rCGdmt3sSvjJ+l8Cca4wEFbd7fVYyAwX+Uw
         f4Dbk+nycHF+seIEpWHk3+ec0FlbkdSRKde73RYYhqTDG8b3oekRuikP+Q2ZDWYWzBRq
         OlSw==
X-Forwarded-Encrypted: i=1; AKwUvBzlVGHInuiu98YYQ24WmsNQGL/3hS58BozjbA0fv1lJs6k/G80QazGNen+CBw/VdG+juVvxkYe46aEz@vger.kernel.org
X-Gm-Message-State: AFq9FYIioEBviaC/YE5iAAmhb01S2z/ZwQrELuWMREy5B4SJCjwyBIoR
	L3bhWKhXuEAQjZmWtDN7zFd92VUlE9LfIx4EyFcam/TBJGMghiaTD8YU0a6TZWqB454W
X-Gm-Gg: AYBFou1IpijMskWsGP/j4DzwDNQKW/nUUskMNlUB3U8WazkCR+rICZcNrgmfMz6a8rl
	E2VxQUOdn9RYAcb1BHhkmIqaauA0mcHotSiJPIV0HjJmXk38VXDh4MJHcO0VC6PoP6Onvee8Eko
	pwr+ErMvqiKzSHY5Py+m8L3Zo0bwqnNAN6ed5DhsJxy7SwSYea67TMIZ5xMacbeIu2qUUo8pGN8
	4dhPp6ZyWm0rFSUC6NUMgFOqkGMvz2pfIlGmS1rvqAt4Zmcm4Pm7uwvx6eT5tTXBDnNz1t3EzRC
	1FYD6Muoor+NfK/3DGa1byFtVzawgz+QiAKaqHpP3201FrW9d5Iav0hKhTtyQEEKPFaYFwp6T2U
	XVY2jA/G+q9jINgXW/VhWu+oTv7kXoSdskWSdDczTDELL2KHvAQNVpYo/DfNa4mb8E2v3wzHHYz
	rcXwvDhjxPSml7RWqc1P8z8KeDRjezjr20+gzAVcqcGCLqTZ3Axl6lxquN/hkfmyU6/iab+QhVW
	ulpdtaMsWrznDDMk7eUdl1onVwb
X-Received: by 2002:a05:6000:1446:b0:487:a87:24c9 with SMTP id ffacd0b85a97d-48af1a8f14dmr3594245f8f.3.1790673496044;
        Tue, 29 Sep 2026 02:18:16 -0700 (PDT)
Received: from debian12.ucl.ac.uk (eduroam-int-pat-8-79.ucl.ac.uk. [144.82.8.79])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48af51c57a0sm2155723f8f.15.2026.09.29.02.18.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2026 02:18:15 -0700 (PDT)
From: Diego Oliva <diego@bynar.io>
To: Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	linux-cifs@vger.kernel.org
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Jeff Layton <jlayton@kernel.org>,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 7/7] smb: client: drop the redundant name bounds in cifs_filldir()
Date: Tue, 29 Sep 2026 10:16:36 +0100
Message-Id: <20260929091636.2618227-8-diego@bynar.io>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260929091636.2618227-1-diego@bynar.io>
References: <20260929091636.2618227-1-diego@bynar.io>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

cifs_fill_dirent() rejects an entry whose name extends past the end of
the response before it returns, for both of its callers. The two
checks cifs_filldir() applies after the parse can no longer fail: the
one that commit f8cf09a53a0d ("smb: client: bound dirent name against
end of SMB response in cifs_filldir") added tests the same name
against the same end, and the older one, which compares the name
length with the length of the response, is implied by it because the
name starts inside the response. Remove both.

This patch depends on "smb: client: fix OOB read of the resume name
sent in TRANS2_FIND_NEXT2", which added the check to
cifs_fill_dirent().

No functional change intended.

Assisted-by: Bynario AI
Signed-off-by: Diego Oliva <diego@bynar.io>
---
 fs/smb/client/readdir.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/fs/smb/client/readdir.c b/fs/smb/client/readdir.c
index 1e121c970685..569efdfb7360 100644
--- a/fs/smb/client/readdir.c
+++ b/fs/smb/client/readdir.c
@@ -1016,17 +1016,6 @@ static int cifs_filldir(char *find_entry, struct file *file,
 	if (rc)
 		return rc;
 
-	if (de.namelen > max_len) {
-		cifs_dbg(VFS, "bad search response length %zd past smb end\n",
-			 de.namelen);
-		return -EINVAL;
-	}
-
-	if (de.name + de.namelen > end_of_smb) {
-		cifs_dbg(VFS, "search entry name extends past end of SMB\n");
-		return -EINVAL;
-	}
-
 	/* skip . and .. since we added them first */
 	if (cifs_entry_is_dot(&de, file_info->srch_inf.unicode))
 		return 0;
-- 
2.39.5

