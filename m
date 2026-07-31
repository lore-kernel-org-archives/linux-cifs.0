Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECDAD26B2DA
	for <linux-cifs@vger.kernel.org>; Fri, 31 Jul 2026 15:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785512116; cv=none; b=PZ2+Dpx64IdL8gsAZqDJ6zAb5Pn2EvpWj6Sw7Wk3Kbxec99RcmH3yQmRDTB0WkHE8rRAEH+IVZrzSJzJH2cwTX6ZNSsNQ0DWWgTHxMe4QkEF3YejBQhpE1237CvIqh9DyqBDixyvATc0+HFzPkGVENargnSTryrAaAqH0Ezemjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785512116; c=relaxed/simple;
	bh=PrIYxaIjeSIfZGATwL+hT1m/U/38RI6VsPzZu/UHOe0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AVKUaiGM8zNllDzA4AFifKVvWui86C93NYynk80JZMCz9tDvXkRcVKjNMUGQye5eH3jIkIHkrG0thVaLPb7zX5f0L3koG9p+I5pZ3rGlW4MF5C/CiXlCljV4nByScKUoYlhnjENWAbWo3Jm5mQP0WDZlszVbcOrbQoCdByHySRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J44DQf2F; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=MPFfzb2e; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J44DQf2F";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="MPFfzb2e"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785512113;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K/1+Ln1YUj2ng59ac5LMXS6/wpF2Y0PC7HkSNpnhTQE=;
	b=J44DQf2F3wSuBEt3gx/pX/Yk/1QI3cyhwFdPTc+iwEG3io9E5JX0Y5ynqYDWp998Ai3n6i
	GU8t81KI6D7ocjrsIPFGnU1CzKLlOl9FHag/1uY5RqvGxWtaJDI6tSdIt6TgeSjzpMT97y
	k4ZGu9YniwmSSEtSq2iH2EHlPbgEXMA=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-191-x0jolQNaN6WBwnDIym9tLg-1; Fri, 31 Jul 2026 11:35:12 -0400
X-MC-Unique: x0jolQNaN6WBwnDIym9tLg-1
X-Mimecast-MFC-AGG-ID: x0jolQNaN6WBwnDIym9tLg_1785512112
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-495b8b30310so1482031b6e.1
        for <linux-cifs@vger.kernel.org>; Fri, 31 Jul 2026 08:35:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1785512111; x=1786116911; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=K/1+Ln1YUj2ng59ac5LMXS6/wpF2Y0PC7HkSNpnhTQE=;
        b=MPFfzb2eiGTGEc+sHzMLahaYYJCA82eW0X2EBwCxpHhcARCo2qD/YcAPOMC5Zqxq1d
         eSy7Bcvf5NmJ2NIvCJg4KYOBz3ooOpqF97zMIJJynKoXB6k2VZlNUtF0q5Lyl5tTYB8c
         vWzv+va3nUQMJD6xu2ypHCiiEwPN0iRBmCMzbjm8L/5Vo6uCboxLGDEcATkgpDHY0nFh
         36mrrj+B+1uQmzlYK0aDUyvGH1/X+qq44v2+lJ62VX47Gim7/BWhpU+SeytSp6wOETjP
         OEIdhatVpxJe/tXz/HWPKjMedVS9E96DJy3XJZMdy50nlbI16QY2zDshUKZRXuH5Yeze
         7f6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785512111; x=1786116911;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=K/1+Ln1YUj2ng59ac5LMXS6/wpF2Y0PC7HkSNpnhTQE=;
        b=ehChLL5HJIE7373e/pbA3SzTS4KEuz80sexEiLZLWrKTyPryPtLV2q1bJYXFaIWInp
         6NltKD3wGM84qmsAof5ECzhLfhPtsZHLCyAqXw0xc8ccZB4RQBit3Y96WkjfRekkGIGl
         JLZNlbfiWAFIl/NF04l9dzEuLLpcjHZkodreA50p3+oQ9VrJG0NpAOfLPMg+pwE9xksJ
         HMZa9P3d+/ikEBtdUgmcUN2CzR+dX5AeAqFfBY2SvzDpZEPBESB0OKIoKhUa8jPXQsAp
         yexb+KGp+cqR9wv4/o6wOvVj6lUx9k50bLMfA9HYNGYuBVjuLjgqA7PzcqACi9UK1+PS
         DrZg==
X-Gm-Message-State: AOJu0YwQJfVJ2cmbNd3zIG6vRGe8gNOBUA7gAfyqQWKWpjTk2xddB/dh
	EAFNuDlqB4fAUswaS5cg7AJyFVZLdJeI3hflhbT47ry+BdVJHRWjGelkW6CeqGbMd0yRbopvp4+
	JchIbQ69m5r6NRmF6UnK6SaEdsl21JhJO2qsAberejm2SxodeLE4r+G3qsNWeAkF80z5yyrzuai
	q7sopdO4g3zR3tnaUJI6TYf8vWpRAXBrTDyPo7oWRrpIwnY2w=
X-Gm-Gg: AR+sD11smeWLypVxRFtP/1xMespzBGWRAoM4pW3gLmmVgMHdMHDa/Cv1qaejVXnuVCJ
	6UFFZYBexLMMszEJorjXK+6tqcaXbat0d1d3/YtSRly/X7buFbsGylwWHSa1Rnzg1XoqHOVJPPu
	SAEmqCakYnFm1+3CNkBLWqr41bBrRoMxQTyc96viEA6GqrftR8EouM9AcClR7D0ALF1Wfr8au1/
	uoT1EQkqDFLxA6ToyJIeABuyjgqyTDWTatYTu/tEen152pnlydDAOtFz/eoRx4VpRXvtBGuGd5A
	LfJy7Ig1q8tIokr9YhXp66oDuExoXK+HmDor39W+Aof3LbgAH9UM0Rf2kI354TrbFdYeCDl/ui5
	W1k9Mc0pukqIgjhrvuqHsQI0B9SBdIIoOzhG0RGDeORGpqjd1cjR1I1wjceGO
X-Received: by 2002:a05:6808:1c09:b0:4a3:d66b:240b with SMTP id 5614622812f47-4af5e38ac08mr632525b6e.18.1785512111527;
        Fri, 31 Jul 2026 08:35:11 -0700 (PDT)
X-Received: by 2002:a05:6808:1c09:b0:4a3:d66b:240b with SMTP id 5614622812f47-4af5e38ac08mr632446b6e.18.1785512110883;
        Fri, 31 Jul 2026 08:35:10 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4af58ce144esm855813b6e.1.2026.07.31.08.35.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 08:35:09 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org,
	pc@manguebit.org,
	stfrench@microsoft.com,
	hehuiwen@kylinos.cn
Subject: [PATCH v2 3/4] cifs: remove redundant size-update block in cifs_remap_file_range()
Date: Fri, 31 Jul 2026 10:34:59 -0500
Message-ID: <20260731153500.660569-4-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260731153500.660569-1-sorenson@redhat.com>
References: <20260731153500.660569-1-sorenson@redhat.com>
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
Reviewed-by: Huiwen He <hehuiwen@kylinos.cn>
Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
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

