Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6EE41CF96
	for <linux-cifs@vger.kernel.org>; Sat, 25 Jan 2025 14:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.235.159.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737815122; cv=none; b=Ofm9hasb+w4uvaMFfgiiBHZDkG6+Fn5A71xB9/L9/4wtiNoFj6b9T5rn4R3ijIRfRYJuzg3Lyo1zVDE1GzWqGRUdkWQfJ12/4ANRVfT9/7J77R88V4iMu2wGFcubxqpozukRYr/k5qT8trSadycyZ5c9PXtgdx7FIR1r17Fy/B4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737815122; c=relaxed/simple;
	bh=beIpKID8fjBlp8wzNQPffCe3yVPXfqcFBF0KMvrP+eo=;
	h=Message-ID:From:To:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=u32418YdCSpX5404I9yw+MWJ+F26eJy0+7iSzaC3jofAxk5RO+HRWynXt9ek24URmC+eSDzWczQVmuoQpcOzDJUogRgdTTciaLd+YC5uKHKWGvpp7i9NC9xZtHOF7ZrYc/JXPUeZ2nCEx32BDZ+p1BhoCwx5JWBUpFgkOlk6bxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=DWDglFBI; arc=none smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="DWDglFBI"
Message-ID: <a60e1fdb1494b31c923d6ce43ca5c8fd@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1737815112;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=beIpKID8fjBlp8wzNQPffCe3yVPXfqcFBF0KMvrP+eo=;
	b=DWDglFBIGVcPWXVWb++nduCz3KrgWBIrEuwMZ1iLVVf9gsXKrqYX5Y3KzRQaNx1zAlaScj
	GxIeoaR9J0FaRzWsO5gaKyoY4LAZWTB+gh/axw0LRuXSotOWKI/vmWmO1PGUQAvPOT2+Xv
	2nPI1ZC53LlS26mZra2wlmEM6InaXhdd0dOkmZhw89R0mrAGQIQsyj3w+UxICQJ5FsjRzq
	X980RxGm8IpNetd1Iuq/XIUKgTaiyTK7hV+nrxoJp4qy0TcBHRQwLW2AT1BLVAM9uu6AIN
	5LpdAnVnKd3YRgR3hCh0eYhcKaT0qy5d5LcMuITITErimr2+ZIt3stZvWa48Eg==
From: Paulo Alcantara <pc@manguebit.com>
To: "Reiterer, Horst" <horst.reiterer@fabasoft.com>,
 "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Subject: Re: Regression: smb: chmod ignored (5.14.0-427.40.1.el9_4 vs.
 5.14.0-503.15.1.el9_5)
In-Reply-To: <85a16504e09147a195ac0aac1c801280@fabasoft.com>
References: <85a16504e09147a195ac0aac1c801280@fabasoft.com>
Date: Sat, 25 Jan 2025 11:25:08 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Hi,

Thanks for the report.

"Reiterer, Horst" <horst.reiterer@fabasoft.com> writes:

> after updating from AlmaLinux 9.4 to 9.5
> (https://repo.almalinux.org/vault/9.4/BaseOS/Source/Packages/kernel-5.14.0-427.40.1.el9_4.src.rpm
> vs. https://repo.almalinux.org/vault/9.5/BaseOS/Source/Packages/kernel-5.14.0-503.15.1.el9_5.src.rpm),
> chmod gets ignored by the CIFS filesystem when executed against a
> Windows file server unless chmod happens in another process.

Yeah, I was able to reproduce it with mainline kernel as well.

Could you please file a bug [1] against File System -> CIFS component?

Thanks.

[1] https://bugzilla.kernel.org/
