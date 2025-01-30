Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00EDC1AF0C8
	for <linux-cifs@vger.kernel.org>; Thu, 30 Jan 2025 21:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738271916; cv=none; b=RGFXlqbd/0q6Dw+lstj9s4azXw5XJo7tXZlultHTgOkFfcpceyGUTYMcqGRKxy6n9OnUMc994mlJXqB0A3BOD8j9Fffi/2O9vIOaO/XqAdG/ju5/Cht+lSujTAlnXUnFdYhfeHLYdhL+b/EcZk7DbgakT11V1FKeKvBxp2xQ1ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738271916; c=relaxed/simple;
	bh=4klZUimzg7AWIJ29uNxC1PJmcoDB9wOczqDusmeM79Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uZue4KbPsyvgx6ML8VwNPp0hOWEyBIhSedwuSejkwDjM/ddx46Sm1HdtiH9bgWvmuxN+IrGkq2XLAtjzx2F0NKDSHhYx7OfxhOY11wz7Oq/m3sEO1iZIO+EdAaP7AXQ1bXR/6wPBGqJcE3PSTz+/oDkQB8Js4avh6JIASDe/pQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cBZszCCa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cBZszCCa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47D05C4CED2;
	Thu, 30 Jan 2025 21:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738271914;
	bh=4klZUimzg7AWIJ29uNxC1PJmcoDB9wOczqDusmeM79Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cBZszCCad2AAbU2XlXFiNydQiP4eWlWv+hpUKkmKAFthC1v/HXCEB0u4E80SkXoFI
	 YU9P7gXZMRL1maR0lkmPuNnkW3/Byeocayf+D7GyE9OkhXS60UMQhNBcNBcHCRewtB
	 GpV8ExycOMMjuE6I5Sf2tqekZLxaEAcYvbGmucuFQeP051/7b9teLO7hhzteB6DwJK
	 seRzOXcjuRyBzP5eZS5A2kD86XeLtBJbDPu5Tpf9Xkzcd3VLB2LISJK/96b4oO/WgT
	 ZJSAPFIysNmMkE38FJ8xFARQcZ3VzcT5sWH4IDA5jTssBs8yf6o1FPM47XmnGUCCTR
	 Iud/aKtFy2mSw==
Received: by pali.im (Postfix)
	id 9114C559; Thu, 30 Jan 2025 22:18:22 +0100 (CET)
Date: Thu, 30 Jan 2025 22:18:22 +0100
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <smfrench@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH 18/62] cifs: Check if server supports reparse points
 before using them
Message-ID: <20250130211822.6swdk5ghckth65up@pali>
References: <CAH2r5muXhrTc_pa-uhB62dOjQDZR5WBzz4NiVFimVQ=oTysekw@mail.gmail.com>
 <CAH2r5mu49ffRd=R7KqWXvXzXysy54obBJ8egrH1fbKbyYbMWGQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH2r5mu49ffRd=R7KqWXvXzXysy54obBJ8egrH1fbKbyYbMWGQ@mail.gmail.com>
User-Agent: NeoMutt/20180716

That is a good point. But question is: are there such broken servers
which do not correctly announce support for reparse points? I was
thinking that such servers would be rather rare or maybe not exist at
all as even Windows SMB client would not work correctly against them for
symlinks and other reparse points. IMHO there are more servers which
either do not support reparse point at all (older Samba servers) or
servers which supports them, but underlying filesystem not (e.g. Windows
SMB server with FAT32 filesystem).

On Wednesday 29 January 2025 18:00:21 Steve French wrote:
>  I was thinking about the possibility that there a servers with bugs
> (ie that support it but don't set the flag right) - so haven't merged
> this one yet - so I want to know how bad end result is if server is
> correctly behaving but doesn't advertise reparse points and you try to
> create one that leaves debris (file/directory).
> 
> On Wed, Jan 29, 2025 at 5:39 PM Steve French <smfrench@gmail.com> wrote:
> >
> > In the patch below, do you have an example you tried where server
> > without reparse point support that left a file/directory around after
> > a failed attempt to create FIFO/SYMLINK or other special file via
> > reparse point?
> >
> > [PATCH 18/62] cifs: Check if server supports reparse points before using them
> >
> > Do not attempt to query or create reparse point when server fs does not
> > support it. This will prevent creating unusable empty object on the server.
> >
> > --
> > Thanks,
> >
> > Steve
> 
> 
> 
> -- 
> Thanks,
> 
> Steve
