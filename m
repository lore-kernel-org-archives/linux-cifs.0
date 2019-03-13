Return-Path: <SRS0=HHpq=RQ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C77EDC43381
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Mar 2019 07:43:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C6FC2171F
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Mar 2019 07:43:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="noPxVOL6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726606AbfCMHnG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 13 Mar 2019 03:43:06 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:44688 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726539AbfCMHnF (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 13 Mar 2019 03:43:05 -0400
Received: by mail-pf1-f195.google.com with SMTP id a3so767836pff.11
        for <linux-cifs@vger.kernel.org>; Wed, 13 Mar 2019 00:43:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9V09ttnUlqNDSFakz4upr2WJfjJyrHTK2xANm3VkRcc=;
        b=noPxVOL6aEzCAMQTNEXA7cuNknm9cg8Br7BwMPCsBOcVr2QR4ZSJoReb19az99wXUk
         DlX/iJliPZfrqeuQunXysHG20idFOPkHpLSg/ljCKPM0yMsetcJNEn2Il6uy5byOLle7
         omFEN3NmILAoI6iGHZE+XJ6WHy70xfqg5Cbe6tbK8y4uT7nN3c8FRYVcOSY72t4D131m
         60nno2V/q0l3lh+1ACSM5SLP8Ia8lgbLg2ItUR7JYcI49kpEY7aNwYz1Ek3/Oa7M1vQ3
         KWr3kL1PwmAWxKVJt4foWqqVKPzUt9LhQc5wtzK+pec8uzXwaDOShkuxkCYxWFOkbDrW
         wW4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9V09ttnUlqNDSFakz4upr2WJfjJyrHTK2xANm3VkRcc=;
        b=dF+dPoYo8cNUIuS13PkZVV38U0HAtbzUjPZqZzf/KlgbTwRouRVJ0m7m2iECRW9tBo
         W6jM78w1eJo4YWkgDcrVSMrqEPKiHV7udVrFlwSWSi5DIcZUM79+XOD5Ni/Wn/OP9yPR
         hUBUdjvlzIJ5yA5TWn3qO7Dj8ccDLoyXwL7enf9vPhMEFr7/nL32RUQSX1arwPq0IVgw
         HR/pPkKGcVy1qncXHLJavtXUl27IyoBEGPu5Vor0tS9JvzkiWZGWRCN7lFrg6Q6OKVA4
         lUqd5UVt8KB7bb+lmOYmKGxOz33BO+KYljFGvg9ovI6b3SoHb1A63yPFhWcMThU3pvOO
         B18g==
X-Gm-Message-State: APjAAAXEg326deReWlrnTpIs83tfNPVVx1rTUNNJ+u8FzokolRfQQL+F
        b7uL0WbJXuE9mdlI0E++itwAfPLDSHxDNFKduJEYhg==
X-Google-Smtp-Source: APXvYqyulvjMqsqcOjs5Ad914O5dI7Me4ThxKNIBI4e0MliX9bhMmHP+eZd4DakqsO8C2TMyjcWAideW/9hFgsSMXVc=
X-Received: by 2002:a17:902:1744:: with SMTP id i62mr43780920pli.24.1552462984353;
 Wed, 13 Mar 2019 00:43:04 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5muDfiv2=VpUDTkbW3h+05ubMHsMe53nzjwp9apu=-1-tA@mail.gmail.com>
 <CAN05THT45xzH3K0YrATJY9UXvoN_qbQ-ZryCaichogaG_+marw@mail.gmail.com>
In-Reply-To: <CAN05THT45xzH3K0YrATJY9UXvoN_qbQ-ZryCaichogaG_+marw@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 13 Mar 2019 02:42:53 -0500
Message-ID: <CAH2r5msD5foJdj3Hdz6ihhXpX3v1VPMbS+4KksC32xQLiOcV6Q@mail.gmail.com>
Subject: Re: [SMB3][PATCH]
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000b5c5820583f4f412"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000b5c5820583f4f412
Content-Type: text/plain; charset="UTF-8"

Rearranged the clauses per Ronnie's suggestion.  Ver2 attached


On Wed, Mar 13, 2019 at 2:33 AM ronnie sahlberg
<ronniesahlberg@gmail.com> wrote:
>
> Looks good.
>
> Minor nit is
> + } else if (qi.flags != PASSTHRU_QUERY_INFO) {
> + cifs_dbg(VFS, "invalid passthru query flags: 0x%x\n", qi.flags);
> + rc = -EINVAL;
> + } else {
> + memset(&qi_iov, 0, sizeof(qi_iov));
> + rqst[1].rq_iov = qi_iov;
> + rqst[1].rq_nvec = 1;
>
> I think it is clearer if the "nothing matched, error out" conditional
> is the last one in the chain.
> I.e. swap them around.
>
> reviewedby me
>
> On Wed, Mar 13, 2019 at 5:29 PM Steve French <smfrench@gmail.com> wrote:
> >
> > SMB3: passthru query info doesn't check for SMB3 FSCTL passthru
> >
> > The passthrough queries from user space tools like smbinfo can be either
> > SMB3 QUERY_INFO or SMB3 FSCTL, but we are not checking for the latter.
> > Temporarily we return EOPNOTSUPP for SMB3 FSCTL passthrough requests
> > but once compounding fsctls is fixed we can remove the EOPNOTSUPP.
> >
> >
> > --
> > Thanks,
> >
> > Steve



-- 
Thanks,

Steve

--000000000000b5c5820583f4f412
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-SMB3-passthru-query-info-doesn-t-check-for-SMB3-FSCT.patch"
Content-Disposition: attachment; 
	filename="0001-SMB3-passthru-query-info-doesn-t-check-for-SMB3-FSCT.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jt6wda2u0>
X-Attachment-Id: f_jt6wda2u0

RnJvbSBjMWNjMDQyOTFiNGI1MjgxYmRiMWFlM2E4ZjgzZGI4MGFhMDhlYWUwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFdlZCwgMTMgTWFyIDIwMTkgMDI6NDA6MDcgLTA1MDAKU3ViamVjdDogW1BBVENIXSBT
TUIzOiBwYXNzdGhydSBxdWVyeSBpbmZvIGRvZXNuJ3QgY2hlY2sgZm9yIFNNQjMgRlNDVEwKIHBh
c3N0aHJ1CgpUaGUgcGFzc3Rocm91Z2ggcXVlcmllcyBmcm9tIHVzZXIgc3BhY2UgdG9vbHMgbGlr
ZSBzbWJpbmZvIGNhbiBiZSBlaXRoZXIKU01CMyBRVUVSWV9JTkZPIG9yIFNNQjMgRlNDVEwsIGJ1
dCB3ZSBhcmUgbm90IGNoZWNraW5nIGZvciB0aGUgbGF0dGVyLgpUZW1wb3JhcmlseSB3ZSByZXR1
cm4gRU9QTk9UU1VQUCBmb3IgU01CMyBGU0NUTCBwYXNzdGhyb3VnaCByZXF1ZXN0cwpidXQgb25j
ZSBjb21wb3VuZGluZyBmc2N0bHMgaXMgZml4ZWQgY2FuIGVuYWJsZS4KClNpZ25lZC1vZmYtYnk6
IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KUmV2aWV3ZWQtYnk6IFJvbm5p
ZSBTYWhsYmVyZyA8bHNhaGxiZXJAcmVkaGF0LmNvbT4KLS0tCiBmcy9jaWZzL2NpZnNfaW9jdGwu
aCB8ICAzICsrKwogZnMvY2lmcy9zbWIyb3BzLmMgICAgfCAyNiArKysrKysrKysrKysrKysrKysr
LS0tLS0tLQogMiBmaWxlcyBjaGFuZ2VkLCAyMiBpbnNlcnRpb25zKCspLCA3IGRlbGV0aW9ucygt
KQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY2lmc19pb2N0bC5oIGIvZnMvY2lmcy9jaWZzX2lvY3Rs
LmgKaW5kZXggZDhiY2UyZjg2MmRlLi4wODZkZGM1MTA4YWYgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMv
Y2lmc19pb2N0bC5oCisrKyBiL2ZzL2NpZnMvY2lmc19pb2N0bC5oCkBAIC00Myw2ICs0Myw5IEBA
IHN0cnVjdCBzbWJfc25hcHNob3RfYXJyYXkgewogCS8qCXNuYXBzaG90c1tdOyAqLwogfSBfX3Bh
Y2tlZDsKIAorLyogcXVlcnlfaW5mbyBmbGFncyAqLworI2RlZmluZSBQQVNTVEhSVV9RVUVSWV9J
TkZPCTB4MDAwMDAwMDAKKyNkZWZpbmUgUEFTU1RIUlVfRlNDVEwJCTB4MDAwMDAwMDEKIHN0cnVj
dCBzbWJfcXVlcnlfaW5mbyB7CiAJX191MzIgICBpbmZvX3R5cGU7CiAJX191MzIgICBmaWxlX2lu
Zm9fY2xhc3M7CmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYjJvcHMuYyBiL2ZzL2NpZnMvc21iMm9w
cy5jCmluZGV4IDgyM2E1ODU1MGRmZC4uMzJkZGU4N2ZlYWE5IDEwMDY0NAotLS0gYS9mcy9jaWZz
L3NtYjJvcHMuYworKysgYi9mcy9jaWZzL3NtYjJvcHMuYwpAQCAtMTM5MCwxNSArMTM5MCwyNyBA
QCBzbWIyX2lvY3RsX3F1ZXJ5X2luZm8oY29uc3QgdW5zaWduZWQgaW50IHhpZCwKIAlzbWIyX3Nl
dF9uZXh0X2NvbW1hbmQodGNvbiwgJnJxc3RbMF0pOwogCiAJLyogUXVlcnkgKi8KLQltZW1zZXQo
JnFpX2lvdiwgMCwgc2l6ZW9mKHFpX2lvdikpOwotCXJxc3RbMV0ucnFfaW92ID0gcWlfaW92Owot
CXJxc3RbMV0ucnFfbnZlYyA9IDE7Ci0KLQlyYyA9IFNNQjJfcXVlcnlfaW5mb19pbml0KHRjb24s
ICZycXN0WzFdLCBDT01QT1VORF9GSUQsIENPTVBPVU5EX0ZJRCwKLQkJCQkgIHFpLmZpbGVfaW5m
b19jbGFzcywgcWkuaW5mb190eXBlLAotCQkJCSAgcWkuYWRkaXRpb25hbF9pbmZvcm1hdGlvbiwK
KwlpZiAocWkuZmxhZ3MgJiBQQVNTVEhSVV9GU0NUTCkgeworCQkvKiBDYW4gZXZlbnR1YWxseSBy
ZWxheCBwZXJtIGNoZWNrIHNpbmNlIHNlcnZlciBlbmZvcmNlcyB0b28gKi8KKwkJaWYgKCFjYXBh
YmxlKENBUF9TWVNfQURNSU4pKQorCQkJcmMgPSAtRVBFUk07CisJCWVsc2UgIC8qIFRCRDogQWRk
IGNvZGUgdG8gY29tcG91bmQgRlNDVEwgKi8KKwkJCXJjID0gLUVPUE5PVFNVUFA7CisJfSBlbHNl
IGlmIChxaS5mbGFncyA9PSBQQVNTVEhSVV9RVUVSWV9JTkZPKSB7CisJCW1lbXNldCgmcWlfaW92
LCAwLCBzaXplb2YocWlfaW92KSk7CisJCXJxc3RbMV0ucnFfaW92ID0gcWlfaW92OworCQlycXN0
WzFdLnJxX252ZWMgPSAxOworCisJCXJjID0gU01CMl9xdWVyeV9pbmZvX2luaXQodGNvbiwgJnJx
c3RbMV0sIENPTVBPVU5EX0ZJRCwKKwkJCQkgIENPTVBPVU5EX0ZJRCwgcWkuZmlsZV9pbmZvX2Ns
YXNzLAorCQkJCSAgcWkuaW5mb190eXBlLCBxaS5hZGRpdGlvbmFsX2luZm9ybWF0aW9uLAogCQkJ
CSAgcWkuaW5wdXRfYnVmZmVyX2xlbmd0aCwKIAkJCQkgIHFpLm91dHB1dF9idWZmZXJfbGVuZ3Ro
LCBidWZmZXIpOworCX0gZWxzZSB7IC8qIHVua25vd24gZmxhZ3MgKi8KKwkJY2lmc19kYmcoVkZT
LCAiaW52YWxpZCBwYXNzdGhydSBxdWVyeSBmbGFnczogMHgleFxuIiwgcWkuZmxhZ3MpOworCQly
YyA9IC1FSU5WQUw7CisJfQorCiAJaWYgKHJjKQogCQlnb3RvIGlxaW5mX2V4aXQ7CiAJc21iMl9z
ZXRfbmV4dF9jb21tYW5kKHRjb24sICZycXN0WzFdKTsKLS0gCjIuMTcuMQoK
--000000000000b5c5820583f4f412--
