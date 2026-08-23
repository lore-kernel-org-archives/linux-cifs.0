Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76D0430DEBA
	for <linux-cifs@vger.kernel.org>; Sun, 23 Aug 2026 23:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787527636; cv=none; b=bjed8a9sRF/zkQ++TZ4ZG2t2KN28H81bGoRwnZDFEQK3xicZwRsO54Ke7JDE9fMDQywWRa62St9YaFVz6VsyGjf9fyP2+Qc9hCocv98qrYXz1OYR+MQEtci1LuFgGMVJqoXpvaXBrhTw3Vd6s8DXaufemuIoyj0G0XV+F5bQkKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787527636; c=relaxed/simple;
	bh=HrsyjT1Ek1X1mbUhCltTnuu1jNp5aT6vFuyQ+8cV1+o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bHs7+LBCu4PjtiFwvF017raZLMWg3b4CENxaakxHXgpOaJ1pvvwo9JFaeXUlRwI+i3RnyWROAdJnHC2Z3oAczCWXeiFSTsMAUp7tyoXeeVxvqR4gq/WJ3GRXGLrZm4huzYOpTozXTF2fLyk8wXUqdLggwVvIjWpGQfjlCqZARmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N96QiPbk; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ipKUIaFL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N96QiPbk";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ipKUIaFL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787527634;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=l+jSiflMXrTCTdSE4t4LfuleogagVvtvuwLtqzZj8u4=;
	b=N96QiPbk7xApevdlm4Xu74V816oXC8rhUkhxHlN3l+OxdWoW/4KnSym5doaVdEV8t0kd0e
	FpeuK4kMr3gX2+AGAZPR+xpvr2JqJSdhriHUltvXoFVeDG/9ZoQrRbPo5YNeN/w+iAPzwg
	XoSAaOmU0KtXSn1aS8V0ybMUZBgCbkQ=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-610-54swjLttPhuA9e91tlC40Q-1; Sun, 23 Aug 2026 19:27:11 -0400
X-MC-Unique: 54swjLttPhuA9e91tlC40Q-1
X-Mimecast-MFC-AGG-ID: 54swjLttPhuA9e91tlC40Q_1787527631
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-48e5de5a23cso5398092b6e.0
        for <linux-cifs@vger.kernel.org>; Sun, 23 Aug 2026 16:27:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1787527631; x=1788132431; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=l+jSiflMXrTCTdSE4t4LfuleogagVvtvuwLtqzZj8u4=;
        b=ipKUIaFLkvliOLBEN1g3g/Xw/KdmNJp4Xg4aPYELb8n8btMmdKg3oBq39jzwM7N1sa
         DAMlmkn44dDRFTKI1wZ0S624ZBTj6SnwsmtFDZLUyUh3/mlW9Ogydz6hTd44ehpj/+u0
         4jZuclyhVW9j0Riw+vCqFu597ZMeoKZCSdqrIgNhijE6g9TyvSJMfjw6IiGxUvGNHwS3
         3cO9pogkxDddYxau30zkBtWUj6EfmAVz7GL/3QG3d93u9jpjErPKcZ/PKtLcVAtJSwxX
         1Brsej4fQrct0TZRigllXQFjZr4mNjk4WxLkkL5XJ0TPYYF3jHRIVTLh0xmzfLPhAW1b
         1pew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787527631; x=1788132431;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=l+jSiflMXrTCTdSE4t4LfuleogagVvtvuwLtqzZj8u4=;
        b=aT529oiCrKDOHes4rhKVZlxRYl6YX0ooDO/QEvEFGrll69VOP3uv9W1ukRYim8br5O
         rY//2kaU2Xm7w8BoTlKpummEQP1ZMM5gqsoIfo3SDMRpUaBUZ8WKFhwPbjg2sU+W2mfD
         0nY5icjlUZWXIitx2WvyNYh96cyiZpq6fzI1DWS7UV6LXcPYHyTg8+XDFnVeyVl4Fd/h
         BtzrwtOWc9KynPBJFdOf+bllHCm1AR1ww7MNI9X7orptVlAGS9M2GDxITSlUIMJrblYE
         tJAiyDN3FluXUdm2Sl6/8B7juscI0aI1xRPhKWkmGWDW3wWvDx8hQ/14DLQU/cTeQjdi
         1gdw==
X-Gm-Message-State: AFuF++l5T+Dvr8Aujt2zi9cTJkMvXeCFF2RlfDRaHcW234gd4CumdH+i
	VEBhia6JTEsPEtb+uUKp9F2+iabhHhetQLJDwVpbvfn1v4vO1OZyrgitu/0VRK+qQll1hZCJKhd
	2y2U9dRYv50NtX9S5Uf7uoY3xQrjn3A6Uqeq+7SnRiTnczyaRP3gcMBQN5no9/tyzbpw70yRBmt
	YU0dLrWe9N7+y5dQnl6aMW9nR9/qG680IfjD1cksih+fW76f4=
X-Gm-Gg: AR+sD13b157kn3QD/v0yiNunMwhV+szVIxweGNjXvz6UPLERZ9H3Wt0qYCYCubFrO2K
	h8RQNDnu521J8TZG4GPhw8PcBDQRRseakQSkFcQjyAcogjUCZp+htqNlxGNKdKBHRHVxbjYIJuE
	1RjxgF1miuQCbaaxJjCKuyL2jTrt6w9ySFfprshp3bClDymRZpEJO90H9xIyZdyDk1yPrb8nhTw
	jufe0QS4SkYWvnK/Vp7SUqYdm+Vo7NIaph0siUusDGkfL9eQIhSofCsojYEd2/SgPwl0xHXLR0s
	DdlbqIpTnBZwd4CbBwrf636VKPenRPxJ9enPLZxBhbdaakOmVH1IFXhm0TY4wC56UMVvDuAiIvm
	uff4pQ2w1wW/jFlC1X63UXXVXA7SAGEBgg6S31zStYVTx1+Aev4/i61aA47VDElOwTw==
X-Received: by 2002:a05:6808:1b0c:b0:48a:ddd4:d36f with SMTP id 5614622812f47-4b2ef33a8d5mr21956178b6e.8.1787527630981;
        Sun, 23 Aug 2026 16:27:10 -0700 (PDT)
X-Received: by 2002:a05:6808:1b0c:b0:48a:ddd4:d36f with SMTP id 5614622812f47-4b2ef33a8d5mr21956147b6e.8.1787527630487;
        Sun, 23 Aug 2026 16:27:10 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4b32c835f6asm2039478b6e.9.2026.08.23.16.27.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Aug 2026 16:27:09 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org
Cc: pc@manguebit.org,
	linkinjeon@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] cifs: add revalidation on FSCTL failure in smb2_duplicate_extents()
Date: Sun, 23 Aug 2026 18:26:46 -0500
Message-ID: <20260823232646.3170915-1-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

smb2_duplicate_extents() has no handling for
FSCTL_DUPLICATE_EXTENTS_TO_FILE failure: when the FSCTL fails, local
inode metadata may be stale from the pre-extension or from concurrent
remote writes, but is never refreshed.

Force revalidation on FSCTL failure and use i_size_read() for the
pre-extension check.

Fixes: cfc63fc8126a ("smb3: fix cached file size problems in duplicate extents (reflink)")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 fs/smb/client/smb2ops.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 7d6738ffcb80..bea4876b58cb 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2218,7 +2218,7 @@ smb2_duplicate_extents(const unsigned int xid,
 			       trgtfile->fid.volatile_fid, tcon->tid,
 			       tcon->ses->Suid, src_off, dest_off, len);
 	inode = d_inode(trgtfile->dentry);
-	if (inode->i_size < dest_off + len) {
+	if (i_size_read(inode) < dest_off + len) {
 		rc = smb2_set_file_size(xid, tcon, trgtfile, dest_off + len, false);
 		if (rc)
 			goto duplicate_extents_out;
@@ -2235,7 +2235,10 @@ smb2_duplicate_extents(const unsigned int xid,
 	if (ret_data_len > 0)
 		cifs_dbg(FYI, "Non-zero response length in duplicate extents\n");
 
-	if (rc == 0) {
+	if (rc) {
+		CIFS_I(inode)->time = 0; /* force reval */
+		cifs_invalidate_cache(inode, 0);
+	} else {
 		qrc = SMB2_query_info(xid, tcon, trgtfile->fid.persistent_fid,
 				      trgtfile->fid.volatile_fid, &file_inf);
 		spin_lock(&inode->i_lock);
-- 
2.55.0

