Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCEF52BEFEB
	for <linux-cifs@vger.kernel.org>; Wed, 24 Jun 2026 11:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782298989; cv=none; b=X0XFa6Yois0rK1O5aGo6juA49STYjvWdqMn94Gdb2qodHuL64oaf0eC1C2eQoHNP+/vo22BXLZpjHVEoiaS3XKeTnJtsIH5MVmqsIGwU/VdP1++Dl0nPgQSF9FlcgU7PAg0A7DPPNPCfLxEuPKTaFcaRXnZlS4leAW0e3vuNR4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782298989; c=relaxed/simple;
	bh=2E0/fy194XrX/ufJIIITGIZyvzOPcFhtKiH6tWRTXD4=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=TBTKq0An2El7tCufIBPmnsdDQDs1bQZ4UpOSO9pYtwV6k4bEGxl1VMgruGcN4nrN0PQhUEQlvKpxYLwy0z1oxGO2iJv3JHdnON03o8mR/lvCz2UgzvLNPnX6DAkunpRjvkjemXUsMb20mWfuoc59ZB8FkHBhMBS6SECbjKbVlNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KsHfAS7o; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KsHfAS7o"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782298987;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Sp4RxWhiqLp3dU/cEI7ohxd3YvMu21Ic0dUIFdb7BDA=;
	b=KsHfAS7o4qcCRRtTrsopIYq5c00NpJkCTVfRnQSAb9t+4TJIdNBJ7WohkO2uH3a6aZBhLy
	OoRsbYel76+bR0p/KcUCkRr1eCf1lXbqaHXuymnR1S6a8gV7lLdLaAaqwk15uNH8m3f3Bm
	37AQTIsDCOKsJNQ7DNuGwOPYwW/6krA=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-665-wsPcFl0KNxSnxpT9V6VKJA-1; Wed,
 24 Jun 2026 07:03:02 -0400
X-MC-Unique: wsPcFl0KNxSnxpT9V6VKJA-1
X-Mimecast-MFC-AGG-ID: wsPcFl0KNxSnxpT9V6VKJA_1782298981
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C55E81801BEA;
	Wed, 24 Jun 2026 11:03:00 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.44.49.152])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 65E491955F6F;
	Wed, 24 Jun 2026 11:02:57 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <498534d3-e82e-40ce-bc7d-230580b2fcae@chenxiaosong.com>
References: <498534d3-e82e-40ce-bc7d-230580b2fcae@chenxiaosong.com> <33cc8eb4-8831-49b0-80d6-b06544a37920@chenxiaosong.com> <FA1EF9EEE4C1415E+20260530011403.1686344-1-hongao@uniontech.com> <2912807.1782231053@warthog.procyon.org.uk>
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: dhowells@redhat.com, hongao <hongao@uniontech.com>,
    Paulo Alcantara <pc@manguebit.org>, netfs@lists.linux.dev,
    linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
    syzbot+3c74b1f0c372e98efc32@syzkaller.appspotmail.com,
    Steve French <smfrench@gmail.com>,
    Namjae Jeon <linkinjeon@kernel.org>,
    "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH] netfs: Fix UAF in netfs_unbuffered_write() on failed preparation
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2961398.1782298976.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Wed, 24 Jun 2026 12:02:56 +0100
Message-ID: <2961399.1782298976@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

I suspect the issue is this bit in netfs_unbuffered_write():

	for (;;) {
		...
		netfs_get_subrequest(subreq, netfs_sreq_trace_get_resubmit);

		if (stream->prepare_write) {
			stream->prepare_write(subreq);
			__set_bit(NETFS_SREQ_IN_PROGRESS, &subreq->flags);
			netfs_stat(&netfs_n_wh_retry_write_subreq);
		} else {
			struct iov_iter source;

			netfs_reset_iter(subreq);
			source =3D subreq->io_iter;
			netfs_reissue_write(stream, subreq, &source); <----
		}
	}

This doesn't happen with AFS because it has a ->prepare_write() method.  D=
oes
this change fix the problem for you?

diff --git a/fs/netfs/direct_write.c b/fs/netfs/direct_write.c
index 25f8ceb15fad..9f6258da45d6 100644
--- a/fs/netfs/direct_write.c
+++ b/fs/netfs/direct_write.c
@@ -190,12 +190,6 @@ static int netfs_unbuffered_write(struct netfs_io_req=
uest *wreq)
 			stream->prepare_write(subreq);
 			__set_bit(NETFS_SREQ_IN_PROGRESS, &subreq->flags);
 			netfs_stat(&netfs_n_wh_retry_write_subreq);
-		} else {
-			struct iov_iter source;
-
-			netfs_reset_iter(subreq);
-			source =3D subreq->io_iter;
-			netfs_reissue_write(stream, subreq, &source);
 		}
 	}
 =


David

