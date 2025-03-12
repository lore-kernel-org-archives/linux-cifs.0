Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6F933D76
	for <linux-cifs@vger.kernel.org>; Wed, 12 Mar 2025 16:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.235.159.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741795374; cv=none; b=srbJKkLkFTeTyByl0qn2kFReifwQWhk5e7nZT1Ebl3brqsNFykaqwRDT1vzRCwuhO8aN6/LX0WDMuOKFvHfmt5BsEX5gSAk9h8/oLmmKSfvZq4zCxPHDp3uiFEh3FIsTWkNLXAU823BmtTCD9W6bbyIYIEwrbcttFo2w1ymh6k4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741795374; c=relaxed/simple;
	bh=QqfsnUscBwwI/SSkjC86d9dwA4lnAB6GE+2cgN7yUk4=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=MZOqSMFsWeAwgOL8rwr4cP/oarQIJE/4sMwXDbL6TxakJ5evo1ekjjAXqC4Do/vvnun6bD3+r5xIfW/6dIw9fCjpI+nzIYQsOaNUn0lF5MxLoba5V2d/PNccHs8+TzIwRBq0uWiS9Ai7Bh+39ZRvxGNkW6nImpvcMgBaQSwKtP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=Y7F7iljE; arc=none smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="Y7F7iljE"
Message-ID: <4cbaab94c2ba97a8d91b9f43ea8a3662@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1741795367;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=V+QA8rzap3eKFCsVLNNx2DOliSIb49YZ3hDl+570+eI=;
	b=Y7F7iljEPi5UGga5hofndl3IBtFphIlHlB5a9VfzZsvMUWIoO+BlMtfZUnqN7Ds37u9X0N
	wwfi8yqWQgAUUkd3ySa2yLNW2wTsDBsNNyL3dITj7U0/jn7Vla6mQotX/Se6UokqNjXZAu
	g1Eqz9WdQWGX7LpUVqnYA2YL6H+X/ZpPyy8/E0dFQfOuJuZ7hgSyYH4Errl/I3ZhLM5MK/
	VXvBWPCwPWPsEwoAtqVRehtgv/bjdFN6ITZG2jnxc3R+atYpc7bXd7QfUCzHLyKL8rDzGA
	ngwyX5kuYP1N02mZ++KRefmea4ioAb7yrMZcBtOBk4BYV4DKpbhC9kSf3sW96w==
From: Paulo Alcantara <pc@manguebit.com>
To: Adam Williamson <awilliam@redhat.com>, Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org
Subject: Re: [PATCH] smb: client: fix regression with guest option
In-Reply-To: <70d0157ac13725595d64978b11c4d3a91f417803.camel@redhat.com>
References: <20250312135131.628756-1-pc@manguebit.com>
 <CAH2r5mtjtigJf7JKUiL3D5Lp8f4qTe4GUxQPXwz1o=SQMqiqdA@mail.gmail.com>
 <70d0157ac13725595d64978b11c4d3a91f417803.camel@redhat.com>
Date: Wed, 12 Mar 2025 13:02:43 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Adam Williamson <awilliam@redhat.com> writes:

> On Wed, 2025-03-12 at 10:32 -0500, Steve French wrote:
>> merged into cifs-2.6.git for-next pending additional testing/review
>> 
>> Presumably we could also update cifs-utils (mount.cifs.c) to
>> workaround this as well.  Thoughts?
>
> Yeah, I was going to ask whether just not passing password2 when doing
> anonymous mount might be an option? That way the new cifs-utils will
> work with older kernels, rather than being a sudden surprise for anyone
> who happens to get a new cifs-utils but not a new kernel, for whatever

Yes, we could also change cifs-utils to not send both password= and
password2= when using guest mount option.

The kernel change is still required in case someone is using mount(2)
directly and end up passing an empty password2= option.
