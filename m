Return-Path: <SRS0=TaZu=3G=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8DB0C33CAF
	for <linux-cifs@archiver.kernel.org>; Fri, 17 Jan 2020 03:04:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ACDEF2072B
	for <linux-cifs@archiver.kernel.org>; Fri, 17 Jan 2020 03:04:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="alOk43hD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389236AbgAQDEV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 16 Jan 2020 22:04:21 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:48850 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388298AbgAQDEV (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 16 Jan 2020 22:04:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579230260;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dPPEBcv4TBO33AV58McnGR9jTaMWRyaA5nLrYaJHFWE=;
        b=alOk43hD9uzPW8QBkg3krZajbg3o5oVXohQpxOBQPNyIuHuh5owxTaipDiW68r/hRxUQjh
        O9dVONSxA/BzlcVMGdJFoGKKPnfcMUvppiMHi/Oourtug9RY6+glZdQQNQNU12AGz/b1jj
        lv3VMErp3BO+R8ZfDFqFZfakZpxbz7M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-382-O6_ZzSWyPFmgEwirHChFzg-1; Thu, 16 Jan 2020 22:04:18 -0500
X-MC-Unique: O6_ZzSWyPFmgEwirHChFzg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0D80BDBA5;
        Fri, 17 Jan 2020 03:04:18 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 036008432E;
        Fri, 17 Jan 2020 03:04:18 +0000 (UTC)
Received: from zmail25.collab.prod.int.phx2.redhat.com (zmail25.collab.prod.int.phx2.redhat.com [10.5.83.31])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id EDA28503A4;
        Fri, 17 Jan 2020 03:04:17 +0000 (UTC)
Date:   Thu, 16 Jan 2020 22:04:17 -0500 (EST)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Message-ID: <644970174.6192265.1579230257768.JavaMail.zimbra@redhat.com>
In-Reply-To: <CAH2r5mvLCqTXVFG93AgSJHTu8daMLwV_hpbjgJs-7orUwr7ffg@mail.gmail.com>
References: <CAH2r5mvLCqTXVFG93AgSJHTu8daMLwV_hpbjgJs-7orUwr7ffg@mail.gmail.com>
Subject: Re: [PATCH][SMB3] Fix modefromsid newly created files to allow more
 permission on server
MIME-Version: 1.0
Content-Type: multipart/alternative; 
        boundary="----=_Part_6192263_448403399.1579230257767"
X-Originating-IP: [10.64.54.71, 10.4.195.6]
Thread-Topic: Fix modefromsid newly created files to allow more permission on server
Thread-Index: +zyBFZFPqsvmA4AnQ4A+n/tg1tJcHQ==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

------=_Part_6192263_448403399.1579230257767
Content-Type: multipart/related; 
	boundary="----=_Part_6192264_795809670.1579230257768"

------=_Part_6192264_795809670.1579230257768
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Reviewed-By: Ronnie Sahlberg <lsahlber@redhat.com>

But drop the extra parenthesises here :
+		 (2 * sizeof(struct cifs_ace));

----- Original Message -----
From: "Steve French" <smfrench@gmail.com>
To: "CIFS" <linux-cifs@vger.kernel.org>
Sent: Friday, 17 January, 2020 12:28:03 PM
Subject: [PATCH][SMB3] Fix modefromsid newly created files to allow more permission on server

    When mounting with "modefromsid" mount parm most servers will require
    that some default permissions are given to users in the ACL on newly
    created files, and for files created with the new 'sd context' -
when passing in
    an sd context on create, permissions are not inherited from the parent
    directory, so in addition to the ACE with the special SID (which contains
    the mode), we also must pass in an ACE allowing users to access the file
    (GENERIC_ALL for authenticated users seemed like a reasonable default,
    although later we could allow a mount option or config switch to make
    it GENERIC_ALL for EVERYONE special sid).




-- 
Thanks,

Steve

------=_Part_6192264_795809670.1579230257768--

------=_Part_6192263_448403399.1579230257767--

