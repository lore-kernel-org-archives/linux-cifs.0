Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 662D142AF9D
	for <linux-cifs@vger.kernel.org>; Tue,  4 Aug 2026 07:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785830022; cv=none; b=nWeeiso0fbIyxP3KHHXo06mpZj+lnGP5FErKOtrTo9OA3QBYLOs55Ex0wHA9JDAz9E+fibOuMyig/F4jyCOkdQutN/xmUZN019JCkeS7Dp1S98E3JO7u5aSkZmKHBqHeaIuIT1q0Evy0RU/LMiE9WG+mppfzFxkHiM6RT3xA9LU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785830022; c=relaxed/simple;
	bh=zrDBCMLqzHsKBYfM3Rbsqdk2M7sgWDNGgcqnrk6VyOs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eqwrxA8W6J2iVocBaBQnYJPyNH/0invy0HuaiVTmIrZJ4d8hAol7X5skC/7CCx4trwEGebYOUIRm8IrNv7dnBxVxdnsEMkZPkziHY1Oiazq5UD3LyJ6v8grUBRYSV1AHnoe1CtHQ633NJJo8JTp6I7hS2gbE0a2GqAJGfiITFAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P29C1WFQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P29C1WFQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D343A1F00ACF
	for <linux-cifs@vger.kernel.org>; Tue,  4 Aug 2026 07:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785830018;
	bh=zrDBCMLqzHsKBYfM3Rbsqdk2M7sgWDNGgcqnrk6VyOs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=P29C1WFQsOC96GxNAyJZG5IcUSRJw5MNnvf3I6eAF1ql56z3ZPEsBt74VqDouYwqW
	 swpqVtxFS2L80FEwR0aEL7IWWUmyIRAZ04PxLszGxxxXeQFbdtZ/Kq2oicjJUTL+Km
	 uZmqqNOAvknVV8UBfarZwWzTyX/T/tcH8PUxuUbBuYJmwXdl2k3OWTdzxbF1tFl+1F
	 J8A2V9om+srf8YEPiEFGMIORe7/PN9tUBpOssduve23oueXVVUnhS1kPL3sjRnbZ7d
	 7RPS4mMdFWBMPfidtsXbCg7UX8XW9NekBHWoA0uKaybKDmTSVR9KOll35hsx3hk2f5
	 CcluX+m3+W+rg==
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c2020421077so186878866b.3
        for <linux-cifs@vger.kernel.org>; Tue, 04 Aug 2026 00:53:38 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrY4h/LW9pmZnVjtfqD7sh8AvNnotFACcZQz8tzsyG79Bj+1ZLZn5RT1N77IisqaJF60T2cQ4Tllssb@vger.kernel.org
X-Gm-Message-State: AOJu0YznbU4/ARoVC5RBo4gIs0fscJqyf+bC7bOU0mOLZjK/+GVRt+nO
	vi1Tb+fMoC7WYfshNGGBdrqyXzBo104u1s34wLOD8xOMQ52uM/dtOs/cx2F7bhkBwd3pEERmPAS
	fB/uHVf1b4Z+Tslo3WpEMra/zr+Jv4J8=
X-Received: by 2002:a17:907:c17:b0:c20:1ec5:feb8 with SMTP id
 a640c23a62f3a-c201ec6037cmr481384766b.29.1785830017449; Tue, 04 Aug 2026
 00:53:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260611085847.653284-1-chenxiaosong@chenxiaosong.com>
 <CAKYAXd8ah8Jxi55WaoOONUDJEtRpkwTYvmNnL9e+4=FPD2fnHw@mail.gmail.com> <c0102f11-e49e-49e0-a7af-0c1dec642096@chenxiaosong.com>
In-Reply-To: <c0102f11-e49e-49e0-a7af-0c1dec642096@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 4 Aug 2026 16:53:25 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_wZG+T=WYdZC_S7jPsUmsUAeQ_UDsn7uKWzUS5nSSgoQ@mail.gmail.com>
X-Gm-Features: AUfX_mwFlG6cjKUg3YmmkNmgzG7NS-fz40y_N2As1HVzlT1rFI-PsW0lMJgcJxE
Message-ID: <CAKYAXd_wZG+T=WYdZC_S7jPsUmsUAeQ_UDsn7uKWzUS5nSSgoQ@mail.gmail.com>
Subject: Re: [PATCH] smb/server: check destination is open when renaming
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org, 
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 4, 2026 at 4:16=E2=80=AFPM ChenXiaoSong
<chenxiaosong@chenxiaosong.com> wrote:
>
> Hi Namjae,
>
> Currently, both the client and server support only
> `FileRenameInformation` (level 10) and do not implement
> `FileRenameInformationEx` (level 65).
>
> Level 10 does not support `FILE_RENAME_POSIX_SEMANTICS`.
Okay. We can implement this in ksmbd and cifs.ko to pass generic/035 test.

Thanks for sharing it.
>
> - MS-FSCC 2.4.42 FileRenameInformation:
> https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-fscc/1d2=
673a8-8fb9-4868-920a-775ccaa30cf8
> - MS-FSCC 2.4.43 FileRenameInformationEx:
> https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-fscc/421=
7551b-d2c0-42cb-9dc1-69a716cf6d0c
> - MS-FSA 2.1.5.15.12 FileRenameInformation:
> https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-fsa/87f8=
6c9b-6c2a-4803-84b7-131a74a434fa
>
> On 6/13/26 11:52, Namjae Jeon wrote:
> > This check is also applied when SMB3 POSIX extensions are negotiated.
> > POSIX rename semantics allow replacing an open destination while
> > existing file descriptors continue to reference the unlinked inode.
> > The check should therefore at least be skipped when
> > work->tcon->posix_extensions is set.
>
> --
> ChenXiaoSong <chenxiaosong@chenxiaosong.com>
> Chinese Homepage: https://chenxiaosong.com
> English Homepage: https://chenxiaosong.com/en
>
