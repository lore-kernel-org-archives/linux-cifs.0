Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10FB43093C7
	for <linux-cifs@vger.kernel.org>; Mon, 22 Dec 2025 22:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766442633; cv=none; b=ltx+ILvMmB0RVxTy9601OPpvZdtWmg77F+sWHbzv67xIONsMfZ6xRvCVAuj1vBYyg+bhcnMR5mYHuQZ8pkCUe03njagh6f9idbzRNyRaxFLbLJsc6vRG2d4xR3e/r8yi+1XCatSNDFdOKrx9jsUk1J7PjRgkAjbBSpue9x9fyv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766442633; c=relaxed/simple;
	bh=WUHmRUnzqNPwEhuk1TuFL7+GybFR3BK5bT0LH/vyASk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t0yiQSFOxbrX2bU2j9DT74wPeyCS9JcD9103h9d+uxIXZGquoIPM9saVChNmR+ynxFk2d0q3Jjg6KLOL6Fc5eiSkDYEIFZDqE63JkwQJkaVh8FLl/TprDJtQURWF6sdA3pkxhaowQVjD1XlHak/h1gK206zEi+/GpcoENsVZCUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iFm9Gzy8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iFm9Gzy8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766442630;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O8+H9Ob/mTH0hxN19qOue5SWqY4tfGh4uckSGOp+AJQ=;
	b=iFm9Gzy81AZdOiDqVxRF5UM2ehnSEIsiCEbf8jLtQ4AZvFgtei2ZqPNSs/3fF75UzSpChk
	qcPXsR/cXDDJsrzgP2UUu0B7w/6oRybCnMKKs3NHutA52vi9g/7s+lgeG7/kogaZSP6gwl
	HO6cNR0nwsKOV9N7+JENi7p9MlSD/7s=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-628-tEqXTdK-MaKRIP7-tS2QxA-1; Mon,
 22 Dec 2025 17:30:29 -0500
X-MC-Unique: tEqXTdK-MaKRIP7-tS2QxA-1
X-Mimecast-MFC-AGG-ID: tEqXTdK-MaKRIP7-tS2QxA_1766442628
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 376BF1955F11;
	Mon, 22 Dec 2025 22:30:28 +0000 (UTC)
Received: from warthog.procyon.org.uk.com (unknown [10.42.28.4])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6D9A019560B4;
	Mon, 22 Dec 2025 22:30:26 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Steve French <sfrench@samba.org>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Enzo Matsumiya <ematsumiya@suse.de>,
	linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 05/37] cifs: Scripted clean up fs/smb/client/netlink.h
Date: Mon, 22 Dec 2025 22:29:30 +0000
Message-ID: <20251222223006.1075635-6-dhowells@redhat.com>
In-Reply-To: <20251222223006.1075635-1-dhowells@redhat.com>
References: <20251222223006.1075635-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Remove externs, correct argument names and reformat declarations.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <sfrench@samba.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Enzo Matsumiya <ematsumiya@suse.de>
cc: linux-cifs@vger.kernel.org
cc: linux-fsdevel@vger.kernel.org
cc: linux-kernel@vger.kernel.org
---
 fs/smb/client/netlink.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/netlink.h b/fs/smb/client/netlink.h
index e2fa8ed24c54..d35eef981b6b 100644
--- a/fs/smb/client/netlink.h
+++ b/fs/smb/client/netlink.h
@@ -10,7 +10,7 @@
 
 extern struct genl_family cifs_genl_family;
 
-extern int cifs_genl_init(void);
-extern void cifs_genl_exit(void);
+int cifs_genl_init(void);
+void cifs_genl_exit(void);
 
 #endif /* _CIFS_NETLINK_H */

