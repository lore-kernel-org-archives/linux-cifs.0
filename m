Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B65DB37A493
	for <linux-cifs@vger.kernel.org>; Mon, 20 Apr 2026 02:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776653016; cv=none; b=lRqzyXyL1/HPAT2eNzRIVtokOynZ2uhhZ5p/zFh2ILBGqgvJ7Sd6HFLMAb+L11zlH4VRS8Q4swGeIhSGHN4+Yc5IQJ9hQMNID3keApabDS8GYOdI8EoCx+A2MjLPmaUKr1O1tBm28rROiesXjskQiV6X7xnSHSIMgYUywT80py8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776653016; c=relaxed/simple;
	bh=WaSNSKptb0I9vrNt7rpWvx92RantJMFh+Ft0+wl1Wi8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=C41wdIopLla0U7+K1c5QPi9E/esUh7mOUimbJFtWeJRJUlFoovKJ0G4jg79LkMmDsBAKuWcF4EHlDSyXPJHGeqDz2OtXhyqR5fAJzrYgFzf3pwsjbFNsI5Wcfway8hbHVBsKuxHI5dfpM5ocj9/lFK6+RCijvad+GYd3XLYHrvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XAueMNoq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XAueMNoq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FD1EC2BCB6
	for <linux-cifs@vger.kernel.org>; Mon, 20 Apr 2026 02:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776653016;
	bh=WaSNSKptb0I9vrNt7rpWvx92RantJMFh+Ft0+wl1Wi8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=XAueMNoqfofEp+tCuHW53CiGi0o4VOAx/nHf+eTaIUzs/2inO7m8D4GvRqzjZZS4o
	 WkI28cqUFJwN85Ff44Qq5Azfw2givEkfhnc5i2n8rBblqiCnYljrcxapGbpVq+szcM
	 wZEilwbRgO3GZVUxmLjCRqYZYO2i0444oHv1l684CXzxFsAU7gR+8vy/pmSvpr4lX0
	 TTWccyLNu5219kMr2c57wYvlETRl7V/yCJpS58ZFssrQm285FfPs7LcD4GuD/9uapn
	 gz8IKAVFCpIgjqvKg6KYBpeWVLDV8SSyTbXgEfaBfsbFFvMUK9eklW8G0Ri8VAwec5
	 igKSq9Tk+FuGQ==
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6745a88eec7so2640344a12.2
        for <linux-cifs@vger.kernel.org>; Sun, 19 Apr 2026 19:43:36 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8FueNSzhph/80yrU3rR5phSsic8a3etlaYlAzY6KEOJQx9Y94rPlOe+xzhX9Gu22bGyPGZ3lH80WRY@vger.kernel.org
X-Gm-Message-State: AOJu0YwIWtIR9+w173770UsifJSPqpuhfltYxwc54v0cKNRhfZOLuqpL
	nQU0+IlIsKdaxRVDCND6UJKvNojHYSjx7mzn7ThzGfjlkuXa7ltjowNEOFuySLmcLE+Xi4PWaR6
	9IwN15rrbD+ZCHRj9wn2v+RR1LB0zf9g=
X-Received: by 2002:a05:6402:2790:b0:671:4f9a:9e4e with SMTP id
 4fb4d7f45d1cf-672bfed76b7mr5069100a12.24.1776653014895; Sun, 19 Apr 2026
 19:43:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260418154505.84684-1-akif.sait111@gmail.com>
In-Reply-To: <20260418154505.84684-1-akif.sait111@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 20 Apr 2026 11:43:21 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8Z0Rk+uCx+3+M0xKqz=sLEmnZC1x1bRDsFQsfKU=-S8w@mail.gmail.com>
X-Gm-Features: AQROBzBtm-QdPZZ6AnaUF0KvC5f6-Pr_QcC5ksNo2zN3urRiuatJztROpFE_Zc4
Message-ID: <CAKYAXd8Z0Rk+uCx+3+M0xKqz=sLEmnZC1x1bRDsFQsfKU=-S8w@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: fix O(N^2) DoS in smb2_lock via unbounded LockCount
To: Akif Sait <akif.sait111@gmail.com>
Cc: smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com, 
	linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 19, 2026 at 12:45=E2=80=AFAM Akif Sait <akif.sait111@gmail.com>=
 wrote:
>
> smb2_lock() performs O(N^2) conflict detection with no cap on LockCount.
> Cap lock_count at 64 to prevent CPU exhaustion from a single request.
>
> Signed-off-by: Akif Sait <akif.sait111@gmail.com>
Applied it to #ksmbd-for-next-next.
Thanks!
