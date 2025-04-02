Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB0A6AA7
	for <linux-cifs@vger.kernel.org>; Wed,  2 Apr 2025 20:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743624216; cv=none; b=Qb/FT2Yn/wn2NL7M4I77YelDW+ZkT91obyZbwYPyPtU3YsS0Q7RwziaKb9axgrelWQcievBvIB5WNQpDEYi2jHsKJfYlNZcww+V6Q/QpQCPcQLQfsCUT4xmPyWnVle6ut+++h4JGQWAlldfZ9dHF6qcZtinnkD306SwBeoiCXIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743624216; c=relaxed/simple;
	bh=4sXJmOarD8YzytZMERGRdxFB7vWMOtIStcu8P3Dibak=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=rn9B1jO5f8GXVVwNgecTr8HaF1uQ7Wr/AYQca6FPraSctD8YFUqNguGBpzyNt/iYydb5zoolPp7Nlbj/fAKI3bm/Aeskt5FSElgKdNvQXZvqKEkqy00cYV+yC40z60T60L0zwMAAoXHAPR5sUHsfsvh3lxPbUOxOK+OxvL7vMLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.jp; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=RbIQvI/I; arc=none smtp.client-ip=99.78.197.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="RbIQvI/I"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1743624215; x=1775160215;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=fvflbliXlCyhmTDSxYa5lwtO6Jfp/Cek8bFc53RSoAc=;
  b=RbIQvI/IKcY5MkX0X7Knw+cxOaZsdHEBDcu8ZLuJhzblujQOxxcTXMGe
   rC1gftxVaiWkWbyIV9D5xs3UctiZqkSpzVUoj8MF1mWB8qHz4bwbnS5DF
   O265w7LljgQ516JiJxAXaVnoC3NP/pcrBckCvUnLhLU6wd+h+iMtNRO69
   8=;
X-IronPort-AV: E=Sophos;i="6.15,183,1739836800"; 
   d="scan'208";a="37543458"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.214])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2025 20:03:33 +0000
Received: from EX19MTAUWC001.ant.amazon.com [10.0.38.20:61748]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.4.91:2525] with esmtp (Farcaster)
 id a5c37aac-98ea-45af-bb22-7b116a04128a; Wed, 2 Apr 2025 20:03:32 +0000 (UTC)
X-Farcaster-Flow-ID: a5c37aac-98ea-45af-bb22-7b116a04128a
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Wed, 2 Apr 2025 20:03:32 +0000
Received: from 6c7e67bfbae3.amazon.com (10.106.101.8) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Wed, 2 Apr 2025 20:03:29 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: Steve French <sfrench@samba.org>
CC: Paulo Alcantara <pc@manguebit.com>, Ronnie Sahlberg
	<ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, "Tom
 Talpey" <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, Enzo
 Matsumiya <ematsumiya@suse.de>, Wang Zhaolong <wangzhaolong1@huawei.com>,
	"Kuniyuki Iwashima" <kuniyu@amazon.com>, Kuniyuki Iwashima
	<kuni1840@gmail.com>, <linux-cifs@vger.kernel.org>,
	<samba-technical@lists.samba.org>
Subject: [PATCH 0/2] cifs: Revert bogus fix for CVE-2024-54680 and its followup commit.
Date: Wed, 2 Apr 2025 13:02:45 -0700
Message-ID: <20250402200319.2834-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D043UWA002.ant.amazon.com (10.13.139.53) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)

Commit e9f2517a3e18 ("smb: client: fix TCP timers deadlock after
rmmod") was not only a bogus fix for the LOCKDEP issue but also
introduced a real TCP socket leak.

I'm working on the LOCKDEP fix on the networking side, so let's
revert the commit and its followup fix.

For details, please see each commit.


Kuniyuki Iwashima (2):
  Revert "smb: client: Fix netns refcount imbalance causing leaks and
    use-after-free"
  Revert "smb: client: fix TCP timers deadlock after rmmod"

 fs/smb/client/connect.c | 34 +++++++++-------------------------
 1 file changed, 9 insertions(+), 25 deletions(-)

-- 
2.48.1

