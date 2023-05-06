Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D015C7EE21
	for <linux-cifs@archiver.kernel.org>; Sat,  6 May 2023 04:49:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbjEFEtT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 6 May 2023 00:49:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbjEFEtS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 6 May 2023 00:49:18 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B35B7DAD
        for <linux-cifs@vger.kernel.org>; Fri,  5 May 2023 21:49:17 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id 2adb3069b0e04-4f13a72ff53so2873386e87.0
        for <linux-cifs@vger.kernel.org>; Fri, 05 May 2023 21:49:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683348555; x=1685940555;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=wNVhZJFovtfiMt8SsZ2Nw2Vrkye4RdETHXJSnQJ+Rs8=;
        b=YpEXoX0s9H6ErnPYaTftgC4zR9CecrTCvEoxGkesFJ8+wt9atrgxCLpRuZlLkSETR9
         beEISmzewjmW02cnGTvM+cSwcKB9SJY3fTmgHIuyih4G/jUSlC4lFJC0GCyatSg7Vh1e
         4TELymkIhVIqiPcR1cacUmmXyk+u6SE7AU1WqYUTWwNY6VVIU9p9C5+/XajbNnTHEiXq
         MsNla1x9crMi962NTFz/VHuUbbcIfHqwHwGhw1QDMzczkya59jhI+i3tJGv/zoS3BmmX
         xhtfhQiBQlud9YHHNeOwxIz1GEX/lticpFjASU16glaS8FhI+kexMvZlhHJRtkW4meOc
         +efg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683348555; x=1685940555;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wNVhZJFovtfiMt8SsZ2Nw2Vrkye4RdETHXJSnQJ+Rs8=;
        b=TCa5gYh7Dja3suNBYImMBndy7KudBMXEvtoVuRTdmHUBW0YZoAGdBrR09Q9TG4Gewu
         IuDCArEnQFcFAC2L0Tk6vtPaswvrkbmy54FUFEHe38IHkLRfjiN67fE+AF5vEQsT7B3b
         qOfpOFJXWgdTPCKefUKUX2iVadwNEAlONOq77E4KAzqc+QYRWlfhbBnhdQ/SsiEOwnLq
         qjkT5IJVuYBS8Ok0cFZfyHWl9abfijTY9UjOymyPK0v8kmZTZg3HNtn9FbJiK+xmSBbo
         FRfBt4Xb+dtVYimMWnY4s7keG7B2ewNRgUswZirI+pJSZy4MTTFNy9jbgaOCRCb79iRv
         W0Ew==
X-Gm-Message-State: AC+VfDzHjiDhIqSfg1R+UlnRGedl1DVwn/skb5ubPBMd3PwFyPX2SWNV
        UYDR2zn0gekXoDcVSf9jIqvgXGhuD2u4qwabwHt8sbAvbX0=
X-Google-Smtp-Source: ACHHUZ75cBD40JxTA4Rxe33bTEwp1SXo9vUgrXnw6CQSgMxb/jVPWPdWWeP/rZzGgUUN7EQHfLG0uv4YA+tmgGdAuNw=
X-Received: by 2002:a19:f50a:0:b0:4e9:c327:dd81 with SMTP id
 j10-20020a19f50a000000b004e9c327dd81mr1003084lfb.63.1683348555457; Fri, 05
 May 2023 21:49:15 -0700 (PDT)
MIME-Version: 1.0
References: <4b402539-1b98-bfe6-fa60-d73d13794077@gmail.com>
 <CAH2r5mszw6sayQfJqiYwTjPCqKDB7Dk-Hmtr0-Z3fXf=e3t0aQ@mail.gmail.com>
 <824c8a05-4c68-119e-45a9-504ea0aa8583@gmail.com> <CAH2r5mvCCY=VT9ZUkjz4c+QGZ0MjR4ggdG56QUa-apZ7eoeo0A@mail.gmail.com>
In-Reply-To: <CAH2r5mvCCY=VT9ZUkjz4c+QGZ0MjR4ggdG56QUa-apZ7eoeo0A@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 5 May 2023 23:49:04 -0500
Message-ID: <CAH2r5muOMc1ks+RJeC0uV30pwgH7iaUeag0C5=4biy8dHURkdA@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix pcchunk length type in smb2_copychunk_range
To:     Pawel Witek <pawel.ireneusz.witek@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000ae8f9105faff20b3"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000ae8f9105faff20b3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Wouldn't it be safer (since pcchunk->Length is a u32 to do the
following minor change to your patch

                pcchunk->Length =3D
-                       cpu_to_le32(min_t(u32, len, tcon->max_bytes_chunk))=
;
+                       cpu_to_le32(min_t(u64, len, tcon->max_bytes_chunk))=
;

Also added Cc: stable and Fixes: tags.  See attached.

On Fri, May 5, 2023 at 2:48=E2=80=AFPM Steve French <smfrench@gmail.com> wr=
ote:
>
> Good catch
>
> On Fri, May 5, 2023, 14:31 Pawel Witek <pawel.ireneusz.witek@gmail.com> w=
rote:
>>
>> I've tried to copy a 5 GB file which resulted in -EINVAL (same for large=
r
>> files). After wiresharking the protocol I've observed that one packet
>> requests ioctl with 'Transfer Length: 0', to which the server responded
>> with an error. Some investigation showed, that this happens when
>> len=3D4294967296.
>>
>> On 5/5/23 18:47, Steve French wrote:
>> > since pcchunk->Length is a 32 bit field doing cpu_to_le64 seems wrong.
>> >
>> > Perhaps one option is to split this into two lines do the minimum(u64,=
 len, tcon->max_bytes_chunk) on one line and the cpu_to_le32 of the result =
on the next
>> >
>> > What is "len" in the example you see failing?
>> >
>> > On Fri, May 5, 2023 at 10:15=E2=80=AFAM Pawel Witek <pawel.ireneusz.wi=
tek@gmail.com <mailto:pawel.ireneusz.witek@gmail.com>> wrote:
>> >
>> >     Change type of pcchunk->Length from u32 to u64 to match
>> >     smb2_copychunk_range arguments type. Fixes the problem where perfo=
rming
>> >     server-side copy with CIFS_IOC_COPYCHUNK_FILE ioctl resulted in in=
complete
>> >     copy of large files while returning -EINVAL.
>> >
>> >     Signed-off-by: Pawel Witek <pawel.ireneusz.witek@gmail.com <mailto=
:pawel.ireneusz.witek@gmail.com>>
>> >     ---
>> >      fs/cifs/smb2ops.c | 2 +-
>> >      1 file changed, 1 insertion(+), 1 deletion(-)
>> >
>> >     diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
>> >     index a81758225fcd..35c7c35882c9 100644
>> >     --- a/fs/cifs/smb2ops.c
>> >     +++ b/fs/cifs/smb2ops.c
>> >     @@ -1682,7 +1682,7 @@ smb2_copychunk_range(const unsigned int xid,
>> >                     pcchunk->SourceOffset =3D cpu_to_le64(src_off);
>> >                     pcchunk->TargetOffset =3D cpu_to_le64(dest_off);
>> >                     pcchunk->Length =3D
>> >     -                       cpu_to_le32(min_t(u32, len, tcon->max_byte=
s_chunk));
>> >     +                       cpu_to_le64(min_t(u64, len, tcon->max_byte=
s_chunk));
>> >
>> >                     /* Request server copy to target from src identifi=
ed by key */
>> >                     kfree(retbuf);
>> >     --
>> >     2.40.1
>> >
>> >
>> >
>> >
>> > --
>> > Thanks,
>> >
>> > Steve



--=20
Thanks,

Steve

--000000000000ae8f9105faff20b3
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-fix-pcchunk-length-type-in-smb2_copychunk_range.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-fix-pcchunk-length-type-in-smb2_copychunk_range.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lhbi9c1s0>
X-Attachment-Id: f_lhbi9c1s0

RnJvbSA0MzFiYmI0ODBkMDVjZGY1ZDc0NTdjMmFlNDE3YWY3MmU1Y2ViYzgyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBQYXdlbCBXaXRlayA8cGF3ZWwuaXJlbmV1c3oud2l0ZWtAZ21h
aWwuY29tPgpEYXRlOiBGcmksIDUgTWF5IDIwMjMgMTc6MTQ6NTkgKzAyMDAKU3ViamVjdDogW1BB
VENIXSBjaWZzOiBmaXggcGNjaHVuayBsZW5ndGggdHlwZSBpbiBzbWIyX2NvcHljaHVua19yYW5n
ZQoKQ2hhbmdlIHR5cGUgb2YgcGNjaHVuay0+TGVuZ3RoIGZyb20gdTMyIHRvIHU2NCB0byBtYXRj
aApzbWIyX2NvcHljaHVua19yYW5nZSBhcmd1bWVudHMgdHlwZS4gRml4ZXMgdGhlIHByb2JsZW0g
d2hlcmUgcGVyZm9ybWluZwpzZXJ2ZXItc2lkZSBjb3B5IHdpdGggQ0lGU19JT0NfQ09QWUNIVU5L
X0ZJTEUgaW9jdGwgcmVzdWx0ZWQgaW4gaW5jb21wbGV0ZQpjb3B5IG9mIGxhcmdlIGZpbGVzIHdo
aWxlIHJldHVybmluZyAtRUlOVkFMLgoKRml4ZXM6IDliZjBjOWNkNDMxNCAoIkNJRlM6IEZpeCBT
TUIyL1NNQjMgQ29weSBvZmZsb2FkIHN1cHBvcnQgKHJlZmNvcHkpIGZvciBsYXJnZSBmaWxlcyIp
CkNjOiA8c3RhYmxlQHZnZXIua2VybmVsLm9yZz4KU2lnbmVkLW9mZi1ieTogUGF3ZWwgV2l0ZWsg
PHBhd2VsLmlyZW5ldXN6LndpdGVrQGdtYWlsLmNvbT4KU2lnbmVkLW9mZi1ieTogU3RldmUgRnJl
bmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29tPgotLS0KIGZzL2NpZnMvc21iMm9wcy5jIHwgMiAr
LQogMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0t
Z2l0IGEvZnMvY2lmcy9zbWIyb3BzLmMgYi9mcy9jaWZzL3NtYjJvcHMuYwppbmRleCBhODE3NTgy
MjVmY2QuLmEyOTVlNGMyZDU0ZSAxMDA2NDQKLS0tIGEvZnMvY2lmcy9zbWIyb3BzLmMKKysrIGIv
ZnMvY2lmcy9zbWIyb3BzLmMKQEAgLTE2ODIsNyArMTY4Miw3IEBAIHNtYjJfY29weWNodW5rX3Jh
bmdlKGNvbnN0IHVuc2lnbmVkIGludCB4aWQsCiAJCXBjY2h1bmstPlNvdXJjZU9mZnNldCA9IGNw
dV90b19sZTY0KHNyY19vZmYpOwogCQlwY2NodW5rLT5UYXJnZXRPZmZzZXQgPSBjcHVfdG9fbGU2
NChkZXN0X29mZik7CiAJCXBjY2h1bmstPkxlbmd0aCA9Ci0JCQljcHVfdG9fbGUzMihtaW5fdCh1
MzIsIGxlbiwgdGNvbi0+bWF4X2J5dGVzX2NodW5rKSk7CisJCQljcHVfdG9fbGUzMihtaW5fdCh1
NjQsIGxlbiwgdGNvbi0+bWF4X2J5dGVzX2NodW5rKSk7CiAKIAkJLyogUmVxdWVzdCBzZXJ2ZXIg
Y29weSB0byB0YXJnZXQgZnJvbSBzcmMgaWRlbnRpZmllZCBieSBrZXkgKi8KIAkJa2ZyZWUocmV0
YnVmKTsKLS0gCjIuMzQuMQoK
--000000000000ae8f9105faff20b3--
