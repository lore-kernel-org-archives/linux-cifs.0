Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F327728690
	for <linux-cifs@vger.kernel.org>; Wed,  1 Apr 2026 02:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775009654; cv=pass; b=Temyl6BJ4v6wEe7UJS/jEJlRvjjDVWsXZafBdjCGFdA5ZMcSur8NvvxbYxfIrH3CYMr8ZuHVxMTCg6qlrfcGf6t9eUWNL13CuBI8siowDMf+5Oo/A86uktNMB9GN13wB4y9H7ioLv0aBKGguiGtdjtTwQpjUAmensmcuEVap+zk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775009654; c=relaxed/simple;
	bh=p2+7Bu+ZeRVjzsfnR5hiOqqix18FZJbHmV2+4pPGsn4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rGUUZjKFrtcvpyp7NGJY3vykvJjE6hYaafEVL8ncTLJ91KkiSnsmmh5K+GTpHWPpNYMqWsodxT3tqSQ4ChC2TPu5avtDDsdNflM9cfKRDk4dMPAjV3Kt+xbdrOhp4r99x1uO86oJwCpJ90P0gkUTssRIF6cgtj2Dpz4VEXI7Ro0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=czPEUTN4; arc=pass smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="czPEUTN4"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-8cfc795ca97so575122185a.0
        for <linux-cifs@vger.kernel.org>; Tue, 31 Mar 2026 19:14:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775009652; cv=none;
        d=google.com; s=arc-20240605;
        b=jLeVJhzsPXEWCyQh60/IKkxM5dayz6e1ioL6XsJFXr5TF6LLbzy2SZ1kiG5h9VO0p+
         zJdaQHLGeWjZwAESefRPwy0rjozHK3TLD9wSFpGVnIHyNesRbovgiM+J2s5vkj280QxF
         OG5EjmwaCaj1bM9jK3LJHqhul1fpuT8rMRQGOeaEkdCQDWXWfWX99vwnXsgLZwJBpNFm
         xVnoDsr8bVewRfK0F54Y64rfDDBVTBEZGH4HVJEmkra/3LRfYPB6qK3yfeio1NhrRccQ
         kL+NsKhp34xA7JrMUtJAZdEA6kAo614cN6hXHNjQ6hlB05/eZY76Pxi/nlHKjyCsPkTo
         yYaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gVGh0l3jazLsBUiDX0ySZLc+Xs/vb/rMl4hzAjL5dIA=;
        fh=SQ/8XEAGvwe3MRhbnuLeeI2LL6uozSUaDGXVXkm/KyE=;
        b=KB0pkMObuAeaJjU1+9rtppvgdyspu3vxEVzpzXlIuC+OaxF2V6AGcPj4yJytrYkf9u
         KcH9ACdVsp42uLREtlioMs7Ab8XtsWbFndE8iNOZDwL/0IgYwQ4o8KuzconIoVuohq5y
         06BbU5zU+fGllB1Cyz/F6YCUVqYlG/SVNA6ZgaCq4nrRJS7mMBn3XtB7PFxP2Lt4eG8z
         PBFqqeVEA4r04Hb/26R76MCYDBrIPEStNH+w52D89DWT+FaxI1WAG1YJrWRcWr734gf4
         al6apIs1q7QfmI+/TDWM+OJVhciG/xn25EeQGlCHGesyyOAYfwXb8AZ6Eq59D5vHV+zN
         TFrQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775009652; x=1775614452; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gVGh0l3jazLsBUiDX0ySZLc+Xs/vb/rMl4hzAjL5dIA=;
        b=czPEUTN4zb+51Q7e19JvovB7qhHlOzK0kfrS7px7KYRMSvrcBbas2mufa7W2ni1CCi
         tLBUlmGJBMEVjf12ct5GYHYXQSw4KoF20QHtdEd42OS+kWwLnDWXvos1ZwSM5FtmIRu5
         3pKIEI5DXFhuFL1kI0EBDDXfv6sDQ9fLyP8Fh1KcMCxMWIPUURMyns3BnDDzD91dixyn
         TpJzyOyXFXzQ3OYXWmhquXawZk2Oh6rLrENMKqqZT78zBq0M7Ol3GcWPc8ODBPuJMAqW
         AU88rQbvndlbMcbu0ou4YuUN5s2u7+CpYX6Z4LAiiS9Sp4odvIHvleKtoMkT1ANypYZB
         ncFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775009652; x=1775614452;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gVGh0l3jazLsBUiDX0ySZLc+Xs/vb/rMl4hzAjL5dIA=;
        b=SHwMPYtmvte/NN/I234/PDK7VBeswVvH7jK4skhXP2b6tBTEC0j7ucnInrGRVkBCSB
         p47Y4HM8WgqtZqhpIXD8KYs0DDwrkoahnL5GNMZMtzcbvydimMzkz2X5NrDq+Pb5ACuU
         3hIqQve69WigHy/WrlYz+Iyg4pfqH88BXsrpTM/C4tLBK9Z+c+HaS8Js/JAdbt60WIbG
         VyRpOAxhCuynHOnQ6n/7l9gRdhcHLENlT2r12/5Q9KKD0k/EBmCbZ97ga18y1ZTh50qu
         YgJGCzncmcCwk8i4HZD3J9xNeZ0keBPnlKzXBycVjyC+8GSUmAxsI3/bvJRUdTFuOSo1
         MYUA==
X-Forwarded-Encrypted: i=1; AJvYcCXo5FP3YSGrdcVYFc0e4S5tt99+aByXVjNog02BaqtyGSg4H13HIOHZztezSM0DYutwdRVzIXOJIHud@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1xGL80HR3Qg1ouTaGEAbR9HYfXq4FqmAI0EYSgmknuh82K7lw
	Na9Fp9zwg2fcLweJigTxaSxMhVG/r/nLudJUoHOViLYBgd6FFsIhQDAgbHJAEtPDBNtNI91c/4k
	MqFkxjvoGfbr/NxtSskd3mrOYsbsZ0ko=
X-Gm-Gg: ATEYQzwXywghj/3b08zw1PFgLCcKQt1/cEl1juFjGTRIcwLHyLJK7Z1DQr9tvQmMddD
	nnqCiVriDnkxS4SLsanWUqv5v3gXqPD3K4V1i3Eq5GuC2UZ2RP47Uy+zymGof8fEtMcCguRucIB
	uTFadI3gcGR72K2iHscPnHRnNav00QHZI8NteMSa6zRrHHaCNYa3UCsA63zCY3t1+S1yqWVJ+9g
	ZB1xbb+j78PWiFSsKTUIkID7k8Po9U6xkvZ1K692S20IyMC0wSdIdeimsnIkvxBo1+U0Zu+tia4
	sEJXg5KOaVfhkGj3wxM14g5r6jTN8znrHPQKVZJ1mqtd7gijXbPL7J1uKOgU1aDiZo+cENW7/yR
	EHfrdMqoua7UznGDcX+sqQj7xd+o+G/9kd7W2ITAIWLWKg1hpynhfm3JwXCg42Ld6Vfz0IX8Lv7
	79hihNkPAEuFy9zp8dhqOg
X-Received: by 2002:a05:620a:2686:b0:8d1:a75e:2f8c with SMTP id
 af79cd13be357-8d1b5bcd79bmr324980585a.53.1775009651744; Tue, 31 Mar 2026
 19:14:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260331012508.17410-1-ddiss@suse.de> <rt2s32lnxvi7rfhmoqpvujls3shmbumor4imura7ryvaqizbcf@qc74gdiyr74k>
In-Reply-To: <rt2s32lnxvi7rfhmoqpvujls3shmbumor4imura7ryvaqizbcf@qc74gdiyr74k>
From: Steve French <smfrench@gmail.com>
Date: Tue, 31 Mar 2026 21:14:00 -0500
X-Gm-Features: AQROBzC9EYkiMNYc0LCVlUqmTIA4TFz4tPo9ncy9SlTqwimevi5KhASw9rOUphs
Message-ID: <CAH2r5mu+a=39irbGViiXmOuFz4R6PrWQTOm4jUOHbwdmhNQeHg@mail.gmail.com>
Subject: Re: [PATCH 0/3] mount.cifs: minor buflen tracking cleanups
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: David Disseldorp <ddiss@suse.de>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Added the RB and merged into git.samba.org/data/git/cifs-utils.git and
https://github.com/smfrench/smb3-utils for-next

On Tue, Mar 31, 2026 at 1:06=E2=80=AFPM Henrique Carvalho
<henrique.carvalho@suse.com> wrote:
>
> Reviewed-by: Henrique Carvalho <henrique.carvalho@suse.com>
>
> On Tue, Mar 31, 2026 at 11:37:50AM +1100, David Disseldorp wrote:
> > These changes are minor cleanups to go atop the bugfix
> > "mount.cifs: fix buffer overrun in set_password"
> > https://lore.kernel.org/linux-cifs/20260331000911.16062-1-ddiss@suse.de=
/T/#u
> >
> > David Disseldorp (3):
> >       build_assert: add ccan build_assert.h header
> >       mount.cifs: adjust get_password_from_file() buf size
> >       mount.cifs: remove runtime pass_length calculation
> >
> >  build_assert.h | 40 ++++++++++++++++++++++++++++++++++++++++
> >  mount.cifs.c   | 18 ++++++++----------
> >  2 files changed, 48 insertions(+), 10 deletions(-)
> >  create mode 100644 build_assert.h
> >
> >



--
Thanks,

Steve
