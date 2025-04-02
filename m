Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 440DE1F1317;
	Wed,  2 Apr 2025 20:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743625687; cv=none; b=kkcPaBQFqRsv+NUQ29h9Ku1o9TYE3O4y6cwgUbglNt0ZT20GlvDhqh6EzYjr8fevy7mIN4oMMgyindN3LPf5q+b354QmndU35u0AogGFe8B1eXoOzjSOz6XZYbT083cqzWNkffWWhXGT6B0opVm8N1DA5/Z7oj3E4XzHkOEDcPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743625687; c=relaxed/simple;
	bh=pMI4VvrhdHCySyXCh3UEy27QIl3KjZTJ74eGiusFQ3Q=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z88XDW/1BjaS4YR2gCeeaXfhBh62m6xlDbKillwWCz6PQ7kTbL7ibiShPHFna4fs7JIZLEhmAQmdgsKnr/MK3zFHq6jjoEqVhuV7jhaYZvxd14M6N+EsahnjUOXfzJvQdxN0m3W98Z+TorscxIQFu5mwXPnPhuAvcdJP9d0IMew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.jp; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=dwG9Tynz; arc=none smtp.client-ip=99.78.197.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="dwG9Tynz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1743625685; x=1775161685;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ti6s4TIDQavVBsdtxADl8QYz9QBjQ5A0z4Mg7FW8S0I=;
  b=dwG9Tynz3VHlapsl/sxadefXGRrxTHRhB7OuLfQFv/ZhkOUSN0UJDT+E
   NAPEoJcMB0c/2xcXLRF8qxCWTYxLIDwGK2HaIarmOQbH+swxFqaLRyGeG
   CdkpfLzrHwKrxJr+jplRuBpLB11ds42OqeD9I6/MINIPPRveT+hnUrEwp
   g=;
X-IronPort-AV: E=Sophos;i="6.15,183,1739836800"; 
   d="scan'208";a="392332186"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2025 20:28:02 +0000
Received: from EX19MTAUWA001.ant.amazon.com [10.0.7.35:1643]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.27.18:2525] with esmtp (Farcaster)
 id 1e781972-352e-4290-b038-58ec050c9ede; Wed, 2 Apr 2025 20:28:02 +0000 (UTC)
X-Farcaster-Flow-ID: 1e781972-352e-4290-b038-58ec050c9ede
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Wed, 2 Apr 2025 20:27:57 +0000
Received: from 6c7e67bfbae3.amazon.com (10.106.101.8) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Wed, 2 Apr 2025 20:27:54 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: Steve French <sfrench@samba.org>
CC: Paulo Alcantara <pc@manguebit.com>, Ronnie Sahlberg
	<ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, "Tom
 Talpey" <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, Enzo
 Matsumiya <ematsumiya@suse.de>, Wang Zhaolong <wangzhaolong1@huawei.com>,
	"Kuniyuki Iwashima" <kuniyu@amazon.com>, Kuniyuki Iwashima
	<kuni1840@gmail.com>, <linux-cifs@vger.kernel.org>,
	<samba-technical@lists.samba.org>, <stable@vger.kernel.org>
Subject: [PATCH v2 1/2] Revert "smb: client: Fix netns refcount imbalance causing leaks and use-after-free"
Date: Wed, 2 Apr 2025 13:26:47 -0700
Message-ID: <20250402202714.6799-2-kuniyu@amazon.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250402202714.6799-1-kuniyu@amazon.com>
References: <20250402202714.6799-1-kuniyu@amazon.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D037UWB001.ant.amazon.com (10.13.138.123) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)

This reverts commit 4e7f1644f2ac6d01dc584f6301c3b1d5aac4eaef.

The commit e9f2517a3e18 ("smb: client: fix TCP timers deadlock after
rmmod") is not only a bogus fix for LOCKDEP null-ptr-deref but also
introduces a real issue, TCP sockets leak, which will be explained in
detail in the next revert.

Also, CNA assigned CVE-2024-54680 to it but is rejecting it. [0]

Thus, we are reverting the commit and its follow-up commit 4e7f1644f2ac
("smb: client: Fix netns refcount imbalance causing leaks and
use-after-free").

Link: https://lore.kernel.org/all/2025040248-tummy-smilingly-4240@gregkh/ #[0]
Fixes: 4e7f1644f2ac ("smb: client: Fix netns refcount imbalance causing leaks and use-after-free")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: stable@vger.kernel.org
---
 fs/smb/client/connect.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 10a7c28d2d44..137a611c5ab0 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -300,7 +300,6 @@ cifs_abort_connection(struct TCP_Server_Info *server)
 			 server->ssocket->flags);
 		sock_release(server->ssocket);
 		server->ssocket = NULL;
-		put_net(cifs_net_ns(server));
 	}
 	server->sequence_number = 0;
 	server->session_estab = false;
@@ -3367,12 +3366,8 @@ generic_ip_connect(struct TCP_Server_Info *server)
 		/*
 		 * Grab netns reference for the socket.
 		 *
-		 * This reference will be released in several situations:
-		 * - In the failure path before the cifsd thread is started.
-		 * - In the all place where server->socket is released, it is
-		 *   also set to NULL.
-		 * - Ultimately in clean_demultiplex_info(), during the final
-		 *   teardown.
+		 * It'll be released here, on error, or in clean_demultiplex_info() upon server
+		 * teardown.
 		 */
 		get_net(net);
 
@@ -3388,8 +3383,10 @@ generic_ip_connect(struct TCP_Server_Info *server)
 	}
 
 	rc = bind_socket(server);
-	if (rc < 0)
+	if (rc < 0) {
+		put_net(cifs_net_ns(server));
 		return rc;
+	}
 
 	/*
 	 * Eventually check for other socket options to change from
@@ -3444,6 +3441,9 @@ generic_ip_connect(struct TCP_Server_Info *server)
 	    (server->rfc1001_sessinit == -1 && sport == htons(RFC1001_PORT)))
 		rc = ip_rfc1001_connect(server);
 
+	if (rc < 0)
+		put_net(cifs_net_ns(server));
+
 	return rc;
 }
 
-- 
2.48.1

