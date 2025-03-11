Received: from ksmg02.maxima.ru (ksmg02.maxima.ru [81.200.124.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A488E156C62;
	Tue, 11 Mar 2025 14:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=81.200.124.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741703147; cv=none; b=cSW1U4JRq0rFOAKYfgqhGT5iCmtbzsioyLDSFQQFW1Njh8MMgovUY6K4L4/ovWE1QN1i3q2lbaNtsjEFpn0jvEWqxR0uOepQeyxEk6W/SEHKynzX27mxOsk/uUxgkovXMEtGULKtLeYVdEOWoczKSj87fMLiXg44mF4AVS5YVdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741703147; c=relaxed/simple;
	bh=05bZVaLA9/Kh87yiopcsB70RUi/bZ2X4rpmzaPDGjRU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ChEReVoZLWyIsvqSWSqJEZfqYw1s/rvjwT0Q+cSosAtttNQz6nZUZHp8SdT9pv0BZC3INJOvPMhjtegjNUcVy1lk5HtcMH2MbwCNz8IHgO0C+FSAKqH4/8BIbXfR2w5jQILZ8VEIDRdXIPjO7W8gQzABlrIw210yPnAHUU6f3GM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mt-integration.ru; spf=pass smtp.mailfrom=mt-integration.ru; dkim=pass (2048-bit key) header.d=mt-integration.ru header.i=@mt-integration.ru header.b=e1EdwjGs; arc=none smtp.client-ip=81.200.124.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mt-integration.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mt-integration.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mt-integration.ru header.i=@mt-integration.ru header.b="e1EdwjGs"
Received: from ksmg02.maxima.ru (localhost [127.0.0.1])
	by ksmg02.maxima.ru (Postfix) with ESMTP id 72DE21E0011;
	Tue, 11 Mar 2025 17:25:35 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 ksmg02.maxima.ru 72DE21E0011
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mt-integration.ru;
	s=sl; t=1741703135; bh=pVr5Bxi/FvTbaIsz7rL3SBie1NbHtO1UVIGxudFCGWg=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=e1EdwjGs2bi1w1Xyde5W6L6U9yFZTMft2RCiTCma/+gH+qRR1AtgEqW/SY3FNudPS
	 5MCO+wiTVpPOdntOgCNjDqQTdAA058oGfpMLZKY16x/wBcp13xjQi+G8k0lzRX4vfK
	 RgxN4dLw4HJxHTrRbJt7YW9RtQ99HHv3iHtJ4DFut36iLN1MS+ShOpsGrTCLEEenyI
	 3/+4750tnFdF+Z60/qqgAxE7QlwdrIJEf1dOq7BBbFnCcaVYdnWYt6/rs2WnRRDxtf
	 KifL/Bm4HaAQ2CtzctmaaYAITYI3NMN8dENYwsTY/wMRIhzqGSMhUDFIiG57dC7JZD
	 GQFr3EOgZuXSw==
Received: from ksmg02.maxima.ru (mail.maxima.ru [81.200.124.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(Client CN "*.maxima.ru", Issuer "GlobalSign GCC R3 DV TLS CA 2020" (verified OK))
	by ksmg02.maxima.ru (Postfix) with ESMTPS;
	Tue, 11 Mar 2025 17:25:35 +0300 (MSK)
Received: from GS-NOTE-190.mt.ru (10.0.246.70) by mmail-p-exch02.mt.ru
 (81.200.124.62) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1544.4; Tue, 11 Mar
 2025 17:25:31 +0300
From: Murad Masimov <m.masimov@mt-integration.ru>
To: Steve French <sfrench@samba.org>
CC: Paulo Alcantara <pc@manguebit.com>, Ronnie Sahlberg
	<ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, Tom
 Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, Jeff Layton
	<jlayton@kernel.org>, Suresh Jayaraman <sjayaraman@suse.de>, "Paulo Alcantara
 (SUSE)" <pc@cjr.nz>, <linux-cifs@vger.kernel.org>,
	<samba-technical@lists.samba.org>, <linux-kernel@vger.kernel.org>,
	<lvc-project@linuxtesting.org>, Murad Masimov <m.masimov@mt-integration.ru>
Subject: [PATCH 0/4] cifs: Fix integer overflow while processing mount options
Date: Tue, 11 Mar 2025 17:22:02 +0300
Message-ID: <20250311142206.2045-1-m.masimov@mt-integration.ru>
X-Mailer: git-send-email 2.46.0.windows.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: mt-exch-01.mt.ru (91.220.120.210) To mmail-p-exch02.mt.ru
 (81.200.124.62)
X-KSMG-AntiPhishing: NotDetected
X-KSMG-AntiSpam-Auth: dmarc=none header.from=mt-integration.ru;spf=none smtp.mailfrom=mt-integration.ru;dkim=none
X-KSMG-AntiSpam-Envelope-From: m.masimov@mt-integration.ru
X-KSMG-AntiSpam-Info: LuaCore: 51 0.3.51 68896fb0083a027476849bf400a331a2d5d94398, {rep_avail}, {Tracking_from_domain_doesnt_match_to}, mt-integration.ru:7.1.1;81.200.124.62:7.1.2;ksmg02.maxima.ru:7.1.1;127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1, FromAlignment: s, ApMailHostAddress: 81.200.124.62
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiSpam-Lua-Profiles: 191671 [Mar 11 2025]
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Version: 6.1.1.11
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.1.1.8310, bases: 2025/03/11 08:08:00 #27707391
X-KSMG-AntiVirus-Status: NotDetected, skipped
X-KSMG-LinksScanning: NotDetected
X-KSMG-Message-Action: skipped
X-KSMG-Rule-ID: 7

These patches fix similar issues that have different origin commits.
User-provided mount parameters are intended to have upper limits, but
are validated after their values are converted from seconds to jiffies,
which can lead to an integer overflow.

Murad Masimov (4):
  cifs: Fix integer overflow while processing acregmax mount option
  cifs: Fix integer overflow while processing acdirmax mount option
  cifs: Fix integer overflow while processing actimeo mount option
  cifs: Fix integer overflow while processing closetimeo mount option

 fs/smb/client/fs_context.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--
2.39.2

