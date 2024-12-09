Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDE0C14E2CC
	for <linux-cifs@vger.kernel.org>; Mon,  9 Dec 2024 19:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733772894; cv=none; b=kc3zgBZI5zjr0awsXMiR7hBqiOWtLl1UFTp+sOrpTs94CKTQ3Lutz0G9Zd+IVtkmpIF0aLRYwNkM7pFB8JB6fJpb0HNo9yI6tW2xtya1rbpjIwsArCmUc8ISSVJQNmS9ABnDqobr/P19QPRyBDHeEcpPUUAmJx7MQ6+4elsr0i0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733772894; c=relaxed/simple;
	bh=G/KBEftQIe2ZLKgEC7KaR0TazY+nkOMKMbgQz4YJSO8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V6FFUSsrFBlNseUESme1ikJKRIoK38R+ku4znvXzr+A4g/cJmphzhY+3zgPIYFHYb1+pUzLRUwQVk+Ql5Ryan98IwI9X+riDLyw9qjBppAEmZ8b4td8wYP886n9PuEcly0CpIsU3fHdbskusT/FhxoSn3jkBApDHXwrLY9BE/SU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ykg25dqy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ykg25dqy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AB05C4CED1;
	Mon,  9 Dec 2024 19:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733772894;
	bh=G/KBEftQIe2ZLKgEC7KaR0TazY+nkOMKMbgQz4YJSO8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ykg25dqyEGmRWUOC23Ja5r/mU6a98+D22RvMYWIWwskfBKTlTxBfZSmJo1Yi+J4kf
	 oE9cGI5mo5rDkxZRkVzhLExLJh4w4j0MsMsBhaSF8b4Xf5sarq5+Acn44FuHaQiv01
	 mQ1zvHtLrvKmcao4tlHQdLjX6G2xKdVHB3jWGtV2AArjhR6eX+TbnkSoNbp5KF/MiS
	 5cXvWznhmomoNT03pMa6sR7+lCIX0z/Amxc7hJOH2GxQKjtRUaXqLcOpLH5iXeVYK3
	 18akgbNHHmYIaMIQHCh65awW5YfUhiNhHN+QpsF3xZTO+5XYx7JrSsopCl5BC/pfhT
	 sBPI5eX7p0Now==
Received: by pali.im (Postfix)
	id 819BD8A0; Mon,  9 Dec 2024 20:34:45 +0100 (CET)
Date: Mon, 9 Dec 2024 20:34:45 +0100
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Paulo Alcantara <pc@manguebit.com>
Cc: Ralph Boehme <slow@samba.org>,
	Steven French <Steven.French@microsoft.com>,
	CIFS <linux-cifs@vger.kernel.org>
Subject: Re: Special files broken against Samba master
Message-ID: <20241209193445.yrcaa7ciqegvs6fz@pali>
References: <458d3314-2010-4271-bb73-bff47e9de358@samba.org>
 <20241209183946.yafga2vixfdx5edu@pali>
 <1098e751d1109d8730254ada7648ae4d@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1098e751d1109d8730254ada7648ae4d@manguebit.com>
User-Agent: NeoMutt/20180716

On Monday 09 December 2024 16:28:08 Paulo Alcantara wrote:
> Pali Rohár <pali@kernel.org> writes:
> 
> > Hello, this patch is incomplete and still does not fix the main problem
> > that SMB2_OP_QUERY_WSL_EA command does not work with any Windows SMB
> > server except the last Windows Server version. On non-recent Windows
> > versions it is not possible to set both EAs and reparse point at the
> > same time and Windows SMB server is returning error when trying to query
> > EAs on file with reparse point.
> 
> No, Ralph's patch has nothing to do with your problem.  SMB3.1.1 POSIX
> will support NFS reparse points with no EAs, so makes sense skipping
> SMB2_OP_QUERY_WSL_EA altogether for posix case.

Ok, so this is just a coincidence that skip was added at the same place.
And I though that it is the same thing (which now I see that is not).

> > Which basically means that it is not possible to query data about the
> > special files from Windows SMB server (except 2022 version).
> >
> > More details are in the email which I wrote in September:
> > https://lore.kernel.org/linux-cifs/20240928140939.vjndryndfngzq7x4@pali/
> >
> > I proposed similar but extended patch which skips asking for EAs based
> > on reparse point:
> > https://lore.kernel.org/linux-cifs/20240913200204.10660-1-pali@kernel.org/
> 
> Yes, that patch looks incorrect and untested.  Can you tell me how is
> @data->reparse.tag supposed to be set, for non-readdir case, if the
> compound request wasn't sent yet?  Have you tried to stat(2) those files
> with your patch?

I need to rethink about it. Basically I already dropped this patch as I
was expecting the proper solution.

> > But it was somehow rejected as the proper solution should be different:
> > https://lore.kernel.org/linux-cifs/20240917210707.4lt4obty7wlmm42j@pali/
> 
> Yes.  Have you sent a patch with the proposed solution yet?

I have not sent, I was not working on it. I was in impression that you
are going to implement the proper solution.
