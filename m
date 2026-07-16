Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D042D400976;
	Thu, 16 Jul 2026 10:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784197105; cv=none; b=EUS4QKInZ7UkGJvckLK0Oc2fh4t+ll10BI/aYE3uqdVRmkyD9uItTtbL9aa7OFKwi+fkxshDgBnqPYjDKVg3dn5fF9tHtSSbR6I/uxBm7hzTv18zr0Beq6A3x+35SEHvc7kavx0M5x+Go2KZRxvilDDo4zjNZzCsMI0imWErZ0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784197105; c=relaxed/simple;
	bh=ET1B/IGhtKwJtR0g4KZezEBXMG2qeTV2YEsJEHEapUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ISnJsHITAEGPLiuefiJXWeAD/2ltSDLrUrP4fQdx5t/Uabv12CVa+NMMyZgCnXiTGxUui8QB1/P18VasddDnQLW/wFQWsOFRUUZsArJX1SSm5l0oPkbQReszQatdLBXklo4Nw8PJnikqrQV5RlzcHRSwJXZOpXRXZ1YpiquQ8wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SV3JGMme; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SV3JGMme"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DA761F00A3A;
	Thu, 16 Jul 2026 10:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784197103;
	bh=ZyeUBWyh7dnZQfFIxVwXy7TXU4RzGh6PBTnWYyat4ds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SV3JGMmebHAI4f98/DomWDbALlkpalo9BhLiCanLwzyTz1WW4TF9b4l/AAsA6qu6g
	 yvMjxEdQ/vYcFCB5vbttAJt+x87YLME2DmHXx1BvNH9ysQtPjrWO1vxouM3Qqdp3B6
	 yambPuyeM4r8ZXnr6CdgHGe7mdJ3v+HMBTZTA4jWyL+8skzpvoIKY3246/cfE2m1dW
	 1j+MJYf6KoNA0WM8g6wRwGvAeqv2j2PvHHuIynNqqHuq4Fw8W9yyucgz6dgW5lCIDZ
	 zlbijc3ffFBYwuSBW9XACdkwSjtYLYA5gS73Zf+ebsaXNM+ZliDDiy97gvpZRIT13S
	 OwV47SgBUBCZQ==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Enzo Matsumiya <ematsumiya@suse.de>,
	linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18.y 2/3] cifs: SMB1 split: Add some #includes
Date: Thu, 16 Jul 2026 06:18:18 -0400
Message-ID: <20260716101819.1461638-2-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260716101819.1461638-1-sashal@kernel.org>
References: <2026071403-ferris-hydroxide-5531@gregkh>
 <20260716101819.1461638-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Howells <dhowells@redhat.com>

[ Upstream commit a7c7f35bcf0943ba85ab14bafbfbcbc3a30ad402 ]

Add some #includes to make sure things continue to compile as splitting
occurs.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <sfrench@samba.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Enzo Matsumiya <ematsumiya@suse.de>
cc: linux-cifs@vger.kernel.org
cc: linux-fsdevel@vger.kernel.org
cc: linux-kernel@vger.kernel.org
Acked-by: Enzo Matsumiya <ematsumiya@suse.de>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: c6394bcaf254 ("ksmbd: use opener credentials for FSCTL mutations")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifssmb.c       | 5 +++--
 fs/smb/client/smb1transport.c | 4 ++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index bfc9b1ea76fac9..7694ca283fdc38 100644
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
index e98b95eff8c983..518f764dedcce6 100644
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
-- 
2.53.0

