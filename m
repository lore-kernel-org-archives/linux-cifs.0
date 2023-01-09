Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A48CBC5479D
	for <linux-cifs@archiver.kernel.org>; Mon,  9 Jan 2023 22:16:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237777AbjAIWQp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 9 Jan 2023 17:16:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237709AbjAIWQn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 9 Jan 2023 17:16:43 -0500
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB48817E37
        for <linux-cifs@vger.kernel.org>; Mon,  9 Jan 2023 14:16:37 -0800 (PST)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 237947FC04;
        Mon,  9 Jan 2023 22:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1673302595;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nLhDSdzXJG3YpPKrCdh46Bqed5RlawBvTrcMspX1ewQ=;
        b=ecQm14l6CgkfeujTKm53MgUISvenJ6aDZ1y2fstCHYZgB/SbxcxyLVBdLnKGCjIJY39r3b
        z3BtdGkgyz83WJThcEnr6jAciKWZBXTr9wcHCu88Me2YGzef08fEsQ42/nG+bEcFsoRo/5
        BTrt/iCzX/zVlX+BKup+4kFnTPS1+3OoNz7+SWkvdE+KgWq1m1oa+WkQwb7f1cb4askT8r
        G5APJwfrCVkYM1KsYSzwMtXpMzBWfU1ix3JoXXTNS2ROcoyiJUkVp1UxcTPpb/+GRdjQTF
        bakgn6+nvIE47t4c/t6ZP01jMZQdPwbeW/kwAgYSg2KTRCpI244WBSQk5Qzibw==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Xiaoli Feng <fengxiaoli0714@gmail.com>,
        Steve French <sfrench@samba.org>, lsahlber@redhat.com,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: CIFS: kernel BUG at mm/slub.c:435
In-Reply-To: <CAOoqPcSqOZWN7LKmZQzPhu8MWxNsxYoDs2woHotE_te__+MF=w@mail.gmail.com>
References: <CAOoqPcSqOZWN7LKmZQzPhu8MWxNsxYoDs2woHotE_te__+MF=w@mail.gmail.com>
Date:   Mon, 09 Jan 2023 19:16:30 -0300
Message-ID: <87pmbnwdz5.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Xiaoli Feng <fengxiaoli0714@gmail.com> writes:

> Test the latest kernel in the branch for-next of
> git://git.samba.org/sfrench/cifs-2.6.git. Kernel always panic when
> mount cifs with option "-o sec=krb5,multiuser".
>
> Bug 216878 - CIFS: kernel BUG at mm/slub.c:435
> https://bugzilla.kernel.org/show_bug.cgi?id=216878

Thanks for the report.

I wasn't able to reproduce it but the issue seems related to
sesInfoFree() calling kfree_sensitive() again in
cifs_ses::auth_key.response even though it was kfree_sensitive()'d
earlier in SMB2_auth_kerberos().

Does below changes fix your issue?  Thanks.

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 2c484d47c592..727f16b426be 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1482,8 +1482,11 @@ SMB2_auth_kerberos(struct SMB2_sess_data *sess_data)
 out_put_spnego_key:
 	key_invalidate(spnego_key);
 	key_put(spnego_key);
-	if (rc)
+	if (rc) {
 		kfree_sensitive(ses->auth_key.response);
+		ses->auth_key.response = NULL;
+		ses->auth_key.len = 0;
+	}
 out:
 	sess_data->result = rc;
 	sess_data->func = NULL;
