Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C29293B297
	for <linux-cifs@vger.kernel.org>; Mon, 15 Apr 2024 09:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713171671; cv=none; b=GJ+WOOd+Ppy+6+YD1QBypeLnNVo4WECeNb1DyEmDYa/eXDd65DYFKSCI98JFkSTZNcZlM8plRwUKa/Qiid0emz3luIJcw7iZ/ICtSIhsAFwixuVNUCPAJPXe6wvlkrxhNpckp7RB9hu1n16mYp2iGHGoeU+8kciGz4BEN9jNdaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713171671; c=relaxed/simple;
	bh=9KpMkmPTQEMsyrb+f+WLY1gPmUf53+Y8w0FbLnQBBQI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QqwxUbOf4l3KqvGGA2mhBoxk6YlPsS+ArmjMBZgE3sWBK3iN7ZYvycJJsLTTrQvrw5Jkmcz0OH8hCpdODFHNwGhhG87vxBA/pIGH0rkkRfy/QCY4cHegaY5WsUxSlbJQfZHnlktrsPqzHEXpEdtgJv/QMfm/IGyFr6KFG4buxrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freebox.fr; spf=pass smtp.mailfrom=freebox.fr; dkim=pass (2048-bit key) header.d=freebox-fr.20230601.gappssmtp.com header.i=@freebox-fr.20230601.gappssmtp.com header.b=YMG7cg+V; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freebox.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=freebox.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=freebox-fr.20230601.gappssmtp.com header.i=@freebox-fr.20230601.gappssmtp.com header.b="YMG7cg+V"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-518931f8d23so1929203e87.3
        for <linux-cifs@vger.kernel.org>; Mon, 15 Apr 2024 02:01:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=freebox-fr.20230601.gappssmtp.com; s=20230601; t=1713171663; x=1713776463; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AugIkbVxCrPMzdvolQnczjHt5CrOV6dV8faXV7iNP4U=;
        b=YMG7cg+VtR+MHMsbszF2Bk9BpU06Xsltilg4/LPK2thVEOyk6Ih3p3Z0kPlMDLm1Hi
         GLf3b2caqebJKdAhFeDXo4VeM7erM1XQTyVDTjU0xa42RTf2dMCUC93zQjq8ZSyGra0e
         FTG9TLDPbkzoCw9RZg8GfqRCnTG95Sm34ZDPTZCbo/z0Ptxdq9Czrm1wf5y7TgIVs5e4
         9V6H3rRFqjjYYDyVHNJ/RkFC0oaWppTy1mxOHHtEBXsk/cJsE5pAxDVJvpKM4MCl4M29
         UOSx4PknyR/KnLwFeKA7rLuuv5O+IltazMp0GlcYluyT2F8LTbJLysvJdogaFdO+cN1p
         fU6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713171663; x=1713776463;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AugIkbVxCrPMzdvolQnczjHt5CrOV6dV8faXV7iNP4U=;
        b=lDHxUWVqGFK6NcuJbw+4y2ESbK0ERxilhwoSsvGK5u2PiZxqfut9Y6GG3B+pIUZjaQ
         lsxTcRJutrV3BSwI3VrM8O9G8q/dd2cbvXq1hEpuWUXeRzyBuzfvDitDO8XNcpECf+/p
         XwPQwndSEPrNI+PWc0158eKFBPeXSObBa5UMOmTD5g0QNc94gRqUwy07XtWAYidECzBS
         z4N8OMgklXM0J+nFJmJcCt1vwvPSiCdRMhfRljN09SDKAv9gTbOxGA7g744OtgjT7qls
         ED51OXOtM8zfs1xlalyxWI4d5aCJXjDZcqq8Q/N5akI0+FCsBu8g/chLQoKaLlbKp/Gn
         VPaw==
X-Gm-Message-State: AOJu0YwXLQgok43G27yiPw5sPhAFxJ7l71KobgwSH9ftsraT3PlEVCBq
	CnKU3NYPsH3XK2psmG3ljv1TgPVN+QtKE6d+65rd0VOUiAykr65oBPJ2mQxvBtCy3K4ETFnNI+A
	um9ARd+Fl7OQGvmDELOMpB0tX3z2HbkRBdhaDYkggmEVhSFwD
X-Google-Smtp-Source: AGHT+IE+9JsJZ3VQa1OPhttAckSE2PkUYpu3ruAYS55aNlJDFZbXvLfra3PMtDX6MwtcD9zNA0IlUpdS/dXQvZ+foRQ=
X-Received: by 2002:a19:ca01:0:b0:515:d1b9:3066 with SMTP id
 a1-20020a19ca01000000b00515d1b93066mr5085210lfg.46.1713171663469; Mon, 15 Apr
 2024 02:01:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240313130708.2915988-1-mmakassikis@freebox.fr>
In-Reply-To: <20240313130708.2915988-1-mmakassikis@freebox.fr>
From: Marios Makassikis <mmakassikis@freebox.fr>
Date: Mon, 15 Apr 2024 11:00:51 +0200
Message-ID: <CAF6XXKVNTF2yZK=QdKi-YNZC5N93x-NrN7a=hDGZNNCUfxTAwA@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: clear RENAME_NOREPLACE before calling vfs_rename
To: linux-cifs@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 13, 2024 at 2:07=E2=80=AFPM Marios Makassikis
<mmakassikis@freebox.fr> wrote:
>
> File overwrite case is explicitly handled, so it is not necessary to
> pass RENAME_NOREPLACE to vfs_rename.
>
> Clearing the flag fixes rename operations when the share is a ntfs-3g
> mount. The latter uses an older version of fuse with no support for
> flags in the ->rename op.
>
> Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
> ---
>  fs/smb/server/vfs.c | 3 +++
>  1 file changed, 3 insertions(+)
>

Bumping this as I haven't received any feedback.
Are there any issues with the patch ?
