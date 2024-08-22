Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A2A368;
	Thu, 22 Aug 2024 00:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724285522; cv=none; b=PvA/GDql4UbO/urWv7TTwSio23Jlw7o9YGKfrKVShxiSFv0cyR6fDkbqjRWw27s7V8+LmiXPV/ycSeG0uHhlA49/+4dj+KOWonR2DnlGaLfOeom1UvSA/HMy2uut+I7haAIhq9nxoQV+5xrX0MYmW74fi2U6VMw1gF9DVLtPLdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724285522; c=relaxed/simple;
	bh=cOB+YiLmNayeW6bviExoaKiZs04FFiGdmrtliqQuWXc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EVrgty0TD3JbsRs7FcISIfVbsM1FhhfrVk67qW3ZS5KAwQ0j6rCwuO2YZgJ3qT+hsg9vDshbctWBkbDtcI+JhEMv7Qc2TBvV7LyZup7auaFJHiiSsb3wImeLgnrZUWalLGewMRPdlGx3zprJeHKH70T+0nlEGnANSAsPzxytVy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M8bUqlAW; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M8bUqlAW"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-530e062217eso286424e87.1;
        Wed, 21 Aug 2024 17:12:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724285519; x=1724890319; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ixcwWDPwJmqg6oOHPuUmOi09F3Uk9NfClTZxuEFkMi4=;
        b=M8bUqlAWj2Z2EEj2G9snVCQnaJNuldiySIOaDfkU3Qv7lBCBJs/NXt5gqLbMsV0CJT
         v1FPfF6YvdHv5Pa0h/UDvD4E4dDGCX7z0wGceUzyN4zGicpZkr4VUgUzQrwqGb9dzW7M
         U9BKPpzdNG64iD8sZfZMhQlcSs3UK38r/XPigH2BFPc91LqmyljWRTc4Ej6ad375+avf
         wKuLfs5lQzMkkWBk67ANeIWOFICh/Plor72Ifio+cU1nBSlpbXwK1wsa5yWN5hIoLwpz
         1Q5tCuNPzd3gAr+cTbE1zAVKPMRg8/t4YEhC/isqbRrfQyyMOM/XigXxKZGMDKnmKUgh
         3Gzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724285519; x=1724890319;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ixcwWDPwJmqg6oOHPuUmOi09F3Uk9NfClTZxuEFkMi4=;
        b=KiPk7KOIE373att1iIDsbKlGmzfavGJQt5n8HOi+YRzMjkaCmd3xBjKo8w5mnLV3Os
         ozvqQOeY3NLTReFS3FbSowIVi7qKL2/f7FqcSx5CRXko8NuBTe+2cIl/2k3Akb0gN+9Q
         HslbUbKmcR30R7CI/22T1pA4/9qpTr3F7t6NOkIO8aj9oGJ6kqvq3HsxNaF71UZO7fdI
         f2JTP5lV/4c+vIwyTDaU845q1WjQb51LojZBfaH2hrmGhlV/DDmSaBBfk8PZYjKY+75h
         bUjR96ttaKL2+VO3vs/Yu421KTcJf/QUr8BwhuAJUYDEOvO3svL+wN9G/etuq4iGp7Vc
         hDNw==
X-Forwarded-Encrypted: i=1; AJvYcCUC4jOAvULYNo7DHh7hQj3Y3CjTCPNwRGnus2WXDdONDctu6avDoI83b/mhIZp2YYAIlYfcbSJnV0/m@vger.kernel.org, AJvYcCVyCPzev1MB/A9C7cED9U60f3xfjKM/80cNApM6q5ln06MY2wNm/gxQOEfL93cvlwHEL7CJzaqsSkJYhWvb@vger.kernel.org
X-Gm-Message-State: AOJu0YwcDjwOT/bCEpSwLuymEDDPzUKPOOgvdy7plWiT5Btdi58JXng8
	/wVbuAZkVCqtXPoTPPOA0XGe4K2jYglOeRRKhAgw7shVb4VUbJ2zzR2vAAbl5kbOYJnGA6vubQp
	83K6hDHZxBCJzG3UQacPiTrtIYBU=
X-Google-Smtp-Source: AGHT+IFOy8SQawRILFRXkqtw7mPwJHZkOXKB1VElMoyfPyqP4qEUIRGBU6t8gISxXvQF7NkibaPkNsSZV8lUD5nbRNE=
X-Received: by 2002:a05:6512:15a9:b0:530:ad8b:de11 with SMTP id
 2adb3069b0e04-533485650bbmr2147090e87.9.1724285518810; Wed, 21 Aug 2024
 17:11:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240820143319.274033-1-chenxiaosong@chenxiaosong.com>
 <20240820143319.274033-8-chenxiaosong@chenxiaosong.com> <CAKYAXd_XWf33rCHMh8AjhXKZEdvcRS-xXew9FDeitExNaezW2g@mail.gmail.com>
In-Reply-To: <CAKYAXd_XWf33rCHMh8AjhXKZEdvcRS-xXew9FDeitExNaezW2g@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Wed, 21 Aug 2024 19:11:47 -0500
Message-ID: <CAH2r5mvqi0miAzd6FtJiK9Wfo6oBDVV8_vwV8Fi0bUnT+i1oyg@mail.gmail.com>
Subject: Re: [PATCH 7/8] smb/client: fix typo: STATUS_MCA_OCCURED -> STATUS_MCA_OCCURRED
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: chenxiaosong@chenxiaosong.com, sfrench@samba.org, senozhatsky@chromium.org, 
	tom@talpey.com, linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	pc@manguebit.com, ronniesahlberg@gmail.com, sprasad@microsoft.com, 
	bharathsm@microsoft.com, chenxiaosong@kylinos.cn, liuzhengyuan@kylinos.cn, 
	huhai@kylinos.cn, liuyun01@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

aah - good catch.  See MS-ERREF section 2.3.1

Will back this patch out of for-next (and backout patch 0008 from
for-next-next).

Chen,
Can you update those two (and fix the Signed-off vs. Author line) and resen=
d?


On Wed, Aug 21, 2024 at 6:57=E2=80=AFPM Namjae Jeon <linkinjeon@kernel.org>=
 wrote:
>
> On Tue, Aug 20, 2024 at 11:35=E2=80=AFPM <chenxiaosong@chenxiaosong.com> =
wrote:
> >
> > From: ChenXiaoSong <chenxiaosong@kylinos.cn>
> >
> > Preparation for moving the SMB2 Status code definitions to a common
> > header file.
> >
> > Signed-off-by: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
> STATUS_MCA_OCCURED is not a typo.
> Please check microsoft's header definition :
> https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-erref/59=
6a1078-e883-4972-9bbc-49e60bebca55
>
> Thanks.
>


--=20
Thanks,

Steve
