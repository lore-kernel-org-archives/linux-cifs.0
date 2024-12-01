Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7521BD020;
	Sun,  1 Dec 2024 12:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733057268; cv=none; b=OWy8feiaqUPgavN7ulWO5bOy9nE+D3GPUCt98YYidoIdBE+IWsc+3nxwvjCCwPF5OuJzSpKhiEW02K2DHKS6usbojs1g5RSkP+PRr16KR/tHDgWaYQXsyOh90ZPQNUR/WyIb++W6uFaUcz62jUqbpqXLWFf4tm1RzgXTcWLgSpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733057268; c=relaxed/simple;
	bh=oNG1J6iiHx1Zh7pLgt0a9neUb5nqdCPqL7H5X8A86TY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qq5+anz8/zesuF2FMAgRoLY4Lqzx8Tml386rVkB0JG5RXVZ79YUdICcQBx/0fN7v5E5d1j9mWDKSCe59Ig+N9WxJDDQAYRhpAY5howLS+BmYRuueOzi9dQ4Q2qStOECTPxQD7Yyh/fZsH7xE47D52V4eg25gLRIU9moBJADbFdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p86LnZQO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p86LnZQO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77CDBC4CECF;
	Sun,  1 Dec 2024 12:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733057268;
	bh=oNG1J6iiHx1Zh7pLgt0a9neUb5nqdCPqL7H5X8A86TY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=p86LnZQOwvQY7+lJzR5oUX+QPww2wqjq1B8CJiPV838q8CjvSFIgy1+h+SU+P2ntx
	 vUHkuRcCwrQzBsbegZg7L1/ywYwFMAS9XLt6CyXKgoJELTQ+3v6+0dLTI6K/vDwEXj
	 mUk3BjmZADBUZxY41WeeY5enQnTP+pXxAgBWYmxX/Sc56clIxgqsw++xjJQtMB4pYK
	 VdnDV5GmDU+2rHrFYqVU1x4BAqvgFFaS98hjojObV980M53uqCl29wNPOsVBIe4OsH
	 ibhDgLHwk0w7CKGLe+B9mLZFqTMrMzeZ3MiBuOrmRpqXnPaAMHYfHkmiYUPPuQ/pzO
	 zDn0114asW6YA==
Received: by pali.im (Postfix)
	id BDE6675F; Sun,  1 Dec 2024 13:47:39 +0100 (CET)
Date: Sun, 1 Dec 2024 13:47:39 +0100
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Mahmoud Adam <mngyadam@amazon.com>, stfrench@microsoft.com,
	stable@vger.kernel.org, linux-cifs@vger.kernel.org
Subject: Re: [PATCH] cifs: Fix buffer overflow when parsing NFS reparse points
Message-ID: <20241201124739.q7jayq7jgzdxsu2h@pali>
References: <20241122134410.124563-1-mngyadam@amazon.com>
 <20241123122050.23euwjcjsuqwiodx@pali>
 <lrkyqmshny9qt.fsf@dev-dsk-mngyadam-1c-a2602c62.eu-west-1.amazon.com>
 <20241201123735.ssqp4v6q57ygmxt5@pali>
 <2024120156-gating-ogle-c622@gregkh>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2024120156-gating-ogle-c622@gregkh>
User-Agent: NeoMutt/20180716

On Sunday 01 December 2024 13:44:15 Greg KH wrote:
> On Sun, Dec 01, 2024 at 01:37:35PM +0100, Pali Rohár wrote:
> > On Monday 25 November 2024 09:54:02 Mahmoud Adam wrote:
> > > Pali Rohár <pali@kernel.org> writes:
> > > 
> > > > On Friday 22 November 2024 14:44:10 Mahmoud Adam wrote:
> > > >> From: Pali Rohár <pali@kernel.org>
> > > >> 
> > > >> upstream e2a8910af01653c1c268984855629d71fb81f404 commit.
> > > >> 
> > > >> ReparseDataLength is sum of the InodeType size and DataBuffer size.
> > > >> So to get DataBuffer size it is needed to subtract InodeType's size from
> > > >> ReparseDataLength.
> > > >> 
> > > >> Function cifs_strndup_from_utf16() is currentlly accessing buf->DataBuffer
> > > >> at position after the end of the buffer because it does not subtract
> > > >> InodeType size from the length. Fix this problem and correctly subtract
> > > >> variable len.
> > > >> 
> > > >> Member InodeType is present only when reparse buffer is large enough. Check
> > > >> for ReparseDataLength before accessing InodeType to prevent another invalid
> > > >> memory access.
> > > >> 
> > > >> Major and minor rdev values are present also only when reparse buffer is
> > > >> large enough. Check for reparse buffer size before calling reparse_mkdev().
> > > >> 
> > > >> Fixes: d5ecebc4900d ("smb3: Allow query of symlinks stored as reparse points")
> > > >> Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
> > > >> Signed-off-by: Pali Rohár <pali@kernel.org>
> > > >> Signed-off-by: Steve French <stfrench@microsoft.com>
> > > >> [use variable name symlink_buf, the other buf->InodeType accesses are
> > > >> not used in current version so skip]
> > > >> Signed-off-by: Mahmoud Adam <mngyadam@amazon.com>
> > > >> ---
> > > >> This fixes CVE-2024-49996, and applies cleanly on 5.4->6.1, 6.6 and
> > > >> later already has the fix.
> > > >
> > > > Interesting... I have not know that there is CVE number for this issue.
> > > > Have you asked for assigning CVE number? Or was it there before?
> > > >
> > > Nope, It was assigned a CVE here:
> > >  https://lore.kernel.org/all/2024102138-CVE-2024-49996-0d29@gregkh/
> > > 
> > > -MNAdam
> > 
> > I did not know that somebody already assigned it there.
> > It would be nice in future to inform people involved in the change about
> > assigning CVE number for the change.
> 
> We have decided not to do that to prevent spamming
> maintainers/developers with even more things that they just don't want
> to care about.  Remember, we assign about 50 CVEs a week.  If you wish
> to see all CVEs assigned to parts of the kernel that you maintain, just
> subscribe to the cve-announce mailing list or use a tool like `lei` to
> provide a feed of stuff just that you care about.
> 
> thanks,
> 
> greg k-h

Ok, fair enough. I did not know about such high number. It is better
than to really not spam developers about it.

I was just surprised about MNAdam email as CCed me that what happened.
