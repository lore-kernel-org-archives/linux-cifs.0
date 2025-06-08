Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 558F03D81;
	Sun,  8 Jun 2025 22:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749420939; cv=none; b=jWgUyeRsrGGPr1pzLkLLWlPA0FMXPk2FfQIGUWWRZJpnSwfJcdaud0Ei7+tvJzYnTzigp/uvp3Ehxc0v/GL7lqrLjt1jMihQW5Jgl3At9/Sy3H9mZ12tXJUERXl0q4DQwl9a8XluLmKeP2AuZXQ0d9dlh6o0ykW4IRl4urRhzfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749420939; c=relaxed/simple;
	bh=RlzgHUYs5avsIHUIcsUV8CD59RHqtnvBE38hjNyRfEQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IkjT96m6BfnMWjCH7bG0NuimRDRuinnTn4J/CwR8H4MRkosa75qerYEWa8LEe1d5Hj/K4mHJEwSoX2eeIIm8xPVd6bj/13eBE2iA77VK09y1TW+L21IwsjWLSQZ9jD9IT/fpbIzoRLi4aNR/mXuE+nmdB74TFFwnQCuK6r4R+o4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d8shk4F/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d8shk4F/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1C06C4CEEE;
	Sun,  8 Jun 2025 22:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749420938;
	bh=RlzgHUYs5avsIHUIcsUV8CD59RHqtnvBE38hjNyRfEQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=d8shk4F/OZhriFicC3MPvXfLm3paNxPwyDRIdiIpjZgw0eq1yg+LZDqCLb55IEFya
	 zsjddXXPM5VG92YdbkZiLjD8PksN1Rw55+rX0XiyAfxZNQRg/lbC9NlbWS/oHdBRu1
	 P191XykUSrnBRis34tPpAzm+vxysVmf3u73/l3iZoVh2XY9s+iOrl7as7axsBl27MV
	 0Ztyhb50ui2tIeRqQ2RP0VwiN0GHLmyHUW8+D0DAoEbE2WWE2+0mPgvY2WjialJpPF
	 oZsnHmPByKyofmXxetWqH9+tWal/VlRT/g7yFSGOogVssfmZeE0En0/6THNhhqegrl
	 XPx5FFVh8sPWg==
Received: by pali.im (Postfix)
	id 62F9F55E; Mon,  9 Jun 2025 00:15:36 +0200 (CEST)
Date: Mon, 9 Jun 2025 00:15:36 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Paulo Alcantara <pc@manguebit.com>
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] cifs: Fix validation of SMB2_OP_QUERY_WSL_EA
 response size
Message-ID: <20250608221536.fdwxexewsntxs3em@pali>
References: <20250608170119.6813-1-pali@kernel.org>
 <20250608170119.6813-4-pali@kernel.org>
 <1bde0a162a5905828806e0993ba9e524@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1bde0a162a5905828806e0993ba9e524@manguebit.com>
User-Agent: NeoMutt/20180716

On Sunday 08 June 2025 18:49:43 Paulo Alcantara wrote:
> Pali Rohár <pali@kernel.org> writes:
> 
> > Currently the SMB2_OP_QUERY_WSL_EA checks that response buffer has at least
> > size SMB2_WSL_MIN_QUERY_EA_RESP_SIZE and maximally it is
> > SMB2_WSL_MAX_QUERY_EA_RESP_SIZE.
> >
> > Constant SMB2_WSL_MIN_QUERY_EA_RESP_SIZE is defined wrongly because it
> > expects that the there are at least 3 EAs. But WSL subsystem has only one
> > mandatory EA: $LXMOD. So fix the SMB2_WSL_MIN_QUERY_EA_RESP_SIZE to be size
> > of the structure of one EA.
> >
> > Relax also SMB2_WSL_MAX_QUERY_EA_RESP_SIZE, calculate maximum size from the
> > size of the largest EA which is 8 bytes for $LXDEV.
> >
> > This change allows to recognize WSL CHR and BLK reparse points which have
> > only $LXMOD and $LXDEV EAs (no $LXUID or $LXGID). WSL subsystem recognize
> > such reparse points too.
> >
> > Fixes: ea41367b2a60 ("smb: client: introduce SMB2_OP_QUERY_WSL_EA")
> > Signed-off-by: Pali Rohár <pali@kernel.org>
> > ---
> >  fs/smb/client/smb2pdu.h | 19 +++++++++----------
> >  1 file changed, 9 insertions(+), 10 deletions(-)
> 
> If we're querying all those EAs and the file has only $LXMOD, wouldn't
> the server return empty EAs except for $LXMOD?

We are using FILE_FULL_EA_INFORMATION for querying EAs, which means that
always all stored EAs are returned. It is not 4 calls (one by one), but
rather one call to return everything at once.

Windows server in this case returns just one EA in its response: $LXMOD EA.
And SMB2_WSL_MIN_QUERY_EA_RESP_SIZE specifies that at least 3 EAs must
be returned, otherwise check_wsl_eas() throws error and do not try to
parse response.
