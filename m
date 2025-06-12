Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04FE6219FC
	for <linux-cifs@vger.kernel.org>; Thu, 12 Jun 2025 14:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749738042; cv=none; b=eGE4EGEF0ZVDrLSYDBNxf/Ulx6cj7aIElPHEN9BSl7bV2mMS/p9BSRVL6JRlEBp4gZnNzIj2WPunZBKsWKuyA2VVYllhxxO3+rxsCk5P7dTMcdTNrHO4jdsP51LhDs+coKk6PJeEEuYAFdaORgO1PHeRD7cRO4WGXm8cgm8qybM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749738042; c=relaxed/simple;
	bh=yf0Y1FJ2JrYAktAReh3XEe2xa8mBby+/EYAlNcJsTh8=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=hk5o8J2/qSdlC0FbNzKFdkU6Fszt8Wl0zch/M9rWvvtJ1Xf+RmJxyiBg5c7uxVWBIRgZ+zL1315gqhccwnCPWwB9tZw1JjBjyjo9hbJHrCx8C5/CJcfA65pkW0d9NvuEK92ZtSB0PyaNB11b2dAmn94pvxE7I5ZMiioea+7LENE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TZKXJ/xR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TZKXJ/xR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749738039;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yf0Y1FJ2JrYAktAReh3XEe2xa8mBby+/EYAlNcJsTh8=;
	b=TZKXJ/xReMbYA8yCqs8Cryw5JzAPaAl0kSiGhiy2AR96ruk9A9KhlLzunpsEL5FnNzSdey
	0SGYRTUUvLvKOKhkNMEpU7ghlXpsx2z1+L+xaD8dilY+0e47TqFeYoS4Py1HDcVbkTM/sB
	jhnR2RbtscGu2DFPJGuFehp35oXE2T4=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-508-p-dOTvohMMGpnTaJxJOaJA-1; Thu,
 12 Jun 2025 10:20:36 -0400
X-MC-Unique: p-dOTvohMMGpnTaJxJOaJA-1
X-Mimecast-MFC-AGG-ID: p-dOTvohMMGpnTaJxJOaJA_1749738035
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2344B195606B;
	Thu, 12 Jun 2025 14:20:35 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.18])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2A34A195E340;
	Thu, 12 Jun 2025 14:20:32 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAH2r5muQB8CgN7r8SE8okujV2rpvQoKYAP=yD95a_R1hLjKWqA@mail.gmail.com>
References: <CAH2r5muQB8CgN7r8SE8okujV2rpvQoKYAP=yD95a_R1hLjKWqA@mail.gmail.com>
To: Steve French <smfrench@gmail.com>
Cc: dhowells@redhat.com, CIFS <linux-cifs@vger.kernel.org>,
    Paulo Alcantara <pc@manguebit.com>,
    Shyam Prasad N <sprasad@microsoft.com>,
    Bharath S M <bharathsm@microsoft.com>
Subject: Re: netfs hang in xfstest generic/013
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <466170.1749738030.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Jun 2025 15:20:30 +0100
Message-ID: <466171.1749738030@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

Steve French <smfrench@gmail.com> wrote:

> I saw a hang in xfstest generic/013 once today (with 6.16-rc1 and a
> directory lease patch from Bharath and the fix for the readdir
> regression from Neil which look unrelated to the hang).
> =

> http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builders=
/5/builds/487/steps/29/logs/stdio
> =

> There were no requests in flight, and the share worked fine (could
> e.g. ls /mnt/test) but fsstress was hung so looks like a locking leak,
> or lock ordering issue with netfs. Any thoughts?
> =

> root@fedora29:~# cat /proc/fs/cifs/open_files
> # Version:1
> # Format:
> # <tree id> <ses id> <persistent fid> <flags> <count> <pid> <uid>
> <filename> <mid>
> 0x5 0x234211540000091 0x5c5698c8 0xc000 2 32005 0
> f24XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 6928

Can you grab the contents of /proc/fs/netfs/{stats,requests} ?

I presume you're running without a cache?

Would you be able to try reproducing it with some netfs tracing on?

David

