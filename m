Return-Path: <SRS0=+oFK=7W=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 382C7C433DF
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Jun 2020 05:01:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C4A120801
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Jun 2020 05:01:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vs/ppIDx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725772AbgFIFBg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 9 Jun 2020 01:01:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725770AbgFIFBg (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 9 Jun 2020 01:01:36 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4467C03E969
        for <linux-cifs@vger.kernel.org>; Mon,  8 Jun 2020 22:01:35 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id m131so428861ybc.12
        for <linux-cifs@vger.kernel.org>; Mon, 08 Jun 2020 22:01:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kXZK0xB7DqkZeW+NNfFIuT+6CG3E9HG8fwQCDWdFkpA=;
        b=Vs/ppIDxG5TJLfUPo0ZHpIfnmHI0HUWqFSLpT6M472ip8PS/ZaqJ/5gcO/NkA5WO97
         vFnj8lReeb4kzMAgdXIUTZ70zQWXjaeIqTSq2leApV7/krfcAaaaBKCzS9gGIZC78Rdl
         tfC5jMxdg9aHcqIvoK+hzRdmh9Tmi9LGXUS9Gzu+cGSPEQo3gPl2hvaETLRr4darjos4
         j+lOXJ1lKCYeSNHAfYLxPzRdaW7/DuM2oATe8AUs1g+/YLwOpHI0p0eIuMVnUsi6a67o
         IuwfmIsTkytfmXSMeLgtKDrTJACfZEpwbpUMutW+p1mCAf0rXFfvlhtcB2QCQFI8eHxI
         /6oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kXZK0xB7DqkZeW+NNfFIuT+6CG3E9HG8fwQCDWdFkpA=;
        b=GGTlLpzTpJyVaCBtPbIgDNtyj6i6npk6r4ooZV64RqnmX0sH2Adgi+BVZEh2KzyWqb
         /PFNp2qP+wJFzhHqogN+M3+RuVl1zuqAAjf+HP8GNwTQBCXQZrLAkzWgy5/pQqW4HFGr
         lZKTTrljssUKJfxabll+d19YstVRcyN11f7wUSgjc/r01P2jEW+9MDu110EKQgIyOdxN
         M3IbBBAtoPmy8VujEFoZWpLTgv3actcbnGPQTU6AAi0CcgAW8vtJz8w4/CJ1uSFMNb4W
         P8XFkSgYxOw0z2rBx3ol/UPsS2xvHIMgD8Y1HhyiAuD2lKT1w3CwL/vF7ic837/akW3F
         hWfQ==
X-Gm-Message-State: AOAM532BGS5CnkYqTP2ngFPKoe4SRvIpCPUkag1+CWMytbLzxpC5p447
        +xj3I2U1wvVBVZjZdOXvqammQM7qLRySdOUadyk=
X-Google-Smtp-Source: ABdhPJxz6WmgSqcogfkb7zSf0cfPIOXUAprGeuvHuPiLMQIK5+pGp8HurQDTrbdcAzxvi5szuQhLEPgu9p1O+d7Mkb4=
X-Received: by 2002:a25:ec0d:: with SMTP id j13mr3206671ybh.364.1591678894321;
 Mon, 08 Jun 2020 22:01:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200605151746.18743-1-kdsouza@redhat.com>
In-Reply-To: <20200605151746.18743-1-kdsouza@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 9 Jun 2020 00:01:23 -0500
Message-ID: <CAH2r5mt_AtRHoyZ3_0j+d0gxA0_ntvYEUsN3VWY4mkG=ammwiw@mail.gmail.com>
Subject: Re: [PATCH v3] cifs: dump Security Type info in DebugData
To:     "Kenneth D'souza" <kdsouza@redhat.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Roberto Bergantinos Corpas <rbergant@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

the updated version of this one has been merged into cifs-2.6.git for-next

On Fri, Jun 5, 2020 at 10:17 AM Kenneth D'souza <kdsouza@redhat.com> wrote:
>
> Currently the end user is unaware with what sec type the
> cifs share is mounted if no sec=<type> option is parsed.
> With this patch one can easily check from DebugData.
>
> Example:
> 1) Name: x.x.x.x Uses: 1 Capability: 0x8001f3fc Session Status: 1 Security type: RawNTLMSSP
>
> Signed-off-by: Kenneth D'souza <kdsouza@redhat.com>
> Signed-off-by: Roberto Bergantinos Corpas <rbergant@redhat.com>
> ---
>  fs/cifs/cifs_debug.c |  4 ++++
>  fs/cifs/cifsglob.h   | 18 ++++++++++++++++++
>  2 files changed, 22 insertions(+)
>
> diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
> index 916567d770f5..9caca784376b 100644
> --- a/fs/cifs/cifs_debug.c
> +++ b/fs/cifs/cifs_debug.c
> @@ -375,6 +375,10 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
>                                 ses->ses_count, ses->serverOS, ses->serverNOS,
>                                 ses->capabilities, ses->status);
>                         }
> +
> +                       seq_printf(m,"Security type: %s\n",
> +                                       get_security_type_str(server->ops->select_sectype(server, ses->sectype)));
> +
>                         if (server->rdma)
>                                 seq_printf(m, "RDMA\n\t");
>                         seq_printf(m, "TCP status: %d Instance: %d\n\tLocal Users To "
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 39b708d9d86d..d8ef01039e71 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -1994,6 +1994,24 @@ extern struct smb_version_values smb302_values;
>  extern struct smb_version_operations smb311_operations;
>  extern struct smb_version_values smb311_values;
>
> +static inline char *get_security_type_str(enum securityEnum sectype)
> +{
> +       switch (sectype) {
> +       case RawNTLMSSP:
> +               return "RawNTLMSSP";
> +       case Kerberos:
> +               return "Kerberos";
> +       case NTLMv2:
> +               return "NTLMv2";
> +       case NTLM:
> +               return "NTLM";
> +       case LANMAN:
> +               return "LANMAN";
> +       default:
> +               return "Unknown";
> +       }
> +}
> +
>  static inline bool is_smb1_server(struct TCP_Server_Info *server)
>  {
>         return strcmp(server->vals->version_string, SMB1_VERSION_STRING) == 0;
> --
> 2.21.1
>


-- 
Thanks,

Steve
