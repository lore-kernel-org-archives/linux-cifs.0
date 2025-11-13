Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D714E23C8CD
	for <linux-cifs@vger.kernel.org>; Thu, 13 Nov 2025 13:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763042266; cv=none; b=RpiQ2Ecva6FdWMJmGj+FKhrUouoGAdmHOV/eNlBIqr21T0joC4lRhhVe4xcx7ovr1cYS5rFChWZc6rJXSzS+n9v38hRGwTF/LErZl9tUv8eXbmRkxNipHTiFUnEH6pM9WIjwfxXiwIJ0jVrsq73KK/wGwc/jCN/1kDrRznlurgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763042266; c=relaxed/simple;
	bh=JLeLFFZYZwY6fpyJMEn28rycTYvDbk94qpZ/GmXSaCk=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=Mr4gcr95FXkxUMEGOWfZa2LQozIVM/dhUhMQudMunFVzAbBRULtntm6GATvoYikpL1iOxU+MMZhC5ekl+YCYZeH4G9WZC/gbw1M/DTok5D3OsGrJ9OnAat42vJCbRgzo86Jo8rZczeXf+3KEfVes2HBM8/GRbOm3SzaaDIMAq/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bSYr8Byn; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bSYr8Byn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763042263;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NGLKxXQF0F/XWTApJ0iL6QP8bi29GckGnnFKci2qgBI=;
	b=bSYr8BynPRWutWyIKa2IG2lQaihhMAWcvEk0Mgnc0xSX32rpIbR/mSNgFIMH5sZeDOOCQG
	SVjinlJ/jTb2gddSWfPTn2fsZmO/oz3U3QekpOFVX2WBzwn5ZVtyivUdaCSMdbb6t0zWh4
	neF0OeJ3QpgOkkaHaU8rcHqlS9c+Y4o=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-683-sp60RIDPOj29y3R-3xX3ng-1; Thu,
 13 Nov 2025 08:57:37 -0500
X-MC-Unique: sp60RIDPOj29y3R-3xX3ng-1
X-Mimecast-MFC-AGG-ID: sp60RIDPOj29y3R-3xX3ng_1763042256
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E71201801235;
	Thu, 13 Nov 2025 13:57:35 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.87])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2BF13180097D;
	Thu, 13 Nov 2025 13:57:32 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CANT5p=p4KSRsCAB-peTKehvsYYiuOxy3qLNDO9j5H+5PP_eiyw@mail.gmail.com>
References: <CANT5p=p4KSRsCAB-peTKehvsYYiuOxy3qLNDO9j5H+5PP_eiyw@mail.gmail.com> <YT1PR01MB9451424C6870795133FB7C96B3A72@YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM> <36fb31bf2c854cdc930a3415f5551dcd@izw-berlin.de> <CAH2r5mtNtyqZBpT8hL2xvZ8QYWAymrPR-5LmpZbeTHr_1ATPWg@mail.gmail.com> <uildcjpqxzc5nckupgdeeifkrqwrau2qxuc2df2uxuyys3i2k2@iz2bmi6yojyu> <YT1PR01MB945191C652AEE173CEADBA3EB3A12@YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM> <aaloi77h2f5xolhrnegxsxntqp2jopwisunmjfp45idsoockpy@cy5agf2oqjop> <YT1PR01MB9451A0F623371F50E77CC1C9B3AD2@YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM> <CAGypqWw0bnE7_=49HSxgExouk4s5PVFQ6gVH50wrE8_=4b5vAg@mail.gmail.com> <958479.1762852948@warthog.procyon.org.uk> <CANT5p=rh7BQBnwNYLxHtFw=YUhAGVnskJ=33i6Eg4porU-X+5A@mail.gmail.com> <CANT5p=px8Lh1C2O0F8i1htoMACWZbLPfw0NEzUco5Njss2c7pQ@mail.gmail.com> <1392200.1762971247@warthog.procyon.org.uk>
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: dhowells@redhat.com, Bharath SM <bharathsm.hsk@gmail.com>,
    Mark A Whiting <whitingm@opentext.com>, henrique.carvalho@suse.com,
    Enzo Matsumiya <ematsumiya@suse.de>,
    Steve French <smfrench@gmail.com>,
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
Content-ID: <1640438.1763042251.1@warthog.procyon.org.uk>
Date: Thu, 13 Nov 2025 13:57:31 +0000
Message-ID: <1640439.1763042251@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Shyam Prasad N <nspmangalore@gmail.com> wrote:

> +
> +			/* boundary check before the folio is accounted */
> +			if ((max_pages - nr_pages) <= 0 ||
> +			    (*_len + len) >= max_len ||
> +			    (*_count - nr_pages) <= 0) {
> +				folio_unlock(folio);
> +				folio_put(folio);
> +				xas_reset(xas);
> +				break;
> +			}
> +

I suspect that whilst this will work, it will mean that you can never append a
partial page to a write op; a partial page will always have to start a new RPC
call.

So if you do:

	fd = open("/cifs/foo");
	write(fd, buf, 0x1001);
	close(fd);

it will make two Write ops, one for 4K and one for 1 byte (give or take
PAGE_SIZE==4096).

David

