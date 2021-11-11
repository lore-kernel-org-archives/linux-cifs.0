Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46714C433EF
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Nov 2021 22:28:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21DB861211
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Nov 2021 22:28:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbhKKWbi (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 11 Nov 2021 17:31:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbhKKWbi (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 11 Nov 2021 17:31:38 -0500
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBA86C061766
        for <linux-cifs@vger.kernel.org>; Thu, 11 Nov 2021 14:28:48 -0800 (PST)
Received: by mail-lj1-x22f.google.com with SMTP id e7so213919ljq.12
        for <linux-cifs@vger.kernel.org>; Thu, 11 Nov 2021 14:28:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=Yirq4K8XolEC05Cs1kNK4TfUIcMOnp+1RnMez4kFB7E=;
        b=llT5s+M8py7MssrqS9YSSUVt5shiD5Ryoc1FRyKfBE9Rxu0qaZ2Of7QSIwehOkxjBk
         r2qxgnHvoDq+nEy6ZpUeF40ehHojrSBO/qgpMn2Fjtx9u/NXzUxRVb1dgshhk5h4WqnS
         wV6Ndh7O9Cs9VNeNmNDGm41JWY8HltR+iF5x0/1CAXjg0UsXEh4HmJ6EeSEoPHhkizoW
         T361zb5HbrsxbnAIoLilfFzlITZNe0Zh8xKRCketUC9H/RIb66nveIY6s6Z/0qY/BFIR
         L9ebOveUHdABwdiKKsDMzkax5/+sK0VBc2DOb1BAVjffr0VUff5DL0fhgSux6tTEWMIu
         vOvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=Yirq4K8XolEC05Cs1kNK4TfUIcMOnp+1RnMez4kFB7E=;
        b=6Nbj8Oe/vPr+sjMFTRF+XYxMmBgchWEzHXuDA2NOUjMtWlJqtG/c0l4f8v6X9gSl+I
         bYlvMtglS9GDMvYUpLoMwQeM2x7yJI2IS9eWwTIdG6Yc3X0lzQQ7hf0tY460/VO6qNIe
         1jBZuyNIu8qMvSth8W33scg0tWsfqDGJ3JTo/oqg5Jlx3OEXf5SJImvEXQpIJgkDpery
         PVSR5eP79u2hFkA9WOMzbQOJbTo6I/tB3/QpBo9vi2G8iKErz1jK3mmFBAheEe+o6UE2
         W300zXpksLTaIz6L6A78p29GHusfDpwC/fhpdGDAs/6j4jfy6PVFKkwwggkIf1tGSoMW
         0ALw==
X-Gm-Message-State: AOAM53321e77V+6YbSlBYKKXPTCqfhqnbCe7OMiFgQRR5dKUjm3CztfV
        Wbns3J9yuLgWjWlrbABgp5ExtzxT4uvsZygbf7/VtlMW
X-Google-Smtp-Source: ABdhPJyCNKMDU7p2KKbHdPO9RDCpo4Bow0tAOv9Cl64pkdUDdEttURqIe5qHmdGPOjfvJLzshA7J6mMQksNvGCdzcKg=
X-Received: by 2002:a2e:9107:: with SMTP id m7mr10267806ljg.209.1636669727064;
 Thu, 11 Nov 2021 14:28:47 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5mvM2hEP6TTOWipZayRapLwZ-=BzrLBJDK_0J4ZHiRc6og@mail.gmail.com>
In-Reply-To: <CAH2r5mvM2hEP6TTOWipZayRapLwZ-=BzrLBJDK_0J4ZHiRc6og@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 11 Nov 2021 16:28:36 -0600
Message-ID: <CAH2r5msHng+COdwwJ0QUb2drTq-=5NMQFOK4W97Fd0=kvdoTuw@mail.gmail.com>
Subject: Re: [PATCH] wait until we have the FS info from the server befor
 initializing fscache cookie
To:     David Howells <dhowells@redhat.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000b258e605d08addde"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000b258e605d08addde
Content-Type: text/plain; charset="UTF-8"

Updated patch to check whether would be initializing the super cookie twice

cifs

On Wed, Nov 10, 2021 at 3:20 AM Steve French <smfrench@gmail.com> wrote:
>
> With this patch now that the fscache cookie is initialized properly -
> I do see an oops on the 2nd unmount if we mount the same share twice
> ... any ideas on fixing that?
>
>
>     smb3: do not call setup the fscache_super_cookie until fsinfo initialized
>
>     We were calling cifs_fscache_get_super_cookie after tcon but before
>     we queried the info (QFS_Info) we need to initialize the cookie
>     properly.
>
>     Suggested-by: David Howells <dhowells@redhat.com>
>     Signed-off-by: Steve French <stfrench@microsoft.com>
>
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve

--000000000000b258e605d08addde
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-do-not-setup-the-fscache_super_cookie-until-fsi.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-do-not-setup-the-fscache_super_cookie-until-fsi.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kvvivqgp0>
X-Attachment-Id: f_kvvivqgp0

RnJvbSA1NjI3MTNmZTliNDk3MGZiYzgzZmZkYmMxYTI5NWU1ZjBjN2Y5ZjEwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFdlZCwgMTAgTm92IDIwMjEgMDM6MTU6MjkgLTA2MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBkbyBub3Qgc2V0dXAgdGhlIGZzY2FjaGVfc3VwZXJfY29va2llIHVudGlsIGZzaW5mbwog
aW5pdGlhbGl6ZWQKCldlIHdlcmUgY2FsbGluZyBjaWZzX2ZzY2FjaGVfZ2V0X3N1cGVyX2Nvb2tp
ZSBhZnRlciB0Y29uIGJ1dCBiZWZvcmUKd2UgcXVlcmllZCB0aGUgaW5mbyAoUUZTX0luZm8pIHdl
IG5lZWQgdG8gaW5pdGlhbGl6ZSB0aGUgY29va2llCnByb3Blcmx5LiAgQWxzbyBpbmNsdWRlcyBh
biBhZGRpdGlvbmFsIGNoZWNrIHN1Z2dlc3RlZCBieSBQYXVsbwp0byBtYWtlIHN1cmUgd2UgZG9u
J3QgaW5pdGlhbGl6ZSBzdXBlciBjb29raWUgdHdpY2UuCgpTdWdnZXN0ZWQtYnk6IERhdmlkIEhv
d2VsbHMgPGRob3dlbGxzQHJlZGhhdC5jb20+ClJldmlld2VkLWJ5OiBQYXVsbyBBbGNhbnRhcmEg
KFNVU0UpIDxwY0BjanIubno+ClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hA
bWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9jaWZzL2Nvbm5lY3QuYyB8IDkgKysrKysrKy0tCiAxIGZp
bGUgY2hhbmdlZCwgNyBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBh
L2ZzL2NpZnMvY29ubmVjdC5jIGIvZnMvY2lmcy9jb25uZWN0LmMKaW5kZXggZGYzMzY1OTU4NjAz
Li40MmU0ZDdiNDhlOTcgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvY29ubmVjdC5jCisrKyBiL2ZzL2Np
ZnMvY29ubmVjdC5jCkBAIC0yMzQ5LDggKzIzNDksNiBAQCBjaWZzX2dldF90Y29uKHN0cnVjdCBj
aWZzX3NlcyAqc2VzLCBzdHJ1Y3Qgc21iM19mc19jb250ZXh0ICpjdHgpCiAJbGlzdF9hZGQoJnRj
b24tPnRjb25fbGlzdCwgJnNlcy0+dGNvbl9saXN0KTsKIAlzcGluX3VubG9jaygmY2lmc190Y3Bf
c2VzX2xvY2spOwogCi0JY2lmc19mc2NhY2hlX2dldF9zdXBlcl9jb29raWUodGNvbik7Ci0KIAly
ZXR1cm4gdGNvbjsKIAogb3V0X2ZhaWw6CkBAIC0zMDAyLDYgKzMwMDAsMTMgQEAgc3RhdGljIGlu
dCBtb3VudF9nZXRfY29ubnMoc3RydWN0IG1vdW50X2N0eCAqbW50X2N0eCkKIAkJCQljaWZzX2Ri
ZyhWRlMsICJyZWFkIG9ubHkgbW91bnQgb2YgUlcgc2hhcmVcbiIpOwogCQkJLyogbm8gbmVlZCB0
byBsb2cgYSBSVyBtb3VudCBvZiBhIHR5cGljYWwgUlcgc2hhcmUgKi8KIAkJfQorCQkvKgorCQkg
KiBUaGUgY29va2llIGlzIGluaXRpYWxpemVkIGZyb20gdm9sdW1lIGluZm8gcmV0dXJuZWQgYWJv
dmUuCisJCSAqIEFuZCB3ZSBtaWdodCBiZSByZXVzaW5nIGEgdGNvbiwgc28gbmVlZCB0byBlbnN1
cmUKKwkJICogdGhhdCB3ZSBkbyBub3QgZ2V0IHN1cGVyIGNvb2tpZSB0d2ljZS4KKwkJICovCisJ
CWlmICghdGNvbi0+ZnNjYWNoZSkKKwkJCWNpZnNfZnNjYWNoZV9nZXRfc3VwZXJfY29va2llKHRj
b24pOwogCX0KIAogCS8qCi0tIAoyLjMyLjAKCg==
--000000000000b258e605d08addde--
