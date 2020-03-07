Return-Path: <SRS0=KWrg=4Y=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39209C10F00
	for <linux-cifs@archiver.kernel.org>; Sat,  7 Mar 2020 20:04:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 023302073C
	for <linux-cifs@archiver.kernel.org>; Sat,  7 Mar 2020 20:04:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IzCg+Dgs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726114AbgCGUE3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 7 Mar 2020 15:04:29 -0500
Received: from mail-yw1-f66.google.com ([209.85.161.66]:45102 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbgCGUE3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 7 Mar 2020 15:04:29 -0500
Received: by mail-yw1-f66.google.com with SMTP id d206so5830037ywa.12;
        Sat, 07 Mar 2020 12:04:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/rR/M+LiYBCWNmfBPwlVH/wzXuH1CUAi97im8uVf3hE=;
        b=IzCg+DgshWulZUq80/28tRdF0HPsUS1Hft+N9NAOtOIQfjvPpzSw6nk1B8nb5dcUwd
         SidMdfdrwiPQsseOyQWc/pzvrYdtxtGGv3ICelDqvYBOcy/K5AytXw9F4J6Js7EMDVfw
         rSnVOSA3MlLgvpIb81Zgg4hviSNaQhgSLgDF3B4O4TaZAs4udYbm+ZtwWfaQipLSEZ9l
         qhcRd/QlJ3DxGog5KejIctKwcYosnKv3/HOibeBi6+EKQWlSIL6wfGKnPPkO4gC1fQfl
         p3vozBbvreU2YiEfNiy1d79KuPrpu3ZQzvR1qQJ0HgvP12J0ZDfy1451P3lPQuC7TDQL
         NrTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/rR/M+LiYBCWNmfBPwlVH/wzXuH1CUAi97im8uVf3hE=;
        b=Y24B6y235/5SzdfIdt930cj6QS9WELisu3XZN/by+1DDa+OBUWKnKNGyPCYlt0quIz
         BnRKgspW+vmgF8y3CUSbFrygh5SJ1loicA3gDbsN94QAYZzc0G2dKHFINj/YeFSgafFu
         49mxU9eCwChS/h/Ax7JWzuQzOTFAJYRd5dQupT1v+7FxF2Nx4Nf1C653mRzz1QQcqosj
         M/I9gxg6NmTZK+vSC6vLYvq9u4+lWg7OlJgxPw4i4kZAGtZztiJsEf8OMs4zebUy6LT8
         3ra7yVoFxTqoOG6ykmKcGuS1MZY2Yj0Ue2HjmmuUWbq4rP61qzVWW8ywfyJX9TVn7QwH
         EPVg==
X-Gm-Message-State: ANhLgQ2rZSSGfKTtAWMyYoCHIZ98zg5GMMZc164ZEeX2ejdHhy2LJVjr
        2oeyrBkfJcwBH45P0LPJ6vDSQr0BiuwM0E2DlL4DNFAZ
X-Google-Smtp-Source: ADFU+vuBTktkE7VEjjPZrONxkb/cDFSxDE0LzO5UJB3I8x3It6D/F0K7wDZKzC7QuR0lnyvVKPUOepBbnLb0aP1rTS4=
X-Received: by 2002:a0d:f583:: with SMTP id e125mr10608364ywf.176.1583611467702;
 Sat, 07 Mar 2020 12:04:27 -0800 (PST)
MIME-Version: 1.0
References: <20200306221740.GA31410@embeddedor>
In-Reply-To: <20200306221740.GA31410@embeddedor>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 7 Mar 2020 14:04:17 -0600
Message-ID: <CAH2r5muV_W9T4s1HYK-Bv+XVAwz8tqgKORnzMHCpKi8VUW0EfQ@mail.gmail.com>
Subject: Re: [PATCH][next] cifs: cifspdu.h: Replace zero-length array with
 flexible-array member
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next

On Fri, Mar 6, 2020 at 5:01 PM Gustavo A. R. Silva
<gustavo@embeddedor.com> wrote:
>
> The current codebase makes use of the zero-length array language
> extension to the C90 standard, but the preferred mechanism to declare
> variable-length types such as these ones is a flexible array member[1][2],
> introduced in C99:
>
> struct foo {
>         int stuff;
>         struct boo array[];
> };
>
> By making use of the mechanism above, we will get a compiler warning
> in case the flexible array does not occur last in the structure, which
> will help us prevent some kind of undefined behavior bugs from being
> inadvertently introduced[3] to the codebase from now on.
>
> Also, notice that, dynamic memory allocations won't be affected by
> this change:
>
> "Flexible array members have incomplete type, and so the sizeof operator
> may not be applied. As a quirk of the original implementation of
> zero-length arrays, sizeof evaluates to zero."[1]
>
> This issue was found with the help of Coccinelle.
>
> [1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
> [2] https://github.com/KSPP/linux/issues/21
> [3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")
>
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
>  fs/cifs/cifspdu.h | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
> index 8e15887d1f1f..593d826820c3 100644
> --- a/fs/cifs/cifspdu.h
> +++ b/fs/cifs/cifspdu.h
> @@ -1021,7 +1021,7 @@ typedef struct smb_com_writex_req {
>         __le16 ByteCount;
>         __u8 Pad;               /* BB check for whether padded to DWORD
>                                    boundary and optimum performance here */
> -       char Data[0];
> +       char Data[];
>  } __attribute__((packed)) WRITEX_REQ;
>
>  typedef struct smb_com_write_req {
> @@ -1041,7 +1041,7 @@ typedef struct smb_com_write_req {
>         __le16 ByteCount;
>         __u8 Pad;               /* BB check for whether padded to DWORD
>                                    boundary and optimum performance here */
> -       char Data[0];
> +       char Data[];
>  } __attribute__((packed)) WRITE_REQ;
>
>  typedef struct smb_com_write_rsp {
> @@ -1306,7 +1306,7 @@ typedef struct smb_com_ntransact_req {
>         /* SetupCount words follow then */
>         __le16 ByteCount;
>         __u8 Pad[3];
> -       __u8 Parms[0];
> +       __u8 Parms[];
>  } __attribute__((packed)) NTRANSACT_REQ;
>
>  typedef struct smb_com_ntransact_rsp {
> @@ -1523,7 +1523,7 @@ struct file_notify_information {
>         __le32 NextEntryOffset;
>         __le32 Action;
>         __le32 FileNameLength;
> -       __u8  FileName[0];
> +       __u8  FileName[];
>  } __attribute__((packed));
>
>  /* For IO_REPARSE_TAG_SYMLINK */
> @@ -1536,7 +1536,7 @@ struct reparse_symlink_data {
>         __le16  PrintNameOffset;
>         __le16  PrintNameLength;
>         __le32  Flags;
> -       char    PathBuffer[0];
> +       char    PathBuffer[];
>  } __attribute__((packed));
>
>  /* Flag above */
> @@ -1553,7 +1553,7 @@ struct reparse_posix_data {
>         __le16  ReparseDataLength;
>         __u16   Reserved;
>         __le64  InodeType; /* LNK, FIFO, CHR etc. */
> -       char    PathBuffer[0];
> +       char    PathBuffer[];
>  } __attribute__((packed));
>
>  struct cifs_quota_data {
> @@ -1762,7 +1762,7 @@ struct set_file_rename {
>         __le32 overwrite;   /* 1 = overwrite dest */
>         __u32 root_fid;   /* zero */
>         __le32 target_name_len;
> -       char  target_name[0];  /* Must be unicode */
> +       char  target_name[];  /* Must be unicode */
>  } __attribute__((packed));
>
>  struct smb_com_transaction2_sfi_req {
> @@ -2451,7 +2451,7 @@ struct cifs_posix_acl { /* access conrol list  (ACL) */
>         __le16  version;
>         __le16  access_entry_count;  /* access ACL - count of entries */
>         __le16  default_entry_count; /* default ACL - count of entries */
> -       struct cifs_posix_ace ace_array[0];
> +       struct cifs_posix_ace ace_array[];
>         /* followed by
>         struct cifs_posix_ace default_ace_arraay[] */
>  } __attribute__((packed));  /* level 0x204 */
> @@ -2757,7 +2757,7 @@ typedef struct file_xattr_info {
>         /* BB do we need another field for flags? BB */
>         __u32 xattr_name_len;
>         __u32 xattr_value_len;
> -       char  xattr_name[0];
> +       char  xattr_name[];
>         /* followed by xattr_value[xattr_value_len], no pad */
>  } __attribute__((packed)) FILE_XATTR_INFO; /* extended attribute info
>                                               level 0x205 */
> --
> 2.25.0
>


-- 
Thanks,

Steve
