Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EEF320011E
	for <linux-cifs@vger.kernel.org>; Wed, 12 Feb 2025 22:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739398076; cv=none; b=dL0CiLotvbQSqc9iPIcAGnC4UFFxIV1Uct8t6Pi4fCQNjDe7NanW3zWX4dz5i2mrCLlXfutKdN9batix9DM8YXGWqKsZ81Dn/pF7dg+Mxjw0zkZzoHaRE5T5i3HVyYQMP3l4elmIEczpWMVTUF1UueVyNBfZ/oUclKDtDDtRSrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739398076; c=relaxed/simple;
	bh=Trkw+2faCv3bSx6ZZ9bz24PcOjL0cehLh9e4T5K0DJY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d9NhLVgVCAyKSTda5Pxn8U+2W09PYDzb3KvhjQAzgG7hGVz6xZlDWNf1YceGwyaM1tCVuS2vktZWRNyQw/RLHKnZnRBdeD6yTP/ARCCOeXW+qjrF1PSyO4Eqw+RXfik7gKpNqy9k11OooB+oevfnf6LzbaLkGXdAy2yCLj8syH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u2MJS2zz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u2MJS2zz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C081C4CEDF;
	Wed, 12 Feb 2025 22:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739398075;
	bh=Trkw+2faCv3bSx6ZZ9bz24PcOjL0cehLh9e4T5K0DJY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=u2MJS2zzL+ZhpiF/T2jLD0kdQPojXajNuSWlaVixGsYWXmTFY5QLfDI1DSRteJTsj
	 6taRsV0AQGFHcrzOpiNaLxzPETwZ0EcvqYPk5XdoiC4venL3CTb06jtnEowH+cLedj
	 yfwvCN78MZad4YO9LFmake9MjR1lag3TGQDcn6U/twWSe2AJSyIEM3K3EQdLynttW6
	 +VEIa/CC3tYw31BR2tXFehW4Pz8fSXRQfiIel52zR9WEJ8jksY9ZaguorB64ij1Key
	 Xz9876GkcLlMoP+8GxKCj0H+Ql/P2yOiDaUyqKAviTT1iSsBGIio+TU7KzdtY12ELb
	 /AY80zkHR3WxA==
Received: by pali.im (Postfix)
	id 33A3A40E; Wed, 12 Feb 2025 23:07:43 +0100 (CET)
Date: Wed, 12 Feb 2025 23:07:43 +0100
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Paulo Alcantara <pc@manguebit.com>
Cc: Steve French <smfrench@gmail.com>, linux-cifs@vger.kernel.org
Subject: Re: Regression with getcifsacl(1) in v6.14-rc1
Message-ID: <20250212220743.a22f3mizkdcf53vv@pali>
References: <2bdf635d3ebd000480226ee8568c32fb@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2bdf635d3ebd000480226ee8568c32fb@manguebit.com>
User-Agent: NeoMutt/20180716

On Wednesday 12 February 2025 17:49:31 Paulo Alcantara wrote:
> Steve,
> 
> The commit 438e2116d7bd ("cifs: Change translation of
> STATUS_PRIVILEGE_NOT_HELD to -EPERM") regressed getcifsacl(1) because it
> expects -EIO to be returned from getxattr(2) when the client can't read
> system.cifs_ntsd_full attribute and then fall back to system.cifs_acl
> attribute.  Either -EIO or -EPERM is wrong for getxattr(2), but that's a
> different problem, though.
> 
> Reproduced against samba-4.22 server.

That is bad. I can prepare a fix for cifs.ko getxattr syscall to
translate -EPERM to -EIO. This will ensure that getcifsacl will work as
before as it would still see -EIO error.

But as discussed before, we need to distinguish between
privilege/permission error and other generic errors (access/io).
So I think that we need 438e2116d7bd commit.

Based on linux-fsdevel discussion it is a good idea to distinguish
between errors by mapping status codes to appropriate posix errno, and
then updating linux syscall manpages.
