Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792533711;
	b=uf/4pysLLkNEHkrc82vkLTT7wbVBWRMTCzAMRYhe7fiU26JNFY2Bz54doMTO4KRsOwt1
	 +aNlxw2wsQDLDHxOzoi4CIqoCQaShGYfuCf5Zd1H/csJSu42SwShxM/VUzXTLnSWr4SdY
	 86hKNzGi32PJmZ5n4s6l491ZVF1CxCaRB3p37Rkv5FTx5sNtQXsT2Wo9z3s4EVwmnvv6i
	 lCi4tmio/i01lPhr0O72fJ7tYH4uiEM27xGzmRktOjdBiJYPTMHqSqae1nDqrGiLdrIlp
	 jTPdxcbIKk5u0l9ZXScHiNIwxqtU3INsxhTKHtbbdCqizpoP5gbvsQ4NZSVKlCjFwLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792533711;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=GKl02Y5rb43uuw/yEbBq2UtRSEh7f8tkmfQ/G32NXiA=;
	b=fjZRDdE8KQUwZY4cMpupbva29t6dbqUqpPMNBG6Dy/9hlsIHrSvqHuQql28MB6PVNdN2
	 IpCHq1s1cJ6sLkuOmB/1Dd2GIWvZY0Kd45AhRJhS0ihvqyMYovhXfNs9yOYryYRqv2Ii0
	 w9QuV5GVgnRp2XQcuL1CeOKRsGRaZ/hvb9TlEBX+xlfWK7AcOzfY01zOU0kklakr/hbjs
	 XM+/4z/cW3hPpjfmut5yLiw4KXQd7xpVuC6EBGsmsBJ4SP+NhydVSlzTJEZTu3XndE+qy
	 rhXuvLTBY/pn6mD0nYN4SmQb0/uEKkcBWEjrW0qHyt7vJb7RESMWsZcUbsUfBS0+yDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X9aAIPC9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 317B3606A319;
	Tue, 20 Oct 2026 22:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X9aAIPC9
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 343251F000C9;
	Tue, 20 Oct 2026 22:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792533710;
	bh=GKl02Y5rb43uuw/yEbBq2UtRSEh7f8tkmfQ/G32NXiA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=X9aAIPC9pQTbt8fg+nqcHj/IAhBZFlp2n5G8gTOTHWAg1yB+EHUv3OehhbYc8QO5v
	 ytsRqPBb7E7SFEs5pslbkgOjjUMBGxZMQFabGWLJao1h63wy4sUtIHEDYB3PE58wmS
	 MAfGXMHXJqevlseSEGdHLdfoFyShIFuzBTDMQNFc6zXP9zqSKi3MiUQil8DPWKrnHb
	 6Z874bqWQRsALae7UPzK4dKKn2ufmrkqkWlrqBbe/F429cJnWpfgc1hHg25++bvAzo
	 FyctzJF/FEiZMCrMJoXDzVQPtgNgrO6kisoK8NLBrOi5nzYKoJAWEZeWlF3m8S/MeM
	 eiuvR6a1SfdsQ==
Date: Wed, 21 Oct 2026 01:01:47 +0300
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
Message-ID: <atfky30OZQ5vsNVs@kernel.org>
References: <20261020174325.2229448-1-jarkko@kernel.org>
 <20261020174325.2229448-2-jarkko@kernel.org>
 <atfT5WJU_ldjpQOM@kernel.org>
 <20261020214335.GE699485@google.com>
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
In-Reply-To: <20261020214335.GE699485@google.com>

On Tue, Oct 20, 2026 at 09:43:35PM +0000, Eric Biggers wrote:
> On Tue, Oct 20, 2026 at 11:49:41PM +0300, Jarkko Sakkinen wrote:
> > For any kernel patches I've missed all Sashiko reviews so far and have
> > not taken the feedback into account in anything.
> > 
> > There is two issues:
> > 
> > 1. I was not subscribed to linux-security-module. I could be and have
> >    been but probably when I've changed my list subscriptions at some
> >    point otherwise, I happened not to be.
> > 2. Even if I was subscribed to linux-security-module, at least I'd
> >    like to get reviews Cc'd that concern my patches or patches
> >    sent to me.
> > 
> > Now that Eric pointed out Sashiko review I was able to look up this
> > via web browser:
> > 
> > https://lore.kernel.org/linux-security-module/20261020174325.2229448-1-jarkko@kernel.org/T/#mccc5900222fdad9d790be343fcec2a32540ed2fb
> > 
> > This is somewhat inconvenient though that it responds like that, and
> > not to the review thread.
> > 
> > Not actually sure how do you write a Sieve filter that automates
> > relevant-to-me Sashiko emails going into some specific folder but
> > I'm sure that is somehow possible. I guess I'll start by subscribing
> > to linux-security-module.
> 
> Well, the keyrings mailing list isn't currently opted into Sashiko
> monitoring or emails.  linux-security-modules is opted in, but it's set
> to have the Sashiko emails go to only that list.  See
> https://github.com/sashiko-dev/sashiko/blob/main/projects/linux/mailing_lists.toml
> 
>     ["linux-security-module@vger.kernel.org"]
>     reply_to = ["list"]
>     positive_review = "all"
> 
> (Sashiko defaults to no email, because unfortunately there hasn't yet
> been consensus in the kernel community to enable it everywhere yet.)
> 
> keyrings could be opted in by opening a GitHub pull request that edits
> that file.  Let me know if you want me to do it.
> 
> My preference is what I set the fscrypt and fsverity lists too: enable
> monitoring of the list and emails of issues found to everyone (but not
> the noisy positive reviews, i.e. "It looks great!"):
> 
>     ["linux-fscrypt@vger.kernel.org"]
>     reply_to = ["author", "list", "recipients"]
> 
> So for keyrings I suggest we add:
> 
>     ["keyrings@vger.kernel.org"]
>     reply_to = ["author", "list", "recipients"]
> 
> Do you agree with that?

Yeah, that would help, thanks :-)

> 
> - Eric

Br, Jarkko
