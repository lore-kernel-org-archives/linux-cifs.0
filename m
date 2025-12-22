Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B260313535
	for <linux-cifs@vger.kernel.org>; Mon, 22 Dec 2025 22:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766442628; cv=none; b=txgLu5QqbwWzUQapG4mAxxjXSfOmYxnzorTwlP7Qz+lXQKwveosSy+qdPiycxIaG8sJx2tt17yFkmzuPvvwnKc9PlKp2Ne9Z9OtE0cT0ZN7loRs4zHrevRkwDn0PcV23WB/tlPkX6It9uCrPdQtYmCswGWTnJzwfVKubKb0Zshg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766442628; c=relaxed/simple;
	bh=B5B1UpVLxfIVT8FXHwNiuCVnkKxhHweN84i+Ja0mBUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zfb87YLKLD4iOgxhggxXZoYwbjqxfwjLR34tdJMSAooOy3muD2yMsmRDuCwtQaCvvAUv5rJ/dfXUYiBMmYyXQgoyqPnxrskfHvBC58UthyIP4j1ua8d1/FsqxxjRBQnupi6wAF6u+H3EgEbnowewEMWwQLuKOg1KzzO6edx4Ia0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hPGeymTu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hPGeymTu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766442626;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Azyu375a0PbyVqSBelYOYqj6n7XdILlIQ8dFfw/FECA=;
	b=hPGeymTuU8RarS8Bl/lKwgGtx6g1MfT4O865gFzfQfO19eMOry36Y9EmCL6vnL/TcdG9BB
	eK5wkLHeoQlfevDO3sgO/v/YbsdXYZIscvISQO2Ebw52N+7gvxbTT1aWlGKvsfYm2CySM9
	wF63TokxP0WcMRLgbnzjLTYacldXlok=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-359-5FZmNPOnOX2YEZpQI3yqtQ-1; Mon,
 22 Dec 2025 17:30:19 -0500
X-MC-Unique: 5FZmNPOnOX2YEZpQI3yqtQ-1
X-Mimecast-MFC-AGG-ID: 5FZmNPOnOX2YEZpQI3yqtQ_1766442618
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 84E581956096;
	Mon, 22 Dec 2025 22:30:18 +0000 (UTC)
Received: from warthog.procyon.org.uk.com (unknown [10.42.28.4])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 994481800670;
	Mon, 22 Dec 2025 22:30:16 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Steve French <sfrench@samba.org>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Enzo Matsumiya <ematsumiya@suse.de>,
	linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 02/37] cifs: Scripted clean up fs/smb/client/dfs.h
Date: Mon, 22 Dec 2025 22:29:27 +0000
Message-ID: <20251222223006.1075635-3-dhowells@redhat.com>
In-Reply-To: <20251222223006.1075635-1-dhowells@redhat.com>
References: <20251222223006.1075635-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Remove externs, correct argument names and reformat declarations.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <sfrench@samba.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Enzo Matsumiya <ematsumiya@suse.de>
cc: linux-cifs@vger.kernel.org
cc: linux-fsdevel@vger.kernel.org
cc: linux-kernel@vger.kernel.org
---
 fs/smb/client/dfs.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/dfs.h b/fs/smb/client/dfs.h
index e60f0a24a8a1..6b5b5ca0f55c 100644
--- a/fs/smb/client/dfs.h
+++ b/fs/smb/client/dfs.h
@@ -151,7 +151,8 @@ static inline void ref_walk_mark_end(struct dfs_ref_walk *rw)
 	ref->tit = ERR_PTR(-ENOENT); /* end marker */
 }
 
-int dfs_parse_target_referral(const char *full_path, const struct dfs_info3_param *ref,
+int dfs_parse_target_referral(const char *full_path,
+			      const struct dfs_info3_param *ref,
 			      struct smb3_fs_context *ctx);
 int dfs_mount_share(struct cifs_mount_ctx *mnt_ctx);
 

