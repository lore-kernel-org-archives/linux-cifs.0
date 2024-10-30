Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0289A1BD9F6;
	Wed, 30 Oct 2024 18:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730311442; cv=none; b=bHOc81MvsjQz+7d6H7AkUKQOYtLS84LUm09fpt9sExFWa7MhSc3/7ndK58lEV2SaZO9VNL2yPnPYwq+TzNuG0ijTMR0UByL4oWavfME6JdzKSo3B2YjrmxGVxfpIquA6gg9Vahgxst+XgzumMVOdAAWbeykamhzZjlM5Ei4pgWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730311442; c=relaxed/simple;
	bh=1ujuCik89KZA+F/0Akuxc+0TXH1ObBwAk8w3VBpa7dc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GnM9cFjv5SYiumHkHj6wkUf0CArNVBKw3U/kS32DgY+tKSd3m3OOv0Fe7Mr4SuRWLZkHeoAaU51TXbOLXaqxVcNFGUsnQqMCia/yyk98NtHh1Z4EOnAadvlMGu7plM/8TMHHldaFtMhAo2pGLWiMsq83tWHWK3DbGpDuH1HrZy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UmoHDf9C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UmoHDf9C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60D35C4CECE;
	Wed, 30 Oct 2024 18:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730311441;
	bh=1ujuCik89KZA+F/0Akuxc+0TXH1ObBwAk8w3VBpa7dc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UmoHDf9CuXcQhLEEXmhn8YC3BC4/85A74T2PnUxTXfHmrdkF4VjUWYSkhoKrgBDqZ
	 QJjsWFpIgoWDdgOayjv4wa4tJu4mUUQgZjMsVvTMgK3GU2h0eJQwhtHo0oH/UTMinl
	 GEtkgr7SCDlaNU7mWUaR2Aq7h0pGpVUcrz2yNMDigRDC849zaaz0iFK7vWz0m7I2Qx
	 TOlEtgGIZI+XW7KU85hu+IzdO4MOAO6m/iCclzY3yZ97u8kySAg85sf7++VGjWiSaQ
	 7pfNIU6/9o1Qt9yI+30EsevgnIoYwzSAM+b1CefMvuriq0EfeD4zhgmGGWdjRLo/I/
	 6vvRk+jms5k7g==
Received: by pali.im (Postfix)
	id B44C49D2; Wed, 30 Oct 2024 19:03:53 +0100 (CET)
Date: Wed, 30 Oct 2024 19:03:53 +0100
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Bharath SM <bharathsm.hsk@gmail.com>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] cifs: Change translation of STATUS_DELETE_PENDING to
 -EBUSY
Message-ID: <20241030180353.w75vgf5uxoh3sid3@pali>
References: <20241005154817.20676-1-pali@kernel.org>
 <20241028104229.29736-1-pali@kernel.org>
 <CAGypqWxRv+3q3gXqGtKH+5rb+pPwNrCz-933xOk29eku38qosg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGypqWxRv+3q3gXqGtKH+5rb+pPwNrCz-933xOk29eku38qosg@mail.gmail.com>
User-Agent: NeoMutt/20180716

On Wednesday 30 October 2024 11:06:30 Bharath SM wrote:
> On Mon, Oct 28, 2024 at 4:12 PM Pali Rohár <pali@kernel.org> wrote:
> >
> > STATUS_DELETE_PENDING error is returned when trying to open a file which is
> > in delete pending state. Linux SMB client currently translates this error
> > to -ENOENT. So Linux application trying to open a file which still exists
> > will receive -ENOENT error. This is confusing as -ENONET means that
> > directory entry does not exist.
> >
> > File on SMB server can be in delete pending state for an indefinite long
> > period. Moreover it does not have to final state before the real deleting,
> > as any SMB client who still have opened handle to such file can revert file
> > from delete pending state back to normal state. And therefore client can
> > cancel any scheduled file removal.
> >
> > So change translation of STATUS_DELETE_PENDING error to -EBUSY. -EBUSY is
> > used also for STATUS_SHARING_VIOLATION error which is similar case, when
> > opening a file was disallowed by server due to concurrent usage.
> >
> 
> My worry is that, change in error code mapping might break some
> applications compatibility.

Do you have any specific example in mind where this can happen?

I was thinking about it and I cannot imagine how this change could break
application compatibility. I do not know how can application think that
-ENOENT error from open() or stat() syscall should be handled as file
exists. This is direct contradiction of the -ENOENT meaning.
