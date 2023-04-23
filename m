Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 082F1C77B7C
	for <linux-cifs@archiver.kernel.org>; Sun, 23 Apr 2023 06:10:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbjDWGK3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 23 Apr 2023 02:10:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjDWGK2 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 23 Apr 2023 02:10:28 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFA941FCC
        for <linux-cifs@vger.kernel.org>; Sat, 22 Apr 2023 23:10:26 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id 2adb3069b0e04-4efe8991bafso990812e87.0
        for <linux-cifs@vger.kernel.org>; Sat, 22 Apr 2023 23:10:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682230225; x=1684822225;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iMPobW5y0j8FZ5LoX4u2g8GSsItn8GWcBxGj/JMfyu8=;
        b=rvt36XtFhPWRGsLWxIyQlL2xDfmBymdtPLASoU04TR/9HNeQkEsKYlo3tRufuMEcxR
         rS+DFVInymqcvkmjF3vHl3AJEi1nmSTWpAvIbQQx6HNPcKTTBpm5Ywv/mgXjAcpa8znX
         9Y0NYNi5FZrRCd8s/tSXPrjD4DCLXt1H+zTUYlmYMiN67Wa8sOD3ZUS4RwZDkpnwVXht
         G8ZuckNJK2lKTU6Xmi5zblHr/N1lfpHU48DoObGMkU42IUA25VwOEi70z6B9wfifxWcF
         aPygm/+DZZ2BVByMLTDX4QcEZFbQvEEljbADESrNe+0Ia8Ljk+VcrsO9lQkpRIfzCcqR
         NyBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682230225; x=1684822225;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iMPobW5y0j8FZ5LoX4u2g8GSsItn8GWcBxGj/JMfyu8=;
        b=k5sr9YJ6A4oKZlUoNViirhWn3Jk+XSastuDtznm7bIUM9KvUHdddTAKeOag8cjiNkm
         JAoAGVN4lPS9d7ihn6b3Os83l+CAxkjTTtFZAw8XGA/Pn0yfGbEgGZ+Jng90dmS3r4rd
         ahvngM3u32f2G7mgF39oZmFDILbjMuwzJFsVQxPmuj2lWMxqeXoDxxwphSm/eOnpq0E7
         LIa7wjIA61OpYU5w6RZk0+89Rr1eGiGsElCUVBDTbzWrc63VpwR0Nn7dxgyEM+WJVFxL
         uQi5IYDCbpyclsj5p7q1wsTgV/GTBLVPeRZ2fo6rR4L+0SU6Cn1yvI3+bTEoywpdb/up
         eUhA==
X-Gm-Message-State: AAQBX9dPpJLgYD6ixW2TDaE4fIQ4rEOXXBv7ouRRU1nqfAf52CmG/Wuq
        1+yCKPcwCmcOnxLOsusBemUS6ZxPg74yPH+WgsXz5LLx
X-Google-Smtp-Source: AKy350YsixTWCNwVpKXNQL1Iq6ETgaiIq2w70FHtTkso8B1VRJBOkwUWvPvoMHBvDzHOLU+brXJOjdeT4Y8aRa5/Hp4=
X-Received: by 2002:a19:f80a:0:b0:4ec:9fe9:fea9 with SMTP id
 a10-20020a19f80a000000b004ec9fe9fea9mr2510936lff.56.1682230224797; Sat, 22
 Apr 2023 23:10:24 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1680177540.git.vl@samba.org>
In-Reply-To: <cover.1680177540.git.vl@samba.org>
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 23 Apr 2023 01:10:12 -0500
Message-ID: <CAH2r5mtatC+PXvpk_T=e5DPtY8Hzw1odCVCJWgXcyT_HRrdgVw@mail.gmail.com>
Subject: Re: [PATCH 0/3] Simplify SMB2_open_init
To:     Volker Lendecke <vl@samba.org>
Cc:     linux-cifs@vger.kernel.org, David Disseldorp <ddiss@samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Let me know if any updated patches (with merge window approaching soon)

On Thu, Mar 30, 2023 at 7:16=E2=80=AFAM Volker Lendecke <vl@samba.org> wrot=
e:
>
> Stitching together can be done in one place, there's no need to do
> this in every add_*_context function.
>
> This supersedes the patchet in
>
> https://www.spinics.net/lists/linux-cifs/msg28087.html.
>
> Volker Lendecke (3):
>   cifs: Simplify SMB2_open_init()
>   cifs: Simplify SMB2_open_init()
>   cifs: Simplify SMB2_open_init()
>
>  fs/cifs/smb2pdu.c | 106 +++++++++++-----------------------------------
>  1 file changed, 25 insertions(+), 81 deletions(-)
>
> --
> 2.30.2
>


--=20
Thanks,

Steve
