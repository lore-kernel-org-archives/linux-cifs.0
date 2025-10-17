Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3795E283FC5;
	Fri, 17 Oct 2025 16:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760718337; cv=none; b=cfECE7djNdHBwTd4lKwFPirZc3KTJRES6ZTKbpQUMYP/vsixFYETl/2d+q/mmdEfxb8GHdEFKipOWi1oJNMIamUJYTud+JuD41CxWvwVl3s+f7gyRAx3fe8KHX+zWbrkPxoExG/OD5d2TYDCrvg6z8aGhC9By/rwbV57JjT1NTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760718337; c=relaxed/simple;
	bh=FGcaQDhcT73GDBoXqQaq/3HS7ybhqg2XqfymHS+1rLY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vBuPfvgFFk8Mok8kAhpwzdUzDozFtg97sl0MxHRRjLll/TDiWLK91+atf1XjFgwZ3cdn+D2E4tJ6WWYmXisNiB3Gqju5edliAJyymW9rZrcOu3P1xR+ly9jmmKJt7PgUC6cWzBWNKRjw1tBud4KxLkZ0QffYKSZwHBJ9e86Yl4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HQEu8Q8V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HQEu8Q8V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A966C4CEFE;
	Fri, 17 Oct 2025 16:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760718336;
	bh=FGcaQDhcT73GDBoXqQaq/3HS7ybhqg2XqfymHS+1rLY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HQEu8Q8VytDnMnLkG+5G1ZN0EzUarenvIIolfoa877Djq5xO63+x47BCHHRo7VTA7
	 gGG6V+ZTxjmml3ntkRUIlpa1u+DkLU9bIKHBMFJGSKyWZebY/9kfJvx1U7G8wKmPFi
	 RzCaEf3bH0foW9ouDXRX9Oxug8jJy6yPk43AzWnOA0NWphkckG7ObitwY79vzYQk07
	 JcCHTDlEqHBOz+6aknWCRxW/hTXGH3qa8yhV3ucCptCyU8Ptc9io3LEZFnZlRk5iVv
	 BDbPIT8Fjldl4K8CKNxdlRJ1nbqgueyuVV13tv7XnsINENGZj6BoMZ/HEL6Stgpy/g
	 1LL7kKHGb/dyg==
Date: Fri, 17 Oct 2025 09:24:03 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org, Steve French <sfrench@samba.org>,
	samba-technical@lists.samba.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>
Subject: Re: [PATCH 0/8] smb: client: More crypto library conversions
Message-ID: <20251017162403.GB1566@sol>
References: <20251012015738.244315-1-ebiggers@kernel.org>
 <20251014034230.GC2763@sol>
 <CAH2r5mtPp6yGFHipzQ6A+6Yi0FZjWZa=T=CrtALc4o6TGqF8EA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH2r5mtPp6yGFHipzQ6A+6Yi0FZjWZa=T=CrtALc4o6TGqF8EA@mail.gmail.com>

On Fri, Oct 17, 2025 at 11:12:58AM -0500, Steve French wrote:
> > with SMB 1.0 I get "CIFS: VFS: SMB signature verification
> > returned error = -13",
> 
> If testing SMB1 to Samba the server disabled signing unless I set
>   "server signing = mandatory"
> in smb.conf.  But with that, signing with your patches worked fine even to SMB1
> 
> Were you testing to Samba with SMB1?

As per my cover letter, these are the settings I used:

    Tested with Samba with all SMB versions, with mfsymlinks in the
    mount options, 'server min protocol = NT1' and 'server signing =
    required' in smb.conf, and doing a simple file data and symlink
    verification test.  That seems to cover all the modified code paths.

This was with Samba 4.23.1.

I just tried 'server signing = mandatory' too (just in case that's
different from "required"), and I still get the error.

Anyway, it's not related to my patchset, as it happens regardless of it.
I also tried some much older kernels, and it still happens there too.

- Eric
