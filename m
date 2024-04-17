Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2C8113CF8D
	for <linux-cifs@vger.kernel.org>; Wed, 17 Apr 2024 12:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713356337; cv=none; b=Eh9iaauFpygAEGVihRBSejs5VlFXG4SofD8mi+6VRuYwClCiUSWO4lftjtdNtXVqCWHCuGofgiWIo3nHe/yOjEhO7OplaDly50jgn+t1n1FHCcOTMsDfihB0p9yzjxiU4n7IuPOdp+RzuNK62IqR6fAog4AMZC+EGJdfEkdY+hM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713356337; c=relaxed/simple;
	bh=e5g+9Z9HtsHEKxe2LaOAecd54UvAXCkGQ96msWQj9N4=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=rHwTIDU6RWMpULoZGU8uib66UBbucbN3zkEaffDoMJ8stDTctZXxtOciGhs8IIfnWYAge43RnXUtLF406pQQ5eRHkQNgelQZb4zTRYPv44KaUmC+zvVjXMcC8rz2ZzIgJxY6scrNPsfBefi5rzU7GuykTLkjBM5/vQjnPKyqD8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N0Dl0Gbk; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N0Dl0Gbk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713356334;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=e5g+9Z9HtsHEKxe2LaOAecd54UvAXCkGQ96msWQj9N4=;
	b=N0Dl0GbkZMt1vyHNAwaGp/TiGAWRizoqK4tmldWVtNc7TBk/Eb8+VRxNVfnNXP6OAlQ9C7
	r0ZtnAKjyFulRM9xZcT8ELnmQl4hnwv3hKj0rUWUNkAXvAL3bHNSgTGeersl1DQBAMA+Tm
	R9TxLFsSVhTMdhU40zYel/LFZ1PFj5A=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-577-HZb4tYkCOiuraGxVwvC9Yw-1; Wed,
 17 Apr 2024 08:18:48 -0400
X-MC-Unique: HZb4tYkCOiuraGxVwvC9Yw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D17DE3C0253F;
	Wed, 17 Apr 2024 12:18:47 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.200])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 762A6112132A;
	Wed, 17 Apr 2024 12:18:46 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <202404161031.468b84f-oliver.sang@intel.com>
References: <202404161031.468b84f-oliver.sang@intel.com>
To: kernel test robot <oliver.sang@intel.com>
Cc: dhowells@redhat.com, oe-lkp@lists.linux.dev, lkp@intel.com,
    Steve French <sfrench@samba.org>,
    Shyam Prasad N <nspmangalore@gmail.com>,
    "Rohith
 Surabattula" <rohiths.msft@gmail.com>,
    Jeff Layton <jlayton@kernel.org>, netfs@lists.linux.dev,
    linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org,
    samba-technical@lists.samba.org
Subject: Re: [dhowells-fs:cifs-netfs] [cifs] b4834f12a4: WARNING:at_fs/netfs/write_collect.c:#netfs_writeback_lookup_folio
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <164953.1713356321.1@warthog.procyon.org.uk>
Date: Wed, 17 Apr 2024 13:18:41 +0100
Message-ID: <164954.1713356321@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

When I try and do "sudo bin/lkp install job.yaml", I get an error because
Fedora 39 doesn't have a libarchive-tools package.

Also, I can't find a "filemicro_seqwriterandvargam.f" script, presumably
because it would get patched into existence by the failing install step above.

David

