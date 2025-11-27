Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86D1B2750ED;
	Thu, 27 Nov 2025 13:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764250231; cv=none; b=W2SdHI35L7Z8ybuQclYJJ4cAajWr4xpgyITkHxnfGlorHfT99kPQa5sSjplAYP3q9PMqDXmLQ8yq6wiH86WBtnXfMhsgHT+N1UtslQoT1dAb41lYMCJxJMr0HJ7fbko8JSPZKirWheK+QQS50Y1iPd27Apo7aaPPtqGSzZvsv1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764250231; c=relaxed/simple;
	bh=LuW33Qmw6b+FBxoiMZUsrTuCLWkTEsGgiIgp0uKhm3c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UPnkI/WEIcVWsH1hDDwErGMVNukOokLl2HSn+jTbpgVWlOaCiopE7ZcegkNDRrsK02jKxPeUoLZmrlA5OLSfxFbRR9G1vSgWHvj+v1ROuetU7QGy4PgMCShzs81ySTldKtKsWBEgl0YKP3bxOQmBeUaodZm/8ljJKZb4rEnFkH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hLttpL+f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hLttpL+f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC1DBC4CEF8;
	Thu, 27 Nov 2025 13:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764250231;
	bh=LuW33Qmw6b+FBxoiMZUsrTuCLWkTEsGgiIgp0uKhm3c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hLttpL+fSi/4VGEdZbJXeBfo5lC65USaTdPOiDBNJuEFlBhC/rGbVORs8f/Rp8B+2
	 09EtLwc5Mtx9Z3M0REc8V8xAVdo71b7TRTCiEx6ylelSVDwDRSmrkDNYkxiiTnN1L0
	 D3RkJHvopkyo+bOmwr0KcXe6OrT2lOhTC/MjPGQA=
Date: Thu, 27 Nov 2025 14:30:28 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Bharath SM <bharathsm.hsk@gmail.com>
Cc: Henrique Carvalho <henrique.carvalho@suse.com>, stable@vger.kernel.org,
	Shyam Prasad N <sprasad@microsoft.com>, apais@microsoft.com,
	Bharath S M <bharathsm@microsoft.com>,
	David Howells <dhowells@redhat.com>, smfrench@gmail.com,
	linux-cifs@vger.kernel.org, Laura Kerner <laura.kerner@ichaus.de>
Subject: Re: [PATCH 6.6.y] smb: client: support kvec iterators in async read
 path
Message-ID: <2025112707-pummel-film-6bd6@gregkh>
References: <20250710165040.3525304-1-henrique.carvalho@suse.com>
 <2944136.1752224518@warthog.procyon.org.uk>
 <aHE0--yUyFJqK6lb@precision>
 <CAGypqWyyA6nUfH-bGhQxLYD74O7EcE_6_W15=AB8jvi6yZiV_Q@mail.gmail.com>
 <2025112112-icon-bunkmate-bfad@gregkh>
 <CAGypqWy8=Oq6CC0YGFSr72L7kqrEDOytboSqJFJBxxV5tGQgFA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGypqWy8=Oq6CC0YGFSr72L7kqrEDOytboSqJFJBxxV5tGQgFA@mail.gmail.com>

On Fri, Nov 21, 2025 at 02:31:20AM -0800, Bharath SM wrote:
> On Fri, Nov 21, 2025 at 2:02 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Thu, Nov 06, 2025 at 06:02:39AM -0800, Bharath SM wrote:
> > > On Fri, Jul 11, 2025 at 9:01 AM Henrique Carvalho
> > > <henrique.carvalho@suse.com> wrote:
> > > >
> > > > On Fri, Jul 11, 2025 at 10:01:58AM +0100, David Howells wrote:
> > > > > Henrique Carvalho <henrique.carvalho@suse.com> wrote:
> > > > >
> > > > > > Add cifs_limit_kvec_subset() and select the appropriate limiter in
> > > > > > cifs_send_async_read() to handle kvec iterators in async read path,
> > > > > > fixing the EIO bug when running executables in cifs shares mounted
> > > > > > with nolease.
> > > > > >
> > > > > > This patch -- or equivalent patch, does not exist upstream, as the
> > > > > > upstream code has suffered considerable API changes. The affected path
> > > > > > is currently handled by netfs lib and located under netfs/direct_read.c.
> > > > >
> > > > > Are you saying that you do see this upstream too?
> > > > >
> > > >
> > > > No, the patch only targets the 6.6.y stable tree. Since version 6.8,
> > > > this path has moved into the netfs layer, so the original bug no longer
> > > > exists.
> > > >
> > > > The bug was fixed at least since the commit referred in the commit
> > > > message -- 3ee1a1fc3981. In this commit, the call to cifs_user_readv()
> > > > is replaced by a call to netfs_unbuffered_read_iter(), inside the
> > > > function cifs_strict_readv().
> > > >
> > > > netfs_unbuffered_read_iter() itself was introduced in commit
> > > > 016dc8516aec8, along with other netfs api changes, present in kernel
> > > > versions 6.8+.
> > > >
> > > > Backporting netfs directly would be non-trivial. Instead, I:
> > > >
> > > > - add cifs_limit_kvec_subset(), modeled on the existing
> > > >   cifs_limit_bvec_subset()
> > > > - choose between the kvec or bvec limiter function early in
> > > >   cifs_write_from_iter().
> > > >
> > > > The Fixes tag references d08089f649a0c, which implements
> > > > cifs_limit_bvec_subset() and uses it inside cifs_write_from_iter().
> > > >
> > > > > > Reproducer:
> > > > > >
> > > > > > $ mount.cifs //server/share /mnt -o nolease
> > > > > > $ cat - > /mnt/test.sh <<EOL
> > > > > > echo hallo
> > > > > > EOL
> > > > > > $ chmod +x /mnt/test.sh
> > > > > > $ /mnt/test.sh
> > > > > > bash: /mnt/test.sh: /bin/bash: Defekter Interpreter: Eingabe-/Ausgabefehler
> > > > > > $ rm -f /mnt/test.sh
> > > > >
> > > > > Is this what you are expecting to see when it works or when it fails?
> > > > >
> > > >
> > > > This is the reproducer for the observed bug. In english it reads "Bad
> > > > interpreter: Input/Output error".
> > > >
> > > > FYI: I tried to follow Option 3 of the stable-kernel rules for submission:
> > > > <https://www.kernel.org/doc/html/v6.15/process/stable-kernel-rules.html>
> > > > Please let me know if you'd prefer a different approach or any further
> > > > changes.
> > > Thanks Henrique.
> > >
> > > Hi Greg,
> > >
> > > We are observing the same issue with the 6.6 Kernel, Can you please
> > > help include this patch in the 6.6 stable kernel.?
> >
> > Pleas provide a working backport and we will be glad to imclude it.
> >
> This fix is not needed now in the stable kernels as "[PATCH] cifs: Fix
> uncached read into ITER_KVEC iterator" submitted
> in email thread "Request to backport data corruption fix to stable"
> fixes this issue.

I do not understand, what commit fixed this?  You attached a fix, but
that's not needed?

confused,

greg k-h

