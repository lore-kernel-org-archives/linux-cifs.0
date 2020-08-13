Return-Path: <SRS0=jY8V=BX=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98D8CC433DF
	for <linux-cifs@archiver.kernel.org>; Thu, 13 Aug 2020 15:32:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CDFE20781
	for <linux-cifs@archiver.kernel.org>; Thu, 13 Aug 2020 15:32:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HH61uerQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbgHMPcV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 13 Aug 2020 11:32:21 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:57452 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726253AbgHMPcU (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 13 Aug 2020 11:32:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597332739;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rI+VkqySahTGBo+LZ6196lJmvR/3YlmhnUdKT+7qOco=;
        b=HH61uerQdQ0JXMLrUtjwbumRYJ5x59DUNLNVuv5/mV5GFgNi0hy2hKrf4WujXjDthsHgkj
        ePw9eevWTbKI/pmX+KHR4+a/5QSc82kPOqVF7oCFY7ydjuI5ZIomWRI5nK8yUe5kjy/rwn
        X7mZLHHV3yGPif7kayKi+TDigtoGc1Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-363-jDTk2fcrN4qB8i1FYCNzRA-1; Thu, 13 Aug 2020 11:32:17 -0400
X-MC-Unique: jDTk2fcrN4qB8i1FYCNzRA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 817C01DDE0;
        Thu, 13 Aug 2020 15:32:16 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-127.rdu2.redhat.com [10.10.120.127])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8CC515C1A3;
        Thu, 13 Aug 2020 15:32:15 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <87tux64mns.fsf@suse.com>
References: <87tux64mns.fsf@suse.com> <1097808468.45751159.1597108422888.JavaMail.zimbra@redhat.com> <3704067.45751512.1597109127904.JavaMail.zimbra@redhat.com> <CAH2r5mt389QPfeZPSTun9qkc=88ehFC1NzayewCoKU=qv+Epaw@mail.gmail.com>
To:     =?us-ascii?Q?=3D=3Futf-8=3FQ=3FAur=3DC3=3DA9lien=3F=3D?= Aptel 
        <aaptel@suse.com>
Cc:     dhowells@redhat.com, Steve French <smfrench@gmail.com>,
        Xiaoli Feng <xifeng@redhat.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: FS-Cache for cifs
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date:   Thu, 13 Aug 2020 16:32:14 +0100
Message-ID: <322210.1597332734@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Aur=C3=A9lien Aptel <aaptel@suse.com> wrote:

> Is there an overview document somewhere that describe what fscache does?
> We are seeing some warnings about duplicated entries in some scenarios
> but I'd like to understand better what it does before changing what goes
> in the key.

Documentation/filesystems/caching/* in the kernel.

David

