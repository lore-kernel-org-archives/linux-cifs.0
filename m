Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E24834C121
	for <linux-cifs@vger.kernel.org>; Mon, 22 Dec 2025 22:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766442697; cv=none; b=MggtB3J4HUcXqiEQqpIngPxNPCuZ3Hxxm8M+8Ecl+9c+PW3IBdoeeTMpfPm2fdxfYOvhFT2oM30+KGexBXT3XGu+Wo4O6l5ThLQjDuWK+mrkZ5fao67RxfpyP+aTwzJ2cMYj01FmXkzLoIua856+6K95bOJqkXB68WF8gevmDC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766442697; c=relaxed/simple;
	bh=qHI2DbH4p7GyRLt7+5myQhsP3bAY6T7Mo7O1MROE/K8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s5nS4oPkcIiNaZBKQKT9ZrrPjgEHVOCtykVjnpUgNFBFcHQYgL0MGzjoCp+ihJYJuwpxr1MHZ39gTOQ+cmNE7ZBNm0PQuFK+dUsPv7cCCljrZ5PRMhBBWnGnsjOIfsBcnyZxdK/p9ZnsdiB5w6FKScWdZRl2cKXNEY/OX+OnQ68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ij3M27YI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ij3M27YI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766442691;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ohCfhX1WSW+PabWqdY+fYfa+YrfsfjqgCQXwla5DBMQ=;
	b=ij3M27YIkMH10PusTBF4K+7ecdGQHB1e/bvSh6VARSMb5iCdTlyXiAzqv0EVJ0Oxc7y4D0
	g/T6Ni35bleYAFQha0q+gl1rKQ3FQ5d97+hfgs5+Z6I2zien2eTzKlntyGfVdRNYNnTDVV
	yskGfihnI5/H8nV9pqVVuHBe75Rp9gE=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-183-phE16nPhNPqYjF1CSqXPxA-1; Mon,
 22 Dec 2025 17:31:27 -0500
X-MC-Unique: phE16nPhNPqYjF1CSqXPxA-1
X-Mimecast-MFC-AGG-ID: phE16nPhNPqYjF1CSqXPxA_1766442686
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6F0E5180035A;
	Mon, 22 Dec 2025 22:31:26 +0000 (UTC)
Received: from warthog.procyon.org.uk.com (unknown [10.42.28.4])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B358F1955F16;
	Mon, 22 Dec 2025 22:31:24 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Steve French <sfrench@samba.org>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Enzo Matsumiya <ematsumiya@suse.de>,
	linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 24/37] cifs: SMB1 split: Add some #includes
Date: Mon, 22 Dec 2025 22:29:49 +0000
Message-ID: <20251222223006.1075635-25-dhowells@redhat.com>
In-Reply-To: <20251222223006.1075635-1-dhowells@redhat.com>
References: <20251222223006.1075635-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Add some #includes to make sure things continue to compile as splitting
occurs.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <sfrench@samba.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Enzo Matsumiya <ematsumiya@suse.de>
cc: linux-cifs@vger.kernel.org
cc: linux-fsdevel@vger.kernel.org
cc: linux-kernel@vger.kernel.org
---
 fs/smb/client/cifssmb.c       | 5 +++--
 fs/smb/client/smb1transport.c | 4 ++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index 3db1a892c526..478dddc902a3 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -26,11 +26,12 @@
 #include <linux/uaccess.h>
 #include <linux/netfs.h>
 #include <trace/events/netfs.h>
+#include "cifsglob.h"
+#include "cifsproto.h"
+#include "../common/smbfsctl.h"
 #include "cifspdu.h"
 #include "cifsfs.h"
-#include "cifsglob.h"
 #include "cifsacl.h"
-#include "cifsproto.h"
 #include "cifs_unicode.h"
 #include "cifs_debug.h"
 #include "fscache.h"
diff --git a/fs/smb/client/smb1transport.c b/fs/smb/client/smb1transport.c
index 5e508b2c661f..7154522c471c 100644
--- a/fs/smb/client/smb1transport.c
+++ b/fs/smb/client/smb1transport.c
@@ -22,13 +22,13 @@
 #include <linux/mempool.h>
 #include <linux/sched/signal.h>
 #include <linux/task_io_accounting_ops.h>
-#include "cifspdu.h"
 #include "cifsglob.h"
 #include "cifsproto.h"
-#include "cifs_debug.h"
+#include "cifspdu.h"
 #include "smb2proto.h"
 #include "smbdirect.h"
 #include "compress.h"
+#include "cifs_debug.h"
 
 /* Max number of iovectors we can use off the stack when sending requests. */
 #define CIFS_MAX_IOV_SIZE 8

