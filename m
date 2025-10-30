Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C2BD330D42
	for <linux-cifs@vger.kernel.org>; Thu, 30 Oct 2025 17:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761843712; cv=none; b=atkjx83BUiaeXIo1oQaxf2tBVcHtuQzaxTrOawAzSDDL/sx93W+gKwgaTcTS2IER4FHvA3gFcmmuOzlAfpiQpIfB1Mii3t8uN9QRsZ/QDa0Vrmx+xBv/+fFJSCLLjdYugjZRiTnvW/C96jQWIAtsuX5jfj+VuE0XJnIAxUF4C9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761843712; c=relaxed/simple;
	bh=HTxmNRT7OTKZykSqcxZiLZjBzKT+I6sfkHZfgxJjeIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZkU7vuXD+E2GTDAEKcqc0U9Eqf7hT8PO6VkJQHuRE3RB1xpgrf8RoVI42rRuUAbqLm8bp1YIN7qyS7+CCzv5f1cDWB0CyQ8JawYopvRy3jjn7codIxbpvp7kbkNoWd2rb93GY3E+cvO3PVpNv6NK3zQcVGDYWq4ArESNRvEFeoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hYEkTca8; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hYEkTca8"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-34029a194bcso1531351a91.0
        for <linux-cifs@vger.kernel.org>; Thu, 30 Oct 2025 10:01:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761843690; x=1762448490; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vtKIBQvYxGkMhdq8eW3gVNThACtdyAfJe/7FuQf9bXg=;
        b=hYEkTca8E9AZ6Rzb+DPn28ExuDSbTucNUsGkLIAcXt/ut6V/RkfoivJfRezhoiS+Mu
         ZS6UNkwbrMjMNiPg9IC5A6Qnut7ihRwl20zU7cNAubgjhBCv1bDpOo10y1pqAs0qQDVb
         CRdwZ/CDWC0yy3pj+fT1w5KmfRufhOv/9nq1+WHNCRv5GWSZcIiu9DB/au4PB3zgIYxh
         pjr+AfflQn6JYPp45nGAD6sayyGarKY7VWVY0G7YnuePSGGTIhLZ9WVg1GADcp31MKIv
         4eRB/38pZgb/Ygh/vOoOhoDAhY2D9pQXhZXbOJEjFza7MItr9gJWQ5YdlvpoLIebJZcB
         XDqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761843690; x=1762448490;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vtKIBQvYxGkMhdq8eW3gVNThACtdyAfJe/7FuQf9bXg=;
        b=pqEFy4/L8zX5khN8cr/+iB3pv2bqgs4OTVa1Anynhz/o3iP3Bj8uRwxNfVyfjqNS4f
         V6mRlNkgPOcgkagdXz1PdL5imR2N7AlPFhZ8C1/VkSsHfI4+JZzx5H5Go/2ATs5xEPfN
         et5aOxxfEEH6QijkcyLPnUDb6dhEAGk/IkFAGs8b9GHLpHoxd2+EKWCcorFZrJQFgFGS
         24Wo4UxyzFmGSrw+cuPkGvNh3QqL3tbiz3Yb6EbZ2qwT/Vofo0E97jUBXW7RbcS3XG/Q
         7GxLsifrJjK+nQWn6mQeB0JCygdFTF239Ac+RZ1Uy3PtXfCChw1+gVHvWRU7U/rfFt5/
         fTMg==
X-Gm-Message-State: AOJu0YwISuZ8DkiC0nRsPPQKK/Jn8+3laMiWIgndYqRJS0F7AWLj5HaO
	aesu5um5xnnHEESIRjYO5Oeq9+9l7LnAPxlqPuDCY3l6qkI8gAyhD1jXbuiYQIIZ
X-Gm-Gg: ASbGncsv99Aaer9P3FYa/Z/SdUGCsQNTl7febQI51olhv06u1QBbX8X2Vs1bC4fj0pz
	uNLDmPQoC+h3ZKljyj2P4sEusutiVrpd8h7Yf9+AdeXhrumRBYb6lH63Acuh88l1LhHrwlYPbqR
	039UGDjdGdd2EjZvOksgzkvKY9+l2+7CctxhQaTzBghAIYySdlhDnkSGNxkclzFkPPE6deSjdhH
	LOGGc0huXY5cZknGEk3sIkftRvYdfKDiPQXENrXm1J0cB/vBWw7tje8z98uwxMXgVRMJblYELeE
	bnZDsKTzUme3iCc7pg6zSYSIlhORKoLReW4Ue7K5SqLLd4Ll8HpQI6S4oTjJ2ZKpzs4WaTTKlty
	JVE1wgErzUcU1Z117zP4EFE7elOiLv2Xy8k5OXel6tsD+ysO8ZKopp3AtEzxBuXrVaDb6Mk09f9
	OBH9Wt5snmp9LG8r20c+O62LXrPas=
X-Google-Smtp-Source: AGHT+IFW99ggwqFO5TtPqqHBT+HcRYnp0Yxz6WDnW+xYWYJrcaYGU/9paLm//rxeF/grZb4G8/cE3Q==
X-Received: by 2002:a17:902:d2c8:b0:275:7ee4:83bc with SMTP id d9443c01a7336-2951a36c306mr5384315ad.2.1761843689340;
        Thu, 30 Oct 2025 10:01:29 -0700 (PDT)
Received: from bharathsm-Virtual-Machine.. ([131.107.160.85])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-29498e41697sm191788485ad.98.2025.10.30.10.01.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Oct 2025 10:01:29 -0700 (PDT)
From: Bharath SM <bharathsm.hsk@gmail.com>
X-Google-Original-From: Bharath SM <bharathsm@microsoft.com>
To: linux-cifs@vger.kernel.org,
	sprasad@microsoft.com,
	smfrench@gmail.com
Cc: Bharath SM <bharathsm@microsoft.com>
Subject: [PATCH 2/3] smb: client: show smb lease key in open_dirs output
Date: Thu, 30 Oct 2025 22:31:15 +0530
Message-ID: <20251030170116.31239-2-bharathsm@microsoft.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20251030170116.31239-1-bharathsm@microsoft.com>
References: <20251030170116.31239-1-bharathsm@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Show cached directory smb lease key in /proc/fs/cifs/open_dirs
for debugging purposes.

Signed-off-by: Bharath SM <bharathsm@microsoft.com>
---
 fs/smb/client/cifs_debug.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
index 1383caa5a034..7fdcaf9feb16 100644
--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -324,7 +324,7 @@ static int cifs_debug_dirs_proc_show(struct seq_file *m, void *v)
 
 	seq_puts(m, "# Version:1\n");
 	seq_puts(m, "# Format:\n");
-	seq_puts(m, "# <tree id> <sess id> <persistent fid> <path>\n");
+	seq_puts(m, "# <tree id> <sess id> <persistent fid> <lease-key> <path>\n");
 
 	spin_lock(&cifs_tcp_ses_lock);
 	list_for_each(stmp, &cifs_tcp_ses_list) {
@@ -343,11 +343,15 @@ static int cifs_debug_dirs_proc_show(struct seq_file *m, void *v)
 						(unsigned long)atomic_long_read(&cfids->total_dirents_entries),
 						(unsigned long long)atomic64_read(&cfids->total_dirents_bytes));
 				list_for_each_entry(cfid, &cfids->entries, entry) {
-					seq_printf(m, "0x%x 0x%llx 0x%llx     %s",
+					seq_printf(m, "0x%x 0x%llx 0x%llx ",
 						tcon->tid,
 						ses->Suid,
-						cfid->fid.persistent_fid,
-						cfid->path);
+						cfid->fid.persistent_fid);
+					if (cfid->has_lease)
+						seq_printf(m, "%pUl ", cfid->fid.lease_key);
+					else
+						seq_puts(m, "- ");
+					seq_printf(m, "%s", cfid->path);
 					if (cfid->file_all_info_is_valid)
 						seq_printf(m, "\tvalid file info");
 					if (cfid->dirents.is_valid)
-- 
2.48.1

