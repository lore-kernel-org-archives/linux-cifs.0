Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B4BEC433EF
	for <linux-cifs@archiver.kernel.org>; Sun, 26 Sep 2021 03:21:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3889960F13
	for <linux-cifs@archiver.kernel.org>; Sun, 26 Sep 2021 03:21:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230399AbhIZDXN (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 25 Sep 2021 23:23:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230429AbhIZDXJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 25 Sep 2021 23:23:09 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDE8CC061740
        for <linux-cifs@vger.kernel.org>; Sat, 25 Sep 2021 20:21:33 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id y28so58830686lfb.0
        for <linux-cifs@vger.kernel.org>; Sat, 25 Sep 2021 20:21:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=XoaBr5eDmHFxZEnmxN49fiPmU5feigrFbx/c/Ls0j80=;
        b=mrY/RY6yxNvC8ggO/62bx+B4GxRpjIRjFITmAspGTYOO+emLp5qpjzOKbBLDWiGHDo
         g1xjPd5qxSmtdPD4yHS81gGsHIWPYp70Ue/VvUTimmoLUshDkLidtdGaoqy520UAk0H/
         C0eUXapgFQm5BOHYJeY6CbfszAOD5DGrgvmUuCmJqADXQHj/ONx4GH1p0C0a6bj/WAzw
         0R3a+BfJ/ZPKpEOkjg8rHJ7ujfj+Jka+DvEsiA3kpZIekRWxoDtiT1jvXSWzfAjFr0+H
         wk25vhgLZbn4qUpyihNbWgDqbYuj35XwTTEHkSwm+MH13i9lyxuuf2WQjxBrciJm0pzL
         6faQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=XoaBr5eDmHFxZEnmxN49fiPmU5feigrFbx/c/Ls0j80=;
        b=Q6GqmaxmrchXnhZMS1kw42lOLwEZbcXU68IxXLqyn7aIELZA7MK59fPWiLoPKXJ1Rb
         wzBM/mK2O/a20OJ24lEDpBLJYEuEPcjuUjGwcJoHCtBQZjqDFYGvN2kUgOFsq5ATEFeJ
         +bSXKnhAFwOuxNFSqxOtok+4smYZsYBk1xkf2ttB79KKvqvbLxz25NfuPlHl4nA4ish0
         SDoR7M1t4pYBnHxTWsBDauu+nHEt6DxGh8MWVFzf2h7f7pwfDmXGC0CYsexQVhBMMku6
         dnbOmEDCtu4jq9nc0RHuzD1ikKo5vvfi4psUMIpoZ6desExZ9NIfgYLJ0RTVQqL/SSF6
         8NUQ==
X-Gm-Message-State: AOAM531fDXK8I4B6C5Qbz/iB+31PLjI/z5YVHxU3FHXMnb8rCzQO5DH6
        DaQ8iXbM8NusHErdsJmi8WRxwDBHVjKamyzsfs8=
X-Google-Smtp-Source: ABdhPJwx35AlrN8jfFPRsAnpjPYWvWukD01OoNVq4X4symXi277sG74V5io67gckVaYmFOVND8gI50nhAKwdpm+1j1c=
X-Received: by 2002:a2e:a78d:: with SMTP id c13mr20247143ljf.314.1632626492226;
 Sat, 25 Sep 2021 20:21:32 -0700 (PDT)
MIME-Version: 1.0
References: <20210925131625.29617-1-linkinjeon@kernel.org> <20210925131625.29617-2-linkinjeon@kernel.org>
In-Reply-To: <20210925131625.29617-2-linkinjeon@kernel.org>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 25 Sep 2021 22:21:21 -0500
Message-ID: <CAH2r5msWH=mk_H2ajsKuN8N5ufWPt1zKhnEpbwRu52WxqJG+QA@mail.gmail.com>
Subject: Re: [PATCH v2 1/7] ksmbd: remove RFC1002 check in smb2 request
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?B?UmFscGggQsO2aG1l?= <slow@samba.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Hyunchul Lee <hyc.lee@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Also reviewed by me, and merged into cifsd-for-next

On Sat, Sep 25, 2021 at 8:17 AM Namjae Jeon <linkinjeon@kernel.org> wrote:
>
> From: Ronnie Sahlberg <lsahlber@redhat.com>
>
> In smb_common.c you have this function :   ksmbd_smb_request() which
> is called from connection.c once you have read the initial 4 bytes for
> the next length+smb2 blob.
>
> It checks the first byte of this 4 byte preamble for valid values,
> i.e. a NETBIOSoverTCP SESSION_MESSAGE or a SESSION_KEEP_ALIVE.
>
> We don't need to check this for ksmbd since it only implements SMB2
> over TCP port 445.
> The netbios stuff was only used in very old servers when SMB ran over
> TCP port 139.
> Now that we run over TCP port 445, this is actually not a NB header anymo=
re
> and you can just treat it as a 4 byte length field that must be less
> than 16Mbyte. and remove the references to the RFC1002 constants that no
> longer applies.
>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> Cc: Ralph B=C3=B6hme <slow@samba.org>
> Cc: Steve French <smfrench@gmail.com>
> Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
> Acked-by: Hyunchul Lee <hyc.lee@gmail.com>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---
>  fs/ksmbd/smb_common.c | 15 +--------------
>  fs/ksmbd/smb_common.h |  8 --------
>  2 files changed, 1 insertion(+), 22 deletions(-)
>
> diff --git a/fs/ksmbd/smb_common.c b/fs/ksmbd/smb_common.c
> index 43d3123d8b62..1da67217698d 100644
> --- a/fs/ksmbd/smb_common.c
> +++ b/fs/ksmbd/smb_common.c
> @@ -149,20 +149,7 @@ int ksmbd_verify_smb_message(struct ksmbd_work *work=
)
>   */
>  bool ksmbd_smb_request(struct ksmbd_conn *conn)
>  {
> -       int type =3D *(char *)conn->request_buf;
> -
> -       switch (type) {
> -       case RFC1002_SESSION_MESSAGE:
> -               /* Regular SMB request */
> -               return true;
> -       case RFC1002_SESSION_KEEP_ALIVE:
> -               ksmbd_debug(SMB, "RFC 1002 session keep alive\n");
> -               break;
> -       default:
> -               ksmbd_debug(SMB, "RFC 1002 unknown request type 0x%x\n", =
type);
> -       }
> -
> -       return false;
> +       return conn->request_buf[0] =3D=3D 0;
>  }
>
>  static bool supported_protocol(int idx)
> diff --git a/fs/ksmbd/smb_common.h b/fs/ksmbd/smb_common.h
> index 57c667c1be06..d7df19c97c4c 100644
> --- a/fs/ksmbd/smb_common.h
> +++ b/fs/ksmbd/smb_common.h
> @@ -48,14 +48,6 @@
>  #define CIFS_DEFAULT_IOSIZE    (64 * 1024)
>  #define MAX_CIFS_SMALL_BUFFER_SIZE 448 /* big enough for most */
>
> -/* RFC 1002 session packet types */
> -#define RFC1002_SESSION_MESSAGE                        0x00
> -#define RFC1002_SESSION_REQUEST                        0x81
> -#define RFC1002_POSITIVE_SESSION_RESPONSE      0x82
> -#define RFC1002_NEGATIVE_SESSION_RESPONSE      0x83
> -#define RFC1002_RETARGET_SESSION_RESPONSE      0x84
> -#define RFC1002_SESSION_KEEP_ALIVE             0x85
> -
>  /* Responses when opening a file. */
>  #define F_SUPERSEDED   0
>  #define F_OPENED       1
> --
> 2.25.1
>


--=20
Thanks,

Steve
