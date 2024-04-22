Received: from mail-oo1-f42.google.com (mail-oo1-f42.google.com [209.85.161.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E696A5025E
	for <linux-cifs@vger.kernel.org>; Mon, 22 Apr 2024 15:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713798657; cv=none; b=f1QQz+EnHUMIugYcd9zpjSOSiRucjE8BG7fepPil1RIzdSseo4lVBAwj4HwPGH1altNhPb4VBbu0d++fdjPpJKxjGBAhfW8frxdIH1bhlIjILO0XmaIQ591NrZclHuW5+Yr0oZfal/Wz6quY96amSuxYjzUE2I2xa7I1FwBcA80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713798657; c=relaxed/simple;
	bh=v5Wqemlgs2ag5B1gNimLuB61AkG2imLgIlmzN161pVE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nKbugL48D9bVpiwjOqYk3zHSBGzbbxb54xikmDMzuNtZhGo7g8V5S+kZP4ma9eP+UnsIyeH+RB4SoYtJ2TRDVunq3TF/fSfVa8gNajbamvqij0q0+iakvTrmUxwN73IlIkR+WPS+IWKssk602XUZ0aazW9waAv2wP0n6tX+mUF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UXQhacYN; arc=none smtp.client-ip=209.85.161.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UXQhacYN"
Received: by mail-oo1-f42.google.com with SMTP id 006d021491bc7-5acfba298d5so1849745eaf.2
        for <linux-cifs@vger.kernel.org>; Mon, 22 Apr 2024 08:10:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713798655; x=1714403455; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=v5Wqemlgs2ag5B1gNimLuB61AkG2imLgIlmzN161pVE=;
        b=UXQhacYNYGs7ntVriIGITDX7m98+DAZGBAzhpkQKvtD2sD2rmXsgFDpTUXgF+YuhdX
         2Lc722veC9QOTbcEZ1OK74rCpyhT4BihJWmSpfq9VEP9LC08SHbPhFFXZS5q/jO3YgKI
         UP4bXz2lnx02WRN1xfii3mm8Lm9ZI/2RLypi4yWgdQqK9uYi1XmUI5r6bQasIR9Ix+2v
         ssajs3apPGbEqoH0mg4Zu/pjs04IfeDcojGSheOyBua2AHENJzC8li902B+q5wh61ZpQ
         Q83AQvyvKfGw1DzKIQi5YOGR+TkBeSLaSAzxt7CGSGQUW1P5cxij80OzRrEfOsIQQ6ul
         JAhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713798655; x=1714403455;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v5Wqemlgs2ag5B1gNimLuB61AkG2imLgIlmzN161pVE=;
        b=nhdnJi+07/7C/ma5tBfYQm34doLq1tj4vPw9kswRQF7BUIJq5hLS2U7rS/tLMcK5HT
         /hgyVCS8rHv6XEK4C3DU7gifL4z5vuE8jxU4Yr8duMd5kanyvkPKJqYIm9onapDKhLv5
         FbS1gc84kkFwpweY0qaigYnniCGAkjkvwqdasTDpwDK8MaJJxa0LgJmd3TmNN/q9RVch
         2BX8plkP1XxqGTLe+4pEHtPtsh7xs38yIQzmpyP+Rs1TvvtRj6O4TM/iiJknJwBOmuVk
         J1E8j+RqEbiaZ8gDAijdbeV/XMM6zjmCrKXCWk4ppi62O4tLKJiTjkk1bbKNhpnXNYF5
         V3+Q==
X-Forwarded-Encrypted: i=1; AJvYcCUvMfdULWzsP4OPWaXEsG3XXAeq6Mz1OhmRqPT8ct5oZVVd8qbaeqcvWAAdVQn6Tg54SQXv7X+yQgwkCSedb4J0qh1GgNQnS5c3Jw==
X-Gm-Message-State: AOJu0Ywi24tLNt5jvvAKgJzVEcpcJjARo/GCO56Uw4s7jF8/4uQQd7LO
	8D4fBHRI94fwFAFwplgRUsawfSGUo70vuDK/Sk0PlxRpTqOwlxDbc7xAgqUt2pHwBZ+wvYqlfWk
	ROsp2o8+EhDpheYcaw3FILKYae/5C
X-Google-Smtp-Source: AGHT+IHOQSnwa2pzrlHuG87j7wTsLdMWqBYVdAXOaPLfbvtSGNJ4kbTtu0M+7/RD/3DoI3U6ZkXifWzGpjMusOLkpXg=
X-Received: by 2002:a05:6870:58c:b0:239:c210:1e55 with SMTP id
 m12-20020a056870058c00b00239c2101e55mr7822310oap.4.1713798654999; Mon, 22 Apr
 2024 08:10:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240403052448.4290-1-david.voit@gmail.com> <20240403052448.4290-2-david.voit@gmail.com>
 <80e09054c9490c359e8534e07f924897@manguebit.com> <CAPmGGo7XogXA8RppeqOtidWsgL84u+J4SUB7-st=A9a2ooPriQ@mail.gmail.com>
 <CAKywueRW3PoAJcfwPWANh-oJeop6VP6BXsSMVR1Xq2LcTmXKDg@mail.gmail.com>
In-Reply-To: <CAKywueRW3PoAJcfwPWANh-oJeop6VP6BXsSMVR1Xq2LcTmXKDg@mail.gmail.com>
From: David Voit <david.voit@gmail.com>
Date: Mon, 22 Apr 2024 17:10:43 +0200
Message-ID: <CAPmGGo4khSw5UVOruqoEGBSwns1Nt_pUBF9OaUr48=SQ+DA63Q@mail.gmail.com>
Subject: Re: [PATCH v4 1/1] Implement CLDAP Ping to find the closest site
To: Pavel Shilovsky <piastryyy@gmail.com>
Cc: Paulo Alcantara <pc@manguebit.com>, linux-cifs@vger.kernel.org, 
	Jacob Shivers <jshivers@redhat.com>
Content-Type: text/plain; charset="UTF-8"

> IPPROTO_TCP check in resolve_host.c. Let me know if it is ok with you.

Sure that's fine with me, I think this change isn't coming from my change. :-)

Thanks for merging it and all the feedback off list before!
