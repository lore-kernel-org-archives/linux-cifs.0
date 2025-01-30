Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77ABD1482E1
	for <linux-cifs@vger.kernel.org>; Thu, 30 Jan 2025 21:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738271686; cv=none; b=W2yMv3oU+yXcbwphJUiMSMl1yv2/ZsPlTtxPrNqRuVzhgAI0FIPa9N8rvC+vVljoqg/rO9mQrl5bk3qWTzGvnlo/SRP9Ay8vQ1JZJU9O7SXocJ8bsmtn6/wKqW5drxw6R3Y+wbEHZvPeapkWETxsvsrsnEMSr61jeBRotBterFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738271686; c=relaxed/simple;
	bh=IlXMGTMVr99MJ4hRmrB0E9wuUkhVsvl2z6ZsoadlyQM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SUIsu9IqLbjugoqkgqrv0Eb0vzP5yV2kiijbRCQxYxeyUD6oCkDr6rNy4O//Gbe1maHn+h8oE3T9y/CQKSE1C+E3czPe/7qTJ9F7LZdRIxicasOoGWv7DORsiODS9oEsNNdLpQidjXOW0X8kwgHB4yq2h2I2LO0d9mo9ijnstoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FibJJmCs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FibJJmCs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8BC2C4CED2;
	Thu, 30 Jan 2025 21:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738271685;
	bh=IlXMGTMVr99MJ4hRmrB0E9wuUkhVsvl2z6ZsoadlyQM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FibJJmCsXd60GFpkPttsMBBLxG/G+5MNXKOeO23lYvAsJjCPKVIe0VhuXFjQEc9Fj
	 dcdUp4fbLejlGSUqBOyl6I90nyXAolO06MlWDyzEhssSeAHW6WRDQNMhCLWdhdphpI
	 u6dL0z4O3cl2fpSIBbT5XQJqo4aTGOBHNhurqh+XGvQbBdNt8xqP4RdJr5GwBG1HkY
	 /wCbXSksu6MylyWO3AJz0Tvjw//FpqI1GHy1LPW681KFi+/nzE01jjiEkzUUnJ3123
	 XsBzLPMNLANHxHWZDI5QmjvN5KVSLo+AXE9M2F/rezKwX/k2VY13wgs/4UuoWYUZLf
	 OvcT7hIcqUy4A==
Received: by pali.im (Postfix)
	id 1AB70559; Thu, 30 Jan 2025 22:14:34 +0100 (CET)
Date: Thu, 30 Jan 2025 22:14:34 +0100
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <smfrench@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH 18/62] cifs: Check if server supports reparse points
 before using them
Message-ID: <20250130211434.vzplxnuhi5jq3z5c@pali>
References: <CAH2r5muXhrTc_pa-uhB62dOjQDZR5WBzz4NiVFimVQ=oTysekw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH2r5muXhrTc_pa-uhB62dOjQDZR5WBzz4NiVFimVQ=oTysekw@mail.gmail.com>
User-Agent: NeoMutt/20180716

Export FAT32 share (which does not support reparse points) and try to
create symlink, fifo or socket. Compound request will try to create
empty file, attach reparse point to it, and then close it. On FAT32 this
the attach reparse point part will fail and returns error, letting the
empty file created on the disk. Later the code is trying to remove this
empty file, but it is racy as meanwhile other client may open that empty
file and hence block its removal.

So the idea for this is simple: If filesystem share does not support
reaparse points (like FAT32) then do not even try to create reparse
point.

Same applies for older Samba servers on Linux which do not support
reparse point at all.

On Wednesday 29 January 2025 17:39:24 Steve French wrote:
> In the patch below, do you have an example you tried where server
> without reparse point support that left a file/directory around after
> a failed attempt to create FIFO/SYMLINK or other special file via
> reparse point?
> 
> [PATCH 18/62] cifs: Check if server supports reparse points before using them
> 
> Do not attempt to query or create reparse point when server fs does not
> support it. This will prevent creating unusable empty object on the server.
> 
> -- 
> Thanks,
> 
> Steve
