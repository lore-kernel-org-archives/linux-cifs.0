Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4E511C93B2;
	Thu, 22 Aug 2024 11:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724327671; cv=none; b=kfwzPRO2xa0bpoxoSlAvXq54a2nkMSoPuR3ThLROsO6thPBfyYDxIt4e097xD9yPE0vD8oEBNcZcLXHtZPc5T6KkJkA1e3B5/vnTIu2a/PIuMOzoyYKgFznEGOyRg12Fj/XWIZR9jOIEXEaPQPR/yIeUltDezzKyt1tYcwYhODY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724327671; c=relaxed/simple;
	bh=EuS90j+urrDTRrW2hWNn8rNaiYqjwhWB+SXCI2QrWRA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=t+hjW6b4g0Hvau7ssJUrNI1s3IMNIULwKaWULiu+PLcuGFK5uxkIkGf0ca2NBMIbOdshsIiXtiOEbxnITjn/lJnnhdSXRvnzHLqbl9W0KEMYkxLYr3rjtrBwNmNdFpXn0VHLBjpS/M4Tt8m/5dfa31Xd3raVDpAg8x37Q8UeTAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q+ndHjup; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q+ndHjup"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EE36C4AF0C;
	Thu, 22 Aug 2024 11:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724327670;
	bh=EuS90j+urrDTRrW2hWNn8rNaiYqjwhWB+SXCI2QrWRA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=q+ndHjupri4KF9R8pPs8HEGrf7WBFtSI4iur+pJWuMv+OcEMxe/ZylPXjAOy+GE/b
	 90KwVxj70zfUK06eV/6NnB+1ih/GoHfngM/BUd9bQtjuYI/pmuB6C8SMHWSFOIqn8W
	 2VyeiF8c11d3axp7EViYm4IYxa+YPXx51o/XPw9sCvIVzJ9w5f3zs9dbYMBA1L3BQH
	 aSf2gmVROSl74Yyn3ijCmJ2mc9tn6Bo/6Hzsa0z1hL363yuk+Tyn6j5tIT7rOEAlBY
	 zHp8v/jtkkP61AEoYJi4539tHAkXhsa4JGscGbohUlQWubHauSivDWZVfeiPzONrq2
	 J9m7r7t6Vb+iQ==
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-2f3edb2d908so7124801fa.2;
        Thu, 22 Aug 2024 04:54:30 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUJp65wDloR5IoRKyGkaYbkoh7FN/ZB1kVyEUINNQV3e2ODRguOkH9es2MCf90iKAbcwhw8AS2Q1fpbrTr5@vger.kernel.org, AJvYcCVDhtphORdJcP1wdIQqdh6U6gmhtjQ4mlfGqQoozxYW6bCsoefY9DwMRiXYDjY3OgVu/iLTSp62kA/P@vger.kernel.org
X-Gm-Message-State: AOJu0YxaxYLQztu6LrStGhAlwZoIPIpLoKH33j+7Mmwe9OYZFNxQXxI2
	CUaxsmSlddT5k6ledAQ60kIknDTMZO3mhhuqI8BernDABk48NkRaFqvf8S5r08WCTGUVp6nRUW9
	Ac6QXuTIp+fBxBHR3YQ/aNB+CnXI=
X-Google-Smtp-Source: AGHT+IEqL9Fhmg/PB1bwvSMESD15EArG4hDr+nLJ5iZ4X4vp/WwYXpZghPeW7lbxZnyn4Ns1pF8ALcz+kTiqa+bzncg=
X-Received: by 2002:a2e:b8c4:0:b0:2f4:15f:fbf with SMTP id 38308e7fff4ca-2f4015f1013mr20509841fa.47.1724327668812;
 Thu, 22 Aug 2024 04:54:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240822082101.391272-1-chenxiaosong@chenxiaosong.com> <20240822082101.391272-13-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20240822082101.391272-13-chenxiaosong@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 22 Aug 2024 20:54:15 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_hBkLsRoSG69Kts+XiBk5NJoaYTch=sQ2f9x0EhSsUNw@mail.gmail.com>
Message-ID: <CAKYAXd_hBkLsRoSG69Kts+XiBk5NJoaYTch=sQ2f9x0EhSsUNw@mail.gmail.com>
Subject: Re: [PATCH v2 12/12] smb: add comment to STATUS_MCA_OCCURED
To: chenxiaosong@chenxiaosong.com
Cc: sfrench@samba.org, senozhatsky@chromium.org, tom@talpey.com, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, pc@manguebit.com, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, bharathsm@microsoft.com, 
	chenxiaosong@kylinos.cn, liuzhengyuan@kylinos.cn, huhai@kylinos.cn, 
	liuyun01@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 22, 2024 at 5:24=E2=80=AFPM <chenxiaosong@chenxiaosong.com> wro=
te:
>
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> Explained why the typo was not corrected.
>
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Looks ok.
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Thanks.
> ---
>  fs/smb/common/smb2status.h | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/fs/smb/common/smb2status.h b/fs/smb/common/smb2status.h
> index 841d4c688411..14b4a5f04564 100644
> --- a/fs/smb/common/smb2status.h
> +++ b/fs/smb/common/smb2status.h
> @@ -901,6 +901,10 @@ struct ntstatus {
>  #define STATUS_DEVICE_ENUMERATION_ERROR cpu_to_le32(0xC0000366)
>  #define STATUS_MOUNT_POINT_NOT_RESOLVED cpu_to_le32(0xC0000368)
>  #define STATUS_INVALID_DEVICE_OBJECT_PARAMETER cpu_to_le32(0xC0000369)
> +/*
> + * 'OCCURED' is typo in MS-ERREF, it should be 'OCCURRED',
> + * but we'll keep it consistent with MS-ERREF.
> + */
>  #define STATUS_MCA_OCCURED cpu_to_le32(0xC000036A)
>  #define STATUS_DRIVER_BLOCKED_CRITICAL cpu_to_le32(0xC000036B)
>  #define STATUS_DRIVER_BLOCKED cpu_to_le32(0xC000036C)
> --
> 2.34.1
>
