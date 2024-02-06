Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B92745DC
	for <linux-cifs@vger.kernel.org>; Tue,  6 Feb 2024 04:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707192368; cv=none; b=sxWvH/T22k6uwmLgTa13cFolkMrrShf6BICr/IAMjUY2TLtozPKhTTbP83oZrXqVoemFI+LwccyT1yfftmaEQyNlLv2hL30PrP7HZBDxzxC+tAyBJlaIholwt6QibgCTw8GCyePxOYwnUD0413Be5kjFMxeTmY8iY9hV4G1fBmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707192368; c=relaxed/simple;
	bh=mTyMD1qSBGzYGnwES8UmGdTwddcliM5wAPCQyfNKu8o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H/yLnzvaI6bWpS5FH4i+QiSPcVW0RJ1TkJsU9aMds8DVhkFIwdvg1Uz2zUE1qaBtWUugphYt4p9q+vxeCKYg1BnnT0hlFwqJVQXtLf2CZc23nekKnb/fKIcMD4PkxtDJLYVH2Q7iuuD5YH7nABWDSli8eiewpl9VigkHSkQMvuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W+nRbVnm; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W+nRbVnm"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-51124d86022so7967948e87.0
        for <linux-cifs@vger.kernel.org>; Mon, 05 Feb 2024 20:06:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707192365; x=1707797165; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k2LkHwtM00dtjHDY1TM1aw800eJJ+laQNNwInnQLaik=;
        b=W+nRbVnmPDFI6uF8UFjTdfp87vnyYjMEiN46qwjdbQkGVlmX1kZntx0FLN6gqPEuK6
         Zkx/sK1rx7ZcuWLax9JoLTLZ/NvBbzUySFVH6BRnleZwEOeNL3ybDkQDDnd8bf5QQh2H
         CUD2W5C7waQIVzuiFvOwf4gWP3wqFvnryoN5JROMmvdeymErBQtf3xEYsAa6xfkKzYWQ
         vWeW59HGTut3ZGZ0rKPu6710nZRqDIEwtkzTMUILFXTIkuqdGf0ODp28+SGSqTyxH0l3
         1keTRQawSS1WvtHpnb4Ij/bx2JBAMWLE7yDI5McMKGmY7e4Leev0pE97/irBqFtJkq7X
         8HBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707192365; x=1707797165;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k2LkHwtM00dtjHDY1TM1aw800eJJ+laQNNwInnQLaik=;
        b=HOc4IrSq4gFusj6ZO2yfsRIlrjXIasApFeW+wP1TV3eGw9FKV7Iok4UBvuSE0n+rBp
         iRUnlesWTKu+WZUD40Zf1umDUFQROETx2/F6if8KvWN0NRGd8Orw5ZNES6ZZBXqc61Wj
         mwzWFBR9uB40IGmRTtXhW+qQ+qaQ2+ost2W1Flde0GyO/O4J5Mz8mNqLT52KwlBfdUyz
         T8Vo00mVApExp2BpXoLVoMvR9/+OcyxUfnNDEWdyD7pcEU04/WJwRmChYWbFSagFH3Io
         WIZU0n5CGMISZh4T98brddJ0iL9jdbRB2IwMrUitoqOlzNEO0clLrQsQMKhK9OF44+BY
         By2g==
X-Gm-Message-State: AOJu0YxflH+t70892uHcl8wkNlsV7Xhez1N1O76N4wtarAY5AT51zt7l
	bkNfgKxO/xORkDYyyuvoXJgO8HTO+6IadKKlWdILIj7IGytBRAyH5KnOnAft0QWmTviYC7GI/eK
	m/fUhzc9qE+mVpVC/Pon4i3ceC1Y=
X-Google-Smtp-Source: AGHT+IGtUQqBYT2NVWkiOUW4pT8B80kL/+p/YsAXvEc137WLd5TvhLaB9uxgCyC+e4A2+Gd5/nvHGMhQjFDY2kdSdTA=
X-Received: by 2002:ac2:4c30:0:b0:510:569:4f4e with SMTP id
 u16-20020ac24c30000000b0051005694f4emr638312lfq.63.1707192364430; Mon, 05 Feb
 2024 20:06:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <3003956.1707125148@warthog.procyon.org.uk> <CAH2r5mtYF4MgTz8v3DGfYiDycMMaGywuyPxF9-61d4575-S0bw@mail.gmail.com>
 <a356847f-afa0-446a-b896-fd2b9af2e393@rd10.de> <3004197.1707125484@warthog.procyon.org.uk>
 <262547e6-72e1-436f-8683-86f7a861f219@rd10.de> <CAH2r5mt3we_rcKrkyweaVcH53QVYE8jaV9NCvaEvOrt16bwr1w@mail.gmail.com>
In-Reply-To: <CAH2r5mt3we_rcKrkyweaVcH53QVYE8jaV9NCvaEvOrt16bwr1w@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Mon, 5 Feb 2024 22:05:53 -0600
Message-ID: <CAH2r5mv6mvtSD3VpHKUtA_3zNDMGhFFkeLus1h5HpNZEJ2Q1pw@mail.gmail.com>
Subject: Re: SMB 1.0 broken between Kernel versions 6.2 and 6.5
To: "R. Diez" <rdiez-2006@rd10.de>
Cc: David Howells <dhowells@redhat.com>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

In my additional experiments I could reproduce this but only with
wsize < 32768 but it wasn't SMB1 specific - I could reproduce it with
current dialects (smb3.1.1 e.g.) too not just SMB1 - so it is more
about you picking  small wsize that found the bug than an SMB1
specific problem.

On Mon, Feb 5, 2024 at 7:30=E2=80=AFPM Steve French <smfrench@gmail.com> wr=
ote:
>
> I can reproduce this now with a simple smb1 cp - but only with the small =
wsize
> ie mount option: wsize=3D16850.  As mentioned earlier the problem is
> that we see a 16K write, then the next write is at the wrong offset
> (leaving a hole)
>
> (it worked for SMB1 with default wsize)
>
> so focus is on these two functions in the call stack:
>
> [19085.611988]  cifs_async_writev+0x90/0x380 [cifs]
> [19085.612083]  cifs_writepages_region+0xadc/0xbb0 [cifs]
>
> On Mon, Feb 5, 2024 at 3:37=E2=80=AFAM R. Diez <rdiez-2006@rd10.de> wrote=
:
> >
> >
> > >> Unlikely as you didn't take them for the last merge window, let alon=
e 6.2.
> > >
> > > That said, you did take my iteratorisation patches in 6.3 - but that =
shouldn't
> > > affect 6.2 unless someone backported them.
> >
> > Please note that 6.2 is not affected, the breakage occurred afterwards.=
 See the bug report here for more information:
> >
> > https://bugs.launchpad.net/ubuntu/+source/linux/+bug/2049634
> >
> > Regards,
> >    rdiez
> >
>
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve
