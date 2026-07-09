Received: from pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.1.125])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 778EE38C2BF;
	Thu,  9 Jul 2026 15:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.246.1.125
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783612502; cv=none; b=rH7pCaGKZNYYcSRojPR6K3xpFyBTUUWjcUkwpo548z+C1NKYQP+vN3GSk/eiaHaleN4ojm4a80TW9ykyaAZjFajzVjprX/t1uBTDVPbMTEV6Lxc2m45GcplRHW63cDalm0hWesftcukSa0aNpIbHf9gnbQ13uVg+DblO2HboE2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783612502; c=relaxed/simple;
	bh=LuXv6JcJjK6mtDWtLr8zqHDrPXzE0ewOu1aVcFSDNUs=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=DvBQ3FL0ul7hK83zJ2kP08RZNIs9+JyLSmFmFsE8wSny0h6wzoKd2cpadgPFKhdcfbYHHMYDNV0TO1wAnnRCUWCfzeIjwXXKityXBJhgebkUekT79iiAG7xlRMlr+ql9s+ZZihueXc6tanZXM+1r1kkAH/xm+fkafB8s+zx6ULA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=IHemkVMZ; arc=none smtp.client-ip=44.246.1.125
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="IHemkVMZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1783612501; x=1815148501;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=MS2Fs/jSRohnT1IecYb4b1QrfzuXtM/vLFmi4bLUDYI=;
  b=IHemkVMZ2wSqo1S45ViVESRsdVkkeetkA8hg75kfmdlpLWwm+2HNNwQ1
   bhAQrjocc2RRktTWb8Gc2qCHoxyeK/pMIESOrlfQf7cZMs8xFAyvs5PP/
   dLHFnR2TGCgB90C0Ij6OKTCY3LKB4JypMGCDFHM9L0ijWZKWe2CX1wnb+
   uDmfV9Nypr4u/qcE7+XDhAUn6NQJi1VmWZfkxstJ+PWbln/h2Ev5Y1KP5
   vs1pud3SWFd/0/9ti3drRAouCVMFphMWi6LoXjEsC/Bk8cf0LpXPtikMV
   6TjOnstheHKVnrTaRZJ06eiQtxN53Ade9oIrbTgrcLIoZT6kJiRSkPNvf
   A==;
X-CSE-ConnectionGUID: 3hANjMELRxCK6Tt71+VChA==
X-CSE-MsgGUID: zdHCjPkdQo2DRaNdJAMVuQ==
X-IronPort-AV: E=Sophos;i="6.25,154,1779148800"; 
   d="scan'208";a="23385286"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2026 15:54:58 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.111:14009]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.31.54:2525] with esmtp (Farcaster)
 id 9e9060b9-9ea4-43a9-8ca2-b1243e68b4ea; Thu, 9 Jul 2026 15:54:58 +0000 (UTC)
X-Farcaster-Flow-ID: 9e9060b9-9ea4-43a9-8ca2-b1243e68b4ea
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Thu, 9 Jul 2026 15:54:58 +0000
Received: from dev-dsk-doebel-1a-7b355d76.us-east-1.amazon.com (10.169.119.5)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Thu, 9 Jul 2026 15:54:56 +0000
From: Bjoern Doebel <doebel@amazon.de>
To: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N
	<sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, Bharath SM
	<bharathsm@microsoft.com>, <linux-cifs@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <samba-technical@lists.samba.org>
CC: <stable@vger.kernel.org>, <doebel@amazon.de>, <nmanthey@amazon.de>
Subject: [PATCH] smb: client: fix DACL-rewrite heap overflow in id_mode_to_cifs_acl()
Date: Thu, 9 Jul 2026 15:54:38 +0000
Message-ID: <20260709155440.2132459-1-doebel@amazon.de>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D033UWA002.ant.amazon.com (10.13.139.10) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Budget the destination buffer for the worst case in both branches:
every rewritten ACE may take sizeof(struct smb_ace) bytes (which
already accounts for an smb_sid with SID_MAX_SUB_AUTHORITIES
sub-authorities), plus the smb_acl header that
replace_sids_and_copy_aces() emits.

Fixes: bc3e9dd9d104 ("cifs: Change SIDs in ACEs while transferring file ownership.")
Cc: stable@vger.kernel.org
Signed-off-by: Bjoern Doebel <doebel@amazon.de>
Assisted-by: Kiro:claude-opus-4.6
---
 fs/smb/client/cifsacl.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/cifsacl.c b/fs/smb/client/cifsacl.c
index 07cf0e5782337..6d572dd995d79 100644
--- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
@@ -1812,11 +1812,13 @@ id_mode_to_cifs_acl(struct inode *inode, const char *path, __u64 *pnmode,
 				cifs_put_tlink(tlink);
 				return rc;
 			}
-			if (mode_from_sid)
-				nsecdesclen +=
-					le16_to_cpu(dacl_ptr->num_aces) * sizeof(struct smb_ace);
-			else /* cifsacl */
-				nsecdesclen += le16_to_cpu(dacl_ptr->size);
+			/*
+			 * Worst case: every ACE is rewritten with a new SID of
+			 * SID_MAX_SUB_AUTHORITIES sub-auths -> sizeof(smb_ace) each,
+			 * plus the smb_acl header replace_sids_and_copy_aces() emits.
+			 */
+			nsecdesclen += sizeof(struct smb_acl) +
+				le16_to_cpu(dacl_ptr->num_aces) * sizeof(struct smb_ace);
 		}
 	}
 
-- 
2.50.1

