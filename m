Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEDA6C636CC
	for <linux-cifs@archiver.kernel.org>; Mon, 13 Feb 2023 09:44:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbjBMJoG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 13 Feb 2023 04:44:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbjBMJoE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 13 Feb 2023 04:44:04 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F39D64C08
        for <linux-cifs@vger.kernel.org>; Mon, 13 Feb 2023 01:43:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676281387;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=w//lLvDMGkGDa7tyy0b9UTVUTyTlDGETFz9NwLblz2I=;
        b=PNr3G4D2MBomkwo2JQtMoS83N4vms8B6mil4BQdvkPmsvKY582LDWqIhN1bPiDiDrEvvwe
        BNswenOCo4yac9QiTnjUo74iwSvCjnSGpojNSpxTCLRFF3jOG0lm8SHpmHN2nPBbprWvku
        TD6OsJNvERoy33CQ2iAYt1c1XF9s+zI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-152-Ugzl_MP9O-SMJE5Ls9g9Rw-1; Mon, 13 Feb 2023 04:43:03 -0500
X-MC-Unique: Ugzl_MP9O-SMJE5Ls9g9Rw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8924D85A5A3;
        Mon, 13 Feb 2023 09:43:03 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2482518EC5;
        Mon, 13 Feb 2023 09:43:03 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <DM4PR21MB3441F89E32F0984DE605C67AE4DD9@DM4PR21MB3441.namprd21.prod.outlook.com>
References: <DM4PR21MB3441F89E32F0984DE605C67AE4DD9@DM4PR21MB3441.namprd21.prod.outlook.com> <202302130931.zOOQKBPI-lkp@intel.com>
To:     Steven French <Steven.French@microsoft.com>
Cc:     dhowells@redhat.com,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Subject: Re: [EXTERNAL] [cifs:for-next 21/25] fs/netfs/iterator.c:372:19: error: 'netfs_extract_iter_to_sg' undeclared here (not in a function); did you mean 'netfs_extract_user_iter'?
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1747438.1676281382.1@warthog.procyon.org.uk>
Date:   Mon, 13 Feb 2023 09:43:02 +0000
Message-ID: <1747439.1676281382@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steven French <Steven.French@microsoft.com> wrote:

> This patch is no longer in for-next (it was only in briefly iirc). Am I
> missing a patch depenency?  for-next built fine for me when I tried earlier
> today.

Without knowing what's on your for-next branch, it's hard to say.

Do you want a hangout later to discuss it?  Say 9pm my time, 3pm yours (I
think).

David

