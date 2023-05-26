Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F0C0C77B7A
	for <linux-cifs@archiver.kernel.org>; Fri, 26 May 2023 14:38:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243905AbjEZOiw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 26 May 2023 10:38:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243933AbjEZOit (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 26 May 2023 10:38:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8592FE6C
        for <linux-cifs@vger.kernel.org>; Fri, 26 May 2023 07:38:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AEFA46506E
        for <linux-cifs@vger.kernel.org>; Fri, 26 May 2023 14:38:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EB96C4339B
        for <linux-cifs@vger.kernel.org>; Fri, 26 May 2023 14:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685111888;
        bh=MeHkFicxaGcrdBs1sz7wYQJVqcXwZODJPSoterjGWW0=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=R6MHPm74Rt5UJHRClV2cUe2SdJHv+LSFVROfqSIR4dJRR8XGfpG83exJTYq/iLyvi
         gLnHWegi4COWOzVKPxMyqElmJjOCbAgIB88iQ4zlwaHGn4mrp5P0kq6vTVWX2k0+d3
         wAyRBOJdxWwYjSENmeBzydy3Equ1mbXlPepxreMXezAcPMVkGHWXc+/XzewluzHoJt
         DPruQqhaN8K642nZaLx+kCKAcndGrCZ1BT+0k65wvNs2ffGkNHd1D3Dh0mBNNMCF59
         HkD5Uwok4lH3yC4s1QNJvjf1P0Un0hYlIJWolykkmtKhwmKH4/WsCQwgk5mYfw1nw3
         7B+sZvWpSLg4w==
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-557e66063e8so141519eaf.3
        for <linux-cifs@vger.kernel.org>; Fri, 26 May 2023 07:38:08 -0700 (PDT)
X-Gm-Message-State: AC+VfDx53+dCZA7gq7/i5iLiG6qUFyvwamGpghsFMlm0sC4wpuW3C1+M
        lWFlg+wcwVXpe8OYPFPfDzW1IIk2Ygh4xeKtRDk=
X-Google-Smtp-Source: ACHHUZ5fquP7ajbNzr3mD/RNSItric49zutX7HmkuquESD+gEbDB/JRFBn6JWgBSYcr3ihaInQWPeMRqvT/N4o9p9qc=
X-Received: by 2002:a4a:3342:0:b0:555:5ab5:a0e5 with SMTP id
 q63-20020a4a3342000000b005555ab5a0e5mr932409ooq.7.1685111887271; Fri, 26 May
 2023 07:38:07 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:acb:0:b0:4de:afc5:4d13 with HTTP; Fri, 26 May 2023
 07:38:06 -0700 (PDT)
In-Reply-To: <74f5237c-50a4-4117-8e6e-62c2de48c2c8@kili.mountain>
References: <74f5237c-50a4-4117-8e6e-62c2de48c2c8@kili.mountain>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Fri, 26 May 2023 23:38:06 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_=Y+oA43PFx9Eye_=ERkqhATFBnB_YCd35p8g89Ghjng@mail.gmail.com>
Message-ID: <CAKYAXd_=Y+oA43PFx9Eye_=ERkqhATFBnB_YCd35p8g89Ghjng@mail.gmail.com>
Subject: Re: [bug report] cifsd: add server-side procedures for SMB3
To:     Dan Carpenter <dan.carpenter@linaro.org>
Cc:     namjae.jeon@samsung.com, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2023-05-26 20:56 GMT+09:00, Dan Carpenter <dan.carpenter@linaro.org>:
> Hello Namjae Jeon,
>
> The patch e2f34481b24d: "cifsd: add server-side procedures for SMB3"
> from Mar 16, 2021, leads to the following Smatch static checker
> warning:
>
> fs/smb/server/smbacl.c:1296 smb_check_perm_dacl()
>     error: 'posix_acls' dereferencing possible ERR_PTR()
> fs/smb/server/vfs.c:1323 ksmbd_vfs_make_xattr_posix_acl()
>     error: 'posix_acls' dereferencing possible ERR_PTR()
> fs/smb/server/vfs.c:1830 ksmbd_vfs_inherit_posix_acl()
>     error: 'acls' dereferencing possible ERR_PTR()
I will fix it.
Thanks for your report!
>
> fs/smb/server/smbacl.c
>     1281         if (*pdaccess & FILE_MAXIMAL_ACCESS_LE && found) {
>     1282                 granted = READ_CONTROL | WRITE_DAC |
> FILE_READ_ATTRIBUTES |
>     1283                         DELETE;
>     1284
>     1285                 granted |= le32_to_cpu(ace->access_req);
>     1286
>     1287                 if (!pdacl->num_aces)
>     1288                         granted = GENERIC_ALL_FLAGS;
>     1289         }
>     1290
>     1291         if (IS_ENABLED(CONFIG_FS_POSIX_ACL)) {
>     1292                 posix_acls = get_inode_acl(d_inode(path->dentry),
> ACL_TYPE_ACCESS);
>
> __get_acl() returns a mix of error pointers and NULL.  I don't really
> understand the rules here.  There are no comments explaining it.
>
>     1293                 if (posix_acls && !found) {
>     1294                         unsigned int id = -1;
>     1295
> --> 1296                         pa_entry = posix_acls->a_entries;
>                                             ^^^^^^^^^^^^
> Potential error pointer dereference.
>
>     1297                         for (i = 0; i < posix_acls->a_count; i++,
> pa_entry++) {
>     1298                                 if (pa_entry->e_tag == ACL_USER)
>     1299                                         id =
> posix_acl_uid_translate(idmap, pa_entry);
>     1300                                 else if (pa_entry->e_tag ==
> ACL_GROUP)
>     1301                                         id =
> posix_acl_gid_translate(idmap, pa_entry);
>     1302                                 else
>
> regards,
> dan carpenter
>
