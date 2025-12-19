Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5C9F30C366
	for <linux-cifs@vger.kernel.org>; Fri, 19 Dec 2025 08:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766132293; cv=none; b=MUg28FNsd4nidM7RyIfi3TnQyF7bftATwqmgUIWaaMPj4ZTuBZVBic47/CSETnCnKtvykBbb4dO22Ip+bibLwIWZTnU2/VKgcHtC3LiDtjpcj1XOUL8A1tdHVzQiEyRpp6831qN7Wj/2wXMCfqQZnTf+EKDEUtfJ7SG69XODaYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766132293; c=relaxed/simple;
	bh=vh8viwd5LgIvUS08QX9/+TBQXTrQuNXfaPY04p1wYJk=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=AeHKRkbVarv/82MlrZyf/YnyLFQNRHYEkgeyY4qP6xY9KFKt9odi2DKNdQxBNp+ptRmhAdUwBYSDEgHSfxSaa7gHquP+wZzGUhdJ4ep8g0ntcHL56oF5kbNHMjokRBnask0OPi9MrQRw7TBx21FgDxxCssQFaLPhTeRi/yLzyAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DnYFBV5p; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DnYFBV5p"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766132289;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=g+UcSnHEtzY5eIOBAQgX575+sV9ht7IVjTmugmxYWAQ=;
	b=DnYFBV5pofz/SOnAvuaHyXeM4mqZ7e/9x88HLM7TehfMqUewfYI95NUQozPGHX2li0cSrl
	JVnF1qYqIS1SwNq2Q3gTrG/LBWRKzPqYVj/5N1RhJekXqGusABF8SDI21cj50WVD+UoEDD
	1dSkNbAuad6ColNJVJeycpxlYTrMzXM=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-145-DmeT3NrsNESR1yht1Pw2NQ-1; Fri,
 19 Dec 2025 03:18:03 -0500
X-MC-Unique: DmeT3NrsNESR1yht1Pw2NQ-1
X-Mimecast-MFC-AGG-ID: DmeT3NrsNESR1yht1Pw2NQ_1766132281
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3E0701800669;
	Fri, 19 Dec 2025 08:18:01 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.5])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7BDCC180045B;
	Fri, 19 Dec 2025 08:17:57 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAKYAXd-Lub=zOOE5cW5jEWNYhTJcmX3grZLLXFpZTcwWA4UYBA@mail.gmail.com>
References: <CAKYAXd-Lub=zOOE5cW5jEWNYhTJcmX3grZLLXFpZTcwWA4UYBA@mail.gmail.com> <20251218171038.55266-1-chenxiaosong.chenxiaosong@linux.dev> <CAKYAXd-W9xN9rQ4_Y9eudV2CJ7ZObys9YLXib-=wHymH4kfExg@mail.gmail.com> <9b5eec32-d702-4d77-b4dd-5c33939ae6e2@linux.dev>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: dhowells@redhat.com,
    ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>,
    sfrench@samba.org, smfrench@gmail.com, linkinjeon@samba.org,
    pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com,
    tom@talpey.com, bharathsm@microsoft.com, senozhatsky@chromium.org,
    linux-cifs@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: Re: [PATCH] smb/server: fix SMB2_MIN_SUPPORTED_HEADER_SIZE value
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <805495.1766132276.1@warthog.procyon.org.uk>
Date: Fri, 19 Dec 2025 08:17:56 +0000
Message-ID: <805496.1766132276@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Namjae Jeon <linkinjeon@kernel.org> wrote:

> > We should rename them to `SMB1_MIN_SUPPORTED_PDU_SIZE` and
> > `SMB2_MIN_SUPPORTED_PDU_SIZE`.
> >
> > But we "should not" add "+4" to them.
> Not adding the +4 will trigger a slab-out-of-bounds issue.
> You should check ksmbd_smb2_check_message() and
> ksmbd_negotiate_smb_dialect() as well as ksmbd_conn_handler_loop().
> ...
> >    pdu_size = get_rfc1002_len(hdr_buf);
> >    ...
> >    if (pdu_size < SMB1_MIN_SUPPORTED_HEADER_SIZE)
> >    ...
> >    if (pdu_size < SMB2_MIN_SUPPORTED_HEADER_SIZE)

As previously mentioned, the problem I have with the +4 accounting for the
RFC1002 header is that the size value in pdu_size does not include the size of
the RFC1002 header, so the comparison seems to be allowing an overlong header.

However, I think the +4 actually makes sense for SMB2/3 - assuming the +4
isn't actually for the RFC1002 size, but is rather for the StructureSize of
the operation header that follows immediately after the smb2_hdr.

If that's the case, I would guess that the SMB1 variant might want a +2 to
allow for the BCC field...  but according to the code in cifs side that I've
looked at, some servers may only provide half a BCC field - or maybe even
forget to put it in entirely.

David

