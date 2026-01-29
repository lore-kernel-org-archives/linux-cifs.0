Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 204073A1CD
	for <linux-cifs@vger.kernel.org>; Thu, 29 Jan 2026 13:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769694198; cv=none; b=pMGOBEV9ZR1TDjJ/hEgsMuAVJuC82BKd1F2cDLDwrYT/rhyRkdMXowk2QzdOeUw+y/eHbs4fwtn8RuvwiunyluJd9jSUnZaOUAP/+KyeBszAkpz8fw+TgPWFaj6XbmGtjwg2k8eqhBauKybWcfrumcNqHdAXpgJz1zN1C48GNSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769694198; c=relaxed/simple;
	bh=nhqNTCDTUD49j0pZWGNXwmhDlM9COb2wLFllUo+LSm8=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=O37dYgq23qxPwHJyuM9betqeJ2aw6sUbbWLVU2p3Rx15m6QNkGO7MStMkL9SZZqJk1+qhtzANH/PAYdfLoIIIVrAA2q8kTvXTEeb8IMlrh12aivY967N2OT/hGazrd4z1yO99LQG/7paHbdaJH9LYk2hdw2B6gH7ABcFJLlcvnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JWl4mTHh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JWl4mTHh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769694196;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZLKUtUm5065sq89vfcWLNBU/FPKK0LiPatUESAJe6tg=;
	b=JWl4mTHh540Mt2sD5mv5mMK6LsqJc9VX0o5MWSh2clSUdZdGnN+hz+8AJ79Unm9OlJ5uvq
	cg9Gic0ulJv5EDrTIHTeYiTBIBp8S8d75bi6HpH//P5ofDWYFIyOXu98dQyF1gYNAr5asZ
	iV4d4in3AVrEz8d4hH+uqtbC2+EmoKI=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-516-mnVeEMGrOkGmME9lO2RfRQ-1; Thu,
 29 Jan 2026 08:43:12 -0500
X-MC-Unique: mnVeEMGrOkGmME9lO2RfRQ-1
X-Mimecast-MFC-AGG-ID: mnVeEMGrOkGmME9lO2RfRQ_1769694191
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 944A118005A7;
	Thu, 29 Jan 2026 13:43:11 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.44.33.164])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7995D1956048;
	Thu, 29 Jan 2026 13:43:09 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CANT5p=qptmBxhOoO_y+OnuX+_rjMeqGUTJ87y_tA+eVX6eJqBQ@mail.gmail.com>
References: <CANT5p=qptmBxhOoO_y+OnuX+_rjMeqGUTJ87y_tA+eVX6eJqBQ@mail.gmail.com> <20260120062152.628822-1-sprasad@microsoft.com> <1652302.1769037531@warthog.procyon.org.uk>
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: dhowells@redhat.com, linux-cifs@vger.kernel.org, smfrench@gmail.com,
    pc@manguebit.com, bharathsm@microsoft.com,
    Shyam Prasad N <sprasad@microsoft.com>
Subject: Re: [PATCH 1/4] netfs: when subreq is marked for retry, do not check if it faced an error
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2226336.1769694188.1@warthog.procyon.org.uk>
Date: Thu, 29 Jan 2026 13:43:08 +0000
Message-ID: <2226337.1769694188@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Shyam Prasad N <nspmangalore@gmail.com> wrote:

> > I think I suggested moving the check for NETFS_SREQ_NEED_RETRY up in the
> > function - above any checks of subreq->error, but after the initial stat
> > counting.
> 
> So you want to do this check regardless of whether there's an error or not?

Yes.  There's likely only to be a need to retry if there's been an error
(though there is the possibility of the filesystem returning a short read,
say, and needing a retry to complete it).  In any case, we can make the
setting of this flag up to the filesystem: does it think that a retry is
warranted?

> In that case, I think I'll still need to check if there is an error to
> set NETFS_RREQ_PAUSE only on error, right?

It needs to be set if a retry is requested as the retry thread will wait for
outstanding ops to quiesce - and if more are still being generated, that's
potentially a problem.  And for AFS, for example, the need to do a retry might
mean that we need to switch server - so we probably do want to throw a hold on
further subrequest generation until we've probed the problem.

David

