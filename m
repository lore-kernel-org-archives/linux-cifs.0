Received: from pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.35.192.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E157742DA3F;
	Thu,  9 Jul 2026 15:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.35.192.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783612504; cv=none; b=rkeqFw/b3rFU7tXZwC/j5m9Bytb5hFf+L5YwBjVuHvt03Y1/NX5dEwHNR0YjoilR901s5MoghP//3rWoNYDOzsI2Ch8YqSnNhP4iNFkIsKvVeRmlZ/b3XcYey+7MQx+KS9JkbGz+fBy6YlzC5r6dHM9WHOYvr7ODzgMds3zrnoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783612504; c=relaxed/simple;
	bh=2UY2hwRLYLB8e7f2GFLkUci/X38S6EIiBO8keiN69do=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Ag4B9feWmCcdt5Q/5rkXlWWGkHzHz51KB9AFyJ5jInWc4crw4b00XyInY6/4ahPtsk48GQpki5bFvz6MvnsEhBhkE9vP0UlNW1HgG5Av96yrUhm3OjNJsr2pYzpy7aHZTKV1SfihoBimbs65JC+Giq/PtPgUv1nhI7ws66zQnYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=jRjuQk4i; arc=none smtp.client-ip=52.35.192.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="jRjuQk4i"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1783612502; x=1815148502;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=vE946ASmE2lxBNc96IRvRBu3IlQiGEZOj0kMnret4Sc=;
  b=jRjuQk4iTprYMBXgmyBtS0qxUCEg4ZKzGNoPu+s4NPhFLxpL+bb1mqlt
   cs7SlaVNoeKtiby584u7Yv6J1d0ZF6XdIQDEQVhTFnr/TamdxmKTTDlpN
   gsaNgdXeWEmBsRUOdaxLxdBDo6lxXUJQ/Cm+9+3M3WOK6isU6cn+sHXeY
   Hk82icOG6xgNPZQ3Z2TPTzhILUCTNEOSQZjmifY9t/QSPqUoUhjNsx8e0
   6hHywuimhbun0v/f9Z0eYLI4MafG1zrSl+Bql5oxKTHUFXd5YD0fJMZnt
   lxhMx5G6QsUJEeWqAccs43wJaW3vtz0yLPUmHkucadOAtKnNBGFjwgQ/g
   w==;
X-CSE-ConnectionGUID: nDKJE0QKQxSZE7qfHZmrVA==
X-CSE-MsgGUID: KLHiNLcqRX6rcpT1ULBUwA==
X-IronPort-AV: E=Sophos;i="6.25,154,1779148800"; 
   d="scan'208";a="23149231"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2026 15:54:59 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.234:9716]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.11.68:2525] with esmtp (Farcaster)
 id eeb7f2e3-3e92-4c26-aca1-9580d5f33a8f; Thu, 9 Jul 2026 15:54:59 +0000 (UTC)
X-Farcaster-Flow-ID: eeb7f2e3-3e92-4c26-aca1-9580d5f33a8f
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Thu, 9 Jul 2026 15:54:59 +0000
Received: from dev-dsk-doebel-1a-7b355d76.us-east-1.amazon.com (10.169.119.5)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Thu, 9 Jul 2026 15:54:58 +0000
From: Bjoern Doebel <doebel@amazon.de>
To: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N
	<sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, Bharath SM
	<bharathsm@microsoft.com>, <linux-cifs@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <samba-technical@lists.samba.org>
CC: <stable@vger.kernel.org>, <doebel@amazon.de>, <nmanthey@amazon.de>
Subject: [PATCH] smb: client: mask server-provided mode to 07777 in modefromsid
Date: Thu, 9 Jul 2026 15:54:39 +0000
Message-ID: <20260709155440.2132459-2-doebel@amazon.de>
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

From: Norbert Manthey <nmanthey@amazon.de>

When modefromsid is active, parse_dacl() applies the server-provided
sub_auth[2] value from the NFS mode SID to cf_mode without masking to
07777. Apply the correct masking, same as in the read path.

Fixes: e2f8fbfb8d09c ("cifs: get mode bits from special sid on stat")
Signed-off-by: Norbert Manthey <nmanthey@amazon.de>
Assisted-by: Kiro:claude-opus-4.6
Cc: stable@vger.kernel.org
---
 fs/smb/client/cifsacl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/cifsacl.c b/fs/smb/client/cifsacl.c
index 6d572dd995d79..a0a68404fbff7 100644
--- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
@@ -962,7 +962,7 @@ static void parse_dacl(struct smb_acl *pdacl, char *end_of_acl,
 				 */
 				fattr->cf_mode &= ~07777;
 				fattr->cf_mode |=
-					le32_to_cpu(ppace[i]->sid.sub_auth[2]);
+					le32_to_cpu(ppace[i]->sid.sub_auth[2]) & 07777;
 				break;
 			} else {
 				if (compare_sids(&(ppace[i]->sid), pownersid) == 0) {
-- 
2.50.1

