Return-Path: <SRS0=pabO=SN=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46B05C282DA
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Apr 2019 02:20:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E10E2183E
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Apr 2019 02:20:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbfDKCU2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 10 Apr 2019 22:20:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37144 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725782AbfDKCU2 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 10 Apr 2019 22:20:28 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8A21B87637;
        Thu, 11 Apr 2019 02:20:28 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-110.bne.redhat.com [10.64.54.110])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 201541001E80;
        Thu, 11 Apr 2019 02:20:27 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>, Stable <stable@vger.kernel.org>
Subject: [PATCH 0/1] FSCTL write support
Date:   Thu, 11 Apr 2019 12:20:16 +1000
Message-Id: <20190411022017.24942-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Thu, 11 Apr 2019 02:20:28 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve,
This patch adds code to allow us to do fsctl passthrough for fsctl types that
need to pass data to the server.
This not only needs to pass the blob to the server but also need to decode
the access-type part of the fsctl code and change the arguments to the CREATE
accordingly.

The values for the access are from wireshark traces of win16 -> win16.
For now I only implement the special handling we need for 
FILE_READ_WRITE_ACCESS.
We can add the others as needed and as we we discover them while adding
new functions to smbinfo.

