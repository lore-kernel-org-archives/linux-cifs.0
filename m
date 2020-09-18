Return-Path: <SRS0=kqF3=C3=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56D1DC43463
	for <linux-cifs@archiver.kernel.org>; Fri, 18 Sep 2020 03:18:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08DA721582
	for <linux-cifs@archiver.kernel.org>; Fri, 18 Sep 2020 03:18:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Mjd/T38S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726249AbgIRDSX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 17 Sep 2020 23:18:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60725 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726201AbgIRDSX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 17 Sep 2020 23:18:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600399102;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=B7QZN5bB1ODEfpgdiy0j8chyOajh/Pya1JzNV03v1jw=;
        b=Mjd/T38ShaffP9mX2KHimRRxs6Ktzy2Ly5cdFtqH30P116JPfSP1+jKhm58i/RFang+d0g
        9qfnHLad/VrdtTHoa517e7lB8WvFzme9qkIbHOiYbGFaSvHniS6zrYbUuaR5Zt7JEkW9xq
        nbCOKRZmHJG/h8pNzWfE/VYfIDbTL18=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-189-FEGNzavJPuey-S0FoEE3Tg-1; Thu, 17 Sep 2020 23:18:20 -0400
X-MC-Unique: FEGNzavJPuey-S0FoEE3Tg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EA8401006717;
        Fri, 18 Sep 2020 03:18:18 +0000 (UTC)
Received: from test1103.test.redhat.com (vpn2-54-64.bne.redhat.com [10.64.54.64])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 88E1D7880F;
        Fri, 18 Sep 2020 03:18:18 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH] cifs: treat password/account expired as -EACCES
Date:   Fri, 18 Sep 2020 13:18:12 +1000
Message-Id: <20200918031812.20578-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

These two errors both require admin changes to the server before they can
be resolved so there is no point in looping to try to reconnect
indefinitely. Change the mapping to -EACCES so that we will quickly
terminate the reconnect for these threads and return an error back to userland.

RHBZ: 1798031

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/smb2maperror.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/smb2maperror.c b/fs/cifs/smb2maperror.c
index 7fde3775cb57..9cd231486af4 100644
--- a/fs/cifs/smb2maperror.c
+++ b/fs/cifs/smb2maperror.c
@@ -409,8 +409,8 @@ static const struct status_to_posix_error smb2_error_map_table[] = {
 	{STATUS_ACCOUNT_RESTRICTION, -EACCES, "STATUS_ACCOUNT_RESTRICTION"},
 	{STATUS_INVALID_LOGON_HOURS, -EACCES, "STATUS_INVALID_LOGON_HOURS"},
 	{STATUS_INVALID_WORKSTATION, -EACCES, "STATUS_INVALID_WORKSTATION"},
-	{STATUS_PASSWORD_EXPIRED, -EKEYEXPIRED, "STATUS_PASSWORD_EXPIRED"},
-	{STATUS_ACCOUNT_DISABLED, -EKEYREVOKED, "STATUS_ACCOUNT_DISABLED"},
+	{STATUS_PASSWORD_EXPIRED, -EACCES, "STATUS_PASSWORD_EXPIRED"},
+	{STATUS_ACCOUNT_DISABLED, -EACCES, "STATUS_ACCOUNT_DISABLED"},
 	{STATUS_NONE_MAPPED, -EIO, "STATUS_NONE_MAPPED"},
 	{STATUS_TOO_MANY_LUIDS_REQUESTED, -EIO,
 	"STATUS_TOO_MANY_LUIDS_REQUESTED"},
-- 
2.13.6

