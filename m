Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEF19137C37
	for <linux-cifs@vger.kernel.org>; Fri,  2 May 2025 05:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746163159; cv=none; b=WAFaNC3D1QpeC1jA9vdo0dMKEmCC14zYWAk0Vdzmf3RlCP9yvC020FFw72xK8r60hO+oZEd51NAOKxC51EmNdBhbxK4ESXWNBT3y4q2lYpLCQQZ0m1ZzS/jtp9QBfmhf985LZ63BnKKUIcAz0w1I5EzJhqhx2R06s8YVhdRhDc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746163159; c=relaxed/simple;
	bh=9KsOxsjHcVJ2aNeMpK1eYwrt1mGHaQ0cJzUPwoM3uss=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=apVJtnXtaxwg1plGxV8rBNnNHQC5Vb6geIhJSqWNSmy3O/gj4FhCm7AR/my9VtLx9xC6dPScJf0MUVlphm4eGGTshHbhUe6/qK68tCjb/HAcoVsGuh3dF7zf7/VRA1W1PRQFbJ3ienA1ZVkfnwyxDU5PibLgbn+CZC4YEnMZOpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LxyHLMeH; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LxyHLMeH"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-ac2c663a3daso304351966b.2
        for <linux-cifs@vger.kernel.org>; Thu, 01 May 2025 22:19:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746163156; x=1746767956; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=p+VgGBCNW+h2LxeDaG8YR4r2HjIUH1OIV/+wmR9eSs0=;
        b=LxyHLMeHhluQ1lYv8u0j4Ffx3rYZP+MxyAS7/VbFZdQDV8g0pegXGMdnMmJRBpu0pt
         HG7lOxWu4eR7TNdD6xpFmcTGxVAkJGUulKewTGDTxJL+wpoCNVAyI0gtlIa2o1G/HghC
         QJqRQ8doaDGCZxcBYM5gx3ey/hpd6berBu35RnQNudkq6t6Ou/kdEsRmAK9l5DnFqDNk
         +UtjZPO+XdOz0PYPhH4edEO4ME5WgCkfpSpcZNI2tGqdQ5yHucxbvepr30h4NOFafClY
         1/v1BoHvLS/6yz9Yt4fG8sHsKgGXRTTD6wvNAAD9RSgIQxv7MpKfN1jZlLmy5eXEjE8B
         LK9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746163156; x=1746767956;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=p+VgGBCNW+h2LxeDaG8YR4r2HjIUH1OIV/+wmR9eSs0=;
        b=TUdidBXd7qibRuF9IdzIwdYyzC2f4YebH0FGC7fG6Vfmx6XQ/PK8p044cvBox05La0
         dmlj5+lWUGsUEAGPw6grDXQn+FNcddriJeekFTsdmiPmemXboju/4OvEaWvaItSCL3vD
         F+TpibRFwn+f2cYz0rLql74W9a2VgudRXTv2ueQopdN9UyDOCozHaCBSndUmSWYxcytx
         CL4bap8/c7VevIYIXl+oguDJOuORuBfBpI5++HnuEzeLCGycfK9sUILErMreHK1aYKyK
         oPPClO6XZv7+0ss0SMRN/KcUn3x/pMWVlzJQS56FyBy0gtzMj56nnxR8ut3wly23DdJD
         e98w==
X-Forwarded-Encrypted: i=1; AJvYcCWsJ424ZYFsFq/2UOQBJCeimO7s+wZima0PFArWUQ3p5Fh8+0CvXxyy1UUNkmNOAti3LgdjzlJu9GcL@vger.kernel.org
X-Gm-Message-State: AOJu0YzBvlPxhjVMydvIaTCi2S9DiI6YAVubzyhSlOHkET5hEJJuC2Ke
	NuNXg2n8t2tvMTlgd86nceHrHMYDAe9VuRKNKShgEUZHRwizIn2Okdo7CgnfOj0X68a8Nt5cePb
	5j4Hh8Nr2mP7WxhxwG1icTTH0rF8IJXj8x5E=
X-Gm-Gg: ASbGnctFFqECBbkBNbO5IYNZjoOYQKfOBQDjzGF7mmUAkDR+Vxj0pRhzNB1NJjIIIa9
	rnTzV92KXYhWrrErkwF9L1g9/rzU1eb/M1Q88qD7r1tN6m5r8BdHwz+qb+ZApVfVzAapZAqvp1c
	6GTBpyc5sNdykiwaZf6YoRJUGssbDMSTY=
X-Google-Smtp-Source: AGHT+IGAQo8yjPMVgpcgWst2VZ8okKs++9gMsLXnR9RDK/ATfUDjkRIjMfM1rFORHIuWr+PxQc+wWi9SzAKT3olGe4Y=
X-Received: by 2002:a17:907:9494:b0:ace:cb59:6c59 with SMTP id
 a640c23a62f3a-ad17adfa82fmr148407866b.32.1746163156055; Thu, 01 May 2025
 22:19:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Fri, 2 May 2025 10:49:05 +0530
X-Gm-Features: ATxdqUHIc8yLZaqqvxO6Sc5Xm6rKURYyhQVCDIbz1CdmVz-szERgdVe-zl-ulwU
Message-ID: <CANT5p=r8zhQqerUJrno_0QGxw7T0En_kmH31ePm=FWMAeOHVPQ@mail.gmail.com>
Subject: [PATCHSET] Fixes for directory handle caching
To: Steve French <smfrench@gmail.com>, Bharath SM <bharathsm.hsk@gmail.com>, 
	Enzo Matsumiya <ematsumiya@suse.de>, Paulo Alcantara <pc@manguebit.com>, CIFS <linux-cifs@vger.kernel.org>, 
	paul@darkrain42.org, ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Hi all,

We've been dealing with a few tests failing here and there on the
mainline kernel for a few releases now. Since some recent changes to
the test infrastructure, we've seen a more consistent repro of the
bug.

The bug shows up during umount, as a splat with the following:
BUG: Dentry still in use [umount of cifs cifs]
VFS: Busy inodes after unmount of cifs (cifs)

I added a few breakpoints at dentry get and put times to conclude that
this is a race where the dentry get races with one of the worker
threads that does a dentry put.

To fix some race conditions in this code path, I've submitted a bunch
of patches. Also, there's one patch to ensure that the laundromat
thread now evicts the cache in LRU manner.

Since many of you in this email receipt are involved in this code
path, it would be very helpful if you can review these patches.

-- 
Regards,
Shyam
