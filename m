Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60C35286419
	for <linux-cifs@vger.kernel.org>; Tue,  6 Jan 2026 01:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767661309; cv=none; b=HRL1iUEDkgRaEtUSuXyqfQ/grU87sXtBxAs3HmIkfgER+17ddZeXgMbnAMZz+3rQZrFaQuITyTsdVUZHDx+BDzR6pp6vDViexV/qyX0R9oTsm02fbHNeBg9vnlJprwDPWlicRSmq74/l1ZkKjVD7qx0Pla7KMu1uOFu68zhQ5Tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767661309; c=relaxed/simple;
	bh=YiGJ/4dBLriSXnvPuWHLPHBwRkgybactaihGDFxJ+xY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MdgTaq1J2+xCUXM6f+sn65Axzbok93sBa2KASRFMD1Q5Fkdq4dbH8YIJm3AdGxyk7UKKctjZqR11FLZoOa0phGAQaOwnyrnOuAtOwjnphrNxmk9gU5aKu95d3HjeRZqQPbSAWAVwsSyWSUPKGJljLXEG15evNnUsQxUL5vyzoYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bH+lVqBA; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bH+lVqBA"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-8903707280bso6277916d6.1
        for <linux-cifs@vger.kernel.org>; Mon, 05 Jan 2026 17:01:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767661306; x=1768266106; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KbNuRToqgAzQnIy1oHZ7Kl2NNlJ6EbGTRArMZTS9LPo=;
        b=bH+lVqBA1vuYDwNccPK7wtTwtwcY5DiQq9gwY+w/CTxtKEPXAcJruoWpBcW/QXz+op
         oV/lVlTIjJU0fBh+63JJzjlO9QZKzbyGSvK90ahi3xuK86TbHZtB6jODBSR5r6KUvPlp
         +i8mONMmrzeAJ5Xe6QXP/RD3BHt1rhFNh3+Piyxv4GDdHB6sl005nrwfTlyYGXJyW4B2
         G0OYZJia5gYWTjsxfEwmf7yYLc/S8KKStR4D9CPnhr3RmzD+v4kHjph8xRBgoCs2K8HL
         90epGhD2sBdIyiZ1j6rxug8Oy/dWtNubCLTb2WcOXL/9pK6fM6yAGkylDmbVZLHkGHq4
         UDUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767661306; x=1768266106;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KbNuRToqgAzQnIy1oHZ7Kl2NNlJ6EbGTRArMZTS9LPo=;
        b=I2w0x/ndHBDMG3sW25RC3SAoaLTY+GYgLounB0gkSpzhH3Td0xiPz82oLrGdUo3QWo
         FM795FNWJJU1JxscXTaluQ7ZY9MnRd6DwMwJ+JIiOkbpZAntFdCM4Q+TC7LLKaVEptSd
         iEg+MW3Cd3VzwLaKYSwJiwEAosTfSl4zhuaJ2wgqCfCYXL5zyYiSJfLO9clT+hCXM9d3
         NpNR2UZ4gAal2ujN0c46nR+wZezsbFeYdHc4IzmCpFIK7jxZAr+/xb2BetiGwdCTa8U/
         kE0AAhIaKSG0WcMuaYJ71Cay4LthAepVd7v4al6FlLKt6vyD/iHGAAOo/BSfm13AAhvB
         HRaQ==
X-Gm-Message-State: AOJu0YwPDhmpAMHYBtHo3K+zW35Y2wSb2OUT/1+3buhTV2TJlT5s85yr
	gAC2nxnvNtUBUA4j3b8+wNkmzTN2sdqel0LUPPuHhH/SQEtf2se6Km3xH0yej02NI3X3k+JBll0
	7D5XlGpIU1WGNAsiYCX+dcViCmmw59DnHZA==
X-Gm-Gg: AY/fxX5NoX9I4Yv9e7c+ctYgS6TzWM6wliW05P8qdlrMCiwgY7b5uMux8yll8EFq4i/
	SYq5+rGAVpMPpNcz5RyL1FIPXERJ+EymArrqBfZ72LbE0FaROxc/DwCTBsVqTGQRwxykSCrDG4b
	wY4Wj7tV8IR+wjSQnEDyY26vsa00coIQvf83I6B9wHea+H2cmyYk1vvhTUM2wa9So9GTY7Dw8Ag
	eU53WkRFIC1rKWAq1tlzCoYhYE8syRxGRjHjwCRFVAAr471+s3/CkEPurAE03zdFSYDg4gTqClO
	rmdk1IuWT5VF2ZPhI7/E5fvLPz/JhhxQAuBoL7rfMO+i9fTZlwU6kE1iTUHZN4qWC4LiVmjJR1t
	ZtL3K/LrVzKyRRnbz2VmtQWaBOyx/w9TGxNj214WAKG0acqTmOfrDtaSIMSdPcGuKB4H1tEy6Yo
	6K4PQqJZLpaw==
X-Google-Smtp-Source: AGHT+IGgpsjPpGjHYBgOLKJ+eVKZEqkZTJx1Z2hLuEtiv0Zz0QDrK6SuT2hZ+8QEmjbfCOKycEtY/9PMoexpbOxbppo=
X-Received: by 2002:a05:6214:2dc8:b0:890:6331:7e7e with SMTP id
 6a1803df08f44-89075ee35e8mr22077706d6.60.1767661305932; Mon, 05 Jan 2026
 17:01:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250910193110.6978809d@martins.ozlabs.org>
In-Reply-To: <20250910193110.6978809d@martins.ozlabs.org>
From: Steve French <smfrench@gmail.com>
Date: Mon, 5 Jan 2026 19:01:34 -0600
X-Gm-Features: AQt7F2o-WyuObBestm7UPIC4Um11qgCBY9HneVYL8FYBBmRyClmUpdI4FEIS6h0
Message-ID: <CAH2r5mtwi=2PmqEXd3f0yEhBCgsBB2OQa=jdc524DsM8xoC9gg@mail.gmail.com>
Subject: Re: [PATCH] docs: update username= option to drop invalid examples
To: Martin Schwenke <martin@meltin.net>
Cc: linux-cifs@vger.kernel.org, Pavel Shilovsky <piastryyy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Merged into cifs-utils for-next

On Wed, Sep 10, 2025 at 4:57=E2=80=AFAM Martin Schwenke <martin@meltin.net>=
 wrote:
>
> When hurrying and scanning the documentation, my eye was drawn to the
> examples ``user%password`` or ``workgroup/user`` and
> ``workgroup/user%password``, especially because they were rendered in
> bold in my terminal.  I didn't read them in the context of them being
> deprecated and experienced a non-zero amount of frustration when they
> didn't work.  Given that these no longer work at all, remove them and
> add clarity.
>
> peace & happiness,
> martin



--=20
Thanks,

Steve
