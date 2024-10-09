Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1FE112B17C
	for <linux-cifs@vger.kernel.org>; Wed,  9 Oct 2024 05:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728450198; cv=none; b=c1xavgBGnBmpRs5Cv6e2B0rUiCchFeiPrP2c78OY4/wotVlzPQBMBGLUD6L1W3n/Aa/wEsNEgdQX9Pi5CY+eVwYDuS+LZ6X3nw3LIBxoYIz83iAZBd6k1VYvv0XYvVeZ8zzH/WOWP61o6+eLDjAsJaIu5v0nJfRoC0kkdBimpyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728450198; c=relaxed/simple;
	bh=gRA2fk9++h1h6HZuv3C70Li+E+/hhRYnVpyzQ2//Sp4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BP+4x7xClonkofSUHyyi1XPEw3U/SPlKN2khuaerMhNJJHXDEl5+bfZn9ShdWqQTDvegv77DDOw6jYBidRJDBMsNzJ1iJ6ox5+MDNY58/7kLBA2Jr6RwquZidudMqw/duQ5mcX/Zm9B4Kgp/lU8xzyI4aK1tQpadbqlgmcGO6mU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WD/JjIgA; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WD/JjIgA"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5389fbb28f3so512926e87.1
        for <linux-cifs@vger.kernel.org>; Tue, 08 Oct 2024 22:03:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728450195; x=1729054995; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/vDJuYeA+Rcqn5mGCqCwKH0ssRyBNhSnjVYokvyKius=;
        b=WD/JjIgAGn+YRIPQenPAPqs+Iqub6/ogJ9MzHahZ0JH8wNEuKqBYXHVGfqp9UzHW/I
         bnXIBrMgK0jDrgpOXNwjYSBitWxWwmIyv+fEkHiSd918VKDP+F/rFUe3qQD/A8zbXWo+
         ygce5j5CYPP5IEH+5ZBytQLc+HGKrZZwvs0U/x/S+K9AuvRkdVibCTJ/qoy3HRcFFd7q
         z19nogkCcwYCQsXh6U6czR383UVMr02ynATVJo8LXGpjXrx8cWRs2jHtHswpmBnUNBWT
         0bugtRk2haaW5ud5RhGC4MfnlM6H/ssbA6EFc1v0LaSzlPO4VHN5HF0j+SPLm6xQ64IR
         14Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728450195; x=1729054995;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/vDJuYeA+Rcqn5mGCqCwKH0ssRyBNhSnjVYokvyKius=;
        b=ZhKlc3oGbYlCx5FqXoWxutHDoiwG/sh/JiKUDUcV6W7VSwelSbymWlqo0YnGR41Sg3
         9GsFhEniRJpKKlpq2Xnjt/1UHqD25u7irXs0zOMMjVm/n+mmb1dSWYI5yfVWtRDRJwy1
         htiji/XrBzHj7lvWp2tIF4oSg9HAnI/nuRV8wsLmMaKc7GayIUosU6C2YimKidRzYLm0
         tdDyETSbXBvjRw7ZKOx1ftbIj3PKtj73Hs8KqdeZ8fLT0GPzu6cOrg09bvqA2nQm3fgw
         CY1ocwe+DETh8lwU4GsWgBgcJ/HUL8n5VIhYHexKr3ohElxDzfvVKz/rr4hxUdIh/tYT
         Cwpg==
X-Forwarded-Encrypted: i=1; AJvYcCV5+Q9N9EKMqTq44N1Eks+wkgbEmoXKCAuzj3hvNUmfQ7TsqcHtBH2+xSDSbmOfSI6dHQeDBLv7wCp4@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2w2GZxfQdIFR2RYYTAZvT4jvjYnikkPUGhsxlgQtPbvB/bqXQ
	9paDHdU9CSQh7+d3zGpobpYqXkEIFLxbEABdTUSjDD4sL8jqfhpprB7ey7kfXOCwxs78mRIpzmW
	rXbJr0oq4Uvu+JXyJ+mxSQSrWWnx/MLZK6Yo=
X-Google-Smtp-Source: AGHT+IFscxRyzlVDbYBb2kWtFjYVKbT2kk/dKwizxqdp+GTji+IwZoe+CGePmzCDnpmu5UBtXX66TxZOk3FOFQeKibc=
X-Received: by 2002:a05:6512:b99:b0:539:a353:276b with SMTP id
 2adb3069b0e04-539bdb056e9mr1731738e87.23.1728450194451; Tue, 08 Oct 2024
 22:03:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241006103127.4f3mix7lhbgqgutg@pali> <01f5a207-7dfe-41f4-b2bf-bc38d48053b7@samba.org>
 <20241008181827.cgytk5sssatv6gvl@pali>
In-Reply-To: <20241008181827.cgytk5sssatv6gvl@pali>
From: Steve French <smfrench@gmail.com>
Date: Wed, 9 Oct 2024 00:03:03 -0500
Message-ID: <CAH2r5mvUjZdDo2gEZ-PSrP5cYT7q25yT7-J1RcaaLxGh-h7Eaw@mail.gmail.com>
Subject: Re: SMB2 DELETE vs UNLINK
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: Ralph Boehme <slow@samba.org>, Steve French <sfrench@samba.org>, 
	Paulo Alcantara <pc@manguebit.com>, Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

FILE_DISPOSITION_DO_NOT_DELETE  0x00000000 Specifies the system should
not delete a file.
FILE_DISPOSITION_DELETE  0x00000001 Specifies the system should delete a fi=
le.
FILE_DISPOSITION_POSIX_SEMANTICS  0x00000002 Specifies the system
should perform a POSIX-style delete.
FILE_DISPOSITION_FORCE_IMAGE_SECTION_CHECK  0x00000004 Specifies the
system should force an image section check.
FILE_DISPOSITION_ON_CLOSE  0x00000008Specifies if the system sets or
clears the on-close state.
FILE_DISPOSITION_IGNORE_READONLY_ATTRIBUTE  0x00000010 Allows
read-only files to be deleted.

These are interesting flags, but are we certain they are passed
through over SMB3.1.1 by current Windows?  It is possible that they
are filtered and thus local only

Have you tried setting them remotely over an SMB3.1.1 mount to Windows serv=
er?

On Tue, Oct 8, 2024 at 1:18=E2=80=AFPM Pali Roh=C3=A1r <pali@kernel.org> wr=
ote:
>
> On Tuesday 08 October 2024 11:40:06 Ralph Boehme wrote:
> > On 10/6/24 12:31 PM, Pali Roh=C3=A1r wrote:
> > > But starting with Windows 10, version 1709, there is support also
> > > for UNLINK operation, via class 64 (FileDispositionInformationEx)
> > > [1] where is FILE_DISPOSITION_POSIX_SEMANTICS flag [2] which does
> > > UNLINK after CLOSE and let file content usable for all other
> > > processes. Internally Windows NT kernel moves this file on NTFS from
> > > its directory into some hidden are. Which is de-facto same as what
> > > is POSIX unlink. There is also class 65 (FileRenameInformationEx)
> > > which is allows to issue POSIX rename (unlink the target if it
> > > exists).
> >
> > interesting. Thanks for pointing these out!
> >
> > > What do you think about using & implementing this functionality for
> > > the Linux unlink operation? As the class numbers are already
> > > reserved and documented, I think that it could make sense to use
> > > them also over SMB on POSIX systems.
> >
> > for SMB3 POSIX this will be the behaviour on POSIX handles so we don't
> > need an on the wire change. This is part of what will become POSIX-FSA.
> >
> > > Also there is another flag
> > > FILE_DISPOSITION_IGNORE_READONLY_ATTRIBUTE which can be useful for
> > > unlink. It allows to unlink also file which has read-only attribute
> > > set. So no need to do that racy (unset-readonly, set-delete-pending,
> > > set-read-only) compound on files with more file hardlinks.
> > >
> > > I think that this is something which SMB3 POSIX extensions can use
> > > and do not have to invent new extensions for the same functionality.
> >
> > same here (taking note to remember to add this to the POSIX-FSA and
> > check Samba behaviour).
> >
> > -slow
>
> So the behavior when the POSIX extension is active would be same as if
> every DELETE_ON_CLOSE and every DELETE_PENDING=3Dtrue requests would set
> those new NT flags FILE_DISPOSITION_POSIX_SEMANTICS and
> FILE_DISPOSITION_IGNORE_READONLY_ATTRIBUTE?
>


--=20
Thanks,

Steve
