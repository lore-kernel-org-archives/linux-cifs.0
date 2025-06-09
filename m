Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F91B2868B;
	Mon,  9 Jun 2025 22:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749509344; cv=none; b=hys/EOQmQshleW8yU/dOKNH4NdcROfncE4W2ar1QACtEi0JY9unsHHF9cJoSwiWc/bIl3Vl2Lo5TYnIA3uxlt6ikF4BVZpiaDZxpvzUb6eaXKx3/xNeVXKlAzsZ07uGoP54ao1h2TYcUUr+OnV8jNrl4bm0jzIDHpoyjhNzEq8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749509344; c=relaxed/simple;
	bh=mfvml8txlEjBQ+hcaKBN5iiZJ9Lm5MZE1rXwYquHDt0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RGRclF7VcJsa/5vQacDDfOgWmsLHxhTKswxzFDhsg6vKRHXuDIAaQu+8XOII+uD20s15WCCxNQuTcuTi4R7W0Bt2jQEVDcI0pscjcBcLSIupukpkmLHtrMsjbn2F20A0UPIIciyySdtDaIUXG9GAnuyZcJLsEgYoWQHEi7LWT6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qpnbM21B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qpnbM21B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DD1BC4CEEB;
	Mon,  9 Jun 2025 22:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749509343;
	bh=mfvml8txlEjBQ+hcaKBN5iiZJ9Lm5MZE1rXwYquHDt0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qpnbM21B+pDx6E+5Ta9AdJTwVXW1DkA3Y3BOZlADIqFnxqYWLbmuHGij7T/5uPaTy
	 /K2Nk1oDReIe1pmB3kEaAOQiF6jVEXi8ZXDAFqiOIPU6dceBwFDDMV/2YHL7kPNplo
	 qBUQW6PpE3Dyz8rq8T7ZuWMGtBxJfmun/mprl2+3h9XZ99kGSDQ1MaAOkToFBX60PO
	 WnKwWpfAyG/rHFufli44FLSz9w/ENkOrQcgY0CIy+9w20VqA9rQUROUV9KgvMqiKKr
	 xJzuEtGNvdYSaF/p0ol0VoGQ/IZ4Z+PNXjnr1ZDxo0u47H30nC35Ualzav9BAX6AWX
	 XI3tt1M9fIPvQ==
Received: by pali.im (Postfix)
	id F2809C75; Tue, 10 Jun 2025 00:49:00 +0200 (CEST)
Date: Tue, 10 Jun 2025 00:49:00 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Paulo Alcantara <pc@manguebit.com>
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] cifs: Fix validation of SMB2_OP_QUERY_WSL_EA
 response size
Message-ID: <20250609224900.zlocskau3pgg4itz@pali>
References: <20250608170119.6813-1-pali@kernel.org>
 <20250608170119.6813-4-pali@kernel.org>
 <1bde0a162a5905828806e0993ba9e524@manguebit.com>
 <20250608221536.fdwxexewsntxs3em@pali>
 <17c70afea9476e5a2ebb0ed37ea780ca@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <17c70afea9476e5a2ebb0ed37ea780ca@manguebit.com>
User-Agent: NeoMutt/20180716

On Sunday 08 June 2025 20:10:24 Paulo Alcantara wrote:
> Pali Rohár <pali@kernel.org> writes:
> 
> > On Sunday 08 June 2025 18:49:43 Paulo Alcantara wrote:
> >> Pali Rohár <pali@kernel.org> writes:
> >> 
> >> If we're querying all those EAs and the file has only $LXMOD, wouldn't
> >> the server return empty EAs except for $LXMOD?
> >
> > We are using FILE_FULL_EA_INFORMATION for querying EAs, which means that
> > always all stored EAs are returned. It is not 4 calls (one by one), but
> > rather one call to return everything at once.
> 
> Yes.
> 
> > Windows server in this case returns just one EA in its response: $LXMOD EA.
> > And SMB2_WSL_MIN_QUERY_EA_RESP_SIZE specifies that at least 3 EAs must
> > be returned, otherwise check_wsl_eas() throws error and do not try to
> > parse response.
> 
> Can you share a trace of the server returning only a single EA in the
> response when we query $LXUID, $LXGID, $LXMOD and $LXDEV?
> 
> What I mean is that we query all those EAs when we find reparse points
> on non-POSIX mounts, and if the file doesn't have them, the server still
> returns the EAs but with a zero smb2_file_full_ea_info::ea_value_len.
> check_wsl_eas() skips the EA when is @vlen zero.

I started recording of tcpdump and I'm not able to reproduce it anymore.
That is stupid. So I started investigation what happened there...

And the result is that I have more changes related to EAs on my disk,
and I did some tests on all of them. And due to bug in dissector of
older wireshark version which I used, I wrongly interpreted the format
of network EA buffer. So based on this I calculated all sizes wrongly
and introduced bug in my WIP code on my disk. So it my mistake here.

So please drop this one "PATCH 3/5". I re-checked the size limits and
they should be correct.
