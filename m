Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA8537647E
	for <linux-cifs@vger.kernel.org>; Thu,  1 Oct 2026 13:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790862735; cv=none; b=IiPdXvR1WPmiTj4SAn5c+wQd8EIZAWXOiDJPHCeg5xLhbYaB+N8zmSE+VmulsMretmU6u0XJa7dqxWg/XCzX6XXG743vi8jvMvoOcYvBcdz+4aXEaVBJfR8Ohlp5afiQjKG76lfiF5Nrzx2/iSDlTlwfSSbI8yugaCNlAZuDHsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790862735; c=relaxed/simple;
	bh=0geIIBAtChqx0SPrXodBDN0wwm8n774sD/kCINfRRVI=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=eAYBhPGxiFf0LxpdXHU3WZf0L+FmbEzCD73i2tbcUFl5AS/x7Pez4Y+DQ3ZkYtzFw41pFi5T4tPakAuwEjgS5pxdyyhkWO6OKRy+6N04unLohYPoA9TW/3G2M4g6vcnmy0xdYsY/8wO1dDZbdW5hxgDagHskA+hShB3PYofm5TY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JOONMuVZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JOONMuVZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790862732;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JjcPPUA2+KSJwXDBVE75ZLKJDqcpCkUXLHxsXrz7loQ=;
	b=JOONMuVZv4xh8ez/M7Hza93kVux3MQZt5RGgwuZ2UHDimKXt2abaSH0R619Tk/IrLjwG/X
	Kl/rn/FUvyOmgRE5IF9iUDx4MymcyqzDl7UTVzchvLw9am/FOt1QvlCTWCmI41ervM98o1
	48cpKWUkN/nlzjMyu7PQXMZIz49dr7w=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-677-uJbyo1fROuqS7vWfhzcp3A-1; Thu,
 01 Oct 2026 09:52:08 -0400
X-MC-Unique: uJbyo1fROuqS7vWfhzcp3A-1
X-Mimecast-MFC-AGG-ID: uJbyo1fROuqS7vWfhzcp3A_1790862726
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 26FDD18011FE;
	Thu,  1 Oct 2026 13:52:05 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.44.32.54])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CC61E1800299;
	Thu,  1 Oct 2026 13:51:57 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20261001091239.3343034-4-dhowells@redhat.com>
References: <20261001091239.3343034-4-dhowells@redhat.com> <20261001091239.3343034-1-dhowells@redhat.com>
To: Christian Brauner <christian@brauner.io>
Cc: dhowells@redhat.com, Paulo Alcantara <pc@manguebit.org>,
    Matthew Wilcox <willy@infradead.org>,
    Namjae Jeon <linkinjeon@kernel.org>,
    Marc Dionne <marc.dionne@auristor.com>,
    Stefan Metzmacher <metze@samba.org>,
    Eric Van Hensbergen <ericvh@kernel.org>,
    Dominique Martinet <asmadeus@codewreck.org>,
    Ilya Dryomov <idryomov@gmail.com>, netfs@lists.linux.dev,
    linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org,
    linux-nfs@vger.kernel.org, ceph-devel@vger.kernel.org,
    v9fs@lists.linux.dev, linux-fsdevel@vger.kernel.org,
    linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v15 03/10] netfs: Add some tools for managing bvecq chains
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3609011.1790862716.1@warthog.procyon.org.uk>
Date: Thu, 01 Oct 2026 14:51:56 +0100
Message-ID: <3609012.1790862716@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Hi Christian,

Could you add:

	#include <linux/mempool.h>

to fs/netfs/internal.h if you apply this?  One of the headers I'm using must
bring it in conditionally because it's not pulled in when Paulo builds it.

Thanks,
David

