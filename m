Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7EFA442B3A
	for <linux-cifs@vger.kernel.org>; Thu, 23 Jul 2026 12:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784809422; cv=none; b=OoA74b6/39TjPFClCQe5nb6R9RW/P3Q/xnWkMaIcmPXfA7H3j2f3GiYPHBn5UAMimXFZXQBLW2NSvIqqqI6U3oB4AL+iZnzTXQ8IYJJzY+kg+G+aSIFqW+STm0SFfhjntdsG99xgxNqtEM7RdeZG0l9F+/n3QV6c9gBIUDmQg68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784809422; c=relaxed/simple;
	bh=5/b0TtXzdtqfWWfg6M0ArLBMS5/qT/WO6t/bUEpG8rY=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=eJUSO+vBrSqKXtn+uM7xihhZ97atyzxtsG/lSsm7cunOauZicmUAByyAi7BiSaDcSoirFamdHxhmY2ooZR8Gym/3Tak4bvAmuezAxDT9S/z1mlpiadvCzsPr/BKyWJm6VIc6iFay7kn16J6BGHoYoz5USlawTB/AKycqdk2I7Mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bXlQ1lbg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bXlQ1lbg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784809419;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=h6sLo2Oh1+AR7rTMKks8nXjJcufxaJIsKON8cMnqlYQ=;
	b=bXlQ1lbgph5LiwbNOCFYV9LrJ7dZBn5SUpSUaB6matCQC+xuJMx9tl92lJdIJk36QShNPF
	MojsKRCjkBo17YRDlxNg1k9ikUOZtAOqw9xZ/GbRr7nDBmXBClXg+XywMqj9vQNMSOOHHS
	KbjRcKtoa25BpIYFNSaDf8t0YHI8+ao=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-684-M7yQQaqzNBWL9i1HuCz3cQ-1; Thu,
 23 Jul 2026 08:23:36 -0400
X-MC-Unique: M7yQQaqzNBWL9i1HuCz3cQ-1
X-Mimecast-MFC-AGG-ID: M7yQQaqzNBWL9i1HuCz3cQ_1784809415
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C7B721830319;
	Thu, 23 Jul 2026 12:23:34 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.44.33.159])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A3BDD1800361;
	Thu, 23 Jul 2026 12:23:31 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20260722-net-dns_resolver-v1-1-c3385898ccf9@manguebit.org>
References: <20260722-net-dns_resolver-v1-1-c3385898ccf9@manguebit.org>
To: Paulo Alcantara <pc@manguebit.org>
Cc: dhowells@redhat.com, "David S. Miller" <davem@davemloft.net>,
    Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
    Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
    Frank Sorenson <sorenson@redhat.com>, netdev@vger.kernel.org,
    linux-cifs@vger.kernel.org, Pierguido Lambri <plambri@redhat.com>
Subject: Re: [PATCH net-next] net: dns_resolver: allow shorter names in dns_query()
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <615375.1784809410.1@warthog.procyon.org.uk>
Date: Thu, 23 Jul 2026 13:23:30 +0100
Message-ID: <615376.1784809410@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Paulo Alcantara <pc@manguebit.org> wrote:

> Customer reported a problem with mounting CIFS shares where the server
> hostname was 2 chars long.  Turned out that the CIFS client wasn't
> able to resolve NetBIOS names shorter than 3 chars.
> 
> Fix this by allowing a minimum of one character per hostname in
> dns_query().
> 
> Reproducer with samba server:
> 
>   # 'ab' and 'srv' hotnames resolve to same ip address
>   $ ssh srv ln -s 'msdfs:\\ab\\share' /home/shares/dfs/link1
>   $ mount.cifs //srv/dfs/link1 /mnt -o ... [EINVAL]
> 
> Reported-by: Pierguido Lambri <plambri@redhat.com>
> Signed-off-by: Paulo Alcantara <pc@manguebit.org>

Acked-by: David Howells <dhowells@redhat.com>

