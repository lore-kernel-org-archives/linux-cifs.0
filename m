Return-Path: <SRS0=CZtn=BN=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8597CC433E0
	for <linux-cifs@archiver.kernel.org>; Mon,  3 Aug 2020 02:48:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F037206F6
	for <linux-cifs@archiver.kernel.org>; Mon,  3 Aug 2020 02:48:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GcskMSyh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbgHCCsN (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 2 Aug 2020 22:48:13 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26362 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725820AbgHCCsN (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 2 Aug 2020 22:48:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596422892;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  in-reply-to:in-reply-to;
        bh=GqhAUeCwOFef5i9VGynTwZ3qyMu5xBnlGW6z2Tq9v88=;
        b=GcskMSyhcQlk7OCj0SoWZ7AwH8TPc3BeMvHd4CH64NDnGE30M30zEx85+cNrqC7C5r/FDA
        UlSF7yDkR3Rd2rvgYKR8gSN0IPWyBRlFlF+OQUgWqrJNcSK7t9O7FvpazJ5oT6e8OD8oTr
        yu1pZVWaFFOt6F7pJiX/1YAINMiK/zs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-323-A84jVYxWM5u50b6Hdb2M1g-1; Sun, 02 Aug 2020 22:48:10 -0400
X-MC-Unique: A84jVYxWM5u50b6Hdb2M1g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6CAE9800472
        for <linux-cifs@vger.kernel.org>; Mon,  3 Aug 2020 02:48:09 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 66A187B41F
        for <linux-cifs@vger.kernel.org>; Mon,  3 Aug 2020 02:48:09 +0000 (UTC)
Received: from zmail23.collab.prod.int.phx2.redhat.com (zmail23.collab.prod.int.phx2.redhat.com [10.5.83.28])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 60429180954D
        for <linux-cifs@vger.kernel.org>; Mon,  3 Aug 2020 02:48:09 +0000 (UTC)
Date:   Sun, 2 Aug 2020 22:48:08 -0400 (EDT)
From:   Xiaoli Feng <xifeng@redhat.com>
To:     CIFS <linux-cifs@vger.kernel.org>
Message-ID: <506179292.44794805.1596422888744.JavaMail.zimbra@redhat.com>
In-Reply-To: <1119714633.44793917.1596421202774.JavaMail.zimbra@redhat.com>
Subject: fallocate can't change the cifs disk space usage
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.68.5.20, 10.4.195.14]
Thread-Topic: fallocate can't change the cifs disk space usage
Thread-Index: 13/8w3mJEUY0r3x+SC6Tt6L7mlrMiQ==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello all,

Recently when I'm investigating the xfstests generic/213 generic/228 failur=
es for cifs.
Found that fallocate can't change the cifs disk space usage. Comparing xfs =
fileystem,=20
fallocate can update space usage.

My tests is in 5.8.0-rc7+. I also file a bug for this issue.=20
  https://bugzilla.kernel.org/show_bug.cgi?id=3D208775

# cat /etc/samba/smb.conf
[cifs]
path=3D/mnt/cifs
writeable=3Dyes
# mount //localhost/cifs cifs -o user=3Droot,password=3Dredhat,cache=3Dnone=
,actimeo=3D0
# df -h cifs
Filesystem        Size  Used Avail Use% Mounted on
//localhost/cifs   36G   23G   13G  66% /root/cifs
#  fallocate -o 0 -l 2g /root/cifs/file1
# df -h cifs
Filesystem        Size  Used Avail Use% Mounted on
//localhost/cifs   36G   23G   13G  66% /root/cifs
]# ls -l cifs
total 1
-rwxr-xr-x. 1 root root 2147483648 Aug  2 21:57 file1

Thanks.

--=20
Best regards!
XiaoLi Feng =E5=86=AF=E5=B0=8F=E4=B8=BD

