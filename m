Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29B258F49
	for <linux-cifs@vger.kernel.org>; Thu,  9 May 2024 17:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715274939; cv=none; b=aV1eJVUMj3ODLCoM5TgS82VYpxVdxPufebMwwWxsuU4En27otgGf/T61dCqcjVF5iZ/vLWPEwK9rshW5z/3FNddJDMpK0l7DhiuxaPOo/xTG4/Whl/rIYfPJNsGP/NFfAWnrmAj3W5obuPCxlMxruj4XA5S3uvx1Dlg5fbQQccc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715274939; c=relaxed/simple;
	bh=I2b3mZDphqAOw1CzA9XXn8owOPYBXLxuDEHOZbykNDU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KdTUbNNMnCfmP6yzKKWaJxHVGl/Zr99KNePqNbrK1bBuvgbn235ZpGSftFMJtcXwAXkwI6p+DqHgxK/VKN+h5LsA0s6kWyLdnNVXpAyMNX1yPfTFJbfdrJu17AN9R6oOtXIhmmC8m9kT/YhKqhG2jyTE6EWP4vm+U/jbslZ62E0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b=HIE23ZeU; arc=none smtp.client-ip=185.125.188.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="HIE23ZeU"
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 5F33B3FB6E
	for <linux-cifs@vger.kernel.org>; Thu,  9 May 2024 17:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1715274934;
	bh=R13CNUyH1MbzjMY2CalRPAAS/uvh6wjQHgeABBOaJzE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:In-Reply-To;
	b=HIE23ZeUFGpNub4mkJjolnmcnjKRiYIZCcxlle7qzx0QxPHfaQSaalKI6TzYaWHJi
	 bLy2UvHNP5D7B3R4aW3+t/KG8h59aUSqA4sPFiaH7lvjNC3gzhv51blx0XD+bI0L/A
	 tX+msuNNXItnYmoBpCRrGkFQJIxCZbw5kQMPRrWJ1OlrwOLptZepvDtHw0T9EPRg9S
	 qnSS1wBFZB//Cu6J1M6PCBa8OtAz+16pQ5d1G5zF0WmqDHbVBAjniJWshKu6Q8m+ku
	 6QRzxKzQUTpg3I36rLwEU4KHB2eyEt0YvDTY30FUAp2A7NO+4mOBXSL1NF75qAB+wp
	 7gCLpXmZF7L7w==
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-a59caea8836so66803966b.1
        for <linux-cifs@vger.kernel.org>; Thu, 09 May 2024 10:15:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715274931; x=1715879731;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R13CNUyH1MbzjMY2CalRPAAS/uvh6wjQHgeABBOaJzE=;
        b=LMmVLfKiQDi0RMIOt5aMoZtMro/9vRkOuPr7nx7tap/jkaOs0xEnkB2Z277Dw/HEbX
         HzcUwhpovZSMqNPO6zukcXPAgeS37LE3EzTwwGSUxnjYChTXvIPpxe7fVAczEgVKU1t3
         PZF7TAO6FgrUlUVHwGBuMVRkC9JiHLn2ww69+5Qn85EorXDpVn6CxP2jwjzszltcl2YQ
         ltgAs7GQqrZQOpuUz2hr+MR8C1tRn74ZolA6FJPbCqe5cfcrWuiqtDsIby5jGfeZmSPo
         8s4OaAEgyggDuH+xj8u3vR0qdRNvZL1pwyo4HfzyJ2+qBNKCiTD0mMo5m8tE7VQFwSjC
         Yv4Q==
X-Forwarded-Encrypted: i=1; AJvYcCUz2uTTXWS3EX/VRw6HRC+AzLcOQWAR//u8ll4PF99556lQJOQRiz3XHkNk5RoF83ptfoY2ouoCRsomE+Z/wicNQOL7/crhQAp3LQ==
X-Gm-Message-State: AOJu0Yzq5/hKajU7WYPk6wGsCs46p9Aknw+otdouNNlaTUde2KBDaZNA
	H5kOjiGl/J2LfHTLK+EGD8rey92cI84wmP2vGRYE8TyG2yXxvhTkcJBuc8xHdpwnLu0FT+2PYkO
	e8tFs4eKOiE1o1/wfj6KvVq2TxKab4Sfs9fSJeSR+HmgJ8UCevVhhXggAO+vpksHzBrtNTsEycc
	8=
X-Received: by 2002:a17:906:3849:b0:a59:b02a:90dc with SMTP id a640c23a62f3a-a5a2d66ac03mr15004166b.54.1715274930676;
        Thu, 09 May 2024 10:15:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHRId3ZK7jZnEUqxnKrbYMBDrOXsoSZ6C8TgHiChCG3zHZRXUk/mhnLLXZdmjv+NVtyVoseaw==
X-Received: by 2002:a17:906:3849:b0:a59:b02a:90dc with SMTP id a640c23a62f3a-a5a2d66ac03mr15001366b.54.1715274929765;
        Thu, 09 May 2024 10:15:29 -0700 (PDT)
Received: from localhost (host-82-49-69-7.retail.telecomitalia.it. [82.49.69.7])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a5a179c81bfsm93194566b.129.2024.05.09.10.15.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 May 2024 10:15:29 -0700 (PDT)
Date: Thu, 9 May 2024 19:15:27 +0200
From: Andrea Righi <andrea.righi@canonical.com>
To: David Howells <dhowells@redhat.com>
Cc: Jeff Layton <jlayton@kernel.org>, Steve French <smfrench@gmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	Marc Dionne <marc.dionne@auristor.com>,
	Paulo Alcantara <pc@manguebit.com>,
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Ilya Dryomov <idryomov@gmail.com>,
	Christian Brauner <christian@brauner.io>, linux-cachefs@redhat.com,
	linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org,
	linux-nfs@vger.kernel.org, ceph-devel@vger.kernel.org,
	v9fs@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Latchesar Ionkov <lucho@ionkov.net>,
	Christian Schoenebeck <linux_oss@crudebyte.com>
Subject: Re: [PATCH v5 40/40] 9p: Use netfslib read/write_iter
Message-ID: <Zj0ErxVBE3DYT2Ea@gpd>
References: <20231221132400.1601991-1-dhowells@redhat.com>
 <20231221132400.1601991-41-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231221132400.1601991-41-dhowells@redhat.com>

On Thu, Dec 21, 2023 at 01:23:35PM +0000, David Howells wrote:
> Use netfslib's read and write iteration helpers, allowing netfslib to take
> over the management of the page cache for 9p files and to manage local disk
> caching.  In particular, this eliminates write_begin, write_end, writepage
> and all mentions of struct page and struct folio from 9p.
> 
> Note that netfslib now offers the possibility of write-through caching if
> that is desirable for 9p: just set the NETFS_ICTX_WRITETHROUGH flag in
> v9inode->netfs.flags in v9fs_set_netfs_context().
> 
> Note also this is untested as I can't get ganesha.nfsd to correctly parse
> the config to turn on 9p support.

It looks like this patch has introduced a regression with autopkgtest,
see: https://bugs.launchpad.net/bugs/2056461

I haven't looked at the details yet, I just did some bisecting and
apparently reverting this one seems to fix the problem.

Let me know if you want me to test something in particular or if you
already have a potential fix. Otherwise I'll take a look.

Thanks,
-Andrea
