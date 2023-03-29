Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD398C74A5B
	for <linux-cifs@archiver.kernel.org>; Wed, 29 Mar 2023 20:28:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbjC2U2S (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 29 Mar 2023 16:28:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbjC2U2R (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 29 Mar 2023 16:28:17 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90C78527D
        for <linux-cifs@vger.kernel.org>; Wed, 29 Mar 2023 13:28:16 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id y4so68306573edo.2
        for <linux-cifs@vger.kernel.org>; Wed, 29 Mar 2023 13:28:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680121695;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=VhTRqJl2kiD60/EpjlAVP9ErcZo20BpSAh3SlTDaImo=;
        b=crxmgLrXtNNDjmCFgU4hzKGuNcNRxQQU/MVJi5VA0mUpmOgfL3ANe4RxMvhqOP4JXR
         iNPA9L1+UcScpD8oHgX7gh/SCkENGkUMlIih8x9qsT+UXOoZGyLdtYCAJzKM/1hz35GC
         ZPcllWzUAVOx8N74O9KfHqQXJvseQH4T0SjPAzC6zjxSJoN96hGWS1V+Mws/+ADAXH/L
         /B6mqKgIOqGYmqg10jeKH4Mj+MOUTgvurGIxWQ22qZljuJSlPJutDXiWw6/nOgVfTSxF
         FnoaAyr1ygByTIME9QbY9MlAT9dpNR9ATLiHsUJl5EQ1HbokqWYQwpG42QbM4NTo8IGg
         b8mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680121695;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VhTRqJl2kiD60/EpjlAVP9ErcZo20BpSAh3SlTDaImo=;
        b=fn9M1MraO7kz7H6YsURw49TknHX2yJ9okRP4/8DbXI4aXovQyhEqUkOLtq1pAj9Qe7
         dcEhjzlD9JYNqwcaJJQ2BdbQiNgAf7e4TeOZ1q+LBWEPYxOV/+8ihjL3qWzqnaCVnLP+
         azgeN0QgmwRpZWexbUqdaMct/Qh0BVr5VX8IlTO/pzNZ+aP0itAsZ+0tqBSe9JdK9fku
         NahAaeheihbLQW3P04hFIU3CbROgOM6uv1bPg+HIXd2plPGei//RmM0IOVP+awZL1mWl
         DNqnritkAgdxnTs6qEY3QG1Z0UcwEut3k3k/Y5VYWyermATH/9gFmdCnGrWJtLYt2SW+
         RBzA==
X-Gm-Message-State: AAQBX9f6rZL+xlp4tyKmSUX5QmU2T4F3D/Wfuemn7GmIvuuWKUMD2rVP
        c7gQdx1m7iKI/A/UfsO4kNR0gS2rcEN3Npz53aU=
X-Google-Smtp-Source: AKy350aTK0yx6bKIZtHuHw5T/0znQ0mE1TCtTW1k2UQZzgEKRFiNjFhSfDk3Rj5KZ8K9Bnd/axOBfHgLe7RtJgQidSM=
X-Received: by 2002:a17:907:160e:b0:946:a095:b314 with SMTP id
 hb14-20020a170907160e00b00946a095b314mr4250507ejc.2.1680121694957; Wed, 29
 Mar 2023 13:28:14 -0700 (PDT)
MIME-Version: 1.0
References: <20230329201423.32134-1-pc@manguebit.com> <20230329201423.32134-5-pc@manguebit.com>
In-Reply-To: <20230329201423.32134-5-pc@manguebit.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Thu, 30 Mar 2023 06:28:02 +1000
Message-ID: <CAN05THSshgpUHy-Dvf-fwnr=KD0DyqAdnX0x2keXhgcr1pKedA@mail.gmail.com>
Subject: Re: [PATCH 5/5] cifs: get rid of dead check in smb2_reconnect()
To:     Paulo Alcantara <pc@manguebit.com>
Cc:     smfrench@gmail.com, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

reviewed-by me

On Thu, 30 Mar 2023 at 06:20, Paulo Alcantara <pc@manguebit.com> wrote:
>
> The SMB2_IOCTL check in the switch statement will never be true as we
> return earlier from smb2_reconnect() if @smb2_command == SMB2_IOCTL.
>
> Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
> ---
>  fs/cifs/smb2pdu.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 6bd2aa6af18f..2b92132097dc 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -310,7 +310,6 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
>         case SMB2_READ:
>         case SMB2_WRITE:
>         case SMB2_LOCK:
> -       case SMB2_IOCTL:
>         case SMB2_QUERY_DIRECTORY:
>         case SMB2_CHANGE_NOTIFY:
>         case SMB2_QUERY_INFO:
> --
> 2.40.0
>
