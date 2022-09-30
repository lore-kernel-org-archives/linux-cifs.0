Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38CDDC433F5
	for <linux-cifs@archiver.kernel.org>; Fri, 30 Sep 2022 03:03:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbiI3DD5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 29 Sep 2022 23:03:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbiI3DDp (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 29 Sep 2022 23:03:45 -0400
Received: from mail-vk1-xa31.google.com (mail-vk1-xa31.google.com [IPv6:2607:f8b0:4864:20::a31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69C4C110EED
        for <linux-cifs@vger.kernel.org>; Thu, 29 Sep 2022 20:03:31 -0700 (PDT)
Received: by mail-vk1-xa31.google.com with SMTP id s12so1629706vkn.11
        for <linux-cifs@vger.kernel.org>; Thu, 29 Sep 2022 20:03:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=KFqW0It+MnJIijyFsdfj+cM9XgEV8wiBa3GFzeHcUG0=;
        b=MCgDmz3NnTHuYGBppAOmoJl1FLMYk562qQWdVSAFqm4c6JvkCKFT+kjJ8b4nRXLgcW
         FohfAjDjYdp20heJLfgl+HcG5iuNb5PI6CplsaMIY2RvN+N0kmXuHxxsx+O7TjNH//tB
         nwvV8s0vzMCAL8dchYtJCPMEqLlIzE050LD8coCmPRr2I7gEfS+P/miTwlsdyzL7cizZ
         hioqLG9Ox6SMIuXh1CPKXaciFAzmqkH27WV1gM36gzCBXEPTdZjG2t/vRsv7a9bthBX2
         mGyDGt/0z/kRrYNW+v/4suJnW4GwZtwU0zPBNRzlS2p+iEuv7A9Fz3CbQ7ivLWwDY5q2
         No1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=KFqW0It+MnJIijyFsdfj+cM9XgEV8wiBa3GFzeHcUG0=;
        b=6O/KeuZI01R0reJ5+uqefuHXRstVW3Edzjq8IH/lU5YkL5AcmKzMFADinm/D/UWnIb
         rUL0x7wDlxf5MWeVOl9GQiSYIJv5DlTmpYS0kLkWUn8SGp/4W2Yv4DlSEISqNp6oN3vA
         Wh0ag9x+MtPSV3tNACr9aHXY5wrbgLJYbxQOdSZwQIJX4BSZtdlgHEDjgOm8LBphLBUV
         M3UJ6VaYbb10v+iSE7yxqPgJ53f6gdFyJKba6R5Sh70x8xuRiBSYic/nxde1kBEIHuHP
         5+fpmKPcn/sEViOx3P2iNnDggfUuAiXAGEgXeBVAaZ9ADyj1T/JWs/+etT/LbKeIKqpg
         YHrA==
X-Gm-Message-State: ACrzQf13+BkVp5wVV1bKcznjzG3w1UKVB+tTWUtIR1+3gdh2yCI88eB5
        yMIAXzHKzV9UbkcdVmpwugKcCJzIC3FMuqjuB+M=
X-Google-Smtp-Source: AMsMyM57fQmgclXED6OKddUiLYdGlRnJhGtmvfE+2Cik4nKsSRePjd2WJGDY+XcVEoxiRi0mrvmgarOFd3oflcDLT84=
X-Received: by 2002:a1f:21c5:0:b0:3a3:d755:ff17 with SMTP id
 h188-20020a1f21c5000000b003a3d755ff17mr3256856vkh.38.1664507010361; Thu, 29
 Sep 2022 20:03:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220929203652.13178-1-ematsumiya@suse.de>
In-Reply-To: <20220929203652.13178-1-ematsumiya@suse.de>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 29 Sep 2022 22:03:19 -0500
Message-ID: <CAH2r5mtJXYgQro1AgUD+A1fBq6SNNyYYS3KGCJFNj=711RroGg@mail.gmail.com>
Subject: Re: [PATCH v4 0/8] cifs: introduce support for AES-GMAC signing
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     linux-cifs@vger.kernel.org, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com, tom@talpey.com, metze@samba.org
Content-Type: multipart/mixed; boundary="00000000000014830605e9dc3d67"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--00000000000014830605e9dc3d67
Content-Type: text/plain; charset="UTF-8"

improved ... but I see an out of memory error when I do this:

# dd if=/dev/zero of=/mnt1/file bs=4M count=1
dd: closing output file '/mnt1/file': Cannot allocate memory
# dmesg
[  439.674953] CIFS: VFS: \\localhost smb311_calc_aes_gmac: Failed to
compute AES-GMAC signature, rc=-12

Attached is the trace-cmd output

Will also run some xfstests with this v4 series


On Thu, Sep 29, 2022 at 3:36 PM Enzo Matsumiya <ematsumiya@suse.de> wrote:
>
> v4:
> Patches 3/8 and 6/8:
>   - fix checkpatch errors (thanks to Steve)
>
> Patch 5/8:
>   - rename smb311_calc_signature to smb311_calc_aes_gmac, and use SMB3_AES_GCM_NONCE
>     instead of hardcoded '12' (suggested by metze)
>   - update commit message to include the reasoning to move ->calc_signature op
>
> Patch 8/8:
>   - move SMB2_PADDING_BUF to smb2glob.h
>   - check if iov is SMB2_PADDING_BUF in the free functions where
>     smb2_padding was previously used (pointed out by metze)
>
> Enzo Matsumiya (8):
>   smb3: rename encryption/decryption TFMs
>   cifs: secmech: use shash_desc directly, remove sdesc
>   cifs: allocate ephemeral secmechs only on demand
>   cifs: create sign/verify secmechs, don't leave keys in memory
>   cifs: introduce AES-GMAC signing support for SMB 3.1.1
>   cifs: deprecate 'enable_negotiate_signing' module param
>   cifs: show signing algorithm name in DebugData
>   cifs: use MAX_CIFS_SMALL_BUFFER_SIZE-8 as padding buffer
>
>  fs/cifs/cifs_debug.c    |   7 +-
>  fs/cifs/cifsencrypt.c   | 157 ++++-------
>  fs/cifs/cifsfs.c        |  14 +-
>  fs/cifs/cifsglob.h      |  70 +++--
>  fs/cifs/cifsproto.h     |   5 +-
>  fs/cifs/link.c          |  13 +-
>  fs/cifs/misc.c          |  49 ++--
>  fs/cifs/sess.c          |  12 -
>  fs/cifs/smb1ops.c       |   6 +
>  fs/cifs/smb2glob.h      |  15 ++
>  fs/cifs/smb2misc.c      |  29 +-
>  fs/cifs/smb2ops.c       | 102 ++-----
>  fs/cifs/smb2pdu.c       |  77 ++++--
>  fs/cifs/smb2pdu.h       |   2 -
>  fs/cifs/smb2proto.h     |  13 +-
>  fs/cifs/smb2transport.c | 581 +++++++++++++++++++++-------------------
>  16 files changed, 577 insertions(+), 575 deletions(-)
>
> --
> 2.35.3
>


--
Thanks,

Steve

--00000000000014830605e9dc3d67
Content-Type: application/octet-stream; name=failed-4mb-write-with-signing
Content-Disposition: attachment; filename=failed-4mb-write-with-signing
Content-Transfer-Encoding: base64
Content-ID: <f_l8nwgrtq0>
X-Attachment-Id: f_l8nwgrtq0

IyB0cmFjZXI6IG5vcAojCiMgZW50cmllcy1pbi1idWZmZXIvZW50cmllcy13cml0dGVuOiA2My82
MyAgICNQOjEyCiMKIyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXy0tLS0tPT4gaXJx
cy1vZmYvQkgtZGlzYWJsZWQKIyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAvIF8tLS0t
PT4gbmVlZC1yZXNjaGVkCiMgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8IC8gXy0tLT0+
IGhhcmRpcnEvc29mdGlycQojICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfHwgLyBfLS09
PiBwcmVlbXB0LWRlcHRoCiMgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8fHwgLyBfLT0+
IG1pZ3JhdGUtZGlzYWJsZQojICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfHx8fCAvICAg
ICBkZWxheQojICAgICAgICAgICBUQVNLLVBJRCAgICAgQ1BVIyAgfHx8fHwgIFRJTUVTVEFNUCAg
RlVOQ1RJT04KIyAgICAgICAgICAgICAgfCB8ICAgICAgICAgfCAgIHx8fHx8ICAgICB8ICAgICAg
ICAgfAogICAgICAgICAgICAgIGRkLTQzMjggICAgWzAwNV0gLi4uLi4gICA1MjYuNTM3NjA1OiBz
bWIzX2VudGVyOiAJY2lmc19yZXZhbGlkYXRlX2RlbnRyeV9hdHRyOiB4aWQ9NjcKICAgICAgICAg
ICAgICBkZC00MzI4ICAgIFswMDVdIC4uLi4uICAgNTI2LjUzNzYzMTogc21iM19xdWVyeV9pbmZv
X2NvbXBvdW5kX2VudGVyOiB4aWQ9Njcgc2lkPTB4YTQzNzc4ZWYgdGlkPTB4NDYzZTdjZDIgcGF0
aD1cZmlsZQogICAgICAgICAgICAgIGRkLTQzMjggICAgWzAwNV0gLi4uLi4gICA1MjYuNTM3NjM1
OiBzbWIzX3dhaXRmZl9jcmVkaXRzOiBjb25uX2lkPTB4MSBzZXJ2ZXI9bG9jYWxob3N0IGN1cnJl
bnRfbWlkPTE5MyBjcmVkaXRzPTExODcgY3JlZGl0X2NoYW5nZT0tMyBpbl9mbGlnaHQ9MwogICAg
ICAgICAgICAgIGRkLTQzMjggICAgWzAwNV0gLi4uLi4gICA1MjYuNTM3NjM4OiBzbWIzX2NtZF9l
bnRlcjogCXNpZD0weDQ2M2U3Y2QyIHRpZD0weGE0Mzc3OGVmIGNtZD01IG1pZD0xOTMKICAgICAg
ICAgICAgICBkZC00MzI4ICAgIFswMDVdIC4uLi4uICAgNTI2LjUzNzY1MDogc21iM19jbWRfZW50
ZXI6IAlzaWQ9MHg0NjNlN2NkMiB0aWQ9MHhhNDM3NzhlZiBjbWQ9MTYgbWlkPTE5NAogICAgICAg
ICAgICAgIGRkLTQzMjggICAgWzAwNV0gLi4uLi4gICA1MjYuNTM3NjU0OiBzbWIzX2NtZF9lbnRl
cjogCXNpZD0weDQ2M2U3Y2QyIHRpZD0weGE0Mzc3OGVmIGNtZD02IG1pZD0xOTUKICAgICAgICAg
ICBjaWZzZC00MTg5ICAgIFswMDRdIC4uLi4uICAgNTI2LjUzOTAzMDogc21iM19hZGRfY3JlZGl0
czogY29ubl9pZD0weDEgc2VydmVyPWxvY2FsaG9zdCBjdXJyZW50X21pZD0xOTYgY3JlZGl0cz0x
MTg3IGNyZWRpdF9jaGFuZ2U9MCBpbl9mbGlnaHQ9MgogICAgICAgICAgIGNpZnNkLTQxODkgICAg
WzAwNF0gLi4uLi4gICA1MjYuNTM5MDM4OiBzbWIzX2FkZF9jcmVkaXRzOiBjb25uX2lkPTB4MSBz
ZXJ2ZXI9bG9jYWxob3N0IGN1cnJlbnRfbWlkPTE5NiBjcmVkaXRzPTExODcgY3JlZGl0X2NoYW5n
ZT0wIGluX2ZsaWdodD0xCiAgICAgICAgICAgY2lmc2QtNDE4OSAgICBbMDA0XSAuLi4uLiAgIDUy
Ni41MzkwNDc6IHNtYjNfYWRkX2NyZWRpdHM6IGNvbm5faWQ9MHgxIHNlcnZlcj1sb2NhbGhvc3Qg
Y3VycmVudF9taWQ9MTk2IGNyZWRpdHM9MTIxNyBjcmVkaXRfY2hhbmdlPTMwIGluX2ZsaWdodD0w
CiAgICAgICAgICAgICAgZGQtNDMyOCAgICBbMDA1XSAuLi4uLiAgIDUyNi41MzkxMTU6IHNtYjNf
Y21kX2RvbmU6IAlzaWQ9MHg0NjNlN2NkMiB0aWQ9MHhhNDM3NzhlZiBjbWQ9NSBtaWQ9MTkzCiAg
ICAgICAgICAgICAgZGQtNDMyOCAgICBbMDA1XSAuLi4uLiAgIDUyNi41MzkxMTk6IHNtYjNfY21k
X2RvbmU6IAlzaWQ9MHg0NjNlN2NkMiB0aWQ9MHhhNDM3NzhlZiBjbWQ9MTYgbWlkPTE5NAogICAg
ICAgICAgICAgIGRkLTQzMjggICAgWzAwNV0gLi4uLi4gICA1MjYuNTM5MTIxOiBzbWIzX2NtZF9k
b25lOiAJc2lkPTB4NDYzZTdjZDIgdGlkPTB4YTQzNzc4ZWYgY21kPTYgbWlkPTE5NQogICAgICAg
ICAgICAgIGRkLTQzMjggICAgWzAwNV0gLi4uLi4gICA1MjYuNTM5MTI4OiBzbWIzX3F1ZXJ5X2lu
Zm9fY29tcG91bmRfZG9uZTogeGlkPTY3IHNpZD0weGE0Mzc3OGVmIHRpZD0weDQ2M2U3Y2QyCiAg
ICAgICAgICAgICAgZGQtNDMyOCAgICBbMDA1XSAuLi4uLiAgIDUyNi41MzkxMzg6IHNtYjNfZXhp
dF9kb25lOiAJY2lmc19yZXZhbGlkYXRlX2RlbnRyeV9hdHRyOiB4aWQ9NjcKICAgICAgICAgICAg
ICBkZC00MzI4ICAgIFswMDVdIC4uLi4uICAgNTI2LjU0MTAwMzogc21iM19lbnRlcjogCWNpZnNf
b3BlbjogeGlkPTY4CiAgICAgICAgICAgICAgZGQtNDMyOCAgICBbMDA1XSAuLi4uLiAgIDUyNi41
NDEwMjA6IHNtYjNfb3Blbl9lbnRlcjogeGlkPTY4IHNpZD0weDQ2M2U3Y2QyIHRpZD0weGE0Mzc3
OGVmIGNyX29wdHM9MHg0MCBkZXNfYWNjZXNzPTB4NDAwMDAwODAKICAgICAgICAgICAgICBkZC00
MzI4ICAgIFswMDVdIC4uLi4uICAgNTI2LjU0MTAyMjogc21iM193YWl0ZmZfY3JlZGl0czogY29u
bl9pZD0weDEgc2VydmVyPWxvY2FsaG9zdCBjdXJyZW50X21pZD0xOTYgY3JlZGl0cz0xMjE2IGNy
ZWRpdF9jaGFuZ2U9LTEgaW5fZmxpZ2h0PTEKICAgICAgICAgICAgICBkZC00MzI4ICAgIFswMDVd
IC4uLi4uICAgNTI2LjU0MTAyMzogc21iM19jbWRfZW50ZXI6IAlzaWQ9MHg0NjNlN2NkMiB0aWQ9
MHhhNDM3NzhlZiBjbWQ9NSBtaWQ9MTk2CiAgICAgICAgICAgY2lmc2QtNDE4OSAgICBbMDA0XSAu
Li4uLiAgIDUyNi41NDI1OTM6IHNtYjNfYWRkX2NyZWRpdHM6IGNvbm5faWQ9MHgxIHNlcnZlcj1s
b2NhbGhvc3QgY3VycmVudF9taWQ9MTk3IGNyZWRpdHM9MTIyNiBjcmVkaXRfY2hhbmdlPTEwIGlu
X2ZsaWdodD0wCiAgICAgICAgICAgICAgZGQtNDMyOCAgICBbMDA1XSAuLi4uLiAgIDUyNi41NDI2
NjE6IHNtYjNfY21kX2RvbmU6IAlzaWQ9MHg0NjNlN2NkMiB0aWQ9MHhhNDM3NzhlZiBjbWQ9NSBt
aWQ9MTk2CiAgICAgICAgICAgICAgZGQtNDMyOCAgICBbMDA1XSAuLi4uLiAgIDUyNi41NDI2NjU6
IHNtYjNfb3Blbl9kb25lOiB4aWQ9Njggc2lkPTB4NDYzZTdjZDIgdGlkPTB4YTQzNzc4ZWYgZmlk
PTB4OGI0NmRiMzMgY3Jfb3B0cz0weDQwIGRlc19hY2Nlc3M9MHg0MDAwMDA4MAogICAgICAgICAg
ICAgIGRkLTQzMjggICAgWzAwNV0gLi4uLi4gICA1MjYuNTQyNjc4OiBzbWIzX2V4aXRfZG9uZTog
CWNpZnNfb3BlbjogeGlkPTY4CiAgICAgICAgICAgICAgZGQtNDMyOCAgICBbMDA1XSAuLi4uLiAg
IDUyNi41NDI2ODY6IHNtYjNfZW50ZXI6IAljaWZzX3NldGF0dHJfbm91bml4OiB4aWQ9NjkKICAg
ICAgICAgICAgICBkZC00MzI4ICAgIFswMDVdIC4uLi4uICAgNTI2LjU0MjY5Mjogc21iM19mbHVz
aF9lbnRlcjogCXhpZD02OSBzaWQ9MHg0NjNlN2NkMiB0aWQ9MHhhNDM3NzhlZiBmaWQ9MHg4YjQ2
ZGIzMwogICAgICAgICAgICAgIGRkLTQzMjggICAgWzAwNV0gLi4uLi4gICA1MjYuNTQyNjk0OiBz
bWIzX3dhaXRmZl9jcmVkaXRzOiBjb25uX2lkPTB4MSBzZXJ2ZXI9bG9jYWxob3N0IGN1cnJlbnRf
bWlkPTE5NyBjcmVkaXRzPTEyMjUgY3JlZGl0X2NoYW5nZT0tMSBpbl9mbGlnaHQ9MQogICAgICAg
ICAgICAgIGRkLTQzMjggICAgWzAwNV0gLi4uLi4gICA1MjYuNTQyNjk2OiBzbWIzX2NtZF9lbnRl
cjogCXNpZD0weDQ2M2U3Y2QyIHRpZD0weGE0Mzc3OGVmIGNtZD03IG1pZD0xOTcKICAgICAgICAg
ICBjaWZzZC00MTg5ICAgIFswMDRdIC4uLi4uICAgNTI2LjU0NDIzNjogc21iM19wZW5kX2NyZWRp
dHM6IGNvbm5faWQ9MHgxIHNlcnZlcj1sb2NhbGhvc3QgY3VycmVudF9taWQ9MTk4IGNyZWRpdHM9
MTIzNSBjcmVkaXRfY2hhbmdlPTEwIGluX2ZsaWdodD0xCiAgICAgICAgICAgY2lmc2QtNDE4OSAg
ICBbMDA0XSAuLi4uLiAgIDUyNi41NTQxMjc6IHNtYjNfYWRkX2NyZWRpdHM6IGNvbm5faWQ9MHgx
IHNlcnZlcj1sb2NhbGhvc3QgY3VycmVudF9taWQ9MTk4IGNyZWRpdHM9MTIzNSBjcmVkaXRfY2hh
bmdlPTAgaW5fZmxpZ2h0PTAKICAgICAgICAgICAgICBkZC00MzI4ICAgIFswMDVdIC4uLi4uICAg
NTI2LjU1NDIwMzogc21iM19jbWRfZG9uZTogCXNpZD0weDQ2M2U3Y2QyIHRpZD0weDAgY21kPTcg
bWlkPTE5NwogICAgICAgICAgICAgIGRkLTQzMjggICAgWzAwNV0gLi4uLi4gICA1MjYuNTU0MjA3
OiBzbWIzX2ZsdXNoX2RvbmU6IAl4aWQ9Njkgc2lkPTB4NDYzZTdjZDIgdGlkPTB4YTQzNzc4ZWYg
ZmlkPTB4OGI0NmRiMzMKICAgICAgICAgICAgICBkZC00MzI4ICAgIFswMDVdIC4uLi4uICAgNTI2
LjU1NDIxMzogc21iM19zZXRfZW9mOiB4aWQ9Njkgc2lkPTB4NDYzZTdjZDIgdGlkPTB4YTQzNzc4
ZWYgZmlkPTB4OGI0NmRiMzMgb2Zmc2V0PTB4MAogICAgICAgICAgICAgIGRkLTQzMjggICAgWzAw
NV0gLi4uLi4gICA1MjYuNTU0MjMxOiBzbWIzX3dhaXRmZl9jcmVkaXRzOiBjb25uX2lkPTB4MSBz
ZXJ2ZXI9bG9jYWxob3N0IGN1cnJlbnRfbWlkPTE5OCBjcmVkaXRzPTEyMzQgY3JlZGl0X2NoYW5n
ZT0tMSBpbl9mbGlnaHQ9MQogICAgICAgICAgICAgIGRkLTQzMjggICAgWzAwNV0gLi4uLi4gICA1
MjYuNTU0MjMzOiBzbWIzX2NtZF9lbnRlcjogCXNpZD0weDQ2M2U3Y2QyIHRpZD0weGE0Mzc3OGVm
IGNtZD0xNyBtaWQ9MTk4CiAgICAgICAgICAgY2lmc2QtNDE4OSAgICBbMDA0XSAuLi4uLiAgIDUy
Ni41NTQ1ODg6IHNtYjNfYWRkX2NyZWRpdHM6IGNvbm5faWQ9MHgxIHNlcnZlcj1sb2NhbGhvc3Qg
Y3VycmVudF9taWQ9MTk5IGNyZWRpdHM9MTI0NCBjcmVkaXRfY2hhbmdlPTEwIGluX2ZsaWdodD0w
CiAgICAgICAgICAgICAgZGQtNDMyOCAgICBbMDA1XSAuLi4uLiAgIDUyNi41NTQ2NTY6IHNtYjNf
Y21kX2RvbmU6IAlzaWQ9MHg0NjNlN2NkMiB0aWQ9MHhhNDM3NzhlZiBjbWQ9MTcgbWlkPTE5OAog
ICAgICAgICAgICAgIGRkLTQzMjggICAgWzAwNV0gLi4uLi4gICA1MjYuNTU0Njg2OiBzbWIzX3Nl
dF9pbmZvX2NvbXBvdW5kX2VudGVyOiB4aWQ9Njkgc2lkPTB4YTQzNzc4ZWYgdGlkPTB4NDYzZTdj
ZDIgcGF0aD1cZmlsZQogICAgICAgICAgICAgIGRkLTQzMjggICAgWzAwNV0gLi4uLi4gICA1MjYu
NTU0Njg4OiBzbWIzX3dhaXRmZl9jcmVkaXRzOiBjb25uX2lkPTB4MSBzZXJ2ZXI9bG9jYWxob3N0
IGN1cnJlbnRfbWlkPTE5OSBjcmVkaXRzPTEyNDMgY3JlZGl0X2NoYW5nZT0tMSBpbl9mbGlnaHQ9
MQogICAgICAgICAgICAgIGRkLTQzMjggICAgWzAwNV0gLi4uLi4gICA1MjYuNTU0NjkwOiBzbWIz
X2NtZF9lbnRlcjogCXNpZD0weDQ2M2U3Y2QyIHRpZD0weGE0Mzc3OGVmIGNtZD0xNyBtaWQ9MTk5
CiAgICAgICAgICAgY2lmc2QtNDE4OSAgICBbMDA0XSAuLi4uLiAgIDUyNi41NTU0NzI6IHNtYjNf
YWRkX2NyZWRpdHM6IGNvbm5faWQ9MHgxIHNlcnZlcj1sb2NhbGhvc3QgY3VycmVudF9taWQ9MjAw
IGNyZWRpdHM9MTI1MyBjcmVkaXRfY2hhbmdlPTEwIGluX2ZsaWdodD0wCiAgICAgICAgICAgICAg
ZGQtNDMyOCAgICBbMDA1XSAuLi4uLiAgIDUyNi41NTU1NTc6IHNtYjNfY21kX2RvbmU6IAlzaWQ9
MHg0NjNlN2NkMiB0aWQ9MHhhNDM3NzhlZiBjbWQ9MTcgbWlkPTE5OQogICAgICAgICAgICAgIGRk
LTQzMjggICAgWzAwNV0gLi4uLi4gICA1MjYuNTU1NTYyOiBzbWIzX3NldF9pbmZvX2NvbXBvdW5k
X2RvbmU6IHhpZD02OSBzaWQ9MHhhNDM3NzhlZiB0aWQ9MHg0NjNlN2NkMgogICAgICAgICAgICAg
IGRkLTQzMjggICAgWzAwNV0gLi4uLi4gICA1MjYuNTU1NTcwOiBzbWIzX2V4aXRfZG9uZTogCWNp
ZnNfc2V0YXR0cl9ub3VuaXg6IHhpZD02OQogICAgICAgICAgICAgIGRkLTQzMjggICAgWzAwNV0g
Li4uLi4gICA1MjYuNTYyMTY1OiBzbWIzX2VudGVyOiAJY2lmc193cml0ZXBhZ2VzOiB4aWQ9NzAK
ICAgICAgICAgICAgICBkZC00MzI4ICAgIFswMDVdIC4uLi4uICAgNTI2LjU2MjE2Nzogc21iM193
YWl0X2NyZWRpdHM6IGNvbm5faWQ9MHgxIHNlcnZlcj1sb2NhbGhvc3QgY3VycmVudF9taWQ9MjAw
IGNyZWRpdHM9MTE4OSBjcmVkaXRfY2hhbmdlPS02NCBpbl9mbGlnaHQ9MQogICAgICAgICAgICAg
IGRkLTQzMjggICAgWzAwNV0gLi4uLi4gICA1MjYuNTYyNDk2OiBzbWIzX3dyaXRlX2VudGVyOiB4
aWQ9MCBzaWQ9MHg0NjNlN2NkMiB0aWQ9MHhhNDM3NzhlZiBmaWQ9MHg4YjQ2ZGIzMyBvZmZzZXQ9
MHgwIGxlbj0weDQwMDAwMAogICAgICAgICAgICAgIGRkLTQzMjggICAgWzAwNV0gLi4uLi4gICA1
MjYuNTYyNDk4OiBzbWIzX2NtZF9lbnRlcjogCXNpZD0weDQ2M2U3Y2QyIHRpZD0weGE0Mzc3OGVm
IGNtZD05IG1pZD0yMDAKICAgICAgICAgICAgICBkZC00MzI4ICAgIFswMDVdIC4uLi4uICAgNTI2
LjU2MjUyMDogc21iM193cml0ZV9lcnI6IAl4aWQ9MCBzaWQ9MHg0NjNlN2NkMiB0aWQ9MHhhNDM3
NzhlZiBmaWQ9MHg4YjQ2ZGIzMyBvZmZzZXQ9MHgwIGxlbj0weDQwMDAwMCByYz0tMTIKICAgICAg
ICAgICAgICBkZC00MzI4ICAgIFswMDVdIC4uLi4uICAgNTI2LjU2MjUzMDogc21iM19hZGRfY3Jl
ZGl0czogY29ubl9pZD0weDEgc2VydmVyPWxvY2FsaG9zdCBjdXJyZW50X21pZD0yMDAgY3JlZGl0
cz0xMjUzIGNyZWRpdF9jaGFuZ2U9NjQgaW5fZmxpZ2h0PTAKICAgICAgICAgICAgICBkZC00MzI4
ICAgIFswMDVdIC4uLi4uICAgNTI2LjU2MjY5NTogc21iM193YWl0X2NyZWRpdHM6IGNvbm5faWQ9
MHgxIHNlcnZlcj1sb2NhbGhvc3QgY3VycmVudF9taWQ9MjAwIGNyZWRpdHM9MTE4OSBjcmVkaXRf
Y2hhbmdlPS02NCBpbl9mbGlnaHQ9MQogICAgICAgICAgICAgIGRkLTQzMjggICAgWzAwNV0gLi4u
Li4gICA1MjYuNTYyNjk2OiBzbWIzX2FkZF9jcmVkaXRzOiBjb25uX2lkPTB4MSBzZXJ2ZXI9bG9j
YWxob3N0IGN1cnJlbnRfbWlkPTIwMCBjcmVkaXRzPTEyNTMgY3JlZGl0X2NoYW5nZT02NCBpbl9m
bGlnaHQ9MAogICAgICAgICAgICAgIGRkLTQzMjggICAgWzAwNV0gLi4uLi4gICA1MjYuNTYyNjk3
OiBzbWIzX2V4aXRfZXJyOiAJY2lmc193cml0ZXBhZ2VzOiB4aWQ9NzAgcmM9LTEyCiAgICAgICAg
ICAgICAgZGQtNDMyOCAgICBbMDEwXSAuLi4uLiAgIDUyNi42NjY3NDg6IHNtYjNfZW50ZXI6IAlj
aWZzX3dyaXRlcGFnZXM6IHhpZD03MQogICAgICAgICAgICAgIGRkLTQzMjggICAgWzAxMF0gLi4u
Li4gICA1MjYuNjY2NzUzOiBzbWIzX3dhaXRfY3JlZGl0czogY29ubl9pZD0weDEgc2VydmVyPWxv
Y2FsaG9zdCBjdXJyZW50X21pZD0yMDAgY3JlZGl0cz0xMTg5IGNyZWRpdF9jaGFuZ2U9LTY0IGlu
X2ZsaWdodD0xCiAgICAgICAgICAgICAgZGQtNDMyOCAgICBbMDEwXSAuLi4uLiAgIDUyNi42NjY3
NjI6IHNtYjNfYWRkX2NyZWRpdHM6IGNvbm5faWQ9MHgxIHNlcnZlcj1sb2NhbGhvc3QgY3VycmVu
dF9taWQ9MjAwIGNyZWRpdHM9MTI1MyBjcmVkaXRfY2hhbmdlPTY0IGluX2ZsaWdodD0wCiAgICAg
ICAgICAgICAgZGQtNDMyOCAgICBbMDEwXSAuLi4uLiAgIDUyNi42NjY3NjU6IHNtYjNfZXhpdF9k
b25lOiAJY2lmc193cml0ZXBhZ2VzOiB4aWQ9NzEKICAgICAgICAgICAgICBkZC00MzI4ICAgIFsw
MTBdIC4uLi4uICAgNTI2LjY2Njc2ODogY2lmc19mbHVzaF9lcnI6IAlpbm89NTY1ODA5MzYzIHJj
PS0xMgogICAga3dvcmtlci8xMDoxLTEyNyAgICAgWzAxMF0gLi4uLi4gICA1MzEuNzU0NzE2OiBz
bWIzX2VudGVyOiAJX2NpZnNGaWxlSW5mb19wdXQ6IHhpZD03MgogICAga3dvcmtlci8xMDoxLTEy
NyAgICAgWzAxMF0gLi4uLi4gICA1MzEuNzU0NzIwOiBzbWIzX2Nsb3NlX2VudGVyOiAJeGlkPTcy
IHNpZD0weDQ2M2U3Y2QyIHRpZD0weGE0Mzc3OGVmIGZpZD0weDhiNDZkYjMzCiAgICBrd29ya2Vy
LzEwOjEtMTI3ICAgICBbMDEwXSAuLi4uLiAgIDUzMS43NTQ3MjY6IHNtYjNfd2FpdGZmX2NyZWRp
dHM6IGNvbm5faWQ9MHgxIHNlcnZlcj1sb2NhbGhvc3QgY3VycmVudF9taWQ9MjAwIGNyZWRpdHM9
MTI1MiBjcmVkaXRfY2hhbmdlPS0xIGluX2ZsaWdodD0xCiAgICBrd29ya2VyLzEwOjEtMTI3ICAg
ICBbMDEwXSAuLi4uLiAgIDUzMS43NTQ3MzA6IHNtYjNfY21kX2VudGVyOiAJc2lkPTB4NDYzZTdj
ZDIgdGlkPTB4YTQzNzc4ZWYgY21kPTYgbWlkPTIwMAogICAgICAgICAgIGNpZnNkLTQxODkgICAg
WzAwNF0gLi4uLi4gICA1MzEuNzU1NzY5OiBzbWIzX2FkZF9jcmVkaXRzOiBjb25uX2lkPTB4MSBz
ZXJ2ZXI9bG9jYWxob3N0IGN1cnJlbnRfbWlkPTIwMSBjcmVkaXRzPTEyNjIgY3JlZGl0X2NoYW5n
ZT0xMCBpbl9mbGlnaHQ9MAogICAga3dvcmtlci8xMDoxLTEyNyAgICAgWzAxMF0gLi4uLi4gICA1
MzEuNzU1ODAyOiBzbWIzX2NtZF9kb25lOiAJc2lkPTB4NDYzZTdjZDIgdGlkPTB4YTQzNzc4ZWYg
Y21kPTYgbWlkPTIwMAogICAga3dvcmtlci8xMDoxLTEyNyAgICAgWzAxMF0gLi4uLi4gICA1MzEu
NzU1ODA2OiBzbWIzX2Nsb3NlX2RvbmU6IAl4aWQ9NzIgc2lkPTB4NDYzZTdjZDIgdGlkPTB4YTQz
Nzc4ZWYgZmlkPTB4OGI0NmRiMzMK
--00000000000014830605e9dc3d67--
