Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFCCBC19425
	for <linux-cifs@archiver.kernel.org>; Wed,  9 Dec 2020 19:35:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B525323BAC
	for <linux-cifs@archiver.kernel.org>; Wed,  9 Dec 2020 19:35:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728319AbgLITeK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 9 Dec 2020 14:34:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726662AbgLITeC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 9 Dec 2020 14:34:02 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CF89C0613D6
        for <linux-cifs@vger.kernel.org>; Wed,  9 Dec 2020 11:33:22 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id f23so3840337ejk.2
        for <linux-cifs@vger.kernel.org>; Wed, 09 Dec 2020 11:33:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=n2hc+QzvtZHrFjtO1vXBkANPpjyaJQos41FOXltNqOA=;
        b=CkJ9pqbJo35mFeIagTm9A71EXS6N1rWowqDX5y06Hcm3xCk7oUVc5Tn8VtJcdha31C
         +uqOOKc9spUMqupmYr2pGavd1S5Lt9GNayCe+rnlfYBLJk3YZYyEqjZod0b03pcqaaee
         W2VzHVHWqMVtMQk6ozlJ9N0LNKc+DQsubEskuca7AvuX/rg7ABXu9eSEC88EtcYje5h5
         Qui2larVi4ToQCTIxDrzhOq9jpNyfNbXCBmKt188yTRS2Cs1a9O0jykknTAiV/fbkFnP
         HMb/zgJp39E9+rc3TLPD5nlgm8NmGOW7LyNT+TinueUJzLdmviZJy9A79O3NbGcY4x8o
         m48g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=n2hc+QzvtZHrFjtO1vXBkANPpjyaJQos41FOXltNqOA=;
        b=EwTdFFnI7l0H09YgSDWyVLhmtOdl/bIwXTbquejwd3vGLcjefcxoiqy66jeb9V4ZPb
         KN4jC7YjKTbvB3NAbm7DCfh8mIAAAg7yNdyY9d697GqLOB3qnoDy3vsUzdAnVF4Ot3PB
         sxOMcV5m9waq0ZGLfRdos4e9uYHZ4zvTwfRd0Wqcmq/oGBGmgVtQZuY1izsAIFP7FxL7
         WeoaOxYuoFa5OmgbAtMsy4qYIjql8aY2ygjjj57dpsXWyyNt1IhOkDMdBQLjioAF6kmU
         uvmPHn0tZvAEV10cpvkgigzXF6PXAg/zS5jNBoFVSCBhU0RFaqOAGs/t+dGgz/M81+J8
         c9LA==
X-Gm-Message-State: AOAM530QGMaJFI+fw99cJ4mwuCwUACvMMRwVBKtPBgT0OXcDlGX1HajL
        7aqj7CX333e2q3+0kVyHysncNZYHwmwGqVmkJwvvKO4=
X-Google-Smtp-Source: ABdhPJzN3PNIrgj7gbuyJC8JMf9s6hmiBAlbQTNDMWFIQab4Hjxe3y2V2pq81uZgCqPMNb0DDWBLfzMufUHjKeKMz2g=
X-Received: by 2002:a17:906:3381:: with SMTP id v1mr3439557eja.280.1607542400819;
 Wed, 09 Dec 2020 11:33:20 -0800 (PST)
MIME-Version: 1.0
References: <2991484d-15b9-a846-565f-e86ccb83768d@0882a8b5-c6c3-11e9-b005-00805fc181fe>
In-Reply-To: <2991484d-15b9-a846-565f-e86ccb83768d@0882a8b5-c6c3-11e9-b005-00805fc181fe>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Wed, 9 Dec 2020 11:33:09 -0800
Message-ID: <CAKywueRf8T8UJ5e9KaSLM80b3Q4npWC4CTcQ1n2QWYACW29izg@mail.gmail.com>
Subject: Re: [PATCH] Add missing position handling to mount parameters gid/backup_gid/snapshot
To:     Simon Arlott <simon@octiron.net>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Merged. Thanks!
--
Best regards,
Pavel Shilovsky

=D1=81=D1=80, 25 =D0=BD=D0=BE=D1=8F=D0=B1. 2020 =D0=B3. =D0=B2 16:38, Simon=
 Arlott <simon@octiron.net>:
>
> The code tries to optimise for the last parameter not needing to update
> the position which means that every time a new one is added to the end
> by copying and pasting, the string position is not updated.
>
> That makes it impossible to use backup_uid=3D/backup_gid=3D/snapshot=3D a=
fter
> gid=3D or snapshot=3D after backup_gid=3D because part of the string is
> overwritten and contains invalid keys like "gbackup_uid".
>
> Prepare for the next parameter to be added on the end by updating the
> position for snapshot=3D even though it will be unused.
> ---
>  mount.cifs.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/mount.cifs.c b/mount.cifs.c
> index 4feb397..a169bc6 100644
> --- a/mount.cifs.c
> +++ b/mount.cifs.c
> @@ -1229,6 +1229,7 @@ nocopy:
>                         out_len++;
>                 }
>                 snprintf(out + out_len, word_len + 5, "gid=3D%s", txtbuf)=
;
> +               out_len =3D strlen(out);
>         }
>         if (got_bkupuid) {
>                 word_len =3D snprintf(txtbuf, sizeof(txtbuf), "%u", bkupu=
id);
> @@ -1260,6 +1261,7 @@ nocopy:
>                         out_len++;
>                 }
>                 snprintf(out + out_len, word_len + 11, "backupgid=3D%s", =
txtbuf);
> +               out_len =3D strlen(out);
>         }
>         if (got_snapshot) {
>                 word_len =3D snprintf(txtbuf, sizeof(txtbuf), "%llu", sna=
pshot);
> @@ -1275,6 +1277,7 @@ nocopy:
>                         out_len++;
>                 }
>                 snprintf(out + out_len, word_len + 11, "snapshot=3D%s", t=
xtbuf);
> +               out_len =3D strlen(out);
>         }
>
>         return 0;
> --
> 2.17.1
>
> --
> Simon Arlott
