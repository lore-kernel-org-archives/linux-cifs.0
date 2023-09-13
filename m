Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA5B8EE49B7
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Sep 2023 01:42:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233643AbjIMBmy (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 12 Sep 2023 21:42:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231204AbjIMBmy (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 12 Sep 2023 21:42:54 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2717D115
        for <linux-cifs@vger.kernel.org>; Tue, 12 Sep 2023 18:42:50 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id 2adb3069b0e04-501cef42bc9so10315309e87.0
        for <linux-cifs@vger.kernel.org>; Tue, 12 Sep 2023 18:42:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694569368; x=1695174168; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=DFMRgHnjvmG5N/kHqVYSEsa2CA/Tz+01vVqY5O2FtPQ=;
        b=BvdYV2CXI1UzYsqeRuF2S/QApIOlkiS/r0ilZw9GRB8YuEEixOBYjEcqZPzXCHCDJq
         V/fVAT+6/wUR7U0THQwOzAdZPjeo7wJb4SA4EJnvgM7z9uGzEaHhSlc+dTYdb2YnllHD
         n7r9wknYc1ChpUWQGbyJRavLHOqRe2DYf3M0MKRbMEhxfRe8U85yWxnb9fNvTdDd4he4
         yqC40imd4BxhyV5H6v2zomZNikqj505JmO1yBpWLykX8xn5i5IpAXCdHVf1nGvKosOqD
         1vq8EDIftdw7oGevN1fviMQUOO3E9G+0p3MGcHRRCi0Zpbj1w+oID57iGCohLeDkQ14H
         Lutw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694569368; x=1695174168;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DFMRgHnjvmG5N/kHqVYSEsa2CA/Tz+01vVqY5O2FtPQ=;
        b=gaDPy2v9LZHPeE3415eyqchkstIaa2Z2vdXIramnbsV2H548dkDgH8L3l+VgQk7Z0I
         Z7Azc/1181xWplAbA8n6AsHNT4fFm4eur1+P3aki9BGTZq4jBlTVyoq7yxw5K/9htZIG
         NrLt8PIKtYzCtJ0GaSzTuzk4STSbkrdNEIrHYGEM0EWjq/dHqsCdh5jsVcHAQPUkDEpe
         ytIWCgCd6XfykegQ8d+Kt6Oh/5YWVIEVOR5sl28KRZLX2VsL8TrANPHECHZK+kNl+StB
         fUNcfXXWh9haEfC2xNFpjMlguxdJP0UU6stnq8Nel6gpWEvPFCCJPJTnahZTJW/AVW2X
         AuFw==
X-Gm-Message-State: AOJu0YwJHECDGd4vCjMVuMF2pi2i3JqI2dDBwVEELyoabc/wecfAbapf
        rI8xPZl08K0HNjAalC2BxmwNyeM2h+Mu8w96cITif/hAZ7U=
X-Google-Smtp-Source: AGHT+IHBtHQJTisTKU0tS56bFy1DLZqLy4JwTCMyJbA73qZisSeAF0ajzUzTcp2iCEvoJh8rAm4oh/y9U+KpZeawtQQ=
X-Received: by 2002:a05:6512:31c3:b0:4f8:7897:55e6 with SMTP id
 j3-20020a05651231c300b004f8789755e6mr1003059lfe.45.1694569368096; Tue, 12 Sep
 2023 18:42:48 -0700 (PDT)
MIME-Version: 1.0
References: <64897822-3af9-49ee-98a5-97858b594d6b@moroto.mountain>
In-Reply-To: <64897822-3af9-49ee-98a5-97858b594d6b@moroto.mountain>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 12 Sep 2023 20:42:36 -0500
Message-ID: <CAH2r5muif8cCa8RMrbmcoGnHnF1_GN4-5mLG6NTggGFQEaC+9A@mail.gmail.com>
Subject: Re: [bug report] [SMB3] send channel sequence number in SMB3 requests
 after reconnects
To:     Dan Carpenter <dan.carpenter@linaro.org>
Cc:     stfrench@microsoft.com, linux-cifs@vger.kernel.org
Content-Type: multipart/mixed; boundary="0000000000003baae8060533ad45"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000003baae8060533ad45
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Fixed and put in cifs-2.6.git for-next pending any additional reviewing/tes=
ting

On Tue, Sep 12, 2023 at 12:34=E2=80=AFAM Dan Carpenter <dan.carpenter@linar=
o.org> wrote:
>
> Hello Steve French,
>
> This is a semi-automatic email about new static checker warnings.
>
> The patch 09ee7a3bf866: "[SMB3] send channel sequence number in SMB3
> requests after reconnects" from Aug 24, 2023, leads to the following
> Smatch complaint:
>
>     fs/smb/client/smb2pdu.c:105 smb2_hdr_assemble()
>     warn: variable dereferenced before check 'server' (see line 95)
>
> fs/smb/client/smb2pdu.c
>     94          shdr->Command =3D smb2_cmd;
>     95          if (server->dialect >=3D SMB30_PROT_ID) {
>                     ^^^^^^^^
> Unchecked dereference
>
>     96                  /* After reconnect SMB3 must set ChannelSequence =
on subsequent reqs */
>     97                  smb3_hdr =3D (struct smb3_hdr_req *)shdr;
>     98                  /* if primary channel is not set yet, use default=
 channel for chan sequence num */
>     99                  if (SERVER_IS_CHAN(server))
>    100                          smb3_hdr->ChannelSequence =3D
>    101                                  cpu_to_le16(server->primary_serve=
r->channel_sequence_num);
>    102                  else
>    103                          smb3_hdr->ChannelSequence =3D cpu_to_le16=
(server->channel_sequence_num);
>    104          }
>    105          if (server) {
>                     ^^^^^^
> The existing code assumed that server could be NULL
>
>    106                  spin_lock(&server->req_lock);
>    107                  /* Request up to 10 credits but don't go over the=
 limit. */
>
> regards,
> dan carpenter



--=20
Thanks,

Steve

--0000000000003baae8060533ad45
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-move-server-check-earlier-when-setting-channel-.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-move-server-check-earlier-when-setting-channel-.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lmh2u34u0>
X-Attachment-Id: f_lmh2u34u0

RnJvbSAwNWQwZjhmNTVhZDYwODU0Y2I3MDY3OThkYTk0Mjc2YTMzNTkwNDQ1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFR1ZSwgMTIgU2VwIDIwMjMgMTQ6MDg6MzYgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBtb3ZlIHNlcnZlciBjaGVjayBlYXJsaWVyIHdoZW4gc2V0dGluZyBjaGFubmVsIHNlcXVl
bmNlCiBudW1iZXIKClNtYXRjaCB3YXJuaW5nIHBvaW50ZWQgb3V0IGJ5IERhbiBDYXJwZW50ZXI6
CgogICAgZnMvc21iL2NsaWVudC9zbWIycGR1LmM6MTA1IHNtYjJfaGRyX2Fzc2VtYmxlKCkKICAg
IHdhcm46IHZhcmlhYmxlIGRlcmVmZXJlbmNlZCBiZWZvcmUgY2hlY2sgJ3NlcnZlcicgKHNlZSBs
aW5lIDk1KQoKRml4ZXM6IDA5ZWU3YTNiZjg2NiAoIltTTUIzXSBzZW5kIGNoYW5uZWwgc2VxdWVu
Y2UgbnVtYmVyIGluIFNNQjMgcmVxdWVzdHMgYWZ0ZXIgcmVjb25uZWN0cyIpClJlcG9ydGVkLWJ5
OiBEYW4gQ2FycGVudGVyIDxkYW4uY2FycGVudGVyQGxpbmFyby5vcmc+ClNpZ25lZC1vZmYtYnk6
IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9zbWIvY2xpZW50
L3NtYjJwZHUuYyB8IDI1ICsrKysrKysrKysrKysrKy0tLS0tLS0tLS0KIDEgZmlsZSBjaGFuZ2Vk
LCAxNSBpbnNlcnRpb25zKCspLCAxMCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9zbWIv
Y2xpZW50L3NtYjJwZHUuYyBiL2ZzL3NtYi9jbGllbnQvc21iMnBkdS5jCmluZGV4IDA5MmIwMDg3
YzlkYy4uMzQwMzE4OGUzMTAwIDEwMDY0NAotLS0gYS9mcy9zbWIvY2xpZW50L3NtYjJwZHUuYwor
KysgYi9mcy9zbWIvY2xpZW50L3NtYjJwZHUuYwpAQCAtOTIsMTcgKzkyLDIyIEBAIHNtYjJfaGRy
X2Fzc2VtYmxlKHN0cnVjdCBzbWIyX2hkciAqc2hkciwgX19sZTE2IHNtYjJfY21kLAogCXNoZHIt
PlByb3RvY29sSWQgPSBTTUIyX1BST1RPX05VTUJFUjsKIAlzaGRyLT5TdHJ1Y3R1cmVTaXplID0g
Y3B1X3RvX2xlMTYoNjQpOwogCXNoZHItPkNvbW1hbmQgPSBzbWIyX2NtZDsKLQlpZiAoc2VydmVy
LT5kaWFsZWN0ID49IFNNQjMwX1BST1RfSUQpIHsKLQkJLyogQWZ0ZXIgcmVjb25uZWN0IFNNQjMg
bXVzdCBzZXQgQ2hhbm5lbFNlcXVlbmNlIG9uIHN1YnNlcXVlbnQgcmVxcyAqLwotCQlzbWIzX2hk
ciA9IChzdHJ1Y3Qgc21iM19oZHJfcmVxICopc2hkcjsKLQkJLyogaWYgcHJpbWFyeSBjaGFubmVs
IGlzIG5vdCBzZXQgeWV0LCB1c2UgZGVmYXVsdCBjaGFubmVsIGZvciBjaGFuIHNlcXVlbmNlIG51
bSAqLwotCQlpZiAoU0VSVkVSX0lTX0NIQU4oc2VydmVyKSkKLQkJCXNtYjNfaGRyLT5DaGFubmVs
U2VxdWVuY2UgPQotCQkJCWNwdV90b19sZTE2KHNlcnZlci0+cHJpbWFyeV9zZXJ2ZXItPmNoYW5u
ZWxfc2VxdWVuY2VfbnVtKTsKLQkJZWxzZQotCQkJc21iM19oZHItPkNoYW5uZWxTZXF1ZW5jZSA9
IGNwdV90b19sZTE2KHNlcnZlci0+Y2hhbm5lbF9zZXF1ZW5jZV9udW0pOwotCX0KKwogCWlmIChz
ZXJ2ZXIpIHsKKwkJLyogQWZ0ZXIgcmVjb25uZWN0IFNNQjMgbXVzdCBzZXQgQ2hhbm5lbFNlcXVl
bmNlIG9uIHN1YnNlcXVlbnQgcmVxcyAqLworCQlpZiAoc2VydmVyLT5kaWFsZWN0ID49IFNNQjMw
X1BST1RfSUQpIHsKKwkJCXNtYjNfaGRyID0gKHN0cnVjdCBzbWIzX2hkcl9yZXEgKilzaGRyOwor
CQkJLyoKKwkJCSAqIGlmIHByaW1hcnkgY2hhbm5lbCBpcyBub3Qgc2V0IHlldCwgdXNlIGRlZmF1
bHQKKwkJCSAqIGNoYW5uZWwgZm9yIGNoYW4gc2VxdWVuY2UgbnVtCisJCQkgKi8KKwkJCWlmIChT
RVJWRVJfSVNfQ0hBTihzZXJ2ZXIpKQorCQkJCXNtYjNfaGRyLT5DaGFubmVsU2VxdWVuY2UgPQor
CQkJCQljcHVfdG9fbGUxNihzZXJ2ZXItPnByaW1hcnlfc2VydmVyLT5jaGFubmVsX3NlcXVlbmNl
X251bSk7CisJCQllbHNlCisJCQkJc21iM19oZHItPkNoYW5uZWxTZXF1ZW5jZSA9CisJCQkJCWNw
dV90b19sZTE2KHNlcnZlci0+Y2hhbm5lbF9zZXF1ZW5jZV9udW0pOworCQl9CiAJCXNwaW5fbG9j
aygmc2VydmVyLT5yZXFfbG9jayk7CiAJCS8qIFJlcXVlc3QgdXAgdG8gMTAgY3JlZGl0cyBidXQg
ZG9uJ3QgZ28gb3ZlciB0aGUgbGltaXQuICovCiAJCWlmIChzZXJ2ZXItPmNyZWRpdHMgPj0gc2Vy
dmVyLT5tYXhfY3JlZGl0cykKLS0gCjIuMzkuMgoK
--0000000000003baae8060533ad45--
