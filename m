Return-Path: <SRS0=/VLE=7N=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02685C433E0
	for <linux-cifs@archiver.kernel.org>; Sun, 31 May 2020 19:41:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1C2F206A1
	for <linux-cifs@archiver.kernel.org>; Sun, 31 May 2020 19:41:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SpENtGqA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728441AbgEaTlC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 31 May 2020 15:41:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728355AbgEaTlC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 31 May 2020 15:41:02 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13248C061A0E
        for <linux-cifs@vger.kernel.org>; Sun, 31 May 2020 12:41:02 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id a80so3334124ybg.1
        for <linux-cifs@vger.kernel.org>; Sun, 31 May 2020 12:41:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6OIJ74RbWOHdORKTfrNGIFetrO4DvxrVVEseiBiShe8=;
        b=SpENtGqA1LbvooAXkjpe8wYD0/PjnO/TXOTdk9qNHqsylL+b4LvVucPxGCxuLMuSLM
         VTfeAYN/Fia4nDp10R7kTnqtXLqfw3DXlpGCnRA6Q1wlvcKQCFTRX/x/YI5s0A/pd0S+
         1kbmrBV5R5TDyGXgVv5hoTeMdrM8QJF6nabwY5TG4my8WDV0++JZ7YghaQllE3Mjzkxh
         UKXFsg8XYHPHmTnD3STKH7HWzt7ECBX2AbnjBUNQ6+tUZYhK7WRfzjJJ50i2QHeaPbWw
         JfQ14kWzZsslQO2sE3b/ZAKY5GcOQNbr9bm5HlaFgMhyb7W6hpWvTQTpta1Pk7HfXStp
         BpYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6OIJ74RbWOHdORKTfrNGIFetrO4DvxrVVEseiBiShe8=;
        b=QVjs/PzBuH3eHmST+4v7kl2bu7Vd6ruEW6xdScXpaUc7yuu8M+vv4j9I2blgZ+V7m8
         XZzAS/5yXk635jQPIDcGjCvJexJbDFBrc5Hf2eQsxRirzqZgMFDNg0lrAxINroN7amez
         ewQRjFYJoHZvs9Ato8VmPufLJd8fNm4kP0S5P3YZdk3j+zR6t9ZPlbcjQiRE6mY77RVP
         HH9Ai5NgMITUytFmB8Qjp+2f7GgKoVJOODNhgj3B8+NEw/CvFy/uOVwHj9CZIyyUOCac
         E1FyJ13EIi+04OKvj+m0B87FD121XXdpUePwLHmBbOIWIy2NMZyAZ8Pugh9xvjxuob/+
         pf5w==
X-Gm-Message-State: AOAM532FJNokB0S68eskH2Y1XxUCwtA3oVaDMKCqIXWDQpAb9sdu75Vq
        yGscdwHOQ7aFfY4j7ufQDspre8ONRnF3kL1pzuM=
X-Google-Smtp-Source: ABdhPJzVCJ5xLGqCFt0w+Q9XiGy0dJuBPpcgZFAwxH9ua94s3xKy7EiRztFFUP/2SdHf8j0LVeKBndm5zP+kekmKuwY=
X-Received: by 2002:a25:ba0f:: with SMTP id t15mr30842015ybg.376.1590954061211;
 Sun, 31 May 2020 12:41:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200502132935.GA41736@mwanda>
In-Reply-To: <20200502132935.GA41736@mwanda>
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 31 May 2020 14:40:50 -0500
Message-ID: <CAH2r5mtVaokAwhS8X2PfB12G97B3g1K0vdfwWy=iKRzKxWKFzw@mail.gmail.com>
Subject: Re: [bug report] cifs: multichannel: move channel selection above
 transport layer
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000ac460805a6f6db9a"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000ac460805a6f6db9a
Content-Type: text/plain; charset="UTF-8"

Thanks for pointing this out.  I don't think tcon->ses can be null
here but might as well add the check in a consistent way to avoid
confusion and static checker warnings

On Sat, May 2, 2020 at 8:32 AM Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> Hello Aurelien Aptel,
>
> The patch feeaec621c09: "cifs: multichannel: move channel selection
> above transport layer" from Apr 24, 2020, leads to the following
> static checker warning:
>
>         fs/cifs/smb2pdu.c:149 smb2_hdr_assemble()
>         error: we previously assumed 'tcon->ses' could be null (see line 133)
>
> fs/cifs/smb2pdu.c
>    120          shdr->ProcessId = cpu_to_le32((__u16)current->tgid);
>    121
>    122          if (!tcon)
>    123                  goto out;
>    124
>    125          /* GLOBAL_CAP_LARGE_MTU will only be set if dialect > SMB2.02 */
>    126          /* See sections 2.2.4 and 3.2.4.1.5 of MS-SMB2 */
>    127          if (server && (server->capabilities & SMB2_GLOBAL_CAP_LARGE_MTU))
>    128                  shdr->CreditCharge = cpu_to_le16(1);
>    129          /* else CreditCharge MBZ */
>    130
>    131          shdr->TreeId = tcon->tid;
>    132          /* Uid is not converted */
>    133          if (tcon->ses)
>                     ^^^^^^^^^
> Check for NULL.
>
>    134                  shdr->SessionId = tcon->ses->Suid;
>    135
>    136          /*
>    137           * If we would set SMB2_FLAGS_DFS_OPERATIONS on open we also would have
>    138           * to pass the path on the Open SMB prefixed by \\server\share.
>    139           * Not sure when we would need to do the augmented path (if ever) and
>    140           * setting this flag breaks the SMB2 open operation since it is
>    141           * illegal to send an empty path name (without \\server\share prefix)
>    142           * when the DFS flag is set in the SMB open header. We could
>    143           * consider setting the flag on all operations other than open
>    144           * but it is safer to net set it for now.
>    145           */
>    146  /*      if (tcon->share_flags & SHI1005_FLAGS_DFS)
>    147                  shdr->Flags |= SMB2_FLAGS_DFS_OPERATIONS; */
>    148
>    149          if (server && server->sign && !smb3_encryption_required(tcon))
>                                                                         ^^^^
> Unchecked dereference inside the function.  There used to be a bunch
> of checks for NULL "tcon->ses" but some of them were replaces with a
> check for "server" instead.
>
>    150                  shdr->Flags |= SMB2_FLAGS_SIGNED;
>    151  out:
>    152          return;
>    153  }
>
> regards,
> dan carpenter



-- 
Thanks,

Steve

--000000000000ac460805a6f6db9a
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-remove-static-checker-warning.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-remove-static-checker-warning.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kavgyo580>
X-Attachment-Id: f_kavgyo580

RnJvbSBjOGUzYzE3ZmQxOWM5OTg0MjM0ODBjZWJlMTgzZWVkMjIxOTY4NWZhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFN1biwgMzEgTWF5IDIwMjAgMTQ6MzY6NTYgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiByZW1vdmUgc3RhdGljIGNoZWNrZXIgd2FybmluZwoKUmVtb3ZlIHN0YXRpYyBjaGVja2Vy
IHdhcm5pbmcgcG9pbnRlZCBvdXQgYnkgRGFuIENhcnBlbnRlcjoKClRoZSBwYXRjaCBmZWVhZWM2
MjFjMDk6ICJjaWZzOiBtdWx0aWNoYW5uZWw6IG1vdmUgY2hhbm5lbCBzZWxlY3Rpb24KYWJvdmUg
dHJhbnNwb3J0IGxheWVyIiBmcm9tIEFwciAyNCwgMjAyMCwgbGVhZHMgdG8gdGhlIGZvbGxvd2lu
ZwpzdGF0aWMgY2hlY2tlciB3YXJuaW5nOgoKICAgICAgICBmcy9jaWZzL3NtYjJwZHUuYzoxNDkg
c21iMl9oZHJfYXNzZW1ibGUoKQogICAgICAgIGVycm9yOiB3ZSBwcmV2aW91c2x5IGFzc3VtZWQg
J3Rjb24tPnNlcycgY291bGQgYmUgbnVsbCAoc2VlIGxpbmUgMTMzKQoKUmVwb3J0ZWQtYnk6IERh
biBDYXJwZW50ZXIgPGRhbi5jYXJwZW50ZXJAb3JhY2xlLmNvbT4KQ0M6IEF1cmVsaWVuIEFwdGVs
IDxhcHRlbEBzdXNlLmNvbT4KU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBt
aWNyb3NvZnQuY29tPgotLS0KIGZzL2NpZnMvc21iMnBkdS5jIHwgMiArLQogMSBmaWxlIGNoYW5n
ZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9z
bWIycGR1LmMgYi9mcy9jaWZzL3NtYjJwZHUuYwppbmRleCAwODcyOGMwZGNmOGIuLjIwM2E2YmQ1
NTA3OSAxMDA2NDQKLS0tIGEvZnMvY2lmcy9zbWIycGR1LmMKKysrIGIvZnMvY2lmcy9zbWIycGR1
LmMKQEAgLTg1LDcgKzg1LDcgQEAgc3RhdGljIGNvbnN0IGludCBzbWIyX3JlcV9zdHJ1Y3Rfc2l6
ZXNbTlVNQkVSX09GX1NNQjJfQ09NTUFORFNdID0gewogCiBpbnQgc21iM19lbmNyeXB0aW9uX3Jl
cXVpcmVkKGNvbnN0IHN0cnVjdCBjaWZzX3Rjb24gKnRjb24pCiB7Ci0JaWYgKCF0Y29uKQorCWlm
ICghdGNvbiB8fCAhdGNvbi0+c2VzKQogCQlyZXR1cm4gMDsKIAlpZiAoKHRjb24tPnNlcy0+c2Vz
c2lvbl9mbGFncyAmIFNNQjJfU0VTU0lPTl9GTEFHX0VOQ1JZUFRfREFUQSkgfHwKIAkgICAgKHRj
b24tPnNoYXJlX2ZsYWdzICYgU0hJMTAwNV9GTEFHU19FTkNSWVBUX0RBVEEpKQotLSAKMi4yNS4x
Cgo=
--000000000000ac460805a6f6db9a--
