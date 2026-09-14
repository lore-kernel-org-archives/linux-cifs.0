Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F07D7081E
	for <linux-cifs@vger.kernel.org>; Mon, 14 Sep 2026 01:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789348702; cv=none; b=QAdnKKIrHtsNpxZ/7pdOVzTYcZSlUEFpNOcriNTjifcH5fbrCRJnliJZt/XPOIzaZvUVKNemPX77hFT/h3S71OdNmzMVheJIKUinDBy/YSWPiFZkE0e7h+hSHY/N1kfDWHm2VdbBFZC+pqZ+k3+5+v7QXT50ix6m0Uoiq+zfcUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789348702; c=relaxed/simple;
	bh=ESEdCcam9mzGLWGkSmgO+SyJILvdYBiNvYjJ4tC1wFo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ebTqK9F2dCdj+6JVHJxdkiTpHrhgOuJKgSVHmUDa3lVV2X58c9Jr5AfvVFU5a7DlTFrFBfkGESEmfBfvv1bDOdIU8wEWIdvB+Ge6w7qTlYzEbcGJxGjGwvl+9gVLc2Eji39eaT4rYIWSvSdHt60cBm1fp1eltLMgh5FUqcySprI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QjHcdgf1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QjHcdgf1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1383A1F0089D
	for <linux-cifs@vger.kernel.org>; Mon, 14 Sep 2026 01:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789348701;
	bh=ESEdCcam9mzGLWGkSmgO+SyJILvdYBiNvYjJ4tC1wFo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=QjHcdgf1CENydL5QErwIwmUo2Lg3j+5PqRt47/8nUDfq0Grfn3bENAknQEb4QMa84
	 2vmdRhKUtqA++rJ992y9IEd3A2ACYfRVU3Shkd3n12B9WeH2mDokxVaBCoYUrbGJma
	 tYHMsJh5391s9eBY5GdrOXWEwbyIJy/sw1qM+BTpWghfpXAG6lQwojMZJbSGzuMje+
	 fyarTZ/ybjolJrCb+mtITSsdwzrsz4+0ixjyjU+XkvtWtlKhVqUUXHx5Shng4CMeBm
	 t/sFqzlftibU+0RT+0MrNM+KSXlbMWVts8hiTKjPd58dZEmZ8r7egXD/OGfRFkUYST
	 htB0gOFemrjHQ==
Received: by mail-ed2-f12.google.com with SMTP id 4fb4d7f45d1cf-6a996c8adf3so3038720a12.1
        for <linux-cifs@vger.kernel.org>; Sun, 13 Sep 2026 18:18:20 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzYyPJSGHua6d9GGNEZdI8vFEVzXBrEL2jMamFzn4OyxIqIeLYAj/u9ZmuRqKv7s9nBD6n69fcvXbir@vger.kernel.org
X-Gm-Message-State: AFuF++nHtGcWwVKc6DyvCXKn8X7RklcAJgTfWY5Afn3Z2UpFLz1/e0+I
	6rPpgpc6izXR1pISn9mzXIjqMQeIPp+tKnEJi4FrPpUElGpXfh11pjzke1MJtClxfxfjpWHrp4H
	5ryJ6IGYqzMpE+yGgPrH76uQ7DPTD4Lw=
X-Received: by 2002:a05:6402:270b:b0:6a0:9776:cb5b with SMTP id
 4fb4d7f45d1cf-6a9f625f004mr343043a12.13.1789348699564; Sun, 13 Sep 2026
 18:18:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260913113600.11540-1-linkinjeon@kernel.org> <bb7ca0a6-918d-4fa2-96ca-9ccc31c20bf8@chenxiaosong.com>
In-Reply-To: <bb7ca0a6-918d-4fa2-96ca-9ccc31c20bf8@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 14 Sep 2026 10:18:06 +0900
X-Gmail-Original-Message-ID: <CAKYAXd80__ZovmrmrESSnDymBCEzoyxLLMpg40Jtcz3TUB14eg@mail.gmail.com>
X-Gm-Features: AcwNN1UzNdTO4s3meAECa_Vvg6_9ckYRqO4XexhSmWt5UWz_asGaTvUrUf31Gww
Message-ID: <CAKYAXd80__ZovmrmrESSnDymBCEzoyxLLMpg40Jtcz3TUB14eg@mail.gmail.com>
Subject: Re: [PATCH 3/3] ksmbd: keep compound responses on query info errors
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: senozhatsky@chromium.org, tom@talpey.com, atteh.mailbox@gmail.com, 
	Mobin Aydinfar <mobin@mobintestserver.ir>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 14, 2026 at 1:10=E2=80=AFAM ChenXiaoSong
<chenxiaosong@chenxiaosong.com> wrote:
>
> The `rsp_org` parameter in the following 3 functions can be removed now:
>
> - get_standard_info_pipe()
> - get_internal_info_pipe()
> - smb2_get_info_file_pipe()
Okay, I will fix it in v2 patch.
Thanks for the review.
