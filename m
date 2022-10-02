Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C982C433FE
	for <linux-cifs@archiver.kernel.org>; Sun,  2 Oct 2022 04:01:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbiJBEBu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 2 Oct 2022 00:01:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiJBEBt (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 2 Oct 2022 00:01:49 -0400
Received: from mail-vk1-xa2f.google.com (mail-vk1-xa2f.google.com [IPv6:2607:f8b0:4864:20::a2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ED79193E2
        for <linux-cifs@vger.kernel.org>; Sat,  1 Oct 2022 21:01:48 -0700 (PDT)
Received: by mail-vk1-xa2f.google.com with SMTP id k14so4088331vkk.0
        for <linux-cifs@vger.kernel.org>; Sat, 01 Oct 2022 21:01:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date;
        bh=frD2tspOfbluMGzPF/+MsIp8eKrwPchyS8WQzZS0cEw=;
        b=pyytCyuUAZKS+Jp/Ig4XHght+9rdo51AmPI9xrF9dx4iZQ8CK1YuDWrpJ08IXZ/Qzn
         GqA5yDmNdSeANPAht3LBRj3sT0B4UvycsDo1pG+xPIpRaUYD0IA1CDP2yoJQUHimRRDE
         VVaBX7b2LUgN/XvOgJXe36JEDRHZRT5t8WDmMR/c3oFTP5ZOgZzfH2eD+6v9q8VONKfb
         pfPVo7Yvr8x+Obc3xrgp85tXdQhvnUYppw9tgeuVAPSdvTvtZuP30IDeWo+3k8kNKK1q
         AeMVLye+k+AFezEvvQGFqHuELFYZjrl/6/IglLYDkJY3Z1ff71t7vDBOHL619B64FAgk
         HWoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=frD2tspOfbluMGzPF/+MsIp8eKrwPchyS8WQzZS0cEw=;
        b=Y2mgmhQTdWUZJLVQ3D7bsvpktJHxMmXNZxVjOa9cIelIcsXQOcOExeLLav/lbn41rY
         wPeHrqkqJJ8GTBBkymQJH3aVkGepHxt5WRHiRUuMC3UWLU7fw5bAzpGOw3NA5eedItfS
         2Ig/JiFRLZ2GMw7NzLgD3dadVrUNJZFNXJDI8h9+wvAcnHbgiZDD/ZrTau9B0msszYtb
         6/Ol6bPfXrcCGn5Wo7c7RLhK1XSauEVZ97faYmH4c4Dk6utc9gXpf/8N/I4/givSbDAQ
         eoZgwpzqNvF/g1x8RvCUe96ffmzhcaZCwC68pZ+TvdOwtoiPjkQnoP3O+g6Ry8DRj8Kx
         Orcg==
X-Gm-Message-State: ACrzQf096+tRhHjkL5a6dxNFVSJ4ZMB0S34KuftG7ktmlNQ9FSyScX6L
        UfC0pNWfCBBQ16o6aAJk1l8+a/GE2vvR61+5Ze2LF0in
X-Google-Smtp-Source: AMsMyM4FgtckvR8L7vympMvig/WfTapEqo+WQZ9iWuaLwpSCjDYUVdiFi8hB0yuQ0BbhbrnkPgkn/6xBqaZHg1TMJ4g=
X-Received: by 2002:a05:6122:1043:b0:3a9:9506:c34e with SMTP id
 z3-20020a056122104300b003a99506c34emr2792984vkn.38.1664683307394; Sat, 01 Oct
 2022 21:01:47 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvM6a4dU3d7Mxer9jWP0xkA2hyF9PrkwreES5T11W9O9w@mail.gmail.com>
In-Reply-To: <CAH2r5mvM6a4dU3d7Mxer9jWP0xkA2hyF9PrkwreES5T11W9O9w@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 1 Oct 2022 23:01:36 -0500
Message-ID: <CAH2r5mtoZRrCY-jDCH72DSNXPMxYiu24cuRRguLyXDx6zKUvwg@mail.gmail.com>
Subject: Re: new SMB3.1.1 create contexts
To:     samba-technical <samba-technical@lists.samba.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="00000000000033e9c305ea054963"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--00000000000033e9c305ea054963
Content-Type: text/plain; charset="UTF-8"

patch attached to add the four missing create context IDs to the kernel

On Sat, Oct 1, 2022 at 6:50 PM Steve French <smfrench@gmail.com> wrote:
>
> Noticed a few SMB3.1.1 create contexts missing from the Linux kernel
> code.  Any more beyond these four that are still missing?
>
> diff --git a/fs/smbfs_common/smb2pdu.h b/fs/smbfs_common/smb2pdu.h
> index 2cab413fffee..7d605db3bb3b 100644
> --- a/fs/smbfs_common/smb2pdu.h
> +++ b/fs/smbfs_common/smb2pdu.h
> @@ -1101,7 +1101,11 @@ struct smb2_change_notify_rsp {
>  #define SMB2_CREATE_REQUEST_LEASE              "RqLs"
>  #define SMB2_CREATE_DURABLE_HANDLE_REQUEST_V2  "DH2Q"
>  #define SMB2_CREATE_DURABLE_HANDLE_RECONNECT_V2        "DH2C"
> -#define SMB2_CREATE_TAG_POSIX
> "\x93\xAD\x25\x50\x9C\xB4\x11\xE7\xB4\x23\x83\xDE\x96\x8B\xCD\x7C"
> +#define SMB2_CREATE_TAG_POSIX
> "\x93\xAD\x25\x50\x9C\xB4\x11\xE7\xB4\x23\x83\xDE\x96\x8B\xCD\x7C"
> +#define SMB2_CREATE_APP_INSTANCE_ID
> "\x45\xBC\xA6\x6A\xEF\xA7\xF7\x4A\x90\x08\xFA\x46\x2E\x14\x4D\x74"
> +#define SMB2_CREATE_APP_INSTANCE_VERSION
> "\xB9\x82\xD0\xB7\x3B\x56\x07\x4F\xA0\x7B\x52\x4A\x81\x16\xA0\x10"
> +#define SVHDX_OPEN_DEVICE_CONTEXT
> "\x9C\xCB\xCF\x9E\x04\xC1\xE6\x43\x98\x0E\x15\x8D\xA1\xF6\xEC\x83"
> +#define SMB2_CREATE_TAG_AAPL                   "AAPL"
>
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve

--00000000000033e9c305ea054963
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0010-smb3-define-missing-create-contexts.patch"
Content-Disposition: attachment; 
	filename="0010-smb3-define-missing-create-contexts.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_l8qtg7ll0>
X-Attachment-Id: f_l8qtg7ll0

RnJvbSAzMTNiMWY3Mzk2MDRiOTc4YmI5OTZhNmQ2MjBjMDExNjU3Y2UxYjRlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFNhdCwgMSBPY3QgMjAyMiAyMjo1MjoyMCAtMDUwMApTdWJqZWN0OiBbUEFUQ0ggMTAv
MTBdIHNtYjM6IGRlZmluZSBtaXNzaW5nIGNyZWF0ZSBjb250ZXh0cwoKVXBkYXRlIHRoZSBsaXN0
IG9mIGNyZWF0ZSBjb250ZXh0cyB0byBpbmNsdWRlIHRoZSB0aHJlZQptb3JlIHJlY2VudCBvbmVz
IGFuZCB0aGUgb25lIHVzZWQgZm9yIG1vdW50cyB0byBNYWNzLgoKU2lnbmVkLW9mZi1ieTogU3Rl
dmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29tPgotLS0KIGZzL3NtYmZzX2NvbW1vbi9z
bWIycGR1LmggfCA2ICsrKysrLQogMSBmaWxlIGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygrKSwgMSBk
ZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2ZzL3NtYmZzX2NvbW1vbi9zbWIycGR1LmggYi9mcy9z
bWJmc19jb21tb24vc21iMnBkdS5oCmluZGV4IDJjYWI0MTNmZmZlZS4uN2Q2MDVkYjNiYjNiIDEw
MDY0NAotLS0gYS9mcy9zbWJmc19jb21tb24vc21iMnBkdS5oCisrKyBiL2ZzL3NtYmZzX2NvbW1v
bi9zbWIycGR1LmgKQEAgLTExMDEsNyArMTEwMSwxMSBAQCBzdHJ1Y3Qgc21iMl9jaGFuZ2Vfbm90
aWZ5X3JzcCB7CiAjZGVmaW5lIFNNQjJfQ1JFQVRFX1JFUVVFU1RfTEVBU0UJCSJScUxzIgogI2Rl
ZmluZSBTTUIyX0NSRUFURV9EVVJBQkxFX0hBTkRMRV9SRVFVRVNUX1YyCSJESDJRIgogI2RlZmlu
ZSBTTUIyX0NSRUFURV9EVVJBQkxFX0hBTkRMRV9SRUNPTk5FQ1RfVjIJIkRIMkMiCi0jZGVmaW5l
IFNNQjJfQ1JFQVRFX1RBR19QT1NJWCAgICAgICAgICAiXHg5M1x4QURceDI1XHg1MFx4OUNceEI0
XHgxMVx4RTdceEI0XHgyM1x4ODNceERFXHg5Nlx4OEJceENEXHg3QyIKKyNkZWZpbmUgU01CMl9D
UkVBVEVfVEFHX1BPU0lYCQkiXHg5M1x4QURceDI1XHg1MFx4OUNceEI0XHgxMVx4RTdceEI0XHgy
M1x4ODNceERFXHg5Nlx4OEJceENEXHg3QyIKKyNkZWZpbmUgU01CMl9DUkVBVEVfQVBQX0lOU1RB
TkNFX0lECSJceDQ1XHhCQ1x4QTZceDZBXHhFRlx4QTdceEY3XHg0QVx4OTBceDA4XHhGQVx4NDZc
eDJFXHgxNFx4NERceDc0IgorI2RlZmluZSBTTUIyX0NSRUFURV9BUFBfSU5TVEFOQ0VfVkVSU0lP
TiAiXHhCOVx4ODJceEQwXHhCN1x4M0JceDU2XHgwN1x4NEZceEEwXHg3Qlx4NTJceDRBXHg4MVx4
MTZceEEwXHgxMCIKKyNkZWZpbmUgU1ZIRFhfT1BFTl9ERVZJQ0VfQ09OVEVYVAkiXHg5Q1x4Q0Jc
eENGXHg5RVx4MDRceEMxXHhFNlx4NDNceDk4XHgwRVx4MTVceDhEXHhBMVx4RjZceEVDXHg4MyIK
KyNkZWZpbmUgU01CMl9DUkVBVEVfVEFHX0FBUEwJCQkiQUFQTCIKIAogLyogRmxhZyAoU01CMyBv
cGVuIHJlc3BvbnNlKSB2YWx1ZXMgKi8KICNkZWZpbmUgU01CMl9DUkVBVEVfRkxBR19SRVBBUlNF
UE9JTlQgMHgwMQotLSAKMi4zNC4xCgo=
--00000000000033e9c305ea054963--
