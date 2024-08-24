Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2E02757F3
	for <linux-cifs@vger.kernel.org>; Sat, 24 Aug 2024 12:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724501758; cv=none; b=CFKmqpkQHUPemsd9c6ILFJ9Yto2hGu2nbf2nqFoAdbFHHZRHjTUCwGfgb6kwtFiuyv0HTCOa4rGvTsYeiIvBA8O901zYcS4d+xXf/ZZPngsIlu3/5wSxgG2giwiWk4KkrQJM72zifHVEH4sUB6ENslJCe5z8HogKlJh9WuwihKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724501758; c=relaxed/simple;
	bh=eTjLwNVe+NgIfMMx4jiH9oWNDP9wqAWhZgSLtM6Tq9s=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=MTRVAtY1gvWd8y2if1utg7fmP3wAx4il3RBuYc81MeCJJYikOUs1KeoegGxdiNCKU3s85O/rU145VkIij2Akb4q33cByVmGCEGc6YmgTF0WCryVht5hu2vQoZP3G2a3qoJeB0PcTb3fwiaMvwc/IQOmR0qcwrkZWAqTwV98ChEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WvSWNy8i; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WvSWNy8i"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724501755;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eeGNoUo/w5GtGFvsb/vgChqvg4TfOgbi6ZZPKp2iCis=;
	b=WvSWNy8i1lvkpyZ4fHFxS6ZwHFH/gtl7y5PX3YAhnjrohwaA7akWkeDbkY2rECoANK5fFK
	bFeRT0GOLAc2tR/+DmXhGcSNUGSYcjrZ//sn6YQruZxUQz8YEpFiPhuESppoSWJkPhRHjJ
	rQfEIBYEG8f+vesLnV76ECNM0op20NQ=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-401-8rUVZ29xPLi2FlbMJPiRmg-1; Sat,
 24 Aug 2024 08:15:53 -0400
X-MC-Unique: 8rUVZ29xPLi2FlbMJPiRmg-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EB29519560B0;
	Sat, 24 Aug 2024 12:15:52 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.30])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1524719560A3;
	Sat, 24 Aug 2024 12:15:51 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAH2r5muJabg=dB9EkuZD26+2mnQGRYRbpbQ96UxTk2UF4ZNQ6g@mail.gmail.com>
References: <CAH2r5muJabg=dB9EkuZD26+2mnQGRYRbpbQ96UxTk2UF4ZNQ6g@mail.gmail.com>
To: Steve French <smfrench@gmail.com>
Cc: dhowells@redhat.com, CIFS <linux-cifs@vger.kernel.org>
Subject: Re: generic/075 and generic/112 regression
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <564362.1724501750.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Sat, 24 Aug 2024 13:15:50 +0100
Message-ID: <564363.1724501750@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Steve French <smfrench@gmail.com> wrote:

> We are still getting a failure with the netfs/cifs changes in
> generic/075 and generic/112
> =

> http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builders=
/9/builds/119

What's in the output files for 075?

I'm seeing:

+    fsx (-d -N 1000 -S 0) failed, 0 - compare /root/xfstests-dev/results/=
/smb3/generic/075.0.{good,bad,fsxlog}
+mv: '/root/xfstests-dev/results//smb3/generic/075.0.fsxlog' and '/root/xf=
stests-dev/results//smb3/generic/075.0.fsxlog' are the same file

David

