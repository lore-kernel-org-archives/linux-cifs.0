Return-Path: <SRS0=Z9xR=A3=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 415A3C433DF
	for <linux-cifs@archiver.kernel.org>; Thu, 16 Jul 2020 05:40:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C41B206F4
	for <linux-cifs@archiver.kernel.org>; Thu, 16 Jul 2020 05:40:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YXof61Mm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725921AbgGPFkn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 16 Jul 2020 01:40:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725844AbgGPFkn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 16 Jul 2020 01:40:43 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B9BCC061755
        for <linux-cifs@vger.kernel.org>; Wed, 15 Jul 2020 22:40:43 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id y17so2261202ybm.12
        for <linux-cifs@vger.kernel.org>; Wed, 15 Jul 2020 22:40:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=oTFmU6rH05c0yc/EFCCNRAx1y5jjOSqu8GlE/6Ao2Ew=;
        b=YXof61MmqwSd7EINqsROPksbO5ZnsvPgn3EieoA2jADXI1hlk78b0gWcmx7A9r6M64
         cDcatIgXSzWmPrhbmK9YbVfYKJ0EhkdoPscxiaK5+1l0oxOGjbmiUgFm93v6NyabeNLD
         n0ApR62CR5OY65gaYO7CyraRCs7kwu+YKyqO7VWvL9IG5q9J/Y1qdgEFnWyPP/hqC9L1
         AP+jBA3cnpLM+PKH3EGhU/4+em9kfJ6/m7zjYXH1n5ZrWV5lCxXShVBDAL96hlj1Xzpq
         hWhh6/fLAm2XGXhbWxZ4Pm7qeAKwuE26SPZQPcLRskuwgXxwOFpn3iMGiHVlwvmA21/O
         Z9gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=oTFmU6rH05c0yc/EFCCNRAx1y5jjOSqu8GlE/6Ao2Ew=;
        b=A6g4IJE9qamczwhTE35vSbJrfhr2IUvngkmLMMCq5ha+o9AOPsDSqzDjilxIRG34vz
         tvditTroCNhyAevhy9TlxMv9UQ4ElFF7I9S6Tt5MElS4iHoETzBjnAfA76JJo23Jr9ua
         Lk1dL1X5TVSyBlgoWjzvJ2ojo0H3cd9BinZ3qEiEYOv7fb9WUH++zfoida5FFfUm1Vfg
         tTx/4iJAhBOnvO/ZeYf656UoMK34X+7JwWfAZq2Ecp3wbaU6mkWs+2us+XU83lyA1jNa
         cEJOv3e1ODyDBCyi7oR9385Hfp5HSm9H75ot9t1/slEr49B0DdR2E340QW1nhQpScyBI
         39/Q==
X-Gm-Message-State: AOAM532z2QtN/Lol9XzdXcxs17PldRITp1qCtArIhJSki8zi+HmiRdJ7
        35yV/PJq7xhmr+61Ele7I1Wenvqu2uCA4OPuuulnrk+MKjI=
X-Google-Smtp-Source: ABdhPJwbHlkTVA97LK55eN+rZq5zp69gOcgEs0q9mFWpfdl0UKe9tUFdJOJHz0Y/1iECjhEUpsKKws+qtnFUJlMOlmU=
X-Received: by 2002:a5b:808:: with SMTP id x8mr3814737ybp.375.1594878042086;
 Wed, 15 Jul 2020 22:40:42 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 16 Jul 2020 00:40:31 -0500
Message-ID: <CAH2r5mvKTwGa0W_LcfgNwNQ6QY=pXSBkURV7MtnDz-hfArPTcQ@mail.gmail.com>
Subject: [PATCH][SMB3] warn on confusing error scenario with sec=krb5
To:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

    When mounting with Kerberos, users have been confused about the
    default error returned in scenarios in which either keyutils is
    not installed or the user did not properly acquire a krb5 ticket.
    Log a warning message in the case that "ENOKEY" is returned
    from the get_spnego_key upcall so that users can better understand
    why mount failed in those two cases.

    CC: Stable <stable@vger.kernel.org>
    Signed-off-by: Steve French <stfrench@microsoft.com>

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 2f4cdd290c46..492688764004 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1387,6 +1387,8 @@ SMB2_auth_kerberos(struct SMB2_sess_data *sess_data)
        spnego_key = cifs_get_spnego_key(ses);
        if (IS_ERR(spnego_key)) {
                rc = PTR_ERR(spnego_key);
+               if (rc == -ENOKEY)
+                       cifs_dbg(VFS, "Verify user has a krb5 ticket
and keyutils is installed\n");
                spnego_key = NULL;
                goto out;
        }


-- 
Thanks,

Steve
