Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7218E29E116;
	Sat, 23 May 2026 09:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779528174; cv=none; b=UIq1ikexo4aQIQhSsw9BfaBtdwdWrouSvyzzv03I18x5A5Em6wEJbXr3TuXJJlsRmFfEOnPvbnX7xPXqESNjOvfnJPaBihDJ/YUIBtpXVrGqmYcAXPLwZw6orhn+eQdACyUT8LMti+sPGHXWoWEKrM0JkYiFKiZAqhhcU647lDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779528174; c=relaxed/simple;
	bh=WzWnaxafrb449AME7UJ7Iy8ifl+TzT0qDjt5jndyN98=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MxfAK9HQ/G7J9Ez8V2mL1LT7nIpXwf1uahw2s+N3/bS/nUfaPw5DAi6BdWDHIyFmbclh7QE2jSpoRiEEIS+/vlI0QqZCYAnh5i1jhLwPcyquOO31Ev9fxkpqQatsWXL+olP30TjjnX9Rs1Xgl1QE7jXLTenP3iagvPfpz5CfGUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uXBz4P3K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uXBz4P3K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C9511F000E9;
	Sat, 23 May 2026 09:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779528173;
	bh=F7dDuv7wc6zC9c//1ET26gyJLdKCLeEDcRpy9I2R+8Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=uXBz4P3KU8bZCZGDAbposvHdqoVXnw0VCLY48PV3EclKMT2rkEO9lgDoHa7XMlznA
	 xV+Se3w+1vAxlUc9yEsETXH11BjPFcHSMTE53qsufFww9bO76TAo++EABkZWI8UGlt
	 K5Kef4NRsHBEG+Q2LJEWookbdckoOiG81HbempBQ=
Date: Sat, 23 May 2026 11:22:55 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Xiaoli Feng <xifeng@redhat.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	David Howells <dhowells@redhat.com>, netfs@lists.linux.dev,
	linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH 6.12 634/666] netfs: fix error handling in
 netfs_extract_user_iter()
Message-ID: <2026052349-handset-ambiguity-b618@gregkh>
References: <20260520162111.222830634@linuxfoundation.org>
 <20260520162125.016902019@linuxfoundation.org>
 <7ed573be-1df9-43ee-bfef-4499af0767b4@oracle.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7ed573be-1df9-43ee-bfef-4499af0767b4@oracle.com>

On Sat, May 23, 2026 at 01:53:15AM +0530, Harshit Mogalapalli wrote:
> Hi Greg/Sasha,
> 
> On 20/05/26 21:54, Greg Kroah-Hartman wrote:
> > 6.12-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Paulo Alcantara <pc@manguebit.org>
> > 
> > commit 0aad5704c6b4d14007d4eab15883e8524e4310f4 upstream.
> > 
> > In netfs_extract_user_iter(), if iov_iter_extract_pages() failed to
> > extract user pages, bail out on -ENOMEM, otherwise return the error
> > code only if @npages == 0, allowing short DIO reads and writes to be
> > issued.
> > 
> > This fixes mmapstress02 from LTP tests against CIFS.
> > 
> > Fixes: 85dd2c8ff368 ("netfs: Add a function to extract a UBUF or IOVEC into a BVEC iterator")
> > Reported-by: Xiaoli Feng <xifeng@redhat.com>
> > Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
> > Signed-off-by: David Howells <dhowells@redhat.com>
> > Link: https://patch.msgid.link/20260512123404.719402-10-dhowells@redhat.com
> > Cc: netfs@lists.linux.dev
> > Cc: stable@vger.kernel.org
> > Cc: linux-cifs@vger.kernel.org
> > Cc: linux-fsdevel@vger.kernel.org
> > Signed-off-by: Christian Brauner <brauner@kernel.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >   fs/netfs/iterator.c |   13 ++++++++++---
> >   1 file changed, 10 insertions(+), 3 deletions(-)
> > 
> > --- a/fs/netfs/iterator.c
> > +++ b/fs/netfs/iterator.c
> > @@ -22,7 +22,7 @@
> >    *
> >    * Extract the page fragments from the given amount of the source iterator and
> >    * build up a second iterator that refers to all of those bits.  This allows
> > - * the original iterator to disposed of.
> > + * the original iterator to be disposed of.
> >    *
> >    * @extraction_flags can have ITER_ALLOW_P2PDMA set to request peer-to-peer DMA be
> >    * allowed on the pages extracted.
> > @@ -67,8 +67,8 @@ ssize_t netfs_extract_user_iter(struct i
> >   		ret = iov_iter_extract_pages(orig, &pages, count,
> >   					     max_pages - npages, extraction_flags,
> >   					     &offset);
> > -		if (ret < 0) {
> > -			pr_err("Couldn't get user pages (rc=%zd)\n", ret);
> > +		if (unlikely(ret <= 0)) {
> > +			ret = ret ?: -EIO;
> >   			break;
> >   		}
> > @@ -97,6 +97,13 @@ ssize_t netfs_extract_user_iter(struct i
> >   		npages += cur_npages;
> >   	}
> > +	if (ret < 0 && (ret == -ENOMEM || npages == 0)) {
> > +		for (i = 0; i < npages; i++)
> > +			unpin_user_page(bv[i].bv_page);
> > +		kvfree(bv);
> > +		return ret;
> > +	}
> > +
> 
> I have run an AI assisted backport review and it spotted an issue: I
> have taken a look and the issues goes like:
> 
> Upstream has:
> 
> 
> 
> ssize_t ret = 0;
> 
> ...
> if (ret < 0 && (ret == -ENOMEM || npages == 0)) {
>         for (i = 0; i < npages; i++)
>                 unpin_user_page(bv[i].bv_page);
>         kvfree(bv);
>         return ret;
> }
> 
> 6.12.y has:
> 
> ssize_t ret;
> 
> ...
> if (ret < 0 && (ret == -ENOMEM || npages == 0)) {
>         for (i = 0; i < npages; i++)
>                 unpin_user_page(bv[i].bv_page);
>         kvfree(bv);
>         return ret;
> }
> 
> I think 6.12.y misses commit: 7e3d8db899d5 ("netfs: Fix potential
> uninitialised var in netfs_extract_user_iter()") so backport might not be
> complete, thoughts ?

Now applied, thanks.

greg k-h
