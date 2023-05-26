Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1FD9C77B7A
	for <linux-cifs@archiver.kernel.org>; Fri, 26 May 2023 11:56:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231447AbjEZL4S (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 26 May 2023 07:56:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231444AbjEZL4O (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 26 May 2023 07:56:14 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1FAB128
        for <linux-cifs@vger.kernel.org>; Fri, 26 May 2023 04:56:13 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id 5b1f17b1804b1-3f601c57d8dso5756745e9.0
        for <linux-cifs@vger.kernel.org>; Fri, 26 May 2023 04:56:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1685102172; x=1687694172;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XGrSevfaiB2SbXrDEv3Giw9ox42z9S5omYa+v8cazUc=;
        b=doxtiaChqHwz+z0spF37dpxVTnmemLRE19C2YqFzTV0/BaDbJnquUykPzSoHdDJkc9
         9zDmI4pLTo55dfiYfC01OWppCgy/sa2mcZcsxi/IIb380yENpO8nhaYCif7RAFnf/itY
         i7ZAfvqCALBiVtfUcLn1TKkezHv7XtaHvBXMrANJJ3D+8WxKf8Lig8g0JA4P9hrdUO8G
         pfBgMRGXzN31NRLpHiDdwvaRf8B/YMYjtltuBJrRJGMRuQquZEKmcQtH/SoiTM9b8qG+
         DImvoqS+P0gsA/j368hJZtcmxCHG9F8nsE9nexO+CoZRSLojK+si9cpDx2SceHIKrBBE
         MfsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685102172; x=1687694172;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XGrSevfaiB2SbXrDEv3Giw9ox42z9S5omYa+v8cazUc=;
        b=IbIhuvC8YS1pIzxf9DzaM4QUWlRB58H/f+EFm5mo1+AadfwZrch21ABvKi6Fnyg87f
         M9D6flC13Y2wq2UUl2tgJr/U8t7N0v5zfVQkYHEAq5pSPBsFHGF5CvmatcVrlCaZGJv0
         dFdAUDbpOQ1m1m+4RwyW650OIl4EIKvOyb99WkvwxQjAXuHxqiSLHDHKTHIA0dYy72Wq
         pvlIOiyPus8ZMahZ08OUvJitLHOYc/IS8aLlS8rASvMYm+xZZRtDl1Lr6HHyr/101OXD
         7FRhzhUuif7iN8vryAANu1TJdJzRi7BuNeuhIVJtvcv1xHXwCdNdrurAPVJeSV8MyvYI
         27Tw==
X-Gm-Message-State: AC+VfDwfDiCyEac8OtWpC0VG6vXHwOHpLHVD745zvk2W8fKpRjJBU3Q1
        2irVYd8+qw/cNHgf4pJsmtw+eA==
X-Google-Smtp-Source: ACHHUZ7man6Gj5/dNHe8/kNFS4j9L2CTJSgYUOLHkM7uEg25e85x7o84Wf7g0pDlIHkL0mmfuwFZDQ==
X-Received: by 2002:a1c:f613:0:b0:3f6:8ba:6ea2 with SMTP id w19-20020a1cf613000000b003f608ba6ea2mr1356651wmc.15.1685102172386;
        Fri, 26 May 2023 04:56:12 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id k15-20020a05600c0b4f00b003f611b2aedesm4950910wmr.38.2023.05.26.04.56.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 04:56:10 -0700 (PDT)
Date:   Fri, 26 May 2023 14:56:07 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     namjae.jeon@samsung.com
Cc:     linux-cifs@vger.kernel.org
Subject: [bug report] cifsd: add server-side procedures for SMB3
Message-ID: <74f5237c-50a4-4117-8e6e-62c2de48c2c8@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello Namjae Jeon,

The patch e2f34481b24d: "cifsd: add server-side procedures for SMB3"
from Mar 16, 2021, leads to the following Smatch static checker
warning:

fs/smb/server/smbacl.c:1296 smb_check_perm_dacl()
    error: 'posix_acls' dereferencing possible ERR_PTR()
fs/smb/server/vfs.c:1323 ksmbd_vfs_make_xattr_posix_acl()
    error: 'posix_acls' dereferencing possible ERR_PTR()
fs/smb/server/vfs.c:1830 ksmbd_vfs_inherit_posix_acl()
    error: 'acls' dereferencing possible ERR_PTR()

fs/smb/server/smbacl.c
    1281         if (*pdaccess & FILE_MAXIMAL_ACCESS_LE && found) {
    1282                 granted = READ_CONTROL | WRITE_DAC | FILE_READ_ATTRIBUTES |
    1283                         DELETE;
    1284 
    1285                 granted |= le32_to_cpu(ace->access_req);
    1286 
    1287                 if (!pdacl->num_aces)
    1288                         granted = GENERIC_ALL_FLAGS;
    1289         }
    1290 
    1291         if (IS_ENABLED(CONFIG_FS_POSIX_ACL)) {
    1292                 posix_acls = get_inode_acl(d_inode(path->dentry), ACL_TYPE_ACCESS);

__get_acl() returns a mix of error pointers and NULL.  I don't really
understand the rules here.  There are no comments explaining it.

    1293                 if (posix_acls && !found) {
    1294                         unsigned int id = -1;
    1295 
--> 1296                         pa_entry = posix_acls->a_entries;
                                            ^^^^^^^^^^^^
Potential error pointer dereference.

    1297                         for (i = 0; i < posix_acls->a_count; i++, pa_entry++) {
    1298                                 if (pa_entry->e_tag == ACL_USER)
    1299                                         id = posix_acl_uid_translate(idmap, pa_entry);
    1300                                 else if (pa_entry->e_tag == ACL_GROUP)
    1301                                         id = posix_acl_gid_translate(idmap, pa_entry);
    1302                                 else

regards,
dan carpenter
