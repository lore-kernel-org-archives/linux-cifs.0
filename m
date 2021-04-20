Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E669FC433B4
	for <linux-cifs@archiver.kernel.org>; Tue, 20 Apr 2021 16:09:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AAC81613C0
	for <linux-cifs@archiver.kernel.org>; Tue, 20 Apr 2021 16:09:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233015AbhDTQJ4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 20 Apr 2021 12:09:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232174AbhDTQJy (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 20 Apr 2021 12:09:54 -0400
X-Greylist: delayed 235 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 20 Apr 2021 09:09:22 PDT
Received: from mail.tuxed.org (mail.tuxed.org [IPv6:2a01:4f8:c2c:58f::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EF1AC06174A
        for <linux-cifs@vger.kernel.org>; Tue, 20 Apr 2021 09:09:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alexanderkoch.net;
        s=2019; t=1618934721;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=WyDwtD6gGHJgTbiFZJhmZ34e9W8YS0OBOrz1V02vHqc=;
        b=ZD12ESqH3JpZ1kMTWmXB4MQ/8i1bUOLyv2FRcrm8hHDivKPGNAjDkSmA4T5aLqHdFCDMvY
        rJPw9ohQYePq0k2GA8xm38Oheusn4GvTFauNcK/biV0n6RVnlCkZ8kKvgxFEsOR8ScJXI/
        +7sk+YZKM8mvPLU518Epu6mR1Akoe41iXg2r7RpiCqXhpm6fnbxjEnaSIenShwcDEVrn7G
        HOOdC/llZIVfCyj+AmVJtxsEytzTOsor1CGmPeQY3yIyadfd23B5VdhVSDq555VoEDZ8Na
        qnTj+mSzR0RYxZyDN5ieTOxmCKJdgWHK0muHxfTtFQ06gLph5A/uEAGWp0hBig==
To:     linux-cifs@vger.kernel.org
From:   Alexander Koch <mail@alexanderkoch.net>
Subject: cifs.upcall broken with cifs-utils 6.13
Message-ID: <a01d5d22-5990-c00d-bc2a-582d2585ea69@alexanderkoch.net>
Date:   Tue, 20 Apr 2021 18:05:20 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
        d=alexanderkoch.net; s=2019; t=1618934721;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=WyDwtD6gGHJgTbiFZJhmZ34e9W8YS0OBOrz1V02vHqc=;
        b=Ovj0UuaELf8aDsVv8fGHFyMy4T2Y7yNIOK7Ww3oi7z/CH+XgrLlCNUK789WwztIEPzHL3o
        hKUy1MXcJGLxNanD2JtShT3uLvtoK8EW6Qssos8wvGGx4e/jXA8F6yz3XzCqfW6DYH7lgg
        +OEL+fP9tmp/ZKDuZqK2gtohUNWJTjoCLGBp4zPWwbQyaaiyozjKemplxPwPqGRUN04Vuw
        4ZgeTK7mw+mdffssl2pcx/ql8vHxFRrR0OQdyAdgD8/0P3l05hkmBhUTlT9gbaWvlfSxzp
        YXcieCmYj9Krr9OEB9KyGKrTbSKO5pkIi6h52evP7XV6dKbmSQtn2soMvJMAGg==
ARC-Seal: i=1; s=2019; d=alexanderkoch.net; t=1618934721; a=rsa-sha256;
        cv=none;
        b=MYZra4Lekjln2sxYqj8qgNws3WLzzmXtmPndf1XAu7OdNnnhMqRwH1z14aMy95cuBkJQpX
        S9FZ1BebbAGeLyGrj6EfegrQgM0vg7idfGohUTQ6BZKYKZgcg2WXQyztBB+1OUMuYrfPtz
        8wzgo1qrOjlKZaZcoledl+Y2Y9xp6gbtEyofKMr7I9j5rpLSaIhWR9KubHkZ1SD6Wx8yEo
        A7Nct6X1St4QFPized4VLFbNiHG7TRgNE400yYAE66Q2H36MjS/GJWVlgRL+aRsfCvWDzz
        mzjjNbYJBW1zTNqwuAt1XRIZgg7bDihgDhSmviajs3HMMpn87ZjkoGvnorfYNw==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=mail@alexanderkoch.net smtp.mailfrom=mail@alexanderkoch.net
Authentication-Results: ORIGINATING;
        auth=pass smtp.auth=mail@alexanderkoch.net smtp.mailfrom=mail@alexanderkoch.net
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The recent release of cifs-utils 6.13, more precisely e461afd8cf (which, =

to my understanding, is a fix for CVE-2021-20208) makes attempts of=20
mounting CIFS shares with krb5 fail for me:

 =C2=A0=C2=A0=C2=A0 cifs.upcall[78171]: switch_to_process_ns: setns() fai=
led for cgroup
 =C2=A0=C2=A0=C2=A0 cifs.upcall[78171]: unable to switch to process names=
pace:=20
Operation not permitted


Can anyone tell me if this is a packaging/configuration issue (Arch in=20
my case) or a bug?

Full mount log can be found in [1], along with a confirmation of the=20
observed behaviour from another user.

Thanks!


Best regards,

Alex


[1]=20
https://www.reddit.com/r/archlinux/comments/mukvv6/cifs_mount_broken_agai=
n_with_cifsutils6131/


