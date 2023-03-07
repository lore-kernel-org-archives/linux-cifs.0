Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAFB0C678D4
	for <linux-cifs@archiver.kernel.org>; Tue,  7 Mar 2023 09:38:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbjCGJig (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 7 Mar 2023 04:38:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230411AbjCGJid (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 7 Mar 2023 04:38:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9B5F38645;
        Tue,  7 Mar 2023 01:38:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6402EB8117D;
        Tue,  7 Mar 2023 09:38:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 283F5C4339B;
        Tue,  7 Mar 2023 09:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678181910;
        bh=AfXC17j/QjZ4c6JP4Ez89lCMAtvK2x6KNV/LSRJLsvk=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=t2zmzPCnpyh+CTMAq1KG67UuHB3QPMclF8XtVQcnkvIGO9QSPHAgWImQatUtsYO4K
         SX0LcFdwGpjTW2pMs641ceUviFKwHAmIf6cKKcZfN/ujctl6PhFXij0qPOt88G9Y0+
         W16kfijiKvi+a9iwNijxNhIRt3msbvQwXGNqwuVYZ53feVTFsD3X8BfSIcan5MuVtX
         0ztuYbsAnr9XYQrL3CWF7fUTuGytEExyoxKzojxIo1OxgqBLYLb8weomsq0ZiMDik9
         kccZC2s+S7L7QbkRiiRR+NCxfa2AGQMoj+meM39hEKt0XRI+4XKXcembCpYigtJ3PE
         DD5G7sRP5YgOg==
Received: by mail-ot1-f44.google.com with SMTP id g6-20020a056830308600b0068d4b30536aso6799238ots.9;
        Tue, 07 Mar 2023 01:38:30 -0800 (PST)
X-Gm-Message-State: AO0yUKX5fcG99FeNvKRNQqS914/b+dv7uTq55yHFnloYK6/7TbFjvGMj
        Sf6rbQfq7ILIsVCg3vYPQIngWv5oleOOz2hfkfQ=
X-Google-Smtp-Source: AK7set+0PfCJqakATAaFh3iU76mHZ18cX1d/tpOmF0+QRvgUhfV0rhPtMEPu+cI6MExjxmbOjDohAnmUYD1DT+JoP7E=
X-Received: by 2002:a05:6830:26ca:b0:690:d39d:ee41 with SMTP id
 m10-20020a05683026ca00b00690d39dee41mr4226065otu.7.1678181909327; Tue, 07 Mar
 2023 01:38:29 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:ac9:67ca:0:b0:4c2:5d59:8c51 with HTTP; Tue, 7 Mar 2023
 01:38:28 -0800 (PST)
In-Reply-To: <20230304083559.172398-1-congmingyi@gmail.com>
References: <20230304083559.172398-1-congmingyi@gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Tue, 7 Mar 2023 18:38:28 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8GzB_onCcs=2aZs0MGTy_7oGhECEdr+rcdVS+Jf2C5xQ@mail.gmail.com>
Message-ID: <CAKYAXd8GzB_onCcs=2aZs0MGTy_7oGhECEdr+rcdVS+Jf2C5xQ@mail.gmail.com>
Subject: Re: [PATCH] fs: add the tuncate check of exfat and hfsplus
To:     MIngyi Cong <congmingyi@gmail.com>
Cc:     senozhatsky@chromium.org, sfrench@samba.org, hyc.lee@gmail.com,
        linux-kernel@vger.kernel.org, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2023-03-04 17:35 GMT+09:00, MIngyi Cong <congmingyi@gmail.com>:
> From: Mingyi Cong <congmingyi@gmail.com>
>
> EXFAT and HFSPLUS will fill zero data in truncated range.
> Fix this by adding *_SUPER_MAGIC check.
>
> Signed-off-by: Mingyi Cong <congmingyi@gmail.com>
> ---
>  fs/ksmbd/smb2pdu.c         | 4 +++-
>  include/uapi/linux/magic.h | 2 ++
>  2 files changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index ac029dfd2..10ab929ad 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -5738,7 +5738,9 @@ static int set_end_of_file_info(struct ksmbd_work
> *work, struct ksmbd_file *fp,
>  	 * truncate of some filesystem like FAT32 fill zero data in
>  	 * truncated range.
>  	 */
> -	if (inode->i_sb->s_magic != MSDOS_SUPER_MAGIC) {
> +	if (inode->i_sb->s_magic != MSDOS_SUPER_MAGIC ||
> +		inode->i_sb->s_magic != EXFAT_SUPER_MAGIC ||
> +		inode->i_sb->s_magic != HFSPLUS_SUPER_MAGIC) {
>  		ksmbd_debug(SMB, "filename : %s truncated to newsize %lld\n",
>  			    fp->filename, newsize);
>  		rc = ksmbd_vfs_truncate(work, fp, newsize);
> diff --git a/include/uapi/linux/magic.h b/include/uapi/linux/magic.h
> index 35687dcb1..687b7f584 100644
> --- a/include/uapi/linux/magic.h
> +++ b/include/uapi/linux/magic.h
> @@ -43,6 +43,8 @@
>  #define MINIX3_SUPER_MAGIC	0x4d5a		/* minix v3 fs, 60 char names */
>
>  #define MSDOS_SUPER_MAGIC	0x4d44		/* MD */
> +#define EXFAT_SUPER_MAGIC	0x2011BAB0UL		/* EXFAT */
EXFAT_SUPER_MAGIC is already here. Please check it.

> +#define HFSPLUS_SUPER_MAGIC	0x482b		/* HFSPLUS */
Is there no need to add HFS magic?

>  #define NCP_SUPER_MAGIC		0x564c		/* Guess, what 0x564c is :-) */
>  #define NFS_SUPER_MAGIC		0x6969
>  #define OCFS2_SUPER_MAGIC	0x7461636f
> --
> 2.34.1
>
>
