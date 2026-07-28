Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2627B3FCB0C
	for <linux-cifs@vger.kernel.org>; Tue, 28 Jul 2026 21:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785273292; cv=none; b=fEk0ytQdzLI1PHqNmPfwkz/jaKgSIOyXrCBBr97v/3rANnIKZdXfTK+v0r37BbdOAn73JophhVj3EahIfLqRSgrg1NIM8tAUp18hDP1zLRIka60GBIcY05XPlMIfGhYn0tnkwh9V6ISJa20PEjFR/wyZy9S8FF4vShPsqOc3Ls8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785273292; c=relaxed/simple;
	bh=Q4KLRF+1k0JkMasKRe9+BpH3z91vIGZiJohqgkqGtgU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J4e+Jnn+gQmhqwr/owXrS/2fF7HwaqgOsHJldtVVGzmvJIIBNOvSuoXQ8BCp/E+SDNHSBEyaY3nUl8e4BpEYNT5qzVOG0CJHP7CLWzTI8ny8IEJ7+jFdxF1fKvzaQPbfT8d6Fyo8Ai3SIlZdI6vBs7L3EJHtZlLZK2Av/EFI7QM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QDRw+5kT; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=VvQH1lGp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QDRw+5kT";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="VvQH1lGp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785273290;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JAQnNvjTovbeYztyN6U2x3fslKhYUjZvXjusSIShA7U=;
	b=QDRw+5kTspQeVb3VjfA9tFrlmB7wqz0qw2Akkir/XhyENNgaJhk/36xhfLjLk5nM4zxrha
	PGw3aXtAix0AZQfv1ffAHfl9/ynDGjzOJSIBd5G9TDdcdXqSWo3g8f4qsXIxKLLlZEPgM3
	RTDTCAPmrROacH3S+7yfKpLZt4yGEWQ=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-437-7RZy2m0CPfWzx7GpvipSww-1; Tue, 28 Jul 2026 17:14:47 -0400
X-MC-Unique: 7RZy2m0CPfWzx7GpvipSww-1
X-Mimecast-MFC-AGG-ID: 7RZy2m0CPfWzx7GpvipSww_1785273286
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4a41e3d6fe9so292025b6e.2
        for <linux-cifs@vger.kernel.org>; Tue, 28 Jul 2026 14:14:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1785273286; x=1785878086; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=JAQnNvjTovbeYztyN6U2x3fslKhYUjZvXjusSIShA7U=;
        b=VvQH1lGpFGYGgYMn7KPmcdkyGudw/SiaJ1WeUPpDjOGJ1RNxPji/Lafl+uDmy8pCOO
         eECrGTNB5qI4qBpAfzfug5hpcfgTUQ4gW1FCV5YkqB0YYfdaJtDaOlygq/sbRC/MWZP/
         kiZ5IJg8mHHkivA05uxRVVJE0ZrEJAj1n3q9tpYICHr6xPGOWgvpHFz0iw0JRL/K2hSI
         lonjL8O6IzEdT9HrrCKyfORK/tLLz3QC3HEGkUtPnv8lhdmWl75jB3s8PC4x/eUGKM75
         5A42sDLxwv9FUji+iPE+79G7sH+lZk1kFLGGEnoLQqet7gLN8qjNpnSgoK4hr31XpOJ8
         qX+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785273286; x=1785878086;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=JAQnNvjTovbeYztyN6U2x3fslKhYUjZvXjusSIShA7U=;
        b=mKamTBof9oSRvQdrevjdua+UujJylvcA8YYi4G6av3zLK+EnUq6MLBFPDgyzG6DB7V
         2pNui6+pKvnvF5B9EHKhgXoDU0lsBV34b9WqUfH56t0znLOR1oZ0uP691+YFmMz7iCrR
         atM5NnNNkBVSKtrfT3jZSS21BlsVFUtuPYGuchFy18QeCUyThWa2kPK1RIA5ggrdImX5
         NH51lVa1++ApxDWK5Q7mI5kEMuQBUD0N6TaP0jgo6TWr+amrIVQ5TvVbjtyTO3ic+yY3
         LaHwJecPVSa6Y7tIyz+RLWqEzWqaqhV6shJooxGvDWZ1WS7d1RSuPulBtFVQThAQ+UC1
         iwPQ==
X-Gm-Message-State: AOJu0YyLw/1kI4R58ICI28s6FlTjmYJvgVlXKh9Tz/lDjXdh3GieFDMY
	Z1u7ZKHc5q87Y4Q8gDF6mgZAU61bg37EdpyQRYdSpw7sAwcFZ0ZzlRP8JoPbT1uUsLzoAxNQZPv
	5ZFbKzah2ROS0oYfw/ZuxPDFRBJAOrNjmKLPKJYSKrTl9mbS0KYas4crT8tKxm6toL+Uo224vn+
	wj4o/4rS2Pyv3Oe5xjLil0lZdbH7oy90SUD2blAsgfaGj6bkw=
X-Gm-Gg: AR+sD12aiqCNcU1UE9A3KjTxrVhA2AKSC+FcHLQCIPD6s3i7ycc/qI7nlnhTM6TwvDV
	/33GShZDdkpkzXm3FAiDpoiGYfquVZtb2pVP1KTDJD0XTIo2wUmyDqxia+tXnqY4NVZKIVEIEqS
	111gnus8qFTWQzOiWSRbSIyJUpQsi3z/zpbxmjZ+R/F5Po/jdnSovsYwX2aZx675legnGnH+uP6
	t8qatjhC1m3SQRJuaWPVoEan7BOft0VM4iEwCWxaXC19tgoE6JLjx5wSyLxHNEdRxqbUw9YOSOm
	Rv4TBTOJddVWZ3XC4AjWPZwpBAlFm7eU1w7FAo0BrGEYRRZlWaezSBmPK8wk9vPMi/mdyY14XxG
	jKeycVvhTcsDa0mFHecPH1am0ANMpZ4qtxv15mD2hvHeApTxBp/f4fpayc76j
X-Received: by 2002:a05:6808:1905:b0:496:1009:ec5a with SMTP id 5614622812f47-4ad5b965e64mr2457876b6e.1.1785273286583;
        Tue, 28 Jul 2026 14:14:46 -0700 (PDT)
X-Received: by 2002:a05:6808:1905:b0:496:1009:ec5a with SMTP id 5614622812f47-4ad5b965e64mr2457856b6e.1.1785273286026;
        Tue, 28 Jul 2026 14:14:46 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4ad6ed2dedasm231357b6e.7.2026.07.28.14.14.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 14:14:43 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org,
	pc@manguebit.org,
	stfrench@microsoft.com
Subject: [PATCH 2/3] cifs: remove redundant size-update block in cifs_remap_file_range()
Date: Tue, 28 Jul 2026 16:14:37 -0500
Message-ID: <20260728211438.3859107-3-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260728211438.3859107-1-sorenson@redhat.com>
References: <20260728211438.3859107-1-sorenson@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

cifs_remap_file_range() acquires i_rwsem on both inodes via
lock_two_nondirectories() before calling smb2_duplicate_extents().
cifs_setsize() (called inside smb2_duplicate_extents() when the clone
extends the file) therefore already runs under the lock, meaning the
fscache_resize_cookie() added to cifs_setsize() by commit fa724e235cfd
("cifs: add fscache_resize_cookie() to cifs_setsize()") is correctly
serialised for this path without further changes.

That same commit made the caller-side block:

    if (rc == 0 && new_size > i_size) {
        truncate_setsize(target_inode, new_size);
        fscache_resize_cookie(cifs_inode_cookie(target_inode), new_size);
    }

redundant: smb2_duplicate_extents() already performs the full size update
via cifs_setsize() when the operation extends the file.  Remove the
now-dead block.

Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 fs/smb/client/cifsfs.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index 1788d93a2522..1060ac5f9fff 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -1464,11 +1464,7 @@ static loff_t cifs_remap_file_range(struct file *src_file, loff_t off,
 	if (target_tcon->ses->server->ops->duplicate_extents) {
 		rc = target_tcon->ses->server->ops->duplicate_extents(xid,
 			smb_file_src, smb_file_target, off, len, destoff);
-		if (rc == 0 && new_size > i_size) {
-			truncate_setsize(target_inode, new_size);
-			fscache_resize_cookie(cifs_inode_cookie(target_inode),
-					      new_size);
-		} else if (rc == -EOPNOTSUPP) {
+		if (rc == -EOPNOTSUPP) {
 			/*
 			 * copy_file_range syscall man page indicates EINVAL
 			 * is returned e.g when "fd_in and fd_out refer to the
-- 
2.55.0

