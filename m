Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 777FF3074AA;
	Tue, 14 Oct 2025 03:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760413444; cv=none; b=VZ6QgcbzhWwIykeEX08CreoytY7BpN39CEjvTNKXEA/XQjJ1nVOtQOp1I5xsOveJzejvrtGwlWpH3OSJ01hUuhuOebiFnMfYa0NRcWcagNF0KVYozMf2dlVU4un4IqY5V9UMZwved77885IuaSnZU0EOHe74OHwluvtBOBF6FWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760413444; c=relaxed/simple;
	bh=0K0PAhJTgGRJZpANDPQ3DTTkASQZRCvWyFV/+A4yDLM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AVKe4t6SPKc4ufsSdF6K0kGz/K6cWCYRRS/ELY3YwFq3Gz+VPHngWi66CCDd1Iuz4gI3f/aiI1Ul8AXwSr7KPMPBotd8CYg+SYHdSqeJNaSO4SH/mnCKYA2SeLqfX9kEbLs4Mz1WTzfe+siy4QWVXoG5kl5v36vHsRvoe1JqDiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BPwgeD1H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BPwgeD1H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 949FAC4CEE7;
	Tue, 14 Oct 2025 03:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760413442;
	bh=0K0PAhJTgGRJZpANDPQ3DTTkASQZRCvWyFV/+A4yDLM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BPwgeD1HDTROX5aKEg63a5DmGmvi8K8xQ6+LHv8i47138uiJ72iRYzHcb1llwA1ci
	 S+7X7yHjCDreI4TmR+2OA5+oNFctlf5hwbtwbvtyVoeFlwLl4Kc6VpkyE8Yzv7/xnr
	 lZSpS9RflDO8GTop/gE9vl7Io46WppN620iax0TpfX4t+47I72lhqTncqEqlfs2LMA
	 Ho9qNJoM4VdhFDyCZcqJimBis/CXILd/1LcgVWuIipp/vaSrgmrG2SlIegiMZV3A5m
	 yqY6NgghKggo2gvibFzvSffGr8Ein9MvANdWlRg+FGhpOYGztvjYS1souVmQLlOt9I
	 rWBMtaG5RmqXQ==
Date: Mon, 13 Oct 2025 20:42:30 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: linux-cifs@vger.kernel.org, Steve French <sfrench@samba.org>
Cc: samba-technical@lists.samba.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>
Subject: Re: [PATCH 0/8] smb: client: More crypto library conversions
Message-ID: <20251014034230.GC2763@sol>
References: <20251012015738.244315-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251012015738.244315-1-ebiggers@kernel.org>

On Sat, Oct 11, 2025 at 06:57:30PM -0700, Eric Biggers wrote:
> This series converts fs/smb/client/ to access SHA-512, HMAC-SHA256, MD5,
> and HMAC-MD5 using the library APIs instead of crypto_shash.
> 
> This simplifies the code significantly.  It also slightly improves
> performance, as it eliminates unnecessary overhead.
> 
> Tested with Samba with all SMB versions, with mfsymlinks in the mount
> options, 'server min protocol = NT1' and 'server signing = required' in
> smb.conf, and doing a simple file data and symlink verification test.
> That seems to cover all the modified code paths.
> 
> However, with SMB 1.0 I get "CIFS: VFS: SMB signature verification
> returned error = -13", regardless of whether this series is applied or
> not.  Presumably, testing that case requires some other setting I
> couldn't find.
> 
> Regardless, these are straightforward conversions and all the actual
> crypto is exactly the same as before, as far as I can tell.
> 
> Eric Biggers (8):
>   smb: client: Use SHA-512 library for SMB3.1.1 preauth hash
>   smb: client: Use HMAC-SHA256 library for key generation
>   smb: client: Use HMAC-SHA256 library for SMB2 signature calculation
>   smb: client: Use MD5 library for M-F symlink hashing
>   smb: client: Use MD5 library for SMB1 signature calculation
>   smb: client: Use HMAC-MD5 library for NTLMv2
>   smb: client: Remove obsolete crypto_shash allocations
>   smb: client: Consolidate cmac(aes) shash allocation

As requested off-list, here are some (micro)benchmark results for this
series.  The CPU was AMD Ryzen 9 9950X.  The server was Samba running on
localhost.  Message signing was enabled.  A valid username and password
were given in the mount options.  The "Improvement" column is the
percent change in throughput (reciprocal cycles):

           Microbenchmark               Before      After   Improvement
           ==============               ======      =====   ===========

    1. Total cycles spent in             44548      20081      122%
    smb311_update_preauth_hash()
    during SMB 3.1.1 mount
    (4 calls total)

    2. setup_ntlmv2_rsp() cycles         31777      22231       43%

    3. Total cycles spent in             17802      22876      -22%
    generate_key()
    during SMB 3.1.1 mount
    (3 calls total)

    4. Total cycles spent in            205110      87204      135%
    smb2_calc_signature()
    during SMB 2.0 mount
    (26 calls & 3316 bytes total)

    5. Total cycles spent in          22689767   21043125        8%
    smb2_calc_signature()
    reading 10MB file using SMB 2.0
    (316 calls & 10031077 bytes total)

    6. Total cycles spent in             56803      37840       50%
    cifs_calc_signature()
    during SMB 1.0 mount
    (18 calls & 1551 bytes total)

    7. Total cycles spent in          52669066   51974573        1%
    cifs_calc_signature()
    reading 10MB file using SMB 1.0
    (336 calls & 10021426 bytes total)

    8. parse_mf_symlink() cycles          7654       4902       56%

Note: case 3 regressed because the "cmac(aes)" allocation moved from
smb311_update_preauth_hash (case 1) to generate_key (case 3).  Excluding
that allocation, generate_key got faster.  Likewise, the sum of cases 1,
2, and 3 (which all occurred at mount time) got faster.

There was a greater speedup in signature calculation than I expected.
It's probably because many SMB messages are short (especially the ones
exchanged at mount time), and also because the old code allocated new
crypto_shash objects more frequently than I had thought.  The SMB 2.0
code allocated a new "hmac(sha256)" crypto_shash for every other message
signed.  That overhead is all gone after switching to the library.

TLDR: all SMB crypto calculations (SHA-512, HMAC-SHA256, MD5, HMAC-MD5)
affected by this series are faster now.  The library APIs fix the
unnecessary overhead that the traditional crypto API has.  Of course,
it's also a lot easier to use as well.

- Eric
