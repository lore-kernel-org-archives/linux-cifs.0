Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA1C71F63CD
	for <linux-cifs@vger.kernel.org>; Mon,  5 Jan 2026 07:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767599923; cv=none; b=eJHPRKxM+PVl9A8lDSUPV+9Kh7bWwn2hGPBZZvDr4F64gt+wHsPpAr16RvYu8mguGpwDohIs4XgbqiyhzEkgOzf79rmUtIuQJnPGzreGNImBSUSgWT/1G7o+cRUxKAv5dYAsFV91Ema4OQ3E1hAuHWPeorI+1eb88SGKlErsrxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767599923; c=relaxed/simple;
	bh=N5zwnbXolPEoDsJIXCJjUml42ECM3gXg3VCKQ4IeOmI=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=akxEir8h+fo4OOLJ/G36k+alBadMZ2UtKsQbn3akX1WmYiOqFOidN1xev1Q5ZcU5yzIrzzbp0M43S8VpRHyEVpwuO27Zgm7tsi+erA5KrrBnWp6MKHByTZ3/EDTXsN1zhdNFco1CwA4nUGOK4CYJWYBA61EB6mKbiuIq9XENCVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Zng1Vvu1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Zng1Vvu1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767599920;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DEGOUP7rUZVPB/aEZDgrW/onoEFhGzG7TdkAzmYsEWw=;
	b=Zng1Vvu1gCjf92UpSU6tX4RY6ZwiO91j2P+2FomR7ADk3T203idTp+0omRrx+TheunSodR
	z56wFFzZ1nUCun8n9eMb3N28v3btXjyJ+6+ms5WXfoDgu1mXYH7fAMgGCPA/VADERFUpR6
	5cRXyrtWMGvICzWT2xb9WEESXmcYKEQ=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-544-27mGmtnOPvupbxakgHaOLA-1; Mon,
 05 Jan 2026 02:58:34 -0500
X-MC-Unique: 27mGmtnOPvupbxakgHaOLA-1
X-Mimecast-MFC-AGG-ID: 27mGmtnOPvupbxakgHaOLA_1767599913
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 56D061956089;
	Mon,  5 Jan 2026 07:58:25 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.4])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9170B180044F;
	Mon,  5 Jan 2026 07:58:21 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20251231130918.1168557-3-chenxiaosong.chenxiaosong@linux.dev>
References: <20251231130918.1168557-3-chenxiaosong.chenxiaosong@linux.dev> <20251231130918.1168557-1-chenxiaosong.chenxiaosong@linux.dev>
To: chenxiaosong.chenxiaosong@linux.dev
Cc: dhowells@redhat.com, smfrench@gmail.com, linkinjeon@kernel.org,
    pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com,
    tom@talpey.com, bharathsm@microsoft.com, senozhatsky@chromium.org,
    linux-cifs@vger.kernel.org, Steve French <stfrench@microsoft.com>,
    ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: Re: [PATCH v7 2/5] cifs: Autogenerate SMB2 error mapping table
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1696855.1767599900.1@warthog.procyon.org.uk>
Date: Mon, 05 Jan 2026 07:58:20 +0000
Message-ID: <1696856.1767599900@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

chenxiaosong.chenxiaosong@linux.dev wrote:

> +	__u32 smb2_status;

Note that you only really need to use __u32, __u16, __u8 and suchlike in UAPI
structs that userspace will be able to #include.  You can use u32, u16, u8 in
kernel internals.  But don't worry too much about it - it's not worth
respinning the patches over.

David

