Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C281C93B2;
	Thu, 22 Aug 2024 11:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724327618; cv=none; b=gC04qMui6CTUt0jr5oSwHyE/wRDna4VpswsZRiwQFW+EB+NaOIczRRaRtjXUX4S/l4ng+ZH6L22t1aBqUXY0CsKI/UtpVjreOn6kMPISrKFyXgINaOEKE7E8hxNFQXtPZJ4+I9BAp3O3ADvOZKWNPwktZKIUJRqmo1HvzpgB0eI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724327618; c=relaxed/simple;
	bh=azQANqsWwf6aLPgPfh9mCsQ80dRLL+FmyHHzLCCATUs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Yc2GmLpBYqmsvyQ1M7nwq2/NPgp1/tL8WMTrz1O3CWee1nTqj2DYZuiKETarL33phQg//zBcYy1vY65hlGFBhI8k7zHnJSbfn2+eKEbwVv0lKg4UD6gNMAIspUX1F98XS6afUuYyH2f/gxGtprDdAzlyp8V8FEkCKUIiWD/OcUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hm4A93oW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hm4A93oW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B33D1C4AF13;
	Thu, 22 Aug 2024 11:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724327618;
	bh=azQANqsWwf6aLPgPfh9mCsQ80dRLL+FmyHHzLCCATUs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Hm4A93oW9rUSSB1mS6tAtCR9hAUaO+okvD6S2baoPZAM2+6POk43AaVJiGpMdl0Pf
	 VU7TxOmFD3GMeGJYMrwBMueXHpdE7Mu3IuJMg7YUijDlRD1rVHtIqdkXpohUfYRXzd
	 RBwp0kzNie9ShvVTaCGgiBvNSvqwgkTUrfqPXRSKvAWAdqLYki83XSXpCF9n0riZUv
	 6Wi/IZzq13xjsTCvMuu6po03V/OlQt7ihKeUtY54yvGgOUWRBB6C5NLKPgFqJTfYCF
	 KaqTvA+37R5cHyNVcHsEHFk7AbwEWUTPDCfPRr22To3DqajS1Td7WzWgLiqfMV1bEQ
	 qA5eeLi56Dgnw==
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5334c4cc17fso1005741e87.2;
        Thu, 22 Aug 2024 04:53:38 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWFkrC8A4+flTPa6J5kvXFuLPAY8hCUCNa524WL4BxIhoBHg32VI487Ek0c3WFxooFftd3z4EwevqI8lAm7@vger.kernel.org, AJvYcCWkbzCMBLJRMgVX3VdxXq5BokwW1XktSz5s4aZr1AD65GxhEHQof8WmIBvl1RduartffzCJ/Ae7M1qn@vger.kernel.org
X-Gm-Message-State: AOJu0YzxgVbvgY8da3YAszegpsVEcgm9IFPQ0Nlh/uG3U5YTfAeDtzY0
	TmIxEgfeMXku+pJg+2t8FDEAiSPT7BX3wI0Nni3KDQHtuqKoWl2obxodNOcGwqKlf39PkXflKM7
	QCW4H+7z59KPPmIDJaCovpkwPsqY=
X-Google-Smtp-Source: AGHT+IEKTtZ0Wzw0IZDEXBe18nTmhSyqso2zCdNj/v66E80ZSxke6q0jbsTMlry8WiFXieVMH4HWV/1qrvWyqc+zxjU=
X-Received: by 2002:a05:6512:3b96:b0:52c:d27b:ddcb with SMTP id
 2adb3069b0e04-5334856503bmr4198415e87.3.1724327617090; Thu, 22 Aug 2024
 04:53:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240822082101.391272-1-chenxiaosong@chenxiaosong.com> <20240822082101.391272-8-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20240822082101.391272-8-chenxiaosong@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 22 Aug 2024 20:53:23 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_Z+2-qVnVsgcsW3vr_MLcK73SQZMk2buQda8m0v9ZxiQ@mail.gmail.com>
Message-ID: <CAKYAXd_Z+2-qVnVsgcsW3vr_MLcK73SQZMk2buQda8m0v9ZxiQ@mail.gmail.com>
Subject: Re: [PATCH v2 07/12] smb/client: rename cifs_sid to smb_sid
To: chenxiaosong@chenxiaosong.com
Cc: sfrench@samba.org, senozhatsky@chromium.org, tom@talpey.com, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, pc@manguebit.com, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, bharathsm@microsoft.com, 
	chenxiaosong@kylinos.cn, liuzhengyuan@kylinos.cn, huhai@kylinos.cn, 
	liuyun01@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 22, 2024 at 5:23=E2=80=AFPM <chenxiaosong@chenxiaosong.com> wro=
te:
>
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> Preparation for moving acl definitions to new common header file.
>
> Use the following shell command to rename:
>
>   find fs/smb/client -type f -exec sed -i \
>     's/struct cifs_sid/struct smb_sid/g' {} +
>
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Looks good to me.
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Thanks!
