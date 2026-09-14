Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA87B33F58B
	for <linux-cifs@vger.kernel.org>; Mon, 14 Sep 2026 03:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789357122; cv=none; b=H8iKtf5y2L9M8k70iDh0cJYaGhiy/Ehh2QWDRylH+F7dNiEJiVs83g6UdsZmAJwUUXVz1DcxQn0g5T0lNb4+xXut0Zn8dQzlldf7ioH34G2WQnLCFNNfNU9bZmPz+R+w5zzaBysB6/im6BP49BUvrsbbFwIBxjb4tnXmcRmF1O4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789357122; c=relaxed/simple;
	bh=NQCVw4ExNySbYN7hrq8FjO5Lr5CSLJ6NRs1hsX02wXY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=o9/vdYnzZuRqnEZgyfKhop/mQXBbDGV9+43OwPS87dhGMG2fDRC+zr7Dmlq2Vcuo9f32EwO118iAvuMj8ORqfje5rnparmvYe2tROy5yFCI4hmcvL/E6NIWFeD4mP77Qrtpbju34WSkukw8QggLjmHUsVJeaizgB5Cwr2x25wH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l2ZGKFHd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l2ZGKFHd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 872D01F00898
	for <linux-cifs@vger.kernel.org>; Mon, 14 Sep 2026 03:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789357120;
	bh=8b9H7JzxuFgYGfwC8FBPZk24oQId/O0xJ7XYiUVnClM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=l2ZGKFHdeS5MFe92JGn2YxcJnn3YQtbuHQVpWvnt6V3jY5Wp73H6rUpQxz3WDZ/XF
	 /bLr1qvyRal/7do96mciV4EFthgl2yXYQ3Ad6cMQhyRPXFr7ZjSUv5eWYH6RFTADIP
	 lCtWWIF2+JUgPqNQqUO8DIHp0FG/2HyM0BqYPHpNm32m4NGNssfzm4sMUcEK93JRCo
	 PIj6I0fwiMWYGDNytc3pgt9QQdtmIwmzXgNkoPVlMoXqnYLqUDkjKfNW0EhJk5oRdo
	 ocF5Je9e+Q+5DIQW5rCs3QuSC1KkQDa7Im8GVm44Eyg9CAy1J0osOb4O3SgoSmo2oo
	 HVMumXBEmUY4A==
Received: by mail-ed2-f12.google.com with SMTP id 4fb4d7f45d1cf-6a9c4c3e3b2so1905531a12.0
        for <linux-cifs@vger.kernel.org>; Sun, 13 Sep 2026 20:38:40 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByZwS0tXaS3nWRXGZldf70iTENg6UHDPdxOENbgbvfnOywdAiRqruayHlrML3Sma1qJyszLCm6KTb9t@vger.kernel.org
X-Gm-Message-State: AFuF++l+KonBXTioZFy0JacgGFl5UQiZdrXsO1lFNP852DEkyLuFfbiB
	5bsSec/9A2gn0nirwLSY3VoVob12a/46tp12Bq6x0JMM3FR+3lQZ/mAyXkILCuOpIhfEa4nKk8K
	+5n9S3W4kwckNRHyBZA3ZGaU3OnXhK5o=
X-Received: by 2002:a05:6402:1ed0:b0:6a6:4783:b6ff with SMTP id
 4fb4d7f45d1cf-6a9f61e3cefmr719561a12.4.1789357119200; Sun, 13 Sep 2026
 20:38:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260913113552.11486-1-linkinjeon@kernel.org> <ebb45fdd-76f0-4d92-9899-13ecdaea555c@chenxiaosong.com>
In-Reply-To: <ebb45fdd-76f0-4d92-9899-13ecdaea555c@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 14 Sep 2026 12:38:27 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-efarHzvWEXSc_0jx6KhK3KJOfmuwM+wsVCmcsFUBTWA@mail.gmail.com>
X-Gm-Features: AcwNN1X2gdeHGtJk1kVRm_0qGvRr6d2zan84NumKcVgY_PL8-F4W4AbH2zMWCA4
Message-ID: <CAKYAXd-efarHzvWEXSc_0jx6KhK3KJOfmuwM+wsVCmcsFUBTWA@mail.gmail.com>
Subject: Re: [PATCH 2/3] ksmbd: fix partial normalized name responses
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: senozhatsky@chromium.org, tom@talpey.com, atteh.mailbox@gmail.com, 
	chenxiaosong@kylinos.cn, Mobin Aydinfar <mobin@mobintestserver.ir>, 
	linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 14, 2026 at 11:38=E2=80=AFAM ChenXiaoSong
<chenxiaosong@chenxiaosong.com> wrote:
>
> Hi Namjae,
>
> According to MS-FSA 2.1.5.12.30:
> https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-fsa/3d5c=
68f8-fbc5-4f94-a51d-3600a319fd45
>
>    Set AvailableNameLength to BlockAlignTruncate((OutputBufferSize -
> FieldOffset(FILE_NAME_INFORMATION.FileName)), 2).
>
> It seems that the following changes are also needed:
> ```
> smb2_get_info_file()
> {
>          unsigned int req_output_len =3D le32_to_cpu(req->OutputBufferLen=
gth);
> ...
>          case FILE_NORMALIZED_NAME_INFORMATION:
>                  fixed_len =3D FILE_NORMALIZED_NAME_INFORMATION_SIZE;
>                  req_output_len =3D round_down(req_output_len, 2);
>                  break;
> ...
>          rc =3D buffer_check_err(req_output_len, fixed_len, rsp);
> }
> ```
>
> By the way, it seems that `struct smb2_file_alt_name_info` should be
> renamed to `struct smb2_file_name_info`, since both
> FILE_ALTERNATE_NAME_INFORMATION and FILE_NORMALIZED_NAME_INFORMATION use
> this structure. See:
> - MS-FSA 2.1.5.12.4 FileAlternateNameInformation:
> https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-fsa/5051=
d021-8d06-4b7e-94e3-55b118193427
> - MS-FSA 2.1.5.12.30 FileNormalizedNameInformation:
> https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-fsa/3d5c=
68f8-fbc5-4f94-a51d-3600a319fd45
I think that both of them are changed in another patches.
