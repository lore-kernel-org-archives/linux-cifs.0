Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90F19C433FE
	for <linux-cifs@archiver.kernel.org>; Wed,  9 Dec 2020 03:30:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 562B0238E2
	for <linux-cifs@archiver.kernel.org>; Wed,  9 Dec 2020 03:30:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbgLIDa3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 8 Dec 2020 22:30:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbgLIDa2 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 8 Dec 2020 22:30:28 -0500
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4981C0613CF
        for <linux-cifs@vger.kernel.org>; Tue,  8 Dec 2020 19:29:48 -0800 (PST)
Received: by mail-il1-x144.google.com with SMTP id p5so235937ilm.12
        for <linux-cifs@vger.kernel.org>; Tue, 08 Dec 2020 19:29:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y2JUugXM/47mSS+9K74UOfo8ggkV2elPdsoKm1HSzaM=;
        b=tV5X2TtxiOHZYqBbro1ihhrex0ORHG6gzgV+6YVkEWpGdF2SsfeBEfk+bPcfHGQJlS
         InylBVGH98pm1V4mceVtC1LGdCQSmIgBB8ccWJgS8XyrL/097/B+F/Cllg/MunVngpFb
         7MlMEJ4sFEZmIFnDHcMmXU7eX6SdgYpCrdroXwuTUKC/fBVwOHCWdgBG9EyboKltX/LR
         KR3bEw9voqUBq5+ALxCMwMlJ3S4zvRWe+CuK+n6GKTTKNkN03Bm7jwlzdtcqHgiohiS/
         KBvczazbFAc3yceZ4GHP429ezWYY9S3XAHozghN5mPep3ZfbJNvoJMKhi4L3NEKTBOW9
         k1fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y2JUugXM/47mSS+9K74UOfo8ggkV2elPdsoKm1HSzaM=;
        b=oZR7oXo0C4XHjD0XaPrO7/9U5YC1INDkld1lL6BU0k1xdTOg34+pLFVEHBNIBqRZFf
         s7dlOZymzQHnv2PlzoNCi0MWlGqJrtLRF5XjiOffVxneV80tTlQWYF0eQ9i2dPnzBX/s
         8VpLP5LhCtZrmgWmDnnb6g+AhOLuPVceIcOVvvsAD0p0TflVjzuoWXIX1yDbq5qBNfzR
         wxSOneQFEGVLPKR/D2tuajtLbw1uMphl4wJJ9oZX+2Ygx8AgwemOFDUAgyszUkGTxarK
         qkXltOCATRKt4gcYj7wkQkzbGUVGm/9m2EYZb+R7VXYQOu14URkHge7ladMIpZQiS6B+
         TIyQ==
X-Gm-Message-State: AOAM532QHAHQ1NkH+fwwV7dqeeSUHcy8IxPM9G9IoenDeAk6Wh3VRv+s
        zwFaLnAxh8xUSJHhCngWP4RV6qLP9gLdtmFCtDk=
X-Google-Smtp-Source: ABdhPJyblE50885kRyzLj1UgGZSeZ6W0SC4OB2O41fHgQQxO6jMUo2Vc6VDCjUXB+fWk1lWtfgcHFgs05GAHGCsbCzk=
X-Received: by 2002:a92:91d7:: with SMTP id e84mr343074ill.159.1607484587781;
 Tue, 08 Dec 2020 19:29:47 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5mtx6zWZ2T_Erb=6JQ3mHJxh=bHydww-F52ts3zsvgd8Jw@mail.gmail.com>
In-Reply-To: <CAH2r5mtx6zWZ2T_Erb=6JQ3mHJxh=bHydww-F52ts3zsvgd8Jw@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Wed, 9 Dec 2020 13:29:35 +1000
Message-ID: <CAN05THQxKmuj63Pdd1-5PsEm8Cx4tMfysOPU9QARphmaHBK1hQ@mail.gmail.com>
Subject: Re: [SMB3][Multichannel] avoid confusing warning message on mount to Azure
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>

On Wed, Dec 9, 2020 at 1:22 PM Steve French <smfrench@gmail.com> wrote:
>
> Mounts to Azure cause an unneeded warning message in dmesg
>    "CIFS: VFS: parse_server_interfaces: incomplete interface info"
>
> Azure rounds up the size (by 8 additional bytes, to a
> 16 byte boundary) of the structure returned on the query
> of the server interfaces at mount time.  This is permissible
> even though different than other servers so do not log a warning
> if query network interfaces response is only rounded up by 8
> bytes or fewer.
>
> CC: Stable <stable@vger.kernel.org>
> Signed-off-by: Steve French <stfrench@microsoft.com>
> ---
>  fs/cifs/smb2ops.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index 3d914d7d0d11..22f1d8dc12b0 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -477,7 +477,8 @@ parse_server_interfaces(struct
> network_interface_info_ioctl_rsp *buf,
>   goto out;
>   }
>
> - if (bytes_left || p->Next)
> + /* Azure rounds the buffer size up 8, to a 16 byte boundary */
> + if ((bytes_left > 8) || p->Next)
>   cifs_dbg(VFS, "%s: incomplete interface info\n", __func__);
>
>
> --
> Thanks,
>
> Steve
