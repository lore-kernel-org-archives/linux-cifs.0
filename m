Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67C072E7182;
	Fri, 31 Oct 2025 07:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761896690; cv=none; b=p1WhQYocvSDy5VBq3LCzmMIhQV+5JfyZqaDcYgRowGOdaOjT5d6RN7UNfV/qFS8TL23bUsdBNRinfafegyG+5sEzSn4dI93uLQj1bgDzMWZFw4OyhXH4/m6qBKgwMOnfF7LzbPAzzVWKI8vG88LswR8Q6sW+R3oDk+T4i30gB4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761896690; c=relaxed/simple;
	bh=VztEw2IJcjo2gATUWIYWaNfaOhNlLjB6rGgcXp7n9MY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DLJX8FXeE4Jx5TzG/VoiIfy7iHCFS5Xeih4S/eBz7lj9WfPJDS47SZ6uby75EQRDOu2H9cZ2bqBsdPml2ad1/C8hAwOpxhIIhyW9QsCeKYLGckGKxs1NFDFolBsajkuXHLClgtd/UGy9q/XRV6syh4e7aNNi+DufxghDJZJ5+ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eOHjJCbu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eOHjJCbu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A392EC4CEFB;
	Fri, 31 Oct 2025 07:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761896690;
	bh=VztEw2IJcjo2gATUWIYWaNfaOhNlLjB6rGgcXp7n9MY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eOHjJCbuvplv4O1ny3Lds2wYINPgutoYRzQYh2udPN+AnR0BDLETIpfTZyJPOtGS8
	 AdqwTAsONJdCc3n/UeFeiaboj7/1A8kw+bxhqEDTzknDMARF3sTMsHehTmofYhAe5w
	 fktZoJIa+GJ9V3Z/TOs7CuLKtiTLUDolhvpzrCUc=
Date: Fri, 31 Oct 2025 08:44:47 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Qingfang Deng <dqfext@gmail.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>, Steve French <smfrench@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>, Ronnie Sahlberg <lsahlber@redhat.com>,
	Hyunchul Lee <hyc.lee@gmail.com>, linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH] ksmbd: server: avoid busy polling in accept loop
Message-ID: <2025103116-grinning-component-3aea@gregkh>
References: <20251030064736.24061-1-dqfext@gmail.com>
 <CAKYAXd9nkQFgXPpKpOY+O_B5HRLeyiZKO5a4X5MdfjYoO_O+Aw@mail.gmail.com>
 <CALW65jZQzTMv1HMB3R9cSACebVagtUsMM9iiL8zkTGmethfcPg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALW65jZQzTMv1HMB3R9cSACebVagtUsMM9iiL8zkTGmethfcPg@mail.gmail.com>

On Fri, Oct 31, 2025 at 03:32:06PM +0800, Qingfang Deng wrote:
> Hi Namjae,
> 
> On Thu, Oct 30, 2025 at 4:11 PM Namjae Jeon <linkinjeon@kernel.org> wrote:
> > > Fixes: 0626e6641f6b ("cifsd: add server handler for central processing and tranport layers")
> > > Signed-off-by: Qingfang Deng <dqfext@gmail.com>
> > Applied it to #ksmbd-for-next-next.
> > Thanks!
> 
> I just found that this depends on another commit which is not in
> kernel versions earlier than v6.1:
> a7c01fa93aeb ("signal: break out of wait loops on kthread_stop()")
> 
> With the current Fixes tag, this commit will be backported to v5.15
> automatically. But without said commit, kthread_stop() cannot wake up
> a blocking kernel_accept().
> Should I change the Fixes tag, or inform linux-stable not to backport
> this patch to v5.15?

Email stable@vger.kernel.org when it lands in Linus's tree to not
backport it that far.

thanks,

greg k-h
