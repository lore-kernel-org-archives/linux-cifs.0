Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2735FC77B75
	for <linux-cifs@archiver.kernel.org>; Sat,  6 May 2023 08:06:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231443AbjEFIGH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 6 May 2023 04:06:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230450AbjEFIGG (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 6 May 2023 04:06:06 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6CF893E6
        for <linux-cifs@vger.kernel.org>; Sat,  6 May 2023 01:06:03 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id 2adb3069b0e04-4f00d41df22so20133018e87.1
        for <linux-cifs@vger.kernel.org>; Sat, 06 May 2023 01:06:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683360362; x=1685952362;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9OZWUagey7z0c7RtHnHlQx+rkc8Wn9ftjEHjFVnackg=;
        b=IpLjWdwk/lzLl4kXjZulPn0n2C8r6FVQLHpq81eKmwGiqeetGCrwNhZIomstT+3fsl
         uem64KaEJ7IR1U/Ppv/9JMM7p5r2Mn0EEoeYK5CqDUGvCKwivbhzQEYpwdmXvjWoGT9r
         8n7Zl4YargVgXIKDSJXi85TUeexGFTT1PHgZtIpc3bBle/HUgyZcAF4PtR9/OPA0xQg6
         +VNhix9jbtzcamAmF+YYT3ELV4HRxnwuJKITo39Kcbvob8TMHQmYXpOzXiDw0gpPd2Nu
         Xi8hLHr4hvC07Gb9jUm+222d1MxTji55tynUDHNl1yNy3yhAewX3vv0TKMMtaQrnHriZ
         A02Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683360362; x=1685952362;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9OZWUagey7z0c7RtHnHlQx+rkc8Wn9ftjEHjFVnackg=;
        b=PCyaOGRlhhLVI2C6ArFe9B2di4zYjI4SknQ4sGaMk++fNvMIFgAfwIMGAuptQZbVXL
         1R0RDvDI6m1Bz1oH6E1PYXGDPqDcGb5ykv8gLkxhV/lflJRcGO4CX2ZHh8+OWhKnctmA
         FRwxet9XoHW8gGfcHe1DCoHz5gi4br+navquSGS7wjC/Szv07uiPv7wTkTRRdArgoyYB
         tI9f2Eui+GZbgFDCVd/IL2WUVVa6nCrHS2+WjKFWBUiDEXmIOdp50NDdJW9+5Mc1AjVb
         1Xb4/RHlvFojwRj6NTEXM1LnzaGl6Jg87GRhTa29g9Tah5vazLaD8h8VZgr+hZ27dk8N
         DvOA==
X-Gm-Message-State: AC+VfDz92XfmMNI9h2EdF2LEJ35TKHL9/0dxQddOd3fJ7d0NOB1pps9r
        Xw+VqAaciomNPS+eXJd+fZw=
X-Google-Smtp-Source: ACHHUZ6O2ajN3FUspUMZ3G1P4AHlnuHsnkVXZW4J0ELbhLuy+yMwzHAl3ecrY1ipRq0PV82ofLR3Ww==
X-Received: by 2002:ac2:5387:0:b0:4b6:fddc:1fcd with SMTP id g7-20020ac25387000000b004b6fddc1fcdmr1224762lfh.23.1683360361854;
        Sat, 06 May 2023 01:06:01 -0700 (PDT)
Received: from [10.10.10.110] ([94.231.1.83])
        by smtp.gmail.com with ESMTPSA id z8-20020ac24f88000000b004eff6dd9072sm574532lfs.111.2023.05.06.01.06.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 06 May 2023 01:06:01 -0700 (PDT)
Message-ID: <478cf3a9-b1bc-d170-3176-5cd67e5e63d3@gmail.com>
Date:   Sat, 6 May 2023 10:06:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH] cifs: fix pcchunk length type in smb2_copychunk_range
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
References: <4b402539-1b98-bfe6-fa60-d73d13794077@gmail.com>
 <CAH2r5mszw6sayQfJqiYwTjPCqKDB7Dk-Hmtr0-Z3fXf=e3t0aQ@mail.gmail.com>
 <824c8a05-4c68-119e-45a9-504ea0aa8583@gmail.com>
 <CAH2r5mvCCY=VT9ZUkjz4c+QGZ0MjR4ggdG56QUa-apZ7eoeo0A@mail.gmail.com>
 <CAH2r5muOMc1ks+RJeC0uV30pwgH7iaUeag0C5=4biy8dHURkdA@mail.gmail.com>
 <CAH2r5muUUTxNesxPRO=2TRDSZ7GFqTLJxEpmaYWj2aTzEps1Ng@mail.gmail.com>
Content-Language: en-US
From:   Pawel Witek <pawel.ireneusz.witek@gmail.com>
In-Reply-To: <CAH2r5muUUTxNesxPRO=2TRDSZ7GFqTLJxEpmaYWj2aTzEps1Ng@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

You're right, that does look better and safer :)

On 5/6/23 06:51, Steve French wrote:
> I was also able to reproduce it by using xfs_io to execute copy_range
> on a file of exactly 4GB and verified that the patches (both versions)
> fix it.
> 
> On Fri, May 5, 2023 at 11:49 PM Steve French <smfrench@gmail.com> wrote:
>>
>> Wouldn't it be safer (since pcchunk->Length is a u32 to do the
>> following minor change to your patch
>>
>>                 pcchunk->Length =
>> -                       cpu_to_le32(min_t(u32, len, tcon->max_bytes_chunk));
>> +                       cpu_to_le32(min_t(u64, len, tcon->max_bytes_chunk));
>>
>> Also added Cc: stable and Fixes: tags.  See attached.
>>
>> On Fri, May 5, 2023 at 2:48 PM Steve French <smfrench@gmail.com> wrote:
>>>
>>> Good catch
>>>
>>> On Fri, May 5, 2023, 14:31 Pawel Witek <pawel.ireneusz.witek@gmail.com> wrote:
>>>>
>>>> I've tried to copy a 5 GB file which resulted in -EINVAL (same for larger
>>>> files). After wiresharking the protocol I've observed that one packet
>>>> requests ioctl with 'Transfer Length: 0', to which the server responded
>>>> with an error. Some investigation showed, that this happens when
>>>> len=4294967296.
>>>>
>>>> On 5/5/23 18:47, Steve French wrote:
>>>>> since pcchunk->Length is a 32 bit field doing cpu_to_le64 seems wrong.
>>>>>
>>>>> Perhaps one option is to split this into two lines do the minimum(u64, len, tcon->max_bytes_chunk) on one line and the cpu_to_le32 of the result on the next
>>>>>
>>>>> What is "len" in the example you see failing?
>>>>>
>>>>> On Fri, May 5, 2023 at 10:15 AM Pawel Witek <pawel.ireneusz.witek@gmail.com <mailto:pawel.ireneusz.witek@gmail.com>> wrote:
>>>>>
>>>>>     Change type of pcchunk->Length from u32 to u64 to match
>>>>>     smb2_copychunk_range arguments type. Fixes the problem where performing
>>>>>     server-side copy with CIFS_IOC_COPYCHUNK_FILE ioctl resulted in incomplete
>>>>>     copy of large files while returning -EINVAL.
>>>>>
>>>>>     Signed-off-by: Pawel Witek <pawel.ireneusz.witek@gmail.com <mailto:pawel.ireneusz.witek@gmail.com>>
>>>>>     ---
>>>>>      fs/cifs/smb2ops.c | 2 +-
>>>>>      1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>
>>>>>     diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
>>>>>     index a81758225fcd..35c7c35882c9 100644
>>>>>     --- a/fs/cifs/smb2ops.c
>>>>>     +++ b/fs/cifs/smb2ops.c
>>>>>     @@ -1682,7 +1682,7 @@ smb2_copychunk_range(const unsigned int xid,
>>>>>                     pcchunk->SourceOffset = cpu_to_le64(src_off);
>>>>>                     pcchunk->TargetOffset = cpu_to_le64(dest_off);
>>>>>                     pcchunk->Length =
>>>>>     -                       cpu_to_le32(min_t(u32, len, tcon->max_bytes_chunk));
>>>>>     +                       cpu_to_le64(min_t(u64, len, tcon->max_bytes_chunk));
>>>>>
>>>>>                     /* Request server copy to target from src identified by key */
>>>>>                     kfree(retbuf);
>>>>>     --
>>>>>     2.40.1
>>>>>
>>>>>
>>>>>
>>>>>
>>>>> --
>>>>> Thanks,
>>>>>
>>>>> Steve
>>
>>
>>
>> --
>> Thanks,
>>
>> Steve
> 
> 
> 
