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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11EE3C4361B
	for <linux-cifs@archiver.kernel.org>; Sat, 12 Dec 2020 05:57:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD7562313C
	for <linux-cifs@archiver.kernel.org>; Sat, 12 Dec 2020 05:57:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436645AbgLLF4e (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 12 Dec 2020 00:56:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436660AbgLLF4Z (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 12 Dec 2020 00:56:25 -0500
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D09CEC0613CF
        for <linux-cifs@vger.kernel.org>; Fri, 11 Dec 2020 21:55:44 -0800 (PST)
Received: by mail-lf1-x144.google.com with SMTP id 23so16934238lfg.10
        for <linux-cifs@vger.kernel.org>; Fri, 11 Dec 2020 21:55:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9JSZ9fx1Bui5kczOMw5VVmMsgOq0rNMS++yQImNPjDo=;
        b=IfhgubRWb2ldRk1WI8EchIsqwWZefE6s+cdBNQrXu/9/S+OyzZ9Mljy6NP24qD0gge
         wgPV07y2flVHmo1ZZtNhnsBUuDQorSSOvG+yj8ycu0AgAW+pPQrCIhHEWhP982jmdtBE
         otSpNzjiSD/7MQytvTVonmAzBJ+HwN1f8ncW62Cv9EJZrTJ7oBiWhjhf+quXs83Z46uk
         INY/TEdShhpGQu1iXj8PkxCEKNzMbg4YFF2+JBhIdobcrrgGgVqTYea0l9oERjzmb2gO
         YMI9Kj+hxn6QZYlVSdYp5QG/iM56075XLwXsb9WitIe52SKxEttXw2EIiw64leEvJFdC
         fNYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9JSZ9fx1Bui5kczOMw5VVmMsgOq0rNMS++yQImNPjDo=;
        b=UfkccG/rBRcnF0Gu5plbkqTuDRBYLqSHAgHeeDazBVBYYwCf+HiDDu3KsQA3xZZJJf
         P3BcsBH4FVhKe2S2DXAheoS4u4u0/g7gcjNz/w01QH9lOn80qcgmJrUi1EePhHBHR/rC
         s3lmKKY24e5Apidg8+nEZtBbGh6ogpdTW/K4E4iWveILoL0Iu7kBVvcZz2BvAwKd94MJ
         GEf0IW2O5kUehfzv/iEiSR2pi/yBWJ/gjwv2E4b3qh00XEH8kUsbmaIA12EZVD1yFfz4
         P0B4m8r3kwkUbIk8hH6w3FyTTCk6opASU1rw9FN2q/ljuas85QTUeY0l4GiF+Om67ZTJ
         KaWQ==
X-Gm-Message-State: AOAM530C3fiqD2y45XO4B9pwz4vMw4RRZQ4DPAz6lj+tppVrAUsx3H2T
        am4QvRiT/+ge0v/qaFucmulwkbBIvhXaJwnQijs=
X-Google-Smtp-Source: ABdhPJyeDcNrqAEEpkI23rc0IRkDQ/jhgnfyezwHK0y+OpSVU4Pth9crhmaBHsXD0DE8Z80ROekIf05eP6yKbr7p7Us=
X-Received: by 2002:a2e:924f:: with SMTP id v15mr6969788ljg.6.1607752543261;
 Fri, 11 Dec 2020 21:55:43 -0800 (PST)
MIME-Version: 1.0
References: <20201130180257.31787-1-scabrero@suse.de> <20201130180257.31787-7-scabrero@suse.de>
In-Reply-To: <20201130180257.31787-7-scabrero@suse.de>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 11 Dec 2020 23:55:31 -0600
Message-ID: <CAH2r5mtv=pLSHV-vPOyuemO+EKb-aMCNEPiiTwY+AhX0jHzLBg@mail.gmail.com>
Subject: Re: [PATCH v4 06/11] cifs: Set witness notification handler for
 messages from userspace daemon
To:     Samuel Cabrero <scabrero@suse.de>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively merged into cifs-2.6.git for-next    Let me know if any
updates needed to it

On Mon, Nov 30, 2020 at 12:05 PM Samuel Cabrero <scabrero@suse.de> wrote:
>
> + Set a handler for the witness notification messages received from the
>   userspace daemon.
>
> + Handle the resource state change notification. When the resource
>   becomes unavailable or available set the tcp status to
>   CifsNeedReconnect for all channels.
>
> Signed-off-by: Samuel Cabrero <scabrero@suse.de>
> ---
>  fs/cifs/cifs_swn.c                     | 86 ++++++++++++++++++++++++++
>  fs/cifs/cifs_swn.h                     |  4 ++
>  fs/cifs/netlink.c                      |  9 +++
>  include/uapi/linux/cifs/cifs_netlink.h | 17 +++++
>  4 files changed, 116 insertions(+)
>
> diff --git a/fs/cifs/cifs_swn.c b/fs/cifs/cifs_swn.c
> index c0af03955d0c..63b0764af5d5 100644
> --- a/fs/cifs/cifs_swn.c
> +++ b/fs/cifs/cifs_swn.c
> @@ -383,6 +383,92 @@ static void cifs_put_swn_reg(struct cifs_swn_reg *swnreg)
>         mutex_unlock(&cifs_swnreg_idr_mutex);
>  }
>
> +static int cifs_swn_resource_state_changed(struct cifs_swn_reg *swnreg, const char *name, int state)
> +{
> +       int i;
> +
> +       switch (state) {
> +       case CIFS_SWN_RESOURCE_STATE_UNAVAILABLE:
> +               cifs_dbg(FYI, "%s: resource name '%s' become unavailable\n", __func__, name);
> +               for (i = 0; i < swnreg->tcon->ses->chan_count; i++) {
> +                       spin_lock(&GlobalMid_Lock);
> +                       if (swnreg->tcon->ses->chans[i].server->tcpStatus != CifsExiting)
> +                               swnreg->tcon->ses->chans[i].server->tcpStatus = CifsNeedReconnect;
> +                       spin_unlock(&GlobalMid_Lock);
> +               }
> +               break;
> +       case CIFS_SWN_RESOURCE_STATE_AVAILABLE:
> +               cifs_dbg(FYI, "%s: resource name '%s' become available\n", __func__, name);
> +               for (i = 0; i < swnreg->tcon->ses->chan_count; i++) {
> +                       spin_lock(&GlobalMid_Lock);
> +                       if (swnreg->tcon->ses->chans[i].server->tcpStatus != CifsExiting)
> +                               swnreg->tcon->ses->chans[i].server->tcpStatus = CifsNeedReconnect;
> +                       spin_unlock(&GlobalMid_Lock);
> +               }
> +               break;
> +       case CIFS_SWN_RESOURCE_STATE_UNKNOWN:
> +               cifs_dbg(FYI, "%s: resource name '%s' changed to unknown state\n", __func__, name);
> +               break;
> +       }
> +       return 0;
> +}
> +
> +int cifs_swn_notify(struct sk_buff *skb, struct genl_info *info)
> +{
> +       struct cifs_swn_reg *swnreg;
> +       char name[256];
> +       int type;
> +
> +       if (info->attrs[CIFS_GENL_ATTR_SWN_REGISTRATION_ID]) {
> +               int swnreg_id;
> +
> +               swnreg_id = nla_get_u32(info->attrs[CIFS_GENL_ATTR_SWN_REGISTRATION_ID]);
> +               mutex_lock(&cifs_swnreg_idr_mutex);
> +               swnreg = idr_find(&cifs_swnreg_idr, swnreg_id);
> +               mutex_unlock(&cifs_swnreg_idr_mutex);
> +               if (swnreg == NULL) {
> +                       cifs_dbg(FYI, "%s: registration id %d not found\n", __func__, swnreg_id);
> +                       return -EINVAL;
> +               }
> +       } else {
> +               cifs_dbg(FYI, "%s: missing registration id attribute\n", __func__);
> +               return -EINVAL;
> +       }
> +
> +       if (info->attrs[CIFS_GENL_ATTR_SWN_NOTIFICATION_TYPE]) {
> +               type = nla_get_u32(info->attrs[CIFS_GENL_ATTR_SWN_NOTIFICATION_TYPE]);
> +       } else {
> +               cifs_dbg(FYI, "%s: missing notification type attribute\n", __func__);
> +               return -EINVAL;
> +       }
> +
> +       switch (type) {
> +       case CIFS_SWN_NOTIFICATION_RESOURCE_CHANGE: {
> +               int state;
> +
> +               if (info->attrs[CIFS_GENL_ATTR_SWN_RESOURCE_NAME]) {
> +                       nla_strlcpy(name, info->attrs[CIFS_GENL_ATTR_SWN_RESOURCE_NAME],
> +                                       sizeof(name));
> +               } else {
> +                       cifs_dbg(FYI, "%s: missing resource name attribute\n", __func__);
> +                       return -EINVAL;
> +               }
> +               if (info->attrs[CIFS_GENL_ATTR_SWN_RESOURCE_STATE]) {
> +                       state = nla_get_u32(info->attrs[CIFS_GENL_ATTR_SWN_RESOURCE_STATE]);
> +               } else {
> +                       cifs_dbg(FYI, "%s: missing resource state attribute\n", __func__);
> +                       return -EINVAL;
> +               }
> +               return cifs_swn_resource_state_changed(swnreg, name, state);
> +       }
> +       default:
> +               cifs_dbg(FYI, "%s: unknown notification type %d\n", __func__, type);
> +               break;
> +       }
> +
> +       return 0;
> +}
> +
>  int cifs_swn_register(struct cifs_tcon *tcon)
>  {
>         struct cifs_swn_reg *swnreg;
> diff --git a/fs/cifs/cifs_swn.h b/fs/cifs/cifs_swn.h
> index 69c7bd1035da..7ef9ecedbd05 100644
> --- a/fs/cifs/cifs_swn.h
> +++ b/fs/cifs/cifs_swn.h
> @@ -9,9 +9,13 @@
>  #define _CIFS_SWN_H
>
>  struct cifs_tcon;
> +struct sk_buff;
> +struct genl_info;
>
>  extern int cifs_swn_register(struct cifs_tcon *tcon);
>
>  extern int cifs_swn_unregister(struct cifs_tcon *tcon);
>
> +extern int cifs_swn_notify(struct sk_buff *skb, struct genl_info *info);
> +
>  #endif /* _CIFS_SWN_H */
> diff --git a/fs/cifs/netlink.c b/fs/cifs/netlink.c
> index 83008a56def5..5aaabe4cc0a7 100644
> --- a/fs/cifs/netlink.c
> +++ b/fs/cifs/netlink.c
> @@ -11,6 +11,7 @@
>  #include "netlink.h"
>  #include "cifsglob.h"
>  #include "cifs_debug.h"
> +#include "cifs_swn.h"
>
>  static const struct nla_policy cifs_genl_policy[CIFS_GENL_ATTR_MAX + 1] = {
>         [CIFS_GENL_ATTR_SWN_REGISTRATION_ID]    = { .type = NLA_U32 },
> @@ -24,9 +25,17 @@ static const struct nla_policy cifs_genl_policy[CIFS_GENL_ATTR_MAX + 1] = {
>         [CIFS_GENL_ATTR_SWN_USER_NAME]          = { .type = NLA_STRING },
>         [CIFS_GENL_ATTR_SWN_PASSWORD]           = { .type = NLA_STRING },
>         [CIFS_GENL_ATTR_SWN_DOMAIN_NAME]        = { .type = NLA_STRING },
> +       [CIFS_GENL_ATTR_SWN_NOTIFICATION_TYPE]  = { .type = NLA_U32 },
> +       [CIFS_GENL_ATTR_SWN_RESOURCE_STATE]     = { .type = NLA_U32 },
> +       [CIFS_GENL_ATTR_SWN_RESOURCE_NAME]      = { .type = NLA_STRING},
>  };
>
>  static struct genl_ops cifs_genl_ops[] = {
> +       {
> +               .cmd = CIFS_GENL_CMD_SWN_NOTIFY,
> +               .validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
> +               .doit = cifs_swn_notify,
> +       },
>  };
>
>  static const struct genl_multicast_group cifs_genl_mcgrps[] = {
> diff --git a/include/uapi/linux/cifs/cifs_netlink.h b/include/uapi/linux/cifs/cifs_netlink.h
> index 5662e2774513..da3107582f49 100644
> --- a/include/uapi/linux/cifs/cifs_netlink.h
> +++ b/include/uapi/linux/cifs/cifs_netlink.h
> @@ -31,6 +31,9 @@ enum cifs_genl_attributes {
>         CIFS_GENL_ATTR_SWN_USER_NAME,
>         CIFS_GENL_ATTR_SWN_PASSWORD,
>         CIFS_GENL_ATTR_SWN_DOMAIN_NAME,
> +       CIFS_GENL_ATTR_SWN_NOTIFICATION_TYPE,
> +       CIFS_GENL_ATTR_SWN_RESOURCE_STATE,
> +       CIFS_GENL_ATTR_SWN_RESOURCE_NAME,
>         __CIFS_GENL_ATTR_MAX,
>  };
>  #define CIFS_GENL_ATTR_MAX (__CIFS_GENL_ATTR_MAX - 1)
> @@ -39,8 +42,22 @@ enum cifs_genl_commands {
>         CIFS_GENL_CMD_UNSPEC,
>         CIFS_GENL_CMD_SWN_REGISTER,
>         CIFS_GENL_CMD_SWN_UNREGISTER,
> +       CIFS_GENL_CMD_SWN_NOTIFY,
>         __CIFS_GENL_CMD_MAX
>  };
>  #define CIFS_GENL_CMD_MAX (__CIFS_GENL_CMD_MAX - 1)
>
> +enum cifs_swn_notification_type {
> +       CIFS_SWN_NOTIFICATION_RESOURCE_CHANGE = 0x01,
> +       CIFS_SWN_NOTIFICATION_CLIENT_MOVE        = 0x02,
> +       CIFS_SWN_NOTIFICATION_SHARE_MOVE         = 0x03,
> +       CIFS_SWN_NOTIFICATION_IP_CHANGE  = 0x04,
> +};
> +
> +enum cifs_swn_resource_state {
> +       CIFS_SWN_RESOURCE_STATE_UNKNOWN     = 0x00,
> +       CIFS_SWN_RESOURCE_STATE_AVAILABLE   = 0x01,
> +       CIFS_SWN_RESOURCE_STATE_UNAVAILABLE = 0xFF
> +};
> +
>  #endif /* _UAPILINUX_CIFS_NETLINK_H */
> --
> 2.29.2
>


-- 
Thanks,

Steve
