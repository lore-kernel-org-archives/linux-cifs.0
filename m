Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47652C00140
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Aug 2022 05:18:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231756AbiHHFST (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 8 Aug 2022 01:18:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230472AbiHHFSS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 8 Aug 2022 01:18:18 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFEDD63B2
        for <linux-cifs@vger.kernel.org>; Sun,  7 Aug 2022 22:18:15 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id p10so9567910wru.8
        for <linux-cifs@vger.kernel.org>; Sun, 07 Aug 2022 22:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=sJkqscGI+VtZFqF7fqClmkGrcF4+9PuDDwVAVi7/Y4Y=;
        b=FrwbvlbcJTOp6mGzTlvzbSqu+tr93WbAyx0AORlIRyEJ3cOzXcklenwigKX9G8wFFx
         i+1yaQ2M9QJ98uYj3/ARIisLRLPOylLwE/+k2gxAT7xahwwGuYJQNtPlKt9eyd9bxA8Z
         Go74K2Asty/FTOOSmkbT1h5PZ9ZB6pL5uq09VU7qWpMU/6w8J7MZbLAzvHRRNl0mfrtP
         J4orYTMj4pNI6VEzZBA14Q2B7bnnCAmXxWacFHP2qWd0AtrYiIEl7M9FPPg+LmwsSMIh
         JSyo3mAo5h+CxIrKE/rpvLGX+9n9nLDZIRREZaZepZfU9vbVvRiLrORjiiQ2Ai0jr00e
         efjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=sJkqscGI+VtZFqF7fqClmkGrcF4+9PuDDwVAVi7/Y4Y=;
        b=1k/oNijIhD/gPxzo2uPk3T4yVuEE+2hYyXfJozg7psUaUugZ9OqD0SVQsjeS83iEIt
         Z4DKggrWiPWgBajFvVykYmpfgp0rYBsLqPoFU7NtK6EoLuhD7+fsqXx9YPFSfuTw6XRr
         iJHHpT+vr5bVFp04ZqsnLuSANELJ/Y241fNhF5Fk4ZIaS4tBrVp06uDso8ServMk60Pb
         fSKQXo2Fth0iymseRawYtdermLbfM7Fp+TdI9CTkEJPFNtAaKVHBechcBDO5fR45rmW6
         KkKGgZ7t+cGbXqBjF7SutnoTjnUtOvbzLrQZNrELmTRkx149Ho4U1DbmkoBANazzZJY8
         S2GQ==
X-Gm-Message-State: ACgBeo1gPpJXxv2LS3lxkNOTLyMCtzFs3nlZrjT2To8pplAFdPmucEhM
        G1D38IVILFKXoA/NcE43VMmz/HP7HBfWR891VUw=
X-Google-Smtp-Source: AA6agR5plMPTPmIDtAzE9xHGdhHlc+ueJqhwpy4h5ZpnV94Bv6IBbJboDfhsak+WHgJq8UGD+9rNTNoHL2i7hz5Nd/0=
X-Received: by 2002:a05:6000:15c5:b0:220:727a:24bf with SMTP id
 y5-20020a05600015c500b00220727a24bfmr10708858wry.621.1659935894304; Sun, 07
 Aug 2022 22:18:14 -0700 (PDT)
MIME-Version: 1.0
References: <20220808024341.63913-1-atteh.mailbox@gmail.com> <20220808024341.63913-2-atteh.mailbox@gmail.com>
In-Reply-To: <20220808024341.63913-2-atteh.mailbox@gmail.com>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Mon, 8 Aug 2022 14:18:03 +0900
Message-ID: <CANFS6basuxyj-E2pp95oMr2T69Gk=xYQp5Cc=Zy0hVRv7=rFpw@mail.gmail.com>
Subject: Re: [PATCH 2/3] ksmbd-tools: cleanup config group handling
To:     atheik <atteh.mailbox@gmail.com>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022=EB=85=84 8=EC=9B=94 8=EC=9D=BC (=EC=9B=94) =EC=98=A4=EC=A0=84 11:47, a=
theik <atteh.mailbox@gmail.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> Rename cp_add_ipc_share() to cp_add_ipc_group() in order to better
> describe its purpose. Use the ipc_group global variable so as to get
> rid of the group name comparison in groups_callback(). Keep track of
> used groups callback mode by saving it per-group. Move global group
> checks to global_conf_* functions.
>
> Signed-off-by: Atte Heikkil=C3=A4 <atteh.mailbox@gmail.com>

Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>

> ---
>  include/config_parser.h |  5 +++
>  lib/config_parser.c     | 95 +++++++++++++++++++++++------------------
>  2 files changed, 59 insertions(+), 41 deletions(-)
>
> diff --git a/include/config_parser.h b/include/config_parser.h
> index b6c49b9..43212c8 100644
> --- a/include/config_parser.h
> +++ b/include/config_parser.h
> @@ -10,7 +10,12 @@
>
>  #include <glib.h>
>
> +#define GROUPS_CALLBACK_NONE   (0)
> +#define GROUPS_CALLBACK_INIT   (1 << 0)
> +#define GROUPS_CALLBACK_REINIT (1 << 1)
> +
>  struct smbconf_group {
> +       unsigned short          cb_mode;
>         char                    *name;
>         GHashTable              *kv;
>  };
> diff --git a/lib/config_parser.c b/lib/config_parser.c
> index 5e7a438..d311386 100644
> --- a/lib/config_parser.c
> +++ b/lib/config_parser.c
> @@ -21,7 +21,7 @@
>
>  struct smbconf_global global_conf;
>  struct smbconf_parser parser;
> -struct smbconf_group *global_group;
> +struct smbconf_group *global_group, *ipc_group;
>
>  unsigned long long memparse(const char *v)
>  {
> @@ -107,6 +107,7 @@ static int add_new_group(char *line)
>         }
>
>         group =3D g_malloc(sizeof(struct smbconf_group));
> +       group->cb_mode =3D GROUPS_CALLBACK_NONE;
>         group->name =3D name;
>         group->kv =3D g_hash_table_new_full(g_str_hash,
>                                           g_str_equal,
> @@ -561,6 +562,9 @@ static void global_conf_default(void)
>
>  static void global_conf_create(void)
>  {
> +       if (!global_group || global_group->cb_mode !=3D GROUPS_CALLBACK_I=
NIT)
> +               return;
> +
>         /*
>          * This will transfer server options to global_conf, and leave be=
hind
>          * in the global parser group, the options that must be applied t=
o every
> @@ -569,6 +573,23 @@ static void global_conf_create(void)
>         g_hash_table_foreach_remove(global_group->kv, global_group_kv, NU=
LL);
>  }
>
> +static void append_key_value(gpointer _k, gpointer _v, gpointer user_dat=
a)
> +{
> +       GHashTable *receiver =3D (GHashTable *) user_data;
> +
> +       /* Don't override local share options */
> +       if (!g_hash_table_lookup(receiver, _k))
> +               g_hash_table_insert(receiver, g_strdup(_k), g_strdup(_v))=
;
> +}
> +
> +static void global_conf_update(struct smbconf_group *group)
> +{
> +       if (!global_group)
> +               return;
> +
> +       g_hash_table_foreach(global_group->kv, append_key_value, group->k=
v);
> +}
> +
>  static void global_conf_fixup_missing(void)
>  {
>         int ret;
> @@ -607,39 +628,29 @@ static void global_conf_fixup_missing(void)
>                         ret);
>  }
>
> -static void append_key_value(gpointer _k, gpointer _v, gpointer user_dat=
a)
> -{
> -       GHashTable *receiver =3D (GHashTable *) user_data;
> -
> -       /* Don't override local share options */
> -       if (!g_hash_table_lookup(receiver, _k))
> -               g_hash_table_insert(receiver, g_strdup(_k), g_strdup(_v))=
;
> -}
> -
> -#define GROUPS_CALLBACK_STARTUP_INIT   0x1
> -#define GROUPS_CALLBACK_REINIT         0x2
> -
>  static void groups_callback(gpointer _k, gpointer _v, gpointer user_data=
)
>  {
> -       struct smbconf_group *group =3D (struct smbconf_group *)_v;
> +       struct smbconf_group *group =3D (struct smbconf_group *) _v;
> +       unsigned short cb_mode =3D *(unsigned short *) user_data;
>
> -       if (group !=3D global_group) {
> -               if (global_group && g_ascii_strcasecmp(_k, "ipc$"))
> -                       g_hash_table_foreach(global_group->kv,
> -                                            append_key_value,
> -                                            group->kv);
> +       if (group =3D=3D global_group)
> +               return;
>
> -               shm_add_new_share(group);
> -       }
> +       group->cb_mode =3D cb_mode;
> +
> +       if (group !=3D ipc_group)
> +               global_conf_update(group);
> +
> +       shm_add_new_share(group);
>  }
>
> -static int cp_add_ipc_share(void)
> +static int cp_add_ipc_group(void)
>  {
>         char *comment =3D NULL, *guest =3D NULL;
>         int ret =3D 0;
>
> -       if (g_hash_table_lookup(parser.groups, "ipc$"))
> -               return 0;
> +       if (ipc_group)
> +               return ret;
>
>         comment =3D g_strdup("comment =3D IPC share");
>         guest =3D g_strdup("guest ok =3D yes");
> @@ -649,13 +660,18 @@ static int cp_add_ipc_share(void)
>         if (ret) {
>                 pr_err("Unable to add IPC$ share\n");
>                 ret =3D -EINVAL;
> +               goto out;
>         }
> +
> +       ipc_group =3D g_hash_table_lookup(parser.groups, "ipc$");
> +out:
>         g_free(comment);
>         g_free(guest);
>         return ret;
>  }
>
> -static int __cp_parse_smbconfig(const char *smbconf, GHFunc cb, long fla=
gs)
> +static int __cp_parse_smbconfig(const char *smbconf, GHFunc cb,
> +                               unsigned short cb_mode)
>  {
>         int ret;
>
> @@ -665,35 +681,32 @@ static int __cp_parse_smbconfig(const char *smbconf=
, GHFunc cb, long flags)
>         if (ret)
>                 return ret;
>
> -       ret =3D cp_add_ipc_share();
> -       if (!ret) {
> -               global_group =3D g_hash_table_lookup(parser.groups, "glob=
al");
> +       ret =3D cp_add_ipc_group();
> +       if (ret)
> +               goto out;
>
> -               if (global_group && (flags =3D=3D GROUPS_CALLBACK_STARTUP=
_INIT))
> -                       global_conf_create();
> +       global_group =3D g_hash_table_lookup(parser.groups, "global");
> +       if (global_group)
> +               global_group->cb_mode =3D cb_mode;
>
> -               g_hash_table_foreach(parser.groups,
> -                                    groups_callback,
> -                                    NULL);
> -
> -               global_conf_fixup_missing();
> -       }
> +       global_conf_create();
> +       g_hash_table_foreach(parser.groups, groups_callback, &cb_mode);
> +       global_conf_fixup_missing();
> +out:
>         cp_smbconfig_destroy();
>         return ret;
>  }
>
>  int cp_parse_reload_smbconf(const char *smbconf)
>  {
> -       return __cp_parse_smbconfig(smbconf,
> -                                   groups_callback,
> +       return __cp_parse_smbconfig(smbconf, groups_callback,
>                                     GROUPS_CALLBACK_REINIT);
>  }
>
>  int cp_parse_smbconf(const char *smbconf)
>  {
> -       return __cp_parse_smbconfig(smbconf,
> -                                   groups_callback,
> -                                   GROUPS_CALLBACK_STARTUP_INIT);
> +       return __cp_parse_smbconfig(smbconf, groups_callback,
> +                                   GROUPS_CALLBACK_INIT);
>  }
>
>  int cp_parse_pwddb(const char *pwddb)
> --
> 2.37.1
>


--=20
Thanks,
Hyunchul
