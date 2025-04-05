Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CFF014830F
	for <linux-cifs@vger.kernel.org>; Sat,  5 Apr 2025 17:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743873403; cv=none; b=NtIMeLjcgZPCG3oYQCFithdYhmNIC9+vnGTKPLcfZP2pzuzO+0dTxI/PZym+sykv1qU8BqDO2SLKea5n6FZl1rK33x9ohYDSaPXVqAZORC6va+JghMiSLXSX/M2G0OjbXKYLHgWeaERK98pfJfpTU8oXkKfR22TgirbdeFcNYkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743873403; c=relaxed/simple;
	bh=5w2IFPCYS1u1atHpfR8RjJryOTELFRYeRRTdVdQkl4U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KqBfYpMopwB2oltNSJs6yPS4M6XeaK5s6BQQdyFcwrC8RH6cjb8z9f4qyf7a9TBEVzPmkoHCuj/umiiJjBHet6Rhni8a/+xdfG+u7JET9Zk14YvQhgV1vmCxaApCNKkgekIyG59S/HN4iXWv47MljPaz8XqxUgWar10D5pftLAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BwzsB6gz; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BwzsB6gz"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-54991d85f99so4164527e87.1
        for <linux-cifs@vger.kernel.org>; Sat, 05 Apr 2025 10:16:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743873399; x=1744478199; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ghjQpHKusYxyadXLhZmBSkUSYQTR32eq6vdcMhfyIjQ=;
        b=BwzsB6gzSw46l4d4zxF3ZMDCGNdF2lHI3HIw6rovDYZDVdvG4JqvX3ClbpjS70uhqi
         F6FwBODaYxh9wHanzcTZ2gTlcqiUdYbiJwvdCPOMTBH/4dI/5sqAdeXpqBU1PuitQq8Y
         uZ6hlJAiWMTu67n6C5cQMqXwCcH6o/wS2tu5HK07IXtX1kwPjXpvBtAQPj5u0mIPXZzf
         CggwC7PxezG4587XdkrqlPYI7r7//UMvbsrwM2N8KhQOkTLQcai0k5AkV26bYdh6Qqe2
         g+1JOGztz77MQV/d2rC1lZwxmG1zy25RaGyBxJP/Cd5NDA5XltaDRXaIa9W0139I0mF5
         BgNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743873399; x=1744478199;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ghjQpHKusYxyadXLhZmBSkUSYQTR32eq6vdcMhfyIjQ=;
        b=cvPEW6321sJxg285dfRW/pa2CIARG4nDMqN0ZXkQjOgMWo9X5rFwKKVoPJlL/x+vbX
         rR3EZ73DJ1eY/jYNXm/szgmGwiTjSDBqigfw7af0xUmhAdKezBXcCZk7wEZY9LG8UqNi
         lWNwqGcmWP2jnWuJ+ZHXZPQoCu47jT4NEeNcDPT/umHV6bfiWTyoj5amtImPI5Wc0mpr
         ZnxuA0Q6TRxaV1ZMTNGQBwx36ieMiAPBmdOO+vJb+oMdPhwPfNtuohN4EPeWehQguEpf
         pVAYJcftZ9kTAMs6qRbzd6kauqE3+lrfr1C9Fl/H27rmnnejKZLAtjkkqWCmgGVwYgoC
         LxJg==
X-Forwarded-Encrypted: i=1; AJvYcCXOJVgnrPWM08/ZNm1n3QQqclSpiW1+hOl+gV8kpSR0EMK5b7D0LlNV66cuGIXTesAGKbIwCSX+upZQ@vger.kernel.org
X-Gm-Message-State: AOJu0YzZBiOm/ON5d9nYjk7xC4828mGbGX8RR3KDCnn+niWbJPM4hYEO
	05k8wqrsa5HJ5803JVDljkPEZGmhaJZODIhSPSOzBrAjBXbffAbqfsyxc82eQnyN97Z5b4WVy5j
	tIRqeA4iZOEHX/py/DP4Ohm759xM=
X-Gm-Gg: ASbGncuiBiyhN8lxJ8fGoa2qAMwZ/C+PIWGedvPpWd4v+PdwgdRSEvG4hZmgX871kvF
	+L4P7VcyyhYkdMJx19lEQ4WwbNkjvkRCXYBMTpsxRsQ+vlTnl1kz6thXeVYmI/eYfzT1AgqHTjZ
	XSOAFzuSJDXlFLTZDx0l+oFsYsvRXQjzURCdgbFm5CROdD4+8q1AaF5SXHqcmN
X-Google-Smtp-Source: AGHT+IG4/SsIy6Bz2/iK9JWB5DA5CYEZS2mOTNnhljcm6kX7i4N7N2r0sZflPJm0A+pI/ki6KhcoiQ3+LBIhIrB9ue0=
X-Received: by 2002:ac2:4f14:0:b0:545:3035:f0bb with SMTP id
 2adb3069b0e04-54c1ca866d9mr4778947e87.22.1743873399144; Sat, 05 Apr 2025
 10:16:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJXSQBms+s2Whk7SfugzQ1kby-xyJ62aVLVvM05rPtFAo7247Q@mail.gmail.com>
In-Reply-To: <CAJXSQBms+s2Whk7SfugzQ1kby-xyJ62aVLVvM05rPtFAo7247Q@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Sat, 5 Apr 2025 12:16:27 -0500
X-Gm-Features: ATxdqUFd80OcBQkNwifuudccY6nfsd-84_NAujyDftFJe7Utl7_4sp5kgNzyHJ4
Message-ID: <CAH2r5ms2=o4baY-6_aLmHpJhBYwvaWXUKwZufKs-iT3vsEg_hA@mail.gmail.com>
Subject: Re: Issue with kernel 6.8.0-40-generic?
To: Junwen Sun <sunjw8888@gmail.com>
Cc: 1marc1@gmail.com, linux-cifs@vger.kernel.org, pc@manguebit.com, 
	profnandaa@gmail.com, =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>, 
	samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Good catch - it does look like a regression introduced by:

        cad3fc0a4c8c ("cifs: Throw -EOPNOTSUPP error on unsupported
reparse point type from parse_reparse_point()")

The "unhandled reparse tag: 0x9000701a" looks like (based on MS-FSCC
document) refers to

    "IO_REPARSE_TAG_CLOUD_7   0x9000701A  Used by the Cloud Files
filter, for files managed by a sync engine such as OneDrive"

Will need to revert that as it looks like there are multiple reparse
tags that it will break not just the onedrive one above


On Fri, Apr 4, 2025 at 10:24=E2=80=AFPM Junwen Sun <sunjw8888@gmail.com> wr=
ote:
>
> Dear all,
>
> This is my first time submit an issue about kernel, if I am doing this
> wrong, please correct me.
>
> I'm using Debian testing amd64 as a home server. Recently, it updated
> to linux-image-6.12.20-amd64 and I found that it couldn't mount
> OneDrive shared folder using cifs. If I boot the system with 6.12.19,
> then there is no such problem.
>
> It just likes the issue Marc encountered in this thread. And the issue
> was fixed by commit 'ec686804117a0421cf31d54427768aaf93aa0069'. So,
> I've done some research and found that in 6.12.20, there is a new
> commit 'fef9d44b24be9b6e3350b1ac47ff266bd9808246' in cifs which almost
> revert the commit 'ec686804117a0421cf31d54427768aaf93aa0069'. I guess
> it brings the same issue back to 6.12.20.
>
> Thanks very much in advance if someone can have a look into this issue ag=
ain.
>
> =E5=AD=99=E5=B3=BB=E6=96=87
> Sun Junwen



--=20
Thanks,

Steve
