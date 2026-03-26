Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FAC8377EAB
	for <linux-cifs@vger.kernel.org>; Thu, 26 Mar 2026 20:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774558760; cv=pass; b=uO9clfNyf2JnLyDMjc2UPzsy4wx4OOPEZkdCdYnwevhT0Nqe6aITWsu7jo5ewWhh31rcTBHD2xBuOK3ot0BhhqVZgdbGePIwCgdWhw8qPxpAP/Qah2TRSXfkffiYvFNIqYcws7dzp4/RVOyS/B+O/6JpdcKB7ArVd3LDT46JIDU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774558760; c=relaxed/simple;
	bh=qz062xzaQFbhdnPBWm00N7J5eJvOW+WC7CdqQtTLHwk=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=e0JkfNVzJ8fOf2RSA1SkMtmuv84U6c4oQEkb7HZFLBF7GdlSZKxvmW1YxmZGVSGd5ThPhE3cVwY+3Xp4QBJaaaZtGExpzdjX5sZcjElrl2vR5ummMSDPL9sJZQRvDA7ha4bx6PD2/l4haU1OEOftwTKn9T8CdEYpZ2tOR7vFTqE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BehiC8/a; arc=pass smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BehiC8/a"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-8cb3bae8d3eso152016085a.1
        for <linux-cifs@vger.kernel.org>; Thu, 26 Mar 2026 13:59:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774558758; cv=none;
        d=google.com; s=arc-20240605;
        b=NEsT4z8aaPB76jk65gsvEI9qo7OIz8kCNUHT7C2H+p82ZObGQCGLlnxCSDzv23kEh7
         6MDIzRGXsyzoyeE1P/ERzqawSEl5u8AsGZC1pEko7EKOR1Cki2gn3O4bqXhxR9j+CZQ7
         6TdNM/mV2p3Hr451cQ9xP125GcbvQGTe2cAQs2EgiKGaN6Nj1r7Ycf6dZ7+BwvQy2fhV
         xQrrZbcm2L4jjNtvBOHKGghitksHZa23Wq4gN7IFudZ3fjbzmTRzbDoibfm0Ll6X9/0s
         ZzwI4ovmcZdXu3Q5GuafA9DpFizCK126qmxMSHNfZAcZ0UsqkEpxeUfowqAMbr88Gw8z
         iViw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=Vf0DGXgj3CngRpqwXUDDDnumaqPxpfHiYqGWP/wX68A=;
        fh=qEeK8UOyM3B6gWgOt6w2SZpz/gHwVhiaSau0FYPfxnw=;
        b=NzkCdqR52wZh7hQj1JF54KCbqFk6szyRKy02j+sD74lnPh9daqa30SloHVgQDIOXwA
         Beke3uu9dMM194VLtZN7PrjckrLJNNMgAaPERE/vk30R1XdhMgnM16P4pTZYj3wor/31
         LkjSXRXiTg8og0YC4jRY6JROImKSr3TuVMd5fM8B1pRqiEc7CC8or+GL/xj1BjlSXUoj
         4XDv/+IEp7wYXZbq/UcKxpctAhtYuiOr24ud5QjQJ/dS+F5+6XtIPYb6bRoW64nhOERW
         bAsfFqSFKHK0WYrpcBqABqG+KdT3VV+swZ3xQQ1e/kkcbbEM/z/ZDop4YGD0AXYIz+ZL
         aQ7A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774558758; x=1775163558; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Vf0DGXgj3CngRpqwXUDDDnumaqPxpfHiYqGWP/wX68A=;
        b=BehiC8/aNtI0u4qZIS5BHrI17+n5BInkK94JhLRd7J5WEMuiT++n/P5A2yXSB1Yhll
         6Q2poY8QT0QWs4YW+poilTjvmMT+jCVea3ndqcXa1wP85RcDIeu2D7c+qtf4JXtydUZe
         92xzS18zcfV4AfGY5yWctkNJpyTjcNgbD0IhJdUNVvR758ZGXW3PSXWFXbDoy1LQMOWK
         cu3jWo86VvMRXT7Q/oS6kHpu0ePPHunWDiJqMNElMDtoUrOV9rwcUleQ/KWOk4hbkL6I
         /xqE+cDZoTVbtqC7pghb9gaiw8sX7BWu/A9QqW8elMA9FYzRl0HyRiaLolex/I93umg6
         lfHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774558758; x=1775163558;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Vf0DGXgj3CngRpqwXUDDDnumaqPxpfHiYqGWP/wX68A=;
        b=if+kLFpqIwitRleRhOaIbj9YXmEqhhMAOm0RaUklICLpf/gcfYwc1NTLY6okzpT7zA
         6Ct7hNU7zUV8d8dwxAlBJZ8afhnIUiQICwbvRdyyJvQlrBXSJcB69GGtHBdXdXZkIGD1
         L69rhovkrrF7Ykjat8FJZLOS/cH9gGBxTZCnxz28OtPZtZ0Vv8gLn6i7n609YuiOm8NH
         CSgAAXk4mWaG5bHNUxgs2IWuJwxsj7yaexOEGo2EJsZ76Ux1Wos8dI9eP6w0qPjHtrhc
         K74yTrVfzjz19rRtHQDPbA4vnK5d2ffDVL2w/VmJcKgD78C0uvVO1gpkQK+IS46ZfJOB
         1RPg==
X-Forwarded-Encrypted: i=1; AJvYcCXvcybnBGoI86qWNIvteKFdnFz10qBrjgNsdtisEC5N9T6A8zkGNhHPRl15OEe0wBiPTS7FLN+Hk8U3@vger.kernel.org
X-Gm-Message-State: AOJu0YzFbRkndA+0jaomJhFkugTAM2HrQt0F4OfLMXyF5ytnMSfJODgp
	wE0pv92Xf5nKUv5MLHs4IMWHOkuSpJj66OPlvP3LzPno3h53DrrIzNRfnT3YphBggpf6H9kRtev
	n1CBtDQr1n8/U6U4syStXCEtpQ3XvbiM=
X-Gm-Gg: ATEYQzzt2TeDOOk2HlsKi8DuBtfAR0q2SrRwZbFR68X63DZ+BWFC9gNv8TkPc0s/rXZ
	hOS7It4wIgI0eSVQvwZUoXQo6BlNi68lQx5x8sgXVLcNgc1Y3Q8clpaPVG0yiJ2x9TKOhqxaf8K
	m/QFXneKGsW+cLLW0J7aue2frrxSKH9OEBVJiAzDoygSkOf7jgkRAqv8HPx/ri9mkGsaVfuuzVo
	Vf11WCkliIVjVDsC4iCJNQTZigv9UihXKgD+HfnVjk5CeMgRNJhZmZRpVVNlCTF32jCWXesjpQr
	TtaWABWSKTUhY5Hlwo0U4A57HCy3p8vhT1adNWvVs75bIIch+rq4WiNAtQLUnjEiof6Up8pW9t7
	ZBYoTnsiu2icg8IUBStBG1n3dJ8kmy0G9zczeSAktYhsnFxtOgfZghNigPtU3MGvJYZN3hFnKet
	/+VAld+jbyZai6xnxb1GHU
X-Received: by 2002:a05:6214:212a:b0:89c:e77d:1399 with SMTP id
 6a1803df08f44-89ce77d197bmr9211246d6.22.1774558757996; Thu, 26 Mar 2026
 13:59:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Thu, 26 Mar 2026 15:59:06 -0500
X-Gm-Features: AQROBzCLHMw1w6gCTe-3D891CswWU-5frH-sSJ5xczIfu7QEuwn3Ak6z1ITZ2_M
Message-ID: <CAH2r5muw=UrEBvucGa8OrT_3tE4zXpGKO+d9mU7unmbTw=C=CQ@mail.gmail.com>
Subject: [GIT PULL] smb3 client fix
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
c369299895a591d96745d6492d4888259b004a9e:

  Linux 7.0-rc5 (2026-03-22 14:42:17 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/v7.0-rc5-smb3-client-fix

for you to fetch changes up to 34420cb92dbb9e37ff6c6603f4f5e1807db3f1de:

  smb/client: ensure smb2_mapping_table rebuild on cmd changes
(2026-03-23 08:17:26 -0500)

----------------------------------------------------------------
SMB3 client fix
- Fix rebuild of mapping table
----------------------------------------------------------------
Huiwen He (1):
      smb/client: ensure smb2_mapping_table rebuild on cmd changes

 fs/smb/client/Makefile | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

-- 
Thanks,

Steve
