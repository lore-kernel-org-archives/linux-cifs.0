Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6010CC433E0
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Jan 2021 17:02:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D40A2339D
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Jan 2021 17:02:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727679AbhAMRCY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 13 Jan 2021 12:02:24 -0500
Received: from mx.cjr.nz ([51.158.111.142]:25134 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727301AbhAMRCY (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 13 Jan 2021 12:02:24 -0500
X-Greylist: delayed 633 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Jan 2021 12:02:24 EST
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 140777FD02;
        Wed, 13 Jan 2021 16:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1610556670;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DabtPvXfLlnC0IkYRUgE46aazpziGrV77mrQS3sNgYc=;
        b=BgNZiH02vZ4jXjupAeNVwr/BaeY8m7EzoUklhjFWIMlr1Dxwqluh5S/KXn6xPor+AqJunq
        FusPOhNi89NYcWDkx1sWBzY3dmB5nPmlkE1G+AyP3I4SZuo/SzIFqwxpqffhUcstgJY9eL
        EZOFzNPnASvXIIGweHpAFB/fdpxtK+fCgzCyW0jiDvFROSlTiJxWJaNOrrwIO78ArBKgqn
        tvRRcvd45DC+QufHldWAjhfeQZTlD86EpKPSlz4DpgOLvCuwvBEwSN81M1ZDZaEnQaZ9W9
        vwqA8dZfKcH/Qppts/o6Rf1AkMiDTcoNuyFdKWRI14DOcVZyMumQBV8+cnmcVg==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Pavel Shilovsky <piastryyy@gmail.com>,
        =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>,
        Steve French <smfrench@gmail.com>
Cc:     Duncan Findlay <duncf@duncf.ca>,
        linux-cifs <linux-cifs@vger.kernel.org>
Subject: Re: [bug report] Inconsistent state with CIFS mount after
 interrupted process in Linux 5.10
In-Reply-To: <CAKywueQ9jmyTaKqR2x0nL-Q8A=-V1fP_1L2n=b+OdUzVhV083Q@mail.gmail.com>
References: <CAE-Mgq2kwwZJicbU9oenD4M5SQhbErhXovGX+LKtcnRbLC4xSg@mail.gmail.com>
 <87ft35kojo.fsf@suse.com>
 <CAKywueQ9jmyTaKqR2x0nL-Q8A=-V1fP_1L2n=b+OdUzVhV083Q@mail.gmail.com>
Date:   Wed, 13 Jan 2021 13:51:02 -0300
Message-ID: <87h7nk6art.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Pavel Shilovsky <piastryyy@gmail.com> writes:

> Thanks for reporting the issue.
>
> The problem is with the recent fix which changes the error code from
> -EINTR to -ERESTARTSYS:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/fs/cifs/transport.c?id=6988a619f5b79e4efadea6e19dcfe75fbcd350b5
>
> and this problem happens here:
>
> https://git.samba.org/sfrench/?p=sfrench/cifs-2.6.git;a=blob;f=fs/cifs/smb2pdu.c;h=067eb44c7baa863c1e7ccd2c2f599be0b067f320;hb=236237ab6de1cde004b0ab3e348fc530334270d5#l3251
>
> So, interrupted close commands don't get restarted by the client and
> the client leaks open handles on the server. The offending patch was
> tagged stable, so the fix seems quite urgent. The fix itself should be
> simple: replace -EINTR with -ERESTARTSYS in the IF condition or even
> amend it with "||".

Yes, makes sense.

Maybe we should do something like below

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 067eb44c7baa..794fc3b68b4f 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -3248,7 +3248,7 @@ __SMB2_close(const unsigned int xid, struct cifs_tcon *tcon,
 	free_rsp_buf(resp_buftype, rsp);
 
 	/* retry close in a worker thread if this one is interrupted */
-	if (rc == -EINTR) {
+	if (is_interrupt_error(rc)) {
 		int tmp_rc;
 
 		tmp_rc = smb2_handle_cancelled_close(tcon, persistent_fid,
