Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C76D28F3
	for <linux-cifs@vger.kernel.org>; Tue, 10 Jun 2025 00:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749515602; cv=none; b=H1H2drMWtN8mMn3j0tWDkABwIecEYRaubbWPB4Y7b1hFywXeDVI2pQQqzk6juDdB+iwufeg762nNKbF+vhk76EXANxEKs7qF3h28SMxcjy/8u5HIE+NnRSPd8RWFEOJYpB5rIpypMU0c35WWuGrlw10ZOzpKYHbV2y0oVrm9PBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749515602; c=relaxed/simple;
	bh=qHtksGHl66ysN/RhGCaOBXK3GRjLE7oI9f8+95oPq/o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PBgLWOXyz62nAP8QQR2FJq91RMeXvsIHDyRKOzWG9/wWDCwLg0M9mMyocLHhE7n0fObjb67LsUBDvhpatoEJ4Ii6kwxZiYnt5ikSICzjsXlKg8SJmFWR4rhggNmQ7MM76XH9aytzKKfrXiw9YkMa5D3P8AN14bZHTW8E94RtA2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b=RTMVCWXD; arc=none smtp.client-ip=185.125.188.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="RTMVCWXD"
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 37FBE3F285
	for <linux-cifs@vger.kernel.org>; Tue, 10 Jun 2025 00:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1749515590;
	bh=5cRnfdLpCQlN0t0zA+a0+/N0xeyy/i9TfwI0lobjwHk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version;
	b=RTMVCWXDNm/7WBiFJOLg2Xt/N2nN0mLWOe0uHt9N1PvxrbEMtUY0ceDWVz65qADcO
	 aXkIhDj8y8qbFx+kKPEBA03hG1IjgIeoKamgz2ZZq/vwJHNUIL88j3Nqs3ODNbvBym
	 MIWmZ3c+WBCujlFA7Y7BFhmF8Sao21Jiu8pm/UzNDH9yAEK6cJ9RCcevy4WiZyjhLs
	 8Gyc7hTvQIOx+jMWh3nF8vMNCh63Ek9oa5hUet+r/OKB5vW+71S8E2z9h33GagNjla
	 VIB5ZsGQJMYpXqtS+sb5JyCFTzKy0Ioyww+8Gr+C3OjR1+WD3DSDjDcqqbXnJKhd2w
	 PJXyYMQjia4Ng==
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-231d13ac4d4so74143215ad.3
        for <linux-cifs@vger.kernel.org>; Mon, 09 Jun 2025 17:33:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749515589; x=1750120389;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5cRnfdLpCQlN0t0zA+a0+/N0xeyy/i9TfwI0lobjwHk=;
        b=ECNUR1+fSz817l2kXCF9/SNS6e5M1kTRGsYOkYrN0XEjN64j0bnEJ5qtDrJGj7GSch
         LdlhnNoxfN/xAdwmFRie9DkpSN235o8pz9SndEwqreECPawnWYON2m8YP3GWObP4WETP
         CNq1mNWIyTSOYG1qO9dS6ArqfmeM9ze+IS7Y415KEJiQ9rlo17IWicea+1oOrkFmmNMZ
         n6FeL6GQPCavHpAoRWEcCoMJPPZyxNuJRfx3pud8F7dKu+mp9SxyGcL2ZVHGKCb1PPDc
         4rHIqgq9UBxJa/0OqHNX2QH2vEJdHrVNr4VmUKSdKFHye/Yu96Ls5YW1n6rkqRPG0RLV
         WtMg==
X-Gm-Message-State: AOJu0YxvtqZ1o1QFi1WJKUqX6Udgfyf52fQZZV/YMEyvCnsCepYVKXJN
	L1Vqf4yuLuVFwhBrmyYUTCxzp40hq6xCcNbinu7kemT2ecq29yomSFQlMjmhTaAijtXwjWtzBMj
	W9qBHOH0WPZ5YsM3Vsrsk3TryHP8SyM6TvSgDRk9VCrpiVrSgLM2WGbC9DOmRyWlhN0KBXC5V4S
	+71Wv6URupREGwbw==
X-Gm-Gg: ASbGncvHg1Gnu+jeQuWqOXQYOJNZN3EZQwhWZndwB9smZLDfhUX405wgNdufhm9h8iE
	J5Di6AfRtL0NbWM1OBJZHkih6w4h5SG7TFeO+H3GBVGiUi55oerQsbR+G0gFFRFXox1TsOqxg46
	6ytyPigU5jAnKh9VCmXs450xi4xIrOZVjdYwySHJc5xVEHRwA1jcmg+Cu8kwI7frYZMmtaESFCy
	YDS1BE6h7U8j/9xg+tDAyLQ2o2f6bPCyxVkBfyjxxdh03Fz+cYULIfPhop3ld8cimq0o7F4141v
	P3MVEm7bt1235KTZNBHqRxr8dkvsnw4hc4NoPxKrLnX1f1q7tk01M5R89u4dzseFWAJ81RaRcQ=
	=
X-Received: by 2002:a17:903:41c8:b0:235:6e1:3ee8 with SMTP id d9443c01a7336-23601cf6bc0mr244505265ad.11.1749515588907;
        Mon, 09 Jun 2025 17:33:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEKBw+VjAwuVcOdc5PtEBpT0CwlqazWv82f8hO3K4grbCgMQDaE7DJ1+rEgphnzglFJDQOo7Q==
X-Received: by 2002:a17:903:41c8:b0:235:6e1:3ee8 with SMTP id d9443c01a7336-23601cf6bc0mr244505015ad.11.1749515588592;
        Mon, 09 Jun 2025 17:33:08 -0700 (PDT)
Received: from ThinkPad-X1.. (125-238-29-131-adsl.sparkbb.co.nz. [125.238.29.131])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23603405e6esm60119595ad.170.2025.06.09.17.33.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jun 2025 17:33:08 -0700 (PDT)
From: Matthew Ruffell <matthew.ruffell@canonical.com>
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	henrique.carvalho@suse.com,
	rbudhiraja@microsoft.com,
	bharathsm@microsoft.com
Subject: [PATCH 0/1][cifs-utils] Regression: After CVE-2025-2312 cifs.upcall can't find credential caches from user env
Date: Tue, 10 Jun 2025 12:32:58 +1200
Message-ID: <20250610003259.19242-1-matthew.ruffell@canonical.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

We recently backported 89b679228cc1 ('CIFS.upcall to accomodate new namespace mount opt') 
in Ubuntu to mitigate CVE-2025-2312, and it caused a minor regression where
users of unpatched kernels without db363b0a1d9e ('CIFS: New mount option for cifs.upcall
namespace resolution') could no longer pass in their kerberos credential cache from 
environment variables like KRB5CCNAME, leading to mount failures, particularly of users
with AD accounts in enterprise setups.

$ echo $KRB5CCNAME
/tmp/krb5cc_11200
$ sudo mount -t cifs -o sec=krb5i //samba-dc.example.com/demo /mnt/testshare1
mount error(126): Required key not available
Refer to the mount.cifs(8) manual page (e.g. man mount.cifs) and kernel log messages (dmesg)

Workarounds involve upgrading to a kernel with db363b0a1d9e ('CIFS: New mount option for 
cifs.upcall namespace resolution') or manually setting default_ccache_name in krb5.conf.

Downstream bug:
https://bugs.launchpad.net/ubuntu/+source/cifs-utils/+bug/2112614

Downstream bugs where we first fixed CVE-2025-2312:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/2099914
https://bugs.launchpad.net/ubuntu/+source/cifs-utils/+bug/2099917

Please merge the fix so I can fix affected users.

Alternatively, merge Henrique Carvalho's patch, as it does the same thing.
https://lore.kernel.org/linux-cifs/20250530152814.1592508-1-henrique.carvalho@suse.com/T/#u

Thanks,
Matthew

Matthew Ruffell (1):
  cifs.upcall: Fix regression in accessing ccache in env for users of
    UPTARGET_UNSPECIFIED

 cifs.upcall.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

-- 
2.48.1

