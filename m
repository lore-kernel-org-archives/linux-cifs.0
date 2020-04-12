Return-Path: <SRS0=YkwU=54=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72AD8C2D0EC
	for <linux-cifs@archiver.kernel.org>; Sun, 12 Apr 2020 21:51:42 +0000 (UTC)
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 398F0206E5
	for <linux-cifs@archiver.kernel.org>; Sun, 12 Apr 2020 21:51:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bjzLDvcX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 398F0206E5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-cifs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728387AbgDLVvl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 12 Apr 2020 17:51:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:51876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727388AbgDLVvk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 12 Apr 2020 17:51:40 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 374A7C0A88B5
        for <linux-cifs@vger.kernel.org>; Sun, 12 Apr 2020 14:51:41 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id n188so3776287ybc.3
        for <linux-cifs@vger.kernel.org>; Sun, 12 Apr 2020 14:51:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sY+YvxlZHZQb3BkdYydzdcDG4Kx43IySzoO9d5wFmUQ=;
        b=bjzLDvcXQq2PgxAlCidD0LRhy/hTENH+nOrQK4nxOVIimGgHJFmT63U9mzfp9gTcrQ
         uZL1BDgjUHptHPfJrRXQwduGWZpUN8O7AMCB4zkyTuDHVArqgX+xFoF8YVTrLw+U/Rii
         AzvD8U6yNWEwVEr9WBn2yqtE7LQP9NDqXOGj/+nr6aRbM+t5a6wlOO2ky6ps6QjMstDF
         b0+IqjhygnwufGptkj0ZIkYGBH2kamYuOM1qce6E0dwT5T5W+hJtHXNjq4Ho6i8nBV5y
         Qxk3O+qUK/5YnqHn4PurAaCHO053/d+e3KSoIyx4rOIDU0kAWHf0v879kRfhDkbSSBTe
         EjcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sY+YvxlZHZQb3BkdYydzdcDG4Kx43IySzoO9d5wFmUQ=;
        b=q+i+abEdMisBvHluZHk6DbnUIkNBJ7aQOEMcCMlXWvAzesjl5D/VUbg6u+Nr5SMHl1
         ZvzyfjoDGMcONQYm+3q0NCcOgQQtNLCxxdy2EIIe4XvreRYw70a06A0QJmbdpEeygDb5
         MVZiHjTRPBKr9B7COg8hdOYmVXbiK4ZXGIAv8bYtaqsGQXNe+MRxjWDE3ouKq+/6OchC
         bg+RSecqHN3tb5eSzPJWo76qp1m3e2qJxj4cj7vF+3AJnrxH+MXTl96Xhe+ZYX2csRAA
         k4M4/VwVWHJIuovJW0HcsZPb7parO1MaqhrNibz1kYY+VKRTt/I+KapnmpD01CVHylJV
         0HFg==
X-Gm-Message-State: AGi0PuZ8EZtRKdZAdXNzspKDxCijPb3yYbIEvjuVp8rjrpbZ70EJj155
        uoYvZhKMnz0LcFK/KJLjzpbFG39qMwFzYZc7c2M=
X-Google-Smtp-Source: APiQypLQBf75dKYQ37DNNjSdiHZ7aQ9aAsmWgUZS+MIIxXTL+Qqz1pMcPEpWL+Q5/I856DNCZ6Q0h8MApoC7DrYrwwo=
X-Received: by 2002:a25:cd04:: with SMTP id d4mr21908561ybf.375.1586728300312;
 Sun, 12 Apr 2020 14:51:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200412060926.30733-1-lsahlber@redhat.com>
In-Reply-To: <20200412060926.30733-1-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 12 Apr 2020 16:51:29 -0500
Message-ID: <CAH2r5mvQ2HcFrdjSsW0XJiTRxRNFgUm+g7+ZUgTkkqQXP7s6Cw@mail.gmail.com>
Subject: Re: [PATCH] cifs: dump the session id and keys also for SMB2 sessions
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively merged into cifs-2.6.git for-next

On Sun, Apr 12, 2020 at 1:11 AM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> We already dump these keys for SMB3, lets also dump it for SMB2
> sessions so that we can use the session key in wireshark to check and validate
> that the signatures are correct.
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/smb2pdu.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
>
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 28c0be5e69b7..3ddb0fe6889a 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -1541,6 +1541,21 @@ SMB2_sess_auth_rawntlmssp_authenticate(struct SMB2_sess_data *sess_data)
>         }
>
>         rc = SMB2_sess_establish_session(sess_data);
> +#ifdef CONFIG_CIFS_DEBUG_DUMP_KEYS
> +       if (ses->server->dialect < SMB30_PROT_ID) {
> +               cifs_dbg(VFS, "%s: dumping generated SMB2 session keys\n", __func__);
> +               /*
> +                * The session id is opaque in terms of endianness, so we can't
> +                * print it as a long long. we dump it as we got it on the wire
> +                */
> +               cifs_dbg(VFS, "Session Id    %*ph\n", (int)sizeof(ses->Suid),
> +                        &ses->Suid);
> +               cifs_dbg(VFS, "Session Key   %*ph\n",
> +                        SMB2_NTLMV2_SESSKEY_SIZE, ses->auth_key.response);
> +               cifs_dbg(VFS, "Signing Key   %*ph\n",
> +                        SMB3_SIGN_KEY_SIZE, ses->auth_key.response);
> +       }
> +#endif
>  out:
>         kfree(ntlmssp_blob);
>         SMB2_sess_free_buffer(sess_data);
> --
> 2.13.6
>


-- 
Thanks,

Steve
