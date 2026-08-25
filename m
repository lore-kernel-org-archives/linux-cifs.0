Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F12C223BCED
	for <linux-cifs@vger.kernel.org>; Tue, 25 Aug 2026 01:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787621273; cv=none; b=FSCKD/XQ2cVvEORN4KKUCts9Yq4i7ItoeBMZDehYoCHbME6lo8dcdp13eOL4LHpH05qBqVyC4KvQSrqa/Ni2n8khR3r9A3wWEzSGtIqM7mj6LL5xi3+waNqfT1N/pHnvj8XDRCgLiK5OMzAXrd09Z1kbSrWIBSaVieOwiLlK/Zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787621273; c=relaxed/simple;
	bh=8cRIOGw8G49aI1BVResD5NjKCEp5pMT+/YNjG9xSK24=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SOHTm2ZMokwj/vTzi1xzS38in1/wdyTdub6ZolNMAkFYK+OjZxjr8cnk1Kyr1+RLgrQg5BCYFmU9rtUm1MNnEDcPsSromuWkqIfGaXJNE5zu0AlN7KbhD2QPP6dBBHmlxubGw/imeiecRJ6H7qIpdZokgWgByOxuOyBWj3Pe1/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XSw2/7yN; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XSw2/7yN"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6983d3dae7aso483783a12.0
        for <linux-cifs@vger.kernel.org>; Mon, 24 Aug 2026 18:27:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1787621269; x=1788226069; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2ikiGUNPuFLNexOn5WM9QlcQyS4igFoEL4KjHd9usB8=;
        b=XSw2/7yNjF3du2I89uKSgz3zvrt0Dd5vgoy7X503BpuFsEiZJ6vchuh4CeoRd81FDh
         NR+lblcn9EORfa7T7u5B9KjmrN+jBvuJrZAqMcmOCz7oaAdsuka09Ujx84+erC6jAWIo
         FGCYn4sjKTqKbYlGUjAag7q+V+rfi/7KoMHQc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787621269; x=1788226069;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=2ikiGUNPuFLNexOn5WM9QlcQyS4igFoEL4KjHd9usB8=;
        b=dE/TeVsQxu/EgOWiCsgAgMCFOy19K+90BACMiwJE4JhIb+uurGqg5UfnHeUwnoMy/b
         c3e56XE9+NuEGASPJyASlj/JGEyN5bV8Iq2KacTW4EkbDXevK4Q8rYvoX0jisi+f7UgK
         JeU2bA5G5PbxkvspP5iS8pU6vwCdBIrXpDHdbzqLqVxKxALzmt4DRRbLlzmA4hCRyGDB
         r2Om6JUUSDWogvszS93xSzC437K+MspDsAgCH8gC6feSHvS0t1PfQ3adocaS7kL4+jK9
         5YMy+SC9gs5CExGh7uFCPQS42ERoJCmzc6m4JgLuQbkWZcdDJir/0Fr5ijmJpWAa4aW4
         MXwQ==
X-Forwarded-Encrypted: i=1; AHgh+RpVhGaZVMXk26MoSDTxVlh08nUCeVEWkHjQtCoqhcvOy9BJ0+kkVUuSqfiYRuMoUAcetPHKp0TVqDHc@vger.kernel.org
X-Gm-Message-State: AFuF++n58ZP+zJBDUwxkxscygotCHMVSVHaXv30YGifN4KGH7daY0Ygc
	wqu8xVSAlmunOE/+ax6dApW7yLieX6eLMlKM/G/MpVNJosWyBnSiadPKKrAJXru9cGarMy97O4e
	BWy4tpYo=
X-Gm-Gg: AR+sD105svB9aMMtkAyK7ZwDyQwQADw2fTrpnYsorrxJJk4Cqcb4mGxU/fdn32NrnGI
	8i9ubKy2pVh/dAJ5YHN9FAK5gzsSpsRtaj0geqHbWqgRTYotQa+yWChU+qfVsFe2rlrLx39nQM2
	JV2vgOxJHUsaeH+pQ8dnesNoMgDvxX+JnOFl4o+t8+K9aJLGSG9VpE2g/TP1B3UMTHR2tXAU+2r
	gLy8ac1S+UZHXkMeyjSL5h6/W1m/xXrQfWkzdKy6o++jFpBPl1H2DB3FKVNwGlnfrJiaGHKMRIP
	b9DuD26++OK4XyQBKd9Fpga6ESrh4JwdMskO4dF0mr50ZeVEw49PS55MB8R6otKJDz8MqgY8LxV
	ETdmUt3i2WjZo25eTOBC1JBFOfMTDrJ0EKAUyPCDXTxXR0Ag2Y0kM93N/LAI2BT84YLnW3hZa8g
	1mtIpG3X5DcQoZnni8zVvmD1UkSnhhDAaC7oPGcauko/MBZM9PdxybV3KnyGm298mFOr0OoC8Lo
	qA/6mceahmpN56eFGrLsVK7gb8fI+FeWBQQzHFLKjlFkV0d
X-Received: by 2002:a17:907:a0cf:b0:c1c:49d9:4c34 with SMTP id a640c23a62f3a-c24e2db3d7bmr340134866b.11.1787621269110;
        Mon, 24 Aug 2026 18:27:49 -0700 (PDT)
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com. [209.85.208.47])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c249672becesm1555039266b.42.2026.08.24.18.27.48
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Aug 2026 18:27:48 -0700 (PDT)
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6983d3dae7aso483762a12.0
        for <linux-cifs@vger.kernel.org>; Mon, 24 Aug 2026 18:27:48 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpPS9kZa/72G/GQ0niAuafzwO2Ijo2Qom0LLK349sqEDF4e73v0SK2jxrJeWguoHrmMiLKpPPpEOhM+@vger.kernel.org
X-Received: by 2002:a17:907:9619:b0:c08:580e:899a with SMTP id
 a640c23a62f3a-c24e2df3d90mr253848866b.10.1787621268058; Mon, 24 Aug 2026
 18:27:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <d2674464b7dc751afe232f31411d5379@manguebit.org>
In-Reply-To: <d2674464b7dc751afe232f31411d5379@manguebit.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 24 Aug 2026 18:27:31 -0700
X-Gmail-Original-Message-ID: <CAHk-=wggh_sJkraY9Hxsa9MCOYjSpE0zibz6eUceT_B=hmNzog@mail.gmail.com>
X-Gm-Features: AcwNN1WWp9C7XPlHxzA6bo0M8ljfHtxWkVwah3GfYF7tumHLafLqQnEIHjMxfSU
Message-ID: <CAHk-=wggh_sJkraY9Hxsa9MCOYjSpE0zibz6eUceT_B=hmNzog@mail.gmail.com>
Subject: Re: [GIT PULL] smb client fixes for 7.3-rc1
To: Paulo Alcantara <pc@manguebit.org>
Cc: linux-kernel@vger.kernel.org, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 24 Aug 2026 at 15:06, Paulo Alcantara <pc@manguebit.org> wrote:
>
> Attached is a pull request for the patches if you
> are willing to take them immediately.

I think I might as well take them immediately and treat it as a merge
window update pull, even if it looks like only one of these commits
have been in linux-next. Not the comon situation, after all.

I assume there is nothing else pending right now?

Also, I've mentioned this elsewhere, but since I'm starting to see
more pulls from you I'll mention it explicitly here too: the merge
message should describe what the changes do, not irrelevant
technicalities.

And one such irrelevant technicality is how many patches there are.
Nobody cares.

Would it have been any different if it had been done as one single
larger patch? No.

And if people do care about the "five patches" part, they would be
looking at the individual commits, not reading the merge commit
message.

So I mention this because I reacted to "five sensitive data leak fixes".

The "five" is uninteresting, and the "data leak fixes" aren't.

Those commits are clearing keys after use. That's not fixing a leak,
that's just hardening in case a leak exists elsewere.

So I rewrote it as "clear sensitive data after use".

This is not a problem, but I'll be happier if I don't feel like I need
to edit things more than necessary, so I'm mentioning this in the hope
that people will stop that pattern of numbering patches in particular.

                 Linus
