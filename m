Return-Path: <SRS0=hrCW=42=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D83AC10F25
	for <linux-cifs@archiver.kernel.org>; Mon,  9 Mar 2020 21:41:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C68B21D7E
	for <linux-cifs@archiver.kernel.org>; Mon,  9 Mar 2020 21:41:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZE1Cm41Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726454AbgCIVl5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 9 Mar 2020 17:41:57 -0400
Received: from mail-yw1-f49.google.com ([209.85.161.49]:41995 "EHLO
        mail-yw1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726439AbgCIVl4 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 9 Mar 2020 17:41:56 -0400
Received: by mail-yw1-f49.google.com with SMTP id v138so11697612ywa.9;
        Mon, 09 Mar 2020 14:41:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G2zpwWsDL0R2ZtEs8ElyKdMax9QQFFWKQw9uTXmNUQc=;
        b=ZE1Cm41QgRzQnP/T1EaEvjr/uVHaOA7IyQKc2V0TjfgQ3tMIyjnTZGdAdIU04Ugsv+
         SGYrlkqGWazTPvajPaMN6JKLBzNuQk6TLx1fhgml8cea85kIpGOGMl0vA6X4nbgrqzZF
         V3v6Z+xlCsKIyFrS9qG0rBMH/9HbbwJDNY0XkLjc3yCK9xLXU1PmT4H0UxspbTuyXLTI
         dbYMYXg/KJZiLa5P7Q1Q3mJG3X9pTd7e9X7Dl/fZko3mJ+A2O4IEWPnmJ962JDBd6CeZ
         UmsoZ8SB8Lv9iWEssO9wHOjND9fjXb8RrshJ3u3GnopXIeKRnlZ7iC6cHZ6XLQSKmTZe
         jiFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G2zpwWsDL0R2ZtEs8ElyKdMax9QQFFWKQw9uTXmNUQc=;
        b=oV3GCHW0G6v9AiOSiAARtRnrAcngTmEf4T8SqHyW13DWtglZn0RLIRzBroKYMn07Ml
         x855alKnZnGUo7Rd00Am02ojcL8RL6xV/PInKQmOByQTUx/pUN/X2TBEsnrwn9ptxkSG
         C8LBj4IMYQtQY9cBMkC7n8ZuDVKQegaO2tDAwThlAdn8msIm6xjYkW4dPu8ojd9O9o5z
         37qt26yJ4LBcbyeediQgGYwCbvriXLpRtBngOlumBbevPiQX7Cf9m2jlN2wb8z0VDk7r
         ROiQoho4vW1wvtbKc+04KEnxGxedjrpxNSzHlRqjxuO3Ra+TAIuhpso+xSGQGf1fSeCZ
         Jimw==
X-Gm-Message-State: ANhLgQ2iBIPPBlaxcFhjsfKmqO36/NdM6iosfoGBUdF9R1i9dEjbbybu
        esxmRAH5ojf3jJsfHeyi/5b941YsAF3vNrJPv30=
X-Google-Smtp-Source: ADFU+vuxrn472hyxr2191ZqElzVgk8uBrtMonf6EUZFAfQFSNZ1MGtvFHCzZTgbjPL7O2yohmDUTVcIM/ylRsZvB0OQ=
X-Received: by 2002:a0d:e297:: with SMTP id l145mr19809246ywe.132.1583790114464;
 Mon, 09 Mar 2020 14:41:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200309154451.GA31357@embeddedor>
In-Reply-To: <20200309154451.GA31357@embeddedor>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 9 Mar 2020 16:41:43 -0500
Message-ID: <CAH2r5muo01BKhUuvCAKe3m2hEKO9S-V_gJBbnprDQ9eh7n2M2Q@mail.gmail.com>
Subject: Re: [PATCH][next] cifs: smb2pdu.h: Replace zero-length array with
 flexible-array member
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next

On Mon, Mar 9, 2020 at 11:04 AM Gustavo A. R. Silva
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
>  fs/cifs/smb2pdu.h | 38 +++++++++++++++++++-------------------
>  1 file changed, 19 insertions(+), 19 deletions(-)
>
> diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
> index ad14b8505b4d..817bc0531536 100644
> --- a/fs/cifs/smb2pdu.h
> +++ b/fs/cifs/smb2pdu.h
> @@ -182,7 +182,7 @@ struct smb2_symlink_err_rsp {
>         __le16 PrintNameOffset;
>         __le16 PrintNameLength;
>         __le32 Flags;
> -       __u8  PathBuffer[0];
> +       __u8  PathBuffer[];
>  } __packed;
>
>  /* SMB 3.1.1 and later dialects. See MS-SMB2 section 2.2.2.1 */
> @@ -210,7 +210,7 @@ struct share_redirect_error_context_rsp {
>         __le16 Flags;
>         __le16 TargetType;
>         __le32 IPAddrCount;
> -       struct move_dst_ipaddr IpAddrMoveList[0];
> +       struct move_dst_ipaddr IpAddrMoveList[];
>         /* __u8 ResourceName[] */ /* Name of share as counted Unicode string */
>  } __packed;
>
> @@ -326,7 +326,7 @@ struct smb2_netname_neg_context {
>         __le16  ContextType; /* 0x100 */
>         __le16  DataLength;
>         __le32  Reserved;
> -       __le16  NetName[0]; /* hostname of target converted to UCS-2 */
> +       __le16  NetName[]; /* hostname of target converted to UCS-2 */
>  } __packed;
>
>  #define POSIX_CTXT_DATA_LEN    16
> @@ -421,13 +421,13 @@ struct tree_connect_contexts {
>         __le16 ContextType;
>         __le16 DataLength;
>         __le32 Reserved;
> -       __u8   Data[0];
> +       __u8   Data[];
>  } __packed;
>
>  /* Remoted identity tree connect context structures - see MS-SMB2 2.2.9.2.1 */
>  struct smb3_blob_data {
>         __le16 BlobSize;
> -       __u8   BlobData[0];
> +       __u8   BlobData[];
>  } __packed;
>
>  /* Valid values for Attr */
> @@ -477,14 +477,14 @@ struct remoted_identity_tcon_context {
>         __le16 DeviceGroups; /* offset to SID_ARRAY_DATA struct */
>         __le16 UserClaims; /* offset to BLOB_DATA struct */
>         __le16 DeviceClaims; /* offset to BLOB_DATA struct */
> -       __u8   TicketInfo[0]; /* variable length buf - remoted identity data */
> +       __u8   TicketInfo[]; /* variable length buf - remoted identity data */
>  } __packed;
>
>  struct smb2_tree_connect_req_extension {
>         __le32 TreeConnectContextOffset;
>         __le16 TreeConnectContextCount;
>         __u8  Reserved[10];
> -       __u8  PathName[0]; /* variable sized array */
> +       __u8  PathName[]; /* variable sized array */
>         /* followed by array of TreeConnectContexts */
>  } __packed;
>
> @@ -689,7 +689,7 @@ struct smb2_create_req {
>         __le16 NameLength;
>         __le32 CreateContextsOffset;
>         __le32 CreateContextsLength;
> -       __u8   Buffer[0];
> +       __u8   Buffer[];
>  } __packed;
>
>  /*
> @@ -727,7 +727,7 @@ struct create_context {
>         __le16 Reserved;
>         __le16 DataOffset;
>         __le32 DataLength;
> -       __u8 Buffer[0];
> +       __u8 Buffer[];
>  } __packed;
>
>  #define SMB2_LEASE_READ_CACHING_HE     0x01
> @@ -869,7 +869,7 @@ struct crt_sd_ctxt {
>  struct resume_key_req {
>         char ResumeKey[COPY_CHUNK_RES_KEY_SIZE];
>         __le32  ContextLength;  /* MBZ */
> -       char    Context[0];     /* ignored, Windows sets to 4 bytes of zero */
> +       char    Context[];      /* ignored, Windows sets to 4 bytes of zero */
>  } __packed;
>
>  /* this goes in the ioctl buffer when doing a copychunk request */
> @@ -931,7 +931,7 @@ struct reparse_data_buffer {
>         __le32  ReparseTag;
>         __le16  ReparseDataLength;
>         __u16   Reserved;
> -       __u8    DataBuffer[0]; /* Variable Length */
> +       __u8    DataBuffer[]; /* Variable Length */
>  } __packed;
>
>  struct reparse_guid_data_buffer {
> @@ -939,7 +939,7 @@ struct reparse_guid_data_buffer {
>         __le16  ReparseDataLength;
>         __u16   Reserved;
>         __u8    ReparseGuid[16];
> -       __u8    DataBuffer[0]; /* Variable Length */
> +       __u8    DataBuffer[]; /* Variable Length */
>  } __packed;
>
>  struct reparse_mount_point_data_buffer {
> @@ -950,7 +950,7 @@ struct reparse_mount_point_data_buffer {
>         __le16  SubstituteNameLength;
>         __le16  PrintNameOffset;
>         __le16  PrintNameLength;
> -       __u8    PathBuffer[0]; /* Variable Length */
> +       __u8    PathBuffer[]; /* Variable Length */
>  } __packed;
>
>  #define SYMLINK_FLAG_RELATIVE 0x00000001
> @@ -964,7 +964,7 @@ struct reparse_symlink_data_buffer {
>         __le16  PrintNameOffset;
>         __le16  PrintNameLength;
>         __le32  Flags;
> -       __u8    PathBuffer[0]; /* Variable Length */
> +       __u8    PathBuffer[]; /* Variable Length */
>  } __packed;
>
>  /* See MS-FSCC 2.1.2.6 and cifspdu.h for struct reparse_posix_data */
> @@ -1066,7 +1066,7 @@ struct smb2_ioctl_req {
>         __le32 MaxOutputResponse;
>         __le32 Flags;
>         __u32  Reserved2;
> -       __u8   Buffer[0];
> +       __u8   Buffer[];
>  } __packed;
>
>  struct smb2_ioctl_rsp {
> @@ -1469,7 +1469,7 @@ struct smb3_fs_vol_info {
>         __le32  VolumeLabelLength; /* includes trailing null */
>         __u8    SupportsObjects; /* True if eg like NTFS, supports objects */
>         __u8    Reserved;
> -       __u8    VolumeLabel[0]; /* variable len */
> +       __u8    VolumeLabel[]; /* variable len */
>  } __packed;
>
>  /* partial list of QUERY INFO levels */
> @@ -1531,7 +1531,7 @@ struct smb2_file_rename_info { /* encoding of request for level 10 */
>         __u8   Reserved[7];
>         __u64  RootDirectory;  /* MBZ for network operations (why says spec?) */
>         __le32 FileNameLength;
> -       char   FileName[0];     /* New name to be assigned */
> +       char   FileName[];     /* New name to be assigned */
>  } __packed; /* level 10 Set */
>
>  struct smb2_file_link_info { /* encoding of request for level 11 */
> @@ -1540,7 +1540,7 @@ struct smb2_file_link_info { /* encoding of request for level 11 */
>         __u8   Reserved[7];
>         __u64  RootDirectory;  /* MBZ for network operations (why says spec?) */
>         __le32 FileNameLength;
> -       char   FileName[0];     /* Name to be assigned to new link */
> +       char   FileName[];     /* Name to be assigned to new link */
>  } __packed; /* level 11 Set */
>
>  struct smb2_file_full_ea_info { /* encoding of response for level 15 */
> @@ -1548,7 +1548,7 @@ struct smb2_file_full_ea_info { /* encoding of response for level 15 */
>         __u8   flags;
>         __u8   ea_name_length;
>         __le16 ea_value_length;
> -       char   ea_data[0]; /* \0 terminated name plus value */
> +       char   ea_data[]; /* \0 terminated name plus value */
>  } __packed; /* level 15 Set */
>
>  /*
> --
> 2.25.0
>


-- 
Thanks,

Steve
