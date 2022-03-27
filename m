Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 836D7C433F5
	for <linux-cifs@archiver.kernel.org>; Sun, 27 Mar 2022 03:30:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233747AbiC0DcK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 26 Mar 2022 23:32:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233718AbiC0DcJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 26 Mar 2022 23:32:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 582115AA62
        for <linux-cifs@vger.kernel.org>; Sat, 26 Mar 2022 20:30:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E5C1860C7E
        for <linux-cifs@vger.kernel.org>; Sun, 27 Mar 2022 03:30:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C76FC340EC
        for <linux-cifs@vger.kernel.org>; Sun, 27 Mar 2022 03:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648351831;
        bh=WvVSqjIdWKpPNfu65JrCXTXJ9Jcl1eMK4rGFFDuC+WA=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=UdHvRyeKNY3/by4CxdUFRMYdA8FhjKuOvKMjtRAYwaB/vdUP5CMNsGGK4FS1ZdcNz
         mo5eOwJN7Pjn9HhK4UfRrJpP5CU/KvVSVpDYv9HWeF80jp9TrkDLAA5yk8kkUGNUVU
         f2ctJAd85GYHqqSMMDQBpj8yjChewGxKhaTE+lUeTedQup4QbzIHSGkkD5+c8/tQw5
         bOCsCWAO00ojOctrxY3xkwHe8MJZddnthXm7SvRhFmF35mygwcDyh8v76txGzwW0wK
         Z6JlVIn6RmBhAxdblfq6rZVgHxpwBycmC2hrxp4nQkVcxacGJOyqtEaUOCObwWljGx
         Kjt/P5ekYKj1A==
Received: by mail-wr1-f44.google.com with SMTP id w21so11194663wra.2
        for <linux-cifs@vger.kernel.org>; Sat, 26 Mar 2022 20:30:31 -0700 (PDT)
X-Gm-Message-State: AOAM532VpIbGyEz8JqWyKOHynZKlOAexb5OIT3dgz6bOBAVPDZTpUr6L
        SXL4uGbyeHQkv3NyW1I0ocPR2ikKjmVu4U583Iw=
X-Google-Smtp-Source: ABdhPJznqKqobnNG3jFW87K89bB2SQt81qrsEBuPenZQdg00cK8XWrVWsOUwBpfdGZVkgOi8OrqWd+mQWicfRUti734=
X-Received: by 2002:a5d:47a5:0:b0:203:d4fd:4653 with SMTP id
 5-20020a5d47a5000000b00203d4fd4653mr15786208wrb.229.1648351829564; Sat, 26
 Mar 2022 20:30:29 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6000:2c1:0:0:0:0 with HTTP; Sat, 26 Mar 2022 20:30:29
 -0700 (PDT)
In-Reply-To: <CAH2r5mtZxxnDYTZfoQ1Y+hwn77-zJuFytBxzVAyMKZBQwN+rEw@mail.gmail.com>
References: <CAH2r5muFUWGfK8LTrZA6wFD+XbG51RRM3dNyqEvA4B3mLiAkmA@mail.gmail.com>
 <CAH2r5mt0ZHuFoUcFKEgX6tejJ+xT9Y4zpYSEwYKSdGiROT6pZA@mail.gmail.com>
 <CAKYAXd_PEF7-_pf+AjoA-igO5e9nPaGgOepdeDTNHLsnz6413w@mail.gmail.com> <CAH2r5mtZxxnDYTZfoQ1Y+hwn77-zJuFytBxzVAyMKZBQwN+rEw@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sun, 27 Mar 2022 12:30:29 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9HjSeybk+vvE6YyoUaVs6XsYyx+7voZDEmuN2fLnNQug@mail.gmail.com>
Message-ID: <CAKYAXd9HjSeybk+vvE6YyoUaVs6XsYyx+7voZDEmuN2fLnNQug@mail.gmail.com>
Subject: Re: [PATCH][SMB3] move more protocol header definitions to fs/smbfs_common
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-03-27 11:29 GMT+09:00, Steve French <smfrench@gmail.com>:
> I think this was removed in the next patch (I don't see the warning,
> but presumably it is the blank line before the #endif at the end of
> the file?)

The change below is adding 2 blank lines.

+struct smb2_ioctl_rsp {
+       struct smb2_hdr hdr;
+       __le16 StructureSize; /* Must be 49 */
+       __le16 Reserved;
+       __le32 CtlCode;
+       __u64  PersistentFileId;
+       __u64  VolatileFileId;
+       __le32 InputOffset; /* Reserved MBZ */
+       __le32 InputCount;
+       __le32 OutputOffset;
+       __le32 OutputCount;
+       __le32 Flags;
+       __le32 Reserved2;
+       __u8   Buffer[];
+} __packed;
+
+
 /* Possible InfoType values */

Thanks!

>
> On Sat, Mar 26, 2022 at 7:52 PM Namjae Jeon <linkinjeon@kernel.org> wrote:
>>
>> 2022-03-27 2:59 GMT+09:00, Steve French <smfrench@gmail.com>:
>> > Updated the patch slightly to replace define that had Buffer[0] with
>> > Buffer[]
>> Minor nit, We can remove multiple blank lines in the patch.
>>
>> CHECK: Please don't use multiple blank lines
>> #390: FILE: fs/smbfs_common/smb2pdu.h:1124:
>> +
>> +
>>
>> Otherwise, Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
>>
>> Thanks!
>> >
>> > On Sat, Mar 26, 2022 at 12:55 PM Steve French <smfrench@gmail.com>
>> > wrote:
>> >>
>> >> Move defines for ioctl protocol header and various size to
>> >> smbfs_common
>> >>
>> >> The definitions for the ioctl SMB3 request and response as well
>> >> as length of various fields defined in the protocol documentation
>> >> were duplicated in fs/ksmbd and fs/cifs.  Move these to the common
>> >> code in fs/smbfs_common/smb2pdu.h
>> >>
>> >> See attached
>> >>
>> >>
>> >> --
>> >> Thanks,
>> >>
>> >> Steve
>> >
>> >
>> >
>> > --
>> > Thanks,
>> >
>> > Steve
>> >
>
>
>
> --
> Thanks,
>
> Steve
>
