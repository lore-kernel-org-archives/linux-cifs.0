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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05AECC4361B
	for <linux-cifs@archiver.kernel.org>; Sat, 12 Dec 2020 05:53:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDB212313B
	for <linux-cifs@archiver.kernel.org>; Sat, 12 Dec 2020 05:53:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728500AbgLLFwS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 12 Dec 2020 00:52:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727097AbgLLFwB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 12 Dec 2020 00:52:01 -0500
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA1B2C0613D3
        for <linux-cifs@vger.kernel.org>; Fri, 11 Dec 2020 21:51:20 -0800 (PST)
Received: by mail-lf1-x141.google.com with SMTP id 23so16920920lfg.10
        for <linux-cifs@vger.kernel.org>; Fri, 11 Dec 2020 21:51:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xiVbAc9OQamHJFtChm/oCMTr/tKNbgbOcSCIa9tZdt0=;
        b=JhPjlAxOjnGKxWN/QJh//zq+LxQBk0aXEdFkzgPkcXeFM8PCFGITOPo2AL7B2Cls0u
         hU9g5lcJ1ZX3IxR9RUy8oIcRxG+iUSU9rqtLputuoqk86bRrPhYxsxabuE555tfYEMP9
         FT8IeZH0qoLK0Fu8qRoZSc68ntGvhpkGtOgQ5ELhAa9xVZd4hUum7B3mUNUajAWNfC7h
         6lB5xm+RMXg83mfobNUF5D/N40RwbOFYEwhsX+PkqQNOnDTZctXLXk/SiYwiiWahhAUt
         Y0XbzLTWiM/uu2M5cmGPcbvrCFfZrVxI5drIOpT6mjQ26wu9AWXc2luJdvhRtad7TCaa
         E2GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xiVbAc9OQamHJFtChm/oCMTr/tKNbgbOcSCIa9tZdt0=;
        b=gDIhZYCGW7kNrFH7nO8IackdESsP43bAgxqiUvP/oeZ/TxQ+Uuz47plaEMmm9ilKP0
         OwcnC8RPMJowSM5PXMCUBSOoIvZZ/xlY+bWa4+PLagjyFbpF5dZgWBwIDInHtXp17Tdp
         uQLpcN6q2Vapo4emgwoWqH/+GQ0Zubd5p/xulzLbcz+CdbKo+Q37FQ+0FymrG9METdhS
         89OGgWQ4AI4hlFRFTa3EnV8M+MqAYhOW5Qukrdngpc7wSUepyFupv4xHYCFPPclisIRr
         gvjQNmEgUyAU1Z3abcOgL9+B2qYUnPS067Nh97qH2jbyySEMaaAvsgvqiLN/3CGV9xER
         Qzhw==
X-Gm-Message-State: AOAM532qXCrDdSrqz4OZkuiXTvAUb/+Prr49/nDUoluk/uzJh+E+LQzi
        LUTbFIk6I2+93YDkWF9GBf0zG6aNhkqvWqoDRbGkSy+ve3uwOw==
X-Google-Smtp-Source: ABdhPJyQ6VohovA0V0OTQzsMgEMkG/23DpCwG3UhMTwPGi1AJPgAO8p62Vt7B3PBDTOqtR44lvj4UsHJ0Dx0zpN9MxQ=
X-Received: by 2002:a19:6f01:: with SMTP id k1mr5470281lfc.184.1607752279253;
 Fri, 11 Dec 2020 21:51:19 -0800 (PST)
MIME-Version: 1.0
References: <20201130180257.31787-1-scabrero@suse.de> <20201130180257.31787-4-scabrero@suse.de>
In-Reply-To: <20201130180257.31787-4-scabrero@suse.de>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 11 Dec 2020 23:51:08 -0600
Message-ID: <CAH2r5mvs+3VX+nZhuqUi3FVjwdd7b9rVk0q89q6eW_ZA3fEFyw@mail.gmail.com>
Subject: Re: [PATCH v4 03/11] cifs: Register generic netlink family
To:     Samuel Cabrero <scabrero@suse.de>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000007e046905b63dffa1"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000007e046905b63dffa1
Content-Type: text/plain; charset="UTF-8"

updated version of the patch attached (rebased on current for-next).
Tentatively merged into cifs-2.6.git for-next

On Mon, Nov 30, 2020 at 12:05 PM Samuel Cabrero <scabrero@suse.de> wrote:
>
> Register a new generic netlink family to talk to the witness service
> userspace daemon.
>
> Signed-off-by: Samuel Cabrero <scabrero@suse.de>
> ---
>  fs/cifs/Kconfig                        | 11 ++++
>  fs/cifs/Makefile                       |  2 +
>  fs/cifs/cifsfs.c                       | 17 ++++++-
>  fs/cifs/netlink.c                      | 69 ++++++++++++++++++++++++++
>  fs/cifs/netlink.h                      | 16 ++++++
>  include/uapi/linux/cifs/cifs_netlink.h | 31 ++++++++++++
>  6 files changed, 145 insertions(+), 1 deletion(-)
>  create mode 100644 fs/cifs/netlink.c
>  create mode 100644 fs/cifs/netlink.h
>  create mode 100644 include/uapi/linux/cifs/cifs_netlink.h
>
> diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
> index 604f65f4b6c5..664ac5c63d39 100644
> --- a/fs/cifs/Kconfig
> +++ b/fs/cifs/Kconfig
> @@ -190,6 +190,17 @@ config CIFS_DFS_UPCALL
>           servers if their addresses change or for implicit mounts of
>           DFS junction points. If unsure, say Y.
>
> +config CIFS_SWN_UPCALL
> +       bool "SWN feature support"
> +       depends on CIFS
> +       help
> +         The Service Witness Protocol (SWN) is used to get notifications
> +         from a highly available server of resource state changes. This
> +         feature enables an upcall mechanism for CIFS which contacts an
> +         userspace daemon to establish the DCE/RPC connection to retrieve
> +         the cluster available interfaces and resource change notifications.
> +         If unsure, say Y.
> +
>  config CIFS_NFSD_EXPORT
>         bool "Allow nfsd to export CIFS file system"
>         depends on CIFS && BROKEN
> diff --git a/fs/cifs/Makefile b/fs/cifs/Makefile
> index cd17d0e50f2a..b88fd46ac597 100644
> --- a/fs/cifs/Makefile
> +++ b/fs/cifs/Makefile
> @@ -18,6 +18,8 @@ cifs-$(CONFIG_CIFS_UPCALL) += cifs_spnego.o
>
>  cifs-$(CONFIG_CIFS_DFS_UPCALL) += dns_resolve.o cifs_dfs_ref.o dfs_cache.o
>
> +cifs-$(CONFIG_CIFS_SWN_UPCALL) += netlink.o
> +
>  cifs-$(CONFIG_CIFS_FSCACHE) += fscache.o cache.o
>
>  cifs-$(CONFIG_CIFS_SMB_DIRECT) += smbdirect.o
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 472cb7777e3e..8111d0109a2e 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -55,6 +55,9 @@
>  #ifdef CONFIG_CIFS_DFS_UPCALL
>  #include "dfs_cache.h"
>  #endif
> +#ifdef CONFIG_CIFS_SWN_UPCALL
> +#include "netlink.h"
> +#endif
>
>  /*
>   * DOS dates from 1980/1/1 through 2107/12/31
> @@ -1617,10 +1620,15 @@ init_cifs(void)
>         if (rc)
>                 goto out_destroy_dfs_cache;
>  #endif /* CONFIG_CIFS_UPCALL */
> +#ifdef CONFIG_CIFS_SWN_UPCALL
> +       rc = cifs_genl_init();
> +       if (rc)
> +               goto out_register_key_type;
> +#endif /* CONFIG_CIFS_SWN_UPCALL */
>
>         rc = init_cifs_idmap();
>         if (rc)
> -               goto out_register_key_type;
> +               goto out_cifs_swn_init;
>
>         rc = register_filesystem(&cifs_fs_type);
>         if (rc)
> @@ -1636,7 +1644,11 @@ init_cifs(void)
>
>  out_init_cifs_idmap:
>         exit_cifs_idmap();
> +out_cifs_swn_init:
> +#ifdef CONFIG_CIFS_SWN_UPCALL
> +       cifs_genl_exit();
>  out_register_key_type:
> +#endif
>  #ifdef CONFIG_CIFS_UPCALL
>         exit_cifs_spnego();
>  out_destroy_dfs_cache:
> @@ -1673,6 +1685,9 @@ exit_cifs(void)
>         unregister_filesystem(&smb3_fs_type);
>         cifs_dfs_release_automount_timer();
>         exit_cifs_idmap();
> +#ifdef CONFIG_CIFS_SWN_UPCALL
> +       cifs_genl_exit();
> +#endif
>  #ifdef CONFIG_CIFS_UPCALL
>         exit_cifs_spnego();
>  #endif
> diff --git a/fs/cifs/netlink.c b/fs/cifs/netlink.c
> new file mode 100644
> index 000000000000..b9154661fa85
> --- /dev/null
> +++ b/fs/cifs/netlink.c
> @@ -0,0 +1,69 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Netlink routines for CIFS
> + *
> + * Copyright (c) 2020 Samuel Cabrero <scabrero@suse.de>
> + */
> +
> +#include <net/genetlink.h>
> +#include <uapi/linux/cifs/cifs_netlink.h>
> +
> +#include "netlink.h"
> +#include "cifsglob.h"
> +#include "cifs_debug.h"
> +
> +static const struct nla_policy cifs_genl_policy[CIFS_GENL_ATTR_MAX + 1] = {
> +};
> +
> +static struct genl_ops cifs_genl_ops[] = {
> +};
> +
> +static const struct genl_multicast_group cifs_genl_mcgrps[] = {
> +       [CIFS_GENL_MCGRP_SWN] = { .name = CIFS_GENL_MCGRP_SWN_NAME },
> +};
> +
> +struct genl_family cifs_genl_family = {
> +       .name           = CIFS_GENL_NAME,
> +       .version        = CIFS_GENL_VERSION,
> +       .hdrsize        = 0,
> +       .maxattr        = CIFS_GENL_ATTR_MAX,
> +       .module         = THIS_MODULE,
> +       .policy         = cifs_genl_policy,
> +       .ops            = cifs_genl_ops,
> +       .n_ops          = ARRAY_SIZE(cifs_genl_ops),
> +       .mcgrps         = cifs_genl_mcgrps,
> +       .n_mcgrps       = ARRAY_SIZE(cifs_genl_mcgrps),
> +};
> +
> +/**
> + * cifs_genl_init - Register generic netlink family
> + *
> + * Return zero if initialized successfully, otherwise non-zero.
> + */
> +int cifs_genl_init(void)
> +{
> +       int ret;
> +
> +       ret = genl_register_family(&cifs_genl_family);
> +       if (ret < 0) {
> +               cifs_dbg(VFS, "%s: failed to register netlink family\n",
> +                               __func__);
> +               return ret;
> +       }
> +
> +       return 0;
> +}
> +
> +/**
> + * cifs_genl_exit - Unregister generic netlink family
> + */
> +void cifs_genl_exit(void)
> +{
> +       int ret;
> +
> +       ret = genl_unregister_family(&cifs_genl_family);
> +       if (ret < 0) {
> +               cifs_dbg(VFS, "%s: failed to unregister netlink family\n",
> +                               __func__);
> +       }
> +}
> diff --git a/fs/cifs/netlink.h b/fs/cifs/netlink.h
> new file mode 100644
> index 000000000000..e2fa8ed24c54
> --- /dev/null
> +++ b/fs/cifs/netlink.h
> @@ -0,0 +1,16 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Netlink routines for CIFS
> + *
> + * Copyright (c) 2020 Samuel Cabrero <scabrero@suse.de>
> + */
> +
> +#ifndef _CIFS_NETLINK_H
> +#define _CIFS_NETLINK_H
> +
> +extern struct genl_family cifs_genl_family;
> +
> +extern int cifs_genl_init(void);
> +extern void cifs_genl_exit(void);
> +
> +#endif /* _CIFS_NETLINK_H */
> diff --git a/include/uapi/linux/cifs/cifs_netlink.h b/include/uapi/linux/cifs/cifs_netlink.h
> new file mode 100644
> index 000000000000..cdb1bd78fbc7
> --- /dev/null
> +++ b/include/uapi/linux/cifs/cifs_netlink.h
> @@ -0,0 +1,31 @@
> +/* SPDX-License-Identifier: LGPL-2.1+ WITH Linux-syscall-note */
> +/*
> + * Netlink routines for CIFS
> + *
> + * Copyright (c) 2020 Samuel Cabrero <scabrero@suse.de>
> + */
> +
> +
> +#ifndef _UAPILINUX_CIFS_NETLINK_H
> +#define _UAPILINUX_CIFS_NETLINK_H
> +
> +#define CIFS_GENL_NAME                 "cifs"
> +#define CIFS_GENL_VERSION              0x1
> +
> +#define CIFS_GENL_MCGRP_SWN_NAME       "cifs_mcgrp_swn"
> +
> +enum cifs_genl_multicast_groups {
> +       CIFS_GENL_MCGRP_SWN,
> +};
> +
> +enum cifs_genl_attributes {
> +       __CIFS_GENL_ATTR_MAX,
> +};
> +#define CIFS_GENL_ATTR_MAX (__CIFS_GENL_ATTR_MAX - 1)
> +
> +enum cifs_genl_commands {
> +       __CIFS_GENL_CMD_MAX
> +};
> +#define CIFS_GENL_CMD_MAX (__CIFS_GENL_CMD_MAX - 1)
> +
> +#endif /* _UAPILINUX_CIFS_NETLINK_H */
> --
> 2.29.2
>


-- 
Thanks,

Steve

--0000000000007e046905b63dffa1
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0005-cifs-Register-generic-netlink-family.patch"
Content-Disposition: attachment; 
	filename="0005-cifs-Register-generic-netlink-family.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kila6nbj0>
X-Attachment-Id: f_kila6nbj0

RnJvbSBjZjZhNmMwODQxYmMxMjVhOWVkZTUwMDAwYzIyZjAxMTBlZWE4MDViIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTYW11ZWwgQ2FicmVybyA8c2NhYnJlcm9Ac3VzZS5kZT4KRGF0
ZTogTW9uLCAzMCBOb3YgMjAyMCAxOTowMjo0OSArMDEwMApTdWJqZWN0OiBbUEFUQ0ggNS84XSBj
aWZzOiBSZWdpc3RlciBnZW5lcmljIG5ldGxpbmsgZmFtaWx5CgpSZWdpc3RlciBhIG5ldyBnZW5l
cmljIG5ldGxpbmsgZmFtaWx5IHRvIHRhbGsgdG8gdGhlIHdpdG5lc3Mgc2VydmljZQp1c2Vyc3Bh
Y2UgZGFlbW9uLgoKU2lnbmVkLW9mZi1ieTogU2FtdWVsIENhYnJlcm8gPHNjYWJyZXJvQHN1c2Uu
ZGU+Ci0tLQogZnMvY2lmcy9LY29uZmlnICAgICAgICAgICAgICAgICAgICAgICAgfCAxMSArKysr
CiBmcy9jaWZzL01ha2VmaWxlICAgICAgICAgICAgICAgICAgICAgICB8ICAyICsKIGZzL2NpZnMv
Y2lmc2ZzLmMgICAgICAgICAgICAgICAgICAgICAgIHwgMTcgKysrKysrLQogZnMvY2lmcy9uZXRs
aW5rLmMgICAgICAgICAgICAgICAgICAgICAgfCA2OSArKysrKysrKysrKysrKysrKysrKysrKysr
KwogZnMvY2lmcy9uZXRsaW5rLmggICAgICAgICAgICAgICAgICAgICAgfCAxNiArKysrKysKIGlu
Y2x1ZGUvdWFwaS9saW51eC9jaWZzL2NpZnNfbmV0bGluay5oIHwgMzEgKysrKysrKysrKysrCiA2
IGZpbGVzIGNoYW5nZWQsIDE0NSBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCiBjcmVhdGUg
bW9kZSAxMDA2NDQgZnMvY2lmcy9uZXRsaW5rLmMKIGNyZWF0ZSBtb2RlIDEwMDY0NCBmcy9jaWZz
L25ldGxpbmsuaAogY3JlYXRlIG1vZGUgMTAwNjQ0IGluY2x1ZGUvdWFwaS9saW51eC9jaWZzL2Np
ZnNfbmV0bGluay5oCgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9LY29uZmlnIGIvZnMvY2lmcy9LY29u
ZmlnCmluZGV4IDYwNGY2NWY0YjZjNS4uNjY0YWM1YzYzZDM5IDEwMDY0NAotLS0gYS9mcy9jaWZz
L0tjb25maWcKKysrIGIvZnMvY2lmcy9LY29uZmlnCkBAIC0xOTAsNiArMTkwLDE3IEBAIGNvbmZp
ZyBDSUZTX0RGU19VUENBTEwKIAkgIHNlcnZlcnMgaWYgdGhlaXIgYWRkcmVzc2VzIGNoYW5nZSBv
ciBmb3IgaW1wbGljaXQgbW91bnRzIG9mCiAJICBERlMganVuY3Rpb24gcG9pbnRzLiBJZiB1bnN1
cmUsIHNheSBZLgogCitjb25maWcgQ0lGU19TV05fVVBDQUxMCisJYm9vbCAiU1dOIGZlYXR1cmUg
c3VwcG9ydCIKKwlkZXBlbmRzIG9uIENJRlMKKwloZWxwCisJICBUaGUgU2VydmljZSBXaXRuZXNz
IFByb3RvY29sIChTV04pIGlzIHVzZWQgdG8gZ2V0IG5vdGlmaWNhdGlvbnMKKwkgIGZyb20gYSBo
aWdobHkgYXZhaWxhYmxlIHNlcnZlciBvZiByZXNvdXJjZSBzdGF0ZSBjaGFuZ2VzLiBUaGlzCisJ
ICBmZWF0dXJlIGVuYWJsZXMgYW4gdXBjYWxsIG1lY2hhbmlzbSBmb3IgQ0lGUyB3aGljaCBjb250
YWN0cyBhbgorCSAgdXNlcnNwYWNlIGRhZW1vbiB0byBlc3RhYmxpc2ggdGhlIERDRS9SUEMgY29u
bmVjdGlvbiB0byByZXRyaWV2ZQorCSAgdGhlIGNsdXN0ZXIgYXZhaWxhYmxlIGludGVyZmFjZXMg
YW5kIHJlc291cmNlIGNoYW5nZSBub3RpZmljYXRpb25zLgorCSAgSWYgdW5zdXJlLCBzYXkgWS4K
KwogY29uZmlnIENJRlNfTkZTRF9FWFBPUlQKIAlib29sICJBbGxvdyBuZnNkIHRvIGV4cG9ydCBD
SUZTIGZpbGUgc3lzdGVtIgogCWRlcGVuZHMgb24gQ0lGUyAmJiBCUk9LRU4KZGlmZiAtLWdpdCBh
L2ZzL2NpZnMvTWFrZWZpbGUgYi9mcy9jaWZzL01ha2VmaWxlCmluZGV4IDg0OGViYWQ2YWY3ZC4u
OWUzOThkMjI3YjBlIDEwMDY0NAotLS0gYS9mcy9jaWZzL01ha2VmaWxlCisrKyBiL2ZzL2NpZnMv
TWFrZWZpbGUKQEAgLTE4LDYgKzE4LDggQEAgY2lmcy0kKENPTkZJR19DSUZTX1VQQ0FMTCkgKz0g
Y2lmc19zcG5lZ28ubwogCiBjaWZzLSQoQ09ORklHX0NJRlNfREZTX1VQQ0FMTCkgKz0gZG5zX3Jl
c29sdmUubyBjaWZzX2Rmc19yZWYubyBkZnNfY2FjaGUubwogCitjaWZzLSQoQ09ORklHX0NJRlNf
U1dOX1VQQ0FMTCkgKz0gbmV0bGluay5vCisKIGNpZnMtJChDT05GSUdfQ0lGU19GU0NBQ0hFKSAr
PSBmc2NhY2hlLm8gY2FjaGUubwogCiBjaWZzLSQoQ09ORklHX0NJRlNfU01CX0RJUkVDVCkgKz0g
c21iZGlyZWN0Lm8KZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY2lmc2ZzLmMgYi9mcy9jaWZzL2NpZnNm
cy5jCmluZGV4IDRmMjdmNzdkMzA1My4uNWQzMjU2MWFlMmVkIDEwMDY0NAotLS0gYS9mcy9jaWZz
L2NpZnNmcy5jCisrKyBiL2ZzL2NpZnMvY2lmc2ZzLmMKQEAgLTU1LDYgKzU1LDkgQEAKICNpZmRl
ZiBDT05GSUdfQ0lGU19ERlNfVVBDQUxMCiAjaW5jbHVkZSAiZGZzX2NhY2hlLmgiCiAjZW5kaWYK
KyNpZmRlZiBDT05GSUdfQ0lGU19TV05fVVBDQUxMCisjaW5jbHVkZSAibmV0bGluay5oIgorI2Vu
ZGlmCiAjaW5jbHVkZSAiZnNfY29udGV4dC5oIgogCiAvKgpAQCAtMTYwMSwxMCArMTYwNCwxNSBA
QCBpbml0X2NpZnModm9pZCkKIAlpZiAocmMpCiAJCWdvdG8gb3V0X2Rlc3Ryb3lfZGZzX2NhY2hl
OwogI2VuZGlmIC8qIENPTkZJR19DSUZTX1VQQ0FMTCAqLworI2lmZGVmIENPTkZJR19DSUZTX1NX
Tl9VUENBTEwKKwlyYyA9IGNpZnNfZ2VubF9pbml0KCk7CisJaWYgKHJjKQorCQlnb3RvIG91dF9y
ZWdpc3Rlcl9rZXlfdHlwZTsKKyNlbmRpZiAvKiBDT05GSUdfQ0lGU19TV05fVVBDQUxMICovCiAK
IAlyYyA9IGluaXRfY2lmc19pZG1hcCgpOwogCWlmIChyYykKLQkJZ290byBvdXRfcmVnaXN0ZXJf
a2V5X3R5cGU7CisJCWdvdG8gb3V0X2NpZnNfc3duX2luaXQ7CiAKIAlyYyA9IHJlZ2lzdGVyX2Zp
bGVzeXN0ZW0oJmNpZnNfZnNfdHlwZSk7CiAJaWYgKHJjKQpAQCAtMTYyMCw3ICsxNjI4LDExIEBA
IGluaXRfY2lmcyh2b2lkKQogCiBvdXRfaW5pdF9jaWZzX2lkbWFwOgogCWV4aXRfY2lmc19pZG1h
cCgpOworb3V0X2NpZnNfc3duX2luaXQ6CisjaWZkZWYgQ09ORklHX0NJRlNfU1dOX1VQQ0FMTAor
CWNpZnNfZ2VubF9leGl0KCk7CiBvdXRfcmVnaXN0ZXJfa2V5X3R5cGU6CisjZW5kaWYKICNpZmRl
ZiBDT05GSUdfQ0lGU19VUENBTEwKIAlleGl0X2NpZnNfc3BuZWdvKCk7CiBvdXRfZGVzdHJveV9k
ZnNfY2FjaGU6CkBAIC0xNjU3LDYgKzE2NjksOSBAQCBleGl0X2NpZnModm9pZCkKIAl1bnJlZ2lz
dGVyX2ZpbGVzeXN0ZW0oJnNtYjNfZnNfdHlwZSk7CiAJY2lmc19kZnNfcmVsZWFzZV9hdXRvbW91
bnRfdGltZXIoKTsKIAlleGl0X2NpZnNfaWRtYXAoKTsKKyNpZmRlZiBDT05GSUdfQ0lGU19TV05f
VVBDQUxMCisJY2lmc19nZW5sX2V4aXQoKTsKKyNlbmRpZgogI2lmZGVmIENPTkZJR19DSUZTX1VQ
Q0FMTAogCWV4aXRfY2lmc19zcG5lZ28oKTsKICNlbmRpZgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9u
ZXRsaW5rLmMgYi9mcy9jaWZzL25ldGxpbmsuYwpuZXcgZmlsZSBtb2RlIDEwMDY0NAppbmRleCAw
MDAwMDAwMDAwMDAuLmI5MTU0NjYxZmE4NQotLS0gL2Rldi9udWxsCisrKyBiL2ZzL2NpZnMvbmV0
bGluay5jCkBAIC0wLDAgKzEsNjkgQEAKKy8vIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwt
Mi4wCisvKgorICogTmV0bGluayByb3V0aW5lcyBmb3IgQ0lGUworICoKKyAqIENvcHlyaWdodCAo
YykgMjAyMCBTYW11ZWwgQ2FicmVybyA8c2NhYnJlcm9Ac3VzZS5kZT4KKyAqLworCisjaW5jbHVk
ZSA8bmV0L2dlbmV0bGluay5oPgorI2luY2x1ZGUgPHVhcGkvbGludXgvY2lmcy9jaWZzX25ldGxp
bmsuaD4KKworI2luY2x1ZGUgIm5ldGxpbmsuaCIKKyNpbmNsdWRlICJjaWZzZ2xvYi5oIgorI2lu
Y2x1ZGUgImNpZnNfZGVidWcuaCIKKworc3RhdGljIGNvbnN0IHN0cnVjdCBubGFfcG9saWN5IGNp
ZnNfZ2VubF9wb2xpY3lbQ0lGU19HRU5MX0FUVFJfTUFYICsgMV0gPSB7Cit9OworCitzdGF0aWMg
c3RydWN0IGdlbmxfb3BzIGNpZnNfZ2VubF9vcHNbXSA9IHsKK307CisKK3N0YXRpYyBjb25zdCBz
dHJ1Y3QgZ2VubF9tdWx0aWNhc3RfZ3JvdXAgY2lmc19nZW5sX21jZ3Jwc1tdID0geworCVtDSUZT
X0dFTkxfTUNHUlBfU1dOXSA9IHsgLm5hbWUgPSBDSUZTX0dFTkxfTUNHUlBfU1dOX05BTUUgfSwK
K307CisKK3N0cnVjdCBnZW5sX2ZhbWlseSBjaWZzX2dlbmxfZmFtaWx5ID0geworCS5uYW1lCQk9
IENJRlNfR0VOTF9OQU1FLAorCS52ZXJzaW9uCT0gQ0lGU19HRU5MX1ZFUlNJT04sCisJLmhkcnNp
emUJPSAwLAorCS5tYXhhdHRyCT0gQ0lGU19HRU5MX0FUVFJfTUFYLAorCS5tb2R1bGUJCT0gVEhJ
U19NT0RVTEUsCisJLnBvbGljeQkJPSBjaWZzX2dlbmxfcG9saWN5LAorCS5vcHMJCT0gY2lmc19n
ZW5sX29wcywKKwkubl9vcHMJCT0gQVJSQVlfU0laRShjaWZzX2dlbmxfb3BzKSwKKwkubWNncnBz
CQk9IGNpZnNfZ2VubF9tY2dycHMsCisJLm5fbWNncnBzCT0gQVJSQVlfU0laRShjaWZzX2dlbmxf
bWNncnBzKSwKK307CisKKy8qKgorICogY2lmc19nZW5sX2luaXQgLSBSZWdpc3RlciBnZW5lcmlj
IG5ldGxpbmsgZmFtaWx5CisgKgorICogUmV0dXJuIHplcm8gaWYgaW5pdGlhbGl6ZWQgc3VjY2Vz
c2Z1bGx5LCBvdGhlcndpc2Ugbm9uLXplcm8uCisgKi8KK2ludCBjaWZzX2dlbmxfaW5pdCh2b2lk
KQoreworCWludCByZXQ7CisKKwlyZXQgPSBnZW5sX3JlZ2lzdGVyX2ZhbWlseSgmY2lmc19nZW5s
X2ZhbWlseSk7CisJaWYgKHJldCA8IDApIHsKKwkJY2lmc19kYmcoVkZTLCAiJXM6IGZhaWxlZCB0
byByZWdpc3RlciBuZXRsaW5rIGZhbWlseVxuIiwKKwkJCQlfX2Z1bmNfXyk7CisJCXJldHVybiBy
ZXQ7CisJfQorCisJcmV0dXJuIDA7Cit9CisKKy8qKgorICogY2lmc19nZW5sX2V4aXQgLSBVbnJl
Z2lzdGVyIGdlbmVyaWMgbmV0bGluayBmYW1pbHkKKyAqLwordm9pZCBjaWZzX2dlbmxfZXhpdCh2
b2lkKQoreworCWludCByZXQ7CisKKwlyZXQgPSBnZW5sX3VucmVnaXN0ZXJfZmFtaWx5KCZjaWZz
X2dlbmxfZmFtaWx5KTsKKwlpZiAocmV0IDwgMCkgeworCQljaWZzX2RiZyhWRlMsICIlczogZmFp
bGVkIHRvIHVucmVnaXN0ZXIgbmV0bGluayBmYW1pbHlcbiIsCisJCQkJX19mdW5jX18pOworCX0K
K30KZGlmZiAtLWdpdCBhL2ZzL2NpZnMvbmV0bGluay5oIGIvZnMvY2lmcy9uZXRsaW5rLmgKbmV3
IGZpbGUgbW9kZSAxMDA2NDQKaW5kZXggMDAwMDAwMDAwMDAwLi5lMmZhOGVkMjRjNTQKLS0tIC9k
ZXYvbnVsbAorKysgYi9mcy9jaWZzL25ldGxpbmsuaApAQCAtMCwwICsxLDE2IEBACisvKiBTUERY
LUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMCAqLworLyoKKyAqIE5ldGxpbmsgcm91dGluZXMg
Zm9yIENJRlMKKyAqCisgKiBDb3B5cmlnaHQgKGMpIDIwMjAgU2FtdWVsIENhYnJlcm8gPHNjYWJy
ZXJvQHN1c2UuZGU+CisgKi8KKworI2lmbmRlZiBfQ0lGU19ORVRMSU5LX0gKKyNkZWZpbmUgX0NJ
RlNfTkVUTElOS19ICisKK2V4dGVybiBzdHJ1Y3QgZ2VubF9mYW1pbHkgY2lmc19nZW5sX2ZhbWls
eTsKKworZXh0ZXJuIGludCBjaWZzX2dlbmxfaW5pdCh2b2lkKTsKK2V4dGVybiB2b2lkIGNpZnNf
Z2VubF9leGl0KHZvaWQpOworCisjZW5kaWYgLyogX0NJRlNfTkVUTElOS19IICovCmRpZmYgLS1n
aXQgYS9pbmNsdWRlL3VhcGkvbGludXgvY2lmcy9jaWZzX25ldGxpbmsuaCBiL2luY2x1ZGUvdWFw
aS9saW51eC9jaWZzL2NpZnNfbmV0bGluay5oCm5ldyBmaWxlIG1vZGUgMTAwNjQ0CmluZGV4IDAw
MDAwMDAwMDAwMC4uY2RiMWJkNzhmYmM3Ci0tLSAvZGV2L251bGwKKysrIGIvaW5jbHVkZS91YXBp
L2xpbnV4L2NpZnMvY2lmc19uZXRsaW5rLmgKQEAgLTAsMCArMSwzMSBAQAorLyogU1BEWC1MaWNl
bnNlLUlkZW50aWZpZXI6IExHUEwtMi4xKyBXSVRIIExpbnV4LXN5c2NhbGwtbm90ZSAqLworLyoK
KyAqIE5ldGxpbmsgcm91dGluZXMgZm9yIENJRlMKKyAqCisgKiBDb3B5cmlnaHQgKGMpIDIwMjAg
U2FtdWVsIENhYnJlcm8gPHNjYWJyZXJvQHN1c2UuZGU+CisgKi8KKworCisjaWZuZGVmIF9VQVBJ
TElOVVhfQ0lGU19ORVRMSU5LX0gKKyNkZWZpbmUgX1VBUElMSU5VWF9DSUZTX05FVExJTktfSAor
CisjZGVmaW5lIENJRlNfR0VOTF9OQU1FCQkJImNpZnMiCisjZGVmaW5lIENJRlNfR0VOTF9WRVJT
SU9OCQkweDEKKworI2RlZmluZSBDSUZTX0dFTkxfTUNHUlBfU1dOX05BTUUJImNpZnNfbWNncnBf
c3duIgorCitlbnVtIGNpZnNfZ2VubF9tdWx0aWNhc3RfZ3JvdXBzIHsKKwlDSUZTX0dFTkxfTUNH
UlBfU1dOLAorfTsKKworZW51bSBjaWZzX2dlbmxfYXR0cmlidXRlcyB7CisJX19DSUZTX0dFTkxf
QVRUUl9NQVgsCit9OworI2RlZmluZSBDSUZTX0dFTkxfQVRUUl9NQVggKF9fQ0lGU19HRU5MX0FU
VFJfTUFYIC0gMSkKKworZW51bSBjaWZzX2dlbmxfY29tbWFuZHMgeworCV9fQ0lGU19HRU5MX0NN
RF9NQVgKK307CisjZGVmaW5lIENJRlNfR0VOTF9DTURfTUFYIChfX0NJRlNfR0VOTF9DTURfTUFY
IC0gMSkKKworI2VuZGlmIC8qIF9VQVBJTElOVVhfQ0lGU19ORVRMSU5LX0ggKi8KLS0gCjIuMjcu
MAoK
--0000000000007e046905b63dffa1--
