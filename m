Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84DFE1C84D7;
	Tue,  4 Mar 2025 20:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741120677; cv=none; b=grhPQLuTR/hx+jVhoBUtJ+biCYZGBnzdcE0FHxc2op6UPXTvf675HFgWA5ypuseaV53U31eNeMVdY3FxfmP5G57dzLXiyMW4101cNoCTr4roqUX1+A6LYij/IBmCYASXXVQLYRN5U1azAiqcGDL+LLNXbKr5GQmmZ7FLTlF9UhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741120677; c=relaxed/simple;
	bh=xA79ap3bpEUriYkN1bPNbZ+Olo/PCwhjPzuSzMggTww=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jeypHI6ziUDK7+hWopPOQ3P0QoKJbazEzEUK0e/GsYdaXl0FzSCXuk4+FyyYq/ttOQqMGCy/IsqHnk9ojJ9F8MPmQcHMQsD839eOCCKpjqGjtY5J+LJP3xK+V675nGgxCwkWWE5hKMdoA+OTqMzWxArSxCxofi8V07AcZSGg/do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FG7O11FM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FG7O11FM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBF80C4CEE5;
	Tue,  4 Mar 2025 20:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741120677;
	bh=xA79ap3bpEUriYkN1bPNbZ+Olo/PCwhjPzuSzMggTww=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FG7O11FM6GQaICjFVqdfiCOEAo0wdrnOoTDso41rXQH8dg+ffvPTaPiGZepBsAUTy
	 mwX0R5jlPYHxUAuNTJ5vDKsuITI5LTkNhOzV2YdXt8D22wT6aj30Kfo6KAspSLrx75
	 n+tvgZA+iLucqqYYcKPMA7OifAe2nTpZ5SxzFM9IxFo4ln3nW/eTkIX734o+dfUtKi
	 XxO/7Tml00ErkByHb6KTIWH1Jd7Js27exd8+7i24x8tUmJL3e4As9mZVM6IOL41ebl
	 C+mh9tAxZey1sfGBnGiohy9ovGbeqSZih1PTSJn68Dwf9Z8bAYl4Ms2/iVKoE65Thu
	 unEaNCquJXJAw==
Received: by pali.im (Postfix)
	id 07B9E81A; Tue,  4 Mar 2025 21:37:42 +0100 (CET)
Date: Tue, 4 Mar 2025 21:37:42 +0100
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <smfrench@gmail.com>
Cc: Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
	Tom Talpey <tom@talpey.com>
Subject: Re: [PATCH 0/4] cifs: Handle all name surrogate reparse points
Message-ID: <20250304203742.pcrx3ppkxc6dab4c@pali>
References: <20241222145845.23801-1-pali@kernel.org>
 <20250223222306.plgy3bpy5mjojfve@pali>
 <CAH2r5mv_+ZarrSPEhDjgEYPzqkvdqL-K7NjDsE0sXtrhx65G7A@mail.gmail.com>
 <20250302122446.dpqd6hlpfmy3fo3l@pali>
 <CAH2r5muzB=R2TA2-=XM3juVD1dhic=Wb_JYu71LYr9YyS5cXKA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH2r5muzB=R2TA2-=XM3juVD1dhic=Wb_JYu71LYr9YyS5cXKA@mail.gmail.com>
User-Agent: NeoMutt/20180716

On Sunday 02 March 2025 19:01:00 Steve French wrote:
> On Sun, Mar 2, 2025 at 6:25 AM Pali Rohár <pali@kernel.org> wrote:
> >
> > On Sunday 23 February 2025 18:48:50 Steve French wrote:
> > > On Sun, Feb 23, 2025 at 4:23 PM Pali Rohár <pali@kernel.org> wrote:
> > > >
> > > > Hello Steve, I see that you have merged first two changes (1/4 and 2/4)
> > > > from this patch series, but the remaining (3/4 and 4/4). Is there any
> > > > reason why 3/4 and 4/4 was not taken?
> > >
> > > Mainly because I wasn't able to easily test it, and didn't get test
> > > feedback for anyone else
> > > on those two who had tried it.
> > >
> > > I am ok with looking at them again - and thx for rebasing.
> >
> > Ok, when you have a time, please look at them.
> >
> > > There are some of the 41 patches in your updated cifs branch that do look suitable or rc5
> >
> > There is "cifs: Change translation of STATUS_DELETE_PENDING to -EBUSY"
> > which stops returning -ENOENT for directory entry which still exists.
> 
> IIRC - there were some objections to this if it could break any
> plausible existing application behavior, but will need to dig into the
> thread from earlier.
> 
> Tom or Paulo,
> Do you remember if this is one that you had mentioned?

I have not figured out any regression for the
STATUS_DELETE_PENDING/EBUSY change.

If you have some scenario or other test case for it then please let me
know what can be wrong here.

I think that it should not cause any regression because applications on
ENOENT error cannot expect that the dir entry still existing.
