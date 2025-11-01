Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A257247F4A
	for <linux-cifs@vger.kernel.org>; Sat,  1 Nov 2025 00:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761955829; cv=none; b=Dqvix/672c3Afg5ihnRvD2Dg605c7Yoq+vMd3ZqnTYHxKx82k7QRDCTL5s3OMMBnyew2ksh8Ukszoq08GWg8XjfCZA2N5HmGzoQwqfj+0GRXxhnabzIN7FFfzIA2vjhaApzoEB4jp9zhkQBA9WRkuqgFu/7Vh210mcv9TdkgkM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761955829; c=relaxed/simple;
	bh=pTCNIAWDttDwWaRP0C/Bin7+1nFzG5DIs1oLUC7slWM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=njhkcuy5TEJFBJXt4Se3AtvsGuwvkU1SAAvzZYRKf7gUCwf0+9iFoAKmAjp3ZIylMkpKERBlTmK2NHOMfM9UvmSUmbmJzHO/NdxKH/s7viY2RET3HCCmEpCmFvJ0V4niMzbMtm7h2fehTzGAXB018VbI8KyL8HQ1geZL8/R/0Xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ljHPnYk/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ljHPnYk/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 490EDC4CEE7
	for <linux-cifs@vger.kernel.org>; Sat,  1 Nov 2025 00:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761955829;
	bh=pTCNIAWDttDwWaRP0C/Bin7+1nFzG5DIs1oLUC7slWM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ljHPnYk/j2VRLUJIff/0TZmXSTipMRhmfpvpaXRPn+kYcsAZ2ZKU7ozI97szyryY+
	 N0sT5GOzIqgaKm73mfGE8I9xovKRcXtI2n9vLEl0I5zqG/feUhkKrQzS3HFjxlasLL
	 rFEkG5C4MLfdMCp426yG3ghIcecccfV04IzBZM1PvJJrUFUuJExYG1EA8ffDS94Dgf
	 cpV6q1G3tti1Zys5Mh4mFr342bDPLh3msxAdDFL5jXGhUSUb2kaGlyfrawm/in/qtY
	 M6uEniFOqvbIoJRTNnPEp6jsDTmv/Y6avQecD9fTJJlRfnr2hSLLeCtTfnVYeI02oJ
	 01MEKlgzbTKyA==
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-640860f97b5so1030886a12.2
        for <linux-cifs@vger.kernel.org>; Fri, 31 Oct 2025 17:10:29 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWtNl5APuGOVX7QbMZElCqFb9EaMwRjHE5c2pbwjwrv6gFFqcy402dcjV+7DiMnIa/v9H1JzZHeR2fJ@vger.kernel.org
X-Gm-Message-State: AOJu0YwMx8jAhUJcBUXNixCIsxlDyPz3SLJ7KtFj2bjW07jAC6jPTjhA
	mTvZiUgMZo0K6mbv11NhUSkh23bJGcVLpCLKKOLrz6gpe5ghxt17CUKlrBngE+uEuK0YtRwJOK2
	s+C7HGVJLXGU9XsSS8oebA08N4E4bCtA=
X-Google-Smtp-Source: AGHT+IF59/uLdnEFoAVrk9SX8E4wa6bJR6vMkA3q3oX+mTavQCC4PQyDmSOLYrVyfFuNXHFizZSdavqnGS7BL//eboU=
X-Received: by 2002:a05:6402:1468:b0:63e:8602:8cff with SMTP id
 4fb4d7f45d1cf-64077081f21mr3430212a12.37.1761955827860; Fri, 31 Oct 2025
 17:10:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251017084610.3085644-1-chenxiaosong.chenxiaosong@linux.dev>
 <20251017084610.3085644-3-chenxiaosong.chenxiaosong@linux.dev>
 <CAKYAXd-DxRTEu65-YKwXw8jA478jmgQAtOUNR66Tjb+czxp=xw@mail.gmail.com> <63eb1d4e-b606-4776-a0cd-d41c6bdc60be@linux.dev>
In-Reply-To: <63eb1d4e-b606-4776-a0cd-d41c6bdc60be@linux.dev>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 1 Nov 2025 09:10:15 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9GGAX+RX+s5_jLUPMnjenWvJw3S3aO2CJW8BqLWqNdnQ@mail.gmail.com>
X-Gm-Features: AWmQ_bmVvnpWadMoxIBykS25JvRa1dWLaYMq_c2HZjNGudvcTaaZomhB7ZavC4Y
Message-ID: <CAKYAXd9GGAX+RX+s5_jLUPMnjenWvJw3S3aO2CJW8BqLWqNdnQ@mail.gmail.com>
Subject: Re: [PATCH 2/6] smb/server: fix return value of smb2_notify()
To: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
Cc: sfrench@samba.org, smfrench@gmail.com, linkinjeon@samba.org, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 1, 2025 at 9:05=E2=80=AFAM ChenXiaoSong
<chenxiaosong.chenxiaosong@linux.dev> wrote:
>
> Hi Namjae,
Hi ChenXiaoSong,
>
> I=E2=80=99m referring to the userspace samba code and trying to implement=
 this
> feature.
Sounds great!
There are requests from users to implement it :
https://github.com/namjaejeon/ksmbd/issues/495#issuecomment-3473472265
Thanks!
>
> Thanks,
> ChenXiaoSong.
>
> On 11/1/25 7:56 AM, Namjae Jeon wrote:
> > On Fri, Oct 17, 2025 at 5:47=E2=80=AFPM <chenxiaosong.chenxiaosong@linu=
x.dev> wrote:
> >>
> >> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
> >>
> >> smb2_notify() should return error code when an error occurs,
> >> __process_request() will print the error messages.
> >>
> >> I may implement the SMB2 CHANGE_NOTIFY response (see MS-SMB2 2.2.36)
> >> in the future.
> > Do you have any plans to implement SMB2 CHANGE_NOTIFY?
> > Thanks.
>
