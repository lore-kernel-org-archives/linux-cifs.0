Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57FF53793D2
	for <linux-cifs@vger.kernel.org>; Mon,  9 Feb 2026 14:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770646031; cv=none; b=CVvjcz+P0sWgii+r1HbjoV0srfvcOXMjVtaYoDyMdOkOcE7Sn8lDGnIvmgJGBVNx3lE8opUz+gfr7JSLcsL3YKVSkutj4v9m/Rp/NtRbEvM+EQ+6gZUDHEin2yU196lHBFq06IfCcaA0mP66xIS00DO9BOG0J9fNNyGp1iJPFcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770646031; c=relaxed/simple;
	bh=YqlpWlIJWLHTbb8gjuCR/IN8dvg2+dwdZ5xGjaHRIoM=;
	h=From:To:cc:Subject:MIME-Version:Content-Type:Date:Message-ID; b=QKVqNl95OWgmDGeUjueLyNyDipZrP5cDynbRHzhvyM2CSYwpNHbbmNb8lVLIpCVLfTYFj48Q93ZMqW8da7Le0J7IA8skx6YRKBj/aY4ooywkzSNQ+pHU8FGl8p44YPyrxgiZywLf7gNuL2MsMF5wMXkvKwBm2caJ0HG5i4RnvCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aBqWv0tm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aBqWv0tm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770646030;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=ShgYHnUHzVImIG0VNIVElVlpxwTlCo3Cf+e7W6aSNAM=;
	b=aBqWv0tmVTjEPJsNIPBANa70TFKjWqxGg5KA0qIsU7/V1liVubef7YpHgnnBeAJuSNuWF5
	QhPH1N53ZIW61vib8XMAF+ehdXG+mHyYi0FCuqgmciw97/ADwPDQ8RVdt44OT2feShPSr9
	vRnGZ3JGUOWB7p0+mXYut8S7ATwX+ho=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-592-a_gpDn1lPfmC8gyUbvIlww-1; Mon,
 09 Feb 2026 09:07:08 -0500
X-MC-Unique: a_gpDn1lPfmC8gyUbvIlww-1
X-Mimecast-MFC-AGG-ID: a_gpDn1lPfmC8gyUbvIlww_1770646027
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C324F1956094;
	Mon,  9 Feb 2026 14:07:07 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.44.34.84])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B4D991955F43;
	Mon,  9 Feb 2026 14:07:06 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: Steve French <sfrench@samba.org>
cc: dhowells@redhat.com, linux-cifs@vger.kernel.org
Subject: [PATCH] cifs: Fix the copyright banner on smb1maperror.c
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <98352.1770646025.1@warthog.procyon.org.uk>
Date: Mon, 09 Feb 2026 14:07:05 +0000
Message-ID: <98353.1770646025@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

    
Fix the copyright banner on smb1maperror.c to be the same as netmisc.c.

Signed-off-by: David Howells <dhowells@redhat.com>
---
 fs/smb/client/smb1maperror.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/smb/client/smb1maperror.c b/fs/smb/client/smb1maperror.c
index 1565f249452d..268ed40144f5 100644
--- a/fs/smb/client/smb1maperror.c
+++ b/fs/smb/client/smb1maperror.c
@@ -1,12 +1,11 @@
-/* smb1maperror.c: description
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
  *
- * Copyright (C) 2025 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
+ *   Copyright (c) International Business Machines  Corp., 2002,2008
+ *   Author(s): Steve French (sfrench@us.ibm.com)
  *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public Licence
- * as published by the Free Software Foundation; either version
- * 2 of the Licence, or (at your option) any later version.
+ *   Error mapping routines from Samba libsmb/errormap.c
+ *   Copyright (C) Andrew Tridgell 2001
  */
 
 #include "cifsproto.h"

