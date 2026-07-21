Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D2BC46F4BB;
	Tue, 21 Jul 2026 18:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659511; cv=none; b=UTgmQjQLdHMdPNXBeeSfpvUwF7/a3pb9ZUEmphKSCFddA553dvATdpsuMyhTBvviGxHJHYc99ciRkzEd/EoXmQOThZcvaujRviO0e10LlTTmENT1qENSMx2Z712vbybKARYs5lZYoZFFiZlimWwcW/DtGpoEp0/8hA3lp++wqC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659511; c=relaxed/simple;
	bh=YFvHZfegm0S5MlJVyu7YwQMAfEtAHqDf4dUTpMC7A/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FC1MWgaYCCLwK8G6+paMe/NkzmpPJ0yD0n2vaWIKshNuBDiVyOXSUbKBgJSit9czUoBI8/5tiRCAmqGOuTM/Hrduq3mRizNlqap5RppGr6VRVJic84ulmjdKTNdPowb9SQBMXBzGw5n47MHGh2OpWAzJ8h6wa9TTuAfLiYaE2hM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=INkcmYhW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="INkcmYhW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABDAB1F000E9;
	Tue, 21 Jul 2026 18:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659510;
	bh=6EZXdE5ljtOoqJc2oCMML7wXLTd/5uEHUOI+79VPClw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=INkcmYhWdL7+cTsSkgT0NFyg82MwlzDDSFv02tXLsitq0kZG0/gqDlWMsdMfrgoSs
	 Wg+oKRec+s1Vlf7euF+g2pKvkGQtu5vLNi/LeH5y/IKZwIpv2Yxz7aUIAsiqdZ5Jq2
	 CDpyPs4ZsVQiWFvPRCsZIEunvbVm8Kg5P4eE2eYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Enzo Matsumiya <ematsumiya@suse.de>,
	linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1548/1611] cifs: SMB1 split: Add some #includes
Date: Tue, 21 Jul 2026 17:27:44 +0200
Message-ID: <20260721152550.272673447@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifssmb.c       |    5 +++--
 fs/smb/client/smb1transport.c |    4 ++--
 2 files changed, 5 insertions(+), 4 deletions(-)

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


