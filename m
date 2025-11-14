Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA94F30DEDC
	for <linux-cifs@vger.kernel.org>; Fri, 14 Nov 2025 10:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763117366; cv=none; b=O8614uAZBgnbW2vHV3145SLgPIAYKhGepXlj52G8S8JwTS6S4kIgfCB8SuTxpe45iYePicNBSNUc8tnH5SLdW8pBpKGUxf+I+6A2tkqKN0Q7LdhcWqETF5awoRpHf7wcOsDyEm9kxqe1Pgph8yhuBub1VK958nbmanv4d8leiNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763117366; c=relaxed/simple;
	bh=4KiXtBdCyZjxV11eWUJVKsLmr3vNBLnFC646EiAzMyY=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=ZThY7HtAHJJGYS8Z4Vqllq+xs+hTHr2tGcnoAWoKakvjmYpymkbF0eM+bDnunmL/+MomElTxwrkTYSUrxnAotNNItzlH7CvZ7I4Di15ITpVod/OVw+bS1cErX4DNpSWMr8UTnPxS3QPd9VeqimUcFOnLqR9sRXkQLQ7QyZw6SPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VpTRUPj2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VpTRUPj2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763117363;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4KiXtBdCyZjxV11eWUJVKsLmr3vNBLnFC646EiAzMyY=;
	b=VpTRUPj26dGRnoSV5MNsvi0oQ9kB2AQnsohQzGNNKbA0QsLNNoqdWEIg+fm0FTRi8qZ89p
	kWoKKrtFmd8iSJ9OZ+gzqAWR7j909r2GBLeERK8t1MDiYgawnAQl5Cn2NpNL8lLCt3cHqv
	BGPaDukS0zO6rtVdswaJfoWOFJG+Xjg=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-626-a3YWfUecPrqQ9Csayqj3dQ-1; Fri,
 14 Nov 2025 05:49:20 -0500
X-MC-Unique: a3YWfUecPrqQ9Csayqj3dQ-1
X-Mimecast-MFC-AGG-ID: a3YWfUecPrqQ9Csayqj3dQ_1763117359
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 02A1C1800342;
	Fri, 14 Nov 2025 10:49:19 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.87])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4694919540DF;
	Fri, 14 Nov 2025 10:49:15 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CANT5p=pye46OnCQB+DB=ts7PkZS-bCpC+cURC1HnptmSwApX-Q@mail.gmail.com>
References: <CANT5p=pye46OnCQB+DB=ts7PkZS-bCpC+cURC1HnptmSwApX-Q@mail.gmail.com> <YT1PR01MB9451424C6870795133FB7C96B3A72@YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM> <36fb31bf2c854cdc930a3415f5551dcd@izw-berlin.de> <CAH2r5mtNtyqZBpT8hL2xvZ8QYWAymrPR-5LmpZbeTHr_1ATPWg@mail.gmail.com> <uildcjpqxzc5nckupgdeeifkrqwrau2qxuc2df2uxuyys3i2k2@iz2bmi6yojyu> <YT1PR01MB945191C652AEE173CEADBA3EB3A12@YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM> <aaloi77h2f5xolhrnegxsxntqp2jopwisunmjfp45idsoockpy@cy5agf2oqjop> <YT1PR01MB9451A0F623371F50E77CC1C9B3AD2@YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM> <CAGypqWw0bnE7_=49HSxgExouk4s5PVFQ6gVH50wrE8_=4b5vAg@mail.gmail.com> <958479.1762852948@warthog.procyon.org.uk> <CANT5p=rh7BQBnwNYLxHtFw=YUhAGVnskJ=33i6Eg4porU-X+5A@mail.gmail.com> <CANT5p=px8Lh1C2O0F8i1htoMACWZbLPfw0NEzUco5Njss2c7pQ@mail.gmail.com> <1392200.1762971247@warthog.procyon.org.uk> <CANT5p=p4KSRsCAB-peTKehvsYYiuOxy3qLNDO9j5H+5PP_eiyw@mail.gmail.com> <1640439.1763042251@warthog.procyon.org.uk>
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
Content-ID: <1726854.1763117354.1@warthog.procyon.org.uk>
Date: Fri, 14 Nov 2025 10:49:14 +0000
Message-ID: <1726855.1763117354@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Looks good.

Acked-by: David Howells <dhowells@redhat.com>

