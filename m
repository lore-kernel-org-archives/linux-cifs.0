Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11BF125764
	for <linux-cifs@vger.kernel.org>; Mon,  4 Mar 2024 12:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709555019; cv=none; b=PUgMmf4ULpssxvhk+jUdlED4KGRZI0eTxAub7DfrRpnOlYlLVKZQ/nEWeLxWI0gatVOkx7zxLT/0OrUjmHb8XtWHlT8zVJX5LZSMvUxoVanel7R9uEf1vfQI6Fb+e0IefX0OQhgaUJFhZPHanBtCZUnxvS2Zdq3aDB1ekOUllnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709555019; c=relaxed/simple;
	bh=EXenmv0/q0mV/dDQ6PMX6rTmD0T28XkSu1+mJ1GWpzE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JWaXbWUSmQiTyTsQg4KRxeSaxMWOh7LKMsThqtygT9mDmIGJlpGYaDXIU8A27oy+HuC6cMrystyXS4RRknZQXoQ3/bUaNZj1t57fENaR6/0unoNQ/LooJc8JjsOdbOpmbW8trgT9tGMgJCA1jr3PQZ9/JoRWinisvufwEQTcuks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NS5W5C5k; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NS5W5C5k"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-563b7b3e3ecso6688276a12.0
        for <linux-cifs@vger.kernel.org>; Mon, 04 Mar 2024 04:23:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709555016; x=1710159816; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=pzFgQunS0YCjbrNelt4MFei0I8t6kgpOJqjf39sdpoU=;
        b=NS5W5C5kOorU22R/UcGGmXB3lPeNrBpXmo4xssC01Zu0Syevj7CsRfjbAeM3OB3Frg
         BqMRjsN4HydPaQkY6gt6gQrj1UyN79GoEbwPZvNRR2mP3+43h3IgaJCwGbGNN2lyBKll
         AhoeTPshKMgcHaWHUpEKPs3NNjxkiJtPIFYF+qTzu1it5Egsr/+r2fBJKqTULK+wtx80
         FG9DmNS5HQHColmcgd5I48jHDu5TvTH4u4uEu3njMNIRp5cHnC7gqUkAdPaxqUKqNO+A
         sNjSs3isPoP04lK+MRZockKuqhFNzUilLQmAp6CKhA/Qk9OQWJ/FDgbqRGiCHziKlk1J
         7qhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709555016; x=1710159816;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pzFgQunS0YCjbrNelt4MFei0I8t6kgpOJqjf39sdpoU=;
        b=kmOUrZxDW+dcCYGUBsYikc1PTNLUk9bI8jmJWWjCuAnHy8gb0bLUPQO6GW3h1KK5n4
         CUWkkcjZmHyP2jRjEERX2AFmdS+b1jfMErWYWL53hnMzxoHLil6sTKHaWaVQqq8G51ju
         UvdCHc3pleduBn3hfZMKH4sW74n8iTWicX3lHv4BuvECZsJN1Ip+1THUl/yq6IhzJ4vr
         Kp1UT7+34H78w6o57RE15NTkmCWGraUjmMMqbyj0bvO6Xh5FhZPRM0VYbAbHyHQvMvel
         3Z7g0E7GXKndu7YE+3M9h9ylgSWbV5pyMLD68kv58FjvhprmYviF3kGi/6+yImJxQ4S7
         6DHQ==
X-Gm-Message-State: AOJu0Yw/MbCNHwatB+xTH2XrGQsZfVyBn8P1MChoxg6wXgGqF7ID8vLn
	NLGDxLNAyF+6u/428OLmK2pm/yhX9KQw9Jmi9VHeCXAe2hUz7uSK7Z3Q+Zs=
X-Google-Smtp-Source: AGHT+IEF3JEWZhIHVnuM60P7+MvarFKAx3arJFs+G8QIiJkn3dSk7PxEaTJ2I7EhMoQWyvyxoul/9g==
X-Received: by 2002:a17:906:6813:b0:a44:51d8:7dd with SMTP id k19-20020a170906681300b00a4451d807ddmr6288212ejr.0.1709555015909;
        Mon, 04 Mar 2024 04:23:35 -0800 (PST)
Received: from torus.fritz.box ([2a02:810d:b83f:e400:16a0:2f96:e202:fd52])
        by smtp.gmail.com with ESMTPSA id tb5-20020a1709078b8500b00a4329670e9csm4739841ejc.126.2024.03.04.04.23.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Mar 2024 04:23:35 -0800 (PST)
From: David Voit <david.voit@gmail.com>
To: linux-cifs@vger.kernel.org
Cc: David Voit <david.voit@gmail.com>
Subject: [PATCH v2 0/1] cifs-utils: CLDAP-Ping to find the correct site
Date: Mon,  4 Mar 2024 13:23:00 +0100
Message-ID: <20240304122302.96156-1-david.voit@gmail.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi All,

we had some internal review of the patchset and I had some
misunderstanding of the dn_expand call. Thought it returns the
uncompressed size, but it always returns the compressed size, which
easily can be transformed to the next offset. This code was so or so a
little bit flaky, hope this makes the review of the rest of the code
easier for you guys.

summary of changes from last revision:
 - use dn_expand instead of custom implementation
 - check for minimum length in netlogon_size
 - inline read_dns_string return value check

David Voit (1):
  Implement CLDAP Ping to find the closest site

 Makefile.am    |  15 +--
 cldap_ping.c   | 284 +++++++++++++++++++++++++++++++++++++++++++++++++
 cldap_ping.h   |   9 ++
 mount.cifs.c   |   5 +-
 resolve_host.c | 270 +++++++++++++++++++++++++++++++++++++++++-----
 resolve_host.h |   6 +-
 6 files changed, 551 insertions(+), 38 deletions(-)
 create mode 100644 cldap_ping.c
 create mode 100644 cldap_ping.h

-- 
2.44.0

