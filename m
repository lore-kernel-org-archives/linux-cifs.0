Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B41B7200C2
	for <linux-cifs@vger.kernel.org>; Tue, 27 Jan 2026 00:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769472722; cv=pass; b=cVXytk+pSnYSY+aJ2Ts7qJWHSxI0WMOZE4pTX196E72/2WBoK6M4yWATuOELs5HLoTgxtBnu28Vc1Y5lMMx67CcqwMaVTE087fJ6X28FTjKQxlYn5mZKKq1YFvj4/cJEt3vetrIeT1fd3QK+spa6FlOk4TVgN37+VtZkx0UNubo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769472722; c=relaxed/simple;
	bh=9AFIZarNXXIq+CScBeq92wMz5SXuJiRvtxK3qSM3RHw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SJtQrklQ66zmvIfY4I3A1Ei0h1+e6COHV/4k1Kb3e3CrJx/ffV4/K3pSEuYFSSDhrs/9fl/N+JrRW+UQsIPmhGhp4loow6cmy8S6suc1Y3I+Z3YTnmT4Vc51Cq2TBReZWYI3Y5xDpXQRwuU6SnNc+k2Cn6KVylEmo5lEeNGkdJA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BgG2zya6; arc=pass smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BgG2zya6"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-5018ec2ae21so57176451cf.0
        for <linux-cifs@vger.kernel.org>; Mon, 26 Jan 2026 16:12:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769472719; cv=none;
        d=google.com; s=arc-20240605;
        b=AMD7cZe8YrWckyMhFkjrncu0DqSIuAo1HoBvQ2ZTzkqJtBaeOC1tcqtd7PIGLDpMc5
         348+lki28SUb8sAQmaWh6R+oo9lH8ghRwpILKkZvqsKDihm0B2DrHSKPgWahIxhzoOgx
         t44UjtF++eID1Ffio0eZZ5OpUYMxGGJ72SXfBSejf/0knmx+TZnOfDcxtk3EScwABLao
         XSESoJTVYSEUOpFIl2sg62dy9jZeuWOdkYyzBDgq/W0W38p5FUOmD+ehnEoc4apIBrUl
         MXOvCOtxjhKZYDIbIbNQ9EiO/MoDOgouH+Rs0ku+MWfQSig7I2uQ8WZ9a4ukGd62YSQQ
         09BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9AFIZarNXXIq+CScBeq92wMz5SXuJiRvtxK3qSM3RHw=;
        fh=8AP1p8I+o0N3IzLZIBuKsFbhJqWBf8Hr/sdfXxJ45VI=;
        b=b9InFBeVyjk6PGvI0C+bkdlgkSO9EWgFgAw7pBZyYnpSaB8Otr1OMJVqAYPSju/HeD
         RFMTCovdllBEOHnhggeGqK2H0uGphSlEfnR1Dng9b0nuz2EMmCkzvv4RQObapeeRhDej
         A0eQzaIy5pw6tVW30M7CvRkiWNRwgIkhM58ykifXGFhyAzY5fr3iHHwFNsf/GaNsDy94
         VRvRD2ouXySAHElaI4OYN/NoELJp0hj+bU2kQsGgTytQ8oRT1CsHDfyYVxoBjolS5U0Y
         z6v8XkVS0cAABLhOLyiuhtuFk29K9zbEFSlu8V6bJYXzmEm6VgWPqUFjSX8CH7a9Ojre
         qqUw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769472719; x=1770077519; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9AFIZarNXXIq+CScBeq92wMz5SXuJiRvtxK3qSM3RHw=;
        b=BgG2zya69SLMSP4oWKOZs4o421kvLePu75GHylMixLXeN9EcYFV6ZE2VDp9YG0xSRS
         Aig2hv/d2F9uFt7Zui1a8DyrZLA3BZHVq+GHUx/Dbd3M557bWkz+XkLTv/KQJRfdhWcI
         J08nMez7kpXlBUfpuL5KwqzzExm8NrVhsX3fTOi4iXX+M650eyfdzniMCN4smFCrVOPA
         9q6v3/ov4mhzNqH07p0XDysubiDQnkAUfIxkNvYdtB+e3UJtna1YwHD9hWJlA3NZ+Wwm
         18FimnluevPlPsyNIMyvq3MDn45BlWol0OLMFjctQvObowg8egh1DLVo4PG9C+XjzCao
         MZyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769472719; x=1770077519;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9AFIZarNXXIq+CScBeq92wMz5SXuJiRvtxK3qSM3RHw=;
        b=sgLwyzX43he4webEiWInIJw8zFo8S5Fd5dTbeHiTo6VWBw4UTacdKKXjlKaXJRZBe0
         ZXfQ5WqN2nwh45If02+MRror/QGUi4Vm8+1lxsRi3CvXiOfNnHiIU9WWcdMpo+Kl/6Cr
         sk8mFA8wBGsecfIgcobXpfS918LgrnK5xvXLDYWSH1unFN7zOGRxWqYiZz8did2cweMX
         s3OUs5K5ohSnFyKFYa2wZ4HCRs+2hccCwRyDH/OHvYnHp2O7Y2jiOD4jyhzyx3ALRGJA
         V3q3FLLIIEtxVfPX7e62yl4saw5YFGsSPc9e9FsQgNktQpBl5SyRlJdcDPvFD/AYHjqz
         Cp3A==
X-Forwarded-Encrypted: i=1; AJvYcCUF0kS9DOgqrtCAdbHoKWXXQ+hBg0oltcd6bRLnD5B4tiUobAazGe2uVNU2MlrNddG3woSV+CC0bzbT@vger.kernel.org
X-Gm-Message-State: AOJu0YxtXThKZhiTyGL7ZJ+DfnfLWOHzgFwclBbLAD5lRU2r7JglFHdK
	YaDAR+azRdcuitl9Wc+K8PeGNelLufaSmqQry3U/1/4vnVHcueGLJyLkcFXSGdaSuhdqD07cy5r
	Y6Bcnkl6+qHprdDiodu2O/J99JyjLfhk=
X-Gm-Gg: AZuq6aJrQFuV+Cbe3QBw+zo4bYj465SummDHnAsaf2gfCOwWOqo4Nn0ow5lQ6uxDovy
	qfhr47IToPkF+IbuZXndLMTRR0HIy6zW7KVbZewM+8KAOP2fX4xtJbmERr68m2yuVJ57ENjYesn
	BLXk83KukZSdwe5RSckA+m0HMX8CrZlHQbT2qxX0KCANrlwVnxmrmis+RG8IoDemm0nIYPOH4Gp
	HQ4P+4swOFC0xO+qk9oU80GdSH/QHY3mHXx3MUbGpI2yRqkNYQenfKnEUeUw+zAvX7Ugnn3hoZ0
	TKwGSR5fnRPxOiUQYRqTcxmVGDy1jlGt6vifkRkG8CcHDC6ys5dnhCWZT71bSijY3k+TdKdVzSU
	wZK69Ge0Q7K+Llc47d8OHoR2hBNSKFYlpCWncV2GA2dWjPSUU5jhT0LXoDLb0nwwVaCrv00VYVh
	giT0VWFxAC6Q==
X-Received: by 2002:ac8:5dd2:0:b0:4f4:ee07:91b9 with SMTP id
 d75a77b69052e-50314d19321mr85031261cf.47.1769472719600; Mon, 26 Jan 2026
 16:11:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <n3ma17AT6PhgrI6OfkbdTz3n_ak9jHfcYoGaAOdyxsY63h-GVDNpzS98XsQlTPN6r2nYxdQ_ODsxNX7fPh8J0PpSJ7-Tvt_8uqjtpfQamGw=@denisons.org>
 <hrQNBHikNUU26Klip-roC5Vuq474cWlMtfx-yvROP7k6iAyEW66dCc8negCRm4xdOuRqAQDa346BJQKyFLl3HveGykv-jkKihJarU5MYpFQ=@denisons.org>
 <f147af48-6c01-47f4-ba51-71b77c1ea94a@linux.dev> <Sj-xdM9FhG-h2q9G9x6pAEQN2TZEyWvq3Vh66-KRyGXnoDxar4KfSmsStO9n2mWnJgez0zqgn7STXBXjedgRKRLs23ql190kfqKNrl1J48Y=@denisons.org>
 <LV9PR21MB4757D8624474C50468BEAE81E48EA@LV9PR21MB4757.namprd21.prod.outlook.com>
 <LV9PR21MB4757E63CE7D0DE2610AF2655E489A@LV9PR21MB4757.namprd21.prod.outlook.com>
 <50b282c2-6a06-42cc-b52e-b545fd8d9e01@linux.dev> <hAshiKr_dint37zHnaRbpo9UNdT9my5xllqfyLLXWYZR5jpRVn2lpTvzgWWng3w-INoptu8YHCUMVtda0JV-ekS3zNGePJgJMqL3wKw6HWQ=@denisons.org>
 <CAH2r5ms02k4feJEmfzenU-DgFMSDFDiCc1=o_JpyaiWcnOU1Tg@mail.gmail.com> <shU8wpo2oNyUu4RkVuN0VHmIES1SzKRN9in6AJDn4EKDDGwMkzl2ShJ8i-4AfFOSKDDnEhxZVGH_w8y9JxO683d_QQzMJOig7eOb0AmaFBs=@denisons.org>
In-Reply-To: <shU8wpo2oNyUu4RkVuN0VHmIES1SzKRN9in6AJDn4EKDDGwMkzl2ShJ8i-4AfFOSKDDnEhxZVGH_w8y9JxO683d_QQzMJOig7eOb0AmaFBs=@denisons.org>
From: Steve French <smfrench@gmail.com>
Date: Mon, 26 Jan 2026 18:11:48 -0600
X-Gm-Features: AZwV_Qi7RD4u7prfj7yRWFBYp5x4ZNxQNyd-aJFoxjJsWx_l3krrhiUl698WXkE
Message-ID: <CAH2r5muJwNMq1ZB_5By6Lk05Mg5-BWdf9Bqck5d+2Ysu+wv6-A@mail.gmail.com>
Subject: Re: Decimated subseconds in smbinfo filebasicinfo timestamp output
To: Sam Denison <dev@denisons.org>
Cc: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>, 
	Steven French <Steven.French@microsoft.com>, 
	"linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>, 
	"samba-technical@lists.samba.org" <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-utils for-next

On Sun, Jan 25, 2026 at 1:26=E2=80=AFPM Sam Denison <dev@denisons.org> wrot=
e:
>
> Okay, like this?
>
> I=E2=80=99ve attached the patch kindly written by ChenXiaoSong, if I unde=
rstand the intention this is simply to allow me to take credit and do littl=
e to no work! I only edited the dates and times in the patches header and e=
xamples. I haven=E2=80=99t ran a single Git command! Hope the patch still w=
orks.
>
> I=E2=80=99ve CCed linux-cifs@vger.kernel.org and samba-technical@lists.sa=
mba.org as requested
>
> Sam
>
>
> On Tuesday, 20 January 2026 at 15:40, Steve French <smfrench@gmail.com> w=
rote:
>
> > You can send your patch as an attachment to us, you shouldn't need to c=
hange your email address or worry about smtp.
> >
> > Thanks,
> >
> > Steve



--=20
Thanks,

Steve
