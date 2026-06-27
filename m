Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF882F1FFC
	for <linux-cifs@vger.kernel.org>; Sat, 27 Jun 2026 23:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782602203; cv=none; b=VWLM2H+Z7ZydMz1tAJVph/5tv6WWALO0MCf4nIGhHQETxFKUraAJORPyo669B7rNVcZa/6M0s+IDlnDXhSHc8OAiAw/2yv7SncvuxbuehOUEPOsuQv6SrIG9VK7PKts2XOgBjesbQSaVyrKg6K61mc6ikFxT4+FL6/q+mw9DQBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782602203; c=relaxed/simple;
	bh=OAxm1lbfCiBouvCPWGJrDpEz0M9lA/sEYsPqplOqDJ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hkt7e+8d5H8BvoAGtQFoZiEUwxR6t1zPPCiU/TJpnDALbV2CSVuQLpPSk7vA80xSuddYJXD9Ki9TRxxl0uavfsewGEip0ULJHeB0Mjd+/zbr6J7nA3ljXpp1raaHnEVG5NtV1uOBS2Xy10PwjDVVKWg8LlZ5xJR/fOJlnFxaixA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eXXDtz98; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eXXDtz98"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 078751F000E9;
	Sat, 27 Jun 2026 23:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782602202;
	bh=bxArA/Zr9+UQ1qCLl1rqUxo8BITxWnwhKW1j468In/w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eXXDtz98K1D8AtmdbFOKjcqp6pvSM96e+yi1kumxm10fburZ7oD7tAOeHlvYQPZot
	 GRtsUnMbAMAxqfXiTOe8xbF9sms7B7DAoaJXWi1MWjY3YJy4Dgz49T+j7Hhoii/L8N
	 ZKdLbdAKQZPhw3k3lTleS/xXxbGaV6VKFiacjk7o0wftrDXkiv6596j18qMnd+eVBD
	 pu9Pp6MdG8gNsXwxyoCsvic5P/gxkkBc62S4qvBAqOWMyGM5/2WD7QJY9HYuLs/f9C
	 CfWEO3S2Jt3H5FhHc66twJ3bAfbeI4Bi/H3w4WGrGbig4ydcmaGhoBW1MMSqyZecDY
	 r9vR4JLxvMECA==
Received: by pali.im (Postfix)
	id E7374AFA; Sun, 28 Jun 2026 01:16:38 +0200 (CEST)
Date: Sun, 28 Jun 2026 01:16:38 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <smfrench@gmail.com>
Cc: Ralph Boehme <slow@samba.org>, Paulo Alcantara <pc@manguebit.org>,
	Max-Ulrich Farber <m.u.farber@freenet.de>,
	linux-cifs@vger.kernel.org, Jeremy Allison <jra@samba.org>
Subject: Re: BUG: SMB3.11 POSIX extensions: Absolute symlinks lose leading
 slash on creation
Message-ID: <20260627231638.pbjmqnfxg6wbrlls@pali>
References: <4a88b87d-c38d-4248-a3c3-59dd8c1f5095@freenet.de>
 <33ca19f8-6c6e-4738-bfab-25e70f77dcf3@samba.org>
 <077744e0-ffa3-4ab6-90cc-855fc7adbba3@samba.org>
 <CAH2r5mseoZJwfwyUUB43OBq5uEuxBVApHw_B9wizrQ50ncpnOQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH2r5mseoZJwfwyUUB43OBq5uEuxBVApHw_B9wizrQ50ncpnOQ@mail.gmail.com>
User-Agent: NeoMutt/20180716

Can you give a full context of the issue/bug? Link would be enough.
I just did not caught from this description what is the issue.

On Saturday 27 June 2026 18:14:07 Steve French wrote:
> Yes - I have verified that it is the client code (so copying Paulo and
> Pali who did most of this code) that has the bug.   When the
> FSCTL_SET_REPARSE_POINT is sent by the client, the leading '/' is
> already stripped off.  This affects both reparse=nfs (default)
> and reparse=wsl.    I would recommend mounting instead with
> "mfsymlinks" (which is safer for most cases as well since the
> symlinks are not processed by the server for the "mfsymlinks" case).
> 
> Paulo and Pali,
> Any ideas about this bug with absolute pathnames in symlinks being
> broken with reparse points by stripping off the leading slash?
> 
> On Fri, Jun 26, 2026 at 1:15 PM Ralph Boehme <slow@samba.org> wrote:
> >
> > On 6/26/26 7:41 PM, Ralph Boehme wrote:
> > > Now that we store as empty file + xattr on the server, not real
> > > symlinks, this design decision might need to be revisited.
> > >
> > > I don't remember of the top of my head if this behaviour is implemented
> > > in the client or the server. Does anyone remember? I'd have to check.
> >
> > it's the client: in cifs_convert_path_to_utf16() it strips the leading
> > slash for the symlink target when called from create_native_symlink().
> >
> > As symlinks in SMB3 POSIX may be created any way the server thinks is
> > safe (Samba does file+xattr, it never creates real symlinks on the
> > server), so symlinks are just a client side thing and we should allow
> > creating absolute symlinks. POSIX allows it (and users use it), so we
> > should (safely) also allow it in SMB3 POSIX.
> 
> 
> 
> -- 
> Thanks,
> 
> Steve
