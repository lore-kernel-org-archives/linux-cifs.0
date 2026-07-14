Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E31C547CC62;
	Tue, 14 Jul 2026 13:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784037385; cv=none; b=dImkKtuqGNX6JXoaGXVlfABDMXo0eENOo7uQhIsCqMRKFdpL6/sq1sNRDqtMuqBt21jmdNi79YpyjFaAxb7hnArmmRXIGodHNpYVk3m4D3giT2NkA3L/lv2AcLXKB7lHrc9NiqnitdqoaAjwhcSdwavL8GC7wyk5FMjsjNCDkjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784037385; c=relaxed/simple;
	bh=om/w7HQV14DBYIXfENOO4B4llTdy7HWrzBI2stUDaok=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mopZfjM8RH2WqmgTmTP7ANvy8aYxVT+6iuQU0H/cyEpvli+5B3TRRoz4nVujla0kfsao36zCxHT3YIDKo+p6a2xrAP6gUZu1NM/Ndn2s4++Bihd+mmnrs2d37zvVbCiA0t0MWz200twR2O22hvF+pAdnl6e4gYx5AzeQ0mb8i2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XNFxHzXT; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XNFxHzXT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784037383; x=1815573383;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=om/w7HQV14DBYIXfENOO4B4llTdy7HWrzBI2stUDaok=;
  b=XNFxHzXTsaJqK+oNCDNxUVmKFaNXguTje14HQxeqZBjf2WJ4pbclKMsg
   aUIyoW7XYMvqTNjEDB2gwaSiTAnRdGfRS4Riib4noACsRCPyvMc0ERQU6
   n/Zh5UJT40LHCXzoqja/YjQ1P7JlbG+4BGwRox/lRtG+7FWU1zfZdbvdH
   kAc94JJwl5vcTPa0a/h9SgLwd0oXR2uM/PWLV45rcVSyatsIMJjcO/NFj
   bzKtpjVQkqRuyd0y8LQOIHGNYKKXJBBCvkEcNoI8TfzINS2DUeDs7yOkm
   AeNOp7W/x4dVNZUP8rikiU7Zx+6ER4Ivobh8Oyscva/oZD8+7HHtSq3Jn
   w==;
X-CSE-ConnectionGUID: XORyfRv1QySkeZE+xIb3sw==
X-CSE-MsgGUID: VUa80uvdSXOM4T1gJrUOAQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11846"; a="84778114"
X-IronPort-AV: E=Sophos;i="6.25,163,1779174000"; 
   d="scan'208";a="84778114"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 06:56:22 -0700
X-CSE-ConnectionGUID: /69Cx/VtQOWQCpKmDCILRQ==
X-CSE-MsgGUID: ZkbcAox+TA26NawVQiqfoQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,163,1779174000"; 
   d="scan'208";a="279139903"
Received: from black.igk.intel.com ([10.91.253.5])
  by fmviesa002.fm.intel.com with ESMTP; 14 Jul 2026 06:56:19 -0700
Received: by black.igk.intel.com (Postfix, from userid 1003)
	id 4F53195; Tue, 14 Jul 2026 15:56:18 +0200 (CEST)
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Steve French <stfrench@microsoft.com>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	David Howells <dhowells@redhat.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org
Cc: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 1/1] smb/client: Use EXPORT_SYMBOL_IF_KUNIT() to export symbols in SMB2
Date: Tue, 14 Jul 2026 15:53:33 +0200
Message-ID: <20260714135333.813314-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace EXPORT_SYMBOL_FOR_MODULES() with EXPORT_SYMBOL_IF_KUNIT()
to mark the symbols as visible only if CONFIG_KUNIT is enabled.

Kunit test should import the namespace EXPORTED_FOR_KUNIT_TESTING to
use these marked symbols. This is the standard way for all KUnit
tests.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 fs/smb/client/smb2maperror.c      | 12 ++++++------
 fs/smb/client/smb2maperror_test.c |  1 +
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/smb/client/smb2maperror.c b/fs/smb/client/smb2maperror.c
index 9ed21f7b618c..d86f2460d0e5 100644
--- a/fs/smb/client/smb2maperror.c
+++ b/fs/smb/client/smb2maperror.c
@@ -8,6 +8,9 @@
  *
  */
 #include <linux/errno.h>
+
+#include <kunit/visibility.h>
+
 #include "cifsproto.h"
 #include "cifs_debug.h"
 #include "smb2proto.h"
@@ -109,18 +112,15 @@ int __init smb2_init_maperror(void)
 }
 
 #if IS_ENABLED(CONFIG_SMB_KUNIT_TESTS)
-#define EXPORT_SYMBOL_FOR_SMB_TEST(sym) \
-	EXPORT_SYMBOL_FOR_MODULES(sym, "smb2maperror_test")
-
 const struct status_to_posix_error *smb2_get_err_map_test(__u32 smb2_status)
 {
 	return smb2_get_err_map(smb2_status);
 }
-EXPORT_SYMBOL_FOR_SMB_TEST(smb2_get_err_map_test);
+EXPORT_SYMBOL_IF_KUNIT(smb2_get_err_map_test);
 
 const struct status_to_posix_error *smb2_error_map_table_test = smb2_error_map_table;
-EXPORT_SYMBOL_FOR_SMB_TEST(smb2_error_map_table_test);
+EXPORT_SYMBOL_IF_KUNIT(smb2_error_map_table_test);
 
 unsigned int smb2_error_map_num = ARRAY_SIZE(smb2_error_map_table);
-EXPORT_SYMBOL_FOR_SMB_TEST(smb2_error_map_num);
+EXPORT_SYMBOL_IF_KUNIT(smb2_error_map_num);
 #endif
diff --git a/fs/smb/client/smb2maperror_test.c b/fs/smb/client/smb2maperror_test.c
index 0f8a44a5ed3c..44dc5e899cad 100644
--- a/fs/smb/client/smb2maperror_test.c
+++ b/fs/smb/client/smb2maperror_test.c
@@ -47,3 +47,4 @@ kunit_test_suite(maperror_suite);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("KUnit tests of SMB2 maperror");
+MODULE_IMPORT_NS("EXPORTED_FOR_KUNIT_TESTING");
-- 
2.50.1

