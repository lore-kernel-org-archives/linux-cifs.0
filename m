Received: from pdx-out-015.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-015.esa.us-west-2.outbound.mail-perimeter.amazon.com [50.112.246.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAFE5363C5A;
	Tue,  8 Sep 2026 16:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=50.112.246.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788883825; cv=none; b=hF1jt+wqbXHZkUbih7TJe5F+i0nSs4qmwWJxOXKQPX4HwSZG8nNN73eE0dxDbW0mlX+Zz8DT/KCQJskDx7ILc4F81GBqdQDQrQ2M6/ATMQYSQXw9OmDqghnAbxCo6/Vl7zoDL1C9wSUfkhK+TBNqsPSFm03rLH8tX+Q1tYQznUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788883825; c=relaxed/simple;
	bh=EKpe/G2t/a1VbysYtsyuNiyzdKbBLauBZeg2QMWDjKE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iYxia53qCin0lo/RG99rKncOqLgRRccBATUWk9K2Mc/Fl0xh1au60mlu+tuA7J6wZPGzySkMeFTUlhm1PiIrdRRIlvOH2KNmBrjSSaA6tnYfSwT04tBWUjJdWImFJvGSash1g3Hi0+My5+HzjdRRj6SkjobwQOZaxkWXuUUAgG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=Rq2+xGrR; arc=none smtp.client-ip=50.112.246.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="Rq2+xGrR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1788883823; x=1820419823;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Q2BXE6Ur7AFNkUgpQWEyi2lyndEfw5dtpYmnWEDRjZM=;
  b=Rq2+xGrRkxdLOBmHYtkfQ3inMMH4nHExD608x7RLL+ZAmsG1hOqCkf2k
   UcYGxrKHWmx1LHbsFRLIZaALRO7lL1ZfOJdG5p8MdkHgDj7oWstchXj6t
   sHamsOlTLfEZfsv+OY4fX+BkChSfx6TAt0pa4hz8lz5gUfiVgHFDZjMMm
   9Y2kpoisTrW8ojuJN9y4+j1eW8wA3nqBLCb8MnQlVMQxXfO4prrxfm4VX
   Kt3S15Shg8hx7tfyIVKTNvGfodtMFBasNyNDaraa82A2JJ6weRDj0NMGc
   l9OMW3m8pq7v4QqTsqiVsuGrY+WTZ6nS6r65XBMdk9/s0wbpCjLEQST/A
   A==;
X-CSE-ConnectionGUID: P4rQlcEDTHy7OTvX4YFcyg==
X-CSE-MsgGUID: WiI34h14QZqibi1cArKKGA==
X-IronPort-AV: E=Sophos;i="6.25,269,1779148800"; 
   d="scan'208";a="27914447"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-015.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2026 16:10:21 +0000
Received: from EX19MTAUWC002.ant.amazon.com [205.251.233.111:15987]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.40.124:2525] with esmtp (Farcaster)
 id 64882264-9490-422e-aff4-f9043ee81cd6; Tue, 8 Sep 2026 16:10:20 +0000 (UTC)
X-Farcaster-Flow-ID: 64882264-9490-422e-aff4-f9043ee81cd6
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Tue, 8 Sep 2026 16:10:20 +0000
Received: from dev-dsk-doebel-1a-7b355d76.us-east-1.amazon.com (10.169.119.5)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.46;
 Tue, 8 Sep 2026 16:10:19 +0000
From: Bjoern Doebel <doebel@amazon.de>
To: <linux-cifs@vger.kernel.org>
CC: <linkinjeon@kernel.org>, <pc@manguebit.com>, <stable@vger.kernel.org>,
	Bjoern Doebel <doebel@amazon.de>
Subject: [PATCH v3 0/2] smb: client: fix DACL rewrite overflows
Date: Tue, 8 Sep 2026 16:09:59 +0000
Message-ID: <20260908161001.2603610-1-doebel@amazon.de>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260904125844.1803343-1-doebel@amazon.de>
References: <20260904125844.1803343-1-doebel@amazon.de>
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

Two overflow fixes in the CIFS DACL owner/group rewrite path:

1. Patch 1 fixes a heap overflow when copying ACEs whose total size
   exceeds what kmalloc() allocated. The allocation used the old
   (pre-rewrite) ACE count, but the copy loop iterated over the new
   count.

2. Patch 2 fixes a u16 accumulator overflow in the size calculation
   that could wrap around for DACLs with 800+ ACEs, causing the
   check in patch 1 to pass despite the actual size exceeding 64KB.
   Returns -EOVERFLOW when this would occur.

Changes since v2:
- Patch 1 unchanged (already Reviewed-by Namjae Jeon)
- Patch 2: widened nsize from u16 to u32 and added explicit overflow
  guard instead of relying on check_add_overflow (which gcc optimized
  away for a u16 accumulator)
- Patch 2: fixed build_sec_desc() to propagate error from set_chmod_dacl()
  when it fails (discovered during testing)

Bjoern Doebel (2):
  smb: client: fix heap overflow in DACL owner/group rewrite
  smb: client: fail DACL rewrite when the new DACL exceeds 64K

 fs/smb/client/cifsacl.c | 51 ++++++++++++++++++++++++++---------------
 1 file changed, 33 insertions(+), 18 deletions(-)

-- 
2.50.1

