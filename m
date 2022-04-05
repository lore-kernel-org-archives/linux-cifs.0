Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B6E0C433F5
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Apr 2022 23:42:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232927AbiDEXTq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 Apr 2022 19:19:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446332AbiDEPo3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 5 Apr 2022 11:44:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AAFF889310
        for <linux-cifs@vger.kernel.org>; Tue,  5 Apr 2022 07:14:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649168053;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ccLcaJ3XQxZ5dFaHiCvLp0wwEvmie9vn1E+DpQO2p/o=;
        b=fSxuCZYD38c80yyC4/53hdKKeZdAne63hb6UTBXaDHTSDRXBXLWFLOkCEA1rNCVd3IwdJj
        fPoE6OBprXeccOJx718d/zhCucElC7WuTW06z6ZkEbL87pibKNPtyr4QtBArRyLO998SIx
        Tf+gWiq9xYISqfPfV1Ay5BC9ig+WjaQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-623-ibJSl2VjMui2_DlmxbGNog-1; Tue, 05 Apr 2022 10:14:12 -0400
X-MC-Unique: ibJSl2VjMui2_DlmxbGNog-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0B7B2899EE2;
        Tue,  5 Apr 2022 14:14:12 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 32B6740CF8E5;
        Tue,  5 Apr 2022 14:14:11 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20220405134649.6579-1-dwysocha@redhat.com>
References: <20220405134649.6579-1-dwysocha@redhat.com>
To:     Dave Wysochanski <dwysocha@redhat.com>
Cc:     dhowells@redhat.com, linux-cachefs@redhat.com, jlayton@kernel.org,
        smfrench@gmail.com, linux-cifs@vger.kernel.org
Subject: Re: [PATCH] cachefiles: Fix KASAN slab-out-of-bounds in cachefiles_set_volume_xattr
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1788450.1649168050.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Tue, 05 Apr 2022 15:14:10 +0100
Message-ID: <1788451.1649168050@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Dave Wysochanski <dwysocha@redhat.com> wrote:

> @@ -203,7 +203,7 @@ bool cachefiles_set_volume_xattr(struct cachefiles_v=
olume *volume)
>  	if (!buf)
>  		return false;
>  	buf->reserved =3D cpu_to_be32(0);
> -	memcpy(buf->data, p, len);
> +	memcpy(buf->data, p, volume->vcookie->coherency_len);

Good catch.  However, I think it's probably better to change things a bit
further up, eg.:

	-	len +=3D sizeof(*buf);
	-	buf =3D kmalloc(len, GFP_KERNEL);
	+	buf =3D kmalloc(sizeof(*buf) + len, GFP_KERNEL);

David

