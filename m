Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18CFFEACE
	for <linux-cifs@vger.kernel.org>; Thu, 27 Nov 2025 03:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764212668; cv=none; b=F5ODgb332oC6NXcYVAGBBc1eFuLMZrYBvdW1yXDUpMMfp5ooKFLGg+qCbP4FOKXtaI0OlhH17XgzreV0ou8qxtlpmkRsPJa3tnpsVHuTPDayWOJrIPRi6Xig3gddidfzth3oaJT/rrUOhdE3MvY+VKm6V4hVRjaIY00ldkdrXDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764212668; c=relaxed/simple;
	bh=Oi+j9wGCLDcvk0xScUM5Q9zHLfSbOM8I09MOZsL1rUM=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=H9eWMpdA2KTjDRwr4d0Is4xrhPozNL8WNN+Mk8Q1ruiHyaODrw8F7Aaq78/QdCqug8sINiq7tjT77VjbsC857OTbpP6z9IWDCcSZn7biY+dUOKzIrQ2KleW8pSLRTBU+HvB2xZS5a17+tzAN2Vfc07xMU8kGOOTq0YQhFtH/i/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bi5qyzDd; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bi5qyzDd"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-88054872394so5595586d6.1
        for <linux-cifs@vger.kernel.org>; Wed, 26 Nov 2025 19:04:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764212666; x=1764817466; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=RmkvG+pkBdrnMEGhXbDsBe84w/bmK7qlSe62Ko9cDnE=;
        b=bi5qyzDdGmxwTdHEk8/rgFshWZPhNnoYxTJOyPnEFRSfnK1mXsc1GAdB+vfa5W+0c6
         uBorgWHwCsMi4l+245s/hM/jcF6tfF3wD7v/cfn4exuMw2G2RvgbmltfB4Y6ONR3c/ho
         ZismO5mXHj2A5LMq/MxLUVkxOqRgrKM0bC6638yXQ9vXxpIkpR3IOrzd5KiLXHnMwrNx
         tDFkFvxEOkIGhElXyiAJJp8XH0+0ensdg/47/CKq3w3U4EZYgjQSq0cvY4osoxafhilA
         LhoFd6KyNfWRiK8plAY6AY2e7Gi3YYq/BH7NCqZwW/p1VpHD65TzG2KMv3nQubGY9dJN
         H+9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764212666; x=1764817466;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RmkvG+pkBdrnMEGhXbDsBe84w/bmK7qlSe62Ko9cDnE=;
        b=HUWuWvD2pscatcuJVDrfwMiD+r4dOSmBVgS3lwt9KRc5mbQFD69OPOlhHzdtf/plek
         vQhDz1xPIcOoFTJZjGV/sUHCqEdkceWD7lhEQVw8VVUhVo9LzbjhEeNyeoLTpJFaBjvL
         nx3HfeL/RgQpVSU82ayuy0fCRsoROxLXxgVR0OeRS03rf/yE/2MCoTY6Vp1PkFpUQrVJ
         8OyXLjVYImfwXqoP/nQXGj0zaVpXnjZk7PugmPef9ewdKAF9jCZS+lCtI8Aj/YRQevch
         ubWFn7QyYylsAgx7JH7tQuhUw9ot0oMalP8DYVFAuhJG+LYEJN1Ws3+H2nyJMzY6Amh4
         /jbw==
X-Gm-Message-State: AOJu0YyVftSGoVj51kN2MDXYNA7bDJ4EUG/OsBpoiHfwKOg/Kdd8YYo9
	onbdlqydtOuR5Ehb+J3kd37RCw8Kch6y7OcQGsxrOutyLvg9PQ5zib6JRYDULSxpGzSSp4a8h+4
	0bdjsRnoQ2fJdwZ/gwMNo3KtaIoVP4fvOuWehV+8=
X-Gm-Gg: ASbGncvjKcrcRVv+3QuwZTN4Do1rBacrr1TsPdvEYPxnoYrgGxNBNf6DMNOjWcfANrN
	PB+4Ur+JD4MhofNIQUNFbP7jkRwjW2258Eee+gblzFBaMwZ9Ueu+Rvj4p8iKy3M6FYTYXviCMk5
	/TCBhEqgvqXyexnsGUUo3QNVVoev6n5UKBXah9bzNOd3eU3w6ifUC3BmERVnnmQlcJPm0T3VV8q
	CqXp0AuE3cYr01mlKPlRjKN44+DmvZf+jgi71KvmwkcfR2JN799zww8pUgaMmqSZvPLtEs04C15
	x9WbmvEl3KLp9wDjb5OCS18Uek0F4pH/DfyzG6R/Z7rLQGcWKboZCEQVBkRFNUr7GtuNPfJ0//Y
	Uuj/q9HB+lE1sj7rEWrojolhF1Qr8emxg0QHKHS+7J2fjaLmZwCZoou1Ez1Ilz84vriYrNKyIp3
	LZ9ImHjaP1EQ==
X-Google-Smtp-Source: AGHT+IGIPIZTR7I9kp6gyE1A108P+rAoLB//+mn7q90FCi7ZrPzRqdsMaelmNCSu5Iq/Ep0GXvJDvwhcvXw37Gx9x5A=
X-Received: by 2002:a05:6214:3f93:b0:880:46b6:fe3b with SMTP id
 6a1803df08f44-8847c536770mr319658176d6.53.1764212665924; Wed, 26 Nov 2025
 19:04:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Wed, 26 Nov 2025 21:04:12 -0600
X-Gm-Features: AWmQ_bn7NVpt6YMkR0-AwQIzG-9Pz_rs00O0-qVLie5aCNFMcnOFApXjOX4K9Dg
Message-ID: <CAH2r5mscsSWyptKojMFVYGS+F=9obcUFoApwQ67cXQVgkCn=0w@mail.gmail.com>
Subject: [GIT PULL] smb3 client fix
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
ac3fd01e4c1efce8f2c054cdeb2ddd2fc0fb150d:

  Linux 6.18-rc7 (2025-11-23 14:53:16 -0800)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/v6.18rc7-SMB-client-fix

for you to fetch changes up to 3184b6a5a24ec9ee74087b2a550476f386df7dc2:

  smb: client: fix memory leak in cifs_construct_tcon() (2025-11-25
18:00:06 -0600)

----------------------------------------------------------------
smb client multiuser (with cifscreds) mount fix

----------------------------------------------------------------
Paulo Alcantara (1):
      smb: client: fix memory leak in cifs_construct_tcon()

 fs/smb/client/connect.c | 1 +
 1 file changed, 1 insertion(+)


-- 
Thanks,

Steve
