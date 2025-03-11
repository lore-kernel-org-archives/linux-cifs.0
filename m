Received: from ksmg02.maxima.ru (ksmg02.maxima.ru [81.200.124.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 147C725C6E7;
	Tue, 11 Mar 2025 14:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=81.200.124.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741703150; cv=none; b=Gm2q7yVIvVhbzah0D5W3Irl2K/b5QsisB/Jl/XyaadaWm+5ZzwfPzMUMBZBuwDjhH3eXgMaBWjHEnbXswslEG4V7gW9IDsmqzjei/xYktysOmN62u1fAOxNM/wPBvH4gyTyrGbXfaoKF+UlEsH0vlCL6I4KpIRXIedFbMq4eQ+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741703150; c=relaxed/simple;
	bh=Ulht3x7Xfkshq+RA31+b7Cg6c8KF6Fuy03NB9KcU/wA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OUTR09b65RdC1sX260x+y2a3luEFtBvlA87JYY1eWhfQmwotgohV+4N7tFZAV9VfO+xIhzsd1XX8+lolB+9UI3FL7UYzpsa7j4SgKa9B0+ykJA+jA0FmEohevChnZTfMZSEf+wkfro/wJuwcmN8op4k8ltUgZDv0r0PLoujeIyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mt-integration.ru; spf=pass smtp.mailfrom=mt-integration.ru; dkim=pass (2048-bit key) header.d=mt-integration.ru header.i=@mt-integration.ru header.b=NL9XaaUx; arc=none smtp.client-ip=81.200.124.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mt-integration.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mt-integration.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mt-integration.ru header.i=@mt-integration.ru header.b="NL9XaaUx"
Received: from ksmg02.maxima.ru (localhost [127.0.0.1])
	by ksmg02.maxima.ru (Postfix) with ESMTP id 11BF91E0018;
	Tue, 11 Mar 2025 17:25:41 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 ksmg02.maxima.ru 11BF91E0018
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mt-integration.ru;
	s=sl; t=1741703141; bh=i8l90tW0lQ0g/H/CHoMHQh7J+/sv5ThipLki0A0dDA4=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=NL9XaaUx7wS5yucHxrCe54QPCR3KF0gfNISlNmSr8Q3124LAbSd9x+JJy8zglzfLl
	 NS7ysCe22McLtN4UYPMOM4ArlGvRC6og7HyDx8IIbi9U4kWi6l3d+OGYkH3SCL+w4I
	 /6qYYamgHBX3dc1cUJn3WzWly1wuMHr5bqXArRxHRG/Tr8s1UJIq+KPOQfJgyv6Qy9
	 nkM8LQvjri2T+gH7NpLyRpaFTJj0SDphdLG7pBeKSKZLH/hCjwJOca3P5nWx5QLnCq
	 ObGt/69KDMmnABSLAwi9H6TMb82Sc0VXAwB9rl4xnSahDynko5pKXwHQdgBXxBl0WM
	 0+mfFlREXhmzw==
Received: from ksmg02.maxima.ru (mail.maxima.ru [81.200.124.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(Client CN "*.maxima.ru", Issuer "GlobalSign GCC R3 DV TLS CA 2020" (verified OK))
	by ksmg02.maxima.ru (Postfix) with ESMTPS;
	Tue, 11 Mar 2025 17:25:40 +0300 (MSK)
Received: from GS-NOTE-190.mt.ru (10.0.246.70) by mmail-p-exch02.mt.ru
 (81.200.124.62) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1544.4; Tue, 11 Mar
 2025 17:25:36 +0300
From: Murad Masimov <m.masimov@mt-integration.ru>
To: Steve French <sfrench@samba.org>
CC: Paulo Alcantara <pc@manguebit.com>, Ronnie Sahlberg
	<ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, Tom
 Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, Jeff Layton
	<jlayton@kernel.org>, Suresh Jayaraman <sjayaraman@suse.de>, "Paulo Alcantara
 (SUSE)" <pc@cjr.nz>, <linux-cifs@vger.kernel.org>,
	<samba-technical@lists.samba.org>, <linux-kernel@vger.kernel.org>,
	<lvc-project@linuxtesting.org>, Murad Masimov <m.masimov@mt-integration.ru>
Subject: [PATCH 1/4] cifs: Fix integer overflow while processing acregmax mount option
Date: Tue, 11 Mar 2025 17:22:03 +0300
Message-ID: <20250311142206.2045-2-m.masimov@mt-integration.ru>
X-Mailer: git-send-email 2.46.0.windows.1
In-Reply-To: <20250311142206.2045-1-m.masimov@mt-integration.ru>
References: <20250311142206.2045-1-m.masimov@mt-integration.ru>
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

User-provided mount parameter acregmax of type u32 is intended to have
an upper limit, but before it is validated, the value is converted from
seconds to jiffies which can lead to an integer overflow.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 5780464614f6 ("cifs: Add new parameter "acregmax" for distinct file and directory metadata timeout")
Signed-off-by: Murad Masimov <m.masimov@mt-integration.ru>
---
 fs/smb/client/fs_context.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index e9b286d9a7ba..e9045fcf843e 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1340,11 +1340,11 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 		}
 		break;
 	case Opt_acregmax:
-		ctx->acregmax = HZ * result.uint_32;
-		if (ctx->acregmax > CIFS_MAX_ACTIMEO) {
+		if (result.uint_32 > CIFS_MAX_ACTIMEO / HZ) {
 			cifs_errorf(fc, "acregmax too large\n");
 			goto cifs_parse_mount_err;
 		}
+		ctx->acregmax = HZ * result.uint_32;
 		break;
 	case Opt_acdirmax:
 		ctx->acdirmax = HZ * result.uint_32;
--
2.39.2

