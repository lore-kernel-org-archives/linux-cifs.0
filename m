Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3770D46EC70
	for <linux-cifs@vger.kernel.org>; Wed,  9 Sep 2026 21:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788988123; cv=none; b=TvYhpxKkpk3VmUG3mm2JyvmPI5oLEvPBqQM9hiuoby2NRQmgWJotpnlYzZ0SWCJtO2c6cLYjTBHYYeiW5SBwX1jOkmjGf5pXQCp2OhQyz+eoTXYV4A23n9Kuk26+znd7ZdyiVFQxOP3/W3f5tBeth8cVOQHQq53qs/BoHJWBjws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788988123; c=relaxed/simple;
	bh=v6XN1bSzrdiOZsy+gxDBorIxvgzRZF1Y/gKavtMSJdc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fFHxL6kpkrziL+IOMbHPoq7VMa8QnUByqlM9KIqNgU4yBY1FwLk27pqmBRCD2OkbnS5vp0M3NAg8RSrk5+5U/D/RhufFnCmbuKegJ2HZAEGQNxN32hDBhY6GLnkPhGc5FFrSOiIHJfYzF80oVu4dgGOOiigTbmQcC5aefyUjVeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EieMnnqe; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=hrgxgPCb; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EieMnnqe";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="hrgxgPCb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788988120;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JeCu1I7ci4XqifONO9NCiEC08kQGS9StekRATuRZUpY=;
	b=EieMnnqe0E7eM+N8lsZQs2oEeaVwOpRO9hX2Ny8NHzmbCzz/S/DjpcvmaUvV2my4FH5len
	IyeFqpnVaLukUZsQnmxVh4x+qt/vM5F8DKvNniIPYqA0fWE4BCe+e7WyxKu69qTpPkhvKB
	dhKUlGxiBY3SrgvSoib4WKLilvqj00A=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-85-Gwghp_lxPbupNFGtQYh-7Q-1; Wed, 09 Sep 2026 17:08:38 -0400
X-MC-Unique: Gwghp_lxPbupNFGtQYh-7Q-1
X-Mimecast-MFC-AGG-ID: Gwghp_lxPbupNFGtQYh-7Q_1788988118
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-5308a3825deso61735501cf.2
        for <linux-cifs@vger.kernel.org>; Wed, 09 Sep 2026 14:08:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1788988118; x=1789592918; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:reply-to:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=JeCu1I7ci4XqifONO9NCiEC08kQGS9StekRATuRZUpY=;
        b=hrgxgPCbI+s2W6pD4vzacl4WpRBvQfuv4h0IzPeK3MG2bd7YCv9lzyixwuWci6j4zC
         VDWCz3ZdETVEeyMEnmPFtKukP58YhG6WXGO91YyfdHEqCgUO01ehWMaxAYdaGwHhh7WP
         bCrcsCQKeGli+uI0sbi7DY9YsLmw/2pNRB+ELdcWLMm3hawoWzCdDfcMssftK5ltNXmR
         ZtISmNxU3Hrodujh6PmggJg4/v1lyxj7nZLTu9a5I16r4k9ZVKjOpM33Xi85hWQgyo1C
         wRvO+fQ7L7VYbQqSnrxEdUgAKKUz3E3qKnjI1PPNsfe98EsDKJvnwMXYZjZLk5X6Npdr
         zUsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788988118; x=1789592918;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:reply-to:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=JeCu1I7ci4XqifONO9NCiEC08kQGS9StekRATuRZUpY=;
        b=BwMLSIybxQlKy54xNatxUrztfrFDYDrRhYod995dE5eBZ04gcxKxwIlgC3PkcwvTZU
         sDbzm5o49R9oKueyeWxmt55dbn7k2lgLLyjXN/FMf5JriRpNEvp7GHp0bAbzqPoaPWuN
         0PBx8lISjD31l5G93rKUQyPwe157oC9f79UeijLNEn8mTm6N84AV0iVzM7KlbFsXaC+V
         l1TvdjEcEgTIr/H4XOSPYCF6say4z+sHXhYxYHC0cnh8vajocLTobnBC4yZ4B0IOHpIn
         DeeVvW+JWokiNyRs0ompWX4WlefkwbwKNIruuDT761jfqqlrIZhM+tyRldSBIQMEO83Z
         cLJw==
X-Forwarded-Encrypted: i=1; AKwUvBwTKn3XD4MlKba4kxWOGfpDMdtbEMjWSj9YJV49piZQfpgYWBj7abXLPPoYh/rBGg6E3F+06/4yk7Ob@vger.kernel.org
X-Gm-Message-State: AFuF++n5vLu2Keh+CPdDQJVORznyTYKjeidmvhzuK4ojllk+Kp+1+XU9
	FmkRznOVSJMn34XolxJAxizkbrLLQJlOv4XS9sHz5XkteVGwd8OAgL709U+tUmtHAmPIPv7pOER
	QE4qcqpFNmOjzJXCQMSba9UxoDLdkyaU0jVLQkbZq1sLkAl6WtrgziqMNdVbJ6tlxqoFXUPU=
X-Gm-Gg: AYBFou3TLyhcW6TXNHohb4wD76aYdAt+WXiFZw0YmFSHb8qR50xX/2NOq0ZsXTVFzrN
	ig8StqlOFUmWS4CCczMROyLoc6+xTXSIhjY/E0L3q8Phr6vnK2HPY5MeryWbZKCrNYqo7ZxGrUx
	YB6kRmDaTKks8dz7pzfZxlLlJ7pU77MW9+8lZlGC3avXtH/Qn3jKs57XjV2GIGUuLs3L6A7NiO0
	qyC4WVfsS6zm14HYl18xQHzCn/BnwWKld1i0XUXDfX4x3j7Ld28zeABz7xLLjJ7zTO1E1OL68S/
	TN1bNAVcoyDvx4g+3e13puwsfGuMTPoPDdOZLng6La25UDgOXfflbnlQ6q0CGEpOu+3tvW/WZF6
	zxD6jdD/xt2UbJqfl9hofZEGuOnECtFAknTOBZ+w4
X-Received: by 2002:ac8:5cc1:0:b0:530:b2e2:2f1 with SMTP id d75a77b69052e-530b2e23739mr27765581cf.51.1788988117875;
        Wed, 09 Sep 2026 14:08:37 -0700 (PDT)
X-Received: by 2002:ac8:5cc1:0:b0:530:b2e2:2f1 with SMTP id d75a77b69052e-530b2e23739mr27764751cf.51.1788988117237;
        Wed, 09 Sep 2026 14:08:37 -0700 (PDT)
Received: from [172.16.0.69] (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9104049d30asm153786676d6.0.2026.09.09.14.08.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Sep 2026 14:08:36 -0700 (PDT)
Message-ID: <317dd59c-819f-4bbe-a196-3946c30eb0a3@redhat.com>
Date: Wed, 9 Sep 2026 16:08:34 -0500
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: sorenson@redhat.com
Subject: Re: netfs_read_gaps(): aliased sink folio makes the read destination
 unreadable, SIGBUS on cifs with signing
To: David Howells <dhowells@redhat.com>
Cc: Paulo Alcantara <pc@manguebit.org>, Jeff Layton <jlayton@kernel.org>,
 linux-fsdevel@vger.kernel.org, netfs@lists.linux.dev,
 CIFS <linux-cifs@vger.kernel.org>, linux-kernel@vger.kernel.org
References: <afd68097-b2b2-47e5-889b-fb077e7a9247@redhat.com>
 <a385053c-1c4a-4060-a3bb-befa007ddb33@redhat.com>
 <1714046.1788952509@warthog.procyon.org.uk>
 <1730052.1788974127@warthog.procyon.org.uk>
Content-Language: en-US
From: Frank Sorenson <sorenson@redhat.com>
In-Reply-To: <1730052.1788974127@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 9/9/26 12:15 PM, David Howells wrote:
> Try #3...
>
> David

retested successfully with v3


Frank

> ---
> commit 05abad6ef207137fd3a2559d6ac242d1f94c60aa
> Author: David Howells <dhowells@redhat.com>
> Date:   Wed Sep 9 11:36:30 2026 +0100
>
>      netfs: Fix netfs_read_gaps() to use separate sink folios
>      
>      Fix netfs_read_gaps() to use separate folios rather than re-using a single
>      sink folio to discard the unwanted data so that cifs checksum checking sees
>      all the data that was fetched.
>      
>      Fixes: 7f84a7b9892d ("netfs: Make netfs_read_folio() handle streaming-write pages")
>      Reported-by: Frank Sorenson <sorenson@redhat.com>
>      Closes: https://lore.kernel.org/r/a385053c-1c4a-4060-a3bb-befa007ddb33@redhat.com/
>      Signed-off-by: David Howells <dhowells@redhat.com>
>      Tested-by: Frank Sorenson <sorenson@redhat.com>
>      cc: Paulo Alcantara <pc@manguebit.org>
>      cc: Namjae Jeon <linkinjeon@kernel.org>
>      cc: netfs@lists.linux.dev
>      cc: linux-cifs@vger.kernel.org
>      cc: linux-fsdevel@vger.kernel.org
>
> diff --git a/fs/netfs/buffered_read.c b/fs/netfs/buffered_read.c
> index 424df70a5c30..105194de6e13 100644
> --- a/fs/netfs/buffered_read.c
> +++ b/fs/netfs/buffered_read.c
> @@ -482,15 +482,14 @@ static int netfs_read_gaps(struct file *file, struct folio *folio)
>   	struct netfs_group *group = netfs_folio_group(folio);
>   	struct netfs_folio *finfo = netfs_folio_info(folio);
>   	struct netfs_inode *ctx = netfs_inode(mapping->host);
> -	struct folio *sink = NULL;
> -	struct bio_vec *bvec;
> +	struct bio_vec *bvec = NULL;
>   	unsigned int from = finfo->dirty_offset;
>   	unsigned int to = from + finfo->dirty_len;
> -	unsigned int off = 0, i = 0;
> +	unsigned int off = 0;
>   	size_t flen = folio_size(folio);
>   	size_t nr_bvec = flen / PAGE_SIZE + 2;
>   	size_t part;
> -	int ret;
> +	int ret, i = 0, sink_from = -1, sink_to = -1;
>   
>   	_enter("%lx", folio->index);
>   
> @@ -515,24 +514,23 @@ static int netfs_read_gaps(struct file *file, struct folio *folio)
>   	if (!bvec)
>   		goto discard;
>   
> -	sink = folio_alloc(GFP_KERNEL, 0);
> -	if (!sink) {
> -		kfree(bvec);
> -		goto discard;
> -	}
> -
>   	trace_netfs_folio(folio, netfs_folio_trace_read_gaps);
>   
> -	rreq->direct_bv = bvec;
> -	rreq->direct_bv_count = nr_bvec;
>   	if (from > 0) {
>   		bvec_set_folio(&bvec[i++], folio, from, 0);
>   		off = from;
>   	}
> +	sink_from = i;
>   	while (off < to) {
> +		struct folio *sink = folio_alloc(GFP_KERNEL, 0);
> +
> +		if (!sink)
> +			goto discard;
>   		part = min_t(size_t, to - off, PAGE_SIZE);
> -		bvec_set_folio(&bvec[i++], sink, part, 0);
> +		bvec_set_folio(&bvec[i], sink, part, 0);
>   		off += part;
> +		sink_to = i;
> +		i++;
>   	}
>   	if (to < flen)
>   		bvec_set_folio(&bvec[i++], folio, flen - to, to);
> @@ -553,8 +551,10 @@ static int netfs_read_gaps(struct file *file, struct folio *folio)
>   		folio_mark_uptodate(folio);
>   	}
>   
> -	if (sink)
> -		folio_put(sink);
> +	if (sink_to >= 0)
> +		for (; sink_from <= sink_to; sink_from++)
> +			folio_put(bvec_folio(&bvec[sink_from]));
> +	kfree(bvec);
>   	folio_unlock(folio);
>   	netfs_put_request(rreq, netfs_rreq_trace_put_return);
>   	return ret < 0 ? ret : 0;
> @@ -563,6 +563,10 @@ static int netfs_read_gaps(struct file *file, struct folio *folio)
>   	netfs_put_failed_request(rreq);
>   alloc_error:
>   	folio_unlock(folio);
> +	if (sink_to >= 0)
> +		for (; sink_from <= sink_to; sink_from++)
> +			folio_put(bvec_folio(&bvec[sink_from]));
> +	kfree(bvec);
>   	return ret;
>   }
>   

-- 
Frank Sorenson
sorenson@redhat.com
Principal Software Maintenance Engineer, filesystems
Red Hat

