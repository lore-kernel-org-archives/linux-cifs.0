Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81D501A286
	for <linux-cifs@vger.kernel.org>; Sun, 28 Apr 2024 23:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714346859; cv=none; b=kVid0vx8FpuqrG9ODC94EX7OfemQwlwGG9fuT81m9KPrkWy1nJPf9nYg/dAuu84EwKuZEetmjScLMDXSbWnsvvPHucoQgnEU970kUS5Q/nIlQsPDOZ11JgjWhbN5hKM+cpt01jKrYFc8jV0LtF4qRE8tVo8fuXHk5ev8Iqrw47o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714346859; c=relaxed/simple;
	bh=agiFaPeJM9aq9Y44zVBTo3fX8dFVI9+0yurDyG9rNSY=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=PvgzkFKeemTVLaf2aQGjg4GHqkFFHLPWxkDQH3r7rsSpJmlCclBpIE8laJcq1bWW1wQiuM2+ULQSbEd5vtdh91LWha43pW5HliOAL0xI4wTU31VHklsrFQpMQ2GRI0KXrhVJQbodCikYbCGUaZg0BKsYwQf0ZDEVFM7/p4qKe90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mzzRCxXw; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mzzRCxXw"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-51dc5c0ffdbso285669e87.2
        for <linux-cifs@vger.kernel.org>; Sun, 28 Apr 2024 16:27:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714346855; x=1714951655; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=luatNR4IuoNfgyneIqHxbPv2CQLL0KOZG1hhq1p9eMU=;
        b=mzzRCxXwVjmAMpJo8L69u/n/sxoLklygQ15EU9mgxTcCCOb/KpE+IIWJzoAspdOSoP
         ABb9eAw5cADqoeed8OMcpP3dSYiEsG/eG+5OSZ87k4ehfwQCWyfZz4s0SGSn8sdObrnw
         ouY4wIKKUhNnAtYPwqnxGMCxQzImtXjmo5ir548vGCuYYDaZMxKmHOdXfDizxAUwDMRJ
         SGNTy5uLinUcU4M7alRd5ypBfQPw68TK9NUGsG9xEHCNxM9uDB4WvgPDSyF08svqg2e2
         /HRvx6844oLcSVJRSkVXtu4zFYwZx9fSEWIeaggXqf3cnwtTG59W0fPcSnCiR/qNoUDF
         gn5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714346855; x=1714951655;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=luatNR4IuoNfgyneIqHxbPv2CQLL0KOZG1hhq1p9eMU=;
        b=eT1ZliIVjxK3iHsoLTPH3MZ5ubrek9saNpJIXpHvW3lae7gfVmlCCIiOxVFyfN0M6f
         IyoSWcA3MVOOI1u7NjskuPMfPS14wiXsvroZEpv7IZLWdkT9obrvG0nDM53Tc1pYTFZY
         paWh5KRyWJ23D/3dHdEMnLNrzkPgdv6ALTJY5Lbj30019eSq8o6w1YGJg1QMJsXfizQt
         ySPAe87WLoJMImxSTa9Zsk0mPjWM2xNUd15EmK64w67eCnJl97Mq3T6CD43xZmaLXHn5
         HlZVD78RUH9q+anChvKRmbTefM5lMB1jpMmH8GoZZJqGEELUWPHaWWHFOXefF+MvPLqy
         jofA==
X-Forwarded-Encrypted: i=1; AJvYcCUlUQ1KMMR4jeh9VpeAZM4i4AW/rIxiYHjfOXR8lRSBbFahXzORi7/P+e77fKjKuhwqYgGdLc0821AuRRXHAfe1LVzhnQRWxcMLzw==
X-Gm-Message-State: AOJu0YxNqT3oiUEWwGBvL3Y596BuQ9jGjF8T5z+4pjM191QuVLbVdv//
	v3oLi4plnjdSHouAD/dRbqivV0YtTCnXKPMFpwr0VhwzkJQoFR0kmNnwReINE1OYxJwPpBb2C4n
	C+f0368sO368KQIu6YISme91rJG4=
X-Google-Smtp-Source: AGHT+IEUrE0dDgyDkIf65sRh4Kr85ga/ueRCM3qDBR4GF89S8UwABDnr5ervspot3qSE2KCkt35ltaXNdzjsChjl5Cc=
X-Received: by 2002:a05:6512:33c9:b0:51d:8882:cd69 with SMTP id
 d9-20020a05651233c900b0051d8882cd69mr1926831lfg.53.1714346855161; Sun, 28 Apr
 2024 16:27:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Sun, 28 Apr 2024 18:27:23 -0500
Message-ID: <CAH2r5msg91ad+K+eZmCjKCJeDgyb6xcUUhmpaXeeTFjqFZUeBA@mail.gmail.com>
Subject: query fs info level 0x100
To: =?UTF-8?B?UmFscGggQsO2aG1l?= <slow@samba.org>, 
	samba-technical <samba-technical@lists.samba.org>
Cc: "Volker.Lendecke@sernet.de" <Volker.Lendecke@sernet.de>, Jeremy Allison <jra@samba.org>, 
	CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Trying some xfstests to current Samba (master branch, Samba 4.21),
they fail because query fs info (level 0x100) is returning
STATUS_INVALID_INFO_CLASS) - this works to ksmbd and I thought it used
to work to Samba.   I do see the SMB3.1.1 opens with the POSIX open
context works - but the query fs info failing causes xfstests to fail.

Is that missing rom current mainline Samba?

-- 
Thanks,

Steve
