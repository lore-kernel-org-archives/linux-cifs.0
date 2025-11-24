Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89201280A29
	for <linux-cifs@vger.kernel.org>; Mon, 24 Nov 2025 14:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763995491; cv=none; b=TrXPjS5P6KL2YTGgeo6rFIHb9Ax8v+RwyNU0WdApEQ/z9L3k/+vhivuUusWolYl7pkrP/fVLbFGTHP3kFYPnxzrkDVq/lBF1fkwqpcw5paoKdCAAwN6csiLZQEs8UH0ov1E3uqgKWAOTv9MkORlJq8LYQMz/yLctjlQFj3Ou4tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763995491; c=relaxed/simple;
	bh=8+tkTP0NwvtQmTjv12H6kM7UcFF8HqdpXSy+DqdelRs=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=Ui8DysSAi4KDD8gQUfHcIS1cqw9Kzg2TsOpWuO2g5SAG1VwyR5vjhP238yikevR1+fT458IojbJa84MKHzfWHqIs2vwCH9hmJhlTE8Lp7BHdGCQw5CPxUfKsKKDGjtdFPcHUjfRoZFGHzKm97LS9Xe8Cn6Z5gnHGS3aFZ5NQt+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GJJF04dg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GJJF04dg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763995488;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=m+kDkfiHcw+Tn6pSwMAenGkpyvxrtXwvdAEKNawQEMk=;
	b=GJJF04dgcqFS510P3uiVaXVTq3DlzvAjbyaFalH962e2bXtzk0aMHTbOtkhk6pyC58IeXI
	uTrItO6li94eWrzllUlm4ifztheABNln9XLcGpqaqwOtSG3Yt2/SOAu285ZANN7p5oP3h3
	T7ph6ZM3jZqons3pA0QuVUno89llLSI=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-124-vaouvjpkMqaeLHNv1BOO3A-1; Mon,
 24 Nov 2025 09:44:45 -0500
X-MC-Unique: vaouvjpkMqaeLHNv1BOO3A-1
X-Mimecast-MFC-AGG-ID: vaouvjpkMqaeLHNv1BOO3A_1763995483
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ABC9C1954B0B;
	Mon, 24 Nov 2025 14:44:43 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.14])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 689A119560B2;
	Mon, 24 Nov 2025 14:44:41 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <ad8ef7da-db2a-4033-8701-cf2fc61b8a1d@samba.org>
References: <ad8ef7da-db2a-4033-8701-cf2fc61b8a1d@samba.org> <7b897d50-f637-4f96-ba64-26920e314739@samba.org> <20251124124251.3565566-1-dhowells@redhat.com> <20251124124251.3565566-8-dhowells@redhat.com> <3635951.1763995018@warthog.procyon.org.uk>
To: Stefan Metzmacher <metze@samba.org>
Cc: dhowells@redhat.com, Steve French <sfrench@samba.org>,
    Paulo Alcantara <pc@manguebit.org>,
    Shyam Prasad N <sprasad@microsoft.com>, linux-cifs@vger.kernel.org,
    netfs@lists.linux.dev, linux-fsdevel@vger.kernel.org,
    linux-kernel@vger.kernel.org, Tom Talpey <tom@talpey.com>
Subject: Re: [PATCH v4 07/11] cifs: Clean up some places where an extra kvec[] was required for rfc1002
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3639863.1763995480.1@warthog.procyon.org.uk>
Date: Mon, 24 Nov 2025 14:44:40 +0000
Message-ID: <3639864.1763995480@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Stefan Metzmacher <metze@samba.org> wrote:

> Ok, I can just squash as well as the EIO changes below my branch
> I'll hopefully be able to post later today or tomorrow.
> 
> My idea would be that my branch would replace ksmbd-for-next
> and add your any my changes on top.

I've merged in your requested changes and repushed my branch.

David

