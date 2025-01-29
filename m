Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4F1ADDCD
	for <linux-cifs@vger.kernel.org>; Wed, 29 Jan 2025 23:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738193979; cv=none; b=apRYlp6sq4YWZsQny7qZbwdeLV9p7VJBdyJJVrtFt0/J7ZM/WEfFtyi6ByddESMiH2T3fbG1ZpACwMm/aboHaVVbmEj0ydUvHkIHD/mzcBt8CnmIzRQENFk6biZNJWIw1u/28+ZWQg3grtP0cTY+9w14Ud70DMABA+xe2dJ9JrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738193979; c=relaxed/simple;
	bh=KDagXZZ0pHyb7O62aFJhlsMal9tQ1N6ZapbGMteIZOc=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=WHfqz74fnlhzB4NJZAhFME8B+a4f1jYdRgr3Hs5CB5xQlud+44OgEHIT9jEMRKvsRpTOcLVZihmeXTFuCXV8vfHEWpH7+DWX0ckpi1L3eViqa5iLDS8vvsepwQ/14hzUlB88hXjRaGf8ueb2ciCvYLUDx+kSmeMKunF17PaFf5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iFTK13ya; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iFTK13ya"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-540215984f0so211428e87.1
        for <linux-cifs@vger.kernel.org>; Wed, 29 Jan 2025 15:39:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738193976; x=1738798776; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=NzHY5KQzT/2uDyL2AmDcsi3/jwW2XlgLGwARBobr7yc=;
        b=iFTK13ya/OUVV9qj5Z0nM95hoNYJyITYR1u7sOYsBAHN9XCMjfUQ3AlG5IL3GiXuqH
         INX81qxIb9gHmfY5pO3v9l8LxCHb1Oxdu57AWrrsEDBRgtHM7PkhKmgyJGeLmZ0+08cv
         oSW7dQ8Q/a993h51nmzzY4PhZ9Aj7w3O7UXrFRsfmmR8qgCw6pRX3J4yzPZY6JcmjU90
         LgnoQwxWZ/gOA+AqtmqrN9hBvjbALBmiERDC7WtNnzr6MWvqOxVey+ntdiSR+bxHGECM
         DQQo5weBbsc9r6jhO4Q1d4FelUB8oh1EfnkK3dEUcXMLBCae5zLHUWpYgaR7R1hY62k6
         8v6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738193976; x=1738798776;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NzHY5KQzT/2uDyL2AmDcsi3/jwW2XlgLGwARBobr7yc=;
        b=Q8qGcoXDlX3W3snx9eHuJzkQkzbMfuOQXxZnt9PRZyYx9r5ARvnRbjyOU/wkB76nmn
         QU3JgzOwiJaMxYEOJPiZLICK6SK3scpPZVyRu1zKCK5NwIzTe5rNCBbePpB/g/+fZnGR
         w9PRBDOpCWqiI+X6QLDIZQWiXnCfyQhXhNo/MMGkJfVQnyq6AD9C3AEK0+rZlLILpbUU
         iwf53AmH+konyJ+6y8E8OTrrMCg8bXOXp/muhbB2bKSqsYfZ69Ljn/2HK+3AwVSRPdAp
         0kkjRqy7fwpkLMR04Z5b1BjSx96bEdelXrgSkUtD4Sz0T8zDtAl4M2S3YxtBfaeLLPwj
         MXhA==
X-Forwarded-Encrypted: i=1; AJvYcCVPKTZySx2vac+IR2LHJFrvLNqfFCDxpDpuu5sMMIsfJ3w/czXDA+/MDz0YlBzRIBfCVffgiEKSO6q2@vger.kernel.org
X-Gm-Message-State: AOJu0YwgnQBfooUe93NDz+oJOfaAdeZ1BqVcedBZlSmfwRf911+iYfun
	t3RNnNWJGBtBt+D878m2TSB8IIVLcYDxZJ31BvNRjAjnxIDGNVzaCzv4F5FHJ4w5exkt66gopo2
	cS119XN1x7KcZail1G+CeGS2wz1ggZQ6M
X-Gm-Gg: ASbGncu0S1bO9FBM87xB0xyM3RvrAyM+rZNmHpmvx+ECmazI3muy3IFu+uyvuJUqhP5
	5bBADPwfz5gO8o4smi7RpsiPwLcOt7fV3mBOrJqPjFK9FIN6wll+fNppmTnXAs/nzp5Grbexq
X-Google-Smtp-Source: AGHT+IFaNLWVLclSY15aqKDpcKAy2ngSz4MDaR61IAyU89DZ7JX1QNZnftx0/QQ1RuxlxkJV3oVxRezG7J1x8zbopyA=
X-Received: by 2002:a05:6512:108d:b0:540:1c16:f2f7 with SMTP id
 2adb3069b0e04-543e4be8e86mr1675306e87.14.1738193975599; Wed, 29 Jan 2025
 15:39:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Wed, 29 Jan 2025 17:39:24 -0600
X-Gm-Features: AWEUYZl3f9DrhHeT_bXdizeFPLvzf2MQFgikugtJzRq3HGTuH11ZRwpA6NWA3EU
Message-ID: <CAH2r5muXhrTc_pa-uhB62dOjQDZR5WBzz4NiVFimVQ=oTysekw@mail.gmail.com>
Subject: Re: [PATCH 18/62] cifs: Check if server supports reparse points
 before using them
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>, 
	CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

In the patch below, do you have an example you tried where server
without reparse point support that left a file/directory around after
a failed attempt to create FIFO/SYMLINK or other special file via
reparse point?

[PATCH 18/62] cifs: Check if server supports reparse points before using them

Do not attempt to query or create reparse point when server fs does not
support it. This will prevent creating unusable empty object on the server.

-- 
Thanks,

Steve
