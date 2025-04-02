Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F32D41F1516
	for <linux-cifs@vger.kernel.org>; Wed,  2 Apr 2025 20:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=72.21.196.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743625659; cv=none; b=s6CcC2ADWgiTjMvc/nzE8Rtg2nEzHZ0q4zcEfDHLPfsAkm0CHwr///3550Q9IJtcAWHJMfUKyUEQ2Om4CXhojbBT7l0q6ggTx2DOMJsxgDeu0f8Q0GAHF0AwE6pOEIXlFaWy8Wkuv7z9abJhLEOowLYk7AhK7uB8P6HIcAmToyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743625659; c=relaxed/simple;
	bh=9TaHJWi5ZXxJEnPXI4DgSpsWvMm76OeDtTEXoL4p37s=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=loO+/nAwmBjlK7eVLB0iclW6n4xf3RSXiLOG28WwNbHQdJaDY1+mFHUwLzuuyolkm4ACwekg1IfAXoEXI5lecrDlTfKxfxzp73PqmdnNZIqkaVHIdbKYqL5Do59LjyHUXFCq+9FRzrVWWDTQxwlk/Yscu4GiQojAgrlHNp8Ecaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.jp; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=reChPIpg; arc=none smtp.client-ip=72.21.196.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="reChPIpg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1743625658; x=1775161658;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=0Dl4ambqgSK3qM215BGRBpDMgSBFL9HlOScw7yRKL4M=;
  b=reChPIpgpRY4exPeT/bJq1bJ8V8VjjuiywC3todmvEd+9a02WZa1V85P
   +4eAlvoBfh2HMhhr/Ok26sBUFLczbc7U5B+yOmCzd3fpvAmXlyAI37MXH
   MvODmjWgOPcPgIaKKtnp5QE6FG854GkDqS5cBNM1drBTGG8MYONPUZr+A
   c=;
X-IronPort-AV: E=Sophos;i="6.15,183,1739836800"; 
   d="scan'208";a="479816170"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2025 20:27:33 +0000
Received: from EX19MTAUWC002.ant.amazon.com [10.0.21.151:30648]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.3.46:2525] with esmtp (Farcaster)
 id 4e2d6a44-b7a0-4257-8fa5-e305116ceb8b; Wed, 2 Apr 2025 20:27:32 +0000 (UTC)
X-Farcaster-Flow-ID: 4e2d6a44-b7a0-4257-8fa5-e305116ceb8b
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Wed, 2 Apr 2025 20:27:31 +0000
Received: from 6c7e67bfbae3.amazon.com (10.106.101.8) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Wed, 2 Apr 2025 20:27:28 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: Steve French <sfrench@samba.org>
CC: Paulo Alcantara <pc@manguebit.com>, Ronnie Sahlberg
	<ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, "Tom
 Talpey" <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, Enzo
 Matsumiya <ematsumiya@suse.de>, Wang Zhaolong <wangzhaolong1@huawei.com>,
	"Kuniyuki Iwashima" <kuniyu@amazon.com>, Kuniyuki Iwashima
	<kuni1840@gmail.com>, <linux-cifs@vger.kernel.org>,
	<samba-technical@lists.samba.org>
Subject: [PATCH v2 0/2] cifs: Revert bogus fix for CVE-2024-54680 and its followup commit.
Date: Wed, 2 Apr 2025 13:26:46 -0700
Message-ID: <20250402202714.6799-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D045UWC004.ant.amazon.com (10.13.139.203) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)

Commit e9f2517a3e18 ("smb: client: fix TCP timers deadlock after
rmmod") was not only a bogus fix for LOCKDEP issue but also
introduced a real TCP socket leak.

I'm working on the LOCKDEP fix on the networking side, so let's
revert the commit and its followup fix.

For details, please see each commit.


Changes:
  v2: Add Cc: stable


Kuniyuki Iwashima (2):
  Revert "smb: client: Fix netns refcount imbalance causing leaks and
    use-after-free"
  Revert "smb: client: fix TCP timers deadlock after rmmod"

 fs/smb/client/connect.c | 34 +++++++++-------------------------
 1 file changed, 9 insertions(+), 25 deletions(-)

-- 
2.48.1

