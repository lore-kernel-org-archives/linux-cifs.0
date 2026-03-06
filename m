Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75CC434CFDC
	for <linux-cifs@vger.kernel.org>; Fri,  6 Mar 2026 22:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772835801; cv=none; b=XIwyKAoq8Ctz7w87pG25A5w4cvi8vyimj3eyEaz+edPi3Mu8yZf3jq1lCMSQSj/zXXqCcTfevTNSdfSQQLAKQqkgyvsurcrOa4yvGzKfW/9W7K9K34YJNesfS1yS7AnsQJulfL9vJ05unwYTak3vypfCFV66GTf1FybcgnebIcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772835801; c=relaxed/simple;
	bh=yehI9L67fVzSrtf0g75FISSvW9r90OMEdc5z61oY1qY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=d9Vl0/cdMiy5YX4U2gY/5eQcfKiL89fIpmbVys97tsH/jsbPKOCBMqfKv8wesoszzPatbhK4EqKqqC+/iLqanUiRdtjTcchqniVCbyryb83ILOx1YcjfBeUHFiwrZCktwMP8mAwVIQN4APRLI3V4HaOlEQmO9xrJjupNKdzU/OQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gcGXCZxC; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gcGXCZxC"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b9382e59c0eso558712066b.0
        for <linux-cifs@vger.kernel.org>; Fri, 06 Mar 2026 14:23:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1772835798; x=1773440598; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OXm7CfnQOg8eA0rOHWqiPBIGP99/+chtxE6dpT7vT0A=;
        b=gcGXCZxC5Gz/zTT/W+KrZT/C71vKkjZ9nTVp3cEuFmCzuWrC7sk+rqyF3o/VedP7zg
         7ijRNLN9j/Ph8nt5B+avlka+vJ8yAZSHyGZA07WFRAxCoCcuZqJnJqJ9eopmZpkYfG1A
         3sG92SP5sjEWQXjRnSfHIezvZGXQb4pal3G1w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772835798; x=1773440598;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OXm7CfnQOg8eA0rOHWqiPBIGP99/+chtxE6dpT7vT0A=;
        b=UlclQL7IkvykxWuA/n/of8Hu0cxiVNzxRaNV0StGfpGz25wNoow1rVl5BNoJFLQYZy
         wBuwrBrUYXa75gdAr8HGJTQlr0EyBJ5Ylg5NkgiZohQh6VEsXRVci53LZfbs+biLgnae
         gtK65n3B0pjJjT7tl1aMAyLhGh5JA5PXv8Uaibsm075zJUE8gR/1bw2/vgcAmuikgoM0
         FEZVLWlejjEqYDMvlgsC6r6If9bG3riKUij5OQMezqstfaYvN8syJBIM41pesg7GR+Cg
         4PQ4QOWfXuElorze/ZPiZ1/mLQOlVaJQa7iNbSb9YfwfMEWPg9Q9hiAWK3W0VY8PVbt5
         vNVw==
X-Forwarded-Encrypted: i=1; AJvYcCU9Z+fEHJl9asBR5jiVVHb6Jy/4Vk1gPa4mPcy1GbM4heR7AvKTtl/qyhLWnGiVLCNSqKdFPCkkszKQ@vger.kernel.org
X-Gm-Message-State: AOJu0Yxxc6NgV/7H2z++diNcSKKok/UFEwBzYO3xgl4DzvagnK8rY0qt
	JDkR9/6VFASXQPB2rO2FAvUfvI0aTxiWyOY0HtOxOYs2Z1FGc2ssQVV0Apt7GVNB6M96o4Rn6xL
	hZGIkyjE=
X-Gm-Gg: ATEYQzzSdprqJC91McBAEy/tFYYmSkRqO+XgDE2Vvmn5lCItb0tloJwSbkO7BgxOMP0
	zgPpPdpFn+NzLkanXrD3eJBtL0Ht7s13yibNv6MEkdD3q+7Bx1hcC3LYgLpfyAp9S0Scq+YR3xD
	UkELcprzOKgwK1s+MRyE7X64Fmz5pLKJg6bSPI36PAucFAmG5U3yf3ik53LTAF6X/S5pEi6eItj
	PLegOqOWTb0BsZ8lzmP1y+nviKCTWwkwdIe14HcgxqJ/q2y0xrRnxPQP/SveHDMQu3okl0/uH9u
	p+AdtEPjDVoCqrccPOpdcJpFMTz7Dv0p6A0pzce/YGRUqN16NFyBrxxZx+eweVDYUuhQC69T2dG
	E5RFtMPZHiVGOUZ7bigG8Tnt7WUAcFsHEvQgGpl7GElsc3PiqmqvJf72vNVcsYbWfClhBUOt7hv
	vpi3iHfRNSwYtyDbcKiNtbyD86BAF5wQ9f1PKeCLnvn57I5DxJ0Rt6WrmZgV9KfInBMRgdgz9G
X-Received: by 2002:a17:906:209c:b0:b94:144d:78e9 with SMTP id a640c23a62f3a-b942dbe9137mr148504266b.25.1772835798557;
        Fri, 06 Mar 2026 14:23:18 -0800 (PST)
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com. [209.85.218.49])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b942f13a3e6sm91783466b.33.2026.03.06.14.23.18
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Mar 2026 14:23:18 -0800 (PST)
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b940f962a82so372039966b.2
        for <linux-cifs@vger.kernel.org>; Fri, 06 Mar 2026 14:23:18 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCX9Ov4e9wFa7vf35dI+6cjgFlFrJzjc4pvQr4tuB2WGipBkUW8/elXgtmGFHDZwTZVAel12mC2U57kw@vger.kernel.org
X-Received: by 2002:a17:907:9707:b0:b93:5fa8:d7f9 with SMTP id
 a640c23a62f3a-b942e00cf9emr230803166b.56.1772835798065; Fri, 06 Mar 2026
 14:23:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mu0T+Gcea5YKaAA7L6FfM5OMjEKenih6Sgk2W4EXrSpWw@mail.gmail.com>
In-Reply-To: <CAH2r5mu0T+Gcea5YKaAA7L6FfM5OMjEKenih6Sgk2W4EXrSpWw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 6 Mar 2026 14:23:00 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgVoDTEDyEQgGn9yJQ7T47f-ZN4eV9XeutqzKPJwDrPtg@mail.gmail.com>
X-Gm-Features: AaiRm50P9gGOIRQq0PaF9H5CrGux8sROvKCePzGkFq2iL292FDVqmSpUBz_tog0
Message-ID: <CAHk-=wgVoDTEDyEQgGn9yJQ7T47f-ZN4eV9XeutqzKPJwDrPtg@mail.gmail.com>
Subject: Re: [GIT PULL] smb3 client fixes
To: Steve French <smfrench@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, 6 Mar 2026 at 14:04, Steve French <smfrench@gmail.com> wrote:
>
>   git://git.samba.org/sfrench/cifs-2.6.git v7.0-rc2-smb3-client-fixes

Hmm. I get

   fatal: couldn't find remote ref v7.0-rc2-smb3-client-fixes

and I cannot see the alleged top commit:

> for you to fetch changes up to 048efe129a297256d3c2088cf8d79515ff5ec864:

anywhere else either. Forgot to push?

                  Linus
