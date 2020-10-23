Return-Path: <SRS0=9U06=D6=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1D16C388F9
	for <linux-cifs@archiver.kernel.org>; Fri, 23 Oct 2020 19:31:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 466F121582
	for <linux-cifs@archiver.kernel.org>; Fri, 23 Oct 2020 19:31:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JZalRL0Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1750758AbgJWTbn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 23 Oct 2020 15:31:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S465819AbgJWTbn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 23 Oct 2020 15:31:43 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E4A5C0613CE
        for <linux-cifs@vger.kernel.org>; Fri, 23 Oct 2020 12:31:43 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id a9so3424473lfc.7
        for <linux-cifs@vger.kernel.org>; Fri, 23 Oct 2020 12:31:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=tcPRoD8v+bJgW1TziTv7YcxcW0cWwyBK3J6ySas8mnU=;
        b=JZalRL0Y1uJXnSwm5yoEvCoX55T6/Xhb0+CdLpgNLVlSMISWdpPMgNBiPLSt+6muLS
         EsxaSgmHoo9MuTyrfn8BE2y5Fm9y5xTRGx+Bu4gHz5nTQ2ClmNXvz9VRlF3+z4bmlNof
         C3N5h1p1BHjPH6yBjZ4MPhmV3M8belwZXLPbe0q602nrQL0OEj5JBOhXAHEj5y6csTNJ
         23JMeRTEpXFx70djGeZXRbXjT0yXQA9Wi3rXhfEzsYtQy1fGWKpULw2jiHXpsBjIsvoi
         mC9+XlmW9TJzthBuaauH109Q8rBJc6u0b9Cj7LZynww7gbNglmxa7Ab8V5TrgekTYEMw
         Oi7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=tcPRoD8v+bJgW1TziTv7YcxcW0cWwyBK3J6ySas8mnU=;
        b=YIeVs7yDS+OtH9KQcXh5wMQCw5Q4dlMSEMZKv1z+OUpZ3GLIBzjFS/fEiiXW1vHKWV
         hP9DsuS4JadqECQl2oGbNpDdY7+3rsd+b2ftK5Fuya6jh7sch2oeH38DbC3XSqULvfQE
         juhhtmdsxFubSm1qmj48ikuu9NduluAxa0gpzs9TVffIpRxR2ZR2OKzWKhW5ax3e8bsU
         MApAUlDaKk+aBj9l7pbvTLwgxIAwpP0/6l4OTRDo3Cxwt3IQ2qGRul6LX6GR01FgpFgx
         SMHIPZcjF/ZCwMqcXSGKnQEfePjR6UpcOqL5um3A04KFqmGi5DPpFsxCf6B6ZestvmH/
         RhGQ==
X-Gm-Message-State: AOAM5338KcchTkhoNntOKvAPcO3rvGumEeP4SAD+9yn1b3r5FsU9a2i+
        O5Vf15vOEDyRhVEqYlZ1FLg5NyVd4CfdUYOwJCE=
X-Google-Smtp-Source: ABdhPJxbLd0pFhqspHasip+/qv4ArDdckqt6uHlmYbeS2hg6XBwnTjR9r9lFYr3crLcxlQk9KbWhFrpX6EHdJY5Fi1g=
X-Received: by 2002:a19:7d0b:: with SMTP id y11mr1370228lfc.305.1603481501621;
 Fri, 23 Oct 2020 12:31:41 -0700 (PDT)
MIME-Version: 1.0
References: <0ff7a5c9-d016-b480-ed10-0634316b00ca@talpey.com>
In-Reply-To: <0ff7a5c9-d016-b480-ed10-0634316b00ca@talpey.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 23 Oct 2020 14:31:30 -0500
Message-ID: <CAH2r5mtb-aZ+8Tyf6Gz3y_vzWA22ghDEDVWBe7buc8nt8HJymg@mail.gmail.com>
Subject: Fwd: AES CCM/GCM nonce generation possible issue
To:     Jeremy Allison <jra@samba.org>,
        "Stefan (metze) Metzmacher" <metze@samba.org>,
        Tom Talpey <ttalpey@microsoft.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Interestingly Samba client appears to partition nonce high and nonce
low based on what I see in smbXcli_base.c and do something similar to
what you suggested.

---------- Forwarded message ---------
From: Tom Talpey <tom@talpey.com>
Date: Fri, Oct 23, 2020 at 2:22 PM
Subject: AES CCM/GCM nonce generation possible issue
To: linux-cifs@vger.kernel.org <linux-cifs@vger.kernel.org>


In the recent changeset I spotted a concern in the existing
nonce generation. The code appears to be using a randomly
generated value for each new op. This runs the risk of reusing
a nonce, should the RNG produce a cycle, or if enough requests
are generated (not an impossibility with high-bandwidth RDMA).

It's a critical security issue to never reuse a nonce for a
new data pattern encrypted with the same key, because the cipher
is compromised if this occurs. There is no need for the nonce
to be random, only different. With 11+ bytes of nonce, it
is possible to partition the field and manage this with a
simple counter. The session encryption can be rekeyed prior
to the counter wrap. The nonce field can then be a property
of the session.

Or, am I incorrect in my understanding of the following?

In fs/cifs/smb2ops.c:

3793 static void
3794 fill_transform_hdr(struct smb2_transform_hdr *tr_hdr, unsigned int
orig_len,
3795                    struct smb_rqst *old_rq, __le16 cipher_type)
3796 {
3797         struct smb2_sync_hdr *shdr =
3798                         (struct smb2_sync_hdr
*)old_rq->rq_iov[0].iov_base;
3799
3800         memset(tr_hdr, 0, sizeof(struct smb2_transform_hdr));
3801         tr_hdr->ProtocolId = SMB2_TRANSFORM_PROTO_NUM;
3802         tr_hdr->OriginalMessageSize = cpu_to_le32(orig_len);
3803         tr_hdr->Flags = cpu_to_le16(0x01);
--\
3804         if (cipher_type == SMB2_ENCRYPTION_AES128_GCM)
3805                 get_random_bytes(&tr_hdr->Nonce, SMB3_AES128GCM_NONCE);
3806         else
3807                 get_random_bytes(&tr_hdr->Nonce, SMB3_AES128CCM_NONCE);
--/
3808         memcpy(&tr_hdr->SessionId, &shdr->SessionId, 8);
3809 }

In MS-SMB2 section 2.2.41:

AES_CCM_Nonce (11 bytes): An implementation-specific value assigned for
every encrypted message. This MUST NOT be reused for all encrypted
messages within a session.

[several other similar statements throughout document]


-- 
Thanks,

Steve
