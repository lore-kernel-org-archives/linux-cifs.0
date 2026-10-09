Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5632342146
	for <linux-cifs@vger.kernel.org>; Fri,  9 Oct 2026 02:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791512658; cv=none; b=mwngym6VVhtrlrE6Cj3Tq1r3znaZOEnUNFpAQKTkM4n6faEYC8fHsv68pjC2uduvwj2G9oYPoP4BRuowFFc46cY7gCv/9B1DfWcBR7qhhCx0lsR3S5LfuwyYsOD8XHQZ+Ltw7H9J9RdMekOwIEE2+1aVG193vXFAgb0FvqdFTw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791512658; c=relaxed/simple;
	bh=vGAV29szzckW/hyg0o2BDffmBQtu0HvENqyxwpnY7II=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jIW2qcwyBDTQo5HrOCJ/df79Jqrc7NDmjj76WinmWnOwso4chZkMGvKz6lT0AeIEPm+2L0rsIpr2IfdIRKYqsZ8Cru+3TE+w6WVuYjXEterpIO0iame7q2cN0fOuCLWkPpNpJY3flZt8emU5lfw3BmmQal34B9UREEb1KJBNypA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ax5aOx9e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ax5aOx9e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 965C51F0089C
	for <linux-cifs@vger.kernel.org>; Fri,  9 Oct 2026 02:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791512657;
	bh=XfuBNTwXruuIHKUhXBz1GWV2bxPNXXHvv7tD1L3oZPs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Ax5aOx9eg3H3M9MRO3/5+HgPfJZtkExjY0N6TTLc86DTQbQO+0UDbX2vcwTuXz4Qe
	 DGjrVQPlZjqqIN6a/7+xTvPy5Vi8qx4ZB1Nr4P36hEFsdBFPLunuucL91RUgnoucyY
	 HF6evotXoWVHPGsPDUYQnnnypekQ3xFh/efXF116gSSu3Gg8NwKO0rkgQ5Q1uMCL19
	 oTWP/Q6cwJDU+oPrQuliPNPDPPASANbPpgIOpfKOnDHNNg/E7kM6ds7WEjUBYkHE8H
	 SMc50aCYhB2qdNeNC2NZo/JhHTv/j8Nzm8QSQt/suZSRqIckuPn8uTJhZLcd8fXOgX
	 35aqdaTZ6YQlg==
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c2e2db5e8e4so974644966b.0
        for <linux-cifs@vger.kernel.org>; Thu, 08 Oct 2026 19:24:17 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByH5/7qz+tJPXwoDa7Z8M9EIw1TddxUGIHulnbBcwFIqRKP46MmZAS2rmTCd+F//zKVAVqHFlqOpViP@vger.kernel.org
X-Gm-Message-State: AFuF++nBB/hwhPgtdtKPmDQWgfdIJpr0EwDnNPRvt/pyue7scmGJJr7U
	SA1YZBI0WgepAkivZWZGEadbzc43ajnCn64CipNLjmw2PgFI2BOEb2Y4sPwbF9vJUs4MsdzGPgD
	d5/oPThV4uuPCjWwRw/B5OwMTxlJlTw0=
X-Received: by 2002:a17:907:c07:b0:c2e:3d17:5259 with SMTP id
 a640c23a62f3a-c31aa0bf51amr41841966b.41.1791512656108; Thu, 08 Oct 2026
 19:24:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261008152537.4147299-1-charsyam@gmail.com>
In-Reply-To: <20261008152537.4147299-1-charsyam@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 9 Oct 2026 11:24:03 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-ky26A0hyHgYVu7KoF4Ri1FVd2neiNPbFKMP7fY7neMw@mail.gmail.com>
X-Gm-Features: AclHuK85t5TTELxqqXVT-v7Ayqf4Dr8wg7uTfwmQVmjxxPDockNBvPPPVCGKLOY
Message-ID: <CAKYAXd-ky26A0hyHgYVu7KoF4Ri1FVd2neiNPbFKMP7fY7neMw@mail.gmail.com>
Subject: Re: [PATCH 0/3] ksmbd: fix three named stream bugs
To: DaeMyung Kang <charsyam@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 9, 2026 at 12:25=E2=80=AFAM DaeMyung Kang <charsyam@gmail.com> =
wrote:
>
> Hi Namjae,
>
> This series fixes three independent named stream bugs:
>
>   1. A read at or beyond the end of a non-empty stream returns
>      STATUS_INVALID_PARAMETER instead of STATUS_END_OF_FILE.
>   2. Opening an existing stream with different letter case keeps the
>      client's spelling in the handle. Later writes and removal can
>      target a different xattr from the one that was opened.
>   3. A write-only FILE_OPEN_IF on an existing stream can replace its
>      value with an empty xattr when the value-length lookup fails with
>      -EACCES.
>
> The series applies to ksmbd-for-next at 5d2b1ab54e9a ("ksmbd: fix
> named stream write and EOF handling"). Each fix is in a separate
> patch, with its own Fixes tag and stable Cc.
>
> I built the resulting kernel with CONFIG_SMB_SERVER=3Dy and tested it
> through SMB2.1 in a QEMU guest. Reads at and past stream EOF returned
> STATUS_END_OF_FILE. A stream created as Foo was read, modified and
> removed through foo, with one named stream in the listing. On a 0222
> file, a write-only user opening an existing stream with FILE_OPEN_IF
> received STATUS_ACCESS_DENIED and the original value remained intact;
> without patch 3, the same sequence emptied the stream. The same user
> could still create a new stream.
>
> Patch 2 has a minor textual conflict in linux-next with the VFS tree's
> const mnt_idmap conversion. The resolution keeps both the const
> qualifier and the new actual_name argument.
>
> Concurrent creation of case-variant stream names remains a separate
> issue.
>
> DaeMyung Kang (3):
>   ksmbd: return end of file for reads past a named stream's data
>   ksmbd: use the existing xattr name for a named stream
>   ksmbd: preserve unreadable named streams on open
Applied them to #ksmbd-for-next.
Thanks!
