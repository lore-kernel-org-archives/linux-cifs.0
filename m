Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56F437D07D
	for <linux-cifs@vger.kernel.org>; Fri,  6 Jun 2025 17:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749231307; cv=none; b=ly4PU1rDW9sRMW4TFoDvmj9Ayq81S3IGz7FKHYWj8gOCFRqvJAzQ3ATJ5j71CNjXKIQFQDRn9xeD6MKHhGrhl2Yoel/IydeXIsZ3igZo7dFRVNdsUUe5KI1g3kggjZGplOjBeh7p1+oLqnGK30d7kruyUhFTygkhoG+t/R0T3oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749231307; c=relaxed/simple;
	bh=XN+Yyr+KZxnXoy7dNU2FduQFayqFAI6A3pj4R4XgrYM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oScg2nzV0JI3msujw0gi2Jk/nutaR165E7oQG61AwzB1VI6+6mAhSrz/7eqRAdt1ERUkvSbg29fBm/pTzJwX98pgtGRSVSOW/vDI12DyZj5A1685vloVLpENsp9b5AyO3E/TnjSh/Twm0zVSdhwvEfOUDHS2bamXxQh2Xc8lsKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=burjSuec; arc=none smtp.client-ip=209.85.208.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="burjSuec"
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-32aabfd3813so19820631fa.3
        for <linux-cifs@vger.kernel.org>; Fri, 06 Jun 2025 10:35:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749231303; x=1749836103; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XN+Yyr+KZxnXoy7dNU2FduQFayqFAI6A3pj4R4XgrYM=;
        b=burjSuecF/HAVBl3SG1LLZrtaC9BugwxJyWLk717urYrKicB0rrfnk9wJCqzc5QVYZ
         v0mzo//Y9loqnDRMoYagK/xHBubzqQj+E7FBRqaYDh3Gh+qe5/HFX1HR+GHuhB3by6Qr
         s5Q+gKlSBcFQ8kiroCRb9eaJICik/ii5e7/ENbkRLVyjpq0nR0MXhqUJuTvQHRBltErB
         2NU20+HccMlOR6kiTy4ifJDUI9EVVDomtQCcq6DnltydHgUT1+85V+CectXPEPGyJMS4
         +JddsN7nt+ibC9LQZ8qlFsdQOmuX/s8ArkQvjoQXdbKg9wyGWEtQ9misLqLzqEKO40lE
         a9KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749231303; x=1749836103;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XN+Yyr+KZxnXoy7dNU2FduQFayqFAI6A3pj4R4XgrYM=;
        b=ST7ECOBUvrdC/k664RmDt1Wfqjs+5H8ZzP+cynxGSqNkklPbUHzTZZ8oPVk45z7YEg
         htyikEfQzoivi4/KzLPLBSAdgujOZj0xuYpn1E682j++JXuKBUOUcdDEiGuqzccYquZs
         GEGWxJbJEu70aOmH3oo8KWYs139Tk3p4/gpng2vKqpd3CDUvE3oP6B/sncrr5H0VxXvd
         bpCMnXoBIOKxkCUc0g5oTK8Pjwq26aPUT8KiB4RmUJRZ+t1YFFFU0cVmf+f/2MdGAKTp
         cfQIiu+iBc17QJaVcv4WYIqe10K3JdLTmKgu44qftP6M5NatV1XdQhpiTaW7Ir5V5GSV
         01Eg==
X-Forwarded-Encrypted: i=1; AJvYcCXfwRg17dqli0lOexm2jwTwdx0ci+Tw64ne5GOTZCfxCe5DwBjvo4upHFqcGtdLTF75E/o6SUqhAoYX@vger.kernel.org
X-Gm-Message-State: AOJu0YxWfYxqfqqSnx4WXDleD/ynVsJpSNbRw+4iaWRQx0Uyn9uSNvlK
	M/hFtmBvBIFfX87+ajFvEVZXj0AJoRxxnLkvKKW6XZMgQshHR/PR3EzrvfeHFFijOscIZ2LgWn9
	ILPUmGWIGU+K4tGFxlq/tMcklT9WbnQ5qDA==
X-Gm-Gg: ASbGncsBf5/vWKv7XcbFv7jNbQ0QBMT9Ogq2V0PhLP1u0N12ukDv/ouFlPyOr9vT7EZ
	BxxdcTYqt718q4DqAlrJt11U8Io6wglsEQ7cV3xbrymDUbW/vdV+5BLUs2GdlkQ/2ve7FLDRqm3
	qCwP9gnHFonyLTJa4cOtaHokEzfs3FmKdzrAHtWHqlm9Ertx8HUVoTyCiW00mnkNRgxaj4r3LB0
	La0wA==
X-Google-Smtp-Source: AGHT+IHP6kdGccTyR5wbm2qzkSs97lcC6og0cw2iZjCPTJAQ+7KS+KxRZQ8TqTOdQtr6aQ21fGXdeOVXHGGpZkU83wA=
X-Received: by 2002:a05:651c:108:b0:32a:66f7:8a15 with SMTP id
 38308e7fff4ca-32adfed5cd4mr9024551fa.39.1749231303064; Fri, 06 Jun 2025
 10:35:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKeu6dXUhLP2cjagz_+YB2Esf-rnj3RQHWaX96R2bEBOk0C6dg@mail.gmail.com>
 <35a57e9c-e5d5-4e78-93d7-83fc147080fb@huawei.com> <CAKeu6dWbejr5EbL=AxWrYDFp7cPjkovM7g+Q-jfrmGR0+wfnxA@mail.gmail.com>
In-Reply-To: <CAKeu6dWbejr5EbL=AxWrYDFp7cPjkovM7g+Q-jfrmGR0+wfnxA@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Fri, 6 Jun 2025 12:34:53 -0500
X-Gm-Features: AX0GCFufH_87D7DMijWqCkiUnBHnJet0mtAEvEIJ00-5J3O-qBMe59zyy_oZHKQ
Message-ID: <CAH2r5muTk=hQmmYJheBz0W0_7pbduV9DnTXYN34saCVEgXUd2g@mail.gmail.com>
Subject: Re: [BUG REPORT] smb: client: find_cifs_entry() suppresses some errors
To: Maxim Suhanov <dfirblog@gmail.com>
Cc: Wang Zhaolong <wangzhaolong1@huawei.com>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

There may be ways to log it if it is unlikely to cause a log storm
(that could be distracting) or make it a "log once" message

On Fri, Jun 6, 2025 at 3:28=E2=80=AFAM Maxim Suhanov <dfirblog@gmail.com> w=
rote:
>
> Hello.
>
> > If the original error (e.g., -512/ERESTARTSYS) were propagated directly=
,
> > it might result in unexpected behavior in userspace applications, as
> > these programs typically do not handle raw SMB-level errors.
>
> Usually, file system drivers (like Ext4) propagate I/O errors. For
> example, a read error in a directory block on the Ext4 file system
> sets 'errno' to 5 and the following kernel messages are produced:
>
> [ 4995.871562] EXT4-fs warning (device dm-0):
> htree_dirblock_to_tree:1083: inode #131073: lblock 18: comm readdir:
> error -5 reading directory block
> [ 4995.871919] EXT4-fs warning (device dm-0):
> htree_dirblock_to_tree:1083: inode #131073: lblock 18: comm readdir:
> error -5 reading directory block
>


--=20
Thanks,

Steve
