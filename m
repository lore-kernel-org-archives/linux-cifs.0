Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FC71C7EE2E
	for <linux-cifs@archiver.kernel.org>; Tue, 28 Feb 2023 00:10:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbjB1AKJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 27 Feb 2023 19:10:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbjB1AKG (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 27 Feb 2023 19:10:06 -0500
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C51140CF
        for <linux-cifs@vger.kernel.org>; Mon, 27 Feb 2023 16:09:55 -0800 (PST)
Message-ID: <8a0a723accb2b3bbaa48dd98d5572ebb.pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1677542967;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=swTbyEyB1VfTqVHb16+knnMr6zQTRgU5iFHZQzbmkrk=;
        b=fPQwzGYOK/fVsyqxQXYTTIsBI8fkgHzQ41IHAXs8cZHRAmjMQdzhElwLUxoROVppLgSMpm
        P0j8KcfDShIuNuct7w0I/o+9W5/UL1D5Ed1iT1LhaVdfSpa4SJGelUVkvEWGOb/kjoWgOm
        mZP0Quo2YcHvVdYjeccAo9T3LJLKHwo2r/iLGwAwoU1B44x1BVbgOsvVZXsrP9DCdyrTSG
        wwRUrtfSt1/O1uf2vxvwTawxQRvzz1ZlLR1gyaG2Vo3/ouAzmqQZKmgjduNAIwxg6ISe1F
        4aGQ+CHjbpXNYzY1UlF17/r0Rd+/Tq96RTfJrXVNGlk468RDV/2V/vJ6ePVEzQ==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1677542967; a=rsa-sha256;
        cv=none;
        b=oWrh7E3asHiic6E0U9/tallayI+I+gSVuvRtYBqU5cip7X3eNQhY5+QeHPAFZ3syvthdFY
        3c1FoWkkfuYalsHdLSJcaZzORcmHPAwY3HCb26lbFQ9uDeexuxr4lRM0Bk8KpjItFE/+Z3
        FC3PkOo2Tih6vnm/0vaknUDTO4u9Jrdwov2LWbCG3ssLQAk/rTWgtRLcsDJQTcNJQWIxsz
        u/iC7eKZgbUhGeys0fAIEujk/XyS9Pez8bW350avqk/61h+/U+jNWRe7V5UyxHiePtySag
        /A8BfSQVEl8aiutaBKHqQfA7OmA3Zh3npwHPkRxnZ+++E/EXswyhL7E5SRNoFg==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1677542967;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=swTbyEyB1VfTqVHb16+knnMr6zQTRgU5iFHZQzbmkrk=;
        b=q5COPUqcQ9psTQFiYHRcmmD+fHYWoVX91KD0BuMOGaBJeZw4XCF2AlC/D3JhaONGOUBX9L
        W9r0BMI9OiDvl9p6U1Dch+M1XUyvp2UtUNuO9RXYRdrqc2UoT3xKzZBbooxvZcaSi+cj0D
        5S3oOzFNurqbdKbmpSQJKJRLHC4f9Ca4HAapBREPCj0RazJ3AlMoKuOHfaFN/Dc7lnYCEk
        riuzVcfdQlBOJqI7m/GOXHTcc3OwLwgQYt6pl7PVO+K2dV4Z6Ss95NBx9KbQ+P/pc3pYpa
        4LEg6+dPFO5ClErHjH67YkcrxtV3uvUiAl7XQIPc0fiAHBbfziM2UHavf+mRGg==
From:   Paulo Alcantara <pc@manguebit.com>
To:     Steve French <smfrench@gmail.com>
Cc:     linux-cifs@vger.kernel.org
Subject: Re: [PATCH 2/2] cifs: prevent data race in cifs_reconnect_tcon()
In-Reply-To: <CAH2r5mufi6BRa3tDdzpDNsLDsE2g8ApTTYgK4zF_wU9ExEc1EQ@mail.gmail.com>
References: <20230227135323.26712-1-pc@manguebit.com>
 <20230227135323.26712-2-pc@manguebit.com>
 <CAH2r5mufi6BRa3tDdzpDNsLDsE2g8ApTTYgK4zF_wU9ExEc1EQ@mail.gmail.com>
Date:   Mon, 27 Feb 2023 21:09:21 -0300
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve French <smfrench@gmail.com> writes:

>   CHECK   /home/smfrench/cifs-2.6/fs/cifs/smb2pdu.c
> /home/smfrench/cifs-2.6/fs/cifs/smb2pdu.c:204:20: warning: context
> imbalance in 'smb2_reconnect' - unexpected unlock

Thanks.

Please fold this change in

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 62c125e73b73..0e53265e1462 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -185,7 +185,6 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 
 	spin_lock(&server->srv_lock);
 	if (server->tcpStatus == CifsNeedReconnect) {
-		spin_unlock(&server->srv_lock);
 		/*
 		 * Return to caller for TREE_DISCONNECT and LOGOFF and CLOSE
 		 * here since they are implicitly done when session drops.
@@ -198,6 +197,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 		case SMB2_CANCEL:
 		case SMB2_CLOSE:
 		case SMB2_OPLOCK_BREAK:
+			spin_unlock(&server->srv_lock);
 			return -EAGAIN;
 		}
 	}
