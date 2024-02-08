Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B01823A7
	for <linux-cifs@vger.kernel.org>; Thu,  8 Feb 2024 16:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707410650; cv=none; b=Ljh5tJHPwbtq5jmS91mytZWTeL/ysJ+d1+hGr4PNVK8eOQ8w4zl/9qsRJmWM/u1frxhWzIe/zux0SXM3j23xpkDCN5RDOURdgdTBxKTWB3VSoPy0PmWnKfFT9EH71kGIvlsRHjr0z//4bUotlOpm+V1LAIvfDeWx7j2NMq7T/Rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707410650; c=relaxed/simple;
	bh=SWvbZtY6qDxfyW4KrS1B9epqrolbuJvO9ct5FT9Nqr8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qrXn5B6l0+lzCQFxReKglEZB+uuBHfeAIYRfezGDxx4Ljk0hnGP09kSkA0sRqpyENXk7/I18VW6F5axHqrVNmiRLPfekZaCnoF5FhyIGloGc8W8QzGd6oQmaA5MKyPwYLb0mwajOLIn36ft/fAZhddUEcWf2pIMbIy2E4wTBGok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XAfI6iLG; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XAfI6iLG"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-511717cfa62so697653e87.3
        for <linux-cifs@vger.kernel.org>; Thu, 08 Feb 2024 08:44:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707410647; x=1708015447; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bn99mLYfBA4B9quQ0tHmCrwkV7dDVY8lFI/viLoh/Io=;
        b=XAfI6iLGaxHDDoOfe5LabItK0uEf9w9ZzS2+GTc05GwvkXFP5EDr9kwURbNAjWT/Cr
         5u081xF2m2FHJVUC3FTJiAnA6Q3CXcWcCPBDfLfdGUIlYbNOmVyuJJ1HXPe/+s7o6jCi
         JOB/GvNou/F4/NbEQA3irFdcYelOMLPYrYNvAun6rTNuIqinIodLG7a7DAY+OSF2WcUs
         JMfx1L6lVqnEgMhTjNUo0TYGWddfL0JoCODyitU6eThwT8ElHq0C2cjgJTqn+fGu83NE
         3Vkdt8toy9o9N7LyWUFMMW9DRn22u+wiTQboVdj3a1475x0QZb7ZfQFa8+dAsIQOMzyJ
         rN9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707410647; x=1708015447;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Bn99mLYfBA4B9quQ0tHmCrwkV7dDVY8lFI/viLoh/Io=;
        b=OEsuTDjmVwDNbaSICsaUdD1zfpt4kBfjvUtQ1jyXbcRXZVpuOQjqRarTMWqT9QZVXJ
         HMkYhxaGONzGAKOyUuEH+LhDDwAOmnHmuAIOvusrGlmbCSzAWXnAUoeQx7QLgZOkIyV/
         J561MdN5Y33wSzxMfEgnxG7EbN4hosbcbjfwcJuGMZSo/+QBOuPTQeAKK8ZzkTaBZEpO
         uKkwd2+MhdbPQAKCweTLLQ7SklwR5j64O+Z+YLQXiI4NwSCDSHc0w/BgZomna9AGLWbr
         SOKNGb0k2lnygiZPmfQjH7IwClcZF2+ocgc/I+mDvhdOuTTsIwPdLRTMOqlcAiwiCIKO
         8WdQ==
X-Gm-Message-State: AOJu0Yzgz7e7wdCx+9m+nuLbiq5XPCHuLGaXFRShnafbxa4vqYPgGN/q
	n4xBfBVkz/iuQj8BEF2+7EDuu6c9FgmTx/QWenVtd80ah9yiYXeaMYzEa+xJ1Rqnq0oLBdWwn4O
	c5SNFffYCAVqlrsTB6IZIT9VUdApkdqrOB3M=
X-Google-Smtp-Source: AGHT+IHDXo7hJEjVCsdZUNorRY4OQ9Cn2/PoeJI4ym3rhvQ0Vw3q1GxEdBhqZFZaCNzfLJ2xNYz6jBwmY+C6jKCkF48=
X-Received: by 2002:ac2:4116:0:b0:511:617a:3130 with SMTP id
 b22-20020ac24116000000b00511617a3130mr4671813lfi.35.1707410646485; Thu, 08
 Feb 2024 08:44:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mutYBiXyBnMWKF66DGrKHd7=ypsPGcg_XSrJW=JykNBbQ@mail.gmail.com>
In-Reply-To: <CAH2r5mutYBiXyBnMWKF66DGrKHd7=ypsPGcg_XSrJW=JykNBbQ@mail.gmail.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Thu, 8 Feb 2024 22:13:55 +0530
Message-ID: <CANT5p=qRUd3w6E9v7zhLjmtTkQkM_fgoPqH=QNDF4dOoePwXTg@mail.gmail.com>
Subject: Re: [PATCH][smb client] updating warning message for sec=krb5p
To: Steve French <smfrench@gmail.com>
Cc: samba-technical <samba-technical@lists.samba.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 7, 2024 at 11:38=E2=80=AFAM Steve French <smfrench@gmail.com> w=
rote:
>
>     smb3: clarify mount warning
>
>     When a user tries to use the "sec=3Dkrb5p" mount parameter to encrypt
>     data on connection to a server (when authenticating with Kerberos), w=
e
>     indicate that it is not supported, but do not note the equivalent
>     recommended mount parameter ("sec=3Dkrb5,seal") which turns on encryp=
tion
>     for that mount (and uses Kerberos for auth).  Without an updated
> mount warning
>     it could confuse some NFS users.   Note that for SMB3+ we support
> encryption,
>     but consider it ("seal") a distinct mount parameter since the same
> user may choose
>     to encrypt to one share but not another from the same client.
> Update the warning message
>     to reduce confusion.
>
>     See attached.
> --
> Thanks,
>
> Steve

Looks good to me.

--=20
Regards,
Shyam
