Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5B34431A2E
	for <linux-cifs@vger.kernel.org>; Fri,  7 Aug 2026 11:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786100796; cv=none; b=Gn/YTSIgz8aVJwOiiE0/k30Y6N0836G71LYCwXiVtR6IF9oI8+XFUDI6BMJD/oaX9196uQPAVHAWt3xcaVZsvsZs7/ucYySiaWbOJ4TeZ7DZDf6Boujim1Mlz8yvNB8lkieZz8irhPhMC24q3j4oI7HorhxV3ZEJoY+esxDJ9yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786100796; c=relaxed/simple;
	bh=orrX5TQ8unetK/+rFmT/bo0N+cJMRGAuJsw0OQsAE9M=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=E6VPn1EHjTil62qV8TA4FLM9dlMZggmMx3E5Tk9CzwVr98BzPnkj+Gtz+CX4/8bA8UZaBcv6s2ftQY2vqRt+3dof27QjviaIEnPC4HOnLvcLp2CL+lZ1phf7buncRjFqF/AvdtrMJvabMg9v3LLUHQbpkmtezy7Q7Bann6HJOKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UoRHO7TR; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UoRHO7TR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786100793;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dHgBZ644cAV7TZlNI7NNuhhZdJ3SVjFuwADrNlbv5Bk=;
	b=UoRHO7TRRfxhfyYW5orjJy2k39Ae+2Z7pZDgJRUzw+Ok9ZnYF9i46f5yqg2oiPUdyKT134
	ZnSE9QexJKD6c4Lw+huvEhQ04taQ7I2Go1jcrPrvp9PaUvEchoUp7TfDA04dG38NJQsfmE
	YkvshHE+S5VHPjQhYdqrnetgssvsz+8=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-563-lD0e_OG6PBObp6BTvNkVxQ-1; Fri,
 07 Aug 2026 07:06:32 -0400
X-MC-Unique: lD0e_OG6PBObp6BTvNkVxQ-1
X-Mimecast-MFC-AGG-ID: lD0e_OG6PBObp6BTvNkVxQ_1786100791
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1FF0E18007E7;
	Fri,  7 Aug 2026 11:06:31 +0000 (UTC)
Received: from [10.22.76.7] (unknown [10.22.76.7])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 57768426;
	Fri,  7 Aug 2026 11:06:30 +0000 (UTC)
Message-ID: <190b74b3-ac7f-411a-81a8-ac45e7d20fe9@redhat.com>
Date: Fri, 7 Aug 2026 06:06:28 -0500
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/3] cifs: three size-management bug fixes
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org, stfrench@microsoft.com, pc@manguebit.org
References: <20260807024158.3707995-1-sorenson@redhat.com>
Content-Language: en-US
In-Reply-To: <20260807024158.3707995-1-sorenson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95


On 8/6/26 9:41 PM, Frank Sorenson wrote:
> These patches fix three independent bugs in cifs file size and handle
> management.

Sashiko brought up some serious concerns which I'll have to address.

Sorry for the noise.


Frank


> Patch 1 fixes a use-after-free in cifs_file_set_size(): when the
> handle-based set_file_size() call fails and falls through to the
> path-based fallback, tcon is reused from the cifsFileInfo that was
> already released by cifsFileInfo_put().  If that put drops the last
> reference on a tlink that has been removed from the tlink tree, the
> subsequent set_path_size() call is a use-after-free.
>
> Patch 2 fixes a premature i_size update in cifs_do_truncate(): when
> no cached writable handle is available, the server truncation happens
> implicitly via the O_TRUNC flag in the following cifs_open() request,
> but the current code sets i_size to 0 locally beforehand.  If the
> subsequent open fails, other processes sharing the inode observe a
> spuriously zero-sized file.
>
> Patch 3 fixes a loff_t underflow in cifs_remap_file_range() when
> len == 0 and off >= i_size.  The computed length is negative, which
> corrupts downstream arithmetic and sends a huge ByteCount in the
> FSCTL_DUPLICATE_EXTENTS_TO_FILE request.
>
> Patches 1 and 2 fix regressions introduced by commit 110fee6b9bb5
> ("smb: client: fix missing timestamp updates with O_TRUNC").
>
> v2: rebased
>
> Frank Sorenson (3):
>    cifs: clear tcon after cifsFileInfo_put() in cifs_file_set_size()
>    cifs: don't update i_size in cifs_do_truncate() without a cached
>      handle
>    cifs: fix loff_t underflow in cifs_remap_file_range() when len == 0
>
>   fs/smb/client/cifsfs.c |  7 ++++++-
>   fs/smb/client/file.c   | 17 +++++++++++++----
>   fs/smb/client/inode.c  |  1 +
>   3 files changed, 20 insertions(+), 5 deletions(-)
>

