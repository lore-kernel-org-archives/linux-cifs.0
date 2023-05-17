Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9795EC77B75
	for <linux-cifs@archiver.kernel.org>; Wed, 17 May 2023 19:03:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbjEQTDE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 17 May 2023 15:03:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjEQTDE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 17 May 2023 15:03:04 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A31B83FD
        for <linux-cifs@vger.kernel.org>; Wed, 17 May 2023 12:03:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Cc:To:From:Date;
        bh=P636JvRjP99Vp25C5GdD+Kix1+fh82UGiZ7mRPrG3tY=; b=BfynwOet6iDOZB/faungEa5vHA
        37ukjDvXeWRdHTlvk+9f+NDqh5Eyl7TiDnjomLLH9sAe2qfF7ekOwim6QZ9aUJf7U/Vz1izUBS51M
        fnpHMSBW7fnyzW9a9/DcElC2GCTyphLQ9mRf9rXH8k5uxmigSErWWTJ+DgNIB+TQAnnJ6l30P7ysD
        +RqLn9Yie1G9JIWm0poFLj+7ZG3AmEuys0tESFWW+Ok3Bl4+DkW/XBU6Db/d5UPLu5oPBIA/WaqOa
        wNcIa7bcOXsZ1p7XOf3LAElQYKxEvmPeXOJAOLKmPCU7oFf1i0HZnKTO3hT0CHg+RiLoDEe5dILC7
        xdizZ9+I7S4z4k7aKlc4SQ8JKqYx2EhHDJB0kpOhhfSVjuw2hhdRBkfnc9VqlElbVwigqqL/qJJnq
        DPQvSy87YbN7ecFLEt60QKlpEQirKelOFoa2C37ZS9egnSLb7K6kB8j/wyLziirYgeu557LmtcxJQ
        5O4dRUz+wAkt0rQ+T2JNBULU;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1pzMQL-009gDb-57; Wed, 17 May 2023 19:02:57 +0000
Date:   Wed, 17 May 2023 12:02:52 -0700
From:   Jeremy Allison <jra@samba.org>
To:     HexRabbit <h3xrabbit@gmail.com>
Cc:     linkinjeon@kernel.org, sfrench@samba.org, senozhatsky@chromium.org,
        tom@talpey.com, linux-cifs@vger.kernel.org
Subject: Re: [PATCH] ksmbd: fix multiple out-of-bounds read during context
 decoding
Message-ID: <ZGUk3O75foDOPaJ7@jeremy-rocky-laptop>
Reply-To: Jeremy Allison <jra@samba.org>
References: <20230517185820.1264368-1-h3xrabbit@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230517185820.1264368-1-h3xrabbit@gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, May 17, 2023 at 06:58:20PM +0000, HexRabbit wrote:
>From: Kuan-Ting Chen <h3xrabbit@gmail.com>
>
>Ensure the context's length is valid (excluding VLAs) before casting the
>pointer to the corresponding structure pointer type, also removed
>redundant check on `len_of_ctxts`.
>
>Signed-off-by: Kuan-Ting Chen <h3xrabbit@gmail.com>
>---
> fs/ksmbd/smb2pdu.c | 23 +++++++++++++++++------
> 1 file changed, 17 insertions(+), 6 deletions(-)
>
>diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
>index 972176bff..83b877254 100644
>--- a/fs/ksmbd/smb2pdu.c
>+++ b/fs/ksmbd/smb2pdu.c
>@@ -969,18 +969,16 @@ static __le32 deassemble_neg_contexts(struct ksmbd_c=
onn *conn,
> 	len_of_ctxts =3D len_of_smb - offset;
>
> 	while (i++ < neg_ctxt_cnt) {
>-		int clen;
>-
>-		/* check that offset is not beyond end of SMB */
>-		if (len_of_ctxts =3D=3D 0)
>-			break;
>+		int clen, ctxt_len;

Just a drive-by comment here (haven't had time to look at the
underlying code).

Should lengths in protocol parsing *ever* be defined at 'int' ?

IMHO no, never. That's a disaster waiting to happen as int
overflow driven by the peer can often cause integer wrap to
negative, leaving all the nice "not greater than packet length"
to fail horribly. We excised all 'int' length representations
=66rom the Samba parser a long time ago.
