Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA9AA224D5
	for <linux-cifs@vger.kernel.org>; Mon,  4 Mar 2024 14:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709561599; cv=none; b=p8nvB3Z6xYpOvLORCrEkVdJYLIE036JmZ++37zEmbk5YoQI1ES/R3z17Nd3tKxMFNwb9VkgtSVFbwH7L+EB6dcqaBfU3Lp8bn5enVVy9mnMqjOPLiJSdcYiDa5WkTCb2emV46f/89XJXeahsyAzWHhfyBXWUFSMbUro9KNNe9jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709561599; c=relaxed/simple;
	bh=l3wbRppRlIGdhh7sG3IfW6f4awjUymHJzULXxsdVVgA=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=lTuqYnL/zrxYWnlhOukdcsK7AfBJindVouCxPBlgv7dtJcv/zIOxv2Q9Yi74F9xtvThuxI07jA22ua/GXp3lKK4ZTFAXN3QsupiYkw3K8Qnm3n4qNPXnwGQHSYrpT0BlhvwUpKQQhUSTpVsVo3MDLab4hEONVuc20wQ0v0xBNoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QGs4eBU8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QGs4eBU8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709561596;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=A6QmjxoXan6noqde6BD8aOvSG2Tm9X9t0A12q963Qzc=;
	b=QGs4eBU8oXrBEzP7AjDj9CInEE+DxfvgBAhA+WzPVmAduSPWpo7teihYArtlj4fpyEEBUR
	7ncwqjgcq97A4nN0ij0WtyXXjaB2YXM87aIMfoSE3EgsiWFVvk4bkwCKVFEMc9cZXkYTce
	i7LXNQYGcAPvnDVofUKTVJLRVhWfgrQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-624-1SvP3154M52MqgTLh5tieQ-1; Mon, 04 Mar 2024 09:13:11 -0500
X-MC-Unique: 1SvP3154M52MqgTLh5tieQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 41B3485A58A;
	Mon,  4 Mar 2024 14:13:10 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.114])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 54A9B112131D;
	Mon,  4 Mar 2024 14:13:09 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAH2r5ms4UVc2Lzp+171j_d_ZDXrXNhu4=EFyyiub2+gVmyHQPQ@mail.gmail.com>
References: <CAH2r5ms4UVc2Lzp+171j_d_ZDXrXNhu4=EFyyiub2+gVmyHQPQ@mail.gmail.com>
To: Steve French <smfrench@gmail.com>
Cc: dhowells@redhat.com, Paulo Alcantara <pc@manguebit.com>,
    Shyam Prasad N <nspmangalore@gmail.com>,
    Bharath S M <bharathsm@microsoft.com>,
    Meetakshi Setiya <meetakshisetiyaoss@gmail.com>,
    CIFS <linux-cifs@vger.kernel.org>
Subject: Re: file size bug with some configurations for test generic/586
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <808309.1709561588.1@warthog.procyon.org.uk>
Date: Mon, 04 Mar 2024 14:13:08 +0000
Message-ID: <808310.1709561588@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

Steve French <smfrench@gmail.com> wrote:

> Noticed an interesting bug with test generic/586 where the file size
> can be reset smaller (shrinking the file) due to being sent too late
> (after the last write, instead of before it).
> 
> Trying it to Samba e.g. if I use default mount parms it works, I see
> write of 1MB at 1MB, then filesize shrinks to 1MB, then write of 1MB
> against at 1MB so file size up at its expected value (2MB) at end of
> test, but when mounting with cifsacl (perhaps due to lease breaks) I
> see different ordering of the final write and  set file size so the
> final set file size shrinks it to 1MB.
> 
> The test is intended to test:
> "Race an appending aio dio write to the second block of a file while
> simultaneously fallocating to the first block."
> so it is plausible that we are missing a lock somewhere.

What kernel and patches?

David

