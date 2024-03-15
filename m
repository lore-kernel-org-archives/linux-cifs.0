Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E760D26B
	for <linux-cifs@vger.kernel.org>; Fri, 15 Mar 2024 03:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710472016; cv=none; b=EyKyhmbnm/aDDhDmtWB4+K/576cKcpjlKy26ulTyx/ujRcu1C7modkUuGhNUGkUF8eXJtdM1qKB1uy12VaZcZyJ9TgMfCL877UHY+9lcBCS/YX0R7m4iCT0Ie8m4EMyDw2IGZrUE9UNksPpW2KLfedxhWRdgcuFIzHhOXo2+OWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710472016; c=relaxed/simple;
	bh=WK2R8cZiCZIL/ffsPYjIGdI0j1k5SQ2au1hLxW3rYH8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tJilHMVcj+iZezsLr1xIfK9uFpvlnip25d3Mwn3YgECzwnPpO6IAq2EmxRZQf+tCpTNCdSykpu7YOj5UFVWn3GwB1hCSoLw+HzkrVu6UU2Gn+4peE+vP/7r61RAyelDvEOhibWVCyuzcSxHQ6ftJdJ61XAiHbdzL4Q/31YHvlH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wVPWQ1Bv; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wVPWQ1Bv"
Date: Thu, 14 Mar 2024 23:06:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1710472010;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WK2R8cZiCZIL/ffsPYjIGdI0j1k5SQ2au1hLxW3rYH8=;
	b=wVPWQ1BvdNz7lbHD6ad27GzrrEcrUCSnfFTq6dfM9r+YT+AxoxshN+hpAgWjFkX/JJsHgK
	DEa25VSR/oqhpkYrVVUcOc9cZyG31D+JWl3tcXkAEUBM/gpsYnuRo04NllTYet+MWMkthD
	chQAjx3np0X3P5jl93X8/46Zj5WFZGE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Steve French <smfrench@gmail.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	Christian Brauner <brauner@kernel.org>, CIFS <linux-cifs@vger.kernel.org>, 
	Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: Fwd: [GIT PULL] vfs uuid
Message-ID: <2vkro6jmg3ppquufyunnc2wkfsp6ehvdwjocrqoc3h5y2fecei@bxoi2t3dr6z2>
References: <20240308-vfs-uuid-f917b2acae70@brauner>
 <CAH2r5mvXYwLJbKJhAVd34zyDcM4YNM5_n4G-aUNjrjG3VT5KQQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH2r5mvXYwLJbKJhAVd34zyDcM4YNM5_n4G-aUNjrjG3VT5KQQ@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Mar 14, 2024 at 02:55:50PM -0500, Steve French wrote:
> Do you have sample programs for these programs (or even better
> mini-xfstest programs) that we can use to make sure this e.g. works
> for cifs.ko (which has similar concept to FS UUID for most remote
> filesystems etc.)?

https://evilpiepirate.org/git/query-uuid.git/
