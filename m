Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A62CA3AEB39;
	Sat, 17 Oct 2026 16:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255692; cv=none; b=RDyHifA+/9lKdw4mxLj/n0/XuVPNvqmKDUGd6vpJKNwN5/B0zC/lP0JkiC3Z5WPLK3FgKfSD7sntDMvcQg73k/JnYBIZ79eOtJMY9eFy6es2H1JMDPjRnwjtBeyxdlU9SfLUrY9PGJITndkjyNmhr6TpMA7I1TCngzisCtejZsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255692; c=relaxed/simple;
	bh=8ojWc86RX7V8u0uM4niVZYCMAyBamLfXR9yv2unm/3k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=glbuKqbCkvbldCtfXYDQ7ahYYhymUve+706Wuqp9p6p1hGAQcNHpn/Hcui5/kO9cwLOZSqC8j/c7EDm6XOtm9/y9iJyAz3i3P3/XeLpL4MwAOdlZAQDdImpHs/9dAcl5cFAsSoPuSIFFyTqCmHXyWd/pnLvi0rWkiHBoRNU+2PE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IkPrACDj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IkPrACDj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F41E81F000C5;
	Sat, 17 Oct 2026 16:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792255690;
	bh=Nb2TFneEUQBgrIZvaGQf8xHlbD1HYhgoQ6QdXlwfvOY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IkPrACDjxdJgNPAjPpovmLwHsZz0OJviQv5H8udzGsksLgQJWSSguJzoqrbFtD/f6
	 /knRlD3+3Tj4gxt+onEhV8L5faPye37WzwqsbieHOPPbHhRrX3WEwRgPNH+WE4t1/9
	 9ZomrFfwFyDYFcBjJIIpfGFqO1Q0fBTd3SA6fNLxsLmuv3S6LRXPPvofosC1tTsDMn
	 xPM2nFAvGQvTEiEGtJgs1wuLAH/W3TsfWiXXoLC21cfFLfpmEHyjSWpbv78rkGqKsb
	 nmHPrUaJCfXSRxYLwDzQBg9/YwGFRNoEl1W1q5FEB/lLPrF3vS7dISGW2GAwBFK8pL
	 RcwZcLrFuPszw==
Date: Sat, 17 Oct 2026 19:48:06 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Paulo Alcantara <pc@manguebit.org>,
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
Subject: Re: [RFC PATCH 1/6] keys: prevent quota overflow and widen quotalen
 and datalen to 32 bits
Message-ID: <atOmxqPNV2r0qFNi@kernel.org>
References: <20261016215326.4110064-1-jarkko@kernel.org>
 <20261016215326.4110064-2-jarkko@kernel.org>
 <20261017052844.GC29318@sol>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261017052844.GC29318@sol>

On Fri, Oct 16, 2026 at 10:28:44PM -0700, Eric Biggers wrote:
> On Sat, Oct 17, 2026 at 12:52:59AM +0300, Jarkko Sakkinen wrote:
> > @@ -245,6 +245,10 @@ struct key *key_alloc(struct key_type *type, const char *desc,
> >  	}
> >  
> >  	desclen = strlen(desc);
> > +	if (desclen >= INT_MAX || type->def_datalen > INT_MAX - desclen - 1) {
> > +		key = ERR_PTR(-EINVAL);
> > +		goto error;
> > +	}
> >  	quotalen = desclen + 1 + type->def_datalen;
> 
> This should be tightened further to 'desclen > U16_MAX', since desclen
> is assigned to a u16 later in the function.

Thanks for the remark. I think you are right and fits to what I've been
working on today.

Cutting hairs perhaps but I have really hard time to comprehend this as
a scoped bug fix.

Today morning I tried different things and what made sense to me is
instead think the bug scope as three separate integer overflows and and
one truncation bug.

The net result is here already:

https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd.git/log/?h=keys-rhashtable

I decided that I retain all fixes as part of the series but eagerly
apply and drop them series of course. Split series would be a mess.
And they are any way part of the staircase from "now" to "then".

> 
> - Eric

Br, Jarkko
