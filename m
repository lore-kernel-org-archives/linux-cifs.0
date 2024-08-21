Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D23316C685;
	Wed, 21 Aug 2024 23:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724283652; cv=none; b=sSKL+ZdTuIpzTmLsfpUpeXM6nObu444e2kUW7saobr9mOwZBnP01rKtkFEAmTkavetzbfFUASN9qhRhmp1IsxjB8gFECqwE0GJOehWOlPb2JwwkuSF2x3CBWJhQA6+r0RzRYy5OHDUZjGTndKqZfP5gZE3CmtFarntWFGMAFm4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724283652; c=relaxed/simple;
	bh=xfOu1APNQvpg4pWUI6tcCCbT79a5zsaUUrty1laMGdE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NrPu8vnYagWVUr52dtoBLGJ74lbtxokJd+xUfIZw0TrrjOZ2q6MAhwyo7ylG2q93L74LZmAlnOs2XgTcblfbVNkPM51M69F8bOpeUq379rtEOiOw7L/2PqQLumoC0dasEoEp+9XcxnR06OLxtEw6/suVPbwMbL4ol6yZZnJfFWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F/jVneDI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F/jVneDI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39D2CC4AF12;
	Wed, 21 Aug 2024 23:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724283652;
	bh=xfOu1APNQvpg4pWUI6tcCCbT79a5zsaUUrty1laMGdE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=F/jVneDIPhuM+1bI5RLUHR9ZARaFJoPl/6IZq/i/GYJ5ftvrWZfyo6YsN/n9wZKQi
	 iy7eOBazta0o/BW1lxqWbei8Fo2W/agbBzs/npFZdflMfoAX80FZYiLSAXYC/6HXAF
	 qkuOwAxlkXgrhWOre+y0girkDjlZ4Kk4PzIHaRwrvLqAWjvdW52g/ocNlZeOCDcJ6A
	 hd3M+Og6FGfmC+rEPCS+F/Ea6K8YZasseYwMgQvAATGus6UkXV+z3eru3+djLrwTCx
	 npQnOybR4JLZm5HY2N6qYqNzPehKGlcx9lXiPVrftj3XqiGcU6wuvw/rZvqpxSQ67Z
	 DBJwGuXqr8Udg==
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-2700d796019so126125fac.2;
        Wed, 21 Aug 2024 16:40:52 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUVaXm0OHSF1qspk3cr9ADdhnx9trPTu1DfxKNzqBOEPNScuuWzR8RtVrrkGnq7ANK0XnlLCeH0Su7dDTaI@vger.kernel.org, AJvYcCUvdUkAqNBSdcHKElrqELe8lRc0lWnCCAmXIVOh2fzq52bfiUpcPB6W44lc4DStx3sRyghFMLW9Ghnh@vger.kernel.org
X-Gm-Message-State: AOJu0Yxztw9foNNFhRrI6OImzUJkem09/2qFJvk1/SCOTqceOGHJ9Caw
	dJnyEfSrdRes2AMsIL/hHzXnYeQ8IVfe5liypRtVjCdubrEXbDZ96dy25bW3OCY+5SdCggkBucx
	Z9+A/JHjYzbW10R1lypG9vKMAuus=
X-Google-Smtp-Source: AGHT+IEq5ojOSmud30JUGoLSL72Hb5cP1FvPYiuW9TxXSafGQu4tpiF9A8jKd4Hil+2NHsYZeG0VLB/D/rpDNhgzXZw=
X-Received: by 2002:a05:6870:b488:b0:270:2e19:7734 with SMTP id
 586e51a60fabf-273cfc390d4mr258890fac.12.1724283651458; Wed, 21 Aug 2024
 16:40:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240820143319.274033-1-chenxiaosong@chenxiaosong.com> <20240820143319.274033-9-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20240820143319.274033-9-chenxiaosong@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 22 Aug 2024 08:40:40 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8-J+ZjnmQbaX4FLuKxwLMtYF_dj0G+7sv7nRo2knN=fQ@mail.gmail.com>
Message-ID: <CAKYAXd8-J+ZjnmQbaX4FLuKxwLMtYF_dj0G+7sv7nRo2knN=fQ@mail.gmail.com>
Subject: Re: [PATCH 8/8] smb: move SMB2 Status code to common header file
To: chenxiaosong@chenxiaosong.com
Cc: sfrench@samba.org, senozhatsky@chromium.org, tom@talpey.com, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, pc@manguebit.com, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, bharathsm@microsoft.com, 
	chenxiaosong@kylinos.cn, liuzhengyuan@kylinos.cn, huhai@kylinos.cn, 
	liuyun01@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 20, 2024 at 11:35=E2=80=AFPM <chenxiaosong@chenxiaosong.com> wr=
ote:
>
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> There are only 4 different definitions between the client and server:
>
>   - STATUS_SERVER_UNAVAILABLE: from client/smb2status.h
>   - STATUS_FILE_NOT_AVAILABLE: from client/smb2status.h
>   - STATUS_NO_PREAUTH_INTEGRITY_HASH_OVERLAP: from server/smbstatus.h
>   - STATUS_INVALID_LOCK_RANGE: from server/smbstatus.h
>
> Rename client/smb2status.h to common/smb2status.h, and merge the
> 2 different definitions of server to common header file.
>
> Signed-off-by: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Looks good to me:)
Acked-by: Namjae Jeon <linkinjeon@kernel.org>

Thanks!
