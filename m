Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C853C433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 30 Nov 2021 23:59:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345462AbhLAADD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 30 Nov 2021 19:03:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236395AbhLAADC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 30 Nov 2021 19:03:02 -0500
Received: from mail-ua1-x92c.google.com (mail-ua1-x92c.google.com [IPv6:2607:f8b0:4864:20::92c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25669C061574
        for <linux-cifs@vger.kernel.org>; Tue, 30 Nov 2021 15:59:42 -0800 (PST)
Received: by mail-ua1-x92c.google.com with SMTP id a14so45238029uak.0
        for <linux-cifs@vger.kernel.org>; Tue, 30 Nov 2021 15:59:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qV6SIHhSgjMV7T6uSUaRczDBfsH6RAS3bLJheVXUB+0=;
        b=N30PNzbLxhXr44GK+Ix8gvqg094P3LML2gxq5QxqLgnzVPE0RML8i0SDSNtwTdo328
         QcHnTqSqdtifm+kgJS7IiUL6Q3QGYkjVW6vEXRi6rKO5ZQlG9SrWcRo9GgnDZmeDl28N
         5yAx72oWYKSE+6KqS5mHakGkoZq/1vPwtOMCsdDhDNZHzNVUzjuLzWG5vkzAgwp1UWPc
         5k2WITtSax0xT2t08pa5DcWk7ky5TyGcg03drCqiq+XWKt0yW3xF3CoNqimzJqlrXwQc
         Jw+1hAsu6+vWoJGquE2ZYe2mpERTTGvh6++LRCp938pNsA9XzyRtRVnypy1stcm5QS25
         febA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qV6SIHhSgjMV7T6uSUaRczDBfsH6RAS3bLJheVXUB+0=;
        b=u6q8OZOkRoyZTJm6vqIehlsMHnAOHJq7bl6NkUja/UBS17OiYfpSb9S7u8jqjrR1EZ
         umy/EFctrCZoNmWY9yDAgX9EPzk0MAq4+85ix84R/qa0ubapbSYIHy1hnQnjOVsBJUks
         oZyrsrJKQ+BCFKLv0Rsu7643ZQFKm+ybOaGjWoFct42viUpbDgelOrsXbeJJwyRwl0BS
         KcQhC0I7HtWPZe91RCnPZJg+JFMCCkELmfwf8sT6NKj2jvvNOgAiiLsVqePtn8O/ZNtv
         TvvE5N/n/fwu21WMGjcdtEbKUZno/r2iseXxBbuF3ozJhT/coZYF5HEwVGklvrTjQFtS
         neLQ==
X-Gm-Message-State: AOAM531ImX4UEgADZGbIUPWmckY/A7NqQZO2QVt7fV1mxcvyxAplK3v4
        20K1Sk/nRrzzkbY4W0yrlARJP12R2uaQBz8edvZtgbbLMvc=
X-Google-Smtp-Source: ABdhPJxwi997P7zhF/zCY50LdmsVGDL08NhMIliOs9cgzdmKebVhj5Wg2tmlSvDmhK2mntKY+Lo+1eNRRIMRneEIEh8=
X-Received: by 2002:a05:6102:2922:: with SMTP id cz34mr3638730vsb.56.1638316781301;
 Tue, 30 Nov 2021 15:59:41 -0800 (PST)
MIME-Version: 1.0
References: <20211130115430.GA16669@kili>
In-Reply-To: <20211130115430.GA16669@kili>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Wed, 1 Dec 2021 08:59:30 +0900
Message-ID: <CANFS6bZJHPS+ZLn2PpPJjvBudj_ATuAkQ6nNHLW+oSHijQjzpA@mail.gmail.com>
Subject: Re: [bug report] cifsd: add server-side procedures for SMB3
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Namjae Jeon <namjae.jeon@samsung.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello Dan,

I will fix it.
Thank you for your report!

2021=EB=85=84 12=EC=9B=94 1=EC=9D=BC (=EC=88=98) =EC=98=A4=EC=A0=84 8:27, D=
an Carpenter <dan.carpenter@oracle.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=
=B1:
>
> Hello Namjae Jeon,
>
> The patch e2f34481b24d: "cifsd: add server-side procedures for SMB3"
> from Mar 16, 2021, leads to the following Smatch static checker
> warning:
>
>         fs/ksmbd/smb2pdu.c:2970 smb2_open()
>         error: uninitialized symbol 'pntsd_size'.
>
> fs/ksmbd/smb2pdu.c
>     2930                 if (rc) {
>     2931                         rc =3D smb2_create_sd_buffer(work, req, =
&path);
>     2932                         if (rc) {
>     2933                                 if (posix_acl_rc)
>     2934                                         ksmbd_vfs_set_init_posix=
_acl(user_ns,
>     2935                                                                 =
     inode);
>     2936
>     2937                                 if (test_share_config_flag(work-=
>tcon->share_conf,
>     2938                                                            KSMBD=
_SHARE_FLAG_ACL_XATTR)) {
>     2939                                         struct smb_fattr fattr;
>     2940                                         struct smb_ntsd *pntsd;
>     2941                                         int pntsd_size, ace_num =
=3D 0;
>     2942
>     2943                                         ksmbd_acls_fattr(&fattr,=
 user_ns, inode);
>     2944                                         if (fattr.cf_acls)
>     2945                                                 ace_num =3D fatt=
r.cf_acls->a_count;
>     2946                                         if (fattr.cf_dacls)
>     2947                                                 ace_num +=3D fat=
tr.cf_dacls->a_count;
>     2948
>     2949                                         pntsd =3D kmalloc(sizeof=
(struct smb_ntsd) +
>     2950                                                         sizeof(s=
truct smb_sid) * 3 +
>     2951                                                         sizeof(s=
truct smb_acl) +
>     2952                                                         sizeof(s=
truct smb_ace) * ace_num * 2,
>     2953                                                         GFP_KERN=
EL);
>     2954                                         if (!pntsd)
>     2955                                                 goto err_out;
>     2956
>     2957                                         rc =3D build_sec_desc(us=
er_ns,
>     2958                                                             pnts=
d, NULL,
>     2959                                                             OWNE=
R_SECINFO |
>     2960                                                             GROU=
P_SECINFO |
>     2961                                                             DACL=
_SECINFO,
>     2962                                                             &pnt=
sd_size, &fattr);
>
> No check for if "rc" is an error code.
>
>     2963                                         posix_acl_release(fattr.=
cf_acls);
>     2964                                         posix_acl_release(fattr.=
cf_dacls);
>     2965
>     2966                                         rc =3D ksmbd_vfs_set_sd_=
xattr(conn,
>     2967                                                                 =
    user_ns,
>     2968                                                                 =
    path.dentry,
>     2969                                                                 =
    pntsd,
> --> 2970                                                                 =
    pntsd_size);
>                                                                          =
    ^^^^^^^^^^
>
>     2971                                         kfree(pntsd);
>     2972                                         if (rc)
>     2973                                                 pr_err("failed t=
o store ntacl in xattr : %d\n",
>     2974                                                        rc);
>     2975                                 }
>     2976                         }
>     2977                 }
>     2978                 rc =3D 0;
>     2979         }
>
> regards,
> dan carpenter



--=20
Thanks,
Hyunchul
