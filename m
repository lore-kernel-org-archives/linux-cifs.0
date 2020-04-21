Return-Path: <SRS0=EeRJ=6F=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2824EC2BA19
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Apr 2020 04:33:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F33382076C
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Apr 2020 04:33:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NZAycZO0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726021AbgDUEdt (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 21 Apr 2020 00:33:49 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:43884 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726018AbgDUEdt (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 21 Apr 2020 00:33:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587443628;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4o0kMI3uVvPmVzxN0zsWlwfffRdeyPQQE6Gqo7uJXSw=;
        b=NZAycZO0q2ESgw/rngXAAR2d4AobMGKN/ULFtEZHPZuA5Mg2lJw8zDACco54+cXG7aYloJ
        jE/u8xSHiFcWqoO+loKLd9oon2uPj5znkEASORJTEFVnR2SlOYNKqV/g5UwcvNB0Tkr1/3
        kws1ug/UK4tdEoAgLz4XTZt0r4FZbXk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-296-V-JnVzFgMi-IiQnxVd-Utw-1; Tue, 21 Apr 2020 00:33:45 -0400
X-MC-Unique: V-JnVzFgMi-IiQnxVd-Utw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6EFDB8017F3;
        Tue, 21 Apr 2020 04:33:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 67B9211A08E;
        Tue, 21 Apr 2020 04:33:44 +0000 (UTC)
Received: from zmail25.collab.prod.int.phx2.redhat.com (zmail25.collab.prod.int.phx2.redhat.com [10.5.83.31])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5DC5B18089C8;
        Tue, 21 Apr 2020 04:33:44 +0000 (UTC)
Date:   Tue, 21 Apr 2020 00:33:44 -0400 (EDT)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Message-ID: <1484605579.23547436.1587443624135.JavaMail.zimbra@redhat.com>
In-Reply-To: <CAH2r5msSe_j8xyRd7noarQ-9mkiS4WmM+6w1+kLP1gYf+=0avA@mail.gmail.com>
References: <CAH2r5msSe_j8xyRd7noarQ-9mkiS4WmM+6w1+kLP1gYf+=0avA@mail.gmail.com>
Subject: Re: smbinfo --version
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.64.54.101, 10.4.195.14]
Thread-Topic: smbinfo --version
Thread-Index: oHQpJ3VP/AlS6RkfOeuPqf85j4ahgw==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org





----- Original Message -----
> From: "Steve French" <smfrench@gmail.com>
> To: "CIFS" <linux-cifs@vger.kernel.org>
> Sent: Tuesday, 21 April, 2020 2:23:06 PM
> Subject: smbinfo --version
> 
> Do we need to add a --version (or -V) option to smbinfo to display the
> version number (as we do with mount.cifs e.g.)

Would not hurt. As it is a simple python script I expect it to have bursts of contributions and
features added or changed quite a bit so it would be useful to easily identify the exact version of the script.

> 
> --
> Thanks,
> 
> Steve
> 
> 

