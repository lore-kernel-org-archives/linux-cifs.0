Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A416120B22
	for <linux-cifs@vger.kernel.org>; Thu, 28 Aug 2025 09:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756373045; cv=none; b=MuJUG+vKEgMtgG6G2nRbtVG28GRgbUKq5oFrkXWYWefaVqVlWLTkfnVBC5pNgGOfaArEJ2DNTKC+GZCnOdnc9cI0qMvaTtTOHx+N/XEQgtabQPXYSzl8KLd80OSot1vS+CSkw07A296L4XrcgM2HXmlkKbUg4PEZ74jY1T9gJfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756373045; c=relaxed/simple;
	bh=+4yxKCkLzMA0J+Fz2iATs0DXvQDa6Tnws52+EBImWWU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rehp8M2mDodnW127ROKo/WDw3eMPqOPglzN6m7cqXVuOCeOtJivWan6VlU+McFwe0GXpqaMOGo98Sg4txE4xM0XAgBUBlszE+56JO8gVPkf+dUkK8wL//E0f5Cs0AAhrQQIgd+9Cv9Oh07q6jYU7QgUIIDQoPaDhAvUtgoLel2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YxMrj2me; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YxMrj2me"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-afec56519c8so114913966b.2
        for <linux-cifs@vger.kernel.org>; Thu, 28 Aug 2025 02:24:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756373041; x=1756977841; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KVSeY9LKXNcPyK5G+NPzyrCFluj1V33Bh+RbqFTZPrg=;
        b=YxMrj2me63fmcWhvGeXGzzoeCCZIpi5SSJT/gHASGzvJEZ5GwLMZqoYCCHz9/Hc5eH
         zrAG9t9yjOpHmFvatydMMAwlUNUlQoKLT7yJGM1Z6noaw+1tJ08dGT+MsWh8y3mmjKQe
         tK9f5/KQxI3khGI0AyZQ7FflUa7tcl2LSviL1BkHuvhYw6DIt0AyKUfGGDopGf4DlNYy
         Y4SLTdgt/gLZqhF8UbJgggNFdnM9eNoqqRiktsuhHsPbg9wvSN9rQ6/gSaD2Ckwa3thq
         T25TFtOrlcdWQ0/aV3SvYML1x2OUWwAg+JIJstVO5dxON2hbYr2QCHuskyykMIeOQ4rY
         VatA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756373041; x=1756977841;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KVSeY9LKXNcPyK5G+NPzyrCFluj1V33Bh+RbqFTZPrg=;
        b=syaBT1RgZMfcRDXd9JeqstLyw9060Ks0vwwKkqNNGsHTvFMiN/dMWx7xd0G/ULUsp7
         XC8g49wf8ra35Le0i19IW45jw3xm+zgmtgDsx/vuvk/hI+7JwrOg9N/eKqp4vP0eeo6b
         +OLkc1eHHo7A9UDvqtjV0YA7H5GeWGMHC4/o13ezEC9WxCQn30h67l/qQa81zTO59BPO
         hPJiBuKCADCez0YnGqPkccTTuQCmDIPIDz3QjTW73IAf57DjbxAqGStUQms8V/wrLPUu
         Twp4YO8OPrnQNKaVY6u50YWfZlN7ZJ//Es40eTibI5SiTvut2fT07qGBG3iJI2p2QMbU
         7rrA==
X-Forwarded-Encrypted: i=1; AJvYcCWvThw8Ipa6wQerjakEd+bmnFT8BIoxjjGAHhhmb5QdIk2rO7lRuKM1We7tbSb0nP1OrbHr9MUdTm5l@vger.kernel.org
X-Gm-Message-State: AOJu0Ywlx3Y7KkQN5RU/2LAQ5p6dg5DWeK+PrelDzlAAhlKIC4vqtibL
	qTUuvF2QmX3PXi0R6NP5oiGyQLE1nt/kIUT6ha8gy0hSanJDI+WliMUaf8DXxq0wMJXsa+koG9w
	6Mt9ozzN88yo2woUfitCJA+D4J4g8xLQ=
X-Gm-Gg: ASbGncsl8B1c807oVlvmtjZAC2vxXYmt8oY7bZtPqqgK4V9Pxn6iHGX+3ai6OvJVUpL
	skX0mMFDG8Q9/QQ4PqMR4f5O9hnraB6GuJ2S3ZxIXp7vJ9egy6LIO/g/v+0NyJioyNgbvLxyoA/
	8SZ7nj7fh9yZ2wILlBnqyvBLgFpfNgfpsuWZkMmBR7sVsUYUpVlOuJ5XIaNSwcUYtR9ln4OUMkd
	dRAOUODRdfJ5Dmllv0=
X-Google-Smtp-Source: AGHT+IGtNKhIFLXwb7EMxIenSwQ0Bre1jCie7YKt6Ctqjv6MaaLHosxkSPs5l4sj3JlPWJtZJ7y+lYfNkgWkucR2+jM=
X-Received: by 2002:a17:906:f591:b0:af9:29c1:1103 with SMTP id
 a640c23a62f3a-afe296e5004mr2094857066b.55.1756373040577; Thu, 28 Aug 2025
 02:24:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5muHpZOTU+CHrmG1OnpvXNmfia8CxAs8v_uEPOZrHFr-1w@mail.gmail.com>
 <1f5a4297-8086-4914-af44-1cf76393c8c7@samba.org>
In-Reply-To: <1f5a4297-8086-4914-af44-1cf76393c8c7@samba.org>
From: Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Date: Thu, 28 Aug 2025 14:53:48 +0530
X-Gm-Features: Ac12FXzJ_3by5I3Z0OH_YlXXu2aFSNzzE1gAHyn2Z4EeuOhytXbJnUun4PIs8v4
Message-ID: <CAFTVevUWWrPgs=Kb6E3WtSiyTmWtoD8QYiONJ1hYkS37ri=NrA@mail.gmail.com>
Subject: Re: smbdirect patches for 6.18
To: Stefan Metzmacher <metze@samba.org>
Cc: Steve French <smfrench@gmail.com>, CIFS <linux-cifs@vger.kernel.org>, 
	Tom Talpey <tom@talpey.com>, Long Li <longli@microsoft.com>, 
	Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Metze, Steve

I ran some xfstests after building Steve's current for-next-next, with
all 144 smbdirect client and server patches.
All tests pass save generic/258 (negative timestamps test).

generic/258 0s ... [failed, exit status 1]- output mismatch (see
/home/met/xfstests/results//smb3/generic/258.out.bad)
    --- tests/generic/258.out   2025-05-19 08:53:10.883041010 +0000
    +++ /home/met/xfstests/results//smb3/generic/258.out.bad
2025-08-28 08:45:31.148495408 +0000
    @@ -3,3 +3,6 @@
     Testing for negative seconds since epoch
     Remounting to flush cache
     Testing for negative seconds since epoch
    +Timestamp wrapped: 1756370731
    +Timestamp wrapped
    +(see /home/met/xfstests/results//smb3/generic/258.full for details)
    ...
    (Run 'diff -u /home/met/xfstests/tests/generic/258.out
/home/met/xfstests/results//smb3/generic/258.out.bad'  to see the
entire diff)

This test fails against ksmbd even without RDMA. It seems like a
server problem because the same test passes against the Azure SMB
Server.

I remember reporting this failure to Steve on 13th August too. So, it
might have been introduced before this week's changes.

Thanks
Meetakshi

On Thu, Aug 28, 2025 at 12:16=E2=80=AFPM Stefan Metzmacher <metze@samba.org=
> wrote:
>
> Hi Steve,
>
> > I have updated the cifs-2.6.git for-next-next branch with the 144
> > smbdirect client and server changesets (on top of for-next which is
> > 6.17-rc2 plus a few cifs.ko patches unrelated to RDMA/smbdirect)
> >
> > https://git.samba.org/?p=3Dsfrench/cifs-2.6.git;a=3Dshortlog;h=3Drefs/h=
eads/for-next-next
>
> Thanks!
>
> > Metze,
> > It also looks like there are at least two "Fixes" that qualify to be
> > merged earlier.
> > Do you want me to merge these two into for-next (so we can send it for
> > rc4 or rc5?)
> >
> > 8170223a650e smb: server: fix IRD/ORD negotiation with the client
> > 5dd0894d057a smb: client: fix sending the iwrap custom IRD/ORD
> > negotiation messages
>
> Yes, they are intended for 6,17, but I'm waiting to hear from Tom if my e=
xplanations are ok for him.
> I also didn't get a response from the rdma people on the u8 limit.
>
> metze
>
