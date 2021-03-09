Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F067AC433E0
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Mar 2021 03:01:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AAB6165287
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Mar 2021 03:01:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229379AbhCIDAb (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 8 Mar 2021 22:00:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:60880 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230471AbhCIDAE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 8 Mar 2021 22:00:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615258803;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  in-reply-to:in-reply-to;
        bh=9ulaq3keMHgbhZQ9JLrRzi3bNFYHCcq/2BfLZY1pHxw=;
        b=eyTisfGKhQ7pfIK+4gr9IFoCqz55iE7gRo1AZQqGLkFbLfaNXNv7abF4MiRGMBhtnk7X2o
        9JX9gN7ltPMepzXuo9QWma+63WjxZ2frh2pBTOXym5NWEFPJaHcrpGl0FzitUZrbKYkFNn
        XCZgCgY+2VLw/q5TiovAwDSbszFmdwg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-512-CJMJ9xhaN5yzKEBMzfgH5w-1; Mon, 08 Mar 2021 22:00:01 -0500
X-MC-Unique: CJMJ9xhaN5yzKEBMzfgH5w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BA46F10866A3
        for <linux-cifs@vger.kernel.org>; Tue,  9 Mar 2021 03:00:00 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B344A5D6D7
        for <linux-cifs@vger.kernel.org>; Tue,  9 Mar 2021 03:00:00 +0000 (UTC)
Received: from zmail23.collab.prod.int.phx2.redhat.com (zmail23.collab.prod.int.phx2.redhat.com [10.5.83.28])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id A3C0D18095C9
        for <linux-cifs@vger.kernel.org>; Tue,  9 Mar 2021 03:00:00 +0000 (UTC)
Date:   Mon, 8 Mar 2021 21:59:59 -0500 (EST)
From:   Xiaoli Feng <xifeng@redhat.com>
To:     CIFS <linux-cifs@vger.kernel.org>
Message-ID: <1118493724.71205585.1615258799711.JavaMail.zimbra@redhat.com>
In-Reply-To: <1586458049.71205422.1615258296269.JavaMail.zimbra@redhat.com>
Subject: Host kerberos credential are took in container
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.72.12.255, 10.4.195.11]
Thread-Topic: Host kerberos credential are took in container
Thread-Index: aVOFjROXlcL0g954SPdJZaITEB3vJA==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello,

Just find a issue about container cifs kerberos credential. Create two cont=
ainers.
One is samba server. The other is client. Try to mount cifs share in contai=
ner client.
But it's failed for "Required key not available". Finally found that the co=
ntainer client
use host kerberos credential instead of container kerberos. More info pleas=
e check:
  https://bugzilla.kernel.org/show_bug.cgi?id=3D212145

By the way, host and two container are 5.12.0-rc1+.

Thanks.

--=20
Best regards!
XiaoLi Feng =E5=86=AF=E5=B0=8F=E4=B8=BD

