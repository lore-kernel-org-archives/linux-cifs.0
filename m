Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EF20C4361A
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Jan 2021 00:28:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 235BF20679
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Jan 2021 00:28:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730079AbhA0A0e (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 26 Jan 2021 19:26:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47140 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389045AbhAZF5a (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 26 Jan 2021 00:57:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611640559;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  in-reply-to:in-reply-to;
        bh=2zYPmCa9CD1op8Dz6ppj1Qq3baJz0sWPv7iRVNa20dY=;
        b=iz8dkOpgE/5lzR6QlD9XMdAoVus1fydxeUVXDmEgdL0mU8YTQHkdLiPL1QCbX7VXaQJ7AW
        wHOk+vuBiHlIG0uNXd6u7ydFkimYCLMUOAmP/2YlFW8Z9OlAfExLPk4k3uoxeB3eRQwtbO
        e+B9RYaUX6LWNC0Imf5O6zqW+vk7MQM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-158-rDweF2G8P9iWteXa09NUFA-1; Tue, 26 Jan 2021 00:55:57 -0500
X-MC-Unique: rDweF2G8P9iWteXa09NUFA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4D72E1005504
        for <linux-cifs@vger.kernel.org>; Tue, 26 Jan 2021 05:55:56 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 46BEC5D9DB
        for <linux-cifs@vger.kernel.org>; Tue, 26 Jan 2021 05:55:56 +0000 (UTC)
Received: from zmail23.collab.prod.int.phx2.redhat.com (zmail23.collab.prod.int.phx2.redhat.com [10.5.83.28])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 40A6D4BB7B
        for <linux-cifs@vger.kernel.org>; Tue, 26 Jan 2021 05:55:56 +0000 (UTC)
Date:   Tue, 26 Jan 2021 00:55:55 -0500 (EST)
From:   Xiaoli Feng <xifeng@redhat.com>
To:     CIFS <linux-cifs@vger.kernel.org>
Message-ID: <1593727848.66273087.1611640555370.JavaMail.zimbra@redhat.com>
In-Reply-To: <1415900995.66272053.1611639038067.JavaMail.zimbra@redhat.com>
Subject: mount dfs share failed becaus e of missing username
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.72.12.80, 10.4.195.23]
Thread-Topic: mount dfs share failed becaus e of missing username
Thread-Index: +2LOR8zqgQeu0i2hn8fXXegFGLM9RA==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello guys,

I met a bug. Mount dfs root share failed on v5.11.0-rc5. But It's success o=
n v5.10.

[root@ibm-x3650m4-01-vm-14 ~]# mount -vvv  //localhost/dfsroot cifs -o user=
=3Droot,password=3Dredhat=20
mount.cifs kernel mount options: ip=3D::1,unc=3D\\localhost\dfsroot,user=3D=
root,pass=3D********
mount error(22): Invalid argument

dmesg log:
[ 1648.025424] CIFS: fs/cifs/connect.c: build_unc_path_to_root: full_path=
=3D\\localhost\dfsroot
[ 1648.025427] CIFS: fs/cifs/connect.c: build_unc_path_to_root: full_path=
=3D\\localhost\dfsroot
[ 1648.025429] CIFS: fs/cifs/connect.c: build_unc_path_to_root: full_path=
=3D\\localhost\dfsroot
[ 1648.025434] CIFS: fs/cifs/dfs_cache.c: __dfs_cache_find: search path: \l=
ocalhost\dfsroot
[ 1648.025437] CIFS: fs/cifs/dfs_cache.c: setup_referral: set up new ref
[ 1648.026760] CIFS: fs/cifs/dns_resolve.c: dns_resolve_server_name_to_ip: =
resolved: localhost to 127.0.0.1
[ 1648.026773] CIFS: VFS: No username specified
[ 1648.028008] CIFS: fs/cifs/connect.c: cifs_put_smb_ses: ses_count=3D3
[ 1648.028012] CIFS: fs/cifs/connect.c: cifs_put_tcon: tc_count=3D1
[ 1648.028014] CIFS: fs/cifs/connect.c: VFS: in cifs_put_tcon as Xid: 32 wi=
th uid: 0
[ 1648.028017] CIFS: fs/cifs/smb2pdu.c: Tree Disconnect
[ 1648.028385] CIFS: fs/cifs/connect.c: cifs_put_smb_ses: ses_count=3D2
[ 1648.028390] CIFS: fs/cifs/connect.c: VFS: leaving mount_put_conns (xid =
=3D 29) rc =3D 0
[ 1648.028393] CIFS: VFS: cifs_mount failed w/return code =3D -22


More info please look https://bugzilla.kernel.org/show_bug.cgi?id=3D211345.

Thanks.

--=20
Best regards!
XiaoLi Feng =E5=86=AF=E5=B0=8F=E4=B8=BD

Red Hat Software (Beijing) Co.,Ltd
filesystem-qe Team
IRC:xifeng=EF=BC=8C#channel: fs-qe
Tel:+86-10-8388112
9/F, Raycom

