Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3D7B3009F1
	for <linux-cifs@vger.kernel.org>; Fri, 12 Sep 2025 12:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757680145; cv=none; b=ENLbKrqe12HhkZtWVP/Kw0Gk4zE+luKDhjYV7CgGS88IoCjiMWRTYSNsCUgs306SS9LHQpcbYfkmgCM3uWbpf3ULyIO/IIcdG9bfDds3ehrOzjtTsBF5xK9lTZpeVn5tXi5BkuucQrb4SNzHJa9CLYymMUKjpoUsSWH/B5i1XSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757680145; c=relaxed/simple;
	bh=mnhyYYcjQw8y1xogODaBHyRs79d38+9qOux8OQfT9ms=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=juhJBGKbwlsHUsPcHaghW0ayg5WhRIjeUeKwTsIPjQXUbyv+i/ODWHQOwK0Ky7o8AUCNqtLRaKOAAhyouKyYpiG7Q4IAy4nvpRjL2V6A9GAJPxK7+PSv5NbGfDNJIH1q2Cb/6VXuOAStX0G4Ndu5Bne7VWxz0pMI2zpvLUZpyRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HQB/DwCF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HQB/DwCF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757680142;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7tPqOlKN7cM1OwbgJnskpqdY2T1yziMKm0eMxicStGU=;
	b=HQB/DwCFDs5LwtXQO6NEm2NidFXKZMrbWMhOIjctStWRUUrG5pVHxSM5l/auoayvSjc4cq
	ShselKD6yOehGVLjzn+mYhCPzhR3Ybb1IoITAEGVBx5jgwcKeXj4StPP5QPQ68YTBhGCAJ
	yEPXqHG5aZTzhqXqaKZJUIS1Jl5sTBY=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-377-KmIXrDQfPY2pdT635jXqSg-1; Fri,
 12 Sep 2025 08:28:59 -0400
X-MC-Unique: KmIXrDQfPY2pdT635jXqSg-1
X-Mimecast-MFC-AGG-ID: KmIXrDQfPY2pdT635jXqSg_1757680138
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C59891956087;
	Fri, 12 Sep 2025 12:28:57 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.6])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 04DA21800447;
	Fri, 12 Sep 2025 12:28:54 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <d3712068-ec74-4adb-9e1b-0f8cd6c39ad5@samba.org>
References: <d3712068-ec74-4adb-9e1b-0f8cd6c39ad5@samba.org> <20250904211839.1152340-1-dhowells@redhat.com> <20250904211839.1152340-3-dhowells@redhat.com>
To: Stefan Metzmacher <metze@samba.org>
Cc: dhowells@redhat.com, Steve French <sfrench@samba.org>,
    Paulo Alcantara <pc@manguebit.org>, linux-cifs@vger.kernel.org,
    Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
    netfs@lists.linux.dev, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] cifs: Clean up declarations
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2168724.1757680133.1@warthog.procyon.org.uk>
Date: Fri, 12 Sep 2025 13:28:53 +0100
Message-ID: <2168726.1757680133@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Stefan Metzmacher <metze@samba.org> wrote:

> can you please drop the changes to smbdirect.h?
> (This is the only part I really looked at).
> They leave strange comments around and will likely
> cause conflicts with my current work.

Sure...  Assuming Steve is willing to take these patches.  There's also an
issue with one of the configuration combinations I didn't test - it probably
just needs a #include adding.

David

