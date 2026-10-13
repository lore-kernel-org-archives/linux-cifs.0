Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9219D13B58C;
	Tue, 13 Oct 2026 08:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791879104; cv=none; b=Zu+qkA0Wk/cJPmL/w/GNyXGXKnnOXj4s/uSZNTABDwh2qer/rlrT1XdxqkH1GKfgfQAL+kXbBjSvRm4+1uInwuzM/pQzAzznvHQwyCTs2iICbIYW+IQio9WBB83Sx4PnVk9KZUfPjUMBB2zdwTHpmrbAu7Ij0dvu6oOQ7MjKGk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791879104; c=relaxed/simple;
	bh=XoCwIXHKXW+tfFtNLDwQeZdZAWUkAGIKEYsQXC1DUuk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fhlVgwEJ56+PsJBJGpnrR+Iui2I2aajfCuBOuc9UOQk8OEU25AcbRuMuKBEjt9+j7o85272hNDd1M6wiPNxMrPtIOnhLFDimcemQyMtwlMtiGib1qdcEvxzHhWOB76aT7qbRJic4i7qcPC8aafbrgwmErTLhRwv1uhEKh26Ajd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MEsmCjtD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MEsmCjtD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14F131F000FF;
	Tue, 13 Oct 2026 08:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791879103;
	bh=rG5/bOFUh4a/oPwdbz1FLyL4WUfF1x7/+mhBG8QG764=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MEsmCjtDefv61voXiqbbGM9dW6xGdCpybixzopYSRpNR0CoU5po41/oDFJ26YBJJ9
	 FhkxJiF2zs16HOLMj6w99Kp9NEjHWhksaepW8pAtfhlX6L/pvM8D1w4WY441P9YbCe
	 thfnGHFdXLvjr11eCOXyBUpaIvkjcYsRC8XeqRsSk/vwS2I2FunlBT5JficDQkPFHh
	 7Vp026iInXMNHU/jqKF6NW9ONWTqu1jP6cmqyQQ/HgbuKkXka3eEwDWHaYmME+6+8T
	 8rnt8Z3H8ZDMNaUdsBRtqOhBOAUmDOUqKIxvOw/9grZKixbIGil0KV5VwqJ3sVxLot
	 PKwMx0XsSzOrg==
Received: by pali.im (Postfix)
	id 082F9365; Tue, 13 Oct 2026 10:11:46 +0200 (CEST)
Date: Tue, 13 Oct 2026 10:11:45 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Paulo Alcantara <pc@manguebit.org>, linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/9] Various changes
Message-ID: <20261013081145.fel4juluk55wbfcy@pali>
References: <20260821214722.q7rkflclyyugdxll@pali>
 <20260825230622.24617-1-pali@kernel.org>
 <20261012141053.4ud5pihrtrxpkxfy@pali>
 <CAKYAXd_FP7F1U_ETWx+0QKwpDuEFp=UJzhMjrSmuT9uG3nAxEA@mail.gmail.com>
 <20261013065503.rndxu2qxauehudil@pali>
 <CAKYAXd90dbd9p8uh3nyT_e=gr=P9qQeJd5TE0=+K4+gV2-JG8w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKYAXd90dbd9p8uh3nyT_e=gr=P9qQeJd5TE0=+K4+gV2-JG8w@mail.gmail.com>
User-Agent: NeoMutt/20180716

On Tuesday 13 October 2026 16:56:30 Namjae Jeon wrote:
> > PATCH 8/9 comment 1 - unbound memory allocation based on symlink length
> > - this is valid, but unfortunately all the symlink parsing code would do
> > similar thing. And we have already more symlink types. Do we have some
> > limit how long could be symlink? Does it make sense to address only this
> > one issue and let all other untouched? I would rather propose to define
> > one common limit and fix this issue on all places.
> I agree that a common limit is preferable. cifs.ko already has
> REPARSE_SYM_PATH_MAX(4060) for native reparse symlinks.

Lets this for followup change.

> >
> > PATCH 8/9 comment 2 - fid.netfid initialization - I'm not sure here.
> > I had an impression that this is a right pattern how to open and read
> > file. Can somebody else recheck this?
> For smb2, open() sets persistent_fid and volatile_fid, but not netfid.
> Therefore, .netfid = fid.netfid reads an uninitialized value.
> smb2_sync_read() uses the persistent and volatile IDs instead, so the
> .netfid initializer is unnecessary and should be removed in PATCH 8/9.

Ok. So this would be also simple change to just remove .netfid setting.

> +               io_parms = (struct cifs_io_parms) {
> +                       .netfid = fid.netfid,
> 
> >
> > PATCH 9/9 - masking sync_write error by -EI - This looks to be valid.
> > The fix is simple, just adding "rc &&" before "bytes_written !=".
> Okay. Thanks.

So just these two simple fixups are from the sashiko review, right?
