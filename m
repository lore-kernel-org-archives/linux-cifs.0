Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F59D70836
	for <linux-cifs@vger.kernel.org>; Sat, 27 Jun 2026 18:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782584014; cv=pass; b=gWBqNISGlLW49ziYnhcFd8jE9gcKVW5R5/Lc9uK4ZDpTclhhtn5GuMvL0kqMmw43lqRQxDgAWdItgjNypjIETgeBq0o+COhxGKVeE6H6lLaZbAh6V4xp+akWDYf7os0wDa6su6lhQKyEHbw7m5hO1WCgaFBDHhU758woPvNl5Bg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782584014; c=relaxed/simple;
	bh=ukUrpAUkBLc3ytLMrm9o0OEn4ajdXshUhmsa+nrMQTc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uQHqsIGhIsdbx6vHAm/5apAFB+imcebpxRwug4yclmXFKnl8u/hKfOAa5ExqJM6HrfIdlUtv14z+/9ZzHJ5sppgxVWc2sDndig3x9C+KA1ji+R1lTCrR9sIs3AGIDVZMyqlqY0MOOZMuhLYBsUH5bLDOJWmCwutvcdEui968FU0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZAlKUSXC; arc=pass smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZAlKUSXC"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-8eeadbc5e21so1567616d6.3
        for <linux-cifs@vger.kernel.org>; Sat, 27 Jun 2026 11:13:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782584012; cv=none;
        d=google.com; s=arc-20260327;
        b=EURZsp/gBSvbAjbV4Au37CD1CMY5J/vFhCeqm/yHlgOR6Fec8q5xQ00Le2QOJ5GHz4
         H7TXUiylaVa4glZt3ImRZPSpHeflc8dGTgKmBHwX6n6eTF4EmREpYFrPufGpOPHJ0QXa
         BcjYfsEkWDN3pU6y/Z/5fTa89njeE8HFVZ3aRZxcxlPfDtdNCjKTGmaY95vpY2CmAyJ6
         kysejOS9r6NbNZnyR680raUqmme+h0rSrbXWfzmR+9DnhdjcM7v3763YGR04W3XPIOrM
         NrE6GHgP9E+9EHFcsPWeeHC5nA50fNw0si1Sbu5Y6KGnXrqsiT0WjAWxbRrRSdh11ljM
         m6KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=XFLTaoDqzQJNXmsoubt/ErOFeWWQbVHI04DBDR6KB+4=;
        fh=WMSKUiXUnIYkcTylfy3oDBEFoA6G0G8+wr5C6ScF3aw=;
        b=Glkm77iCoE3HgU0PqLZumyLDsFX63eFjJF3ngWbxZfM00DJ28zkubQkW0wxfOZycE7
         2AvPmtHmYHBYeJFdRp/R3PGc1bIv9mYaG8t2nfjSV8lHrIo2jaNziSudb9dyM32XJWY6
         RdVsPAIWucB/hjqP89/ZG+Hdy5TPoGgGtGt7sUROysg0yML03QCsJNi+Aonhd0VAiA9w
         Sl05PKO5bjz8xOvXoi7oC2SmfNo5Zp2VFdPW5kL7+Qoxp2zMqS/zVyyxwiMcYCS52+sE
         UFv62o3K8PHRo3lfr/DdXV2dRVDydO7d/h9cvwUm9ePEGmPG6cwW61Y66vJxxaEQNuZQ
         Ro7Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782584012; x=1783188812; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XFLTaoDqzQJNXmsoubt/ErOFeWWQbVHI04DBDR6KB+4=;
        b=ZAlKUSXC/pHiCY2V2xULX7ZPAcagrXWgswxhS7i0amJAZYrFYHUaJWG5tTjJFvtXLb
         v5CRW5LmkFRssyEtb6cnnbb8DLOsWcegxElJbxrcjFGS5bIuI2Ez3QsKWJpITeMN5ddX
         alL4AHYaCS7Z6H2NGwjWzt8jwctbzbRbx9oNmfcGNf1A013H/8nxA6YdHE8ZicNzALNh
         tyMVarJknXMPXqgb3gLJsSWv3m6LlGL124xZbhNikJNEVfqLPAi73dlPzlxYL45uLl/R
         B96Ip59biyCycfbc1EWIgFjwtep+uJlsuEqCfJrcx9EO/cD6RYro6Y/E5S07nV+SgdJ+
         206A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782584012; x=1783188812;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XFLTaoDqzQJNXmsoubt/ErOFeWWQbVHI04DBDR6KB+4=;
        b=psF0Ehi6wANMMy2W7ZzsdBCKl6w/678eKdi/kHl9VXbgKHthexMr8SDVqgVTymS+y9
         rgofjeR1YLkjUt2l8YC1wKT1WlQD0rNGsD5XBglWEcPc7nZvQzp8uEjZVAkhq0+FCO1b
         gpnys18HQszG0sUN37eK025wln7UpqrKTCewOKvRIFkSd181kKvgMDxVHP8U5yfw5Yhd
         eBNt8deVSY7KtrfYL4wgHgO/J5f4eKuUdyOmHYfZFl4zX0SzgSTsv7i1OAoj1XN09fWu
         qLQOq9tkSaACH4m+y0KcUG+xQcnhyMBBNxyMovj7DHy/5ceLhD/XEsuFNVXTPvSx79QA
         ha2w==
X-Forwarded-Encrypted: i=1; AHgh+Rpmr+TLpUDclHf7IG8Mofxy8+wk50hlF3olPhn/sGE6bDw/Ux4xXg2eEZ/EkKOQ97cy9WByh7W8WZLU@vger.kernel.org
X-Gm-Message-State: AOJu0YyWA+PqAWr8WdNc56m1HAUHybn6fZ/KODnENiVhAaXU0GwZYYr4
	0RWGWachiYv4LXGYrgbqL2zxvHmeXMWPVgMqboll20TcLuPNAnt2u6uc8tuASK8p6qazlyGHlCb
	wWa4a2iylprvESoVSih3o/t/S6lfff+BII30XzKs=
X-Gm-Gg: AfdE7ck0A1sSDljWYkg3yIFEKgT33g+2g/8BVSVrTEaagCaT5D5p+DTEQbOiPlSqffE
	/F9kRZCZ++IvgK0Hk8IcYOjEG7Mh/s8S/2BBhGtuUM4QlWW9dVe/jfTi8Js68MitAk5mVdN00jM
	Tx5vUft0WEpKv6jOJeP4iq04l7QJFapV2zLzX+ZFeVWh3eFefqKerRSEWduBCtgPAbJFZMZdO9N
	+udedK/3Ky52lAMJztF0zj5Ptqn0fdCUoWUYbCF2OhwiI2dKDwSrEEjvlTUsbPZZJp6boMV4HnD
	B1ufbhnU54QPgmJwp+SVB2QUXmPghSjtSdFGM4wxJ4w2ej0nniYVD9kQTgtCEVKwGycZzsMBVwk
	Vcu/x+zpO3s6g66A88he92VfuMh2TRxV5B3EJ8ltg7e2HWKr4EEIGCazHavhWwq1dZ3uEcwWgR8
	0JgqDJC+Y5wMcSOHsYXrC8Nw==
X-Received: by 2002:a05:6214:3d99:b0:8e1:4508:ee78 with SMTP id
 6a1803df08f44-8e6d5ea4cf0mr202397846d6.8.1782584012324; Sat, 27 Jun 2026
 11:13:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260626134719.158270-1-huiwen.he@linux.dev> <CAH2r5mscAwv1BU25XouJpX_5gx2Xatnh=g6BiLnQj0DvVjrxSw@mail.gmail.com>
In-Reply-To: <CAH2r5mscAwv1BU25XouJpX_5gx2Xatnh=g6BiLnQj0DvVjrxSw@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Sat, 27 Jun 2026 13:13:21 -0500
X-Gm-Features: AVVi8Cc3bGG5b7ezj9BkDb-QELK1B78rbADhA7ASNBx8pkEyrNS69xIknUMNr28
Message-ID: <CAH2r5mtzjPHuAvko1zSW65DeOcX8KmQJuvy5b4RGxCAm0=4yqA@mail.gmail.com>
Subject: Re: [PATCH v4 0/7] smb/client: fix fallocate and allocation accounting
To: Huiwen He <huiwen.he@linux.dev>
Cc: linkinjeon@kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org, 
	chenxiaosong@kylinos.cn, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

With all patches (including smb/client: preserve errors from
smb2_set_sparse) except
    smb/client: verify allocation after EOF-extending fallocate
tests 496 and 701 fail

On Sat, Jun 27, 2026 at 1:06=E2=80=AFPM Steve French <smfrench@gmail.com> w=
rote:
>
> Everything passes with six of these seven as long as I leave out:
>
>           smb/client: verify allocation after EOF-extending fallocate
>
> and revert the earlier patch:
>
>           smb/client: preserve errors from smb2_set_sparse()
>
> On Fri, Jun 26, 2026 at 8:47=E2=80=AFAM Huiwen He <huiwen.he@linux.dev> w=
rote:
> >
> > From: Huiwen He <hehuiwen@kylinos.cn>
> >
> > Changes in v4:
> >
> > - Add new patch 1 to refresh i_blocks after successful duplicate-extent=
s.
> >   This fixes stale st_blocks after reflink and avoids the generic/370
> >   swapon hole-check regression.
> >
> > The following patches from v2 have already been merged into cifs-2.6.gi=
t for-next:
> >   - smb/client: do not account EOF extension as allocation
> >   - smb/client: preserve errors from smb2_set_sparse()
> >   - smb/client: name the default fallocate mode
> >
> > Link to v3:
> > https://lore.kernel.org/linux-cifs/20260625160154.104450-1-huiwen.he@li=
nux.dev
> >
> > Link to v2:
> > https://lore.kernel.org/linux-cifs/20260624021550.1548952-1-huiwen.he@l=
inux.dev
> >
> > Thanks,
> > Huiwen
> >
> > Huiwen He (7):
> >   smb/client: refresh allocation size after duplicate extents
> >   smb/client: handle smb2_set_sparse() failure in EOF-extending
> >     fallocate
> >   smb/client: handle smb2_set_sparse() failure in non-extending
> >     fallocate
> >   smb/client: handle overlapping allocated ranges in fallocate
> >   smb/client: reduce fallocate zero buffer allocation
> >   smb/client: emulate small mode 0 fallocate ranges at or past EOF
> >   smb/client: verify allocation after EOF-extending fallocate
> >
> >  fs/smb/client/smb2ops.c   | 169 +++++++++++++++++++++++++++++++++-----
> >  fs/smb/client/smb2pdu.c   |  19 +++++
> >  fs/smb/client/smb2proto.h |   3 +
> >  fs/smb/common/fscc.h      |   5 ++
> >  4 files changed, 175 insertions(+), 21 deletions(-)
> >
> > --
> > 2.43.0
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
