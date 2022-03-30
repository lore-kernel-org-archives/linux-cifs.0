Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1384DC433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 30 Mar 2022 07:53:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241229AbiC3HzY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 30 Mar 2022 03:55:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243123AbiC3HzW (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 30 Mar 2022 03:55:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67A0321832
        for <linux-cifs@vger.kernel.org>; Wed, 30 Mar 2022 00:53:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3048617E3
        for <linux-cifs@vger.kernel.org>; Wed, 30 Mar 2022 07:53:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64DA8C34111
        for <linux-cifs@vger.kernel.org>; Wed, 30 Mar 2022 07:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648626815;
        bh=YRcFa58DUkKe3XYT5crbDATOZa4uCoXnyOx3yR1M/Sc=;
        h=From:Date:Subject:To:Cc:From;
        b=ihn46zkENmvaM5aeXEGAf9poSoxoCgEvUEMwF1OEi3Iv5OOk9NyaB/FY7lHRgr9Ww
         0uSfDPc4KVIT2oraU5wobair32SzhSfGTOm794rJYsTxSpJ78eFO8ljIi3Ujzt1PVX
         RlxEK5wnxwU1WDlRv2LvhjiKz77owg8XfgdxudXppde0SmtJ8shRlQWbZWHY1xvdMH
         ZiVjYKtGDNzFdc5WqWwBXIsbjc53vGDFf0x5dxo3fWxsrEdeBA0tcRvwajEQl7HXwT
         ezsF3SwJjzcz1/hhXEWnMNFp0uHuRbOWjCk+NwD9SkIjwqcBZ5Drz/A+d4vKPvyLE9
         JgjaINiDwefrg==
Received: by mail-wm1-f53.google.com with SMTP id v64-20020a1cac43000000b0038cfd1b3a6dso659349wme.5
        for <linux-cifs@vger.kernel.org>; Wed, 30 Mar 2022 00:53:35 -0700 (PDT)
X-Gm-Message-State: AOAM5329X/MifQEHc2rOQH1I4rFJCSwiiQu9wBMVwWOAjmU3HvxtADwv
        xXydCcqJxCCF2WTpxPsP1USK5N+KyM0N1+SGcaY=
X-Google-Smtp-Source: ABdhPJyNOT0QJ1rMWF5Bi9rJc3C3J4MsO8bOq84px9v7SNkSfavw1F/tCmFhd2xwXImA9hY7LTQH20mwadoxYa5VMgk=
X-Received: by 2002:a05:600c:4fcd:b0:38c:7495:e644 with SMTP id
 o13-20020a05600c4fcd00b0038c7495e644mr3244185wmq.102.1648626813594; Wed, 30
 Mar 2022 00:53:33 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6000:2c1:0:0:0:0 with HTTP; Wed, 30 Mar 2022 00:53:32
 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Wed, 30 Mar 2022 16:53:32 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_XMW1-VSLwB=k3ypqgqjsux5OFNnr=Ri3B+-8w4aNHjw@mail.gmail.com>
Message-ID: <CAKYAXd_XMW1-VSLwB=k3ypqgqjsux5OFNnr=Ri3B+-8w4aNHjw@mail.gmail.com>
Subject: Regarding to how ksmbd handles sector size request from windows cllient
To:     Christoph Hellwig <hch@lst.de>,
        Christoph Hellwig <hch@infradead.org>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Hyeoncheol Lee <hyc.lee@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Tom Talpey <tom@talpey.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Christoph,

I have a question about the problem of poking into the block layer in ksmbd.

There is FileFsSectorSizeInformation command in SMB. And MS-FSCC
Specification describe it like the following.

FileFsSectorSizeInformation : This information class is used to query
for the extended sector size and alignment information for a volume.

------------------------------------------------>8----------------------------------------------------------------
/* sector size info struct */
struct smb3_fs_ss_info {
        __le32 LogicalBytesPerSector;
        __le32 PhysicalBytesPerSectorForAtomicity;
        __le32 PhysicalBytesPerSectorForPerf;
        __le32 FSEffPhysicalBytesPerSectorForAtomicity;
        __le32 Flags;
        __le32 ByteOffsetForSectorAlignment;
        __le32 ByteOffsetForPartitionAlignment;
} __packed;

LogicalBytesPerSector (4 bytes): A 32-bit unsigned integer that
contains the number of bytes in a logical sector for the device
backing the volume. This field is the unit of logical addressing for
the device and is not the unit of atomic write. Applications SHOULD
NOT utilize this value for operations requiring physical sector
alignment.

PhysicalBytesPerSectorForAtomicity (4 bytes): A 32-bit unsigned
integer that contains the
number of bytes in a physical sector for the device backing the
volume. Note that this is the
reported physical sector size of the device and is the unit of atomic
write. Applications
SHOULD<152> utilize this value for operations requiring sector alignment.
---------------------------------------------------------------------------------------------------------------------

I have received a report that the problem occurs when mounting an iso
file through windows client on ksmbd & zfs share.

https://github.com/cifsd-team/ksmbd-tools/issues/233

More detailed error message can be obtained using Mount-DiskImage
command, the error is:
"Mount-DiskImage : The sector size of the physical disk on which the
virtual disk resides is not supported."

zfs block size is 128KB, and there is a problem when ksmbd responds to
this value as a sector size to the windows client.
This seems to judge as an error when a Windows client requests sector
size information from the server and receives a value larger than 4KB.

If the logical/physical_block_size is obtained from the block layer in
ksmbd, You might think of this as a layer violation.
e.g. i_sb->s_bdev->bd_disk->queue->limits.logical_block_size.

So I am confused as to how to fix this issue. and I'd like to hear
your thoughts on how to fix this correctly.

Thanks!
