Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45192C4332F
	for <linux-cifs@archiver.kernel.org>; Sat, 15 Oct 2022 00:26:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbiJOA0r (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 14 Oct 2022 20:26:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiJOA0r (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 14 Oct 2022 20:26:47 -0400
Received: from mail-vk1-xa2d.google.com (mail-vk1-xa2d.google.com [IPv6:2607:f8b0:4864:20::a2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D64075482
        for <linux-cifs@vger.kernel.org>; Fri, 14 Oct 2022 17:26:45 -0700 (PDT)
Received: by mail-vk1-xa2d.google.com with SMTP id v81so3009684vkv.5
        for <linux-cifs@vger.kernel.org>; Fri, 14 Oct 2022 17:26:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=w+zJOoN2QzJmkewwLOYBjOaG9cTykYJTunjOFzqeptw=;
        b=celScAm+IpDPuWIqgVNYEz3AvVuc1cBmhUcXNVV/mIssUcVert2NEyP9HtqrSvKego
         yTa0J52ZYtcX0Xk7J9pwJ0XXJg6O581bhXyHK867dPrgWyNWdo3jJVRKJS5hDwpoV4sD
         3bjmLwfkw+VInCldzvjuB3/IYzHI7mRJZQdYYDciEjaxdhSwOFVJYalV4n9iM1VqTtcL
         5zU2U7l3Gye2kKR3y7u+ue7vrtc+yrZFaeNPnZX7yZJe12iPElQD0B3blbaoue/x04PL
         VS4wl/QqH/I1DprG6z0Vxw6n+TLtJusUN7hr1ShWKGG3aKk7ZOaKv+fvvUWvsV7cFznR
         iwbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w+zJOoN2QzJmkewwLOYBjOaG9cTykYJTunjOFzqeptw=;
        b=WRuS6ubkpAmYBhCvz7ld4mxxzbQyBBrfIJzft9M2CwNiqf7fxUdipuUxbNIIGKY5wC
         lAAMu9i6JocGITBbHET4NpSr7oHYfjAbn6TSxeKljshXTjKtkAy+Z/UsSxAQlEDUBirz
         1O0SAGRPWWe/u6CvvEPt09lBkDM48iGLUfSlpZtH4y/WA2nWIua/QVE0ANsu0usTP/vb
         MuqCW7lQDvQIg0DYUqbSnXaTGJQGINznSPqtBsIlZJX1D7nmy9aGmlqyf72kyHHHHE0S
         dK5cczy9bCoMGrEUr4Yz0av8dKWPou1tZx32nDPbhgSq+IzXGqnmd7Q3b9iEGP20ExHv
         9VAA==
X-Gm-Message-State: ACrzQf3Wzr0jmsD1/9IZCxQC78A0Ok9x4l3dSsM+nYX6t9JSE+K3U7ob
        ss1J317F40ehB+yDhgtcgmNVbvO0a+9zN/X68StgncwP
X-Google-Smtp-Source: AMsMyM5yzn3ohzjHbT8aNeFeogrlWX40+5qFSyEPLyErt8Mc/iZ2MM+H3+Zb9eZ3+10JWywBYIbJAddulf9N8JoRGyk=
X-Received: by 2002:a1f:17d4:0:b0:3ab:36e3:c22f with SMTP id
 203-20020a1f17d4000000b003ab36e3c22fmr175447vkx.38.1665793604405; Fri, 14 Oct
 2022 17:26:44 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5msaxD7WVUHNUpVfZpjrabLTU=sY-kVo+WD=F04m0v4gaA@mail.gmail.com>
 <CAH2r5mvSNk7WiuvWJ6ZbHvb0F3ze8p=amp0h_BOCy_7S=nhx1w@mail.gmail.com>
In-Reply-To: <CAH2r5mvSNk7WiuvWJ6ZbHvb0F3ze8p=amp0h_BOCy_7S=nhx1w@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 14 Oct 2022 19:26:33 -0500
Message-ID: <CAH2r5mv4YM41jD=PAp6L77Nf+9OgAdmj9OECgox6ZHCeSML1Vw@mail.gmail.com>
Subject: Fwd: [PATCH][SMB3 client] minor coverity fix for unitialized MBZ ACL fields
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000000f70f705eb07cce4"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000000f70f705eb07cce4
Content-Type: text/plain; charset="UTF-8"

---------- Forwarded message ---------
From: Steve French <smfrench@gmail.com>
Date: Fri, Oct 14, 2022 at 7:25 PM
Subject: Re: [PATCH][SMB3 client] minor coverity fix for unitialized
MBZ ACL fields
To: CIFS <linux-cifs@vger.kernel.org>
Cc: Paulo Alcantara <pc@cjr.nz>


And one more similar one (although probably more minor)

    cifs: lease key is uninitialized in smb1 paths

    It is cleaner to set lease key to zero in the places where leases are not
    supported (smb1 can not return lease keys so the field was uninitialized).

    Addresses-Coverity: 1513994 ("Uninitialized scalar variable")

See attached.


On Fri, Oct 14, 2022 at 6:57 PM Steve French <smfrench@gmail.com> wrote:
>
> smb3: must initialize two ACL struct fields to zero
>
> Coverity spotted that we were not initalizing Stbz1 and Stbz2 to
> zero in create_sd_buf.
>
> Addresses-Coverity: 1513848 ("Uninitialized scalar variable")
>
> See attached
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve


-- 
Thanks,

Steve

--0000000000000f70f705eb07cce4
Content-Type: application/x-patch; 
	name="0001-cifs-lease-key-is-uninitialized-in-smb1-paths.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-lease-key-is-uninitialized-in-smb1-paths.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_l996g64p0>
X-Attachment-Id: f_l996g64p0

RnJvbSA1NmY5MWRlOGYxN2E4ZDY1YTg3NjM4ZTljNmFlNGM1MTYzY2Q2NWE5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IEZyaSwgMTQgT2N0IDIwMjIgMTk6MTg6MzIgLTA1MDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiBsZWFzZSBrZXkgaXMgdW5pbml0aWFsaXplZCBpbiBzbWIxIHBhdGhzCgpJdCBpcyBjbGVh
bmVyIHRvIHNldCBsZWFzZSBrZXkgdG8gemVybyBpbiB0aGUgcGxhY2VzIHdoZXJlIGxlYXNlcyBh
cmUgbm90CnN1cHBvcnRlZCAoc21iMSBjYW4gbm90IHJldHVybiBsZWFzZSBrZXlzIHNvIHRoZSBm
aWVsZCB3YXMgdW5pbml0aWFsaXplZCkuCgpBZGRyZXNzZXMtQ292ZXJpdHk6IDE1MTM5OTQgKCJV
bmluaXRpYWxpemVkIHNjYWxhciB2YXJpYWJsZSIpClJldmlld2VkLWJ5OiBQYXVsbyBBbGNhbnRh
cmEgKFNVU0UpIDxwY0BjanIubno+ClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVu
Y2hAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9jaWZzL2Rpci5jIHwgMiArLQogMSBmaWxlIGNoYW5n
ZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9k
aXIuYyBiL2ZzL2NpZnMvZGlyLmMKaW5kZXggY2JkNDZhYzU5Y2QyLi5hNWM3M2MyYWYzYTIgMTAw
NjQ0Ci0tLSBhL2ZzL2NpZnMvZGlyLmMKKysrIGIvZnMvY2lmcy9kaXIuYwpAQCAtNDEzLDcgKzQx
Myw3IEBAIGNpZnNfYXRvbWljX29wZW4oc3RydWN0IGlub2RlICppbm9kZSwgc3RydWN0IGRlbnRy
eSAqZGlyZW50cnksCiAJc3RydWN0IHRjb25fbGluayAqdGxpbms7CiAJc3RydWN0IGNpZnNfdGNv
biAqdGNvbjsKIAlzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpzZXJ2ZXI7Ci0Jc3RydWN0IGNpZnNf
ZmlkIGZpZDsKKwlzdHJ1Y3QgY2lmc19maWQgZmlkID0ge307CiAJc3RydWN0IGNpZnNfcGVuZGlu
Z19vcGVuIG9wZW47CiAJX191MzIgb3Bsb2NrOwogCXN0cnVjdCBjaWZzRmlsZUluZm8gKmZpbGVf
aW5mbzsKLS0gCjIuMzQuMQoK
--0000000000000f70f705eb07cce4--
