Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37A6F1F875A;
	Tue, 25 Aug 2026 01:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622140; cv=none; b=GZ15PjWgpBW4BbusBE/dON8PGUKFsqcmvzmfxNuCWayHQVND47XeLd/Shv5oQuIYhCDc2Mi3gJDZbBtzDJEJQbR8CAU8r/DV3q+igfPj9Hyn5CS6f2OHdawfvX/U02v74efCMGPcrYItv5SI1f/IIlISr6/aeO0xNpQg5WpenfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622140; c=relaxed/simple;
	bh=8gAgaGrjLtsSg4qEaTSl4EMBcI0GdbyENowNxpE6H4w=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=DSshTzX1P9eFPYRFwc0ER7277SWEtynrySKaqA60Ve9RnDoblRv4l6yDuoKNetSdj8LircGnDuUTb1uHNUfvr/j8ZAt6PpibxqB3WGxFHorD5zHDUzgYl+8lp1bVrYm0AhGixDpTPk99/TEL/7VVPCoQUIq4hQQliBI0p3Y8T/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=WdIXdQy7; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="WdIXdQy7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=gYglQ5f2kRrAian8yOTwkyaRtVz5oLWT+91y0w0SX3s=; b=WdIXdQy7yI1hkOVDOUCOUWkB0b
	j6t2kaS2Sib2TZeSq1vu7oGZcVjbFTAx2FNQNYndlsnXvenV+u/X3jh4pSEzJM8tR5voHP5f3XetT
	2FAwcsu5MBjR0vvA7DPrfbe14ydOjqqPbQw/FNsLhxKj13BKlkiPzi0triGzpspiuL0pp3RTZvUth
	erOItJk5XGaJjJb0365u+2zvLUtmi6BE+dWyocWfS81kwOQJ06LSrer/wK5qNXNLJMiOb2VfCZqJU
	eOkPCBSDcQ/PuHTUHWzdhvG/uK0bUriGinN0msr65on7hAa5QdX7uSeEOJw1kS0A8Zb1qU+vfxN++
	So5DqJGw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1wygB6-00000000biO-0Hdh;
	Mon, 24 Aug 2026 22:42:16 -0300
Message-ID: <b3c7586e1cbd8b367529558966d7ac28@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-cifs@vger.kernel.org
Subject: Re: [GIT PULL] smb client fixes for 7.3-rc1
In-Reply-To: <CAHk-=wggh_sJkraY9Hxsa9MCOYjSpE0zibz6eUceT_B=hmNzog@mail.gmail.com>
References: <d2674464b7dc751afe232f31411d5379@manguebit.org>
 <CAHk-=wggh_sJkraY9Hxsa9MCOYjSpE0zibz6eUceT_B=hmNzog@mail.gmail.com>
Date: Mon, 24 Aug 2026 22:42:15 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Mon, 24 Aug 2026 at 15:06, Paulo Alcantara <pc@manguebit.org> wrote:
>>
>> Attached is a pull request for the patches if you
>> are willing to take them immediately.
>
> I think I might as well take them immediately and treat it as a merge
> window update pull, even if it looks like only one of these commits
> have been in linux-next. Not the comon situation, after all.

ACK.  Thanks.

> I assume there is nothing else pending right now?

Nope.

> Also, I've mentioned this elsewhere, but since I'm starting to see
> more pulls from you I'll mention it explicitly here too: the merge
> message should describe what the changes do, not irrelevant
> technicalities.
>
> And one such irrelevant technicality is how many patches there are.
> Nobody cares.
>
> Would it have been any different if it had been done as one single
> larger patch? No.
>
> And if people do care about the "five patches" part, they would be
> looking at the individual commits, not reading the merge commit
> message.

ACK.  Sorry for attempting to follow the wrong pattern then.

> So I mention this because I reacted to "five sensitive data leak fixes".
>
> The "five" is uninteresting, and the "data leak fixes" aren't.
>
> Those commits are clearing keys after use. That's not fixing a leak,
> that's just hardening in case a leak exists elsewere.
>
> So I rewrote it as "clear sensitive data after use".

Makes sense, thanks.

> This is not a problem, but I'll be happier if I don't feel like I need
> to edit things more than necessary, so I'm mentioning this in the hope
> that people will stop that pattern of numbering patches in particular.

ACK.
