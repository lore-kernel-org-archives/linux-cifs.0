Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26D0DC433E0
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Feb 2021 22:22:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D787664E56
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Feb 2021 22:22:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234303AbhBIWVt (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 9 Feb 2021 17:21:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233500AbhBIWPw (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 9 Feb 2021 17:15:52 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EF9BC061A2A
        for <linux-cifs@vger.kernel.org>; Tue,  9 Feb 2021 11:58:32 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id jj19so33872481ejc.4
        for <linux-cifs@vger.kernel.org>; Tue, 09 Feb 2021 11:58:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=4BZ08gZDuYzKG5eIuFN6xwxS5+LQ5I4Q6MVmw1iqtII=;
        b=cZUBlsaFoDUSKQLdDTibQVXnOsouvdeXxwCBwARFizbswJeHKShNH1Y2tsxJoecwxv
         rCjUq5uQn7nHjx7y+dBJpL7mpmRZxAbZDmAgMACrg4XwZrmNGrrLmACjYaVDtwyIxZVj
         06sC1b0KlA3K0ga0KjcP9emNpz1QJfJ2Xi+lljx2m8/mzxCESoOf+Bc8S8wD6f0igPRb
         ugdxa7hvYwF7h8Y5tBdXKSLbofxgSyhQpjNBiNtzY1VF4co4W8wuqmFX2+zn4Ncz/Ssi
         DGH6ADIA6aTz6/En9EDGbPPWaTFx07KBhmvfXmxrQTGIFzQeCLmN7R6muB+VzA/vHXuJ
         TuuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=4BZ08gZDuYzKG5eIuFN6xwxS5+LQ5I4Q6MVmw1iqtII=;
        b=h/vmopavVMes44KroP/QBHF/wS2RS6ZSDmce3/sPqwZyOUjVS8u5McY/r0jwFSU4ow
         JeOAAXk4W0UK6Jxn/RqBJ9UXPiYpDRDcQsVOijZGI0SYyAPRhay49fNVz6KnyRV4Mwcl
         QLc8Rf+FPBkn+2lEX7Y05i2rWnHQyE2L/wp5ZpA3webw/9LKqhfM+DIiM3alOxkquhC0
         r4ZafkBJsMhto+7FedKvhJzru41utX0BxjZ8DRzZBH4AS117APo3rVz4XkZ5/2FEMFPU
         tmw6GcYvEa7NhAwCLdsca7gzWCpURjLSyqqKRcCn+DgVfrWHQTnPS66XirOyV+aVeZld
         5r+Q==
X-Gm-Message-State: AOAM532q2Agn112JDYygJoG41kYbue9C1w1pNRmK09cFP6BtPLpubdsu
        u3qBnju9veW52SsHjCX69SN8TgOxejXv3SSWjw==
X-Google-Smtp-Source: ABdhPJx3wMGsOe6qQld89l1MH0cxzG6FCbwoykTSxxFEauhGgCpbllGMSIplpcZ4frBXM4F4fN8zpAdSovMJoiNFLpw=
X-Received: by 2002:a17:907:9483:: with SMTP id dm3mr23860738ejc.120.1612900710844;
 Tue, 09 Feb 2021 11:58:30 -0800 (PST)
MIME-Version: 1.0
References: <CANT5p=qrx1bKAcJGG=hGBkvwHjQWLgTH3kJ+g-YdZL0yfBtA9A@mail.gmail.com>
 <87mtwkno7q.fsf@suse.com> <CANT5p=qeEBwivE_Fc-Y4gj17d9nkU+ROPnZL=0BD3v_yRNBFtA@mail.gmail.com>
 <87blctmqo0.fsf@suse.com>
In-Reply-To: <87blctmqo0.fsf@suse.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Tue, 9 Feb 2021 11:58:19 -0800
Message-ID: <CAKywueRd1u_7F6qRkSRCtg5exPeNBSXANUiFTrUfcigJGMeP3Q@mail.gmail.com>
Subject: Re: [PATCH 1/4] cifs: New optype for session operations.
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 50fcb65920e8..1a1f9f4ae80a 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1704,7 +1704,8 @@ static inline bool is_retryable_error(int error)
 #define   CIFS_ECHO_OP      0x080    /* echo request */
 #define   CIFS_OBREAK_OP   0x0100    /* oplock break request */
 #define   CIFS_NEG_OP      0x0200    /* negotiate request */
-#define   CIFS_OP_MASK     0x0380    /* mask request type */
+#define   CIFS_SESS_OP     0x2000    /* session setup request */
+#define   CIFS_OP_MASK     0x2380    /* mask request type */

Why skipping 0x400, 0x800 and 0x1000 flags?

--
Best regards,
Pavel Shilovsky

=D0=B2=D1=82, 9 =D1=84=D0=B5=D0=B2=D1=80. 2021 =D0=B3. =D0=B2 03:22, Aur=C3=
=A9lien Aptel <aaptel@suse.com>:
>
> Shyam Prasad N <nspmangalore@gmail.com> writes:
>
> > I had missed one check where CIFS_SESS_OP also had to be checked. Not
> > doing so would disable echoes and oplocks.
>
> Reviewed-by: Aurelien Aptel <aaptel@suse.com>
>
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg,=
 DE
> GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=
=BCnchen)
>
