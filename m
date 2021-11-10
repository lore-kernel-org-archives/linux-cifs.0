Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D0D5C433F5
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Nov 2021 16:48:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01D5F610D2
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Nov 2021 16:47:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231844AbhKJQuq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 10 Nov 2021 11:50:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231838AbhKJQuq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 10 Nov 2021 11:50:46 -0500
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A502C061764
        for <linux-cifs@vger.kernel.org>; Wed, 10 Nov 2021 08:47:58 -0800 (PST)
Received: by mail-lj1-x230.google.com with SMTP id i26so6470684ljg.7
        for <linux-cifs@vger.kernel.org>; Wed, 10 Nov 2021 08:47:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q/6g5Ie1CW30vq/WtilaD3Ksx2RKk6YuXCeV8RmdSbo=;
        b=R8h67u0bxonSZlRjqOaeijZ6gynCooH4POYP8YrS0kDfUoAncZGWFoX9g7HaC6HD6t
         rhr6GU4jnCDjqZhfX9udY0BT+rV3fZvHRJVVFpLOPZsSy6vwUD5QV5LX6lqjlTxv3xVU
         UlhNIXu53qjM51ESPAs/AoGJF6v1Cn+sYu+54dJAlVr5UCgVgourm6Ogu08Jwe7F7Kdv
         aZpUUMiLhoraaTddPs8CGiWXCPPJ07f5KoE6frxnsKHSCNS+5W6rPfdpBMjj9lGScUQF
         ILvPAj4rOJlzIC9lICX9sbYOjS2yf3aWJNZBvFkUdjN4Y7YCqNe4aqww8dqjU4k7pgos
         sIlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q/6g5Ie1CW30vq/WtilaD3Ksx2RKk6YuXCeV8RmdSbo=;
        b=BBaO1OuVacCZFVkveczFThSQy5XrLQKJaSolQHJrbIqs0RoWlCdONFvAEcMts3JCkl
         GTWvj4brg3qqMo3yQ7rMH+OpXyQUxo6gJwbAPKmc5Q51lCHpFf3PoOJOQ64VE4VR1OoX
         +KHvlCRnov6+Qn4H0djJz62Nr4CtFm/JhYdm49z3i2IOIj/RvKQHignXz05ROdi6t7Ye
         F8Ks6YOBNyedoE53nYehLuPx5aGaUcbdkmPK8HXNXLAQlIYnIyfrdBVVmOe9eq5ohKXI
         WQsUd7MDCUS97kNfrG/Fy6QboD5LEgIg6TEps41gP0To2rr2FehZf/HAX84ExZhxWOwR
         9NyQ==
X-Gm-Message-State: AOAM530OqEle10VFOJhZI8IA09Y0U/c30aujTr98VifVl/0yakWDKiJ8
        epb9muMr6Gyw8wl3pC+W1sFD62EalG92T++m2Mg=
X-Google-Smtp-Source: ABdhPJzN1Bkybret06q/RsjiW8SaMDHMyELsZoGpxx7VpcZQEbUB8yiHmG5aYMcxnN/xlAvZMY8ps5OcH4IGnnh5ihk=
X-Received: by 2002:a2e:85c1:: with SMTP id h1mr364703ljj.398.1636562876621;
 Wed, 10 Nov 2021 08:47:56 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5mtVZg1jCCjGfeBgvcN-2iaSBODySkA-B51hx+hfYAatrg@mail.gmail.com>
 <704399.1636541832@warthog.procyon.org.uk>
In-Reply-To: <704399.1636541832@warthog.procyon.org.uk>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 10 Nov 2021 10:47:45 -0600
Message-ID: <CAH2r5mtKqdcv8CYfBFHB49+VDK3XtOBc7tZEdqbWERMFQd9VJw@mail.gmail.com>
Subject: Re: oops in fscache
To:     David Howells <dhowells@redhat.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000ea263605d071fc70"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000ea263605d071fc70
Content-Type: text/plain; charset="UTF-8"

This is with upstream fscache (5.16-rc) + the fix you suggested.

Without the patch those three fields of the super cookie were getting
set to zero.

Scenario is easy:
1) mount
2) mount same share again to different target
3) umount first mount
4) umount second mount (oops)

On Wed, Nov 10, 2021 at 4:57 AM David Howells <dhowells@redhat.com> wrote:
>
> Steve French <smfrench@gmail.com> wrote:
>
> > I noticed that if I mount the same share twice (to different target
> > directories) I get the warning below.  Is that expected?
>
> This is with the upstream fscache, I presume?
>
> David
>


-- 
Thanks,

Steve

--000000000000ea263605d071fc70
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-do-not-setup-the-fscache_super_cookie-until-fsi.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-do-not-setup-the-fscache_super_cookie-until-fsi.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kvtr8mma0>
X-Attachment-Id: f_kvtr8mma0

RnJvbSBmMGY1YmVjM2EzNGY4NWYwZWNhZDk2NTkzN2RmNTRkNDg0YWE0YjQxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFdlZCwgMTAgTm92IDIwMjEgMDM6MTU6MjkgLTA2MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBkbyBub3Qgc2V0dXAgdGhlIGZzY2FjaGVfc3VwZXJfY29va2llIHVudGlsIGZzaW5mbwog
aW5pdGlhbGl6ZWQKCldlIHdlcmUgY2FsbGluZyBjaWZzX2ZzY2FjaGVfZ2V0X3N1cGVyX2Nvb2tp
ZSBhZnRlciB0Y29uIGJ1dCBiZWZvcmUKd2UgcXVlcmllZCB0aGUgaW5mbyAoUUZTX0luZm8pIHdl
IG5lZWQgdG8gaW5pdGlhbGl6ZSB0aGUgY29va2llCnByb3Blcmx5LgoKU3VnZ2VzdGVkLWJ5OiBE
YXZpZCBIb3dlbGxzIDxkaG93ZWxsc0ByZWRoYXQuY29tPgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBG
cmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvY2lmcy9jb25uZWN0LmMgfCA0
ICsrLS0KIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCgpk
aWZmIC0tZ2l0IGEvZnMvY2lmcy9jb25uZWN0LmMgYi9mcy9jaWZzL2Nvbm5lY3QuYwppbmRleCBm
NjQ1Zjk5NGE1MjMuLjE4NmM5NTNjNDdlYyAxMDA2NDQKLS0tIGEvZnMvY2lmcy9jb25uZWN0LmMK
KysrIGIvZnMvY2lmcy9jb25uZWN0LmMKQEAgLTIzNDksOCArMjM0OSw2IEBAIGNpZnNfZ2V0X3Rj
b24oc3RydWN0IGNpZnNfc2VzICpzZXMsIHN0cnVjdCBzbWIzX2ZzX2NvbnRleHQgKmN0eCkKIAls
aXN0X2FkZCgmdGNvbi0+dGNvbl9saXN0LCAmc2VzLT50Y29uX2xpc3QpOwogCXNwaW5fdW5sb2Nr
KCZjaWZzX3RjcF9zZXNfbG9jayk7CiAKLQljaWZzX2ZzY2FjaGVfZ2V0X3N1cGVyX2Nvb2tpZSh0
Y29uKTsKLQogCXJldHVybiB0Y29uOwogCiBvdXRfZmFpbDoKQEAgLTMwMDIsNiArMzAwMCw4IEBA
IHN0YXRpYyBpbnQgbW91bnRfZ2V0X2Nvbm5zKHN0cnVjdCBtb3VudF9jdHggKm1udF9jdHgpCiAJ
CQkJY2lmc19kYmcoVkZTLCAicmVhZCBvbmx5IG1vdW50IG9mIFJXIHNoYXJlXG4iKTsKIAkJCS8q
IG5vIG5lZWQgdG8gbG9nIGEgUlcgbW91bnQgb2YgYSB0eXBpY2FsIFJXIHNoYXJlICovCiAJCX0K
KwkJLyogVGhlIGNvb2tpZSBpcyBpbml0aWFsaXplZCBmcm9tIHZvbHVtZSBpbmZvIHJldHVybmVk
IGFib3ZlICovCisJCWNpZnNfZnNjYWNoZV9nZXRfc3VwZXJfY29va2llKHRjb24pOwogCX0KIAog
CS8qCi0tIAoyLjMyLjAKCg==
--000000000000ea263605d071fc70--
