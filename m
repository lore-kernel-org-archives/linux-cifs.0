Received: from pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.13.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1392A46EF96;
	Fri,  4 Sep 2026 12:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.13.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788526746; cv=none; b=g0TdJ4sbXt0gmeSQo3z1VbWTkuNrNRmB0StguPiyNggVtztXIwBbBjNXLqmfbK0zfiEegvTfDUk41uQGq0oLXHJJfGT9X5/7K+EjJuqrEyPjzgAT6C7UoI/TubO+NgrUr62qDmZ9Tkrs/8uk9I/7bJU+wBlaFCdmLUFsBmejN3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788526746; c=relaxed/simple;
	bh=DctcXNf5Pmkk/c2UdOxWD3NJedxFDlOqNCUViTaW1ac=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VFG2WwGzS3v4RRsr+eN5qdbvFKPZAK1b+Wj5JeQKYDza2nAsoBFG9gSlx0Pqa+Z6pQlok1P1fwzgQv20EpCdRbTc8vR6Gl4NPO5AGFNBsLddoxNi26e9qS7UG4YtiSrsyQMHaRS+5jWWhXExo/fcjOyeSx1V3gicb1sGSN5c3Rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=DDG8jFZX; arc=none smtp.client-ip=52.13.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="DDG8jFZX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1788526745; x=1820062745;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QHzSWCKMcOOUYdTHBekDQVAYh1JT4WzAm68Nz07osSM=;
  b=DDG8jFZXYzd1LGV5XAQYiQJPVTiCD4n2+toSsiaRv//cIvNjdkYHwc9m
   1tj8wrRTrOPT8Gh9aOPWKSmcBlSUjUS8gNCpv7Bmwi5/uzZFdIx6aFLdc
   ZIXlYmsDZqc56fGPbYO5b6IHLjA+mwvyZ5VM9OMLsxe2z1uR9ypv74v6w
   Mw2K5KboBWs5nQaypZQ30GSQhVZ8QaDlIdgforvDVmBFzRuEFQr3lTJsp
   qyXPmmAL3fDxHOxYsDPyvFTva5dt2kf4+e4Oafs5DAfLRcCF7uUarmtJj
   JUnvutPuaOPcsXa5ptkrCjydVnOAqLK9cz/X1NcPvtO5vcGALEcO2KeK4
   g==;
X-CSE-ConnectionGUID: ivWzBOLjRquzuV9Z8gak8g==
X-CSE-MsgGUID: 2UfDtSzvQUarJqVZWMFQUA==
X-IronPort-AV: E=Sophos;i="6.25,262,1779148800"; 
   d="scan'208";a="27796398"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2026 12:59:01 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.234:6055]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.18.218:2525] with esmtp (Farcaster)
 id 1a0df765-551a-4efc-b82f-eaf41a7e019a; Fri, 4 Sep 2026 12:59:01 +0000 (UTC)
X-Farcaster-Flow-ID: 1a0df765-551a-4efc-b82f-eaf41a7e019a
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Fri, 4 Sep 2026 12:59:01 +0000
Received: from dev-dsk-doebel-1a-7b355d76.us-east-1.amazon.com (10.169.119.5)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.46;
 Fri, 4 Sep 2026 12:59:00 +0000
From: Bjoern Doebel <doebel@amazon.de>
To: <linux-cifs@vger.kernel.org>
CC: <pc@manguebit.org>, <linkinjeon@kernel.org>, <ronniesahlberg@gmail.com>,
	<sprasad@microsoft.com>, <tom@talpey.com>, <bharathsm@microsoft.com>,
	<samba-technical@lists.samba.org>, <stable@vger.kernel.org>,
	<doebel@amazon.de>
Subject: [PATCH] smb: client: fix heap overflow in DACL owner/group rewrite
Date: Fri, 4 Sep 2026 12:58:44 +0000
Message-ID: <20260904125844.1803343-1-doebel@amazon.de>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260709155440.2132459-1-doebel@amazon.de>
References: <20260709155440.2132459-1-doebel@amazon.de>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: EX19D040UWB004.ant.amazon.com (10.13.138.91) To
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
mounts—both paths can trigger the same rewrite and need the same
headroom.

KASAN reports this as:
  BUG: KASAN: slab-out-of-bounds in build_sec_desc+0x1e8a/0x2680 [cifs]
  Write of size 4 at addr ffff8881a5e25374 by task chown/5298
  ...
  The buggy address is located 0 bytes to the right of
   allocated 884-byte region [ffff8881a5e25000, ffff8881a5e25374)

Cc: stable@vger.kernel.org
Fixes: 5c3564852c58 ("cifs: Minimize the number of cifs_acl memory allocations")
Assisted-by: Kiro:claude-opus-4.6
Signed-off-by: Bjoern Doebel <doebel@amazon.de>

---
v2:
- Reword commit message to be more descriptive of what is happening
---
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

