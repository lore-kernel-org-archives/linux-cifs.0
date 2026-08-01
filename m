Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2917929D291
	for <linux-cifs@vger.kernel.org>; Sat,  1 Aug 2026 14:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785595151; cv=none; b=u1TZm4KmA6lJdKvyYKlhdPSxMvqlw/Iko7M3fPRDtLnkTePRcBgFComxZJeCB0sScTtr1+kUYOzCRGMZdCMLFDz9kcBgSOgi+qR9uzjY1yKfFps8Hj0ktOZT1wSCe6QD456Ar7qwuUaIN3AVkSrybW5QrftDwTw5qfskPnKyjDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785595151; c=relaxed/simple;
	bh=0wIdHO2KKlqQbHv/U925krSvecRhBLJj9mTUO4kZP7w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EIQOjeP62WgScF1k+NFSUXwlngJcn5ySCMWHC9Vbbi/qC4VKAlhf0pmhY/HBuitsLSxvZQbWHayP/HMaCEFGEiK5Uhmq+hsnkCiIFtoVfRK37wVNcR5K9HewQu9ykKivrK7kiVAyt3v3RE/Al2FXNIrUTJeRTvwe3UqDLjz+8KM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MuaT6hFI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MuaT6hFI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1F7B1F00AC4
	for <linux-cifs@vger.kernel.org>; Sat,  1 Aug 2026 14:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785595147;
	bh=DlXrAqZhx7YtEPMTf+Wj82LYchJ2YfNEWO9CuOFxC9c=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=MuaT6hFIlXAZKsae4PqMTowwCAelmEHcGP5YYFDVrk/Tn3i/O5FNK1WGNj3BFRpRJ
	 Ax2yZtBWbe+Z23Hric1JKS4zPuMtjlcdfz7IwDtN2diju+iCIbfzoTZiTRMBSmxtnS
	 og1tZ3g5n/i5k/WqTS4clW+CC3YrwbDurU+NbjRjJiHg7V0YfrzuCRVgquEx37Qa6L
	 SkfXPI2siEeQvTYS9MjNC0mkFTz6wKKao4EoCHOhKG5upjxOVt3fVEG8Of7qZj+Als
	 rD3Om56/QEEPgVG3MgVenII6JsuUaWoTsO1cdygpTIMJl97THxgOAx2oqNnvhJ+4m2
	 8xcQ+uR85Avlg==
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6a0794669a6so3010500a12.2
        for <linux-cifs@vger.kernel.org>; Sat, 01 Aug 2026 07:39:07 -0700 (PDT)
X-Gm-Message-State: AOJu0YzWsJHM4OlCQO6ZMiTHNGdqAEF/uc8mdC8FV+68k2Co0YIX0b6s
	nLRZEEwUM2f6FmP3TPtZSg0WlmpoLGo9R2A00uZUCak793+s0HZQvCudu4es7DDdUfMDulyM64j
	aq4Gwfts80D7Q9ZbKydhfLYQ1M7O6/4s=
X-Received: by 2002:a05:6402:455b:b0:69c:76c6:9bef with SMTP id
 4fb4d7f45d1cf-6a0a7c88f90mr1962748a12.10.1785595146347; Sat, 01 Aug 2026
 07:39:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260801051953.74245-1-anatoliy.shumak@gmail.com>
In-Reply-To: <20260801051953.74245-1-anatoliy.shumak@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 1 Aug 2026 23:38:54 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_V0d7bheRZQVCprcSOKUx=r-YxEB8TxP8UOcnjuGk5ig@mail.gmail.com>
X-Gm-Features: AUfX_mzqGrjcFSoDcZvVuH6XqMonTgJjOV1Edyib9URB0alXF7NdAhrgltyExsQ
Message-ID: <CAKYAXd_V0d7bheRZQVCprcSOKUx=r-YxEB8TxP8UOcnjuGk5ig@mail.gmail.com>
Subject: Re: [PATCH 0/2] ksmbd: harden SMB 3.1.1 compression receive path
To: Anatolii Shumak <anatoliy.shumak@gmail.com>
Cc: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 1, 2026 at 2:20=E2=80=AFPM Anatolii Shumak
<anatoliy.shumak@gmail.com> wrote:
>
> Hi Namjae,
>
> As requested in https://github.com/namjaejeon/ksmbd/issues/529,
> please find two patches:
>
> 1) Reject Pattern_V1 on decompress when it was not negotiated.
> 2) Validate compression Flags before kvmalloc.
>
> Tested on 7.2.0-070200rc5-generic.
>
> Thanks,
> Anatolii Shumak
>
> Anatolii Shumak (2):
>   smb: compress: reject Pattern_V1 when not negotiated
>   ksmbd: validate compression Flags before kvmalloc
Applied it to #ksmbd-for-next-next.
Thanks!
