Return-Path: <SRS0=BWmz=5Z=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09BA1C2BA19
	for <linux-cifs@archiver.kernel.org>; Thu,  9 Apr 2020 18:29:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D221D206E9
	for <linux-cifs@archiver.kernel.org>; Thu,  9 Apr 2020 18:29:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="leT2P4u+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbgDIS3e (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 9 Apr 2020 14:29:34 -0400
Received: from mail-yb1-f172.google.com ([209.85.219.172]:39731 "EHLO
        mail-yb1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726574AbgDIS3d (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 9 Apr 2020 14:29:33 -0400
Received: by mail-yb1-f172.google.com with SMTP id h205so6227691ybg.6
        for <linux-cifs@vger.kernel.org>; Thu, 09 Apr 2020 11:29:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GWVvjBBHdtWy2ie+JdXFx6U/tSYY5wfRxaoF+YjVIn8=;
        b=leT2P4u+B1ebJf3zgalw1jqKzluXnJg7RJ7oC5Swz6q+qo8YAckk15r5+rTcBi2oOA
         H4dJZ1OX1TCFLf9C07W1mHScwc3le9TmaksKeXfGnXV8MxMXtEj2w1rX2mvON2GHr2EZ
         rb+z2gHfAtwB9DCXXahOyCoqrW9z9v6iZmds6qfnLFg1xne3p2nC3n2fYtcEb85jAhjF
         L8FPAfHrwy/xD+SdNVqGOPlPYo4r+kb1DwAYkZRe0qhJ3JYong0hMVltNREqsesVXN7e
         6JjSEtVlKFLSBuyCt/GTisLCtFBTitkmBxBrv0DU1sUC4wProKTrtiPrtIQQfqtK9Wu/
         LylA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GWVvjBBHdtWy2ie+JdXFx6U/tSYY5wfRxaoF+YjVIn8=;
        b=NVLJODnQdnyzchySUAZWN2PPIbpUGuejVIhlZuIyyUTE+PXuNL6xSwoIAaJhKNdcAD
         LSM3cQBCF7dHV1AaJLBHjDEApGf+ZLGSzt7zbhVvy3Pc3eT/ShJ+yz0vT6ufweB6hM8h
         K+MbEolq2mGysKU6XTmLHBxEPBLko0BOZ3cnMp6EkdBK1bJkDXqQXZAbPylkWBDlce9R
         KL/4OrHLMZRqDqgjEo3HIGAk0HlnpvCcFKFpeMiDjxXvHhLXPLBoqDQteDYrQfnsO8Np
         eYyumnXt2vaOb8Ur9519XU3iQIzeSBC5tkZy48NNgi4DPq2a651zq7lCo4binLk2Xlsb
         f5Pg==
X-Gm-Message-State: AGi0PubFSBqyIy7zyX+o28S+fkIXHHLYliRHwAo6tyYZwkvuxyqeYJ+l
        oFsFqpJ39tUjjQ7uaMwxxt3aL/HWWNxp1KPqZgqJlBg0
X-Google-Smtp-Source: APiQypKO00seBM6UkUPjn05l0ZhewXhzfd8NxR6La3envf1x81BmlKO6BvrmXN0l1htIrRg/70mpZmfCrPm5btyKcy4=
X-Received: by 2002:a5b:443:: with SMTP id s3mr1794016ybp.14.1586456972785;
 Thu, 09 Apr 2020 11:29:32 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mta--YFUVWWf89bCBvdjrDh_vaC4ty8Qphsy5W1fDuOYw@mail.gmail.com>
 <877dypdlvl.fsf@suse.com>
In-Reply-To: <877dypdlvl.fsf@suse.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 9 Apr 2020 13:29:21 -0500
Message-ID: <CAH2r5msWAB+UkDTc8MiX3=JTkRdE4HaDbpR4L=ZcLyqyEy2ncQ@mail.gmail.com>
Subject: Re: [PATCH][SMB3.1.1 POSIX] Change noisy debug message to an FYI
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="00000000000050a36005a2dfcc4e"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--00000000000050a36005a2dfcc4e
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Updated


On Thu, Apr 9, 2020 at 4:55 AM Aur=C3=A9lien Aptel <aaptel@suse.com> wrote:
>
> Steve French <smfrench@gmail.com> writes:
> >     The noisy posix error message in readdir was supposed
> >     to be an FYI (not enabled by default)
> >       CIFS VFS: XXX dev 66306, reparse 0, mode 755
>
> Oops, the XXX was not supposed to be there either. Can you remove it?
>
> Cheers,
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg,=
 DE
> GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=
=BCnchen)



--=20
Thanks,

Steve

--00000000000050a36005a2dfcc4e
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-change-noisy-error-message-to-FYI.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-change-noisy-error-message-to-FYI.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_k8t3ifja0>
X-Attachment-Id: f_k8t3ifja0

RnJvbSAyMzI3MzI3MjI3MWZlMjdiN2NmZjliYTlmOTYyYzk4MDRiMTdhYmNkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFRodSwgOSBBcHIgMjAyMCAwMTowNzozOCAtMDUwMApTdWJqZWN0OiBbUEFUQ0hdIHNt
YjM6IGNoYW5nZSBub2lzeSBlcnJvciBtZXNzYWdlIHRvIEZZSQoKVGhlIG5vaXN5IHBvc2l4IGVy
cm9yIG1lc3NhZ2UgaW4gcmVhZGRpciB3YXMgc3VwcG9zZWQKdG8gYmUgYW4gRllJIChub3QgZW5h
YmxlZCBieSBkZWZhdWx0KQogIENJRlMgVkZTOiBYWFggZGV2IDY2MzA2LCByZXBhcnNlIDAsIG1v
ZGUgNzU1CgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5j
b20+ClJldmlld2VkLWJ5OiBBdXJlbGllbiBBcHRlbCA8YWFwdGVsQHN1c2UuY29tPgotLS0KIGZz
L2NpZnMvcmVhZGRpci5jIHwgMiArLQogMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAx
IGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9yZWFkZGlyLmMgYi9mcy9jaWZzL3Jl
YWRkaXIuYwppbmRleCAxOWU0YTVkM2I0Y2EuLjQyM2Q4NWMxYmE2ZiAxMDA2NDQKLS0tIGEvZnMv
Y2lmcy9yZWFkZGlyLmMKKysrIGIvZnMvY2lmcy9yZWFkZGlyLmMKQEAgLTI0Niw3ICsyNDYsNyBA
QCBjaWZzX3Bvc2l4X3RvX2ZhdHRyKHN0cnVjdCBjaWZzX2ZhdHRyICpmYXR0ciwgc3RydWN0IHNt
YjJfcG9zaXhfaW5mbyAqaW5mbywKIAkgKi8KIAlmYXR0ci0+Y2ZfbW9kZSA9IGxlMzJfdG9fY3B1
KGluZm8tPk1vZGUpICYgflNfSUZNVDsKIAotCWNpZnNfZGJnKFZGUywgIlhYWCBkZXYgJWQsIHJl
cGFyc2UgJWQsIG1vZGUgJW8iLAorCWNpZnNfZGJnKEZZSSwgInBvc2l4IGZhdHRyOiBkZXYgJWQs
IHJlcGFyc2UgJWQsIG1vZGUgJW8iLAogCQkgbGUzMl90b19jcHUoaW5mby0+RGV2aWNlSWQpLAog
CQkgbGUzMl90b19jcHUoaW5mby0+UmVwYXJzZVRhZyksCiAJCSBsZTMyX3RvX2NwdShpbmZvLT5N
b2RlKSk7Ci0tIAoyLjIwLjEKCg==
--00000000000050a36005a2dfcc4e--
