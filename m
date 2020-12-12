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
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA601C4361B
	for <linux-cifs@archiver.kernel.org>; Sat, 12 Dec 2020 05:54:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C0192313F
	for <linux-cifs@archiver.kernel.org>; Sat, 12 Dec 2020 05:54:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725963AbgLLFxy (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 12 Dec 2020 00:53:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404022AbgLLFxa (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 12 Dec 2020 00:53:30 -0500
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C91DBC0613CF
        for <linux-cifs@vger.kernel.org>; Fri, 11 Dec 2020 21:52:48 -0800 (PST)
Received: by mail-lf1-x142.google.com with SMTP id m19so16959074lfb.1
        for <linux-cifs@vger.kernel.org>; Fri, 11 Dec 2020 21:52:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=l+Rz+65RgodAUw8wC6Yk8aDrK2aH5Ee79qAOjlJ5UFs=;
        b=j6/O3ihWKrohUcgL40CO4n/p1J8/7QyT6V7NW3LkBUr5pKYrjgO6P5QNZ87aydChke
         gx8MAiICyOoDLHAI4REaLi5cxr7KszXK2qyNJYaShA7exTyBbIfJpZMrOkzDu10c+KPv
         R9c/TXxozp299J3Xt8Dm6n/weXZ/kG+X23Q83x+MjtO+5r3rYb7HTBez2HXSPxOPkbJy
         UhmIYhxwsXOBKq6X0q/AO8rDmj2VGejDHYqAtKNN6Dfjnd9fqhHWnAqBzoVcV1O+qTHW
         7x6my7XpqFOyaFGhRKvSLlOpzu/M34OE/xQ3MTahsZg4RA0HTh7h7PYaVt0Lt33qjex0
         UE7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l+Rz+65RgodAUw8wC6Yk8aDrK2aH5Ee79qAOjlJ5UFs=;
        b=X5kmd0LH5MJEZSbrEq4BT/xvM9YwwVELvZL6m+uf/YEN0aH54GndJoRcB6T+J/dVuR
         2vLIvkzz1BfpDmaHtpK+CQGSfWzYie482HXXwZzIxi/YWikHtySioH8FMqYgrSr+fHSs
         wSrIR5d5p+b9cy8EkgFTtNWasNRUghs/AwySpS+ALFkGCgFug0Ez6W1wITE28ODpjrss
         qHxvUfHygJtMckHojL9PPFomGEch9giWtwYDmqu5870Nhya8DIfhuD6Swnjmptn5mP9c
         +tdkFNUpplzEKeBLHoEKm5ry95vNEWavUL/vS2LkGTlZ0C9xO295slqOjTuX7tD5RaLz
         0CrA==
X-Gm-Message-State: AOAM532XlrG5kHH2d7G1a04E8Fdx2W7mb7nla1q1fIqesbOJADA9hECB
        DZVYAROmSam8TOcv7ZsvPZAcpp8e/9k2Ok45j8deYGixhPuhhA==
X-Google-Smtp-Source: ABdhPJydhbjPp03C+WEpQez+Z6cOJHU/dVnDAue7901/vc9qsrPahhuQxCKLLP381uEK12nJvEGkHmLJNy01GJDjmkI=
X-Received: by 2002:a19:f11e:: with SMTP id p30mr5583703lfh.395.1607752367104;
 Fri, 11 Dec 2020 21:52:47 -0800 (PST)
MIME-Version: 1.0
References: <20201130180257.31787-1-scabrero@suse.de> <20201130180257.31787-6-scabrero@suse.de>
In-Reply-To: <20201130180257.31787-6-scabrero@suse.de>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 11 Dec 2020 23:52:34 -0600
Message-ID: <CAH2r5mtow7suE+Kj-Z9emQ6T64S4xQaov9cPRGL6nte94KvK=Q@mail.gmail.com>
Subject: Re: [PATCH v4 05/11] cifs: Send witness register and unregister
 commands to userspace daemon
To:     Samuel Cabrero <scabrero@suse.de>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Content-Type: multipart/mixed; boundary="000000000000ba803a05b63e040d"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000ba803a05b63e040d
Content-Type: text/plain; charset="UTF-8"

updated version of the patch attached (rebased on current for-next).
Tentatively merged into cifs-2.6.git for-next


On Mon, Nov 30, 2020 at 12:06 PM Samuel Cabrero <scabrero@suse.de> wrote:
>
> + Define the generic netlink family commands and message attributes to
>   communicate with the userspace daemon
>
> + The register and unregister commands are sent when connecting or
>   disconnecting a tree. The witness registration keeps a pointer to
>   the tcon and has the same lifetime.
>
> + Each registration has an id allocated by an IDR. This id is sent to the
>   userspace daemon in the register command, and will be included in the
>   notification messages from the userspace daemon to retrieve from the
>   IDR the matching registration.
>
> + The authentication information is bundled in the register message.
>   If kerberos is used the message just carries a flag.
>
> Signed-off-by: Samuel Cabrero <scabrero@suse.de>
> ---
>  fs/cifs/Makefile                       |   2 +-
>  fs/cifs/cifs_swn.c                     | 421 +++++++++++++++++++++++++
>  fs/cifs/cifs_swn.h                     |  17 +
>  fs/cifs/connect.c                      |  26 +-
>  fs/cifs/netlink.c                      |  11 +
>  include/uapi/linux/cifs/cifs_netlink.h |  15 +
>  6 files changed, 489 insertions(+), 3 deletions(-)
>  create mode 100644 fs/cifs/cifs_swn.c
>  create mode 100644 fs/cifs/cifs_swn.h
>
> diff --git a/fs/cifs/Makefile b/fs/cifs/Makefile
> index b88fd46ac597..abb2fbc0f904 100644
> --- a/fs/cifs/Makefile
> +++ b/fs/cifs/Makefile
> @@ -18,7 +18,7 @@ cifs-$(CONFIG_CIFS_UPCALL) += cifs_spnego.o
>
>  cifs-$(CONFIG_CIFS_DFS_UPCALL) += dns_resolve.o cifs_dfs_ref.o dfs_cache.o
>
> -cifs-$(CONFIG_CIFS_SWN_UPCALL) += netlink.o
> +cifs-$(CONFIG_CIFS_SWN_UPCALL) += netlink.o cifs_swn.o
>
>  cifs-$(CONFIG_CIFS_FSCACHE) += fscache.o cache.o
>
> diff --git a/fs/cifs/cifs_swn.c b/fs/cifs/cifs_swn.c
> new file mode 100644
> index 000000000000..c0af03955d0c
> --- /dev/null
> +++ b/fs/cifs/cifs_swn.c
> @@ -0,0 +1,421 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Witness Service client for CIFS
> + *
> + * Copyright (c) 2020 Samuel Cabrero <scabrero@suse.de>
> + */
> +
> +#include <linux/kref.h>
> +#include <net/genetlink.h>
> +#include <uapi/linux/cifs/cifs_netlink.h>
> +
> +#include "cifs_swn.h"
> +#include "cifsglob.h"
> +#include "cifsproto.h"
> +#include "fscache.h"
> +#include "cifs_debug.h"
> +#include "netlink.h"
> +
> +static DEFINE_IDR(cifs_swnreg_idr);
> +static DEFINE_MUTEX(cifs_swnreg_idr_mutex);
> +
> +struct cifs_swn_reg {
> +       int id;
> +       struct kref ref_count;
> +
> +       const char *net_name;
> +       const char *share_name;
> +       bool net_name_notify;
> +       bool share_name_notify;
> +       bool ip_notify;
> +
> +       struct cifs_tcon *tcon;
> +};
> +
> +static int cifs_swn_auth_info_krb(struct cifs_tcon *tcon, struct sk_buff *skb)
> +{
> +       int ret;
> +
> +       ret = nla_put_flag(skb, CIFS_GENL_ATTR_SWN_KRB_AUTH);
> +       if (ret < 0)
> +               return ret;
> +
> +       return 0;
> +}
> +
> +static int cifs_swn_auth_info_ntlm(struct cifs_tcon *tcon, struct sk_buff *skb)
> +{
> +       int ret;
> +
> +       if (tcon->ses->user_name != NULL) {
> +               ret = nla_put_string(skb, CIFS_GENL_ATTR_SWN_USER_NAME, tcon->ses->user_name);
> +               if (ret < 0)
> +                       return ret;
> +       }
> +
> +       if (tcon->ses->password != NULL) {
> +               ret = nla_put_string(skb, CIFS_GENL_ATTR_SWN_PASSWORD, tcon->ses->password);
> +               if (ret < 0)
> +                       return ret;
> +       }
> +
> +       if (tcon->ses->domainName != NULL) {
> +               ret = nla_put_string(skb, CIFS_GENL_ATTR_SWN_DOMAIN_NAME, tcon->ses->domainName);
> +               if (ret < 0)
> +                       return ret;
> +       }
> +
> +       return 0;
> +}
> +
> +/*
> + * Sends a register message to the userspace daemon based on the registration.
> + * The authentication information to connect to the witness service is bundled
> + * into the message.
> + */
> +static int cifs_swn_send_register_message(struct cifs_swn_reg *swnreg)
> +{
> +       struct sk_buff *skb;
> +       struct genlmsghdr *hdr;
> +       enum securityEnum authtype;
> +       int ret;
> +
> +       skb = genlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
> +       if (skb == NULL) {
> +               ret = -ENOMEM;
> +               goto fail;
> +       }
> +
> +       hdr = genlmsg_put(skb, 0, 0, &cifs_genl_family, 0, CIFS_GENL_CMD_SWN_REGISTER);
> +       if (hdr == NULL) {
> +               ret = -ENOMEM;
> +               goto nlmsg_fail;
> +       }
> +
> +       ret = nla_put_u32(skb, CIFS_GENL_ATTR_SWN_REGISTRATION_ID, swnreg->id);
> +       if (ret < 0)
> +               goto nlmsg_fail;
> +
> +       ret = nla_put_string(skb, CIFS_GENL_ATTR_SWN_NET_NAME, swnreg->net_name);
> +       if (ret < 0)
> +               goto nlmsg_fail;
> +
> +       ret = nla_put_string(skb, CIFS_GENL_ATTR_SWN_SHARE_NAME, swnreg->share_name);
> +       if (ret < 0)
> +               goto nlmsg_fail;
> +
> +       ret = nla_put(skb, CIFS_GENL_ATTR_SWN_IP, sizeof(struct sockaddr_storage),
> +                       &swnreg->tcon->ses->server->dstaddr);
> +       if (ret < 0)
> +               goto nlmsg_fail;
> +
> +       if (swnreg->net_name_notify) {
> +               ret = nla_put_flag(skb, CIFS_GENL_ATTR_SWN_NET_NAME_NOTIFY);
> +               if (ret < 0)
> +                       goto nlmsg_fail;
> +       }
> +
> +       if (swnreg->share_name_notify) {
> +               ret = nla_put_flag(skb, CIFS_GENL_ATTR_SWN_SHARE_NAME_NOTIFY);
> +               if (ret < 0)
> +                       goto nlmsg_fail;
> +       }
> +
> +       if (swnreg->ip_notify) {
> +               ret = nla_put_flag(skb, CIFS_GENL_ATTR_SWN_IP_NOTIFY);
> +               if (ret < 0)
> +                       goto nlmsg_fail;
> +       }
> +
> +       authtype = cifs_select_sectype(swnreg->tcon->ses->server, swnreg->tcon->ses->sectype);
> +       switch (authtype) {
> +       case Kerberos:
> +               ret = cifs_swn_auth_info_krb(swnreg->tcon, skb);
> +               if (ret < 0) {
> +                       cifs_dbg(VFS, "%s: Failed to get kerberos auth info: %d\n", __func__, ret);
> +                       goto nlmsg_fail;
> +               }
> +               break;
> +       case LANMAN:
> +       case NTLM:
> +       case NTLMv2:
> +       case RawNTLMSSP:
> +               ret = cifs_swn_auth_info_ntlm(swnreg->tcon, skb);
> +               if (ret < 0) {
> +                       cifs_dbg(VFS, "%s: Failed to get NTLM auth info: %d\n", __func__, ret);
> +                       goto nlmsg_fail;
> +               }
> +               break;
> +       default:
> +               cifs_dbg(VFS, "%s: secType %d not supported!\n", __func__, authtype);
> +               ret = -EINVAL;
> +               goto nlmsg_fail;
> +       }
> +
> +       genlmsg_end(skb, hdr);
> +       genlmsg_multicast(&cifs_genl_family, skb, 0, CIFS_GENL_MCGRP_SWN, GFP_ATOMIC);
> +
> +       cifs_dbg(FYI, "%s: Message to register for network name %s with id %d sent\n", __func__,
> +                       swnreg->net_name, swnreg->id);
> +
> +       return 0;
> +
> +nlmsg_fail:
> +       genlmsg_cancel(skb, hdr);
> +       nlmsg_free(skb);
> +fail:
> +       return ret;
> +}
> +
> +/*
> + * Sends an uregister message to the userspace daemon based on the registration
> + */
> +static int cifs_swn_send_unregister_message(struct cifs_swn_reg *swnreg)
> +{
> +       struct sk_buff *skb;
> +       struct genlmsghdr *hdr;
> +       int ret;
> +
> +       skb = genlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
> +       if (skb == NULL)
> +               return -ENOMEM;
> +
> +       hdr = genlmsg_put(skb, 0, 0, &cifs_genl_family, 0, CIFS_GENL_CMD_SWN_UNREGISTER);
> +       if (hdr == NULL) {
> +               ret = -ENOMEM;
> +               goto nlmsg_fail;
> +       }
> +
> +       ret = nla_put_u32(skb, CIFS_GENL_ATTR_SWN_REGISTRATION_ID, swnreg->id);
> +       if (ret < 0)
> +               goto nlmsg_fail;
> +
> +       ret = nla_put_string(skb, CIFS_GENL_ATTR_SWN_NET_NAME, swnreg->net_name);
> +       if (ret < 0)
> +               goto nlmsg_fail;
> +
> +       ret = nla_put_string(skb, CIFS_GENL_ATTR_SWN_SHARE_NAME, swnreg->share_name);
> +       if (ret < 0)
> +               goto nlmsg_fail;
> +
> +       ret = nla_put(skb, CIFS_GENL_ATTR_SWN_IP, sizeof(struct sockaddr_storage),
> +                       &swnreg->tcon->ses->server->dstaddr);
> +       if (ret < 0)
> +               goto nlmsg_fail;
> +
> +       if (swnreg->net_name_notify) {
> +               ret = nla_put_flag(skb, CIFS_GENL_ATTR_SWN_NET_NAME_NOTIFY);
> +               if (ret < 0)
> +                       goto nlmsg_fail;
> +       }
> +
> +       if (swnreg->share_name_notify) {
> +               ret = nla_put_flag(skb, CIFS_GENL_ATTR_SWN_SHARE_NAME_NOTIFY);
> +               if (ret < 0)
> +                       goto nlmsg_fail;
> +       }
> +
> +       if (swnreg->ip_notify) {
> +               ret = nla_put_flag(skb, CIFS_GENL_ATTR_SWN_IP_NOTIFY);
> +               if (ret < 0)
> +                       goto nlmsg_fail;
> +       }
> +
> +       genlmsg_end(skb, hdr);
> +       genlmsg_multicast(&cifs_genl_family, skb, 0, CIFS_GENL_MCGRP_SWN, GFP_ATOMIC);
> +
> +       cifs_dbg(FYI, "%s: Message to unregister for network name %s with id %d sent\n", __func__,
> +                       swnreg->net_name, swnreg->id);
> +
> +       return 0;
> +
> +nlmsg_fail:
> +       genlmsg_cancel(skb, hdr);
> +       nlmsg_free(skb);
> +       return ret;
> +}
> +
> +/*
> + * Try to find a matching registration for the tcon's server name and share name.
> + * Calls to this funciton must be protected by cifs_swnreg_idr_mutex.
> + * TODO Try to avoid memory allocations
> + */
> +static struct cifs_swn_reg *cifs_find_swn_reg(struct cifs_tcon *tcon)
> +{
> +       struct cifs_swn_reg *swnreg;
> +       int id;
> +       const char *share_name;
> +       const char *net_name;
> +
> +       net_name = extract_hostname(tcon->treeName);
> +       if (IS_ERR_OR_NULL(net_name)) {
> +               int ret;
> +
> +               ret = PTR_ERR(net_name);
> +               cifs_dbg(VFS, "%s: failed to extract host name from target '%s': %d\n",
> +                               __func__, tcon->treeName, ret);
> +               return NULL;
> +       }
> +
> +       share_name = extract_sharename(tcon->treeName);
> +       if (IS_ERR_OR_NULL(share_name)) {
> +               int ret;
> +
> +               ret = PTR_ERR(net_name);
> +               cifs_dbg(VFS, "%s: failed to extract share name from target '%s': %d\n",
> +                               __func__, tcon->treeName, ret);
> +               kfree(net_name);
> +               return NULL;
> +       }
> +
> +       idr_for_each_entry(&cifs_swnreg_idr, swnreg, id) {
> +               if (strcasecmp(swnreg->net_name, net_name) != 0
> +                   || strcasecmp(swnreg->share_name, share_name) != 0) {
> +                       continue;
> +               }
> +
> +               mutex_unlock(&cifs_swnreg_idr_mutex);
> +
> +               cifs_dbg(FYI, "Existing swn registration for %s:%s found\n", swnreg->net_name,
> +                               swnreg->share_name);
> +
> +               kfree(net_name);
> +               kfree(share_name);
> +
> +               return swnreg;
> +       }
> +
> +       kfree(net_name);
> +       kfree(share_name);
> +
> +       return NULL;
> +}
> +
> +/*
> + * Get a registration for the tcon's server and share name, allocating a new one if it does not
> + * exists
> + */
> +static struct cifs_swn_reg *cifs_get_swn_reg(struct cifs_tcon *tcon)
> +{
> +       struct cifs_swn_reg *reg = NULL;
> +       int ret;
> +
> +       mutex_lock(&cifs_swnreg_idr_mutex);
> +
> +       /* Check if we are already registered for this network and share names */
> +       reg = cifs_find_swn_reg(tcon);
> +       if (IS_ERR(reg)) {
> +               return reg;
> +       } else if (reg != NULL) {
> +               kref_get(&reg->ref_count);
> +               mutex_unlock(&cifs_swnreg_idr_mutex);
> +               return reg;
> +       }
> +
> +       reg = kmalloc(sizeof(struct cifs_swn_reg), GFP_ATOMIC);
> +       if (reg == NULL) {
> +               mutex_unlock(&cifs_swnreg_idr_mutex);
> +               return ERR_PTR(-ENOMEM);
> +       }
> +
> +       kref_init(&reg->ref_count);
> +
> +       reg->id = idr_alloc(&cifs_swnreg_idr, reg, 1, 0, GFP_ATOMIC);
> +       if (reg->id < 0) {
> +               cifs_dbg(FYI, "%s: failed to allocate registration id\n", __func__);
> +               ret = reg->id;
> +               goto fail;
> +       }
> +
> +       reg->net_name = extract_hostname(tcon->treeName);
> +       if (IS_ERR(reg->net_name)) {
> +               ret = PTR_ERR(reg->net_name);
> +               cifs_dbg(VFS, "%s: failed to extract host name from target: %d\n", __func__, ret);
> +               goto fail_idr;
> +       }
> +
> +       reg->share_name = extract_sharename(tcon->treeName);
> +       if (IS_ERR(reg->share_name)) {
> +               ret = PTR_ERR(reg->share_name);
> +               cifs_dbg(VFS, "%s: failed to extract share name from target: %d\n", __func__, ret);
> +               goto fail_net_name;
> +       }
> +
> +       reg->net_name_notify = true;
> +       reg->share_name_notify = true;
> +       reg->ip_notify = (tcon->capabilities & SMB2_SHARE_CAP_SCALEOUT);
> +
> +       reg->tcon = tcon;
> +
> +       mutex_unlock(&cifs_swnreg_idr_mutex);
> +
> +       return reg;
> +
> +fail_net_name:
> +       kfree(reg->net_name);
> +fail_idr:
> +       idr_remove(&cifs_swnreg_idr, reg->id);
> +fail:
> +       kfree(reg);
> +       mutex_unlock(&cifs_swnreg_idr_mutex);
> +       return ERR_PTR(ret);
> +}
> +
> +static void cifs_swn_reg_release(struct kref *ref)
> +{
> +       struct cifs_swn_reg *swnreg = container_of(ref, struct cifs_swn_reg, ref_count);
> +       int ret;
> +
> +       ret = cifs_swn_send_unregister_message(swnreg);
> +       if (ret < 0)
> +               cifs_dbg(VFS, "%s: Failed to send unregister message: %d\n", __func__, ret);
> +
> +       idr_remove(&cifs_swnreg_idr, swnreg->id);
> +       kfree(swnreg->net_name);
> +       kfree(swnreg->share_name);
> +       kfree(swnreg);
> +}
> +
> +static void cifs_put_swn_reg(struct cifs_swn_reg *swnreg)
> +{
> +       mutex_lock(&cifs_swnreg_idr_mutex);
> +       kref_put(&swnreg->ref_count, cifs_swn_reg_release);
> +       mutex_unlock(&cifs_swnreg_idr_mutex);
> +}
> +
> +int cifs_swn_register(struct cifs_tcon *tcon)
> +{
> +       struct cifs_swn_reg *swnreg;
> +       int ret;
> +
> +       swnreg = cifs_get_swn_reg(tcon);
> +       if (IS_ERR(swnreg))
> +               return PTR_ERR(swnreg);
> +
> +       ret = cifs_swn_send_register_message(swnreg);
> +       if (ret < 0) {
> +               cifs_dbg(VFS, "%s: Failed to send swn register message: %d\n", __func__, ret);
> +               /* Do not put the swnreg or return error, the echo task will retry */
> +       }
> +
> +       return 0;
> +}
> +
> +int cifs_swn_unregister(struct cifs_tcon *tcon)
> +{
> +       struct cifs_swn_reg *swnreg;
> +
> +       mutex_lock(&cifs_swnreg_idr_mutex);
> +
> +       swnreg = cifs_find_swn_reg(tcon);
> +       if (swnreg == NULL) {
> +               mutex_unlock(&cifs_swnreg_idr_mutex);
> +               return -EEXIST;
> +       }
> +
> +       mutex_unlock(&cifs_swnreg_idr_mutex);
> +
> +       cifs_put_swn_reg(swnreg);
> +
> +       return 0;
> +}
> diff --git a/fs/cifs/cifs_swn.h b/fs/cifs/cifs_swn.h
> new file mode 100644
> index 000000000000..69c7bd1035da
> --- /dev/null
> +++ b/fs/cifs/cifs_swn.h
> @@ -0,0 +1,17 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Witness Service client for CIFS
> + *
> + * Copyright (c) 2020 Samuel Cabrero <scabrero@suse.de>
> + */
> +
> +#ifndef _CIFS_SWN_H
> +#define _CIFS_SWN_H
> +
> +struct cifs_tcon;
> +
> +extern int cifs_swn_register(struct cifs_tcon *tcon);
> +
> +extern int cifs_swn_unregister(struct cifs_tcon *tcon);
> +
> +#endif /* _CIFS_SWN_H */
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 22d46c8acc7f..7fbb201b42c3 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -62,6 +62,9 @@
>  #include "dfs_cache.h"
>  #endif
>  #include "fs_context.h"
> +#ifdef CONFIG_CIFS_SWN_UPCALL
> +#include "cifs_swn.h"
> +#endif
>
>  extern mempool_t *cifs_req_poolp;
>  extern bool disable_legacy_dialects;
> @@ -3168,7 +3171,17 @@ cifs_put_tcon(struct cifs_tcon *tcon)
>                 return;
>         }
>
> -       /* TODO witness unregister */
> +#ifdef CONFIG_CIFS_SWN_UPCALL
> +       if (tcon->use_witness) {
> +               int rc;
> +
> +               rc = cifs_swn_unregister(tcon);
> +               if (rc < 0) {
> +                       cifs_dbg(VFS, "%s: Failed to unregister for witness notifications: %d\n",
> +                                       __func__, rc);
> +               }
> +       }
> +#endif
>
>         list_del_init(&tcon->tcon_list);
>         spin_unlock(&cifs_tcp_ses_lock);
> @@ -3336,8 +3349,17 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb_vol *volume_info)
>         if (volume_info->witness) {
>                 if (ses->server->vals->protocol_id >= SMB30_PROT_ID) {
>                         if (tcon->capabilities & SMB2_SHARE_CAP_CLUSTER) {
> -                               /* TODO witness register */
> +                               /*
> +                                * Set witness in use flag in first place
> +                                * to retry registration in the echo task
> +                                */
>                                 tcon->use_witness = true;
> +                               /* And try to register immediately */
> +                               rc = cifs_swn_register(tcon);
> +                               if (rc < 0) {
> +                                       cifs_dbg(VFS, "Failed to register for witness notifications: %d\n", rc);
> +                                       goto out_fail;
> +                               }
>                         } else {
>                                 cifs_dbg(VFS, "witness requested on mount but no CLUSTER capability on share\n");
>                                 rc = -EOPNOTSUPP;
> diff --git a/fs/cifs/netlink.c b/fs/cifs/netlink.c
> index b9154661fa85..83008a56def5 100644
> --- a/fs/cifs/netlink.c
> +++ b/fs/cifs/netlink.c
> @@ -13,6 +13,17 @@
>  #include "cifs_debug.h"
>
>  static const struct nla_policy cifs_genl_policy[CIFS_GENL_ATTR_MAX + 1] = {
> +       [CIFS_GENL_ATTR_SWN_REGISTRATION_ID]    = { .type = NLA_U32 },
> +       [CIFS_GENL_ATTR_SWN_NET_NAME]           = { .type = NLA_STRING },
> +       [CIFS_GENL_ATTR_SWN_SHARE_NAME]         = { .type = NLA_STRING },
> +       [CIFS_GENL_ATTR_SWN_IP]                 = { .len = sizeof(struct sockaddr_storage) },
> +       [CIFS_GENL_ATTR_SWN_NET_NAME_NOTIFY]    = { .type = NLA_FLAG },
> +       [CIFS_GENL_ATTR_SWN_SHARE_NAME_NOTIFY]  = { .type = NLA_FLAG },
> +       [CIFS_GENL_ATTR_SWN_IP_NOTIFY]          = { .type = NLA_FLAG },
> +       [CIFS_GENL_ATTR_SWN_KRB_AUTH]           = { .type = NLA_FLAG },
> +       [CIFS_GENL_ATTR_SWN_USER_NAME]          = { .type = NLA_STRING },
> +       [CIFS_GENL_ATTR_SWN_PASSWORD]           = { .type = NLA_STRING },
> +       [CIFS_GENL_ATTR_SWN_DOMAIN_NAME]        = { .type = NLA_STRING },
>  };
>
>  static struct genl_ops cifs_genl_ops[] = {
> diff --git a/include/uapi/linux/cifs/cifs_netlink.h b/include/uapi/linux/cifs/cifs_netlink.h
> index cdb1bd78fbc7..5662e2774513 100644
> --- a/include/uapi/linux/cifs/cifs_netlink.h
> +++ b/include/uapi/linux/cifs/cifs_netlink.h
> @@ -19,11 +19,26 @@ enum cifs_genl_multicast_groups {
>  };
>
>  enum cifs_genl_attributes {
> +       CIFS_GENL_ATTR_UNSPEC,
> +       CIFS_GENL_ATTR_SWN_REGISTRATION_ID,
> +       CIFS_GENL_ATTR_SWN_NET_NAME,
> +       CIFS_GENL_ATTR_SWN_SHARE_NAME,
> +       CIFS_GENL_ATTR_SWN_IP,
> +       CIFS_GENL_ATTR_SWN_NET_NAME_NOTIFY,
> +       CIFS_GENL_ATTR_SWN_SHARE_NAME_NOTIFY,
> +       CIFS_GENL_ATTR_SWN_IP_NOTIFY,
> +       CIFS_GENL_ATTR_SWN_KRB_AUTH,
> +       CIFS_GENL_ATTR_SWN_USER_NAME,
> +       CIFS_GENL_ATTR_SWN_PASSWORD,
> +       CIFS_GENL_ATTR_SWN_DOMAIN_NAME,
>         __CIFS_GENL_ATTR_MAX,
>  };
>  #define CIFS_GENL_ATTR_MAX (__CIFS_GENL_ATTR_MAX - 1)
>
>  enum cifs_genl_commands {
> +       CIFS_GENL_CMD_UNSPEC,
> +       CIFS_GENL_CMD_SWN_REGISTER,
> +       CIFS_GENL_CMD_SWN_UNREGISTER,
>         __CIFS_GENL_CMD_MAX
>  };
>  #define CIFS_GENL_CMD_MAX (__CIFS_GENL_CMD_MAX - 1)
> --
> 2.29.2
>


-- 
Thanks,

Steve

--000000000000ba803a05b63e040d
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0008-cifs-Send-witness-register-and-unregister-commands-t.patch"
Content-Disposition: attachment; 
	filename="0008-cifs-Send-witness-register-and-unregister-commands-t.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kila8dl10>
X-Attachment-Id: f_kila8dl10

RnJvbSBkNTkyYTAwNTRlODc0MWQ2MDMyNGQxZWMwNjczNzVmNTQ3OWYzMjk1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTYW11ZWwgQ2FicmVybyA8c2NhYnJlcm9Ac3VzZS5kZT4KRGF0
ZTogTW9uLCAzMCBOb3YgMjAyMCAxOTowMjo1MSArMDEwMApTdWJqZWN0OiBbUEFUQ0ggOC84XSBj
aWZzOiBTZW5kIHdpdG5lc3MgcmVnaXN0ZXIgYW5kIHVucmVnaXN0ZXIgY29tbWFuZHMgdG8KIHVz
ZXJzcGFjZSBkYWVtb24KCisgRGVmaW5lIHRoZSBnZW5lcmljIG5ldGxpbmsgZmFtaWx5IGNvbW1h
bmRzIGFuZCBtZXNzYWdlIGF0dHJpYnV0ZXMgdG8KICBjb21tdW5pY2F0ZSB3aXRoIHRoZSB1c2Vy
c3BhY2UgZGFlbW9uCgorIFRoZSByZWdpc3RlciBhbmQgdW5yZWdpc3RlciBjb21tYW5kcyBhcmUg
c2VudCB3aGVuIGNvbm5lY3Rpbmcgb3IKICBkaXNjb25uZWN0aW5nIGEgdHJlZS4gVGhlIHdpdG5l
c3MgcmVnaXN0cmF0aW9uIGtlZXBzIGEgcG9pbnRlciB0bwogIHRoZSB0Y29uIGFuZCBoYXMgdGhl
IHNhbWUgbGlmZXRpbWUuCgorIEVhY2ggcmVnaXN0cmF0aW9uIGhhcyBhbiBpZCBhbGxvY2F0ZWQg
YnkgYW4gSURSLiBUaGlzIGlkIGlzIHNlbnQgdG8gdGhlCiAgdXNlcnNwYWNlIGRhZW1vbiBpbiB0
aGUgcmVnaXN0ZXIgY29tbWFuZCwgYW5kIHdpbGwgYmUgaW5jbHVkZWQgaW4gdGhlCiAgbm90aWZp
Y2F0aW9uIG1lc3NhZ2VzIGZyb20gdGhlIHVzZXJzcGFjZSBkYWVtb24gdG8gcmV0cmlldmUgZnJv
bSB0aGUKICBJRFIgdGhlIG1hdGNoaW5nIHJlZ2lzdHJhdGlvbi4KCisgVGhlIGF1dGhlbnRpY2F0
aW9uIGluZm9ybWF0aW9uIGlzIGJ1bmRsZWQgaW4gdGhlIHJlZ2lzdGVyIG1lc3NhZ2UuCiAgSWYg
a2VyYmVyb3MgaXMgdXNlZCB0aGUgbWVzc2FnZSBqdXN0IGNhcnJpZXMgYSBmbGFnLgoKU2lnbmVk
LW9mZi1ieTogU2FtdWVsIENhYnJlcm8gPHNjYWJyZXJvQHN1c2UuZGU+ClNpZ25lZC1vZmYtYnk6
IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9jaWZzL01ha2Vm
aWxlICAgICAgICAgICAgICAgICAgICAgICB8ICAgMiArLQogZnMvY2lmcy9jaWZzX3N3bi5jICAg
ICAgICAgICAgICAgICAgICAgfCA0MjEgKysrKysrKysrKysrKysrKysrKysrKysrKwogZnMvY2lm
cy9jaWZzX3N3bi5oICAgICAgICAgICAgICAgICAgICAgfCAgMTcgKwogZnMvY2lmcy9jb25uZWN0
LmMgICAgICAgICAgICAgICAgICAgICAgfCAgMjYgKy0KIGZzL2NpZnMvbmV0bGluay5jICAgICAg
ICAgICAgICAgICAgICAgIHwgIDExICsKIGluY2x1ZGUvdWFwaS9saW51eC9jaWZzL2NpZnNfbmV0
bGluay5oIHwgIDE1ICsKIDYgZmlsZXMgY2hhbmdlZCwgNDg5IGluc2VydGlvbnMoKyksIDMgZGVs
ZXRpb25zKC0pCiBjcmVhdGUgbW9kZSAxMDA2NDQgZnMvY2lmcy9jaWZzX3N3bi5jCiBjcmVhdGUg
bW9kZSAxMDA2NDQgZnMvY2lmcy9jaWZzX3N3bi5oCgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9NYWtl
ZmlsZSBiL2ZzL2NpZnMvTWFrZWZpbGUKaW5kZXggOWUzOThkMjI3YjBlLi41MjEzYjIwODQzYjUg
MTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvTWFrZWZpbGUKKysrIGIvZnMvY2lmcy9NYWtlZmlsZQpAQCAt
MTgsNyArMTgsNyBAQCBjaWZzLSQoQ09ORklHX0NJRlNfVVBDQUxMKSArPSBjaWZzX3NwbmVnby5v
CiAKIGNpZnMtJChDT05GSUdfQ0lGU19ERlNfVVBDQUxMKSArPSBkbnNfcmVzb2x2ZS5vIGNpZnNf
ZGZzX3JlZi5vIGRmc19jYWNoZS5vCiAKLWNpZnMtJChDT05GSUdfQ0lGU19TV05fVVBDQUxMKSAr
PSBuZXRsaW5rLm8KK2NpZnMtJChDT05GSUdfQ0lGU19TV05fVVBDQUxMKSArPSBuZXRsaW5rLm8g
Y2lmc19zd24ubwogCiBjaWZzLSQoQ09ORklHX0NJRlNfRlNDQUNIRSkgKz0gZnNjYWNoZS5vIGNh
Y2hlLm8KIApkaWZmIC0tZ2l0IGEvZnMvY2lmcy9jaWZzX3N3bi5jIGIvZnMvY2lmcy9jaWZzX3N3
bi5jCm5ldyBmaWxlIG1vZGUgMTAwNjQ0CmluZGV4IDAwMDAwMDAwMDAwMC4uYzBhZjAzOTU1ZDBj
Ci0tLSAvZGV2L251bGwKKysrIGIvZnMvY2lmcy9jaWZzX3N3bi5jCkBAIC0wLDAgKzEsNDIxIEBA
CisvLyBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMAorLyoKKyAqIFdpdG5lc3MgU2Vy
dmljZSBjbGllbnQgZm9yIENJRlMKKyAqCisgKiBDb3B5cmlnaHQgKGMpIDIwMjAgU2FtdWVsIENh
YnJlcm8gPHNjYWJyZXJvQHN1c2UuZGU+CisgKi8KKworI2luY2x1ZGUgPGxpbnV4L2tyZWYuaD4K
KyNpbmNsdWRlIDxuZXQvZ2VuZXRsaW5rLmg+CisjaW5jbHVkZSA8dWFwaS9saW51eC9jaWZzL2Np
ZnNfbmV0bGluay5oPgorCisjaW5jbHVkZSAiY2lmc19zd24uaCIKKyNpbmNsdWRlICJjaWZzZ2xv
Yi5oIgorI2luY2x1ZGUgImNpZnNwcm90by5oIgorI2luY2x1ZGUgImZzY2FjaGUuaCIKKyNpbmNs
dWRlICJjaWZzX2RlYnVnLmgiCisjaW5jbHVkZSAibmV0bGluay5oIgorCitzdGF0aWMgREVGSU5F
X0lEUihjaWZzX3N3bnJlZ19pZHIpOworc3RhdGljIERFRklORV9NVVRFWChjaWZzX3N3bnJlZ19p
ZHJfbXV0ZXgpOworCitzdHJ1Y3QgY2lmc19zd25fcmVnIHsKKwlpbnQgaWQ7CisJc3RydWN0IGty
ZWYgcmVmX2NvdW50OworCisJY29uc3QgY2hhciAqbmV0X25hbWU7CisJY29uc3QgY2hhciAqc2hh
cmVfbmFtZTsKKwlib29sIG5ldF9uYW1lX25vdGlmeTsKKwlib29sIHNoYXJlX25hbWVfbm90aWZ5
OworCWJvb2wgaXBfbm90aWZ5OworCisJc3RydWN0IGNpZnNfdGNvbiAqdGNvbjsKK307CisKK3N0
YXRpYyBpbnQgY2lmc19zd25fYXV0aF9pbmZvX2tyYihzdHJ1Y3QgY2lmc190Y29uICp0Y29uLCBz
dHJ1Y3Qgc2tfYnVmZiAqc2tiKQoreworCWludCByZXQ7CisKKwlyZXQgPSBubGFfcHV0X2ZsYWco
c2tiLCBDSUZTX0dFTkxfQVRUUl9TV05fS1JCX0FVVEgpOworCWlmIChyZXQgPCAwKQorCQlyZXR1
cm4gcmV0OworCisJcmV0dXJuIDA7Cit9CisKK3N0YXRpYyBpbnQgY2lmc19zd25fYXV0aF9pbmZv
X250bG0oc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwgc3RydWN0IHNrX2J1ZmYgKnNrYikKK3sKKwlp
bnQgcmV0OworCisJaWYgKHRjb24tPnNlcy0+dXNlcl9uYW1lICE9IE5VTEwpIHsKKwkJcmV0ID0g
bmxhX3B1dF9zdHJpbmcoc2tiLCBDSUZTX0dFTkxfQVRUUl9TV05fVVNFUl9OQU1FLCB0Y29uLT5z
ZXMtPnVzZXJfbmFtZSk7CisJCWlmIChyZXQgPCAwKQorCQkJcmV0dXJuIHJldDsKKwl9CisKKwlp
ZiAodGNvbi0+c2VzLT5wYXNzd29yZCAhPSBOVUxMKSB7CisJCXJldCA9IG5sYV9wdXRfc3RyaW5n
KHNrYiwgQ0lGU19HRU5MX0FUVFJfU1dOX1BBU1NXT1JELCB0Y29uLT5zZXMtPnBhc3N3b3JkKTsK
KwkJaWYgKHJldCA8IDApCisJCQlyZXR1cm4gcmV0OworCX0KKworCWlmICh0Y29uLT5zZXMtPmRv
bWFpbk5hbWUgIT0gTlVMTCkgeworCQlyZXQgPSBubGFfcHV0X3N0cmluZyhza2IsIENJRlNfR0VO
TF9BVFRSX1NXTl9ET01BSU5fTkFNRSwgdGNvbi0+c2VzLT5kb21haW5OYW1lKTsKKwkJaWYgKHJl
dCA8IDApCisJCQlyZXR1cm4gcmV0OworCX0KKworCXJldHVybiAwOworfQorCisvKgorICogU2Vu
ZHMgYSByZWdpc3RlciBtZXNzYWdlIHRvIHRoZSB1c2Vyc3BhY2UgZGFlbW9uIGJhc2VkIG9uIHRo
ZSByZWdpc3RyYXRpb24uCisgKiBUaGUgYXV0aGVudGljYXRpb24gaW5mb3JtYXRpb24gdG8gY29u
bmVjdCB0byB0aGUgd2l0bmVzcyBzZXJ2aWNlIGlzIGJ1bmRsZWQKKyAqIGludG8gdGhlIG1lc3Nh
Z2UuCisgKi8KK3N0YXRpYyBpbnQgY2lmc19zd25fc2VuZF9yZWdpc3Rlcl9tZXNzYWdlKHN0cnVj
dCBjaWZzX3N3bl9yZWcgKnN3bnJlZykKK3sKKwlzdHJ1Y3Qgc2tfYnVmZiAqc2tiOworCXN0cnVj
dCBnZW5sbXNnaGRyICpoZHI7CisJZW51bSBzZWN1cml0eUVudW0gYXV0aHR5cGU7CisJaW50IHJl
dDsKKworCXNrYiA9IGdlbmxtc2dfbmV3KE5MTVNHX0RFRkFVTFRfU0laRSwgR0ZQX0tFUk5FTCk7
CisJaWYgKHNrYiA9PSBOVUxMKSB7CisJCXJldCA9IC1FTk9NRU07CisJCWdvdG8gZmFpbDsKKwl9
CisKKwloZHIgPSBnZW5sbXNnX3B1dChza2IsIDAsIDAsICZjaWZzX2dlbmxfZmFtaWx5LCAwLCBD
SUZTX0dFTkxfQ01EX1NXTl9SRUdJU1RFUik7CisJaWYgKGhkciA9PSBOVUxMKSB7CisJCXJldCA9
IC1FTk9NRU07CisJCWdvdG8gbmxtc2dfZmFpbDsKKwl9CisKKwlyZXQgPSBubGFfcHV0X3UzMihz
a2IsIENJRlNfR0VOTF9BVFRSX1NXTl9SRUdJU1RSQVRJT05fSUQsIHN3bnJlZy0+aWQpOworCWlm
IChyZXQgPCAwKQorCQlnb3RvIG5sbXNnX2ZhaWw7CisKKwlyZXQgPSBubGFfcHV0X3N0cmluZyhz
a2IsIENJRlNfR0VOTF9BVFRSX1NXTl9ORVRfTkFNRSwgc3ducmVnLT5uZXRfbmFtZSk7CisJaWYg
KHJldCA8IDApCisJCWdvdG8gbmxtc2dfZmFpbDsKKworCXJldCA9IG5sYV9wdXRfc3RyaW5nKHNr
YiwgQ0lGU19HRU5MX0FUVFJfU1dOX1NIQVJFX05BTUUsIHN3bnJlZy0+c2hhcmVfbmFtZSk7CisJ
aWYgKHJldCA8IDApCisJCWdvdG8gbmxtc2dfZmFpbDsKKworCXJldCA9IG5sYV9wdXQoc2tiLCBD
SUZTX0dFTkxfQVRUUl9TV05fSVAsIHNpemVvZihzdHJ1Y3Qgc29ja2FkZHJfc3RvcmFnZSksCisJ
CQkmc3ducmVnLT50Y29uLT5zZXMtPnNlcnZlci0+ZHN0YWRkcik7CisJaWYgKHJldCA8IDApCisJ
CWdvdG8gbmxtc2dfZmFpbDsKKworCWlmIChzd25yZWctPm5ldF9uYW1lX25vdGlmeSkgeworCQly
ZXQgPSBubGFfcHV0X2ZsYWcoc2tiLCBDSUZTX0dFTkxfQVRUUl9TV05fTkVUX05BTUVfTk9USUZZ
KTsKKwkJaWYgKHJldCA8IDApCisJCQlnb3RvIG5sbXNnX2ZhaWw7CisJfQorCisJaWYgKHN3bnJl
Zy0+c2hhcmVfbmFtZV9ub3RpZnkpIHsKKwkJcmV0ID0gbmxhX3B1dF9mbGFnKHNrYiwgQ0lGU19H
RU5MX0FUVFJfU1dOX1NIQVJFX05BTUVfTk9USUZZKTsKKwkJaWYgKHJldCA8IDApCisJCQlnb3Rv
IG5sbXNnX2ZhaWw7CisJfQorCisJaWYgKHN3bnJlZy0+aXBfbm90aWZ5KSB7CisJCXJldCA9IG5s
YV9wdXRfZmxhZyhza2IsIENJRlNfR0VOTF9BVFRSX1NXTl9JUF9OT1RJRlkpOworCQlpZiAocmV0
IDwgMCkKKwkJCWdvdG8gbmxtc2dfZmFpbDsKKwl9CisKKwlhdXRodHlwZSA9IGNpZnNfc2VsZWN0
X3NlY3R5cGUoc3ducmVnLT50Y29uLT5zZXMtPnNlcnZlciwgc3ducmVnLT50Y29uLT5zZXMtPnNl
Y3R5cGUpOworCXN3aXRjaCAoYXV0aHR5cGUpIHsKKwljYXNlIEtlcmJlcm9zOgorCQlyZXQgPSBj
aWZzX3N3bl9hdXRoX2luZm9fa3JiKHN3bnJlZy0+dGNvbiwgc2tiKTsKKwkJaWYgKHJldCA8IDAp
IHsKKwkJCWNpZnNfZGJnKFZGUywgIiVzOiBGYWlsZWQgdG8gZ2V0IGtlcmJlcm9zIGF1dGggaW5m
bzogJWRcbiIsIF9fZnVuY19fLCByZXQpOworCQkJZ290byBubG1zZ19mYWlsOworCQl9CisJCWJy
ZWFrOworCWNhc2UgTEFOTUFOOgorCWNhc2UgTlRMTToKKwljYXNlIE5UTE12MjoKKwljYXNlIFJh
d05UTE1TU1A6CisJCXJldCA9IGNpZnNfc3duX2F1dGhfaW5mb19udGxtKHN3bnJlZy0+dGNvbiwg
c2tiKTsKKwkJaWYgKHJldCA8IDApIHsKKwkJCWNpZnNfZGJnKFZGUywgIiVzOiBGYWlsZWQgdG8g
Z2V0IE5UTE0gYXV0aCBpbmZvOiAlZFxuIiwgX19mdW5jX18sIHJldCk7CisJCQlnb3RvIG5sbXNn
X2ZhaWw7CisJCX0KKwkJYnJlYWs7CisJZGVmYXVsdDoKKwkJY2lmc19kYmcoVkZTLCAiJXM6IHNl
Y1R5cGUgJWQgbm90IHN1cHBvcnRlZCFcbiIsIF9fZnVuY19fLCBhdXRodHlwZSk7CisJCXJldCA9
IC1FSU5WQUw7CisJCWdvdG8gbmxtc2dfZmFpbDsKKwl9CisKKwlnZW5sbXNnX2VuZChza2IsIGhk
cik7CisJZ2VubG1zZ19tdWx0aWNhc3QoJmNpZnNfZ2VubF9mYW1pbHksIHNrYiwgMCwgQ0lGU19H
RU5MX01DR1JQX1NXTiwgR0ZQX0FUT01JQyk7CisKKwljaWZzX2RiZyhGWUksICIlczogTWVzc2Fn
ZSB0byByZWdpc3RlciBmb3IgbmV0d29yayBuYW1lICVzIHdpdGggaWQgJWQgc2VudFxuIiwgX19m
dW5jX18sCisJCQlzd25yZWctPm5ldF9uYW1lLCBzd25yZWctPmlkKTsKKworCXJldHVybiAwOwor
CitubG1zZ19mYWlsOgorCWdlbmxtc2dfY2FuY2VsKHNrYiwgaGRyKTsKKwlubG1zZ19mcmVlKHNr
Yik7CitmYWlsOgorCXJldHVybiByZXQ7Cit9CisKKy8qCisgKiBTZW5kcyBhbiB1cmVnaXN0ZXIg
bWVzc2FnZSB0byB0aGUgdXNlcnNwYWNlIGRhZW1vbiBiYXNlZCBvbiB0aGUgcmVnaXN0cmF0aW9u
CisgKi8KK3N0YXRpYyBpbnQgY2lmc19zd25fc2VuZF91bnJlZ2lzdGVyX21lc3NhZ2Uoc3RydWN0
IGNpZnNfc3duX3JlZyAqc3ducmVnKQoreworCXN0cnVjdCBza19idWZmICpza2I7CisJc3RydWN0
IGdlbmxtc2doZHIgKmhkcjsKKwlpbnQgcmV0OworCisJc2tiID0gZ2VubG1zZ19uZXcoTkxNU0df
REVGQVVMVF9TSVpFLCBHRlBfS0VSTkVMKTsKKwlpZiAoc2tiID09IE5VTEwpCisJCXJldHVybiAt
RU5PTUVNOworCisJaGRyID0gZ2VubG1zZ19wdXQoc2tiLCAwLCAwLCAmY2lmc19nZW5sX2ZhbWls
eSwgMCwgQ0lGU19HRU5MX0NNRF9TV05fVU5SRUdJU1RFUik7CisJaWYgKGhkciA9PSBOVUxMKSB7
CisJCXJldCA9IC1FTk9NRU07CisJCWdvdG8gbmxtc2dfZmFpbDsKKwl9CisKKwlyZXQgPSBubGFf
cHV0X3UzMihza2IsIENJRlNfR0VOTF9BVFRSX1NXTl9SRUdJU1RSQVRJT05fSUQsIHN3bnJlZy0+
aWQpOworCWlmIChyZXQgPCAwKQorCQlnb3RvIG5sbXNnX2ZhaWw7CisKKwlyZXQgPSBubGFfcHV0
X3N0cmluZyhza2IsIENJRlNfR0VOTF9BVFRSX1NXTl9ORVRfTkFNRSwgc3ducmVnLT5uZXRfbmFt
ZSk7CisJaWYgKHJldCA8IDApCisJCWdvdG8gbmxtc2dfZmFpbDsKKworCXJldCA9IG5sYV9wdXRf
c3RyaW5nKHNrYiwgQ0lGU19HRU5MX0FUVFJfU1dOX1NIQVJFX05BTUUsIHN3bnJlZy0+c2hhcmVf
bmFtZSk7CisJaWYgKHJldCA8IDApCisJCWdvdG8gbmxtc2dfZmFpbDsKKworCXJldCA9IG5sYV9w
dXQoc2tiLCBDSUZTX0dFTkxfQVRUUl9TV05fSVAsIHNpemVvZihzdHJ1Y3Qgc29ja2FkZHJfc3Rv
cmFnZSksCisJCQkmc3ducmVnLT50Y29uLT5zZXMtPnNlcnZlci0+ZHN0YWRkcik7CisJaWYgKHJl
dCA8IDApCisJCWdvdG8gbmxtc2dfZmFpbDsKKworCWlmIChzd25yZWctPm5ldF9uYW1lX25vdGlm
eSkgeworCQlyZXQgPSBubGFfcHV0X2ZsYWcoc2tiLCBDSUZTX0dFTkxfQVRUUl9TV05fTkVUX05B
TUVfTk9USUZZKTsKKwkJaWYgKHJldCA8IDApCisJCQlnb3RvIG5sbXNnX2ZhaWw7CisJfQorCisJ
aWYgKHN3bnJlZy0+c2hhcmVfbmFtZV9ub3RpZnkpIHsKKwkJcmV0ID0gbmxhX3B1dF9mbGFnKHNr
YiwgQ0lGU19HRU5MX0FUVFJfU1dOX1NIQVJFX05BTUVfTk9USUZZKTsKKwkJaWYgKHJldCA8IDAp
CisJCQlnb3RvIG5sbXNnX2ZhaWw7CisJfQorCisJaWYgKHN3bnJlZy0+aXBfbm90aWZ5KSB7CisJ
CXJldCA9IG5sYV9wdXRfZmxhZyhza2IsIENJRlNfR0VOTF9BVFRSX1NXTl9JUF9OT1RJRlkpOwor
CQlpZiAocmV0IDwgMCkKKwkJCWdvdG8gbmxtc2dfZmFpbDsKKwl9CisKKwlnZW5sbXNnX2VuZChz
a2IsIGhkcik7CisJZ2VubG1zZ19tdWx0aWNhc3QoJmNpZnNfZ2VubF9mYW1pbHksIHNrYiwgMCwg
Q0lGU19HRU5MX01DR1JQX1NXTiwgR0ZQX0FUT01JQyk7CisKKwljaWZzX2RiZyhGWUksICIlczog
TWVzc2FnZSB0byB1bnJlZ2lzdGVyIGZvciBuZXR3b3JrIG5hbWUgJXMgd2l0aCBpZCAlZCBzZW50
XG4iLCBfX2Z1bmNfXywKKwkJCXN3bnJlZy0+bmV0X25hbWUsIHN3bnJlZy0+aWQpOworCisJcmV0
dXJuIDA7CisKK25sbXNnX2ZhaWw6CisJZ2VubG1zZ19jYW5jZWwoc2tiLCBoZHIpOworCW5sbXNn
X2ZyZWUoc2tiKTsKKwlyZXR1cm4gcmV0OworfQorCisvKgorICogVHJ5IHRvIGZpbmQgYSBtYXRj
aGluZyByZWdpc3RyYXRpb24gZm9yIHRoZSB0Y29uJ3Mgc2VydmVyIG5hbWUgYW5kIHNoYXJlIG5h
bWUuCisgKiBDYWxscyB0byB0aGlzIGZ1bmNpdG9uIG11c3QgYmUgcHJvdGVjdGVkIGJ5IGNpZnNf
c3ducmVnX2lkcl9tdXRleC4KKyAqIFRPRE8gVHJ5IHRvIGF2b2lkIG1lbW9yeSBhbGxvY2F0aW9u
cworICovCitzdGF0aWMgc3RydWN0IGNpZnNfc3duX3JlZyAqY2lmc19maW5kX3N3bl9yZWcoc3Ry
dWN0IGNpZnNfdGNvbiAqdGNvbikKK3sKKwlzdHJ1Y3QgY2lmc19zd25fcmVnICpzd25yZWc7CisJ
aW50IGlkOworCWNvbnN0IGNoYXIgKnNoYXJlX25hbWU7CisJY29uc3QgY2hhciAqbmV0X25hbWU7
CisKKwluZXRfbmFtZSA9IGV4dHJhY3RfaG9zdG5hbWUodGNvbi0+dHJlZU5hbWUpOworCWlmIChJ
U19FUlJfT1JfTlVMTChuZXRfbmFtZSkpIHsKKwkJaW50IHJldDsKKworCQlyZXQgPSBQVFJfRVJS
KG5ldF9uYW1lKTsKKwkJY2lmc19kYmcoVkZTLCAiJXM6IGZhaWxlZCB0byBleHRyYWN0IGhvc3Qg
bmFtZSBmcm9tIHRhcmdldCAnJXMnOiAlZFxuIiwKKwkJCQlfX2Z1bmNfXywgdGNvbi0+dHJlZU5h
bWUsIHJldCk7CisJCXJldHVybiBOVUxMOworCX0KKworCXNoYXJlX25hbWUgPSBleHRyYWN0X3No
YXJlbmFtZSh0Y29uLT50cmVlTmFtZSk7CisJaWYgKElTX0VSUl9PUl9OVUxMKHNoYXJlX25hbWUp
KSB7CisJCWludCByZXQ7CisKKwkJcmV0ID0gUFRSX0VSUihuZXRfbmFtZSk7CisJCWNpZnNfZGJn
KFZGUywgIiVzOiBmYWlsZWQgdG8gZXh0cmFjdCBzaGFyZSBuYW1lIGZyb20gdGFyZ2V0ICclcyc6
ICVkXG4iLAorCQkJCV9fZnVuY19fLCB0Y29uLT50cmVlTmFtZSwgcmV0KTsKKwkJa2ZyZWUobmV0
X25hbWUpOworCQlyZXR1cm4gTlVMTDsKKwl9CisKKwlpZHJfZm9yX2VhY2hfZW50cnkoJmNpZnNf
c3ducmVnX2lkciwgc3ducmVnLCBpZCkgeworCQlpZiAoc3RyY2FzZWNtcChzd25yZWctPm5ldF9u
YW1lLCBuZXRfbmFtZSkgIT0gMAorCQkgICAgfHwgc3RyY2FzZWNtcChzd25yZWctPnNoYXJlX25h
bWUsIHNoYXJlX25hbWUpICE9IDApIHsKKwkJCWNvbnRpbnVlOworCQl9CisKKwkJbXV0ZXhfdW5s
b2NrKCZjaWZzX3N3bnJlZ19pZHJfbXV0ZXgpOworCisJCWNpZnNfZGJnKEZZSSwgIkV4aXN0aW5n
IHN3biByZWdpc3RyYXRpb24gZm9yICVzOiVzIGZvdW5kXG4iLCBzd25yZWctPm5ldF9uYW1lLAor
CQkJCXN3bnJlZy0+c2hhcmVfbmFtZSk7CisKKwkJa2ZyZWUobmV0X25hbWUpOworCQlrZnJlZShz
aGFyZV9uYW1lKTsKKworCQlyZXR1cm4gc3ducmVnOworCX0KKworCWtmcmVlKG5ldF9uYW1lKTsK
KwlrZnJlZShzaGFyZV9uYW1lKTsKKworCXJldHVybiBOVUxMOworfQorCisvKgorICogR2V0IGEg
cmVnaXN0cmF0aW9uIGZvciB0aGUgdGNvbidzIHNlcnZlciBhbmQgc2hhcmUgbmFtZSwgYWxsb2Nh
dGluZyBhIG5ldyBvbmUgaWYgaXQgZG9lcyBub3QKKyAqIGV4aXN0cworICovCitzdGF0aWMgc3Ry
dWN0IGNpZnNfc3duX3JlZyAqY2lmc19nZXRfc3duX3JlZyhzdHJ1Y3QgY2lmc190Y29uICp0Y29u
KQoreworCXN0cnVjdCBjaWZzX3N3bl9yZWcgKnJlZyA9IE5VTEw7CisJaW50IHJldDsKKworCW11
dGV4X2xvY2soJmNpZnNfc3ducmVnX2lkcl9tdXRleCk7CisKKwkvKiBDaGVjayBpZiB3ZSBhcmUg
YWxyZWFkeSByZWdpc3RlcmVkIGZvciB0aGlzIG5ldHdvcmsgYW5kIHNoYXJlIG5hbWVzICovCisJ
cmVnID0gY2lmc19maW5kX3N3bl9yZWcodGNvbik7CisJaWYgKElTX0VSUihyZWcpKSB7CisJCXJl
dHVybiByZWc7CisJfSBlbHNlIGlmIChyZWcgIT0gTlVMTCkgeworCQlrcmVmX2dldCgmcmVnLT5y
ZWZfY291bnQpOworCQltdXRleF91bmxvY2soJmNpZnNfc3ducmVnX2lkcl9tdXRleCk7CisJCXJl
dHVybiByZWc7CisJfQorCisJcmVnID0ga21hbGxvYyhzaXplb2Yoc3RydWN0IGNpZnNfc3duX3Jl
ZyksIEdGUF9BVE9NSUMpOworCWlmIChyZWcgPT0gTlVMTCkgeworCQltdXRleF91bmxvY2soJmNp
ZnNfc3ducmVnX2lkcl9tdXRleCk7CisJCXJldHVybiBFUlJfUFRSKC1FTk9NRU0pOworCX0KKwor
CWtyZWZfaW5pdCgmcmVnLT5yZWZfY291bnQpOworCisJcmVnLT5pZCA9IGlkcl9hbGxvYygmY2lm
c19zd25yZWdfaWRyLCByZWcsIDEsIDAsIEdGUF9BVE9NSUMpOworCWlmIChyZWctPmlkIDwgMCkg
eworCQljaWZzX2RiZyhGWUksICIlczogZmFpbGVkIHRvIGFsbG9jYXRlIHJlZ2lzdHJhdGlvbiBp
ZFxuIiwgX19mdW5jX18pOworCQlyZXQgPSByZWctPmlkOworCQlnb3RvIGZhaWw7CisJfQorCisJ
cmVnLT5uZXRfbmFtZSA9IGV4dHJhY3RfaG9zdG5hbWUodGNvbi0+dHJlZU5hbWUpOworCWlmIChJ
U19FUlIocmVnLT5uZXRfbmFtZSkpIHsKKwkJcmV0ID0gUFRSX0VSUihyZWctPm5ldF9uYW1lKTsK
KwkJY2lmc19kYmcoVkZTLCAiJXM6IGZhaWxlZCB0byBleHRyYWN0IGhvc3QgbmFtZSBmcm9tIHRh
cmdldDogJWRcbiIsIF9fZnVuY19fLCByZXQpOworCQlnb3RvIGZhaWxfaWRyOworCX0KKworCXJl
Zy0+c2hhcmVfbmFtZSA9IGV4dHJhY3Rfc2hhcmVuYW1lKHRjb24tPnRyZWVOYW1lKTsKKwlpZiAo
SVNfRVJSKHJlZy0+c2hhcmVfbmFtZSkpIHsKKwkJcmV0ID0gUFRSX0VSUihyZWctPnNoYXJlX25h
bWUpOworCQljaWZzX2RiZyhWRlMsICIlczogZmFpbGVkIHRvIGV4dHJhY3Qgc2hhcmUgbmFtZSBm
cm9tIHRhcmdldDogJWRcbiIsIF9fZnVuY19fLCByZXQpOworCQlnb3RvIGZhaWxfbmV0X25hbWU7
CisJfQorCisJcmVnLT5uZXRfbmFtZV9ub3RpZnkgPSB0cnVlOworCXJlZy0+c2hhcmVfbmFtZV9u
b3RpZnkgPSB0cnVlOworCXJlZy0+aXBfbm90aWZ5ID0gKHRjb24tPmNhcGFiaWxpdGllcyAmIFNN
QjJfU0hBUkVfQ0FQX1NDQUxFT1VUKTsKKworCXJlZy0+dGNvbiA9IHRjb247CisKKwltdXRleF91
bmxvY2soJmNpZnNfc3ducmVnX2lkcl9tdXRleCk7CisKKwlyZXR1cm4gcmVnOworCitmYWlsX25l
dF9uYW1lOgorCWtmcmVlKHJlZy0+bmV0X25hbWUpOworZmFpbF9pZHI6CisJaWRyX3JlbW92ZSgm
Y2lmc19zd25yZWdfaWRyLCByZWctPmlkKTsKK2ZhaWw6CisJa2ZyZWUocmVnKTsKKwltdXRleF91
bmxvY2soJmNpZnNfc3ducmVnX2lkcl9tdXRleCk7CisJcmV0dXJuIEVSUl9QVFIocmV0KTsKK30K
Kworc3RhdGljIHZvaWQgY2lmc19zd25fcmVnX3JlbGVhc2Uoc3RydWN0IGtyZWYgKnJlZikKK3sK
KwlzdHJ1Y3QgY2lmc19zd25fcmVnICpzd25yZWcgPSBjb250YWluZXJfb2YocmVmLCBzdHJ1Y3Qg
Y2lmc19zd25fcmVnLCByZWZfY291bnQpOworCWludCByZXQ7CisKKwlyZXQgPSBjaWZzX3N3bl9z
ZW5kX3VucmVnaXN0ZXJfbWVzc2FnZShzd25yZWcpOworCWlmIChyZXQgPCAwKQorCQljaWZzX2Ri
ZyhWRlMsICIlczogRmFpbGVkIHRvIHNlbmQgdW5yZWdpc3RlciBtZXNzYWdlOiAlZFxuIiwgX19m
dW5jX18sIHJldCk7CisKKwlpZHJfcmVtb3ZlKCZjaWZzX3N3bnJlZ19pZHIsIHN3bnJlZy0+aWQp
OworCWtmcmVlKHN3bnJlZy0+bmV0X25hbWUpOworCWtmcmVlKHN3bnJlZy0+c2hhcmVfbmFtZSk7
CisJa2ZyZWUoc3ducmVnKTsKK30KKworc3RhdGljIHZvaWQgY2lmc19wdXRfc3duX3JlZyhzdHJ1
Y3QgY2lmc19zd25fcmVnICpzd25yZWcpCit7CisJbXV0ZXhfbG9jaygmY2lmc19zd25yZWdfaWRy
X211dGV4KTsKKwlrcmVmX3B1dCgmc3ducmVnLT5yZWZfY291bnQsIGNpZnNfc3duX3JlZ19yZWxl
YXNlKTsKKwltdXRleF91bmxvY2soJmNpZnNfc3ducmVnX2lkcl9tdXRleCk7Cit9CisKK2ludCBj
aWZzX3N3bl9yZWdpc3RlcihzdHJ1Y3QgY2lmc190Y29uICp0Y29uKQoreworCXN0cnVjdCBjaWZz
X3N3bl9yZWcgKnN3bnJlZzsKKwlpbnQgcmV0OworCisJc3ducmVnID0gY2lmc19nZXRfc3duX3Jl
Zyh0Y29uKTsKKwlpZiAoSVNfRVJSKHN3bnJlZykpCisJCXJldHVybiBQVFJfRVJSKHN3bnJlZyk7
CisKKwlyZXQgPSBjaWZzX3N3bl9zZW5kX3JlZ2lzdGVyX21lc3NhZ2Uoc3ducmVnKTsKKwlpZiAo
cmV0IDwgMCkgeworCQljaWZzX2RiZyhWRlMsICIlczogRmFpbGVkIHRvIHNlbmQgc3duIHJlZ2lz
dGVyIG1lc3NhZ2U6ICVkXG4iLCBfX2Z1bmNfXywgcmV0KTsKKwkJLyogRG8gbm90IHB1dCB0aGUg
c3ducmVnIG9yIHJldHVybiBlcnJvciwgdGhlIGVjaG8gdGFzayB3aWxsIHJldHJ5ICovCisJfQor
CisJcmV0dXJuIDA7Cit9CisKK2ludCBjaWZzX3N3bl91bnJlZ2lzdGVyKHN0cnVjdCBjaWZzX3Rj
b24gKnRjb24pCit7CisJc3RydWN0IGNpZnNfc3duX3JlZyAqc3ducmVnOworCisJbXV0ZXhfbG9j
aygmY2lmc19zd25yZWdfaWRyX211dGV4KTsKKworCXN3bnJlZyA9IGNpZnNfZmluZF9zd25fcmVn
KHRjb24pOworCWlmIChzd25yZWcgPT0gTlVMTCkgeworCQltdXRleF91bmxvY2soJmNpZnNfc3du
cmVnX2lkcl9tdXRleCk7CisJCXJldHVybiAtRUVYSVNUOworCX0KKworCW11dGV4X3VubG9jaygm
Y2lmc19zd25yZWdfaWRyX211dGV4KTsKKworCWNpZnNfcHV0X3N3bl9yZWcoc3ducmVnKTsKKwor
CXJldHVybiAwOworfQpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9jaWZzX3N3bi5oIGIvZnMvY2lmcy9j
aWZzX3N3bi5oCm5ldyBmaWxlIG1vZGUgMTAwNjQ0CmluZGV4IDAwMDAwMDAwMDAwMC4uNjljN2Jk
MTAzNWRhCi0tLSAvZGV2L251bGwKKysrIGIvZnMvY2lmcy9jaWZzX3N3bi5oCkBAIC0wLDAgKzEs
MTcgQEAKKy8qIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wICovCisvKgorICogV2l0
bmVzcyBTZXJ2aWNlIGNsaWVudCBmb3IgQ0lGUworICoKKyAqIENvcHlyaWdodCAoYykgMjAyMCBT
YW11ZWwgQ2FicmVybyA8c2NhYnJlcm9Ac3VzZS5kZT4KKyAqLworCisjaWZuZGVmIF9DSUZTX1NX
Tl9ICisjZGVmaW5lIF9DSUZTX1NXTl9ICisKK3N0cnVjdCBjaWZzX3Rjb247CisKK2V4dGVybiBp
bnQgY2lmc19zd25fcmVnaXN0ZXIoc3RydWN0IGNpZnNfdGNvbiAqdGNvbik7CisKK2V4dGVybiBp
bnQgY2lmc19zd25fdW5yZWdpc3RlcihzdHJ1Y3QgY2lmc190Y29uICp0Y29uKTsKKworI2VuZGlm
IC8qIF9DSUZTX1NXTl9IICovCmRpZmYgLS1naXQgYS9mcy9jaWZzL2Nvbm5lY3QuYyBiL2ZzL2Np
ZnMvY29ubmVjdC5jCmluZGV4IGVhZDFjMDg2Yjg4ZC4uNjhlZjJkYTdjNzRiIDEwMDY0NAotLS0g
YS9mcy9jaWZzL2Nvbm5lY3QuYworKysgYi9mcy9jaWZzL2Nvbm5lY3QuYwpAQCAtNjIsNiArNjIs
OSBAQAogI2luY2x1ZGUgImRmc19jYWNoZS5oIgogI2VuZGlmCiAjaW5jbHVkZSAiZnNfY29udGV4
dC5oIgorI2lmZGVmIENPTkZJR19DSUZTX1NXTl9VUENBTEwKKyNpbmNsdWRlICJjaWZzX3N3bi5o
IgorI2VuZGlmCiAKIGV4dGVybiBtZW1wb29sX3QgKmNpZnNfcmVxX3Bvb2xwOwogZXh0ZXJuIGJv
b2wgZGlzYWJsZV9sZWdhY3lfZGlhbGVjdHM7CkBAIC0xOTQ0LDcgKzE5NDcsMTcgQEAgY2lmc19w
dXRfdGNvbihzdHJ1Y3QgY2lmc190Y29uICp0Y29uKQogCQlyZXR1cm47CiAJfQogCi0JLyogVE9E
TyB3aXRuZXNzIHVucmVnaXN0ZXIgKi8KKyNpZmRlZiBDT05GSUdfQ0lGU19TV05fVVBDQUxMCisJ
aWYgKHRjb24tPnVzZV93aXRuZXNzKSB7CisJCWludCByYzsKKworCQlyYyA9IGNpZnNfc3duX3Vu
cmVnaXN0ZXIodGNvbik7CisJCWlmIChyYyA8IDApIHsKKwkJCWNpZnNfZGJnKFZGUywgIiVzOiBG
YWlsZWQgdG8gdW5yZWdpc3RlciBmb3Igd2l0bmVzcyBub3RpZmljYXRpb25zOiAlZFxuIiwKKwkJ
CQkJX19mdW5jX18sIHJjKTsKKwkJfQorCX0KKyNlbmRpZgogCiAJbGlzdF9kZWxfaW5pdCgmdGNv
bi0+dGNvbl9saXN0KTsKIAlzcGluX3VubG9jaygmY2lmc190Y3Bfc2VzX2xvY2spOwpAQCAtMjEx
MSw4ICsyMTI0LDE3IEBAIGNpZnNfZ2V0X3Rjb24oc3RydWN0IGNpZnNfc2VzICpzZXMsIHN0cnVj
dCBzbWIzX2ZzX2NvbnRleHQgKmN0eCkKIAlpZiAoY3R4LT53aXRuZXNzKSB7CiAJCWlmIChzZXMt
PnNlcnZlci0+dmFscy0+cHJvdG9jb2xfaWQgPj0gU01CMzBfUFJPVF9JRCkgewogCQkJaWYgKHRj
b24tPmNhcGFiaWxpdGllcyAmIFNNQjJfU0hBUkVfQ0FQX0NMVVNURVIpIHsKLQkJCQkvKiBUT0RP
IHdpdG5lc3MgcmVnaXN0ZXIgKi8KKwkJCQkvKgorCQkJCSAqIFNldCB3aXRuZXNzIGluIHVzZSBm
bGFnIGluIGZpcnN0IHBsYWNlCisJCQkJICogdG8gcmV0cnkgcmVnaXN0cmF0aW9uIGluIHRoZSBl
Y2hvIHRhc2sKKwkJCQkgKi8KIAkJCQl0Y29uLT51c2Vfd2l0bmVzcyA9IHRydWU7CisJCQkJLyog
QW5kIHRyeSB0byByZWdpc3RlciBpbW1lZGlhdGVseSAqLworCQkJCXJjID0gY2lmc19zd25fcmVn
aXN0ZXIodGNvbik7CisJCQkJaWYgKHJjIDwgMCkgeworCQkJCQljaWZzX2RiZyhWRlMsICJGYWls
ZWQgdG8gcmVnaXN0ZXIgZm9yIHdpdG5lc3Mgbm90aWZpY2F0aW9uczogJWRcbiIsIHJjKTsKKwkJ
CQkJZ290byBvdXRfZmFpbDsKKwkJCQl9CiAJCQl9IGVsc2UgewogCQkJCS8qIFRPRE86IHRyeSB0
byBleHRlbmQgZm9yIG5vbi1jbHVzdGVyIHVzZXMgKGVnIG11bHRpY2hhbm5lbCkgKi8KIAkJCQlj
aWZzX2RiZyhWRlMsICJ3aXRuZXNzIHJlcXVlc3RlZCBvbiBtb3VudCBidXQgbm8gQ0xVU1RFUiBj
YXBhYmlsaXR5IG9uIHNoYXJlXG4iKTsKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvbmV0bGluay5jIGIv
ZnMvY2lmcy9uZXRsaW5rLmMKaW5kZXggYjkxNTQ2NjFmYTg1Li44MzAwOGE1NmRlZjUgMTAwNjQ0
Ci0tLSBhL2ZzL2NpZnMvbmV0bGluay5jCisrKyBiL2ZzL2NpZnMvbmV0bGluay5jCkBAIC0xMyw2
ICsxMywxNyBAQAogI2luY2x1ZGUgImNpZnNfZGVidWcuaCIKIAogc3RhdGljIGNvbnN0IHN0cnVj
dCBubGFfcG9saWN5IGNpZnNfZ2VubF9wb2xpY3lbQ0lGU19HRU5MX0FUVFJfTUFYICsgMV0gPSB7
CisJW0NJRlNfR0VOTF9BVFRSX1NXTl9SRUdJU1RSQVRJT05fSURdCT0geyAudHlwZSA9IE5MQV9V
MzIgfSwKKwlbQ0lGU19HRU5MX0FUVFJfU1dOX05FVF9OQU1FXQkJPSB7IC50eXBlID0gTkxBX1NU
UklORyB9LAorCVtDSUZTX0dFTkxfQVRUUl9TV05fU0hBUkVfTkFNRV0JCT0geyAudHlwZSA9IE5M
QV9TVFJJTkcgfSwKKwlbQ0lGU19HRU5MX0FUVFJfU1dOX0lQXQkJCT0geyAubGVuID0gc2l6ZW9m
KHN0cnVjdCBzb2NrYWRkcl9zdG9yYWdlKSB9LAorCVtDSUZTX0dFTkxfQVRUUl9TV05fTkVUX05B
TUVfTk9USUZZXQk9IHsgLnR5cGUgPSBOTEFfRkxBRyB9LAorCVtDSUZTX0dFTkxfQVRUUl9TV05f
U0hBUkVfTkFNRV9OT1RJRlldCT0geyAudHlwZSA9IE5MQV9GTEFHIH0sCisJW0NJRlNfR0VOTF9B
VFRSX1NXTl9JUF9OT1RJRlldCQk9IHsgLnR5cGUgPSBOTEFfRkxBRyB9LAorCVtDSUZTX0dFTkxf
QVRUUl9TV05fS1JCX0FVVEhdCQk9IHsgLnR5cGUgPSBOTEFfRkxBRyB9LAorCVtDSUZTX0dFTkxf
QVRUUl9TV05fVVNFUl9OQU1FXQkJPSB7IC50eXBlID0gTkxBX1NUUklORyB9LAorCVtDSUZTX0dF
TkxfQVRUUl9TV05fUEFTU1dPUkRdCQk9IHsgLnR5cGUgPSBOTEFfU1RSSU5HIH0sCisJW0NJRlNf
R0VOTF9BVFRSX1NXTl9ET01BSU5fTkFNRV0JPSB7IC50eXBlID0gTkxBX1NUUklORyB9LAogfTsK
IAogc3RhdGljIHN0cnVjdCBnZW5sX29wcyBjaWZzX2dlbmxfb3BzW10gPSB7CmRpZmYgLS1naXQg
YS9pbmNsdWRlL3VhcGkvbGludXgvY2lmcy9jaWZzX25ldGxpbmsuaCBiL2luY2x1ZGUvdWFwaS9s
aW51eC9jaWZzL2NpZnNfbmV0bGluay5oCmluZGV4IGNkYjFiZDc4ZmJjNy4uNTY2MmUyNzc0NTEz
IDEwMDY0NAotLS0gYS9pbmNsdWRlL3VhcGkvbGludXgvY2lmcy9jaWZzX25ldGxpbmsuaAorKysg
Yi9pbmNsdWRlL3VhcGkvbGludXgvY2lmcy9jaWZzX25ldGxpbmsuaApAQCAtMTksMTEgKzE5LDI2
IEBAIGVudW0gY2lmc19nZW5sX211bHRpY2FzdF9ncm91cHMgewogfTsKIAogZW51bSBjaWZzX2dl
bmxfYXR0cmlidXRlcyB7CisJQ0lGU19HRU5MX0FUVFJfVU5TUEVDLAorCUNJRlNfR0VOTF9BVFRS
X1NXTl9SRUdJU1RSQVRJT05fSUQsCisJQ0lGU19HRU5MX0FUVFJfU1dOX05FVF9OQU1FLAorCUNJ
RlNfR0VOTF9BVFRSX1NXTl9TSEFSRV9OQU1FLAorCUNJRlNfR0VOTF9BVFRSX1NXTl9JUCwKKwlD
SUZTX0dFTkxfQVRUUl9TV05fTkVUX05BTUVfTk9USUZZLAorCUNJRlNfR0VOTF9BVFRSX1NXTl9T
SEFSRV9OQU1FX05PVElGWSwKKwlDSUZTX0dFTkxfQVRUUl9TV05fSVBfTk9USUZZLAorCUNJRlNf
R0VOTF9BVFRSX1NXTl9LUkJfQVVUSCwKKwlDSUZTX0dFTkxfQVRUUl9TV05fVVNFUl9OQU1FLAor
CUNJRlNfR0VOTF9BVFRSX1NXTl9QQVNTV09SRCwKKwlDSUZTX0dFTkxfQVRUUl9TV05fRE9NQUlO
X05BTUUsCiAJX19DSUZTX0dFTkxfQVRUUl9NQVgsCiB9OwogI2RlZmluZSBDSUZTX0dFTkxfQVRU
Ul9NQVggKF9fQ0lGU19HRU5MX0FUVFJfTUFYIC0gMSkKIAogZW51bSBjaWZzX2dlbmxfY29tbWFu
ZHMgeworCUNJRlNfR0VOTF9DTURfVU5TUEVDLAorCUNJRlNfR0VOTF9DTURfU1dOX1JFR0lTVEVS
LAorCUNJRlNfR0VOTF9DTURfU1dOX1VOUkVHSVNURVIsCiAJX19DSUZTX0dFTkxfQ01EX01BWAog
fTsKICNkZWZpbmUgQ0lGU19HRU5MX0NNRF9NQVggKF9fQ0lGU19HRU5MX0NNRF9NQVggLSAxKQot
LSAKMi4yNy4wCgo=
--000000000000ba803a05b63e040d--
