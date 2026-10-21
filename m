Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792602204;
	b=QMaT3cTkldEIawBLSxOpgMrgb962uHIKl+vwMsfVOe7GEx/UfemGUNBnkqbInJUJAfQ6
	 1lWzAx4/1Lo7JjSsEIbx1lcCTYXa76I01YyIodVig6i9p97pqSGo4ZwpiSp9QgZmxG1hz
	 fRGM9gjy4eCQtaLdAUd4dG+MohRBXWGw0ESWIS02hxZTbhBbOCSdhDWCLzKqo1+7q8Mim
	 HIcjM0sfTVP4VTlVzkNQQE8Pc8wzH28q5NppzyxYxZyHIGy6ErKXa6N7We2nsaOxTtvGG
	 xYqmQiaDE7KaIBc+n2oy4bf+VT3fqfC/ypNiEnJiCewTTFtcqlDKd5MMo28fFEJrqHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792602204;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=V9oKbRIgS4pwxVZeeCa88Y3+8XRLveqA5R7QjFJXjVE=;
	b=WE37z3I5H3P7d/5xBDrZfh0EzeQqnHLM60fKZJQ53dk/hJJOrX2GfQK+VHm2/l2RzhNp
	 5Y4gyBMkmliV4Z5nTJMtWIEZQYeBzRjHgggcw5y8sGVu2SwcbmxW8USRSyGtHt6vgUK7A
	 1v1B7EGysZ2Clzxv55XfMdRwiLP7FmpnlYfKJwBaYUAw+fYN8pxpshRsUYymUDEhRyUCv
	 AL7XojZxH7CqyEI68chCJ0iLyKdkVS1m7B7poRFvyGBnuErca+hc2ee0R5yatjwdRZLdw
	 Pm6H8ANjP5QuExcJc90NavRN3FYEzZmZ0W84aBGIDrKGw0971d7LqUpF9l1x02diJ8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ce6277pA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E342606A327;
	Wed, 21 Oct 2026 17:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ce6277pA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1B981F000C1;
	Wed, 21 Oct 2026 17:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792602203;
	bh=V9oKbRIgS4pwxVZeeCa88Y3+8XRLveqA5R7QjFJXjVE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ce6277pAdcGnf1xtHytlSgyb0IX0barbbXBYnMWF5ylVBrx54J5Lj5+0YdYf8RgFJ
	 Hj7SIi9RKXwd5ypKOy0s6cDoGwa9J6i5QBGn1hySXzDZG29PmKhuvAc3NB1Y8AVGPv
	 0sb/8NKf8BMGmDvEYjxkpsbMTmUDOqPc/35ke2aM5827hGf+44EzQz0Z2yQGyp80bU
	 LnjJWnMiKk9HBNCRQFhEHD0ejbn3Dospb88Ff3vGVs84UJbazyzEU+ZVhvfHhyApUE
	 lr57ZjTMPC5JLYWWRE1NvbTsU+DVtxupb7NkhTHclYkFj2qdUiB0a/nKurDv1z0xTY
	 QOdYb1Sm++55w==
Date: Wed, 21 Oct 2026 10:03:21 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Jarkko Sakkinen <jarkko@kernel.org>
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
Message-ID: <20261021170321.GC1879@quark>
References: <20261020174325.2229448-1-jarkko@kernel.org>
 <20261020174325.2229448-2-jarkko@kernel.org>
 <atfT5WJU_ldjpQOM@kernel.org>
 <20261020214335.GE699485@google.com>
 <atfky30OZQ5vsNVs@kernel.org>
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
In-Reply-To: <atfky30OZQ5vsNVs@kernel.org>

On Wed, Oct 21, 2026 at 01:01:47AM +0300, Jarkko Sakkinen wrote:
> On Tue, Oct 20, 2026 at 09:43:35PM +0000, Eric Biggers wrote:
> > On Tue, Oct 20, 2026 at 11:49:41PM +0300, Jarkko Sakkinen wrote:
> > > For any kernel patches I've missed all Sashiko reviews so far and have
> > > not taken the feedback into account in anything.
> > > 
> > > There is two issues:
> > > 
> > > 1. I was not subscribed to linux-security-module. I could be and have
> > >    been but probably when I've changed my list subscriptions at some
> > >    point otherwise, I happened not to be.
> > > 2. Even if I was subscribed to linux-security-module, at least I'd
> > >    like to get reviews Cc'd that concern my patches or patches
> > >    sent to me.
> > > 
> > > Now that Eric pointed out Sashiko review I was able to look up this
> > > via web browser:
> > > 
> > > https://lore.kernel.org/linux-security-module/20261020174325.2229448-1-jarkko@kernel.org/T/#mccc5900222fdad9d790be343fcec2a32540ed2fb
> > > 
> > > This is somewhat inconvenient though that it responds like that, and
> > > not to the review thread.
> > > 
> > > Not actually sure how do you write a Sieve filter that automates
> > > relevant-to-me Sashiko emails going into some specific folder but
> > > I'm sure that is somehow possible. I guess I'll start by subscribing
> > > to linux-security-module.
> > 
> > Well, the keyrings mailing list isn't currently opted into Sashiko
> > monitoring or emails.  linux-security-modules is opted in, but it's set
> > to have the Sashiko emails go to only that list.  See
> > https://github.com/sashiko-dev/sashiko/blob/main/projects/linux/mailing_lists.toml
> > 
> >     ["linux-security-module@vger.kernel.org"]
> >     reply_to = ["list"]
> >     positive_review = "all"
> > 
> > (Sashiko defaults to no email, because unfortunately there hasn't yet
> > been consensus in the kernel community to enable it everywhere yet.)
> > 
> > keyrings could be opted in by opening a GitHub pull request that edits
> > that file.  Let me know if you want me to do it.
> > 
> > My preference is what I set the fscrypt and fsverity lists too: enable
> > monitoring of the list and emails of issues found to everyone (but not
> > the noisy positive reviews, i.e. "It looks great!"):
> > 
> >     ["linux-fscrypt@vger.kernel.org"]
> >     reply_to = ["author", "list", "recipients"]
> > 
> > So for keyrings I suggest we add:
> > 
> >     ["keyrings@vger.kernel.org"]
> >     reply_to = ["author", "list", "recipients"]
> > 
> > Do you agree with that?
> 
> Yeah, that would help, thanks :-)

FYI, it's merged now: https://github.com/sashiko-dev/sashiko/pull/719

- Eric
