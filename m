Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B67A13FEE
	for <linux-cifs@vger.kernel.org>; Tue,  7 Apr 2026 01:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775526678; cv=none; b=srpVOmmDTzhje+QlKjKtTepbKDfzPF+ptQuzcSjj2kK5w19nYJVTcVcnfzQsE2X8ZmZu9ZngEOr1ihVukQpurixeJvA+ffST9etK1tmpBp+zY+61i5bCwNqOQoXMU10FnTfzbZQqwArzxXsyMl+ICgTuNtnyjCXLGEhAcM4KVGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775526678; c=relaxed/simple;
	bh=zWzmT8CBO4zABVSiQW+XiXd77WgdRDrTcjC//EO7VCQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qxKM6s503DOzvLg5zsPOig7dUiG70noz4U9y/Z4II6lEkxv5wPPGScobZi+8DlRlgv3ir9PP9L6ww98H1wtRWUqnnLsC2uizNw6Eh43xJrReiJ6CC76fF9Mn2i2b+JQutjbs+Nwx6QU3OVMizR++Zuu0tBYLmr6gZ34JUN3W28E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UdOfQyjB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UdOfQyjB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FB2EC19421
	for <linux-cifs@vger.kernel.org>; Tue,  7 Apr 2026 01:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775526678;
	bh=zWzmT8CBO4zABVSiQW+XiXd77WgdRDrTcjC//EO7VCQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=UdOfQyjB6OdeA4wdq2KIDKRDqp9SfWaI2RN2+hByOaph/zHUIdVWyCxrkATs/ChtD
	 gdy7dX+xRFyt8NwuPJy7J0LyCf+xJKNR15e2FwLiaIdkstCc94o94phKehTX60DDMQ
	 DFjmeTSV0M0Wj7BWnb586UkomoXklX8wVN2fRBni/iu7n7DzUbDtV+34lRqQUmXqjX
	 Fep53msAwVsykVqTQXuV4+xlTUWLuwRy1M8r941f85nzBfp62lRsU8LjQxNYIQcXlm
	 0CaOa3y9f7EteutEzT7hVjK84l+1kX+sQLKxmE0Tq5FnJ/mlvC7nc7LggFmgbGfrni
	 5PyQJ2KRTwS5w==
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-66c304dbfd2so4110884a12.0
        for <linux-cifs@vger.kernel.org>; Mon, 06 Apr 2026 18:51:18 -0700 (PDT)
X-Gm-Message-State: AOJu0Yz8n3XzMgBNVmZ3QWTU41rI3qK2OvPswOF3yYuHr/jDu6ufv6/w
	0UwQTz9Z4FjN8+7TJHisnfUT9Xw1uWUvbY1g+XuGe7+n7RpS+I8tt2jDvBcPPmKQrJE8glHDFbo
	nHX9dCHvks2KNmo9zR4QIpdEs5S20bFI=
X-Received: by 2002:a05:6402:a202:20b0:66f:60cf:38c7 with SMTP id
 4fb4d7f45d1cf-66f60cf3a17mr212633a12.17.1775526676914; Mon, 06 Apr 2026
 18:51:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <2026040644-brussels-dab-6f99@gregkh>
In-Reply-To: <2026040644-brussels-dab-6f99@gregkh>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 7 Apr 2026 10:51:03 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_6_d_Ws0DTe0m5xE2M+fCkCY-bAW6C4kZoaNqZQ616Gw@mail.gmail.com>
X-Gm-Features: AQROBzDH8OmVQhpkHkXDY4NC2A1FSseJbWFvj0Yd0iubz3CkvgDUfGEEcXmX1lk
Message-ID: <CAKYAXd_6_d_Ws0DTe0m5xE2M+fCkCY-bAW6C4kZoaNqZQ616Gw@mail.gmail.com>
Subject: Re: [PATCH 0/3] ksmbd: some potential bugfixes
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Steve French <smfrench@gmail.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Tom Talpey <tom@talpey.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 6, 2026 at 10:47=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> I spent the time exercising some new fuzzing tools on the ksmbd and smb
> code purely because it's something that is simple to set up and test
> locally with virtual machines, and in doing so, potentially found some
> minor problems for when you have an "untrusted" client.
>
> Here's some fixes for what I happened to notice.  They pass my very
> limited testing here, but please don't trust them at all and verify that
> I'm not just making this all up before accepting them.
>
> thanks!
>
> greg k-h
>
> Greg Kroah-Hartman (3):
>   ksmbd: validate EaNameLength in smb2_get_ea()
>   ksmbd: require 3 sub-authorities before reading sub_auth[2]
>   ksmbd: fix mechToken leak when SPNEGO decode fails after token alloc
Applied them to #ksmbd-for-next-next.
Thanks for the patches!
