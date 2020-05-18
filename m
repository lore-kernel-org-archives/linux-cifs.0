Return-Path: <SRS0=5fY1=7A=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F22CAC433E0
	for <linux-cifs@archiver.kernel.org>; Mon, 18 May 2020 16:01:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4AF620758
	for <linux-cifs@archiver.kernel.org>; Mon, 18 May 2020 16:01:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fplYaMNW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727035AbgERQB3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 18 May 2020 12:01:29 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21630 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727006AbgERQB3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 18 May 2020 12:01:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589817688;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  in-reply-to:in-reply-to;
        bh=uYBnaMWy2YH4TQYzQo1K+g3jodJVjamQ4AgPvqTBNfw=;
        b=fplYaMNWIf0hUq2XELg1dH9qSBf46eeZ/Q4jSJmy0sfZpJjAaZqKTtZzsTZNzUPpYj7B08
        8374KnZSYOxErPPYJ/8bmBXXKlkNMpSEtHY+Jz3ziv5pX7lCkI3iF2YaE3/OM7ZSRoY0l9
        ugmeR+K914C1zMj9Nw3+n24DzzaGXPc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-354-Q5ITFaZ5PYirvSm-kUIb5Q-1; Mon, 18 May 2020 12:01:26 -0400
X-MC-Unique: Q5ITFaZ5PYirvSm-kUIb5Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 002F7EC1AA
        for <linux-cifs@vger.kernel.org>; Mon, 18 May 2020 16:01:26 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EEE7B5C1B5
        for <linux-cifs@vger.kernel.org>; Mon, 18 May 2020 16:01:25 +0000 (UTC)
Received: from zmail23.collab.prod.int.phx2.redhat.com (zmail23.collab.prod.int.phx2.redhat.com [10.5.83.28])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id E8DE418095FF
        for <linux-cifs@vger.kernel.org>; Mon, 18 May 2020 16:01:25 +0000 (UTC)
Date:   Mon, 18 May 2020 12:01:25 -0400 (EDT)
From:   Xiaoli Feng <xifeng@redhat.com>
To:     linux-cifs@vger.kernel.org
Message-ID: <1628934597.29140043.1589817685407.JavaMail.zimbra@redhat.com>
In-Reply-To: <1371710722.29134084.1589816497911.JavaMail.zimbra@redhat.com>
Subject: How to verify multichannel
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.72.13.235, 10.4.195.14]
Thread-Topic: How to verify multichannel
Thread-Index: /5UGMD25vIxKqA9lgpMTA7jR2qYWog==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello,

When I test multichannel. I don't know how to verify if it works. I just ca=
tch network
packages to see if server and client communicate with multiple IP. But from=
 my test, it
doesn't. Does any one know how to verify multichannel?

Setup:
server is samba server in linux upstream.
client is linux upstream.
smb.conf is:
[global]
interfaces =3D eth1, eth2, team0
server multi channel support =3D yes
vfs objects =3D recycle aio_pthread
aio read size =3D 1
aio write size =3D 1
[cifs]
path=3D/mnt/cifs
writeable=3Dyes

Create network team in server and client. eth1 and eth2 work as team slave.=
 Mount with=20
multichannel option(use one of team ip to mount). Then use "dd" to create 1=
G file. The
used time are the same for multichannel and no multichannel. Compare the ti=
me for=20
copying 1G file. The result are also the same. By the way, network team run=
ning mode=20
is round-robin.


Thanks.

--=20
Best regards!
XiaoLi Feng =E5=86=AF=E5=B0=8F=E4=B8=BD

