Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1B43C4332F
	for <linux-cifs@archiver.kernel.org>; Wed, 19 Oct 2022 15:35:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231194AbiJSPfb (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 19 Oct 2022 11:35:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231491AbiJSPfJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 19 Oct 2022 11:35:09 -0400
Received: from mail-ua1-x92d.google.com (mail-ua1-x92d.google.com [IPv6:2607:f8b0:4864:20::92d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3D361C2E92
        for <linux-cifs@vger.kernel.org>; Wed, 19 Oct 2022 08:30:37 -0700 (PDT)
Received: by mail-ua1-x92d.google.com with SMTP id t26so7411820uaj.9
        for <linux-cifs@vger.kernel.org>; Wed, 19 Oct 2022 08:30:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qp/562Vf8aYEntYlKlRLJf+1Lj7RTDn6WrHZ1t4xhX0=;
        b=RD5iqrcJtqOWDflSqz5N+XSOswed2tw9E3EOF+R5mvuk5BRWlJQpEeN4uyjCjujHNp
         rsdZBn4cZkDFh067K4BnqEqg8pXYDihZ22tkh8u+UXs2aR4EVYcLAfiUEYSb7iKslIuE
         lzh6b4SO3n1csEsPLN35WVZgRATOJ29AdoNu/QcuIxbMKgeR59/mvl8HKOZxrPsXyLsK
         yk6l6ur8eysl60HpKeTxtv1SXYZUTYlCFAfw6Isn/e8oIparD5I9ZRdIOqdkih1+FOGo
         ZDQBc81gOEzyBQACIftRwNUiw7hDDVbuX/hzS0+C93Iys85oEd3Av7vbJilleU4qGAg4
         U23w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qp/562Vf8aYEntYlKlRLJf+1Lj7RTDn6WrHZ1t4xhX0=;
        b=lVbiRcG7pLJAkG2Kr17n1TGVlTbJBc5qw17FdnLT/Go7QV4QFSf8aBaWsA927LS+wl
         dQOcN4P8uQV0Rr6mBxRDkKn7TA26vuQUSeUSr2x9WDgJ0w+oJ6/meErenvxl3/f8TpwS
         J+qOmygFkSVQl82FBEY74ytPXL4GE2LTygiE+Mq0ul7JqfmGWmkSsasBpcYcxkVd6Ib8
         jiB40+0LUAl8wvhKUUxISthqJezPC7+2ui8yP9z+qkM2HO85ztn2UK3gmWdSMtZE3J16
         7LQ5Hm1iiRiSOap47VCBgDis/SLvI7CsxeXH0Hdq7Qit/EtAJYrnXoRYwDpdgWyFBfnl
         YPyg==
X-Gm-Message-State: ACrzQf18DbsSK0vkdXQwiPuRQprLHxVT2laS+LCgO3g3CZxCNKYiZ67r
        xQhPLEfE34mEwlaBFdyklcyaPOYb9UqHpwpc5zM/cbjk
X-Google-Smtp-Source: AMsMyM44g8WOeQYlt3XMkHO23vnw433koFVTFD8buNvrkEv0ZL8YcuVPVNAlQHf8SngqRrc3fnrXqUmxo0Y60DJ86II=
X-Received: by 2002:a9f:2b81:0:b0:3d8:d599:ef49 with SMTP id
 y1-20020a9f2b81000000b003d8d599ef49mr1917601uai.96.1666193344767; Wed, 19 Oct
 2022 08:29:04 -0700 (PDT)
MIME-Version: 1.0
References: <20221019142537.23718-1-pc@cjr.nz>
In-Reply-To: <20221019142537.23718-1-pc@cjr.nz>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 19 Oct 2022 10:28:54 -0500
Message-ID: <CAH2r5mshYDHUPyJ2ZysirA-jhJonTQUvhvMC4Q0xKOuTo2Jb+A@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix memory leaks in session setup
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Is this a cc:stable? or Fixes: tag?

On Wed, Oct 19, 2022 at 9:24 AM Paulo Alcantara <pc@cjr.nz> wrote:
>
> We were only zeroing out the ntlmssp blob but forgot to free the
> allocated buffer in the end of SMB2_sess_auth_rawntlmssp_negotiate()
> and SMB2_sess_auth_rawntlmssp_authenticate() functions.
>
> This fixes below kmemleak reports:
>
> unreferenced object 0xffff88800ddcfc60 (size 96):
>   comm "mount.cifs", pid 758, jiffies 4294696066 (age 42.967s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<00000000d0beeb29>] __kmalloc+0x39/0xa0
>     [<00000000e3834047>] build_ntlmssp_smb3_negotiate_blob+0x2c/0x110 [cifs]
>     [<00000000e85f5ab2>] SMB2_sess_auth_rawntlmssp_negotiate+0xd3/0x230 [cifs]
>     [<0000000080fdb897>] SMB2_sess_setup+0x16c/0x2a0 [cifs]
>     [<000000009af320a8>] cifs_setup_session+0x13b/0x370 [cifs]
>     [<00000000f15d5982>] cifs_get_smb_ses+0x643/0xb90 [cifs]
>     [<00000000fe15eb90>] mount_get_conns+0x63/0x3e0 [cifs]
>     [<00000000768aba03>] mount_get_dfs_conns+0x16/0xa0 [cifs]
>     [<00000000cf1cf146>] cifs_mount+0x1c2/0x9a0 [cifs]
>     [<000000000d66b51e>] cifs_smb3_do_mount+0x10e/0x710 [cifs]
>     [<0000000077a996c5>] smb3_get_tree+0xf4/0x200 [cifs]
>     [<0000000094dbd041>] vfs_get_tree+0x23/0xc0
>     [<000000003a8561de>] path_mount+0x2d3/0xb50
>     [<00000000ed5c86d6>] __x64_sys_mount+0x102/0x140
>     [<00000000142142f3>] do_syscall_64+0x3b/0x90
>     [<00000000e2b89731>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
> unreferenced object 0xffff88801437f000 (size 512):
>   comm "mount.cifs", pid 758, jiffies 4294696067 (age 42.970s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<00000000d0beeb29>] __kmalloc+0x39/0xa0
>     [<00000000004f53d2>] build_ntlmssp_auth_blob+0x4f/0x340 [cifs]
>     [<000000005f333084>] SMB2_sess_auth_rawntlmssp_authenticate+0xd4/0x250 [cifs]
>     [<0000000080fdb897>] SMB2_sess_setup+0x16c/0x2a0 [cifs]
>     [<000000009af320a8>] cifs_setup_session+0x13b/0x370 [cifs]
>     [<00000000f15d5982>] cifs_get_smb_ses+0x643/0xb90 [cifs]
>     [<00000000fe15eb90>] mount_get_conns+0x63/0x3e0 [cifs]
>     [<00000000768aba03>] mount_get_dfs_conns+0x16/0xa0 [cifs]
>     [<00000000cf1cf146>] cifs_mount+0x1c2/0x9a0 [cifs]
>     [<000000000d66b51e>] cifs_smb3_do_mount+0x10e/0x710 [cifs]
>     [<0000000077a996c5>] smb3_get_tree+0xf4/0x200 [cifs]
>     [<0000000094dbd041>] vfs_get_tree+0x23/0xc0
>     [<000000003a8561de>] path_mount+0x2d3/0xb50
>     [<00000000ed5c86d6>] __x64_sys_mount+0x102/0x140
>     [<00000000142142f3>] do_syscall_64+0x3b/0x90
>     [<00000000e2b89731>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
>
> Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
> ---
>  fs/cifs/smb2pdu.c | 15 +++++++--------
>  1 file changed, 7 insertions(+), 8 deletions(-)
>
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index c930b63bc422..a5695748a89b 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -1341,14 +1341,13 @@ SMB2_sess_alloc_buffer(struct SMB2_sess_data *sess_data)
>  static void
>  SMB2_sess_free_buffer(struct SMB2_sess_data *sess_data)
>  {
> -       int i;
> +       struct kvec *iov = sess_data->iov;
>
> -       /* zero the session data before freeing, as it might contain sensitive info (keys, etc) */
> -       for (i = 0; i < 2; i++)
> -               if (sess_data->iov[i].iov_base)
> -                       memzero_explicit(sess_data->iov[i].iov_base, sess_data->iov[i].iov_len);
> +       /* iov[1] is already freed by caller */
> +       if (sess_data->buf0_type != CIFS_NO_BUFFER && iov[0].iov_base)
> +               memzero_explicit(iov[0].iov_base, iov[0].iov_len);
>
> -       free_rsp_buf(sess_data->buf0_type, sess_data->iov[0].iov_base);
> +       free_rsp_buf(sess_data->buf0_type, iov[0].iov_base);
>         sess_data->buf0_type = CIFS_NO_BUFFER;
>  }
>
> @@ -1578,7 +1577,7 @@ SMB2_sess_auth_rawntlmssp_negotiate(struct SMB2_sess_data *sess_data)
>         }
>
>  out:
> -       memzero_explicit(ntlmssp_blob, blob_length);
> +       kfree_sensitive(ntlmssp_blob);
>         SMB2_sess_free_buffer(sess_data);
>         if (!rc) {
>                 sess_data->result = 0;
> @@ -1662,7 +1661,7 @@ SMB2_sess_auth_rawntlmssp_authenticate(struct SMB2_sess_data *sess_data)
>         }
>  #endif
>  out:
> -       memzero_explicit(ntlmssp_blob, blob_length);
> +       kfree_sensitive(ntlmssp_blob);
>         SMB2_sess_free_buffer(sess_data);
>         kfree_sensitive(ses->ntlmssp);
>         ses->ntlmssp = NULL;
> --
> 2.38.0
>


-- 
Thanks,

Steve
