Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94A7C37CD5A;
	Tue, 14 Jul 2026 12:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784031710; cv=none; b=XOsynH+55nFSReS5z5gEY2kA8GeGAopdRb20lAa7o6rdDEYuVnDV5+XB2GcHrF2w39Oj0hl2topeY5+fz8KLB0LRWiGcK8H3bmd1YJyw9xAria+9geUPnmSRL+N/za0mqDhUYn2MpNTOLVrQHRfyTEXGYsvqbzt0zuNEB4Uilbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784031710; c=relaxed/simple;
	bh=WETq6X5lcDIM/HgqLsarLoGh3NjI/Mvisg2rCiWss10=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ez9CfufAzBWdzVAfczNDR9Qd0zSQqCjxnvkV0pT1v9EM+REzNWehelJ4RsnHMdOT5t5d2shGJPywnzyV3wc8x0zp0m6uUVOBnIXDVNYbMEk/JjZV283OclRA4IBcyj3Z/Yc7TY1N+iI5wwKvYD/PJiOWZ9RfORTuOVUn6trk5Fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=h/tvlkAe; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="h/tvlkAe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784031704; x=1815567704;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=WETq6X5lcDIM/HgqLsarLoGh3NjI/Mvisg2rCiWss10=;
  b=h/tvlkAexaFJRYAXKVaIhPyjmmspE4+a0klgWZ7o71XjBcYoDRvaDnpR
   o4kXg9ManD7KosUU+JZFCZ1Ezcxs13PNvTrwhHkH8cID/FhkVde0IN2pI
   O+H3IEbn6KWvD6IVyyWsz4CUpkm+Av3Rjwg7IynnNxv6NirCEztk4DvIP
   2+EeOgrAoyLjJhUVDp/oUy+fULy10lxa8I1VIup4T3X4GVXBKZRYdGmZT
   6jIazqthch7CxH2sPupIak0O4sbJs7PbNna8+pr7ZQHt2nmcDTKMFB+JM
   Bn20kbDJmyQXEKqd7FTilsEvXP9XpjEjGlty8rB04wLQUyR3iRwPA4tfI
   A==;
X-CSE-ConnectionGUID: h2OYYN1XQweMrgu7k+PDvA==
X-CSE-MsgGUID: uwWqVpoVR5OiyzE43UxAwQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11846"; a="88551103"
X-IronPort-AV: E=Sophos;i="6.25,163,1779174000"; 
   d="scan'208";a="88551103"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 05:21:38 -0700
X-CSE-ConnectionGUID: 61vnQfHaTy2EnXsVlkv21g==
X-CSE-MsgGUID: m5FCnM3aQOSzykVHo7WHDw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,163,1779174000"; 
   d="scan'208";a="252455959"
Received: from black.igk.intel.com ([10.91.253.5])
  by fmviesa007.fm.intel.com with ESMTP; 14 Jul 2026 05:21:35 -0700
Received: by black.igk.intel.com (Postfix, from userid 1003)
	id 8A77495; Tue, 14 Jul 2026 14:21:34 +0200 (CEST)
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Steve French <stfrench@microsoft.com>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Youling Tang <tangyouling@kylinos.cn>,
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
Subject: [PATCH v1 1/1] smb/client: Use EXPORT_SYMBOL_IF_KUNIT() to export symbols
Date: Tue, 14 Jul 2026 14:21:20 +0200
Message-ID: <20260714122120.743185-1-andriy.shevchenko@linux.intel.com>
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
 fs/smb/client/smb1maperror.c      | 24 ++++++++++++------------
 fs/smb/client/smb1maperror_test.c |  1 +
 2 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/fs/smb/client/smb1maperror.c b/fs/smb/client/smb1maperror.c
index 74530088d17d..ab3d09613c91 100644
--- a/fs/smb/client/smb1maperror.c
+++ b/fs/smb/client/smb1maperror.c
@@ -10,6 +10,9 @@
  */
 
 #include <linux/bsearch.h>
+
+#include <kunit/visibility.h>
+
 #include "cifsproto.h"
 #include "smb1proto.h"
 #include "smberr.h"
@@ -239,48 +242,45 @@ int __init smb1_init_maperror(void)
 }
 
 #if IS_ENABLED(CONFIG_SMB1_KUNIT_TESTS)
-#define EXPORT_SYMBOL_FOR_SMB_TEST(sym) \
-	EXPORT_SYMBOL_FOR_MODULES(sym, "smb1maperror_test")
-
 const struct ntstatus_to_dos_err *
 search_ntstatus_to_dos_map_test(__u32 ntstatus)
 {
 	return search_ntstatus_to_dos_map(ntstatus);
 }
-EXPORT_SYMBOL_FOR_SMB_TEST(search_ntstatus_to_dos_map_test);
+EXPORT_SYMBOL_IF_KUNIT(search_ntstatus_to_dos_map_test);
 
 const struct ntstatus_to_dos_err *
 ntstatus_to_dos_map_test = ntstatus_to_dos_map;
-EXPORT_SYMBOL_FOR_SMB_TEST(ntstatus_to_dos_map_test);
+EXPORT_SYMBOL_IF_KUNIT(ntstatus_to_dos_map_test);
 
 unsigned int ntstatus_to_dos_num = ARRAY_SIZE(ntstatus_to_dos_map);
-EXPORT_SYMBOL_FOR_SMB_TEST(ntstatus_to_dos_num);
+EXPORT_SYMBOL_IF_KUNIT(ntstatus_to_dos_num);
 
 const struct smb_to_posix_error *
 search_mapping_table_ERRDOS_test(__u16 smb_err)
 {
 	return search_mapping_table_ERRDOS(smb_err);
 }
-EXPORT_SYMBOL_FOR_SMB_TEST(search_mapping_table_ERRDOS_test);
+EXPORT_SYMBOL_IF_KUNIT(search_mapping_table_ERRDOS_test);
 
 const struct smb_to_posix_error *
 mapping_table_ERRDOS_test = mapping_table_ERRDOS;
-EXPORT_SYMBOL_FOR_SMB_TEST(mapping_table_ERRDOS_test);
+EXPORT_SYMBOL_IF_KUNIT(mapping_table_ERRDOS_test);
 
 unsigned int mapping_table_ERRDOS_num = ARRAY_SIZE(mapping_table_ERRDOS);
-EXPORT_SYMBOL_FOR_SMB_TEST(mapping_table_ERRDOS_num);
+EXPORT_SYMBOL_IF_KUNIT(mapping_table_ERRDOS_num);
 
 const struct smb_to_posix_error *
 search_mapping_table_ERRSRV_test(__u16 smb_err)
 {
 	return search_mapping_table_ERRSRV(smb_err);
 }
-EXPORT_SYMBOL_FOR_SMB_TEST(search_mapping_table_ERRSRV_test);
+EXPORT_SYMBOL_IF_KUNIT(search_mapping_table_ERRSRV_test);
 
 const struct smb_to_posix_error *
 mapping_table_ERRSRV_test = mapping_table_ERRSRV;
-EXPORT_SYMBOL_FOR_SMB_TEST(mapping_table_ERRSRV_test);
+EXPORT_SYMBOL_IF_KUNIT(mapping_table_ERRSRV_test);
 
 unsigned int mapping_table_ERRSRV_num = ARRAY_SIZE(mapping_table_ERRSRV);
-EXPORT_SYMBOL_FOR_SMB_TEST(mapping_table_ERRSRV_num);
+EXPORT_SYMBOL_IF_KUNIT(mapping_table_ERRSRV_num);
 #endif
diff --git a/fs/smb/client/smb1maperror_test.c b/fs/smb/client/smb1maperror_test.c
index 2caaf11228ef..903c46f71291 100644
--- a/fs/smb/client/smb1maperror_test.c
+++ b/fs/smb/client/smb1maperror_test.c
@@ -75,3 +75,4 @@ kunit_test_suite(maperror_suite);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("KUnit tests of SMB1 maperror");
+MODULE_IMPORT_NS("EXPORTED_FOR_KUNIT_TESTING");
-- 
2.50.1

