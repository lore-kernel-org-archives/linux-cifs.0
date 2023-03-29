Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D508C761A6
	for <linux-cifs@archiver.kernel.org>; Wed, 29 Mar 2023 20:14:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbjC2UOs (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 29 Mar 2023 16:14:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbjC2UOs (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 29 Mar 2023 16:14:48 -0400
Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95D7E30C7
        for <linux-cifs@vger.kernel.org>; Wed, 29 Mar 2023 13:14:47 -0700 (PDT)
From:   Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1680120886;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2+sWfQUUU6ZOWnURaxnFXP8CMHOEh2Xs0bYQLq6uVss=;
        b=bA/NuiII6zzuMV8ZwSbgzmeM6SyPpgT/4JdaCjsy8t1czkt4WRiaX11EbkHpfb/ovfpMcf
        QFeWzWjLL8CXj2OxzkGYc+41TUUrnOgLL0Bwr2kLEtYeYFAfLUKszHLWNNPXn6ubogPJtx
        UGYxsu4WrhE6RvRPw5m7p93xcIFOc2AdctootSHvB3cp8XnoCCbU2jtMz6w7PSd7M+Bx6g
        VDmEGJseuWYZE4IsvkAfeAUlSqlpOB2TRK8SKpKWFHNipQ7hVIgQ8wP8QEFIcrwMnKsyIR
        +oYU4afasKCeL0cOQm+DegNv0pSCGIc3jnR0OVTaTw1n+XycjVfe0X3slHh8Dg==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1680120886; a=rsa-sha256;
        cv=none;
        b=fn1wzRMdIU98JrFM+YXt9vUEwSji0DVHTWgMRZLK1XTTLCc3WSLpJqOysw5u2AkRJfP8eR
        WjKzuzNZfwN0GlDsOcWe6mAXcTmYc2tZ0awiSsKEe53yXpXHLCTKhhhjR8c9ftx2ONkWge
        hoJiHChVVx75lHoLZlAOQB+shzDk2C1H3RggM77oHPKG54qrN81hNo5Rrw7lf+njj0AfoU
        WR3qtN31JFAZJLRAMcn/Z66ZNWTKlxatRUsiYJxIw7Zl19EzqCtfTEj8/YAv6yquiagCki
        0dY+xxAGU9UgfT24C+c8Oi1Xz9BWgBA7iQ9cE2moqhJMWqKvlJZxOUlzj/q/wg==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1680120886;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2+sWfQUUU6ZOWnURaxnFXP8CMHOEh2Xs0bYQLq6uVss=;
        b=R2e9BDD2UfEWek9NfJ2Kix/djKsCal95lBF3XLfKg9pgtKww57Aq1dlwx7D2MUSuYb/5jm
        pQi53fjHkw+4Ja/FlUgJH2ndpvKNyq3SoHJW1D8FriQEiQRERTkoniPF3ZRRjmU+dv0JK6
        5T/7/zdOc6wYelHGUjMyR+eYo+0xfATNssfVl/k9iMkyYxIDS4FOGW1yr6wLHpC45t8KEV
        lMXbgm6y+UVJrwqgeekVcFJbPwGgIJcitkgtugT6VYte30t2sLu7Dp4diifaiUmbFT4a3F
        paV8LqjioxMXoFWaqc4cP3jajINdd6WiT0FyJpJncGYHZn1bKJ+0iXeEcvdXIQ==
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 5/5] cifs: get rid of dead check in smb2_reconnect()
Date:   Wed, 29 Mar 2023 17:14:23 -0300
Message-Id: <20230329201423.32134-5-pc@manguebit.com>
In-Reply-To: <20230329201423.32134-1-pc@manguebit.com>
References: <20230329201423.32134-1-pc@manguebit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The SMB2_IOCTL check in the switch statement will never be true as we
return earlier from smb2_reconnect() if @smb2_command == SMB2_IOCTL.

Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
 fs/cifs/smb2pdu.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 6bd2aa6af18f..2b92132097dc 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -310,7 +310,6 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	case SMB2_READ:
 	case SMB2_WRITE:
 	case SMB2_LOCK:
-	case SMB2_IOCTL:
 	case SMB2_QUERY_DIRECTORY:
 	case SMB2_CHANGE_NOTIFY:
 	case SMB2_QUERY_INFO:
-- 
2.40.0

