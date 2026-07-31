Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1850544CAC2
	for <linux-cifs@vger.kernel.org>; Fri, 31 Jul 2026 17:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785518032; cv=none; b=HwYOWM7vxc1lLGyEHE7CdOXUJALMxMCtWb9ZwwqCXc9jhYhFR+UNYfR5UELIbdmqd6lRZgEpUR1epK7+cpsxJYqZD0I5DB/mHuizPmO3W5VJPnZzHco9KB9tgBZDxF0unLKpgmM2SEoxh/Uj5OexLUT0gjfH57grctx4+kcsfw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785518032; c=relaxed/simple;
	bh=PrIYxaIjeSIfZGATwL+hT1m/U/38RI6VsPzZu/UHOe0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jmd6dRQmTt8KNqsgvnaaclN1qW3mwrCJNMEE2o9k8SbVejmSyvxtj/0qsCMH88/jZH+koJ+1M7m96FUtGYdSeMEXh4RpZ0+CW+kzbtXmx4vlPQa09JzfFUKWNVPwV4Kb/FRT+Sy9gEnL77T+VC2DkAoqvCG3if2UvsEU9kY+Lyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OCI87seZ; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=VIA40K3D; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OCI87seZ";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="VIA40K3D"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785518029;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K/1+Ln1YUj2ng59ac5LMXS6/wpF2Y0PC7HkSNpnhTQE=;
	b=OCI87seZMY3vef67BLrl7pE7TXJasK5Gw5HqeJKi2lnTQTYXfIKdoi/D9qfBB+BNK7qem4
	zOpzaCzbseaaVauKwF/H3W5XCJf2t7ZLqv2VARedDXY4sDdYo4gyM3td5DRF74bnMWETFA
	VNyviM80LNFLZ2GTOlcGRwHw8YJ5+Ag=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-600-vur4HXTzPCiIc-qmZRlP7w-1; Fri, 31 Jul 2026 13:13:48 -0400
X-MC-Unique: vur4HXTzPCiIc-qmZRlP7w-1
X-Mimecast-MFC-AGG-ID: vur4HXTzPCiIc-qmZRlP7w_1785518028
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-8eeba1d9e47so13479796d6.2
        for <linux-cifs@vger.kernel.org>; Fri, 31 Jul 2026 10:13:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1785518028; x=1786122828; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=K/1+Ln1YUj2ng59ac5LMXS6/wpF2Y0PC7HkSNpnhTQE=;
        b=VIA40K3D1gs11Es44y3DEVc/ZxS8joMAo7CWb30v2C8Kwgs6uTQN3mQ5LKWGvSDHfk
         k86NrIW0mvs50wodMZD5W8LAPdZZGTlu+TlKpv/24eU9Z0Sb1tu1gHEG4DdpDUfc+Adf
         rxujNz+K2wYaYik6RFDAWP7kWeWHyW616vzEUBFTGQxQjULLq6IVpN1KSsGXVSsMsTMZ
         FouWr2Gh8oxEV7BvBsuSj89CB++Uxt1jr6RVwtFg6G2einPO4tfzznUN3W5PwajF+vto
         92IHKoZq/YyaDiZywhgKvSFexrI7CggIm+YMbe2ev7UNJTiJsPbtNN1aol7iCcCnrlVW
         mG5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785518028; x=1786122828;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=K/1+Ln1YUj2ng59ac5LMXS6/wpF2Y0PC7HkSNpnhTQE=;
        b=OhAnobxNQcbf/gk9wQ0GV1FjvTpdPntwHHkn3d6zSMA0RFffCMssmeGfVHkgcwrHNA
         +MV/D0dItCQrhzcUP/xSNQcIYyuuY6wiOGS5uuaeqEcJrEOL8Vd+A+GDXBgVtVMyhN2G
         V/aUuE1FWsVi668sFQrDjdlH/c6tPmCNcxQy+BiPfKEPbBeTuxL1bRKRwsoBNmjWWMzR
         xHLRBOCO+dLRCTza8O9ZfSCcpTtgMFjEbyx4Ba1O96/x0VBub5fYsObUJP4c5bytXpEA
         5bAaz1Wk9AdOjBsVdegtdjKp+jbHYoKpeSLnBGM5H2G2M04hsW6iJS1lFvubFFn/2V9w
         LujA==
X-Gm-Message-State: AOJu0YzY/+jP4jvtgZi/11zDUwPd5EieFbXpotoE0Tnzs2EiiLOy+xQ3
	iZQG45hbw15pifXEcpJxXF3K7tT1nQdFMWZhfmdHghDO0J/GA1eGX/Y673Xo8Cb3BsYmil1ZC5m
	cGX6qNF84l2r0t1b0FALZ/KTJI3ZsnSUtKtlpmLPUPhK97Bx2fpV1uNaeMNIzpYJP4d4FY06VFp
	49GmH1TbNNyPawkVxWIsb2P3fReea7zoVQdPVVcTu5/d4HHu8=
X-Gm-Gg: AR+sD11CfLxvO2JxU33r7OkgACUVTpt3WUyibf2sCpjNb+n6OdFUc/Pz+PGtbiZNae6
	nCYsrpq37ixwhpTkE0nuw3iWPmgrLxfN97HZb0NdDXJ6/gY6ixv4gIg6A2bbNdDO834bQ51md96
	0E+gJyzJ6ewLGZRua1s0ms3Brqo9HYg0BNmFam5dUCTkS4o/lMnm1deY5UMK7dXnfkFeac22u68
	6hQTEOsktMilXXiQuAkhc53X/gmpcUg1OITrmRRts/umkt0iOSm9AZvzQxvILMgU8VjqbWeHicX
	DK3AZJEWvVCkx6hOIIxr/Q+3lsrzTg03vC9AQhZp/4VeHCnb4VxiO7/+7td6ittu8Y5U1YYYsV/
	RDVC2dJfBHL5jjGP6jkZ5Ow9gVItVOhQDkNksj4SqjF+ApjyYlz+3eGkKf7sv
X-Received: by 2002:a05:6214:448a:b0:8f1:440c:7f81 with SMTP id 6a1803df08f44-90849553685mr15073976d6.4.1785518027761;
        Fri, 31 Jul 2026 10:13:47 -0700 (PDT)
X-Received: by 2002:a05:6214:448a:b0:8f1:440c:7f81 with SMTP id 6a1803df08f44-90849553685mr15072936d6.4.1785518026992;
        Fri, 31 Jul 2026 10:13:46 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-908434a250csm14676316d6.13.2026.07.31.10.13.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 10:13:34 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org,
	pc@manguebit.org,
	stfrench@microsoft.com,
	hehuiwen@kylinos.cn
Subject: [PATCH v3 3/4] cifs: remove redundant size-update block in cifs_remap_file_range()
Date: Fri, 31 Jul 2026 12:12:30 -0500
Message-ID: <20260731171231.686427-4-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260731171231.686427-1-sorenson@redhat.com>
References: <20260731171231.686427-1-sorenson@redhat.com>
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

