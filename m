Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D98829A2
	for <linux-cifs@vger.kernel.org>; Thu, 10 Apr 2025 04:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744257895; cv=none; b=XsmAOE5Pb/3Pu23wYNycDVZjSA5FOmSIi4qshqw5ouBYZ9g/bvr1GKBnJSHvkNgvY2bSxPZj/gTOH2+kppce/9qkFDP/y4Lu4QKsZc875Xe/hNNydChBKrYe0+siJpPbc+sKOB7CesqePckYfSk8MPeWUiFs4AMqNrT05Tb2q+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744257895; c=relaxed/simple;
	bh=0E3g6a7VU39tX4orEaXaCrW/m/DxKNviAA7Os2YbDYg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tCkZqLdoZ74UdvTgSJkACwiKmmbbwdCVM+rnPMyXZYSlXpt8Bt9vJNqArihMN5oOIEV+xu9HJ02d5XKlR0RRNXmZXlKX4SPpWJ8hjenxVmIlMsLbfY/6lJCTAtB7LWnXWpcRJ4358F0RqtP1Q/4OyiyDPf/4Utv4sNdFmj5JQFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S8y/vKdg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S8y/vKdg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B17F1C4AF09
	for <linux-cifs@vger.kernel.org>; Thu, 10 Apr 2025 04:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744257894;
	bh=0E3g6a7VU39tX4orEaXaCrW/m/DxKNviAA7Os2YbDYg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=S8y/vKdgiMzTS64aRvtn9zHgJ/uQXrtHMcEb71Vur1crITVb4h7bZIvZPaMFYVY9U
	 mRNu6nFIHgQyHEAEFtXp8EuAKJOcdSWfDCkxAGiOquLDgytc3Gt0AJ3mOvcs92bnaC
	 CYlSvqiYEaeAOO99s2HByPnW5PTmUAlROlUx4X0ufaqbYdYQ+3uUiJvMNhfGkbNK4U
	 zEsZ+07GWKegBerCbRxFSAezd4lQtcrtipVXxRlTKysM0Q6ZEUdEuXPL7jtXD4s2pP
	 GH8Q4VDbah/N4TrCRASJibS4LT3q7QpjEQyxL5RF9NfetzywT8Ou9FCq8hqHyoORQa
	 lCidzIsJ48mzQ==
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-2c818343646so218746fac.3
        for <linux-cifs@vger.kernel.org>; Wed, 09 Apr 2025 21:04:54 -0700 (PDT)
X-Gm-Message-State: AOJu0YxKqovlP/W67ut4h+Z9KwHH0tq17ClBG4URqH5KsJH//LtCKq8A
	P4+xpXd+/6ZoepcSZgdowbmavW6+XBJnF4PtCC+ssJ910txlSUwIydPHPjXRqWUbcMnP7fBnK90
	7kHy0RMg8N4aI2d34GfmSlcKFCpo=
X-Google-Smtp-Source: AGHT+IFYnyrAHsAH/wwBWUWeV6+zdS++LQaHBq33b2XuUbkgGwmSTtI6n/I9yma2lDqUlhHYGZyuUgavDIL0ATLYwxc=
X-Received: by 2002:a05:6871:71c5:b0:2b8:3c87:b491 with SMTP id
 586e51a60fabf-2d0b5e370b4mr531321fac.26.1744257893982; Wed, 09 Apr 2025
 21:04:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mtHccZDP-QdWsb508iNpjeaCPsC8bxrpUgXk3y77aEcfg@mail.gmail.com>
In-Reply-To: <CAH2r5mtHccZDP-QdWsb508iNpjeaCPsC8bxrpUgXk3y77aEcfg@mail.gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 10 Apr 2025 13:04:43 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-4DUOKDHKKxO0rrTCeMCfMrxzRwzMzdSf3ZY6BBUMrPw@mail.gmail.com>
X-Gm-Features: ATxdqUF-pnGzPiRnutQkRbHYArYewg0nASIQIZ69WO0YMWrBHgnBgp6iEJ0VutA
Message-ID: <CAKYAXd-4DUOKDHKKxO0rrTCeMCfMrxzRwzMzdSf3ZY6BBUMrPw@mail.gmail.com>
Subject: Re: [PATCH] Add missing defines for new File System Attributes
To: Steve French <smfrench@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>, 
	samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 10, 2025 at 12:55=E2=80=AFPM Steve French <smfrench@gmail.com> =
wrote:
>
> Trivial patch to add the two new defines for FileSystemAttributes
>
>
> Two new file system attributes were recently added. See MS-FSCC 2.5.1:
>            FILE_SUPPORTS_POSIX_UNLINK_RENAME and
>            FILE_RETURNS_CLEANUP_RESULT_INFO
>
> Update the missing defines for ksmbd.ko and cifs.ko
>
> See attached
Looks good to me:)
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Thanks!
>
>
> --
> Thanks,
>
> Steve
