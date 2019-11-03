Return-Path: <SRS0=MPEU=Y3=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62414CA9EC7
	for <linux-cifs@archiver.kernel.org>; Sun,  3 Nov 2019 02:06:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 367B620862
	for <linux-cifs@archiver.kernel.org>; Sun,  3 Nov 2019 02:06:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ed8cy6TZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727366AbfKCCGo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 2 Nov 2019 22:06:44 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:35175 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727335AbfKCCGo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 2 Nov 2019 22:06:44 -0400
Received: by mail-io1-f68.google.com with SMTP id h9so14869582ioh.2;
        Sat, 02 Nov 2019 19:06:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UY8j4si9feJ8WDRaEe/6ZeNtYTRSD0yc1AA2grJU06M=;
        b=ed8cy6TZCntAaIXa9HjCoriEZie2hsrNv8yozwVnkZnwEdwLYW7OVeLIeE+LACx0N7
         n71MeZA0goX2R+e06ELyG7HZq9eY5vnjkdCeKTDE7bT6U7qANDoaKBaFoIp2biakZ81x
         QVky9cJWuduxgnY5eLgpr/32VVZNLSiDq7tldKCm3DbptamWxuwEgyoMmeFBsA+w0z0a
         jJnSoN6kigQsSMvSnEFnYumERNPliHq0Mn7zCZ7gBoGzfag+GI2/TuasCq5DrAA0M4V7
         Rveg4LG8X53wMQI8jjnkqnQ8+vvu463soA3WRaOOorwjwnEZwWceN8TyJDmM6ErJdoCZ
         NKkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UY8j4si9feJ8WDRaEe/6ZeNtYTRSD0yc1AA2grJU06M=;
        b=Sv5X0ijJoG7F1TFoku2xE1OVu1HEoDvVAvL8xniBGCHMp2n3fu7fapVI/acUclbQR9
         ooqumOttGqzzOqCjzmcjcoQJ97E2B8CK34vJ9K6nxssxjK0ND++UVwXBNaIzrvJ2H7LW
         9gBKcj4+trgKtiPz4vsJnP5IKMHENUwnrbP/LUbJCO9AJXItXvbGVtjnrgIRxD7BUWD2
         Ls7JFFUFvI4J3OzoMcRFZaXyk5JONHzyXjkb38x4QadCr+GxcP0NPMYDMS6yOu6KBJ+e
         bKdXUh5+naPaJxJGWTQH9WEPJAWog1Z5lf3Oq6cmXTJULyhmtIgRjffytna/SmieAiFx
         //Hw==
X-Gm-Message-State: APjAAAXlfaeJAf7oqZTNDgTgjbgqESu9zwr5xxDAb7b4eNQAsMNQKRfz
        2kYZIn3c6hAA5+LIHH165f2tZiw7f/ssJcf3Gq0=
X-Google-Smtp-Source: APXvYqxy61rfqcWgEejBSiT+tDMBwJY76JI0Ra+oEViBdYXXxtKWB32bS68f0a+tDS7vMwe6K7HhOB6Lm5LglRPA50Y=
X-Received: by 2002:a5e:9b13:: with SMTP id j19mr5768649iok.169.1572746802098;
 Sat, 02 Nov 2019 19:06:42 -0700 (PDT)
MIME-Version: 1.0
References: <20191031211857.18989-1-pshilov@microsoft.com>
In-Reply-To: <20191031211857.18989-1-pshilov@microsoft.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 2 Nov 2019 21:06:31 -0500
Message-ID: <CAH2r5mu_0JMYfeLcfvj2ZOxXc+euTL_P+F-nmnjUvpN1=eeLcg@mail.gmail.com>
Subject: Re: [PATCH] CIFS: Fix SMB2 oplock break processing
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>, Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively merged into cifs-2.6.git for-next pending review and
buildbot regression test runs

On Thu, Oct 31, 2019 at 5:50 PM Pavel Shilovsky <piastryyy@gmail.com> wrote:
>
> Even when mounting modern protocol version the server may be
> configured without supporting SMB2.1 leases and the client
> uses SMB2 oplock to optimize IO performance through local caching.
>
> However there is a problem in oplock break handling that leads
> to missing a break notification on the client who has a file
> opened. It latter causes big latencies to other clients that
> are trying to open the same file.
>
> The problem reproduces when there are multiple shares from the
> same server mounted on the client. The processing code tries to
> match persistent and volatile file ids from the break notification
> with an open file but it skips all share besides the first one.
> Fix this by looking up in all shares belonging to the server that
> issued the oplock break.
>
> Cc: Stable <stable@vger.kernel.org>
> Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
> ---
>  fs/cifs/smb2misc.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
> index 8db6201b18ba..527c9efd3de0 100644
> --- a/fs/cifs/smb2misc.c
> +++ b/fs/cifs/smb2misc.c
> @@ -664,10 +664,10 @@ smb2_is_valid_oplock_break(char *buffer, struct TCP_Server_Info *server)
>         spin_lock(&cifs_tcp_ses_lock);
>         list_for_each(tmp, &server->smb_ses_list) {
>                 ses = list_entry(tmp, struct cifs_ses, smb_ses_list);
> +
>                 list_for_each(tmp1, &ses->tcon_list) {
>                         tcon = list_entry(tmp1, struct cifs_tcon, tcon_list);
>
> -                       cifs_stats_inc(&tcon->stats.cifs_stats.num_oplock_brks);
>                         spin_lock(&tcon->open_file_lock);
>                         list_for_each(tmp2, &tcon->openFileList) {
>                                 cfile = list_entry(tmp2, struct cifsFileInfo,
> @@ -679,6 +679,8 @@ smb2_is_valid_oplock_break(char *buffer, struct TCP_Server_Info *server)
>                                         continue;
>
>                                 cifs_dbg(FYI, "file id match, oplock break\n");
> +                               cifs_stats_inc(
> +                                   &tcon->stats.cifs_stats.num_oplock_brks);
>                                 cinode = CIFS_I(d_inode(cfile->dentry));
>                                 spin_lock(&cfile->file_info_lock);
>                                 if (!CIFS_CACHE_WRITE(cinode) &&
> @@ -702,9 +704,6 @@ smb2_is_valid_oplock_break(char *buffer, struct TCP_Server_Info *server)
>                                 return true;
>                         }
>                         spin_unlock(&tcon->open_file_lock);
> -                       spin_unlock(&cifs_tcp_ses_lock);
> -                       cifs_dbg(FYI, "No matching file for oplock break\n");
> -                       return true;
>                 }
>         }
>         spin_unlock(&cifs_tcp_ses_lock);
> --
> 2.17.1
>


-- 
Thanks,

Steve
