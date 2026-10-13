Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6304E37A83D;
	Tue, 13 Oct 2026 06:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791874502; cv=none; b=T9Z8g3SDCtc+ZwP1Qb/zVOy+Vuk8e28RAlvtkNcwqY1K7NYWXmcnhWqsYf8enGUypv94rEexivaf8R4LQVYd//ZAs9ikYgLxtLBDZ7j1t2LrepHKJT7mURR1D3aVKm43E8zk7p5sj4UXM4q0ALQ6gCDVmVD1wjBLH5PFjU8ZjA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791874502; c=relaxed/simple;
	bh=hRoYxsfBsowU+NotN/1uUOF5kLjHwlMbQURl+BUL6W4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VdJxo2fInMXSd7OiX0R1NVl/m76OW0iRl8CoZ8svvrkW/Umq+t0HRtj6FRXjcE0pF+Fjv0nepgJReLxEwgKBsymzxnGnG2TrTHrUyEutWftaGfFfFv+B9amTkWz510bslrH4gXypfgVR86+Bn4/9jIrgJwtNTzDA7TkvUH986t8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jaorVEKc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jaorVEKc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21A281F000FF;
	Tue, 13 Oct 2026 06:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791874501;
	bh=DYAbOYWC8XUm/vdalOehKI/pNO5n7negRX/AHRNbpNU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jaorVEKcOwxh0iHjhm7fFRvF+N+LSRKTEi2AcRkGR4fGK7v375G340S6Y06cftdzz
	 sP6/qGpTYWel/0flaXci7Mfd2t4kYM0uxSuUFO8N5G11Fmdjs65wSjo262iMrF9hU8
	 ilt35Rqe9a7Wb/IqLXsFktDPywStKJSGGofMXl/9tffhHmV33TaErvsbWmU8HyCFx+
	 lRXV7xuV3Gv0ocrKHYkBH6OLkVWlUlXvmR8BbBT5bMUWxbvpigUE2XIlAiBjMtqjiI
	 wU5DvSkElmE6DQxEyvIeqPdT/zICo5+Skgxy0hx8IHXrSZmjdRj7a2SME3tntqk9g2
	 nPqP23wWzMCAg==
Received: by pali.im (Postfix)
	id 05F52365; Tue, 13 Oct 2026 08:55:03 +0200 (CEST)
Date: Tue, 13 Oct 2026 08:55:03 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Paulo Alcantara <pc@manguebit.org>, linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/9] Various changes
Message-ID: <20261013065503.rndxu2qxauehudil@pali>
References: <20260821214722.q7rkflclyyugdxll@pali>
 <20260825230622.24617-1-pali@kernel.org>
 <20261012141053.4ud5pihrtrxpkxfy@pali>
 <CAKYAXd_FP7F1U_ETWx+0QKwpDuEFp=UJzhMjrSmuT9uG3nAxEA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKYAXd_FP7F1U_ETWx+0QKwpDuEFp=UJzhMjrSmuT9uG3nAxEA@mail.gmail.com>
User-Agent: NeoMutt/20180716

On Tuesday 13 October 2026 14:25:34 Namjae Jeon wrote:
> On Mon, Oct 12, 2026 at 11:10 PM Pali Rohár <pali@kernel.org> wrote:
> >
> Hi Pali,
> > Hello, now when is the -rc7 cycle, could you review these patches?
> > So if there are any issues, I would have a chance to address them for
> > the next merge window.
> Could you check sashiko's review comments from these patches ?
> 
> https://sashiko.dev/#/patchset/20260825230622.24617-1-pali%40kernel.org
> 
> Thanks!

Sure, I did not know that there is already review from machine. I have
not received any email about it.

I have checked those comments and here is what I think about it:

PATCH 1/9 is removal of dead code and sashiko found just pre-existing
issue which seems to be not related to this patch.

PATCH 2/9 comment 1 - here sashiko things that the code for serverino
disable should not be called. I think that this is wrong. If cifs.ko
detects that the inode number cannot retrieved then it must disable
serverino otherwise cifs.ko start reporting duplicate inode numbers to
userspace.  I think that in the current situation it must already happen
(from different code path), so I do not think this is valid point.

PATCH 2/9 comment 2 - this is preexisting issue

PATCH 4/9 - preexisting issue

PATCH 7/9 comment 1 - this is not a problem, non-WSL clients (therefore
also Linux one) do not need that EA for working correctly. Also
userspace application cannot see a special EA from userspace and even if
it is able to retrieve it (e.g. via separate own userspace smb client on
separate connection), this is basically a race condition in the smb
protocol itself like any other which requires multiple requests to
finish one filesystem call.

PATCH 7/9 comment 2 - this is preexisting issue

PATCH 8/9 comment 1 - unbound memory allocation based on symlink length
- this is valid, but unfortunately all the symlink parsing code would do
similar thing. And we have already more symlink types. Do we have some
limit how long could be symlink? Does it make sense to address only this
one issue and let all other untouched? I would rather propose to define
one common limit and fix this issue on all places.

PATCH 8/9 comment 2 - fid.netfid initialization - I'm not sure here.
I had an impression that this is a right pattern how to open and read
file. Can somebody else recheck this?

PATCH 9/9 - masking sync_write error by -EI - This looks to be valid.
The fix is simple, just adding "rc &&" before "bytes_written !=".
