Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1674C1EB5C2;
	Wed,  8 Apr 2026 05:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775627125; cv=none; b=d37Qe4DI09uNGoqJQs81yB+suT22mvGY7SwRE2dy5pW7MwNtHEyiJXE+9MG7nOT89H4ChwLJC+OYKcVqrof/3N9Fz1gpTBn9go0GDlJ2wbTSZQw2HpaaHPt9xURBpP57uKldC4xEx5PTHijXeXu/z6HKYd7Uqv+PCYWgr1pQ53Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775627125; c=relaxed/simple;
	bh=T6neeW3mgh7D1onuAxxjE5kOLZQ+E7BmmJ86KiSY3ZY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dtKO6lQRMwTRxYWrxxvrYvKD/NPOgeNyWEnQ133xGwRdt4Kfon+dc7LUSWP9F0kzRXy4uOC1KGnfeGsoJTxOKE9OVsL/GAtbXtnyzOSsHWjUlU2nSCByzOy6J+qOcr3Vvymcr3NoW4DyBNslYLWRbSZ6H5mfTBPURk3BE/nsQ8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KN04/L4D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KN04/L4D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 479F4C19424;
	Wed,  8 Apr 2026 05:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775627124;
	bh=T6neeW3mgh7D1onuAxxjE5kOLZQ+E7BmmJ86KiSY3ZY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KN04/L4DbEJ2AqjD83Iguc+UO87bjyMZU+8xAnUW0FFXVw8ozeIu1Fbt+decvWIXn
	 RhrHCebkNNMNi1PSe7ty0S1yn87K41DmIUVtxubiR0JviYincEpYD0vwe2/HLtadn5
	 rCnzfPb+/7WwFp89nhREP87jXRQzgd0EmNG6c9D0=
Date: Wed, 8 Apr 2026 07:45:22 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Steve French <smfrench@gmail.com>
Cc: Paulo Alcantara <pc@manguebit.org>, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
	Steve French <sfrench@samba.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>
Subject: Re: [PATCH 0/2] smb: some potential bugfixes
Message-ID: <2026040816-rendering-reaffirm-d8ed@gregkh>
References: <2026040635-banking-unsoiled-3250@gregkh>
 <e50b019e071d66509cc24f98c7900fee@manguebit.org>
 <CAH2r5mvXFzWxs70Jmg=yWddmcHs+Bpf8eiBUvyc4oOMLzdCY7w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH2r5mvXFzWxs70Jmg=yWddmcHs+Bpf8eiBUvyc4oOMLzdCY7w@mail.gmail.com>

On Tue, Apr 07, 2026 at 03:52:21PM -0500, Steve French wrote:
> merged into cifs-2.6.git for-next

Thanks!
