Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 518F132F760
	for <linux-cifs@vger.kernel.org>; Tue,  2 Sep 2025 05:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756792587; cv=none; b=uY9zHUnRG0EIwL7Uck+4Dzx2H4vlxgCHQ6GnjNHrOCZzgYrIZkE67xl99rWq8QOwjTgMVE4nEuJeplHhgbYEbsH/EciLwmM07+Q0K/QVWq2Q0cAvH/NMH2lGuq6tqN6B6wQ0hp4JBzIsuhDLYV4Ci66MCwjfcqsBQdh9WHqxoSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756792587; c=relaxed/simple;
	bh=SmPXSn8TQcbCrpvVl625K9Ej0u8goVP66Cz9lxvI/hk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ksqquqF/w981oLLCbCCj+JD3/NsyAlYhxkS02O1Vmwb2Qxu5hTOLdlzcoBXdsQfHOv4NYmN8xRonGsItOnJ5E96AEYpglElFUrPUKmBihQZyZ1KM9/L0RnKng4ssTM4daO9h+gwAvqgU68zXwOGQ7TBR7+GScAZMJHD4+kzTdls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OqZ25PIh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OqZ25PIh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC1A3C4AF0B
	for <linux-cifs@vger.kernel.org>; Tue,  2 Sep 2025 05:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756792586;
	bh=SmPXSn8TQcbCrpvVl625K9Ej0u8goVP66Cz9lxvI/hk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=OqZ25PIh2t+iW6YXsrsoD5W1xf8QIEJXV5JZqCIRTFbOO2ld9njluHjwK/OVZLO8l
	 GkI8eRzzxaV9nZZ1QU8x6cZPlMJyCHvVp8uk8jifS5OcncspRsELBWcjGNaUYkp8ZL
	 4iE0a1sKxTpMDO2DSTQj1mULGR2N0Jlx7QqwStxuT1faSzAGghuqOfqxM0BRbJtAjM
	 p+MiA8jH+9hAXG4b4otokxiO45J6OyX3fyMmdafOwbpSTY1ghcaWhQu75k9etmn6iF
	 x2XxR+pkvhWGIBgR54wLqIVPN0OyMcM+CvoLRzHx4B86HtLVYpCTekCES8kz66vVEZ
	 uHnRC1by+dZLQ==
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-61ce4c32a36so7864461a12.3
        for <linux-cifs@vger.kernel.org>; Mon, 01 Sep 2025 22:56:26 -0700 (PDT)
X-Gm-Message-State: AOJu0Yy9khlwpbB74HegEsHUBm+vsY8arAiF+dfqvWYthV8BEwriZ2Zv
	FNekvoDOqHRMTQsGdKJ2PlA5HoN4r9OTx5jCdje5zjPZApSVv24DFfwBlNonFWPnsZ3yfi20XhH
	J7Zqrh7HVe/nRH8bZhQF3sI+LwN4a71U=
X-Google-Smtp-Source: AGHT+IHbvrrDO8xSGMbkKbG8uqcPcLH7DDJ5zdlKDJlwIrxJ9iNhJ7GPRvOSPyhUp5AtFV38OPdExXAEBeGrTlVOK0Y=
X-Received: by 2002:a05:6402:34c6:b0:61c:7a13:f1d0 with SMTP id
 4fb4d7f45d1cf-61d2688c0f9mr10694327a12.10.1756792585399; Mon, 01 Sep 2025
 22:56:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mvpzK1NMmbKE-wUDHLhtm_fiPAp=zVm1egw3=cLbUh38w@mail.gmail.com>
In-Reply-To: <CAH2r5mvpzK1NMmbKE-wUDHLhtm_fiPAp=zVm1egw3=cLbUh38w@mail.gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 2 Sep 2025 14:56:13 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-LNgCYkxUDhOaYVTqWd2BBpbaNQNnzQHNWPypMDiKpQA@mail.gmail.com>
X-Gm-Features: Ac12FXwS5kduWrVU8UIDdPEPSKuTXSglHvaBLTwNcwbY-0D5cBJuOEDAo6osPIs
Message-ID: <CAKYAXd-LNgCYkxUDhOaYVTqWd2BBpbaNQNnzQHNWPypMDiKpQA@mail.gmail.com>
Subject: Re: smb2_copychunk_range() reset max_bytes_chunk to 0
To: Steve French <smfrench@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>, Paulo Alcantara <pc@manguebit.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 27, 2025 at 12:41=E2=80=AFAM Steve French <smfrench@gmail.com> =
wrote:
>
> I noticed what looks like a bug in smb2_copychunk_range() - I see it
> when ksmbd returns ChunkBytesWritten as 0 we reset the
> tcon->max_bytes_chunk to 0 which causes all subsequent copy_chunks to
> ksmbd to fail with invalid parameter.  I don't see it Samba (but maybe
> because they never returned ChunksBytesWritten as 0).  Any thoughts -
> the logic looks wrong?
cifs.ko request to copy overlapped range within the same file.
ksmbd is using vfs_copy_file_range for this, vfs_copy_file_range() does not
allow overlapped copying within the same file.
In this case, I can change it to fallback to do_splice_direct().
BTW, Does the generic/017 issue pass against samba?
>
> /* Check that server is not asking us to grow size */
> if (le32_to_cpu(retbuf->ChunkBytesWritten) < tcon->max_bytes_chunk)
>      tcon->max_bytes_chunk =3D le32_to_cpu(retbuf->ChunkBytesWritten);
> else
>      goto cchunk_out; /* server gave us bogus size */
>
>
> --
> Thanks,
>
> Steve
