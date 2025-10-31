Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BB4C2EDD53
	for <linux-cifs@vger.kernel.org>; Fri, 31 Oct 2025 07:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761895941; cv=none; b=vD2pZD+wospwi8yZh2GlKKGOw7KnZEb770ghKQiXLF7uasQA/jl96HAl6wgn5ZuXRZw8RbDCgmUA/iZp0rs6LVNmXO4uKw6DOGY9tJBp3Mo8Q4uAXuHnGQccuh8ygZQODRiUSQgDLTEOTCZDy+gX/MmFMvqGABFfo6+yTqFhU5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761895941; c=relaxed/simple;
	bh=BMrQhc78/tWbKmAlQyS3CQRZfigmg1PQWr4K/DHEl3A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gKfeYdt4SNb8TypkWO9yBePOR2ql5R3RCGFn6ApKNMz/HumLXcBQQEIj1Q0mEP+L3POsUD33NW6gf+FflDjf+a+ofAh0lG1ksHTpFiqNqk5C2quHRSDWHECHWovWAYMP8S+/s6UgV7abV75FqRLQ6kJLz54zFb/aIrEQe8hwQsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nSV9TCqI; arc=none smtp.client-ip=209.85.128.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nSV9TCqI"
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-784826b775aso23897707b3.2
        for <linux-cifs@vger.kernel.org>; Fri, 31 Oct 2025 00:32:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761895937; x=1762500737; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BMrQhc78/tWbKmAlQyS3CQRZfigmg1PQWr4K/DHEl3A=;
        b=nSV9TCqI+lLKZqb9Rlc8zZedS4htr3Zm6tW/f0p1+r3ewf8ntrsFhdQxWP4himYHmI
         UbHgMSjGkCWF4KRG5NLg1U2vcjbOqrgbAj13sVLFmBqYx7FDsWMLOlDNtab/jIpMwqRE
         jdjLLwF/5S9YZ1T5PPbnYPqhqO3x07RBHNFWLsPZtYpco0EXMMIhxXRN+Tz6LR9BWd4O
         pzUCZUoh7VmvVziXpQffGUNW7A3qlvhd3TYyJaxb8m9qEtwUbWZCONJS+moIXjeo5SwC
         XVFGYns02/O8S4cR/aP74C7xtNrd5MrOQTBBTAx/R8rybznKgmxigHOCsEtG6ehFdvkq
         84IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761895937; x=1762500737;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BMrQhc78/tWbKmAlQyS3CQRZfigmg1PQWr4K/DHEl3A=;
        b=qsJ28zLcNNsbCCrmmyXdb/oPuCOfpBxI+CgYnq1s+4CWivw/jhpFTq7JfXfhmc8wbY
         mwGhL0XwPsAv3mP3Hg67iDsLSjkgzm3WzDPNImMOPkrkLRNrAEMxUrdlm0cNZIabFh9Z
         frqPqI39llkGNBqrKiN2KPHfsqdRRFSt9vrUDcvN8Zfki/xN62S66DXr4CR9sj5aAMdf
         OBpTJEaQDwC/QLIeJegxbZBoqOB25aEfVzYBmC7qWt6cKWZE/sZIteba9KenALDNHGRn
         3nojOrSITVDEo2m9C35uq7AG/govNvlljX2pemXpnIpH0U3llXjjxlN4sV3z+FaIO9Q8
         ptZg==
X-Forwarded-Encrypted: i=1; AJvYcCXI8NmVEcuD2ZD1xkClYR/SK60DFqZZad/FFanJkluLw/YWAIt60vdLpDkJZKdcRyV5t/nIX6wqdqte@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3Tf9SdKPojmtOQPiKjFMHm1qpuRX8AFdZf1VFh/K9SgphhM1o
	gTLCxYwnOaTYkO1d+pI0jtfzroCffgEwzqbmObi2VDINfczHZHKdANis2mdF8RXjbunvfApaKI8
	WLl6Hm0wMjdyvmEqntb0xHzyQaoeSK49W5lSeNU+EPw==
X-Gm-Gg: ASbGnctvWbdgZqXAORHkkFfR+LXcF5JzzsO5EqmVGbB0U7A7tdbHE19fanY1eWe5B2P
	6jjmmhkoeQ2jL3JUtEeDn+9PzZD8bIdaMJZ8DBOyVjB8440N/N9n8bQeV3gmPplg2nvMy/op529
	MeBWrhh5pzLno/SPvvLwy+8M4EjqIfeUvORvBjnB8VmtGf99aI+Z/HF4UH91AZyS12IW/eU80uR
	EY8kloGiLMus0vGYN2r3/7MVNy4FuRXz6w0pus1tn9BZU+4uVsfBwe3xd4zne7hUIeMLqRBUMtx
	vZu3e7GzMHM=
X-Google-Smtp-Source: AGHT+IHJQTA3KNqKyYFQiTmzgxAa+tjK8r9Su/bQ2kHLfDXiO0jTTvMOB4R2M/5y1O7Kk/f5k2x5Z4CMKas681wgGyM=
X-Received: by 2002:a05:690c:fc8:b0:781:7ee:10b5 with SMTP id
 00721157ae682-786483e8ac9mr22021267b3.5.1761895937576; Fri, 31 Oct 2025
 00:32:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251030064736.24061-1-dqfext@gmail.com> <CAKYAXd9nkQFgXPpKpOY+O_B5HRLeyiZKO5a4X5MdfjYoO_O+Aw@mail.gmail.com>
In-Reply-To: <CAKYAXd9nkQFgXPpKpOY+O_B5HRLeyiZKO5a4X5MdfjYoO_O+Aw@mail.gmail.com>
From: Qingfang Deng <dqfext@gmail.com>
Date: Fri, 31 Oct 2025 15:32:06 +0800
X-Gm-Features: AWmQ_bn7BSFll8h75cmXBIOIlKgqr5WL20vu8LJPrTdeOFLYt0KTtgFQaVW8jBU
Message-ID: <CALW65jZQzTMv1HMB3R9cSACebVagtUsMM9iiL8zkTGmethfcPg@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: server: avoid busy polling in accept loop
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Tom Talpey <tom@talpey.com>, Ronnie Sahlberg <lsahlber@redhat.com>, Hyunchul Lee <hyc.lee@gmail.com>, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Sasha Levin <sashal@kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Namjae,

On Thu, Oct 30, 2025 at 4:11=E2=80=AFPM Namjae Jeon <linkinjeon@kernel.org>=
 wrote:
> > Fixes: 0626e6641f6b ("cifsd: add server handler for central processing =
and tranport layers")
> > Signed-off-by: Qingfang Deng <dqfext@gmail.com>
> Applied it to #ksmbd-for-next-next.
> Thanks!

I just found that this depends on another commit which is not in
kernel versions earlier than v6.1:
a7c01fa93aeb ("signal: break out of wait loops on kthread_stop()")

With the current Fixes tag, this commit will be backported to v5.15
automatically. But without said commit, kthread_stop() cannot wake up
a blocking kernel_accept().
Should I change the Fixes tag, or inform linux-stable not to backport
this patch to v5.15?

+Cc: Jason, Sasha, and GregKH

Regards,
Qingfang
