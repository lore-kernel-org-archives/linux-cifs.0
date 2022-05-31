Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DAB3C433F5
	for <linux-cifs@archiver.kernel.org>; Tue, 31 May 2022 21:05:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239325AbiEaVFo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 31 May 2022 17:05:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238177AbiEaVFn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 31 May 2022 17:05:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ED3A28E1B8
        for <linux-cifs@vger.kernel.org>; Tue, 31 May 2022 14:05:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654031141;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=N59w2pSvtIYUiH0qSGcHVehmRFTiHrDz8q5PNtXlCXQ=;
        b=HYlFXmf2TNf8D4eK/4/PxH+XnsNMr3HCgce/OQUpB/+piZ0UDqCAbB1QvA4i5OrSCwwc74
        12cM5uvBr8ZmaTS67rDa/ZFILGIFuKF4/sOMaYPpt8mktMX139RlaOTF/zgjKMDHVLZase
        Q9VSx5eE9Kg/VTmjWvKMhVwyZ+P8hXA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-358-BNo_e8ONOgCvZGPxjDeN0w-1; Tue, 31 May 2022 17:05:38 -0400
X-MC-Unique: BNo_e8ONOgCvZGPxjDeN0w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 447C329AB40B;
        Tue, 31 May 2022 21:05:38 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A60292166B26;
        Tue, 31 May 2022 21:05:37 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     dhowells@redhat.com, Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: ksmbd threads eating masses of cputime
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <833009.1654031136.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Tue, 31 May 2022 22:05:36 +0100
Message-ID: <833010.1654031136@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Namjae,

Steve says I should show this to you.

My server box that I'm using to do cifs-over-RDMA testing is running reall=
y
slowly because it has about 30 ksmbd thread hogging the cpus:

    PID USER    PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMA=
ND
  19993 root    20   0       0      0      0 R  14.3   0.0 910:06.02 ksmbd=
:r5445
  20048 root    20   0       0      0      0 R  14.3   0.0 896:19.22 ksmbd=
:r5445
  20052 root    20   0       0      0      0 R  14.3   0.0 901:51.52 ksmbd=
:r5445
  20053 root    20   0       0      0      0 R  14.3   0.0 904:20.84 ksmbd=
:r5445
  20056 root    20   0       0      0      0 R  14.3   0.0 910:39.38 ksmbd=
:r5445
  20095 root    20   0       0      0      0 R  14.3   0.0 901:28.48 ksmbd=
:r5445
  20097 root    20   0       0      0      0 R  14.3   0.0 910:02.19 ksmbd=
:r5445
  20103 root    20   0       0      0      0 R  14.3   0.0 912:13.18 ksmbd=
:r5445
  20105 root    20   0       0      0      0 R  14.3   0.0 908:46.76 ksmbd=
:r5445
  ...


I tried to shut them down with "ksmbd.control -s", but that just hung and =
the
threads are still running.  I captured a stack trace from one of them thro=
ugh
/proc:

	[root@carina ~]# cat /proc/20052/stack
	[<0>] ksmbd_conn_handler_loop+0x181/0x200 [ksmbd]
	[<0>] kthread+0xe8/0x110
	[<0>] ret_from_fork+0x22/0x30

Note that nothing is currently mounted from the server and it is getting n=
o
incoming packets.

Looking at the loop in ksmbd_conn_handler_loop(), it seems to be busy-wait=
ing
- unless kernel_recvmsg() is doing that?  In the TCP transport, if
kernel_recvmsg() isn't waiting, but returns -EAGAIN, it will sleep for 1-2=
ms
and then go round again... and again... and again - and all 30 threads wou=
ld
be doing that.


Btw in:

		ret =3D kernel_accept(iface->ksmbd_socket, &client_sk,
				    O_NONBLOCK);

that should be SOCK_NONBLOCK, I think.

Also:

	[root@carina ~]# ksmbd.control --shutdown
	Usage: ksmbd.control
		-s | --shutdown
	...

that looks like it doesn't handle the advertised long parameters.

