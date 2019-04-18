Return-Path: <SRS0=zBrE=SU=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DA95C10F0E
	for <linux-cifs@archiver.kernel.org>; Thu, 18 Apr 2019 16:07:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4498C20693
	for <linux-cifs@archiver.kernel.org>; Thu, 18 Apr 2019 16:07:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HFLhI+q2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389016AbfDRQHK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 18 Apr 2019 12:07:10 -0400
Received: from mail-pg1-f176.google.com ([209.85.215.176]:45944 "EHLO
        mail-pg1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725888AbfDRQHK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 18 Apr 2019 12:07:10 -0400
Received: by mail-pg1-f176.google.com with SMTP id y3so1394712pgk.12
        for <linux-cifs@vger.kernel.org>; Thu, 18 Apr 2019 09:07:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=sKF0jK9b9yJIjxLEg5h1WJiNnPHeqBXNuciZYywUK10=;
        b=HFLhI+q2BzvgsHuEUHB0tKySjdJYSa1YczIvTy3wgA3iKanCkDVEppjN2qdFs+NZ5X
         0eRf5T/+1FxcYXAUfUCLdcC7EsLAQbKrdCttm+aMiFjHEmhc76jeCGhHKb4sskUTLooE
         bgUkfNn6beVgnnI96XNm026vC/M7lhGcCs63BikjFG/Pk7L2iOL34JkfuO5/QNc0f9aG
         GdRAHfYcpjL2p2mue1XWzJEQJG0lb9DpYXiJBqhKPdEl2uacQIwbfOe8p6jNa2zVlQud
         aeGZ70FhPG4J1t7VEGwMRWtX13a1ULFpuJt/85mPRd26mT+cqOGOkn9AytV17XsxeVyB
         r8AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=sKF0jK9b9yJIjxLEg5h1WJiNnPHeqBXNuciZYywUK10=;
        b=siuSTtVRJgvC6mSPeWuKcD4cEzBnYiFMfcHi/2E+M6yecHzDHzxk3vPzQz2wlWo7uN
         jeXpIaiGWlTvgqtfe5v0gEia7YUCUeNDgef7f0OPuAjwj6hJJZ1oOPgomuN47NYzz/e+
         Xgb3WHZLzLH7AzmVhsUMynUFI3EXDRi5A62V8Z0rtQKivJgYxJ2023u2lQpzrjgdOW+C
         oh4l7DgonspFdIqBQo5IQG6qd2imEi4hqGtD0wwP43hX7FU86vjs+c2EG7jUJ8AmYXdQ
         yCFnUo9v03hMOp5j5Gbc/3UohS1BtIEmHluiT03WzdUQ0Tt1gF3fl/MPt8+Sl+/iVcvC
         mY0A==
X-Gm-Message-State: APjAAAVYmVAmryvvxskX4wFOhu7uwvcX+pxsrMUuFlhb8pKepCDIv8qa
        VEltmd5xZMn52ywI3PLZ6LqBaRcAWeuN5aZJMlyumA==
X-Google-Smtp-Source: APXvYqzbDLqEhRrKwMjwi0oHzij7hXyqn7I0wriLfhCXPpHVP5/hCrX1wuv90Xo/dCkZQ9aWU8G7lFTn+0aOAks615s=
X-Received: by 2002:a63:e004:: with SMTP id e4mr90402811pgh.344.1555603629211;
 Thu, 18 Apr 2019 09:07:09 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 18 Apr 2019 11:06:57 -0500
Message-ID: <CAH2r5mvEYMEUjz8BDRUumn0yGq__VntNKx-8AzWcZgCDOJQv-Q@mail.gmail.com>
Subject: [PATCH][SMB3] Add missing defines for new negotiate contexts
To:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: multipart/mixed; boundary="000000000000bb27510586d03154"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000bb27510586d03154
Content-Type: text/plain; charset="UTF-8"

See updated MS-SMB2 - two new negotiate contexts



-- 
Thanks,

Steve

--000000000000bb27510586d03154
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-SMB3-Add-defines-for-new-negotiate-contexts.patch"
Content-Disposition: attachment; 
	filename="0001-SMB3-Add-defines-for-new-negotiate-contexts.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jumu7fi50>
X-Attachment-Id: f_jumu7fi50

RnJvbSAxMzdjNzIyMmMwZjRhYmJjOWVhMmIyYWIxMWM5OGM2OWU4NzYxM2RiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFRodSwgMTggQXByIDIwMTkgMTE6MDM6NTggLTA1MDAKU3ViamVjdDogW1BBVENIXSBT
TUIzOiBBZGQgZGVmaW5lcyBmb3IgbmV3IG5lZ290aWF0ZSBjb250ZXh0cwoKU2VlIHRoZSBsYXRl
c3QgTVMtU01CMiBwcm90b2NvbCBzcGVjaWZpY2F0aW9uIHVwZGF0ZXMuClRoZXNlIHdpbGwgYmUg
bmVlZGVkIGZvciBpbXBsZW1lbnRpbmcgY29tcHJlc3Npb24gc3VwcG9ydApvbiB0aGUgd2lyZSBm
b3IgZXhhbXBsZS4KClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9z
b2Z0LmNvbT4KLS0tCiBmcy9jaWZzL3NtYjJwZHUuYyB8ICA1ICstLS0tCiBmcy9jaWZzL3NtYjJw
ZHUuaCB8IDI2ICsrKysrKysrKysrKysrKysrKysrKysrKysrCiAyIGZpbGVzIGNoYW5nZWQsIDI3
IGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9zbWIy
cGR1LmMgYi9mcy9jaWZzL3NtYjJwZHUuYwppbmRleCBhYzkyZDA2NmM3MjQuLjM5OTllYzVhNmJi
OSAxMDA2NDQKLS0tIGEvZnMvY2lmcy9zbWIycGR1LmMKKysrIGIvZnMvY2lmcy9zbWIycGR1LmMK
QEAgLTQ1OSwxMCArNDU5LDcgQEAgc21iMl9wbGFpbl9yZXFfaW5pdChfX2xlMTYgc21iMl9jb21t
YW5kLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLAogCXJldHVybiByYzsKIH0KIAotCi0jZGVmaW5l
IFNNQjJfUFJFQVVUSF9JTlRFR1JJVFlfQ0FQQUJJTElUSUVTCWNwdV90b19sZTE2KDEpCi0jZGVm
aW5lIFNNQjJfRU5DUllQVElPTl9DQVBBQklMSVRJRVMJCWNwdV90b19sZTE2KDIpCi0jZGVmaW5l
IFNNQjJfUE9TSVhfRVhURU5TSU9OU19BVkFJTEFCTEUJCWNwdV90b19sZTE2KDB4MTAwKQorLyog
Rm9yIGV4cGxhbmF0aW9uIG9mIG5lZ290aWF0ZSBjb250ZXh0cyBzZWUgTVMtU01CMiBzZWN0aW9u
IDIuMi4zLjEgKi8KIAogc3RhdGljIHZvaWQKIGJ1aWxkX3ByZWF1dGhfY3R4dChzdHJ1Y3Qgc21i
Ml9wcmVhdXRoX25lZ19jb250ZXh0ICpwbmVnX2N0eHQpCmRpZmYgLS1naXQgYS9mcy9jaWZzL3Nt
YjJwZHUuaCBiL2ZzL2NpZnMvc21iMnBkdS5oCmluZGV4IGJjOTE2MWEyNjQwMC4uZTA3MjVlOThm
MTc1IDEwMDY0NAotLS0gYS9mcy9jaWZzL3NtYjJwZHUuaAorKysgYi9mcy9jaWZzL3NtYjJwZHUu
aApAQCAtMjUxLDYgKzI1MSwxNCBAQCBzdHJ1Y3Qgc21iMl9uZWdvdGlhdGVfcmVxIHsKICNkZWZp
bmUgU01CMl9OVF9GSU5ECQkJMHgwMDEwMDAwMAogI2RlZmluZSBTTUIyX0xBUkdFX0ZJTEVTCQkw
eDAwMjAwMDAwCiAKKworLyogTmVnb3RpYXRlIENvbnRleHRzIC0gQ29udGV4dFR5cGVzLiBTZWUg
TVMtU01CMiBzZWN0aW9uIDIuMi4zLjEgZm9yIGRldGFpbHMgKi8KKyNkZWZpbmUgU01CMl9QUkVB
VVRIX0lOVEVHUklUWV9DQVBBQklMSVRJRVMJY3B1X3RvX2xlMTYoMSkKKyNkZWZpbmUgU01CMl9F
TkNSWVBUSU9OX0NBUEFCSUxJVElFUwkJY3B1X3RvX2xlMTYoMikKKyNkZWZpbmUgU01CMl9DT01Q
UkVTU0lPTl9DQVBBQklMSVRJRVMJCWNwdV90b19sZTE2KDQpCisjZGVmaW5lIFNNQjJfTkVUTkFN
RV9ORUdPVElBVEVfQ09OVEVYVF9JRAljcHVfdG9fbGUxNig1KQorI2RlZmluZSBTTUIyX1BPU0lY
X0VYVEVOU0lPTlNfQVZBSUxBQkxFCQljcHVfdG9fbGUxNigweDEwMCkKKwogc3RydWN0IHNtYjJf
bmVnX2NvbnRleHQgewogCV9fbGUxNglDb250ZXh0VHlwZTsKIAlfX2xlMTYJRGF0YUxlbmd0aDsK
QEAgLTI4OCw2ICsyOTYsMjQgQEAgc3RydWN0IHNtYjJfZW5jcnlwdGlvbl9uZWdfY29udGV4dCB7
CiAJX19sZTE2CUNpcGhlcnNbMV07IC8qIENpcGhlcnNbMF0gc2luY2Ugb25seSBvbmUgdXNlZCBu
b3cgKi8KIH0gX19wYWNrZWQ7CiAKKy8qIFNlZSBNUy1TTUIyIDIuMi4zLjEuMyAqLworI2RlZmlu
ZSBTTUIzX0NPTVBSRVNTX05PTkUJMHgwMDAwCisjZGVmaW5lIFNNQjNfQ09NUFJFU1NfTFpOVDEJ
MHgwMDAxCisjZGVmaW5lIFNNQjNfQ09NUFJFU1NfTFo3NwkweDAwMDIKKyNkZWZpbmUgU01CM19D
T01QUkVTU19MWjc3X0hVRkYJMHgwMDAzCisKK3N0cnVjdCBzbWIyX2NvbXByZXNzaW9uX2NhcGFi
aWxpdGllc19jb250ZXh0IHsKKwlfX2xlMTYJQ29tcHJlc3Npb25BbGdvcml0aG1Db3VudDsKKwlf
X3UxNglQYWRkaW5nOworCV9fdTMyCVJlc2VydmVkOworCV9fdTE2CUNvbXByZXNzaW9uQWxnb3Jp
dGhtc1sxXTsKK30gX19wYWNrZWQ7CisKKy8qCisgKiBGb3Igc21iMl9uZXRuYW1lX25lZ290aWF0
ZV9jb250ZXh0X2lkIFNlZSBNUy1TTUIyIDIuMi4zLjEuNC4KKyAqIEl0cyBzdHJ1Y3Qgc2ltcGx5
IGNvbnRhaW5zIE5ldE5hbWUsIGFuIGFycmF5IG9mIFVuaWNvZGUgY2hhcmFjdGVycworICovCisK
ICNkZWZpbmUgUE9TSVhfQ1RYVF9EQVRBX0xFTgkxNgogc3RydWN0IHNtYjJfcG9zaXhfbmVnX2Nv
bnRleHQgewogCV9fbGUxNglDb250ZXh0VHlwZTsgLyogMHgxMDAgKi8KLS0gCjIuMTcuMQoK
--000000000000bb27510586d03154--
