Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794961534;
	b=LIwFus4FTZRVFB32yfSVykI23YuyyPn3FiZtG9gFUQDVJeuCYnUI89jTcaa9SLSfIaSI
	 bqISVBwcg4ErLDb1l1ZecLOS4MQOnx6Sm4A9Hh5nMprlkIhjq4aBXE0Wpd0N+ZOSZMOQA
	 WffnueM57eNgWGoPEmmPaQC066nni8PgKfHzS5IcaCrT0wVHCIF04lKnQxikRYbvFqHE2
	 hZZgu4uGwcyUI2NMbiwCtaUNqdv7yrR7sgHqFq8i3z6i7xS+LInwQSVbR1/ZLXT3xDN+T
	 gP/WnQhwYkxYOf1t4OlQwU8bgxW0EDt15FsfHXhFdSn1FiaoMOFCtEqh5whPHQVaj8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794961534;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=YOsED0g/bd1ZFHc7sB4ziCibNPUUgz2EiQJdiyX05eE=;
	b=wY7viHtpQhyUzDUENe7mina0NtP6Qi802PKQefgp2rE4n9HXL6yTvrfTL55jUq9g5WR7
	 aFtQehIuBsownm8Y0lX1Yonu7KjSo91KE4dcPZb4JWxQjKPU9KifW9w8WLRROgtcuyYNz
	 U09WYj8CI8L4xSsZnTEjV4bHOfcJMXi9+X7kuvIDqlf55CSgZL8a5W+Hl5k+aSSCpeKcG
	 OrS3Z8uj4rvMuWprXc43DkVPqrfwzYGp905IOOhbNl/G95scf4PmMvKPruIOQvi/pDYXD
	 fLg3wpl5nanCBCNG7+a7jch4cv/GOdzk9+Hhaaq2vo8Xrn5gB37/nl0jD7NCgPcFb+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=fBRvclcE;
	arc=none smtp.remote-ip=209.85.216.46
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E36CF606A330
	for <linux-cifs@vger.kernel.org>; Wed, 18 Nov 2026 00:25:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E36CF606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=fBRvclcE
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-3ace1f3897cso213229a91.0
        for <linux-cifs@vger.kernel.org>; Tue, 17 Nov 2026 16:25:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794961533; x=1795566333; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=YOsED0g/bd1ZFHc7sB4ziCibNPUUgz2EiQJdiyX05eE=;
        b=fBRvclcE6DV+QVl1fn5PVAdkf4Ap78GiiTNsA/hCvlkDe8tnEJGuDifjgFZ1PL1qaa
         04eHV5oPKnnSEUW2jtif2P4s4pCyTsZz927Qp3K3i/t1piC8Lo3M4U1IoXMyipM1BAer
         WdsRYqd+6v8M80crHGhRi66FmeSxkc/KaPMcrhj99/+ktBJ8Q30p4LZjGyrDgK4smy/+
         5k7an5IQ6lSArzZ2shka6Xoq3Bdx+2KAvpNJE/ukoXF6hOyspDsknReUgPvKLbtBPVuU
         Jb/bnrke9cHXC0Dza4xH1qwy8NYXl4G1zN1jsaJsVOmpd4SK6rEopSO7ubp31dPmb/rS
         dhnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794961533; x=1795566333;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YOsED0g/bd1ZFHc7sB4ziCibNPUUgz2EiQJdiyX05eE=;
        b=0J3u5nqgQwZza/hHmbsoLrmFmBe3JdssCIpLIRu49Y6PFPbFejKlFd19Mnn43gsCbN
         vwKkpiU72WWUay6VwcNwkEgVqLFh8v7bMN90phNqNJcw1l0/ybMMrFBB/EvLzv8rMBNr
         CWuImjpudx5fB1qvtzn/Bpy8F4Ach5oyf2J9OsEgqzv+f3Acl9RwYa6j5pVlBktybz05
         HJczxAgqg933q1S9NYsUBFPrapdZ07gEmKSaCUY8GhelvU29oLAz6jTtdcvXt25gcHkG
         XBRS1K8YxWapXXovFS/cASKmIV/ljMGwGbKczu1lv/F1l7jV7utheZwnd98TxqFS1ypX
         EhYA==
X-Forwarded-Encrypted: i=1; AL+hErG1ZcfXR7ulEnu2NxAH27Ksg9bPkTR8pjW/N5Y5uzERtk968RCCo7+TqKaw8PHTUUmhagMcfbAIUt6m@vger.kernel.org
X-Gm-Message-State: APuU4Z898k0z+dD6m2LySYfvdL1wKOvpSMzdAMGEUbWN5rhdnCfNzBna
	wVLa58HcxBRgMePetikNYA9DWti/8+WP4y6Wg957acDVqwP2Yb9NFe9S
X-Gm-Gg: AZFdTZfuel6il7D7EX773U4qPLM0HhNsMXZaF7jTZMu7KXWhhATKZl/2brgvPI3GeIR
	NYX7HuTjoxk16hVEClVCn4CWsmrHnH0gtYPVOOsj3c5g7ClTHiX8DcKtvWLHC9FtIK/sxDny+EV
	kd1URAAU175PI7eVeBZEkGtyAcK2S8UPJOQLcXlV3hXBv5ffZP4tvjuFm9Ziw1tSMO0+WB3DN0B
	mKkNUC4EOjok54LRINCzYnm9N5PYWgqwKFpqQNp0AM3NYVKvd2v1hX5eZDDlD8tZghfFCBXq1qC
	/TsUPgDe/cNZdkCJUDJA0goKKOpaRE8TW4xlgEA663sh7gKtw916z3IB9YS1kvqo6O3N+sGgyFL
	ERrR1DE+YsnT2Y8n43HLulMCWWSPFRPQZ35T72I4J3uzRSTS241g3/0lGRBvY53hHdAezlDQIAk
	DcIl+zIXMTwPXYndHpxGzfrjuSMyZEDdrF8Yp5Z6oUHdrrK7jwZKypv9cIhQ//fdff02UyxTupK
	69HwFZUC34PtZZpSHbBi7+KjpcyqssIziU0IPYsXV3oP7vesbp0XIXpJTxjhog5hTDNcy70sNaZ
	CmRd/EgghVr/K1qu97Xq7xiSZAH6XZfGRigZy9NCM8HyUstbg3p0vlKk1YNLi7QvPqWCGvnqo9Q
	UBLTsHGKgjoSjAIZJY6SqlyQiSRFzzH6ZJ9gDRp2uc9oXB6DgUVbtj/2fUOpUa2FgdMPN1z3DNm
	f7tFGKYhnCxTY2yUTiJcTWROYjQzMqV+rno18nnd4D6dL2dEQ+EE11krHi3Fq1oQ==
X-Received: by 2002:a17:90a:d444:b0:3aa:fc22:8aad with SMTP id 98e67ed59e1d1-3b3d07c23bfmr1013734a91.54.1794961533262;
        Tue, 17 Nov 2026 16:25:33 -0800 (PST)
Received: from sid-dev-env.cgrhrlrrq2nuffriizdlnb1x4b.xx.internal.cloudapp.net ([4.155.54.158])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3d1c04020sm1212211a91.17.2026.11.17.16.25.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 16:25:32 -0800 (PST)
From: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
To: Paulo Alcantara <pc@manguebit.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Allen Pais <apais@microsoft.com>,
	Rachel Menge <rachelmenge@linux.microsoft.com>,
	Hardik Garg <hargar@linux.microsoft.com>,
	Siddharth Chintamaneni <sidchintamaneni@gmail.com>,
	Gillian Laming <glaming@microsoft.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v1 0/2] smb: client: fix cached-dir and deferred-close unmount races
Date: Wed, 18 Nov 2026 00:25:27 +0000
Message-ID: <20261118002529.250616-1-sidchintamaneni@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

While investigating the cifs_kill_sb() unmount busy-dentry race fixed in
"smb: client: fix busy dentry and inode on unmount from late oplock
break" [1], I wrote a static analysis tool with AI assistance to scan
for the same teardown pattern where objects are moved off shared lists
and locks are dropped before their underlying dentry references are
released.

That scan identified two more unmount races in cifs_kill_sb(), both of
which I reproduced in QEMU where cifs_kill_sb() reaches
generic_shutdown_super() while dentries are still in use:

- Patch 1 walks cfids->dying under cfids->cfid_list_lock in
  close_all_cached_dirs() and holds cifs_sb->outstanding_rreq across
  dput(dentry) in smb2_close_cached_fid() so dentries for dying or
  concurrently closed cached directories are dropped before
  kill_anon_super() runs.
- Patch 2 counts cancelled deferred-close handles in
  cifs_sb->outstanding_rreq while they sit on a local stack list before
  _cifsFileInfo_put() completes in cifs_close_deferred_file(),
  cifs_close_all_deferred_files(), and
  cifs_close_deferred_file_under_dentry().

[1] https://lore.kernel.org/all/20261117001733.192399-1-sidchintamaneni@gmail.com/

Siddharth Chintamaneni (2):
  smb: client: drop dentries for dying cached dirs during unmount
  smb: client: fix busy dentry on unmount from cancelled deferred close

 fs/smb/client/cached_dir.c | 31 +++++++++++++++++++++++++++++--
 fs/smb/client/misc.c       | 32 +++++++++++++++++++++++++++++---
 2 files changed, 58 insertions(+), 5 deletions(-)

-- 
2.43.0

