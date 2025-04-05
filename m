Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com [209.85.219.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E37EC224D7
	for <linux-cifs@vger.kernel.org>; Sat,  5 Apr 2025 03:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743823480; cv=none; b=HuH3NuCafnqVNVcm8FWtOUlSjzUwkxK6jXlHR/f/SzKrBsePcOX1i3F4ScQcO6N6x885Z3rVZWmjydp4VdLqy6S8c8Zcv6eGXeiRvogeYHjA3QekjMc9y5+CbPNwKKjnm9rKb691FoNsanIeFDqgNm5vPdfNxHrsrETt5rBwCzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743823480; c=relaxed/simple;
	bh=Ef4nfipk1gGC431VUIFScJ8PZFa5fmjPR/M6fM/JhIk=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=kov4mX4SQWMF59q+Ipcx/b0wmu/vQqG89h6vfw6KY7eM7eUUhnd5fuuZO87p1Ctjx88QmRZ28MjTWEzOkINgz5QjQWTjUXEzOIBYdPnPEbtZZquc4td4uC+7SCGJ6hkfbLkk0tGXayfAr6dwxES+80Jd/L0+rhSEyfG+pCDqbgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Rj0q1xuI; arc=none smtp.client-ip=209.85.219.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Rj0q1xuI"
Received: by mail-yb1-f173.google.com with SMTP id 3f1490d57ef6-e6df1419f94so2074110276.0
        for <linux-cifs@vger.kernel.org>; Fri, 04 Apr 2025 20:24:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743823478; x=1744428278; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Ef4nfipk1gGC431VUIFScJ8PZFa5fmjPR/M6fM/JhIk=;
        b=Rj0q1xuIqqFUPdwmFK+C7EWFHMkIT5FE0slHbF9/b7qoOS7Gw6JCHX8/igHg7f55Bu
         7qcZ6ZfBRft9ESyqEExSiBRz0RLZjzG92/nRKQBXPahsb0Yt3rGFxM51/AWJ+oC2wHeF
         VjC/cyvH/UfPmAY0Cxm209RL1gHZsRmZnar8LBdS2/uT4nr/3IwAne0OxXrCcHRdlALx
         0lYxr4+ytR5/WFYMw+8ixaGEp/Z+t7RA5K2eDFegzgaQ2dbbCrJpmdCV4dbqz40vnHkO
         HIluAhHeKEXAsMkzEmzov2k/Rh/lBRfSCPYnBwqSSybrHK1XSJF7SXTTZNooLY63OqR3
         6myw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743823478; x=1744428278;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ef4nfipk1gGC431VUIFScJ8PZFa5fmjPR/M6fM/JhIk=;
        b=J0v2eXm/dnEuP52HrVTLXSaBO5ee+KkimSPFe6N7N13P/+gxY4mppzTum+HnxbLzDv
         nphMoaYu7EkIe7yZoavi97ZhlTvpAGVLOOeN6uasDgn4yX+GiKwknmUXCDiWK8eTHg6N
         juw8PItDA5fIvf8zsVA9hNGf5JoH6a0qsQaX/nTopnVetJ6HIx29CalL6xplTd96iGU6
         A52FSrmG3AGG6z9wm455cQgwgWuob5AQfxVc2ULBfNaIj5PtDTFNt7TW90PWx3bXyhdJ
         DPoG6aW1pund4NzPwE0xymaGdoeGMakrGaF7MEfXLi4RAMicHhO2pATKbU19+7Nl3kQM
         V+Cg==
X-Forwarded-Encrypted: i=1; AJvYcCXHIDyD/2iXD/OM73wfgckEwIbxX/kl9dmTlRp1V4pPJza8y6Nd4BAdcGk+4/CqbOE+2LtmzMNc8e0E@vger.kernel.org
X-Gm-Message-State: AOJu0YzEgZVErfsHb+oSDHp0zi8khN0Kd1/ijw09hyQfIzowWrayFf/r
	lEWxPiH+rRWFaZd0DLiy3Sd2R+e1tH12ojaiKMQqqbclpyn6+76y43XC9fxGAjk7v4Gx05jQhwM
	Fo39El3U8xYul4fF82AYUad3zKre/qmpS
X-Gm-Gg: ASbGncvhPevbWSmJmYQRkTn2+NYbLe3nCMtnbA0GXzY/GNWUzEDHmWNVZKeXsdVQb9r
	pGf8O3uYxNgpJiMgAe+zTWZQCxHiFCnQmR0PrcuXlTzgCpB50ShzG+EEkI3BoZF3jK1383gyivD
	HeFdM9gqXLOC4ByZnqyrmmyos=
X-Google-Smtp-Source: AGHT+IFIAFbxtH21qgajawP53NuNrKweUQgIZAqUurLdlDcCGT4cXE5fl3+9TYBtBlmTe5BX22TFAYZZzAjeFxPlCJI=
X-Received: by 2002:a05:690c:4b0d:b0:6fd:41d5:de11 with SMTP id
 00721157ae682-703e331249fmr80960217b3.23.1743823477809; Fri, 04 Apr 2025
 20:24:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Junwen Sun <sunjw8888@gmail.com>
Date: Sat, 5 Apr 2025 11:24:56 +0800
X-Gm-Features: ATxdqUHyEXpgx7l1-l2KljisX6wsnHDrTIRIaDm-pv8th0b6bagqr_qLPZoVefg
Message-ID: <CAJXSQBms+s2Whk7SfugzQ1kby-xyJ62aVLVvM05rPtFAo7247Q@mail.gmail.com>
Subject: Re: Issue with kernel 6.8.0-40-generic?
To: smfrench@gmail.com
Cc: 1marc1@gmail.com, linux-cifs@vger.kernel.org, pc@manguebit.com, 
	profnandaa@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dear all,

This is my first time submit an issue about kernel, if I am doing this
wrong, please correct me.

I'm using Debian testing amd64 as a home server. Recently, it updated
to linux-image-6.12.20-amd64 and I found that it couldn't mount
OneDrive shared folder using cifs. If I boot the system with 6.12.19,
then there is no such problem.

It just likes the issue Marc encountered in this thread. And the issue
was fixed by commit 'ec686804117a0421cf31d54427768aaf93aa0069'. So,
I've done some research and found that in 6.12.20, there is a new
commit 'fef9d44b24be9b6e3350b1ac47ff266bd9808246' in cifs which almost
revert the commit 'ec686804117a0421cf31d54427768aaf93aa0069'. I guess
it brings the same issue back to 6.12.20.

Thanks very much in advance if someone can have a look into this issue agai=
n.

=E5=AD=99=E5=B3=BB=E6=96=87
Sun Junwen
