Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCEE6205AA1
	for <linux-cifs@vger.kernel.org>; Mon, 10 Nov 2025 16:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762790430; cv=none; b=Qf9Ze3yctzgWJNlKLNZl+I2+VgD6W2LvBHihUWZpELgyeAPZeD1/80yzmTNIlwWmLD1CnDzbqHO0P85z9pVgcJ9tSckU1cVG4M4UcKaNujCxk6qGVcfIRHxOw41NMMZghEr9seAVCi7zibiLqsvYXXi6GSeL8yNQxy5kb3lXI2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762790430; c=relaxed/simple;
	bh=AhbhQ67wwQhQ4c07srXeKmzRK8+FD0WRq0ZbeCnH4oc=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=UeaQhf0x1LTOI/0O7nPfUj42DSVvhoQBuNaAYZQ3EQdY1E4gcjiOEVGJcE3fNj8pAtviabyO9nrCYX390v915PcajaTLsd2u5pbwSL7NBqz9ZrSXS4Y1wMIcpfm+wFZkVhr8y1BsRSEpWe0MBj8sAkoM0SJ5MvU2DwLSnPEwEaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WVTXtYSJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WVTXtYSJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762790427;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=T8hqKhR4PO1YyDfo47togD7d/nqY6gzVyhXnj63GbVQ=;
	b=WVTXtYSJy8AiDEgyPEDx/+wD7QXMBOMndw1ZIQZvQDYdztKsmcaRmk6erZ198dnFRG2bY4
	V/gSv29SLU/yvC4EYxlW3cSuIss5QXas/z3NZUIdfvaBLP4irOyF1Bz5OPeDnUpZ7nEZDg
	qTyDl6LKQJoMpAwr+OvQw9kXh9tZi58=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-586-TxtdQIawM9irXdSNeM31cQ-1; Mon,
 10 Nov 2025 11:00:24 -0500
X-MC-Unique: TxtdQIawM9irXdSNeM31cQ-1
X-Mimecast-MFC-AGG-ID: TxtdQIawM9irXdSNeM31cQ_1762790422
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1D7A51801235;
	Mon, 10 Nov 2025 16:00:22 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.87])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7C9B51800576;
	Mon, 10 Nov 2025 16:00:19 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAGypqWw0bnE7_=49HSxgExouk4s5PVFQ6gVH50wrE8_=4b5vAg@mail.gmail.com>
References: <CAGypqWw0bnE7_=49HSxgExouk4s5PVFQ6gVH50wrE8_=4b5vAg@mail.gmail.com> <YT1PR01MB9451424C6870795133FB7C96B3A72@YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM> <36fb31bf2c854cdc930a3415f5551dcd@izw-berlin.de> <CAH2r5mtNtyqZBpT8hL2xvZ8QYWAymrPR-5LmpZbeTHr_1ATPWg@mail.gmail.com> <uildcjpqxzc5nckupgdeeifkrqwrau2qxuc2df2uxuyys3i2k2@iz2bmi6yojyu> <YT1PR01MB945191C652AEE173CEADBA3EB3A12@YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM> <aaloi77h2f5xolhrnegxsxntqp2jopwisunmjfp45idsoockpy@cy5agf2oqjop> <YT1PR01MB9451A0F623371F50E77CC1C9B3AD2@YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM>
To: Bharath SM <bharathsm.hsk@gmail.com>
Cc: dhowells@redhat.com, Mark A Whiting <whitingm@opentext.com>,
    henrique.carvalho@suse.com, Enzo Matsumiya <ematsumiya@suse.de>,
    Steve French <smfrench@gmail.com>,
    Shyam Prasad <nspmangalore@gmail.com>,
    Paulo Alcantara <pc@manguebit.org>,
    "Heckmann,
                         Ilja" <heckmann@izw-berlin.de>,
    "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Subject: Re: [[ EXT ]] [BUG REPORT] cifs/smb data corruption when writing, x86_64, kernel 6.6.71
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <931047.1762790417.1@warthog.procyon.org.uk>
Date: Mon, 10 Nov 2025 16:00:17 +0000
Message-ID: <931048.1762790417@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Bharath SM <bharathsm.hsk@gmail.com> wrote:

> observed by comparing expected vs actual outputs.  Easy reproducer:
> 
> 	done | dd ibs=4194304 iflag=fullblock count=10240000 of=remotefile
> 8999946
> <corrupt lines shows here>

That reproducer would seem to be invalid shell.  Were there lines preceding
the "done" that need to be included?

David

