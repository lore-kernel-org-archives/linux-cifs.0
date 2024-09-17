Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9EE717A591;
	Tue, 17 Sep 2024 21:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726607233; cv=none; b=e6pQwKe2MaEefmOBidAwE8XyUAjDrDqiiO+2xsbyu+XJpQfh7S5orhjgBqRE3EVGVofctkrRCsxrFg0e6/ZxuXmCNHcy2Ff0X6D3W/xlL8HMfQ+7CAyCMY4v2UTRcF4kR1bgZ6ogHmjgt2Z5vd8KQchjeggDyncmVow1PTmiOXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726607233; c=relaxed/simple;
	bh=7uT1AaVoZkpWkUatDBsp5LuR0h7674QxIfTjTM6bybw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fh+y1fQm7BuXEh5LfNEUYIwUgZ22PnshUdHm8i7I9huf8S8uTT44lO2A8hGR7sGqJPfZHCse0qqQWh7h8QN+7LKyTEJ1LUUU6jZIITBCwOzrq76wESppKqJaSZSmOKJNl10zQ+V8jSp3EZvQSoBTP1Z36FNjwXF32LJbK5BLa3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jd4hfuGH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jd4hfuGH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA560C4CEC5;
	Tue, 17 Sep 2024 21:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726607232;
	bh=7uT1AaVoZkpWkUatDBsp5LuR0h7674QxIfTjTM6bybw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jd4hfuGHxooJEtCIjzF2tF5IVAOp4qLFY4J3RJkpNQsRcwvrXJQMbFkzUa34YBo0F
	 Sh0Rc9oSaptpL6Ydl5/0n4vmLhCMvo60qQgm9FIwA6VWmHmwzv4I6aQVUCtCKfDL8b
	 Nqt8l4G4sc+pv5cd2zq91TA/1H2k/1g81qRcfob6dAWSLxkHLlNop0YWZhb/SYyiWZ
	 L9khGfpbVF2RMnP3LshWmpwwxSBo+ZwTxRSKVKN9oe7RybAPKucBYbEZpliMuAxKGh
	 xzV7SHOylTKyFisflOmjUFNcXkTuXc7T+F7DkxzAYgRWM/WBy48hTl9axsQy3q4r1j
	 PI54vKWJJnA9A==
Received: by pali.im (Postfix)
	id BE4F17BA; Tue, 17 Sep 2024 23:07:07 +0200 (CEST)
Date: Tue, 17 Sep 2024 23:07:07 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Paulo Alcantara <pc@manguebit.com>
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cifs: Fix getting reparse points from server without WSL
 support
Message-ID: <20240917210707.4lt4obty7wlmm42j@pali>
References: <20240913200204.10660-1-pali@kernel.org>
 <20240913201041.cwueaflcxhewnvwj@pali>
 <73552a5120ff0a49a5e046a08c6c57f4@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <73552a5120ff0a49a5e046a08c6c57f4@manguebit.com>
User-Agent: NeoMutt/20180716

On Tuesday 17 September 2024 18:04:37 Paulo Alcantara wrote:
> Pali Rohár <pali@kernel.org> writes:
> 
> > Paulo, please look at this patch as it is related to WSL attributes
> > which you introduced in the mentioned commit. I think that the proper
> > fix should be to change SMB2_OP_QUERY_WSL_EA code to not trigger that
> > -EOPNOTSUPP error which is delivered to userspace. I just checked that
> > this my patch works fine for Native NTFS symlinks and NFS-style reparse
> > point special files.
> 
> Thanks for the patch.  The problem is that the client is considering
> that the entire compound request failed when the server doesn't support
> EA.  The client should still parse the rest of the response that
> contains the getinfo and get reparse info data.

I agree with you. This sounds like the best option.

Would you be able to fix the client code to do this?
