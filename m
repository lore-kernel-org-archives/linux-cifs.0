Received: from out162-62-58-211.mail.qq.com (out162-62-58-211.mail.qq.com [162.62.58.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FD2435E1B1
	for <linux-cifs@vger.kernel.org>; Tue, 18 Aug 2026 03:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.58.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787023541; cv=none; b=o62+mdu9Acd1Xcgf5GCsyznZ0D+SWJLYtXY89Ez5Tt7TTOhfUA6A+wO6HJxk+OpFb9mXiJ2gT/FWUjvKqDInIzFVrv+u9cNFUt1FRsy91HunPrbakh0HiOY1Twnwt756mc9lWVyA/hLYobpif1M9RjcQhobNbtC4R8Dk9rEVGWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787023541; c=relaxed/simple;
	bh=t4+8rGGRWdIAeya9yMy/GmuUtsCIdLXPa2PGQ5rEEf4=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version; b=GGLdKAoSWknPnLtUWMnDNBrwZLQm9O5nr+4t+OHbMThnpDrwjj5dpBHBEaqjWj88GP6wfG9cVawXmbaorRjsOLc4g+te4J9Qa7tV6XjLFB0bPR04x5iz3j66cCtGRb4R1wYEvfoHXTKbXVeW7jGOGLfSyGjA/27qmaqrCw9e8V0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=cFZ86vc1; arc=none smtp.client-ip=162.62.58.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="cFZ86vc1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1787023530; bh=/0aeHjVrkAcs3QWB4ZarK9+7PPjfSVQOWKzj2yNusE0=;
	h=From:To:Cc:Subject:Date;
	b=cFZ86vc1FrQLnXXnzuSl2na+52zGNDWia+uvVKJi/N8jvZFnTWUG3G1zo0h8WRNMZ
	 MrFXrbw28TrVSJI/MqiJmRH2pKGoDDJqyXIWQICfPsPiGAQ20LHy8vAapdrLXxay0v
	 nPkQ36/fL0CE0EaXuDtjyHF9/5qrRTFpAW/qwa9M=
Received: from localhost.localdomain ([240e:453:ddc8:a66b:124:844d:8bab:70af])
	by newxmesmtplogicsvrszc50-0.qq.com (NewEsmtp) with SMTP
	id 5F59A495; Tue, 18 Aug 2026 11:23:53 +0800
X-QQ-mid: xmsmtpt1787023433tn8hqem7s
Message-ID: <tencent_3F317DC1A45B94CD5E78DAFF13F73DBD200A@qq.com>
X-QQ-XMAILINFO: OfxHHOU34G6ph8HVix5ES5NlyEBjSkkrSLrbeLyWqlyag/nQLkibdmmV/3G+xH
	 7m+h/dpULgfDpo44ROsox5EpsymbRqqOdkog6eKXfxB/+HkFb/DJ4/dKUPcC4/gjhgweqwYjLzkm
	 4c9U0YeAR/IJFjRDgQIIzBR7G8hotStFFtESwS6b7QzZl+jnSy9FYHDyZwcARk9VFspwykui1Tid
	 FIaNAR4mpu6LOSrYFu6WjKP8LNJoZYY7UA0h46kUX3kn5uFekbPoz/sx7mMqmMnfOIdZIFtkXUCE
	 KwpauACoF4FeHG+CHeNGofgsh+syCcjWGYTfWASj2hAGP0/SzHz8jxidQu7Z0zjTTwQr2UsQ/P+/
	 8GFYpfij6dkrfCoKVv8KdYcM/2/2wsBwr6tC0j7BWPSTdY6lj5sZq2TMgatJAx21v3wEUsWp+oaR
	 PD/TVI0BcjSyoJgSYuPTEQnuMRAfaa0B6M0R35NHLDBg5PpfnfUkqW++LzqQECtfqZ82t/GHmASU
	 2Mf1LHUFQAnAcC6aoAwgV0Td46tAGKO98QOjk9aUUj73Oo1r846xxTbh2q87Fu+Sdt2PrZtzUplf
	 iMUKbFOn7CN58jZv70Kkhp5rByIlml0N19wNRVamHXTJlUqitDNXmF7M+UPWu6SzR9B24YKWjaz1
	 zwWEcG7/7aFge+fgubugzFFDVX+VbdjFSGKa+WE4qDpyGwJWxrSMKUKDkz6S3Xx5R5SDWsaHRXue
	 RWQfy3+F4kwgkFhVK/K4Ehttoy7PY0zcdZ8QZDa8DKGkrzSgptNQdTc+yFSY5EclPIadEV2vhrKN
	 eCsUaJDHyQQaSY2Hn64rZhgcmy8j37y5IrssRg2oJZPbNJtS0LVAVpCTIYE3hGmtXHlxr9J+MpVb
	 dIK1MaGcxQNu8+mTYkx0bC6GgQHOAuZA224F5/JqgtspyLsATF7LoF55rcD4E0sJERe0ksRK6XST
	 7ceSJKl0895ZhTY9PRZamZmrZ3zCwSz1DVuIXL4cb9hMvYQ/AM+wkGEK2KlB6PCBHYAdqEsDVHJq
	 eMwrwMUreEvVEWMhWkdZaeWJBOutKZJhSch4Ee1pfrJ3CN9cyvjfIuddPyT35qcN3c+vIdvg==
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
From: Hang Nan <2122295973@qq.com>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	tom@talpey.com,
	senozhatsky@chromium.org,
	chenxiaosong@kylinos.cn
Cc: linux-cifs@vger.kernel.org,
	Hang Nan <2122295973@qq.com>
Subject: [PATCH v3 0/3] ksmbd: bound smb_check_perm_dacl() ACE walks by DACL size
Date: Tue, 18 Aug 2026 11:23:31 +0800
X-OQ-MSGID: <20260818032335.10643-1-2122295973@qq.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Changes in v3:

- Split the KUnit tests into patch 1 and patch 2.
- Add patch 3.
- Build the KUnit tests as a separate .ko instead of linking them into ksmbd.ko.

The following patch from v2 have already been merged into #ksmbd-for-next-next:
https://lore.kernel.org/linux-cifs/CAKYAXd9XHJSNfrFr+F8thNxFnXqGGcKpS1b1qR4DNuu82+j_VQ@mail.gmail.com/

Hang Nan (3):
  ksmbd: add KUnit test for the DACL walk boundary
  ksmbd: test smb_check_perm_dacl() DACL walk boundary
  ksmbd: test maximal-access DACL walk boundary

 fs/smb/server/Kconfig       |  15 ++
 fs/smb/server/Makefile      |   1 +
 fs/smb/server/smbacl.c      |   2 +
 fs/smb/server/smbacl_test.c | 301 ++++++++++++++++++++++++++++++++++++
 fs/smb/server/vfs.c         |   2 +
 5 files changed, 321 insertions(+)
 create mode 100644 fs/smb/server/smbacl_test.c

-- 
2.55.0

