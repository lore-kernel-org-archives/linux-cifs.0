Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 406784A32
	for <linux-cifs@vger.kernel.org>; Fri,  2 May 2025 17:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746206341; cv=none; b=VpyeLI4ERI9YE3JsObb/jU35LfzpgCG0qiR9WwHAqfZK9byMd+s5846oIlJryKLkzxzsKh9Lqww7AWWGUqRRiZ67dAdozLrcO22A0EEvwRjnGmIwkjB5ZulKsWlmlSsBx/0gD02Nr4RwDaBz16YF4RUmnUv9sJ6Nj0za9Mkuk7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746206341; c=relaxed/simple;
	bh=v2kzNCZkliCFhkIwvkHVWhJvNOYDXGC1v+zA4n3C2bc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KDZwsyCHjqtMfvykU6I/xQxt36GhoYbYNTBrTf+7EZmTbhoit/GfU0JbYfkyk/IufHwIuDA19NAxgcUyWcWL1ymS1geDHm4auMgxKFmWVT0qQv53nVpBGN8KhvSzkLI/tx20Eo/xLKRsG7+ol2CeFtkfPcyRYWzQR72zxd5pAA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EMdq/R1J; arc=none smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EMdq/R1J"
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-30effbfaf61so25137561fa.0
        for <linux-cifs@vger.kernel.org>; Fri, 02 May 2025 10:18:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746206338; x=1746811138; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v2kzNCZkliCFhkIwvkHVWhJvNOYDXGC1v+zA4n3C2bc=;
        b=EMdq/R1JYXItTYhmcFHXqwKC4NnAzhi4OIWqE/nTeIO0P4lo3gjORhnOusMJsa+Qph
         SIPu/yUeEHs55XvhOLrT5gUAGC3GF0nPTIGfAap5Rjap2B5yjywGrB0OHNjfad/D7maX
         NPgCz2HPkhkWh+wbzHVZfNCIQ3E6X34gT2+fAwf65fCr8LiqcDXQAzfJ+j7mEE11XKDX
         QQMQyl/kcAeDgs3yMWSE4prU/C15fuBDiKBIRg/m7jMJW1JkCy9S/wX6/B7v1hoRU/aS
         3/GYiI7Pm2Mts3vKtd9sSXXXIE3ZGj6Sg4qzzplvzQEBjSWXf+XiUh4l+UhDO3+dgALD
         UDYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746206338; x=1746811138;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v2kzNCZkliCFhkIwvkHVWhJvNOYDXGC1v+zA4n3C2bc=;
        b=IFWa96c2AduGcNCXKMJPCUS3cRJRntgpN2vQu3Vu6PRr0JLz7+380P595a7KNJGM+S
         5A8iT9pmVMkdvN6aj275dC/03l1KAQkTrkuCxJGdFydCNFXSxG0zmzxO7oaGVbnoFV+3
         pk9v1CP2LJcSg2EZvVte+BiupBsqI4u10p9rMzoDI/AFkWzjBQcDYLedUVp1HSHyaMZu
         Vbxc9bBWObJzrgytLzzABaGG0aLSAdpawck8Hrj15bfus0At9r1FumwEIW4tMPm3ozne
         k6mj2L1/jo00wvgCtMnwdE0lmBHRDGKUVSTSDGNkYaOeAliE2mnQjLzuR2Pt1Q5zl/CH
         jGbA==
X-Gm-Message-State: AOJu0YzdNp8x0pyfbN1Xb9jJyJrXGV8xefIRmw/kacmKN6I2hGkUWjSr
	25jrbK797+jfQFDcuLQ+ptRclG2WWkol0FHshsn6QiLYu+RN+Mugnxy25D6YAXICKSUa0SzJsh4
	+KgeeVHe27BgBlKxzLQNr7KPQHqbBRQ==
X-Gm-Gg: ASbGnctTdwYoRFqh0jWEIlskHpmjCAXu37ekmxJk2IKv8V46pJueATNh77oNvW6uRUV
	rj2H95NlQmg7lVA7nEjNh5lg5wKEUZeWIGq/nrPKjIyHi1Xc01jgQT5gRuLODgtQfELXTBYx/qN
	B8N7HWHzl/82UhhtBYnsU1Ql4qy2AFfUOyewk76r6D7zsu3gAthCkOp5SX
X-Google-Smtp-Source: AGHT+IEpcju2DrBbqOinEuewmiSBGFmzr964u5gROLa+wInhR+GTJ79mmU61fg5LuYBCWgKyVfNl2FLxJLVnzCoGiM8=
X-Received: by 2002:a05:651c:b13:b0:30c:1aa6:5565 with SMTP id
 38308e7fff4ca-320aca960a5mr11584441fa.20.1746206337927; Fri, 02 May 2025
 10:18:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALMA0xaVdk3qwkb-92QqF2+6z+=oxbBWDR1hYEoE2WUc7jVGkw@mail.gmail.com>
In-Reply-To: <CALMA0xaVdk3qwkb-92QqF2+6z+=oxbBWDR1hYEoE2WUc7jVGkw@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Fri, 2 May 2025 12:18:45 -0500
X-Gm-Features: ATxdqUHkoxjBUKNssKkCS-JBDIMzvyxstRmxdiCToYHY9CrMzYianiB-2QyJLpk
Message-ID: <CAH2r5mvLwetOfEnoKLaEjsKbgzM_i54L2=9eq1q5oSAbitG4nQ@mail.gmail.com>
Subject: Re: [PATCH] getcifsacl, setcifsacl: use <libgen.h> for basename
To: Zhixu Liu <zhixu.liu@gmail.com>
Cc: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-utils for-next (and smb3-utils for-next in github as well)

On Fri, May 2, 2025 at 10:27=E2=80=AFAM Zhixu Liu <zhixu.liu@gmail.com> wro=
te:
>
> basename() is defined in <libgen.h> only in musl, while glibc defines it
> in <string.h> too, which is not standard behavior.
>
> please see attachment for the patch, thanks.
> --
> Z. Liu



--=20
Thanks,

Steve
