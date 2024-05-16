Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9AD010F2
	for <linux-cifs@vger.kernel.org>; Thu, 16 May 2024 01:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715823806; cv=none; b=PRdFchgoieJ9AtruNdQsYMaWP9l2Rrha+nYzdNqExtxSj72vJhXB82SsLWUBV1wthYyrSsIRLNoUYodefjPcwA+3WGtNzhWGGqbwyYlx/bb9xevEXP3uxCwxhIc2lLXFaZLUrhCDZccsFA/V/Fh0FAhXQUfs6ENHAKTW4ADT0Yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715823806; c=relaxed/simple;
	bh=XPCNpHK3vtiqccQwtXw+RsGa4JHqVkcoSJs9/5Av2yk=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=FxuMzSDCyDxxyPXhw7awFxZyB/uWhlDkwT7yzXyUkVOn6ASYCOj3r4tUSWnnbiOoYPFoP8+m5bwMmykzuXB2rBQdR01tnFxUhIquTOGfq0OijOsafICsOTVOwQtMYKPOYXxpBAbz4xCrycil3ylNeyymBVH5jP5p7OxbRLezyd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KN/hY1SN; arc=none smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KN/hY1SN"
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-2e6f33150bcso2112851fa.2
        for <linux-cifs@vger.kernel.org>; Wed, 15 May 2024 18:43:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715823802; x=1716428602; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=u3judt/okdZEpTWQG7P5QjY2Ucn05f8XAAVH2tdvUAg=;
        b=KN/hY1SNFkh238SUaWK9q6aNSSJ4VZ0o+9YCx2BcvgxTnGEpfKvTPzO3qMdlmr3RQs
         e81F9C3HCtoxIe9aw1J55KIi08I5XuocbD8xcYtJ+0ztNNStDgv9F8ZsTP08oEROJNZo
         LSqxEVK9KztXWsTBtDUuDU/89Xx/htJfWQieBCBFl7OE3DHJmcufZneFSkiUueeAbZ0F
         c8CIYO/f6hk6ZZaTyNTZqWudiSlPAYn2gjb8mey7kQkN4QLoW1ga2tnl8m0z34GWNCE5
         MNKl3PEb/W5sBcu1GSm9XwHmYhnjCxqOO1OOYxb0Ve5h7sqvT3h08VxqXistB65Ag7og
         8FGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715823802; x=1716428602;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=u3judt/okdZEpTWQG7P5QjY2Ucn05f8XAAVH2tdvUAg=;
        b=mKVTOYkKYy8OkL8oA5IEO6O9XP9EKeXhuFfZwIcrfCw74uBauQFxCPcNO3wKMNAu8d
         JwD+dDRX5D259LH1znM3G5BZhY/nhnV53ULH0cfiXhIWCKwovGirfPl1PhxP1hsKfx9C
         bxlz7jfiBE/NWNrm4gMgMzWVr4IhTBgpHdOTH+e2bleMaDwJj3+DDoNrc+YF3HrwqVAD
         IWrMXjdqEnmYQonpDhNNF2juEraLcnKRsQ0P17xHpfqlxT1FZYrqNjv8kbaxZPWMh1rD
         EA+4rw+zGBH23X7NQ4ox6ZvIzVQdziw6b92v6VHeavfRqOOPFyNCZySEE1O4kI2FYfL2
         zgyw==
X-Gm-Message-State: AOJu0YyiqMeZpUx3lqli9AXKMeVN2AUKBc3RvsUEV898D3/kenkhOOMg
	ooauy0TM4AKjSHVdfaf40iDIU3M5e5FzM3bTY28JJIb58195Wbk/m1VBwoRE7WE+GKHicaPY5AR
	A41Q29VmjT2O3ObO1HwjoGX+FsMQ=
X-Google-Smtp-Source: AGHT+IEvUSh6u2BTP9Db9DBdaIJQpf4lu0M9OGjBA0qPg/8Cnaf3WOWNzetsLRMUZNhm9xOEDBxWmYnedMr0il3FR9w=
X-Received: by 2002:a2e:7307:0:b0:2e0:83a9:e388 with SMTP id
 38308e7fff4ca-2e51fd2dd5fmr122401641fa.9.1715823802081; Wed, 15 May 2024
 18:43:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Wed, 15 May 2024 20:43:11 -0500
Message-ID: <CAH2r5mtT8guLLcLSeuHyU_7pGhHT=Sr_CEuMJSCOj0X4SEnVTw@mail.gmail.com>
Subject: fixes for netfs regressions
To: David Howells <dhowells74@googlemail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>, Enzo Matsumiya <ematsumiya@suse.de>
Content-Type: text/plain; charset="UTF-8"

Looks like the recent fix ("cifs: fix data corruption in read after
invalidate") addressed most test failures - xfstests are looking much
better.

http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builders/5/builds/129

Test generic/708 failed (and possibly two of the git tests) but others
look  ok so far.   Good progress ...

-- 
Thanks,

Steve
