Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED20B224225
	for <linux-cifs@vger.kernel.org>; Mon,  7 Apr 2025 22:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744066403; cv=none; b=vDuiLXrfr0PfFnE9Jp3TFA+5yPpiLfLPYJ3bMKNbOw6tPO1FQI168cjkO17C0UxcEyW7VH/7YCQH1CzF8yWv7c9Xw3mCTaPaxLQ2RjLROacnWlGT1ZWins8cQG8qbweDKQioUZKhZdE4ImXIUzzICbeFeI1HguFbHSCKrJDJAAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744066403; c=relaxed/simple;
	bh=0PkdOxW+JgS4vo687CxpnLtF44AuHHpesCiD5DhiqGs=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=QKPM8QxZbgAsOnOrpsk9Cdy4jAKhvu8FB4rYz0TJxoe9htYxW0jZqzfmQBcddbpwbqrudj4zDsSK/Af8i2juWXnoyzFh/NmFv5g6VjE4LPunJ7d6sLq2xTHO8u6lIIiTOwome5yQwz8EFl+vHjq7cJMA2MrMpkwSKtFcwrKJgCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Lm0SHtlW; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lm0SHtlW"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-54c0fa6d455so5918046e87.1
        for <linux-cifs@vger.kernel.org>; Mon, 07 Apr 2025 15:53:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744066400; x=1744671200; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=lgyTDRV3+D0TEWPlmpM2qZseCuR1ojGgUYKC6WFwcgc=;
        b=Lm0SHtlW+DgaUwf0brfIrYp/H8jw7oB0PmnW7sJAugCgUsdShL6dwKoj0A0RcM6896
         LuKhu63wXSd23lml4Mk89y2Ke4XzRlnbkhZbbTWZ4AOXxCD1hhz2obTtedpwTndyCHj7
         lB9g+wKQigEaGPQhe8j1ljRwxgHhfBKAIATvmZ90tNlRavwlhTdvPrQWQKURyr4faE3v
         GHqUWjPvrn8CjEKgsMxoSgdWuHpopiM03czCuBdNjSBhV6jwR7zl1NnMA+/E/GoMU2gm
         Fue6EHmWs4JPUcZLTj71GxfZChuZxCqS7GflVAmGY+mY3s9s8cZWvStrW2cBzYw+SPMs
         +xgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744066400; x=1744671200;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lgyTDRV3+D0TEWPlmpM2qZseCuR1ojGgUYKC6WFwcgc=;
        b=R2gWkzA2KpAde9REJmJdI1b0ZyQnK8NA5fMBAb949lnsSbw0++TmRH2jTpa+Nr70Ee
         4yP8s9/qCljBjUu7UA49WAaZDr4NCWe4XxnHWm7ZxuUEn6uAZ6AgSSGauEKdx23GYIOx
         IyGmLNSvvVUqWKCXfLDQ1IXJsSyQJSwePtrk+30FpJ83/RNqkgFLJifBx3FU7KMxqb26
         Ex3WrgO0v5NuKKFXEshngbaCDrjJ/336ulbDuh9nXES/vTafekEmBYwjL1fjXnVGJz05
         qwOPZy7zVZXKZRlHvZA48CJI322Ys9lB1cnqv9kzPww8aTtUEHxOa1aJ24EN+AfugbAY
         YepA==
X-Gm-Message-State: AOJu0YxCmezzGVvoGzXkfLCtXKLUjt2ARSoNJUOv8wZGOO4/RLHivDrL
	A0/RLRAoZHcn1kgVwEXEUY/SW1uF9utOM1q0rQ3FzXKP4wgKKE8rZhsCi4MaGNK42z9IM5m+URc
	S82SLWCrZ78tLOkCE5d0GfaegFVGNSHO4
X-Gm-Gg: ASbGncvSqOHOs2nrg0Tx1W/Tj+BC5nmk6wQmqjeewmTncRT74bF/K5jeur1LzvNvQHH
	ztl/UF0/c8lwzd5TO06SrZfT3I/Mk5C2vY9fCEkvsyAYBFz6vmNpIqX+uYrIqnv5PYh8sLcKOsm
	+8SOnxXigzAiUSlVMmk3JATfeFxws/21lndcodOZ9/RdBMSYjwg/Poq5srsSZWDIiI5nfd9O8=
X-Google-Smtp-Source: AGHT+IGbP3mjwEpDkhlFh0EQZrjFdqWIKAXA/k2zDGHpmQyyOdEbni1ojG7dK6yEQJY3dTZAtQEB/B4MlKZo8DS1iVA=
X-Received: by 2002:a05:6512:3048:b0:549:b28b:17bd with SMTP id
 2adb3069b0e04-54c227f91c8mr4028875e87.35.1744066397737; Mon, 07 Apr 2025
 15:53:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Mon, 7 Apr 2025 17:53:04 -0500
X-Gm-Features: ATxdqUHSX1uqv4A6TUVCjj6kCt8cTGI--skr_m_O-SInoAH9zDgNhNxNEDedwmk
Message-ID: <CAH2r5mu6Yc0-RJXM3kFyBYUB09XmXBrNodOiCVR4EDrmxq5Szg@mail.gmail.com>
Subject: netfs crash in current mainline
To: CIFS <linux-cifs@vger.kernel.org>, David Howells <dhowells@redhat.com>
Cc: Paulo Alcantara <pc@manguebit.com>
Content-Type: text/plain; charset="UTF-8"

I saw netfs crash in current mainline (running generic/249 xfstest)

See

http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builders/5/builds/419/steps/86/logs/stdio

-- 
Thanks,

Steve
