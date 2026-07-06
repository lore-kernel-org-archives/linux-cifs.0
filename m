Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE4353DBD64;
	Mon,  6 Jul 2026 22:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783377760; cv=none; b=ihbf4DcT3Vhmx7MDq8MG7jRRYGGQJZAUVc/F3ZJXXnk0UHAiZVnNxgHv3jTPhxCj50u2jch/rzk4Ra1+0MRGs6rkt788F2ycUTnMm/hh0jJsjKApiUdJH701xUH5GvWyTvZlqhJJP/AQa2jTn0bgoFcuHntBQCbls8V07Ck8rvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783377760; c=relaxed/simple;
	bh=w0EtWQmOFuGYlOktmZFXRq5uqbKL740wcQ/qAectcG4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j7EnTXKoYk00dqcuC1yo0sbYa/5mp4t8dc6IqI7kqSTfKoVJ2WlxWW6ztV154Izv/IM5TlqCErObTRD8KOmcxoIB7eoTnjPh1Acmc1D1z2oGt2C9eyNLYUNCxZoVfe7OLieYz1AE6bDRMcRJinK0wNZP6FSK9Uha44bB0DcE3qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gPJqbUn/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gPJqbUn/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 383C11F000E9;
	Mon,  6 Jul 2026 22:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783377759;
	bh=xZiKOLbHFoacuaaPtuNj0XifToEMxvblEc8Ej328efs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gPJqbUn/zjuKChD+IymPhILtKmY3I6xHghAGYQxgdTFMeIMCXiZIKCM8MkPw/Rjtf
	 31frK6oJqZozUAKsPpTPy2X1yF+ns7vgJj+8My7C1+u7qUmpKvFrtfzcjutQCw/dSx
	 Z/4yIyFVvuSNNWgH8chRFCtDX5oQlaO/TSEdP5tL0ahZB4ACkctwElq5YvBcQyMqyN
	 F/IO+MWr1lpwz6LM5/zHA2n8m812lSynI/J5Xqnl9b7EZkeTqX1GIwXhwQUo7pVZ8a
	 wPm+yDbuJyXzit5GBEe1XM9Da1aXVCPDiLkJRFZT4rcXva1DvQORQVS0sWwQCow7Uq
	 Yir4z7xIh9u/w==
Received: by pali.im (Postfix)
	id 76CA35D7; Tue,  7 Jul 2026 00:42:36 +0200 (CEST)
Date: Tue, 7 Jul 2026 00:42:36 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <smfrench@gmail.com>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 07/11] cifs: Check if server supports EAs before
 trying to set it for WSL
Message-ID: <20260706224236.4fm5ypvbq3z3fsqi@pali>
References: <20260706184819.22124-1-pali@kernel.org>
 <20260706184819.22124-8-pali@kernel.org>
 <CAH2r5mvHgpVP=CxcBd6iygLzDr5cvvvh9_W7DbxzRJTN6H4FKA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH2r5mvHgpVP=CxcBd6iygLzDr5cvvvh9_W7DbxzRJTN6H4FKA@mail.gmail.com>
User-Agent: NeoMutt/20180716

If the server does not support EAs then setting the EAs (which is part
of the creating WSL special file) would fail and so WSL special file
would not be created. Major and minor numbers of char and block devices
is stored in the EAs and therefore without EAs support, it is not
possible to create and store char and block device nodes.

On Monday 06 July 2026 17:33:42 Steve French wrote:
> If this were purely Linux, without this patch what would happen with
> creating special files if the server didn't support EAs.  Would some
> special files still work?
> 
> On Mon, Jul 6, 2026 at 1:52 PM Pali Rohár <pali@kernel.org> wrote:
> >
> > WSL special files store information into EAs. When EAs are not supported
> > on the server filesystem then fast fail in mknod_wsl() function.
> >
> > Signed-off-by: Pali Rohár <pali@kernel.org>
> > ---
> >  fs/smb/client/reparse.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> >
> > diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
> > index 99e93b56374f..e2ea59a17c9c 100644
> > --- a/fs/smb/client/reparse.c
> > +++ b/fs/smb/client/reparse.c
> > @@ -668,6 +668,13 @@ static int mknod_wsl(unsigned int xid, struct inode *inode,
> >         struct kvec reparse_iov, xattr_iov;
> >         int rc;
> >
> > +       /*
> > +        * WSL special files store information into EAs. When EAs are not
> > +        * supported on the server filesystem then fast fail.
> > +        */
> > +       if (!(le32_to_cpu(tcon->fsAttrInfo.Attributes) & FILE_SUPPORTS_EXTENDED_ATTRIBUTES))
> > +               return -EOPNOTSUPP;
> > +
> >         rc = wsl_set_reparse_buf(&buf, mode, symname, cifs_sb, &reparse_iov);
> >         if (rc)
> >                 return rc;
> > --
> > 2.20.1
> >
> >
> 
> 
> -- 
> Thanks,
> 
> Steve
