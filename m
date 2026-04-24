Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDEC735F8B7;
	Fri, 24 Apr 2026 10:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777024958; cv=none; b=aj2mDyR6poUgeyJ4P7TZcyDvmrSoRJV6LY956QANOaMc0HkXYmF2S691V9Sd0sG04Elf7TQOo24c6s+2EcDImyKwL+r8NB07rFOboWfHxZfMPMqeAIRV4a1OvEwjf/GJ2OgJmuQlHGFaLIt3QofhuhoLy+/rBrM+1v5+RfUpW2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777024958; c=relaxed/simple;
	bh=CjUeLPA3EenRqh7MNr2AcUzrVFrPzT99dnMj15b6S4k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H/3hWbjGaSxvbe55eXxdnOlob1Ck+KsKuafF8EbdOj5ychRytUREKSDDp/50fs/dQDyMTJ9GLImxYvr/Gny8fUg6vQP5TL7RvFVE3KG3647/FFGqqH8WLMS5hmyYxkNuhoumFsG8wLX+6J2C9eJ1xOAPxo8iTOgWTio4c8StBFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a+fqX52Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a+fqX52Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D3EBC19425;
	Fri, 24 Apr 2026 10:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777024957;
	bh=CjUeLPA3EenRqh7MNr2AcUzrVFrPzT99dnMj15b6S4k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=a+fqX52Qv6brwSH8UrA5Xs8BwlGCjAQCp/Ph0sJdbtx+Mu7MuFOJGvIYrEs4CXXMS
	 +Hrcj6NOgJJy7cc4VncAzD9VDBT+k0TtmQE65bbIZLluus73MZHN2n28vBqnVv08+a
	 i7hPRM7FFqji0HXu4oqpUxdzKbk8l1xPP+qwCeP0=
Date: Fri, 24 Apr 2026 12:02:35 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: David Howells <dhowells@redhat.com>
Cc: Steve French <sfrench@samba.org>, Stefan Metzmacher <metze@samba.org>,
	Paulo Alcantara <pc@manguebit.org>, Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] smb: client: Fix error cleanup in
 smb_extract_iter_to_rdma()
Message-ID: <2026042426-prance-each-273d@gregkh>
References: <3418418.1777024571@warthog.procyon.org.uk>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3418418.1777024571@warthog.procyon.org.uk>

On Fri, Apr 24, 2026 at 10:56:11AM +0100, David Howells wrote:
>     
> Fix smb_extract_iter_to_rdma() to use pre-decrement, not post-decrement, so
> that it cleans up the correct slots.
> 
> Fixes: e5fbdde43017 ("cifs: Add a function to build an RDMA SGE list from an iterator")
> Closes: https://sashiko.dev/#/patchset/20260326104544.509518-1-dhowells%40redhat.com
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Steve French <sfrench@samba.org>
> cc: Stefan Metzmacher <metze@samba.org>
> cc: Paulo Alcantara <pc@manguebit.org>
> cc: Tom Talpey <tom@talpey.com>
> cc: linux-cifs@vger.kernel.org
> cc: linux-fsdevel@vger.kernel.org
> ---
>  fs/smb/client/smbdirect.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
> index 7d5f66bdbb30..4978755c035c 100644
> --- a/fs/smb/client/smbdirect.c
> +++ b/fs/smb/client/smbdirect.c
> @@ -3394,7 +3394,7 @@ static ssize_t smb_extract_iter_to_rdma(struct iov_iter *iter, size_t len,
>  
>  	if (ret < 0) {
>  		while (rdma->nr_sge > before) {
> -			struct ib_sge *sge = &rdma->sge[rdma->nr_sge--];
> +			struct ib_sge *sge = &rdma->sge[--rdma->nr_sge];
>  
>  			ib_dma_unmap_single(rdma->device, sge->addr, sge->length,
>  					    rdma->direction);
> 
> 
<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
