Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46E131FCFF1
	for <linux-cifs@vger.kernel.org>; Wed,  5 Feb 2025 18:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738780400; cv=none; b=AYVPvQl2zC7/I8/mSfi34Tw9ZjaG8zwne9A1TYcRYAW4UETosemzGT+z+SSzoIJhjmdp/29H/+fT1dXV9+km8fefHdksDR2PxW4WNmcj5eoTrf1S33YZ3/JOrvYQ4Lgp+WvaTz91h1Yh5meRQkpEbG28C9i3uj0q9/7SbJjoEAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738780400; c=relaxed/simple;
	bh=GLUtedPRZ58rpn6XhYW0MsMRwJSgfBhXzrJdZ/YEae0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=alqIW/mEFRpuWNSr/wnvfJX6aRVW789cCz/HOohVzf5gZs1yu+od7A+h/1CX/vRTE7SnI4MEfmjjecZd1l17JZlueEYLyzAeAOcr6Uh1LVyzkNnPpo2B5IkICRnJVc7EpirCirkOOXu3DnNmJmsM2uHwP+LpzoFWohI9q8AeqZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O78bqcDN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O78bqcDN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87ADAC4CED1;
	Wed,  5 Feb 2025 18:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738780399;
	bh=GLUtedPRZ58rpn6XhYW0MsMRwJSgfBhXzrJdZ/YEae0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=O78bqcDNXVvAY7Eeblcal6ktF9Vf0pfFA9uGjHmyUJ2vCXubz+IleHVwiCuRGB5Cv
	 1xAmUsQbssLm6KrL3oZ0DaMocH04aREmmWcaW+i6mDXmitRkfrkHrwV7msJeUriWp1
	 mjD7SlPE67qjwNGxtWYZP6iffFfU9+D6FQ44LgMkhfXLWkdXWcx8F2A4QuqGtlyjQl
	 jWyzUDn3tU7/H83iYRsrzQkAhEXDS5UJ+UW6naqStUNagZFxLS46GvrtpMB68mdpVv
	 ZscchBuDNInJ+9wGFs74nIms+M+vGwZLkLF98fLX3iTBU01tQpmP0zpdHbV5ofXtGj
	 0ZDzdZaNAVWBA==
Received: by pali.im (Postfix)
	id 92F5E4FC; Wed,  5 Feb 2025 19:33:07 +0100 (CET)
Date: Wed, 5 Feb 2025 19:33:07 +0100
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <smfrench@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH 13/43] cifs: Treat unhandled directory name surrogate
 reparse points as mount directory nodes
Message-ID: <20250205183307.dlptuicid7vt4drq@pali>
References: <CAH2r5mt15YNyLuvJGnUaMb3SU5-zZdak+k9Dx6an3aLqBY4XUg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH2r5mt15YNyLuvJGnUaMb3SU5-zZdak+k9Dx6an3aLqBY4XUg@mail.gmail.com>
User-Agent: NeoMutt/20180716

Hello, I sent this patch as part of this series to the list:
https://lore.kernel.org/linux-cifs/20241222145845.23801-1-pali@kernel.org/t/#u
In cover letter is some information.

Linux SMB client already handles support for IO_REPARSE_TAG_MOUNT_POINT
which is just one example of name surrogate point.

This patch just generalize support for all name surrogate reparse point
without need to explicitly list all of reparse point of that type.

The easiest way how to create name surrogate reparse point is to use
mklink.exe to create directory junction point, which uses the
IO_REPARSE_TAG_MOUNT_POINT.

On Windows server create directory C:\dir and then in exported SMB share
directory just call:

mklink /j entry C:\dir

This will create directory junction point named "entry" which redirects
to the C:\dir when SMB client try to access "entry" directory.

Note that symlink is _not_ name surrogate point, even it is reparse
point. But junction point and mount point are name surrogate points.

On Tuesday 04 February 2025 18:06:41 Steve French wrote:
> Do you have a repro scenario (an easy way to create the surrogate
> directory type you mention) to test your patch below
> 
> 
> 
> If the reparse point was not handled (indicated by the -EOPNOTSUPP from
> ops->parse_reparse_point() call) but reparse tag is of type name surrogate
> directory type, then treat is as a new mount point.
> 
> Name surrogate reparse point represents another named entity in the system.
> 
> From SMB client point of view, this another entity is resolved on the SMB
> server, and server serves its content automatically. Therefore from Linux
> client point of view, this name surrogate reparse point of directory type
> crosses mount point.
> 
> Signed-off-by: Pali Rohár <pali@kernel.org>
> 
> 
> -- 
> Thanks,
> 
> Steve
