Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C74842DECDF
	for <linux-cifs@vger.kernel.org>; Mon,  5 Jan 2026 08:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767600304; cv=none; b=ov1NSXqm/TjaG6hYA5aT4scFb2QqJ46dN7zORb81gKdLN3wxBA6yU+VlHUYNpyfr5F28YOlUaBUSyceucaAK3AgxmJ15auNS1/htPzUyFXQUnHRoEX0u0P4/aV0UxzRNhFIEE6epn8lfXoNufTftS+p4xDIQPLHdpz7Wn2q2pFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767600304; c=relaxed/simple;
	bh=una6lMubYfETvLC74WAOFDccNOpGmSrxwdIV5G5SDas=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=Z/iLb+9j1aDgH9Hk1t7g0ukblY2k57iymyuONJ7QyzrHyVd4UI01Ikd2AV8bN+jzcETxRajoW82xyJcg0sO14Cnxys9Ppk6sh+PnYICcp5exMbMs10sZljGeBu4gJyYmUfz4o/KZIedMW6MwlX2BwqloMETqBdN/OX/jWipVuow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XT02Yjq0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XT02Yjq0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767600301;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=X4zKVAK44zMobE5W0Jfa/aDM7GS9OufGxUT6Fw4ARvs=;
	b=XT02Yjq0pIO5eSAWZGSPdW4+COUldv84Ae51OCYRIM9izo9E4ZD+W8dAUpXymoaMLppqSN
	pZbJS2LkyPWKsxTYvyg4vbZEubnjh83kbZ5iy9IC5QekYcWCpDy7RslalOpOsRp+yeL33G
	6Ki7bUNW0H1lV/oYSl2lWIOSbUYjpys=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-664-vjkQCU7uN3CRDNePMzosAw-1; Mon,
 05 Jan 2026 03:04:58 -0500
X-MC-Unique: vjkQCU7uN3CRDNePMzosAw-1
X-Mimecast-MFC-AGG-ID: vjkQCU7uN3CRDNePMzosAw_1767600296
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6D0D018011EE;
	Mon,  5 Jan 2026 08:04:56 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.4])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 85047180045B;
	Mon,  5 Jan 2026 08:04:53 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20251231130918.1168557-6-chenxiaosong.chenxiaosong@linux.dev>
References: <20251231130918.1168557-6-chenxiaosong.chenxiaosong@linux.dev> <20251231130918.1168557-1-chenxiaosong.chenxiaosong@linux.dev>
To: chenxiaosong.chenxiaosong@linux.dev
Cc: dhowells@redhat.com, smfrench@gmail.com, linkinjeon@kernel.org,
    pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com,
    tom@talpey.com, bharathsm@microsoft.com, senozhatsky@chromium.org,
    linux-cifs@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: Re: [PATCH v7 5/5] smb/client: introduce KUnit test to check search result of smb2_error_map_table
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1697002.1767600292.1@warthog.procyon.org.uk>
Date: Mon, 05 Jan 2026 08:04:52 +0000
Message-ID: <1697003.1767600292@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

chenxiaosong.chenxiaosong@linux.dev wrote:

> +	struct status_to_posix_error expect;
> +
> +	for (i = 0; i < ARRAY_SIZE(smb2_error_map_table); i++) {
> +		expect = smb2_error_map_table[i];

Did you want to copy the entry rather than pointing at it?  And if you did
want to point at it, use a const pointer?  (It's just a test, so copying it is
fine).

David

