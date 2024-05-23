Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C7431D545;
	Thu, 23 May 2024 13:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470729; cv=none; b=J2+xE3LrUG8nBVb7yqmATGBpj8M6/dCLpx0eu42au5hwZihcFXai4NNHmhkZymD/sVEbF4pm+SZ4tAmyY/db8Pcz8cC6w8fhA0TF03AXoJp/zFRieCSK1xCsqNWJQNEkNus8wsHxwJsb6wpOPiibKNGyV8In1de9Y/iA8YB5qEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470729; c=relaxed/simple;
	bh=Ss9CPhF93q5yItXdI02jU9lHvW7OMFO4/kS+Bt74Rhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BuibMNPQWnrdHHlaf2QXYnz+BYnE/8ilM3sib8xjQijyo1goEJX488gQ9anP/6d1VTYU+bYcah0BEjpLQzns/FEkT9mmDQJT38nGqwcoZXIuHGiIXFjns+Z/z+ts76Y7dUzH5hqaY34r5OODDKzVCjpy/8+UUE51D6oVCI4SAKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g5d1QWdm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g5d1QWdm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7B99C32781;
	Thu, 23 May 2024 13:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470729;
	bh=Ss9CPhF93q5yItXdI02jU9lHvW7OMFO4/kS+Bt74Rhc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g5d1QWdmrLT742Yc3lsezjopgL6XGVnEkpUykw+lsfsfTHKINeW7lL2HiMygt8UkN
	 fZ2lIVfxdpQSQjozDI/aKltPNKPEJ9q6ejKxp2NRDZz8Pcf/4WiheeezHfzSNIYTRy
	 wmAb3RoaLcG7adAn3KEN/gUcgsX5FdBBVPQSAHcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	linux-cifs@vger.kernel.org,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 068/102] cifs: Move some extern decls from .c files to .h
Date: Thu, 23 May 2024 15:13:33 +0200
Message-ID: <20240523130345.034131795@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130342.462912131@linuxfoundation.org>
References: <20240523130342.462912131@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve French <stfrench@microsoft.com>

[ Upstream commit 5b142b37c70b1fa6936fa2d0babb0b8c16767d3a ]

Move the following:

        extern mempool_t *cifs_sm_req_poolp;
        extern mempool_t *cifs_req_poolp;
        extern mempool_t *cifs_mid_poolp;
        extern bool disable_legacy_dialects;

from various .c files to cifsglob.h.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: linux-cifs@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsfs.c   | 4 ----
 fs/smb/client/cifsglob.h | 2 ++
 fs/smb/client/connect.c  | 3 ---
 fs/smb/client/misc.c     | 3 ---
 4 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index 30bf754c9fc93..539ac9774de1b 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -150,10 +150,6 @@ MODULE_PARM_DESC(disable_legacy_dialects, "To improve security it may be "
 				  "vers=1.0 (CIFS/SMB1) and vers=2.0 are weaker"
 				  " and less secure. Default: n/N/0");
 
-extern mempool_t *cifs_sm_req_poolp;
-extern mempool_t *cifs_req_poolp;
-extern mempool_t *cifs_mid_poolp;
-
 struct workqueue_struct	*cifsiod_wq;
 struct workqueue_struct	*decrypt_wq;
 struct workqueue_struct	*fileinfo_put_wq;
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 70a12584375de..9597887280ff3 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -2112,6 +2112,8 @@ extern struct workqueue_struct *deferredclose_wq;
 extern struct workqueue_struct *serverclose_wq;
 extern __u32 cifs_lock_secret;
 
+extern mempool_t *cifs_sm_req_poolp;
+extern mempool_t *cifs_req_poolp;
 extern mempool_t *cifs_mid_poolp;
 
 /* Operations for different SMB versions */
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 5acfd2057ca04..4e35970681bf0 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -52,9 +52,6 @@
 #include "fs_context.h"
 #include "cifs_swn.h"
 
-extern mempool_t *cifs_req_poolp;
-extern bool disable_legacy_dialects;
-
 /* FIXME: should these be tunable? */
 #define TLINK_ERROR_EXPIRE	(1 * HZ)
 #define TLINK_IDLE_EXPIRE	(600 * HZ)
diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index 669d27b4d414a..ad44f8d66b377 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -27,9 +27,6 @@
 #include "fs_context.h"
 #include "cached_dir.h"
 
-extern mempool_t *cifs_sm_req_poolp;
-extern mempool_t *cifs_req_poolp;
-
 /* The xid serves as a useful identifier for each incoming vfs request,
    in a similar way to the mid which is useful to track each sent smb,
    and CurrentXid can also provide a running counter (although it
-- 
2.43.0



