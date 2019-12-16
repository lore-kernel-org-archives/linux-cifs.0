Return-Path: <SRS0=ZQfQ=2G=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43506C43603
	for <linux-cifs@archiver.kernel.org>; Mon, 16 Dec 2019 15:30:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 14FA6205C9
	for <linux-cifs@archiver.kernel.org>; Mon, 16 Dec 2019 15:30:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="adnfKTti"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728259AbfLPPaN (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 16 Dec 2019 10:30:13 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:38927 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728225AbfLPPaN (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 16 Dec 2019 10:30:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576510212;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  in-reply-to:in-reply-to;
        bh=aEp+MJBOuE8pF/cjQ/nNYtbTCoMdScKTwrbxZ3Nqll4=;
        b=adnfKTtiJoDO5bBJ/J0rPVEIkxHAsGg6TzTcBOk6uAtfNEml6P655WnF0PhTImsVMLwztn
        ldFzayR2zVzX/uIj/Z25b+Oy53FlNkLarJFGmHphzmHM5uuiRkN8ER8IPO7mweE01ft4DJ
        cWakemWIbSSrzTR5oa9wfwhoHRE9FuU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-429-aZghXvlPNgSZQE6qPKmqTQ-1; Mon, 16 Dec 2019 10:30:11 -0500
X-MC-Unique: aZghXvlPNgSZQE6qPKmqTQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 467B218B9FC1
        for <linux-cifs@vger.kernel.org>; Mon, 16 Dec 2019 15:30:10 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 394D66886E
        for <linux-cifs@vger.kernel.org>; Mon, 16 Dec 2019 15:30:10 +0000 (UTC)
Received: from zmail23.collab.prod.int.phx2.redhat.com (zmail23.collab.prod.int.phx2.redhat.com [10.5.83.28])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 30A63ADAAD
        for <linux-cifs@vger.kernel.org>; Mon, 16 Dec 2019 15:30:10 +0000 (UTC)
Date:   Mon, 16 Dec 2019 10:30:09 -0500 (EST)
From:   Xiaoli Feng <xifeng@redhat.com>
To:     linux-cifs@vger.kernel.org
Message-ID: <180194560.1531945.1576510209913.JavaMail.zimbra@redhat.com>
In-Reply-To: <1327532317.1529923.1576509501382.JavaMail.zimbra@redhat.com>
Subject: How to use SMB Direct
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.72.12.30, 10.4.195.3]
Thread-Topic: How to use SMB Direct
Thread-Index: UIMmQ9EQHszzT+199YRg7frRdlFZzQ==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello guys,

I'd like to test SMB Direct. But it's failed. I'm not sure if it works in u=
pstream.
I setup samba server on one rdma machine with 5.5.0-rc1+ kernel. The smb.co=
nf is:
[cifs]
path=3D/mnt/cifs
writeable=3Dyes

Then I try to mount the share on another rdma machine with 5.5.0-rc1+ kerne=
l.
   mount //$RDMA/cifs cifs -o user=3Droot,password=3D$password,rdma

It's failed because of "CIFS VFS: smbd_create_id:614 rdma_resolve_addr() co=
mpleted -113"
Does SMB Direct work fine in upstream?

Thanks.

$ cat /boot/config-5.5.0-rc1+ |grep SMB_DIRECT
CONFIG_CIFS_SMB_DIRECT=3Dy
$ ibstat
CA 'mlx4_0'
=09CA type: MT4099
=09Number of ports: 2
=09Firmware version: 2.42.5000
=09Hardware version: 1
=09Node GUID: 0xf4521403007be0e0
=09System image GUID: 0xf4521403007be0e3
=09Port 1:
=09=09State: Active
=09=09Physical state: LinkUp
=09=09Rate: 56
=09=09Base lid: 29
=09=09LMC: 0
=09=09SM lid: 1
=09=09Capability mask: 0x0259486a
=09=09Port GUID: 0xf4521403007be0e1
=09=09Link layer: InfiniBand
=09Port 2:
=09=09State: Active
=09=09Physical state: LinkUp
=09=09Rate: 40
=09=09Base lid: 44
=09=09LMC: 1
=09=09SM lid: 36
=09=09Capability mask: 0x02594868
=09=09Port GUID: 0xf4521403007be0e2
=09=09Link layer: InfiniBand


--=20
Best regards!
XiaoLi Feng =E5=86=AF=E5=B0=8F=E4=B8=BD

Red Hat Software (Beijing) Co.,Ltd
filesystem-qe Team
IRC:xifeng=EF=BC=8C#channel: fs-qe
Tel:+86-10-8388112
9/F, Raycom

