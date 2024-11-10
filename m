Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D2A647;
	Sun, 10 Nov 2024 23:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731279737; cv=none; b=YtgxxNGIXyK+NIgKpAWI7FI3c7io5WoZ+ozX3D/V9h/YJ0+MvuFiOtNJxJIbhRqoiX0O/HlrEB8soHALL+o4ri8b9mUOQxMwmcBt8fO66l8d/J7r6HWcnjMcfJFLmHZwY7rZ+YVrFbkUwIXv3JJKwrxfhz6OkysTsM5igMcHPHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731279737; c=relaxed/simple;
	bh=vAz+LR65uBstdyYP2ATEBuceJLStdpC/o6JglmhL/mc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PnRxXbmHu71a1cVgg15JA/ZPdQdYmw/z4IglkvaTMVZOZGjQAq7/XyIc4htw0KAC+t9JgGG3MjAwVn7BHu3hxkj1peWOjkXIlSV27Rq67LTVhkYotHxyZRgqc+Qvr7vbhcfXooEAHj+7zCenKUCmVd/VOOm/Lvjkc/XEWv7gNn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VUW3VY31; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VUW3VY31"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-20caea61132so34875925ad.2;
        Sun, 10 Nov 2024 15:02:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731279735; x=1731884535; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bitiFti2cmHrS8tjbLhDtwNlCQXcEb2acAduFPY3M2g=;
        b=VUW3VY31wPZy3kSIyK/A4hNlP8ZOTnX5QsEzFVqKIArLX8+l9lP6y2e50JHPDs7vTy
         O7eCvvkKh7UvDcsBUN3cyt0ENRqYzwMdGAo8C911zWKZocn5SixNSPPeoAxF7d7CMj9g
         DtUcaA7tHoSEG8FpKHEFgobjYaL//3q7IUDdjzTE6bSvEfZpJy3zrUEAuZ+K4Rl4ZLEC
         I2xc0hlqEzjE/VJpudbFdc0a6iQLilkOJwXusqXG1Zw6rsqiC2V6SSzhmZAwzJOPm2th
         tczNXo2IUrIsxJ7hdd9ntHhadxx83D8ePngucjBb9qVa3iY8TTACue//J1eIxSZ9v4Gq
         R5VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731279735; x=1731884535;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bitiFti2cmHrS8tjbLhDtwNlCQXcEb2acAduFPY3M2g=;
        b=RWshm0X4IvkIWPI5Xei/8x3e5c2mKN1turHxfuyRENvntp99eoRl/7g8s6fGQSLNoD
         iLdhQ05Z9PbZ1vMjtWxyInLzbsg7MphMyS3KgP1bAY0kJzjEZOinkD5KXsbIjV8bQzhw
         77EAnDdPU/f0grknO0qLcVJaV3XH8BCG2AC1gMkfocNoiE/lYk2zPR3E0ji3jvJmjXK/
         5sNuWHTaf0oK8dLqQ2/mNnGTPnpQqirxcgBCO8iTbBFr0vneqJb8CwpmGM7mf0BqwDIT
         PgsTgNTaX2lqhqRNDesrmq7+QkpqJqO/1iwcldbi/WywuukOWJ+rh8mjya5RHBnkuK24
         WCAw==
X-Forwarded-Encrypted: i=1; AJvYcCUhUbG+8F02KD8Px3KYK1tFn9J8TUscI52nckGzgYIsH3WGkJu9u+gDYDH6zxofyeRrkJ5Uh3O4v8yG@vger.kernel.org, AJvYcCVqpfesTC2DxB63etL0vkYCTD5+ykPEI7P9ZXtugd7fAoMBzFksZESnrZCmhZ/X7GZ3l9WWdlx1hOBxKrgU@vger.kernel.org
X-Gm-Message-State: AOJu0YwCOpL12CldaGke3DZUvqzrub4IP3BTzWJLiCu283z5b31ZK6Dx
	HjriIJiDmDYBV6H3mnoghIsPkySTNX0idUiNIWGi/MeWcg5YWl1VIpq5BZ5mlPOfO8rX/zcO3On
	7cd98Z6wyEkrRnrlMa0CWDl6/7TpIVA1s
X-Google-Smtp-Source: AGHT+IHZMZDNkenYFapUuPRJJtxFq43VXnEH1vwTgHc1o4VnTwbQRHJ+HCjszyDPcMGh3f5eVyTEN/MfQkOpnlyw6jA=
X-Received: by 2002:a17:902:f68a:b0:20c:a692:cf1e with SMTP id
 d9443c01a7336-2118358afb4mr150394205ad.43.1731279734830; Sun, 10 Nov 2024
 15:02:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241007210214.102568-1-linux@treblig.org> <Zy0reBfykkwXA47d@gallifrey>
 <CAH2r5mvL+xXH_nnoKKKnVPFo_xtOb=8mPSqrG28Dgngx6Aab7Q@mail.gmail.com>
 <CAH2r5ms1y3XsGmA2kU6Vdvdmg_jnVyd2w7mQPRyX9oh9rFD2tA@mail.gmail.com> <ZzEOuqDwagwoGCMf@jeremy-HP-Z840-Workstation>
In-Reply-To: <ZzEOuqDwagwoGCMf@jeremy-HP-Z840-Workstation>
From: ronnie sahlberg <ronniesahlberg@gmail.com>
Date: Mon, 11 Nov 2024 09:02:03 +1000
Message-ID: <CAN05THTgj+_78kG3LFnpU9zsjEEBAsyDZ0P20YL3-DP94r3KUA@mail.gmail.com>
Subject: Re: [PATCH] cifs: Remove pre-historic unused CIFSSMBCopy
To: Jeremy Allison <jra@samba.org>
Cc: Steve French <smfrench@gmail.com>, "Dr. David Alan Gilbert" <linux@treblig.org>, 
	Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, 
	Bharath S M <bharathsm@microsoft.com>, CIFS <linux-cifs@vger.kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

All of SMB1 should be removed.  Not just disabled but deleted.

What are the plans in samba? Any timeline to literally delete the smb1 code?

On Mon, 11 Nov 2024 at 05:51, Jeremy Allison <jra@samba.org> wrote:
>
> On Fri, Nov 08, 2024 at 10:09:58PM -0600, Steve French wrote:
> >As an alternative, might be useful to see if this command still works
> >to Samba and/or older Windows (and e.g. enable an ioctl for it - might
> >have been useful in the past to old servers)
>
> No, this command has *never* been useful. Please don't enable
> it, just remove support.
