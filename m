Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C448F2248A5;
	Fri, 28 Aug 2026 01:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787880611; cv=none; b=I/Bfr+JgS/ncT4qQC44+hT/i8QU+TywfSCEV1/HOFQG6h2ICORFfTbOG1d44nIkkEBY3g6HR9F5NW7chhUzAotwpTo8lTR2G8yHGrxsFjaj/anGJ3vL2y5eq13YRFyOj9wqePW2zaB2rWissltVeI0uXwLjpDpDVpFcJOfnTQTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787880611; c=relaxed/simple;
	bh=kloQV5VWpsLW45WCp/X2bXYyEUkYNMa5T6ZXQXm7sRM=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=CSJntX4mtbxvmzapBP7OlPhvZQifDYp2zmoO5IH3Tkvc4vz1ihEdUM6ZlQ5qaiWJTN4G30rg68mCIyhMSOIwwjxt3D0JsoGMtF9ylb85j7iUpZb6VKITPcnhtUfgPa6jeKjmFALDqQ7u2tMTzT4HyEIksDbIxyvO0tfPU5kZBvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=4/d3Y7+3; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="4/d3Y7+3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ryOJJW06S40T9Lc30xfxQOEn+gUpgd3J6/CVPV0KbEM=; b=4/d3Y7+3khIWD2c4wZH/konRC9
	wNWXFzvBkpXE6VgmeGb2VKShA8J79mLKmqdY4oonxtU9fLUZBHwZ3nDMQh9dT/lOJbZVFrEb+Y8+I
	E5XTB+mrVIW0YP1TA7bgHUEPP/94DVi3UuR9+yoqXGnpAj6BMAqv4SOuTkCAWYqvFkUS3NBQXzLuS
	IeUEdWytMoocnW6GRVBghCsuBGuqIyKvDlQt5x9Q99f7j9At4EKQU/VV7QQHqGJIE9ITqW14m2ZFp
	TLEI90OBP9dfkOMWgEFyd0tJCuNLSjhT+yW+nn+NuQSwsJ2/zpfylFByjcTjMXXytLdljZf88OVMh
	54i9X+vw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1wzlPz-000000008yh-1M5R;
	Thu, 27 Aug 2026 22:30:07 -0300
Message-ID: <61168e3b796d424af9612ad9619ae95b@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: sorenson@redhat.com, linux-cifs@vger.kernel.org
Cc: linkinjeon@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] smb: client: tighten validate_t2() offset bounds
 against actual buffer size
In-Reply-To: <8b7e30ff-fbd9-499e-b371-725c7b85a189@redhat.com>
References: <20260825030948.3577275-1-sorenson@redhat.com>
 <f67877e37eeede299fbbe86914cd58f2@manguebit.org>
 <8b7e30ff-fbd9-499e-b371-725c7b85a189@redhat.com>
Date: Thu, 27 Aug 2026 22:30:06 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Frank Sorenson <sorenson@redhat.com> writes:

> On 8/26/26 6:03 PM, Paulo Alcantara wrote:
>> Besides all these LLM-generated messages and comments, would you have a
>> reproducer or a real use case that would require such changes?
>
> I just want to apologize for going so far overboard.  I identified a
> potential type of issue, and then kept expanding the scope without
> finding a concrete problem or reproducer.  That's a definite
> overcorrection; I tried to fix things that have no known impact in
> practice ('malicious SMB1 server' is a pretty weak threat).
>
> And as you noted, I relied too heavily on AI assistance; that's on
> me.  I'll be more careful about both the scope of what I do and how
> I get there.
>
> I'll obviously withdraw this

Oh Frank, that's fine.  No worries.

My only concern is that this SMB1 code, and as much as we can avoid it,
the better.  The bugs are still valid to be reviewed and fixed, whether
we like it or not.

If we could have reproducers or any other way to validate them, great.
Otherwise, it's fine too -- we can fix any regressions later.

A few days ago we were struggling with getting diretory listing fixed
against Windows XP server because of a cleanup patch that touched SMB1
code that had been working for a very long time...

I'll help you with that.  Great work.
