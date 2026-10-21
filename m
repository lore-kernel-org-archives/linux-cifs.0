Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792602896;
	b=tlCVpRSF7tW28XBQ+wOzbZTbD7vEXTLy3JhajPsGN05VO6Ue3gRjvclOjwEiZ1bOsDxU
	 8rGPxzLnT8fLtwNY5ORFZv7nZuDifVr0f49iYcx8S3dlh71DgzHw1fsOvIa8KFoqJvUtV
	 0AD+Uvz1TYreMBmdsP21eb43beXi/fQHu1dTirNuQ5V3vxgFo3AHFNWk+lLQW1cPoic6e
	 2dvmCo/oEZX5lj6hNn10xJZ/SJxSqlhSwPWq1ErB6LIU8ysKjJnt9d+A0q8UgPuA44yzQ
	 uzgKJT35qklQR0KgduDapRtqj8NTXtDRNeyqo9ELtDnJHSqxI50l5yu1cuINEkTwoTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792602896;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=wpISKsYdIVz9d6bHJMIPHTSQMYCt0PBJlMxAnbCOdTo=;
	b=uKA/YdVleQPPq1bLLst8L1DJl9nnLPY5rMEJTqbh9oCUmZ3rkeWb4X8llVnMX/5J0yGe
	 UpnsxCUqaBvpZ+wSHQesXZ353UM0rJMMm59TIyB+9A0MmyK8BNjKqr0D801eGV5ts4smA
	 P0z9z9Bu5gSVGXdpkcIvtLW1xbjJEyRzgImceueDqNmJrvqnU+Uev+WbWdgJPLFKK+Fz1
	 por3pdNyLmzjtjxQFq4vUBQDIP+OSrRERYRdQJBhK/NvvmJje0hzLqQA2KgxA6rVFprbb
	 MSovMZm74QiuMCYlv4RcLwSgA6rV3qvHlMYQAxxru/6H8ymKggIfpQUcJn86SiehBkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eQbErXQh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 7D6DB606A319;
	Wed, 21 Oct 2026 17:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eQbErXQh
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C731B1F000C3;
	Wed, 21 Oct 2026 17:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792602896;
	bh=wpISKsYdIVz9d6bHJMIPHTSQMYCt0PBJlMxAnbCOdTo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eQbErXQhiLRODpJENOpDjqJ6YNp37xxGTfNHexYZBVCPOGJNDRksQFXXIbS4DwyHv
	 Qy5R2wM+1iEwF0tsRWDPYn7+gZfUW9azhQvIewX6xT5VAd+ms9eaf9oXJcMA0XxyJN
	 Ne6lCfk0CTU/DcA5AO0l+UJljDRvjvhKZSESoFKY6/WPyAbQAb7plgfGftm5sbgWJQ
	 O7/Aez5ARG+qxnNPZfdNGVGsdnlshp0Zpogc5c5QWQSJHqQke5ijvM6q4H69FdSqCT
	 j4D+j69iUO2mWxc/f77QdCXL8ImznhdPn+2zdkz8qFKZlnBOORjpw7z57Z0Hvp853P
	 v4e3U+g3DqJMg==
Date: Wed, 21 Oct 2026 20:14:52 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org,
	stable@vger.kernel.org, Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	"open list:COMMON INTERNET FILE SYSTEM CLIENT (CIFS and SMB3)" <linux-cifs@vger.kernel.org>,
	"moderated list:COMMON INTERNET FILE SYSTEM CLIENT (CIFS and SMB3)" <samba-technical@lists.samba.org>,
	open list <linux-kernel@vger.kernel.org>,
	"open list:SECURITY SUBSYSTEM" <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH v4 1/3] KEYS: Expand key->{datalen,quotalen} to unsigned
 int
Message-ID: <atjzDKHgkufVnMED@kernel.org>
References: <20261020174325.2229448-1-jarkko@kernel.org>
 <20261020174325.2229448-2-jarkko@kernel.org>
 <atfT5WJU_ldjpQOM@kernel.org>
 <20261020214335.GE699485@google.com>
 <atfky30OZQ5vsNVs@kernel.org>
 <20261021170321.GC1879@quark>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261021170321.GC1879@quark>

On Wed, Oct 21, 2026 at 10:03:21AM -0700, Eric Biggers wrote:
> On Wed, Oct 21, 2026 at 01:01:47AM +0300, Jarkko Sakkinen wrote:
> > On Tue, Oct 20, 2026 at 09:43:35PM +0000, Eric Biggers wrote:
> > > On Tue, Oct 20, 2026 at 11:49:41PM +0300, Jarkko Sakkinen wrote:
> > > > For any kernel patches I've missed all Sashiko reviews so far and have
> > > > not taken the feedback into account in anything.
> > > > 
> > > > There is two issues:
> > > > 
> > > > 1. I was not subscribed to linux-security-module. I could be and have
> > > >    been but probably when I've changed my list subscriptions at some
> > > >    point otherwise, I happened not to be.
> > > > 2. Even if I was subscribed to linux-security-module, at least I'd
> > > >    like to get reviews Cc'd that concern my patches or patches
> > > >    sent to me.
> > > > 
> > > > Now that Eric pointed out Sashiko review I was able to look up this
> > > > via web browser:
> > > > 
> > > > https://lore.kernel.org/linux-security-module/20261020174325.2229448-1-jarkko@kernel.org/T/#mccc5900222fdad9d790be343fcec2a32540ed2fb
> > > > 
> > > > This is somewhat inconvenient though that it responds like that, and
> > > > not to the review thread.
> > > > 
> > > > Not actually sure how do you write a Sieve filter that automates
> > > > relevant-to-me Sashiko emails going into some specific folder but
> > > > I'm sure that is somehow possible. I guess I'll start by subscribing
> > > > to linux-security-module.
> > > 
> > > Well, the keyrings mailing list isn't currently opted into Sashiko
> > > monitoring or emails.  linux-security-modules is opted in, but it's set
> > > to have the Sashiko emails go to only that list.  See
> > > https://github.com/sashiko-dev/sashiko/blob/main/projects/linux/mailing_lists.toml
> > > 
> > >     ["linux-security-module@vger.kernel.org"]
> > >     reply_to = ["list"]
> > >     positive_review = "all"
> > > 
> > > (Sashiko defaults to no email, because unfortunately there hasn't yet
> > > been consensus in the kernel community to enable it everywhere yet.)
> > > 
> > > keyrings could be opted in by opening a GitHub pull request that edits
> > > that file.  Let me know if you want me to do it.
> > > 
> > > My preference is what I set the fscrypt and fsverity lists too: enable
> > > monitoring of the list and emails of issues found to everyone (but not
> > > the noisy positive reviews, i.e. "It looks great!"):
> > > 
> > >     ["linux-fscrypt@vger.kernel.org"]
> > >     reply_to = ["author", "list", "recipients"]
> > > 
> > > So for keyrings I suggest we add:
> > > 
> > >     ["keyrings@vger.kernel.org"]
> > >     reply_to = ["author", "list", "recipients"]
> > > 
> > > Do you agree with that?
> > 
> > Yeah, that would help, thanks :-)
> 
> FYI, it's merged now: https://github.com/sashiko-dev/sashiko/pull/719

Thanks, and about wrapper. I tried it and it does not play out 
in practice so no changes to the patch set from my side unless
there is something that needs to be still fixed.

> 
> - Eric

Br, Jarkko
