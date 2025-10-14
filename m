Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA14F2BDC3E;
	Tue, 14 Oct 2025 06:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760422150; cv=none; b=XGKtLPg2ifGDHvo6G73izKMf1daeKbXET4LdUKS6tU10wO8YE4sSjDHFxeX/NIkaoaQI36EuMQ25EWx8ioQQdZgUqrQUPF2Hy8QZYj99nqYxDchdictcjLJkIHqkybXq/e/C9nhZbVVvBhyCx8udtsSVxwy2rjKmq4eFvXoQybQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760422150; c=relaxed/simple;
	bh=bw2rjJak5ibp1HP9mzPAfpKK+w4tEZn4HwIaBKC9xNU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hT9CCAKJPc7PAUkaXMwLjCmVtA95AWWgUcSGUcLpycuRXjNsXd8Ex4dks6vUJikjGg+p4Jvj7tTCdRLl62w8/r7kG+Pzj0RhMOgtkfFhrba1SBLFjRNcsPZw1CYAb87j4BjVvKkTFbSlOVs0R8a1KrbXXdoLEF216Rxj0LGTy8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hNQaCvdw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hNQaCvdw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 975BFC4CEE7;
	Tue, 14 Oct 2025 06:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760422149;
	bh=bw2rjJak5ibp1HP9mzPAfpKK+w4tEZn4HwIaBKC9xNU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hNQaCvdw+dAbqIb6yGCfHP2L4Qw8xFoYjYIz/1TFurOmzBOXsypefaakwaDGPwHMi
	 50XVA5+MUxV0cv5yGdqyXhlA98lZ6rhZJCCk7ok07B29cTeqLo4Bbx1GjavR8IJII+
	 Wg+1CCMYmwx8VbfvFT3mzfTP/xvACHDBqEvjJUIE+TvHop0lT1Rd/wNv3SJIXb0TCY
	 u0K1vsubzgub6AOY7ZnOQZq3FgLKETgDJlKbSoluRwj2Am5OvMwghmpUXuBsLL0vja
	 UQ90+u4oPLAysqvj/dLrJ85EaIQ17mf3ocTnyK9yzD+hpgcgz+BApHP81c9gDZgrJq
	 4RuBSN+MzBCQQ==
Date: Mon, 13 Oct 2025 23:07:37 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Enzo Matsumiya <ematsumiya@suse.de>
Cc: linux-cifs@vger.kernel.org, Steve French <sfrench@samba.org>,
	samba-technical@lists.samba.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>
Subject: Re: [PATCH 0/8] smb: client: More crypto library conversions
Message-ID: <20251014060737.GD2763@sol>
References: <20251012015738.244315-1-ebiggers@kernel.org>
 <ihoaj3ymhuesevdb7k2kg2a2axdkishrrrjr2teigelhkxmt4s@do2n6pkdmaas>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ihoaj3ymhuesevdb7k2kg2a2axdkishrrrjr2teigelhkxmt4s@do2n6pkdmaas>

On Mon, Oct 13, 2025 at 11:44:37AM -0300, Enzo Matsumiya wrote:
> Hi Eric,
> 
> On 10/11, Eric Biggers wrote:
> > This series converts fs/smb/client/ to access SHA-512, HMAC-SHA256, MD5,
> > and HMAC-MD5 using the library APIs instead of crypto_shash.
> > 
> > This simplifies the code significantly.  It also slightly improves
> > performance, as it eliminates unnecessary overhead.
> > 
> > Tested with Samba with all SMB versions, with mfsymlinks in the mount
> > options, 'server min protocol = NT1' and 'server signing = required' in
> > smb.conf, and doing a simple file data and symlink verification test.
> > That seems to cover all the modified code paths.
> > 
> > However, with SMB 1.0 I get "CIFS: VFS: SMB signature verification
> > returned error = -13", regardless of whether this series is applied or
> > not.  Presumably, testing that case requires some other setting I
> > couldn't find.
> > 
> > Regardless, these are straightforward conversions and all the actual
> > crypto is exactly the same as before, as far as I can tell.
> 
> I think the overall series looks good and do a great cleanup.
> 
> Just a minor nit about fips_enabled: since it's now being handled
> explicitly (rather than an error on cifs_alloc_hash() currently), I
> think it makes sense to move the check to mount code path when
> 'sectype == NTLMv2' (I don't particularly care about SMB1, but
> something similar can be done for 'smb1 && sign' cases I guess).

For MD5 message signing and NTLMv2, this series keeps the fips_enabled
checks where they were before.  That is, they're inserted where the
calls to cifs_alloc_hash() were before.  I think moving them to earlier
locations is best done in later patches, as it's not obvious (at least
to me) exactly how to do that.

I spent a while reading the code again, and this is what I came up with:

- For MD5 message signing: cifs_enable_signing() is probably the right
  place to disallow it.  However, it's called regardless of the signing
  algorithm.  So it needs a parameter passed in that tells it that the
  signing algorithm will be MD5 (or equivalently the dialect is SMB1).

- For NTLMv2: select_sec() and SMB2_select_sec() are where the
  authentication protocol is selected and are probably the right places
  to disallow NTLMv2 and RawNTLMSSP.  However, those are two places, not
  one.  We'd have to remember to put the fips_enabled check in both.

The nice thing about keeping the fips_enabled checks next to the actual
uses of the algorithms is that it ensures they stay in sync.  So maybe
we should just stay with that here.

- Eric
