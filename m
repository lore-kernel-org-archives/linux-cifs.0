Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E7561B4234
	for <linux-cifs@vger.kernel.org>; Sat, 15 Mar 2025 07:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742022594; cv=none; b=jDVdbdCXqGyoF736CyGlVGiYABaY9371cS+idlbS7zHr9hmc92rgm5BZVPs5kYrTiSqZY2hNbOU6rgbA044emINnL2+lQ2aEndAoiz5RpIfMjiSGlhEsUwS4BXXN1UWRm3M/crxGq5cBLLZVgqqTvodoCxnbc/HAmbaBSdaq4AE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742022594; c=relaxed/simple;
	bh=4XSyR7JlNP89U0Q7UNqehDDOEQwlnRFQ78BEGvR4Kfo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uzWg+NPOJOc8YSujq3/ZjiYVQlbZJcsXg1VoWAryLGBBKiPRW3ZU1Ni8alj75hYqfQtp8aIAF2ZXevPopczwfEzSz+VCqDyytaGX4iOB3dEl6ArfEwWL8E39N6i8Jk+LdtUh8w26d8Qfbd6OB/0UkUenAjfyf54cpVnWjQqTgGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Rp8pgNao; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Rp8pgNao"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5e5e0caa151so4918608a12.0
        for <linux-cifs@vger.kernel.org>; Sat, 15 Mar 2025 00:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742022591; x=1742627391; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JvrSmemaf0jLLe7MDCLU4Hh7OYwc3Mb5NtW3VaVfIqE=;
        b=Rp8pgNaovF6L4r+Souvn03jg6gNHRX7q7f3yFPG8EDA2kaWClpkYjZcZGmPoPgjsgv
         DDcoY8fQWsqXPrBXxSoNxg9JDNuJhmiVeeMbMoNo4KaGNXF4Wpn0dujrTCFBBJ4VLf/d
         A2v4n7RWSo5vlFskBh1eYvdm2T+NTG5wzPY5bD8NdTki/QfdIapaocYrl6USwhDAIBp+
         D/EHw7nNDJCtumt5bvgIDYd13pTqa6tTnUI9yZKNK8Fzv8mPqs6i9HorMAhFpW3MmAIX
         oekdlbEf3PP5YiTHA+xNv5JftJyjbOyeBPLDBVePY4q8o67Uil4eOMQtYarPkci6iO/O
         Ieuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742022591; x=1742627391;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JvrSmemaf0jLLe7MDCLU4Hh7OYwc3Mb5NtW3VaVfIqE=;
        b=HNHIdS4cJwBr2uH5uaBvMJPWTL8PvaEEK9G1okmPz3Z/ptzqofa1Y3RK1BwOgsVOLz
         0/2SeepspRcMmOvxFVblBqzkJ1U0suGzo/jdHfNScuZ6Tu3KmOZE1+4quYjg7H1fR6Rd
         tBaDZC9YRx3zu6XchykN6KLWYw27QvugUHr51IQPSh/wFTcGRGyoNpl2HOpkx5xXkiTB
         Rkuvs9QYKILX/u1MOQtKtA0vx50cjm1zrofOZu218WX7fVn7i7pkQRuAiGyj46Me0von
         A63juqJriya4SVqxmKT4SV2L3ngm4EacIyqqykJxzHWBkaOPUBLFgqz3DNw12zBXIbeg
         H3HA==
X-Forwarded-Encrypted: i=1; AJvYcCXXoHQl9E8OHPkOm7m9uVHN0oa1EZsPxHNgIexG+XB00CMuOzyIgdzFXv3OWv0JwLQqTV3Wm2stBdlu@vger.kernel.org
X-Gm-Message-State: AOJu0Yxsmo4kOlC9FCsUWQHBS8tzX+0cXOvGVHzTeh9J2X02q8jAXP49
	NMeO5Ph+t+eA0XGh77Hr376ViiYZ285zk0AmiKeft7+Z1PnbuY6EwD+J/DShh2Eb1P1OpXPZ+Cd
	Px2N2orxVPLL6XR34DTy38axxPm4=
X-Gm-Gg: ASbGncvqDQexCBWP6OUn3oQALiyxlrgvoR1T0zcpOgHFkp5WUDXPFdiXBGRHYXnoMUw
	NmHUMsfGZ70rQdCzoWBjQMchA8tFWW0hmHetoI4sGrN42nBpqVw9nOTMA+q7h6awQ5KHvbS0IfM
	bFqed+E9FvHgUlrCgtboRw9WMVyQ==
X-Google-Smtp-Source: AGHT+IEt+Jjk9gMruKyuzZfSvsi0EWzw4SxMFYXZZ9qFt0pnbYk9MQGr7Da/aaoWp+WaMrnXBJf2fQRDAQ92in9PXrM=
X-Received: by 2002:a05:6402:27cc:b0:5e6:1352:c53d with SMTP id
 4fb4d7f45d1cf-5e8a0bf1f19mr6199625a12.28.1742022591238; Sat, 15 Mar 2025
 00:09:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250312135131.628756-1-pc@manguebit.com> <CAH2r5mtjtigJf7JKUiL3D5Lp8f4qTe4GUxQPXwz1o=SQMqiqdA@mail.gmail.com>
 <70d0157ac13725595d64978b11c4d3a91f417803.camel@redhat.com>
 <4cbaab94c2ba97a8d91b9f43ea8a3662@manguebit.com> <CAH2r5mu5=nnBwibmARGoLepbQfU6qkXnez8whaWaSM7G7MEVXw@mail.gmail.com>
 <9ef1d7140c93877011e7ca5fdcd13ec4@manguebit.com>
In-Reply-To: <9ef1d7140c93877011e7ca5fdcd13ec4@manguebit.com>
From: Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Date: Sat, 15 Mar 2025 12:39:39 +0530
X-Gm-Features: AQ5f1JryrxuTiPw0OE7usym4tvRUacEjjktn29DI9NElicUqj0wawGI-CqzojpA
Message-ID: <CAFTVevVmp7f5Mv7CZhKhV9287ev0Wf9=7d3qakS6BNs2b4wayA@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix regression with guest option
To: Paulo Alcantara <pc@manguebit.com>
Cc: Steve French <smfrench@gmail.com>, Adam Williamson <awilliam@redhat.com>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks Paulo, created a PR for cifs-utils based on your suggestion
https://github.com/smfrench/smb3-utils/pull/14

Thanks
Meetakshi

On Wed, Mar 12, 2025 at 9:53=E2=80=AFPM Paulo Alcantara <pc@manguebit.com> =
wrote:
>
> Steve French <smfrench@gmail.com> writes:
>
> > Meetakshi sent a patch idea to try (to also fix this in cifs-utils) -
> > will take a look
>
> Where is the patch?
>
> Something like below would work
>
> diff --git a/mount.cifs.c b/mount.cifs.c
> index 7605130..16730c6 100644
> --- a/mount.cifs.c
> +++ b/mount.cifs.c
> @@ -200,6 +200,7 @@ struct parsed_mount_info {
>         unsigned int got_domain:1;
>         unsigned int is_krb5:1;
>         unsigned int is_noauth:1;
> +       unsigned int is_guest:1;
>         uid_t sudo_uid;
>  };
>
> @@ -1161,6 +1162,7 @@ parse_options(const char *data, struct parsed_mount=
_info *parsed_info)
>                         parsed_info->got_user =3D 1;
>                         parsed_info->got_password =3D 1;
>                         parsed_info->got_password2 =3D 1;
> +                       parsed_info->is_guest =3D 1;
>                         goto nocopy;
>                 case OPT_RO:
>                         *filesys_flags |=3D MS_RDONLY;
> @@ -2334,7 +2336,9 @@ mount_retry:
>                 fprintf(stderr, "%s kernel mount options: %s",
>                         thisprogram, options);
>
> -       if (parsed_info->got_password && !(parsed_info->is_krb5 || parsed=
_info->is_noauth)) {
> +       if (parsed_info->got_password &&
> +           !(parsed_info->is_krb5 || parsed_info->is_noauth ||
> +             parsed_info->is_guest)) {
>                 /*
>                  * Commas have to be doubled, or else they will
>                  * look like the parameter separator
> @@ -2345,7 +2349,9 @@ mount_retry:
>                         fprintf(stderr, ",pass=3D********");
>         }
>
> -       if (parsed_info->got_password2 && !(parsed_info->is_krb5 || parse=
d_info->is_noauth)) {
> +       if (parsed_info->got_password2 &&
> +           !(parsed_info->is_krb5 || parsed_info->is_noauth ||
> +             parsed_info->is_guest)) {
>                 strlcat(options, ",password2=3D", options_size);
>                 strlcat(options, parsed_info->password2, options_size);
>                 if (parsed_info->verboseflag)
