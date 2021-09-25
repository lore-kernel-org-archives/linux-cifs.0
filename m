Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCBBBC433F5
	for <linux-cifs@archiver.kernel.org>; Sat, 25 Sep 2021 08:25:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A76FC61283
	for <linux-cifs@archiver.kernel.org>; Sat, 25 Sep 2021 08:25:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbhIYI1F (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 25 Sep 2021 04:27:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230162AbhIYI1E (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 25 Sep 2021 04:27:04 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EB70C061570
        for <linux-cifs@vger.kernel.org>; Sat, 25 Sep 2021 01:25:30 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id l16-20020a9d6a90000000b0053b71f7dc83so16494028otq.7
        for <linux-cifs@vger.kernel.org>; Sat, 25 Sep 2021 01:25:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=PYIH71xE3zYyFS9B/1inyICbaMRkARTl8D0JMN4LsUU=;
        b=FDjZKtkVWIIhuMBz22Q9iXZP/ZAqhL4/UITmFBqesd2EQvisMqI6X1IFW4DZ9DxypM
         PHHYdBxzkCZ0JfYCQv4WMSZXiGT260PtcF5c7Z7UUqDnSa/Ki2f7rpzNcFg5N6ve6WTA
         tRMZTT3M7Yq6+ElJPdetA6oe2k5efkfCbc8OhORsftSHDP5tCGY6bYtl6IgMYUQKeI0k
         K5C00gTKfsk4Gdj8w+BG3Vtcg/wp8r4VlW80P88DRD4hUpJNnwMSLpYlCZgUiixGbHGq
         pSk705pJCkguvXr4lKupgYWKq/wdqk7iivfJlZgZUkNsyvAsBBPljlyD9LSJGxI74mKJ
         yVwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=PYIH71xE3zYyFS9B/1inyICbaMRkARTl8D0JMN4LsUU=;
        b=QyHobjZngGj+BBDiTdudAKKIRQUFBKJaS6GwwpvDMMFl3pMyJLpGs7+f81jDbxOq4o
         Sa1DjLRPumTdpyczQLMnfalnG5yvu7SAcdLdLfOCdwvUAePwl7ebAHieTATqfvtV7Lxr
         EsRmRppZY4CzSfpOwfPdp4CXJq9BPPZnxjhyjL1h00Ud6KVqk9ekGDTFYiE+ho9wSgbV
         KRCBF4k9VpV1P8d0Ke7RE0xlb/roxWxJU5GomtMIcGG5HfJfi4ATZrlqEIgyzuoxYPBJ
         X9HBSByOLxavZlRkzB8eLNJN+MP6SY/2rgWNIzNgdYIZ7/u3cICzPNbBx+YBQu455ml5
         JNow==
X-Gm-Message-State: AOAM5325NAjZ7kxd5HmNo3sRas1Ve7MJNcVfkBO5RkX0YnJFgyDGNRFH
        0fNWXOI6QLwwW+y0rn3byDiwbajkoyubZL2iiqGTQT3PIAne3fv5h1s=
X-Google-Smtp-Source: ABdhPJzVV9RhepymCfk+e4IYu97d93arln3nSJ9NpqSXjjeZDZSr/7RUhdwFtXFpj5U9epxDnBptLixL/pRRn4+Z+tI=
X-Received: by 2002:ab0:5a91:: with SMTP id w17mr13258604uae.82.1632557948903;
 Sat, 25 Sep 2021 01:19:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210924021254.27096-1-linkinjeon@kernel.org> <20210924021254.27096-4-linkinjeon@kernel.org>
In-Reply-To: <20210924021254.27096-4-linkinjeon@kernel.org>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Sat, 25 Sep 2021 17:18:57 +0900
Message-ID: <CANFS6bYm+=zQhh1VcZ=PvWuuQ35Pafk7O+dAPsb8yFD9quh8OA@mail.gmail.com>
Subject: Re: [PATCH 3/7] ksmbd: remove RFC1002 check in smb2 request
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?B?UmFscGggQsO2aG1l?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Looks good to me.
Acked-by: Hyunchul Lee <hyc.lee@gmail.com>

2021=EB=85=84 9=EC=9B=94 24=EC=9D=BC (=EA=B8=88) =EC=98=A4=EC=A0=84 11:13, =
Namjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
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
> Cc: Hyunchul Lee <hyc.lee@gmail.com>
> Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---
>  fs/ksmbd/smb_common.c | 15 +--------------
>  fs/ksmbd/smb_common.h |  8 --------
>  2 files changed, 1 insertion(+), 22 deletions(-)
>
> diff --git a/fs/ksmbd/smb_common.c b/fs/ksmbd/smb_common.c
> index 40f4fafa2e11..5901b2884c60 100644
> --- a/fs/ksmbd/smb_common.c
> +++ b/fs/ksmbd/smb_common.c
> @@ -155,20 +155,7 @@ int ksmbd_verify_smb_message(struct ksmbd_work *work=
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
> index 0a6af447cc45..994abede27e9 100644
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
Hyunchul
