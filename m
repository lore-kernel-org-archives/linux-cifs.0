Received: from pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com [34.218.115.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 041CF3672AE;
	Tue,  8 Sep 2026 16:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=34.218.115.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788883828; cv=none; b=BDsOHKeV5TniUaflHCX65GAj6nL76FmI+z8kCiSNOcrdcWQJEU+xtlfDEoKIF7Rcjo8MutfGDoEJ29OBEtb6FPVQXSndmqE20NhmQaDEYTyzkKaaU6xtGLiS3TsyrC1F3K70VXzCme7RE/nAMnE3koER021RR3Xn8kUSWCeh9wE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788883828; c=relaxed/simple;
	bh=ulHsZPVk4Xug/9TeH0VEjmkxyuf7yTw4hntQsOjrJRs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pRZGNRkD2RJGwKNfn79s3LqEe40B735xs/yaJ5kJ0vJR/JQw/ga6lqyD9LOs6m82zjfcgfID1SLySG+Z+NECcU+F9rBPl3HHEj/tZ2loZed2nDTpMVa3CxhhQlEhwMQOLt90MoO9ekWfrtWKSF0h8PKUbryU5rpGxzU4d5uZyi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=F1Qjbhzu; arc=none smtp.client-ip=34.218.115.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="F1Qjbhzu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1788883827; x=1820419827;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Q6JmwZQ+L+l67HY7DSdIwwiFGP1JO6OTz3DrApzvcSc=;
  b=F1Qjbhzusgft03OcUJdpDQ4O6GgRuBPnTHfavYIIo9sEAV15SZHOvdCj
   VPEfL1cqC2Hsmscv9s5TCkSGwDyPtZnSEnH4N0x5H5GA2RA27IEi+ulTw
   tgCilejOJwy8JOaYr57rxhkby7eUzEdPrfqNUGtliwDF0Obqb3nNl9cFH
   qLiWI025nh8OzId1cYVf2cLgS9DznxSBnYKM7xt7sMdV6zj2yfdJwElNr
   2cDn+6JVxGNzNMCHEmoiZfxHOq6GdB87sEwEGl+O3fwq7OwE7SBWp03aG
   4f5yO5AQZooxgA7AdWTTAlTtCNPngYCe1PlrUE11GEnDZMQjjlbsCjDBm
   g==;
X-CSE-ConnectionGUID: xo83F7RuSpCD26K+vNTRBg==
X-CSE-MsgGUID: KBG2O/kaRPed9Fj0jou2Bw==
X-IronPort-AV: E=Sophos;i="6.25,269,1779148800"; 
   d="scan'208";a="27918470"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2026 16:10:24 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.182:3798]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.15.196:2525] with esmtp (Farcaster)
 id 7b7d18fd-2771-4c19-9c37-9119889490af; Tue, 8 Sep 2026 16:10:24 +0000 (UTC)
X-Farcaster-Flow-ID: 7b7d18fd-2771-4c19-9c37-9119889490af
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.204) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Tue, 8 Sep 2026 16:10:24 +0000
Received: from dev-dsk-doebel-1a-7b355d76.us-east-1.amazon.com (10.169.119.5)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.46;
 Tue, 8 Sep 2026 16:10:23 +0000
From: Bjoern Doebel <doebel@amazon.de>
To: <linux-cifs@vger.kernel.org>
CC: <linkinjeon@kernel.org>, <pc@manguebit.com>, <stable@vger.kernel.org>,
	Bjoern Doebel <doebel@amazon.de>
Subject: [PATCH v3 1/2] smb: client: fix heap overflow in DACL owner/group rewrite
Date: Tue, 8 Sep 2026 16:10:00 +0000
Message-ID: <20260908161001.2603610-2-doebel@amazon.de>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260908161001.2603610-1-doebel@amazon.de>
References: <20260904125844.1803343-1-doebel@amazon.de>
 <20260908161001.2603610-1-doebel@amazon.de>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D033UWA004.ant.amazon.com (10.13.139.85) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

When id_mode_to_cifs_acl rewrites an existing DACL, it allocates a
buffer sized according to the on-disk DACL length reported by
dacl_ptr->size. However, replace_sids_and_copy_aces may rewrite each
ACE with a new owner/group SID obtained from the cifs.idmap upcall.
Those SIDs can have up to SID_MAX_SUB_AUTHORITIES (15) sub-authorities,
making each ACE up to 76 bytes (sizeof(struct smb_ace)).

If the original DACL contains short SIDs (e.g., 1 sub-authority) while
the replacement SIDs are long, the rewritten ACEs overflow the
allocation.

Fix this by always budgeting for worst-case SID expansion: allocate
sizeof(struct smb_acl) plus num_aces * sizeof(struct smb_ace), which
covers the smb_acl header and room for every ACE at maximum SID size.
This replaces the previous split logic that used dacl_ptr->size for
cifsacl mounts but num_aces * sizeof(struct smb_ace) for mode_from_sid
mounts: both paths can trigger the same rewrite and need the same
headroom.

KASAN reports this as:
  BUG: KASAN: slab-out-of-bounds in build_sec_desc+0x1e8a/0x2680 [cifs]
  Write of size 4 at addr ffff8881a5e25374 by task chown/5298
  ...
  The buggy address is located 0 bytes to the right of
   allocated 884-byte region [ffff8881a5e25000, ffff8881a5e25374)

Cc: stable@vger.kernel.org
Fixes: bc3e9dd9d104 ("cifs: Change SIDs in ACEs while transferring file ownership.")
Assisted-by: Kiro:claude-opus-4.6
Signed-off-by: Bjoern Doebel <doebel@amazon.de>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>

---
v3:
- Correct the Fixes: tag; the previous commit id did not exist
- Add Namjae Jeon's Reviewed-by
v2:
- Reword commit message to be more descriptive of what is happening
---
 fs/smb/client/cifsacl.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/cifsacl.c b/fs/smb/client/cifsacl.c
index 12005f46307de..2d785a3039585 100644
--- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
@@ -1815,11 +1815,13 @@ id_mode_to_cifs_acl(struct inode *inode, const char *path, __u64 *pnmode,
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

