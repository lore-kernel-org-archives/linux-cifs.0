Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EBD73E171C;
	Tue, 25 Aug 2026 08:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787646656; cv=none; b=naJQWmCoyxEcBQR+mhN+cDbJIoupfqYpVgFbZUPtabwjvFxmXzlGrjZF7vkUejZdMsieOD+1whqSTFe4cwrseBNXy8WTZwEUyE8KN1XK5ZR0KUOUz8Q2H/gP3zvu5P2veNKcIISsCPrthe8N2OUZ3BUAXneS+Ch6IpuX4elw4vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787646656; c=relaxed/simple;
	bh=u2fGCbhOYE4AOcgln312wvUk2txiBZMAagKaL6hDjcw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hpNCeBc7Jj21jSeKRq6AP+uPFymaoWODHIb5tPU/wD0itcJZ7VbppBvHYNvybq1zf/IiIo6Ss3A3Rlq41C0iywv400d2uV2Y8xWZjdhigTf6AtcBOVtO277N3y4NEgQbH6Nbldth/6eH6GQ2iEhXCAjskEtoGelmil9ymEEnyRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lbX3E2D5; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lbX3E2D5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787646654; x=1819182654;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=u2fGCbhOYE4AOcgln312wvUk2txiBZMAagKaL6hDjcw=;
  b=lbX3E2D5OyvRfHrOtAlmUBWBekPRkVT/tGIQ5170DOw+mwYsX6wsPpoC
   9c/jrMsLBKaBHRu/GRSGCUns0pebu4frm3XJ1r9OI9f2j+1sm08yKt58E
   EnRy+oAd2qXPMYHtTZXjhrtPp2NXFbJZ4QbBBKM1lfqtYdt8Gb8VnM33j
   CM73u27vNtV05i9vOMDYzzYWaVVee2FuQst714gNl7mgE+e5bRt24Knrs
   DCadxTLJDXFi5NSZJWWHwkWOjGIaF1AaPiW/FTvcqQRPJbPvnNwfGktLH
   bKW2buvKBs8XvsIUfkGgtQy4HwHH8iTH4vfGsccXINJbF4/HbhV5BKe3V
   w==;
X-CSE-ConnectionGUID: 1N7StKUxTE6YKHx7utT/Ww==
X-CSE-MsgGUID: Gs729jTuTuinq6f2vFq0eg==
X-IronPort-AV: E=McAfee;i="6800,10657,11885"; a="75643336"
X-IronPort-AV: E=Sophos;i="6.25,242,1779174000"; 
   d="scan'208";a="75643336"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2026 01:30:53 -0700
X-CSE-ConnectionGUID: ph/jpuTtRXWxRfYNSponkQ==
X-CSE-MsgGUID: 5haeeRpXRlytlvEromX3+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,242,1779174000"; 
   d="scan'208";a="271024859"
Received: from black.igk.intel.com ([10.91.253.5])
  by orviesa004.jf.intel.com with ESMTP; 25 Aug 2026 01:30:51 -0700
Received: by black.igk.intel.com (Postfix, from userid 1003)
	id ACF5699; Tue, 25 Aug 2026 10:30:49 +0200 (CEST)
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Steve French <stfrench@microsoft.com>,
	David Howells <dhowells@redhat.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org
Cc: Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 1/1] smb: client: transport: Fix debug printing in __release_mid()
Date: Tue, 25 Aug 2026 10:30:43 +0200
Message-ID: <20260825083043.4037868-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Long time ago during upgrading printk():s to the respective pr_<level>()
calls one misconversion happened and nobody has noticed that. So,
previously printk(KERN_DEBUG) + printk() worked as one long debug print
since the trailing '\n' is only present in the followup printk() format
string. The culprit change missed that and split the message to two on
the different levels. Restore the original behaviour to make users be
less confused in the most likely never happen cases of partially getting
that message.

Fixes: 0b456f04bcdf ("cifs: convert printk(LEVEL...) to pr_<level>")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 fs/smb/client/transport.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index fdf4e50c27ce..e266859818a4 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -101,12 +101,11 @@ void __release_mid(struct TCP_Server_Info *server, struct mid_q_entry *midEntry)
 		trace_smb3_slow_rsp(smb_cmd, midEntry->mid, midEntry->pid,
 			       midEntry->when_sent, midEntry->when_received);
 		if (cifsFYI & CIFS_TIMER) {
-			pr_debug("slow rsp: cmd %d mid %llu",
-				 midEntry->command, midEntry->mid);
-			cifs_info("A: 0x%lx S: 0x%lx R: 0x%lx\n",
-				  now - midEntry->when_alloc,
-				  now - midEntry->when_sent,
-				  now - midEntry->when_received);
+			pr_debug("slow rsp: cmd %d mid %llu A: 0x%lx S: 0x%lx R: 0x%lx\n",
+				 midEntry->command, midEntry->mid,
+				 now - midEntry->when_alloc,
+				 now - midEntry->when_sent,
+				 now - midEntry->when_received);
 		}
 	}
 #endif
-- 
2.50.1

