Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55492224F0;
	Sun, 29 Sep 2024 15:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727624605; cv=none; b=h2fCq/IyuPdmpWv3TBmyouRXLPZaEeCBfRu81J9qnzD4Br10og2eXxvfXqHoT8XGMuf7icnrQjqPUqWmk7hWt+yj8tUGA/Wujp4TX4UPiKTHFTtW0DO/Sm9E6Mlmu0hssr8uL5ML4UvIiUpjXvfhsxTSJgxbYC4gXqnF7COJ810=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727624605; c=relaxed/simple;
	bh=X6lZdRXfwZ16ku5gLjv5qTjx5nkFjMnKlGAoLts2bwY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oDfQBj4Vhx5Q6mYcDmEPRvJL1e66SxlXGeidiB1op0UAENHQtL7aeg+MSyY2qDZc5JbZjM3XNMGVQdn1AOyniORCdmVwpvy5D2ux5hjm8nj0ii1TJujSdkovambVVKZ04Xn5pUepLJaDhHeCWrydC75EuImNZ/ftLlDBVXVRwxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZsVdX6VD; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZsVdX6VD"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-537a399e06dso4160753e87.1;
        Sun, 29 Sep 2024 08:43:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727624601; x=1728229401; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1n0CktSEL23ehfFD92HK9lqhjT5Y70TnnQ6oUimFnFo=;
        b=ZsVdX6VDyriQ4xrZNw5+1tmpxHiy7Vh3JVQdDViq7jzkR4EgLaWCx0Q70qZY1YneWI
         hHhYdpIiku4X0NtUWAWPYAFbd4bl8hbDPJ+BUBKYN+qjK8r41Gky6dfa6I9LajF46ys/
         b8NP3PZ1B1tRuy7VYErA6k0Vaf+OuNBLVFBRtwRa9VsfyN7L5aMXdelk7nC3K+xfDRDQ
         b1ayLsAUeCzJGjLEiNumSkgiS5R1FOa1YUaRFpQwKF17NT9MjwPrZbrJUggrYiaZwWsJ
         9VewWH42stpEX+zTvl0D7CfdA9k4khmM/3q2K5STXzP4hWp+nh77AdLTqz5VKd8BD+hY
         beKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727624601; x=1728229401;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1n0CktSEL23ehfFD92HK9lqhjT5Y70TnnQ6oUimFnFo=;
        b=O/9MISlbgWRtyyVV8wF8xKksU2PNplx9UI2IFqzzoQvgXT6OjXWLnLUURKhEcqia+c
         88AKb+xtBC/SHpbV/vH7ih3k7KHtxEoyvXCAzsMW6vB8VL5sk2W5KdODsocRJSCTs4C9
         g93vAVLZFy3KAcSzNnGWayOtu2vAIGNLQw7G50VxsybF4Hc2KnIMEV6delVIaQypNimS
         fIQqXUxGF30zi6kw9F584pDJZONGR5jKgBqSEeEqMN70zB5S1M56gRiLl4BEQfEC5ag5
         dC7rcm4tMUIFxJrVQoPn5Y/tl+5IvALVltUXcT4N7CL6dqZitJ4j0WtpUYjOT66O0J2u
         ls0A==
X-Forwarded-Encrypted: i=1; AJvYcCVDnQ6wS9bUCUji3QG2MFs1CcSLnT5k1dRkzSctzCjT+2NQ8uWhk2tpKVUT1SR14oQf/CPHLl2Ai/nvXajk@vger.kernel.org, AJvYcCVM2FM3g9PvQ2kC1w7cLGgKbX8XtTvY5H61XoC2pDBl2qsw8pMtdRo9OFHlDbMhvg7E0qv4DX7cDu7A@vger.kernel.org
X-Gm-Message-State: AOJu0YxDphL7X/i7nX12n47V/jtD7NXYq+YuW2EjXBA6sG3jlxsW4VDT
	7gSuc2Q8/Ptk4jtrpWPGMaHkH7NfX05caNIM99NOOBtwUVGbh5suYHzANbyWkGuYbo1niAIuFZm
	jthiXlLCX1c3IYzi4te47Kc4wgtdr3A==
X-Google-Smtp-Source: AGHT+IGp024VUv+XMb6Dwilq1n6L5N8HIfRasntJ/++FqkeLLlx2Swm9AvOQN2934run9fyj0WYHGFwZs0tF2CKE0NE=
X-Received: by 2002:a05:6512:1396:b0:52c:8abe:51fb with SMTP id
 2adb3069b0e04-5389fc308bbmr5027662e87.10.1727624601165; Sun, 29 Sep 2024
 08:43:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240928215948.4494-1-pali@kernel.org> <20240928215948.4494-9-pali@kernel.org>
 <CAH2r5mvqrWHX6n58eXGL0EgVuhKBD-aZbgrF1DBG9evdXNNaCg@mail.gmail.com>
 <0105d773-3030-4ee9-8b25-b074768df73c@samba.org> <20240929092623.yaqhixsa4eot4k62@pali>
 <5431fa20-089d-4d4e-ba9f-926860d4f202@samba.org>
In-Reply-To: <5431fa20-089d-4d4e-ba9f-926860d4f202@samba.org>
From: Steve French <smfrench@gmail.com>
Date: Sun, 29 Sep 2024 10:43:10 -0500
Message-ID: <CAH2r5mt2jjirZdNCA9ZoENwtAdhfCCs6GxhZjwGtuQpj2q7cbA@mail.gmail.com>
Subject: Re: [PATCH 8/8] cifs: Rename posix to nfs in parse_reparse_posix()
 and reparse_posix_data
To: Ralph Boehme <slow@samba.org>
Cc: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>, 
	Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 29, 2024 at 7:52=E2=80=AFAM Ralph Boehme <slow@samba.org> wrote=
:
>
> On 9/29/24 11:26 AM, Pali Roh=C3=A1r wrote:
> > Hello Ralph, thank you for information. So in case Samba is not
> > going to use IO_REPARSE_TAG_NFS as primary way to serve special
> > files, then it still makes sense to do this structure rename with my
> > patch?
>
> that's up to Paulo and Steve. I can only talk protocol/spec and server. :=
)

I don't think renaming that struct helps since to various servers we
will have to use reparse points to save special files, and could be
confusing to keep mentioning "nfs" for use cases in the client code
where not really related much to NFS.

> > Anyway, Windows clients mostly do not use IO_REPARSE_TAG_NFS.
>
> They don't *create* it, but they can *read* and present it. But I guess
> that's what you meant.
>
> > From my knowledge on Windows this tag is used only by Windows NFS
> > server. So scenario when Windows sends IO_REPARSE_TAG_NFS over SMB
> > would be rare... It would be needed to export NFS share via Windows
> > NFS server from SMB mount connected to Samba server.
>
> That's out of scope as far as SMB3 POSIX Extensions and I are concerned. =
:)
>
> > Note that Windows NFS client stores data about special files in EAs.
> > So for example if you mount export from Linux NFS server by Windows
> > NFS client, then NFS symlink would be visible to Windows
> > applications as regular file with "NfsSymlinkTargetName" EA. More
> > info is in this email: https://marc.info/?l=3Dsamba-
> > technical&m=3D121423255119680
> >
> > And this is what are Windows applications using if they want to
> > access data of special files. So application access
> > "NfsSymlinkTargetName" EA and not IO_REPARSE_TAG_NFS reparse tag.
>
> For symlinks SMB3 POSIX Extensions will use what Windows uses natively:
> IO_REPARSE_TAG_SYMLINK.
>
> > To my knowledge neither Samba, nor Linux CIFS client supports
> > "NfsSymlinkTargetName" EA for creating or parsing symlink.
>
> for Samba: yup.

Yes.  We would only want to support reading the NfsSymlinkTargetName
for the rare
cases where it would come up, but the default for creating symlinks on
the client
would be to use "mfysmlinks" (safer, client only symlinks, like Apple) when=
 the
mfsymlinks mount parm is specified, otherwise use the default Windows
symlink type
when creating a new (server side) symlink remotely.

--=20
Thanks,

Steve
