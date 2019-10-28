Return-Path: <SRS0=uI0J=YV=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0E2FCA9EC0
	for <linux-cifs@archiver.kernel.org>; Mon, 28 Oct 2019 15:44:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF05421721
	for <linux-cifs@archiver.kernel.org>; Mon, 28 Oct 2019 15:44:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bpUwQifv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729836AbfJ1Po7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 28 Oct 2019 11:44:59 -0400
Received: from mail-il1-f171.google.com ([209.85.166.171]:39542 "EHLO
        mail-il1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728601AbfJ1Po7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 28 Oct 2019 11:44:59 -0400
Received: by mail-il1-f171.google.com with SMTP id i12so8583848ils.6
        for <linux-cifs@vger.kernel.org>; Mon, 28 Oct 2019 08:44:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=M60CXvffZqLcG4nYdAJjI4fwF4m2/pv8YEoOG+Ye5/M=;
        b=bpUwQifvYstxgHr/20FU82mfs8Y1bS8RNYcIRY2yW1gZEp6XpfubBX1z/uNOZYsRos
         G80FK5Xmb0o79H0YV30pKS1/u738CjBTUYb9+ov2wimGB6MiROZGd5aJkxyz2VqTZwm+
         9NKPtHXBddM4oUJELAzSN1mzjnqopRK4Bl4GRxTUImuHtP5fLuitjoJ2ADMSCIMyEU4b
         kSgENKhB/cGkZrjIgNZB0OLTYubjehdo4ZCnm0liz2j723+lN80lJ3EiKRpYGKyBARNY
         uIkxsxT9jXRO1VN/kO2IQjDzJbD2oorQD14+z8ngz+0G3/ayBU0jLiYwwUVoGYbbCMyo
         tLag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=M60CXvffZqLcG4nYdAJjI4fwF4m2/pv8YEoOG+Ye5/M=;
        b=VEF9Zlo0V7EvoiU9aChnK7eZFMLUdjiKm6sFCfFRX5cVWRhBgLmAEb0anjpyT9dsS1
         mn+Bs7hzfHaRK11vMkV3nM9d/AzEmv6oCrVUzAM06Hk57d3TB2wCAzK0VKWQQHfZ11j0
         x+xliRDa49AfaPpQntRb80EfGn4jHeE/cvoOKOgKC4RqUAd1MaCfN/QAX17tl7plcYZY
         fo/efjyur1sVzjEIWaT7FK++fM+sSLxCN2iaulB4mNMAAIisNqsTj+rl/OirgiM/5mUB
         THGrDRhVP7SEYXPnoAdq6AsGzRlbk6FQbPbdAHXa2gBvIFLadSyYcH68yfasrbHWc0HN
         YULw==
X-Gm-Message-State: APjAAAVHaOwuxm3W0qjeNhJszFKmKxfOYTVy+h9ouZAjXVFfhuOFTe3h
        ylNvgjPVKGDxCIia1ovWs2BK+rAPrctq/7TCFL8DU3bX7Po=
X-Google-Smtp-Source: APXvYqxXGM4QrETgmb6DUjT1LfwhxWhVekd1tsAJm5DEFwprHulfVoHDBb3fIe8z3BCdQwYmscbbG/yizHuk/vQ2zhQ=
X-Received: by 2002:a92:48d8:: with SMTP id j85mr20442767ilg.272.1572277496301;
 Mon, 28 Oct 2019 08:44:56 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 28 Oct 2019 10:44:45 -0500
Message-ID: <CAH2r5mv-1YBTnYNp6Sx2nU4Sf5F92YKe6M+W4xP-UE1mUYQXBg@mail.gmail.com>
Subject: Updated for-next with patches for 5.5-rc
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     Long Li <longli@microsoft.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Dave Wysochanski <dwysocha@redhat.com>,
        Pavel Shilovsky <piastryyy@gmail.com>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Passes the buildbot with the current 13 patches in for-next post
5.4-rc5 (probably all but the first will target for 5.5-rc)

Buildbot results
http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/273

(it also passes Azure and Windows test groups as well).  Here is the
current list of patches in for-next.  Doesn't include the Ronnie/David
W. patch since still open question on that one, and doesn't include
Aurelien's multichannel ones yet  (although I would really like to get
those in 5.5) since there is an encryption crash to work through when
multichannel enabled.

eac95a44f454 (HEAD -> for-next, origin/for-next) cifs: update internal
module version number
a1356cad7e64 cifs: smbd: Return -EAGAIN when transport is reconnecting
5fb584dcf073 cifs: smbd: Only queue work for error recovery on memory
registration
a4ed3149a5dc cifs: smbd: Return -ECONNABORTED when trasnport is not in
connected state
3465bca3963c cifs: smbd: Add messages on RDMA session destroy and reconnection
0e1e0c31b7f9 cifs: smbd: Return -EINVAL when the number of iovs
exceeds SMBDIRECT_MAX_SGE
727b00af4253 cifs: smbd: Invalidate and deregister memory registration
on re-send for direct I/O
c7d1d76af023 cifs: Don't display RDMA transport on reconnect
1a9e24ea2b9a CIFS: remove set but not used variables 'cinode' and 'netfid'
8a974989ef5e cifs: add support for flock
0455298f0efb cifs: remove unused variable 'sid_user'
f556e4949186 cifs: rename a variable in SendReceive()
a08d897bc04f fix memory leak in large read decrypt offload

Let me know if any patches missing (it is easy to overlook on the
mailing lists).

-- 
Thanks,

Steve
