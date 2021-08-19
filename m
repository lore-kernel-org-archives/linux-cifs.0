Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90A69C4338F
	for <linux-cifs@archiver.kernel.org>; Thu, 19 Aug 2021 02:19:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B099610E9
	for <linux-cifs@archiver.kernel.org>; Thu, 19 Aug 2021 02:19:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235563AbhHSCTo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 18 Aug 2021 22:19:44 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:41003 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235558AbhHSCTn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 18 Aug 2021 22:19:43 -0400
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210819021906epoutp029f5d24e5e23130ddb1047eb2eee4e0e9~ck69SAbO42456224562epoutp020
        for <linux-cifs@vger.kernel.org>; Thu, 19 Aug 2021 02:19:06 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210819021906epoutp029f5d24e5e23130ddb1047eb2eee4e0e9~ck69SAbO42456224562epoutp020
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1629339546;
        bh=mpGtyNk2am680edo9vvzBNxuAQpxa6yFCsqfRoIa7Do=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=nJR6t+3s08y3bAsfoAkuBCdt7UxA2RCyVQJoFbAIrJ1aAiril/PnFvGIuAOI4refH
         EwtLNUePSbSaqvWAUgDFDGIxfYAnzxMF14V+fDfl16pkyzKx/7QDdUhXRYONkLbAQx
         nsdB13DMfF5Hb5Z9syDetXAh13ALiojPyVSjpufg=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas1p4.samsung.com (KnoxPortal) with ESMTP id
        20210819021906epcas1p4505fb0bbed352031b8522289b18f32d8~ck689fRKk2852028520epcas1p4O;
        Thu, 19 Aug 2021 02:19:06 +0000 (GMT)
Received: from epsmges1p4.samsung.com (unknown [182.195.40.163]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4GqpNn0bYlz4x9QC; Thu, 19 Aug
        2021 02:19:05 +0000 (GMT)
Received: from epcas1p2.samsung.com ( [182.195.41.46]) by
        epsmges1p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        73.1B.10119.89FBD116; Thu, 19 Aug 2021 11:19:04 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20210819021904epcas1p1e06653dfa1fe6644219469d3109d5611~ck67oeZcM1166011660epcas1p16;
        Thu, 19 Aug 2021 02:19:04 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210819021904epsmtrp1abe607be857db19652c114fab7fde691~ck67niKue2144721447epsmtrp1w;
        Thu, 19 Aug 2021 02:19:04 +0000 (GMT)
X-AuditID: b6c32a38-965ff70000002787-43-611dbf98a48d
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        47.83.08394.89FBD116; Thu, 19 Aug 2021 11:19:04 +0900 (KST)
Received: from namjaejeon01 (unknown [10.89.31.77]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210819021904epsmtip1fed2e53a54232f74b46c55bce2265d8b~ck67ckF1R1232612326epsmtip1Q;
        Thu, 19 Aug 2021 02:19:04 +0000 (GMT)
From:   "Namjae Jeon" <namjae.jeon@samsung.com>
To:     "'Christian Brauner'" <christian.brauner@ubuntu.com>
Cc:     "'Christian Brauner'" <brauner@kernel.org>,
        "'Sergey Senozhatsky'" <senozhatsky@chromium.org>,
        "'David Sterba'" <dsterba@suse.com>,
        "'Steve French'" <stfrench@microsoft.com>,
        "'Christoph Hellwig'" <hch@infradead.org>,
        "'Hyunchul Lee'" <hyc.lee@gmail.com>, <linux-cifs@vger.kernel.org>
In-Reply-To: <20210818174539.ro2ryrbku3ozdjvi@wittgenstein>
Subject: RE: [PATCH] ksmbd: fix lookup on idmapped mounts
Date:   Thu, 19 Aug 2021 11:19:04 +0900
Message-ID: <000001d794a0$94ec20a0$bec461e0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQFlJa7+H2Vr1qkTH9rCACD+U5nFJwIkQDPJAeGdLfQBUd7j0aw0IkZg
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBJsWRmVeSWpSXmKPExsWy7bCmnu6M/bKJBnfX21i8PvyJ0WLrt0SL
        Cz8amSxOT1jEZHHt/nt2ixf/dzFb7N64iM3i1sT5bA4cHrMbLrJ47Jx1l91j8wotj02rOtk8
        Wnf8ZfdYv+Uqi8eDSW8YPT5vkgvgiMqxyUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0
        MFdSyEvMTbVVcvEJ0HXLzAE6TEmhLDGnFCgUkFhcrKRvZ1OUX1qSqpCRX1xiq5RakJJTYGhQ
        oFecmFtcmpeul5yfa2VoYGBkClSZkJNxeXYbU0GjccWbKb3MDYzT1bsYOTkkBEwk5rQ0MHYx
        cnEICexglNjcNpcNwvkE5HycwQzhfGOU+PR4BztMy6t/7SwQib2MEpuOvWIGSQgJvGCU+DKr
        GMRmE9CV+PdnP9AoDg4RAQuJR2eqQMLMAiuYJP58YAGxOQWsJb60nQObKSxgKXHw1HImEJtF
        QFVi68GlYDYvUPz23ltQtqDEyZlPWCDmyEtsfzuHGeIeBYmfT5exgtgiAm4Sfb8g6pkFRCRm
        d7aBPSAhsIVD4s2GLUwQDS4St5fPY4GwhSVeHd8C9ZiUxMv+Nii7XOLEyV9Q9TUSG+btYwf5
        RULAWKLnRQmIySygKbF+lz5EhaLEzt9zGSHW8km8+9rDClHNK9HRJgRRoirRd+kw1EBpia72
        D+wTGJVmIXlsFpLHZiF5YBbCsgWMLKsYxVILinPTU4sNC0yQo3oTIzjJalnsYJz79oPeIUYm
        DsZDjBIczEoivOocUolCvCmJlVWpRfnxRaU5qcWHGE2BQT2RWUo0OR+Y5vNK4g1NjYyNjS1M
        zMzNTI2VxHkZX8kkCgmkJ5akZqemFqQWwfQxcXBKNTAxnjr16vuWsuq4M9pX2oybsu5U8nYk
        FPGsWxYarBRzolCMfZndPq/EWaJBB/MfBtXn7F3642irsEaJm/Oz42YJq/Peh8xrf6zPXx77
        4xO/8Nq2+7v2Hpr2wJrjom/DHIZ3XJ06nf8i1zrKTfIW4NDn/Cf/+eu/JRuC2wOTX6TsvFdv
        4/75M99JeSPHQo1oU/Nb79Yds9ol/avFZM23N8vkOZzXbUs5eyXly/vPMquiMu/KmJj87haK
        jX4t8Gcdc9OsaOOznRc3t95dYrQx+/8DxYdck673J7PUfpj40P/0ucpb5itO77yrdipQ3TB+
        m2i0yRulhQ2HGlo51+xUF+LUu/uj8tNEJtYE05Xs/PeVWIozEg21mIuKEwEFvoXjOwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKIsWRmVeSWpSXmKPExsWy7bCSnO6M/bKJBvOuKlq8PvyJ0WLrt0SL
        Cz8amSxOT1jEZHHt/nt2ixf/dzFb7N64iM3i1sT5bA4cHrMbLrJ47Jx1l91j8wotj02rOtk8
        Wnf8ZfdYv+Uqi8eDSW8YPT5vkgvgiOKySUnNySxLLdK3S+DKuDy7jamg0bjizZRe5gbG6epd
        jJwcEgImEq/+tbN0MXJxCAnsZpTYu2cjK0RCWuLYiTPMXYwcQLawxOHDxRA1zxglZi4/zwRS
        wyagK/Hvz342kBoRAQuJR2eqQGqYBdYwSVyZu5MZouE5o8SzLQ8YQRo4BawlvrSdYwexhQUs
        JQ6eWg42iEVAVWLrwaVgNi9Q/PbeW1C2oMTJmU9YQGxmAW2JpzefQtnyEtvfzmGGOFRB4ufT
        ZWBHiwi4SfT9guhlFhCRmN3ZxjyBUXgWklGzkIyahWTULCQtCxhZVjFKphYU56bnFhsWGOal
        lusVJ+YWl+al6yXn525iBMecluYOxu2rPugdYmTiYDzEKMHBrCTCq84hlSjEm5JYWZValB9f
        VJqTWnyIUZqDRUmc90LXyXghgfTEktTs1NSC1CKYLBMHp1QDU+zXHedbDV+vjL+rvX7Wyubo
        7Tz28stFFiz7Gh69b+KLCZEtPU5V+g/flXkKyv+X2esiPfknszLH8Z28Mu7+ix8l/rc6fbBL
        jEXwx63gapdjGXVxAi0Wwkut0p43RVx4nan3+uNHDl6X+sasaYFKkb7fdff9V8872ZbIbPFV
        e+vv8MK5xx1SZd9KFOnsF7xTs+zL84a9R1eKnNPnyGA4PevT572ZXzbNPDTt/bbZ1wRmfKkq
        MJibwaHxhsu2t9hltt7nSfyejkUt+rsYCreEfj6x49nxpXd3fti0mj3wW9UMxT/cnSydS+dF
        JhZfdtrH+tQo6X6CTfXjlyV5Vw+8XWHjMc3W4+kTx5bcF2L78pRYijMSDbWYi4oTARRxVjIo
        AwAA
X-CMS-MailID: 20210819021904epcas1p1e06653dfa1fe6644219469d3109d5611
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210816115835epcas1p410fb2a768b1af42d2458027de74dcd3c
References: <CGME20210816115835epcas1p410fb2a768b1af42d2458027de74dcd3c@epcas1p4.samsung.com>
        <20210816115605.178441-1-brauner@kernel.org>
        <008d01d792f6$c2735f30$475a1d90$@samsung.com>
        <20210818174539.ro2ryrbku3ozdjvi@wittgenstein>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

> On Tue, Aug 17, 2021 at 08:30:55AM +0900, Namjae Jeon wrote:
> > > From: Christian Brauner <christian.brauner@ubuntu.com>
> > >
> > > It's great that the new in-kernel ksmbd server will support idmapped
> > > mounts out of the box! However, lookup is currently broken. Lookup
> > > helpers such as lookup_one_len() call inode_permission() internally
> > > to ensure that the caller is privileged over the inode of the base dentry they are trying to
> lookup under. So the permission checking here is currently wrong.
> > >
> > > Linux v5.15 will gain a new lookup helper lookup_one() that does
> > > take idmappings into account. I've added it as part of my patch
> > > series to make btrfs support idmapped mounts. The new helper is in
> > > linux- next as part of David's (Sterba) btrfs for-next branch as commit c972214c133b ("namei: add
> mapping aware lookup helper").
> > >
> > > I've said it before during one of my first reviews: I would very much recommend adding fstests to
> [1].
> > > It already seems to have very rudimentary cifs support. There is a
> > > completely generic idmapped mount testsuite that supports idmapped mounts.
> > >
> > > [1]: https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/
> > > Cc: Steve French <stfrench@microsoft.com>
> > > Cc: Christoph Hellwig <hch@infradead.org>
> > > Cc: Namjae Jeon <namjae.jeon@samsung.com>
> > > Cc: Hyunchul Lee <hyc.lee@gmail.com>
> > > Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
> > > Cc: David Sterba <dsterba@suse.com>
> > > Cc: linux-cifs@vger.kernel.org
> > > Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
> > > ---
> > Hi Christian,
> >
> > > I merged David's for-next tree into cifsd-next to test this. I did
> > > only compile test this. If someone gives me a clear set of
> > > instructions how to test ksmbd on my local machine I can at least
> > > try to cut some time out of my week to do more reviews. (I'd
> > > especially like to see acl behavior with ksmbd.)
> >
> > There is "How to run ksmbd" section in patch cover letter.
> >
> > https://protect2.fireeye.com/v1/url?k=65ecaaf0-3a779239-65ed21bf-0cc47
> > a336fae-53bc47005a1a97a9&q=1&e=e44c9f9f-d7ae-4768-8cc2-8f02d748fc6e&u=
> > https%3A%2F%2Flkml.org%2Flkml%2F2021%2F8%2F5%2F54
> >
> > Let me know if it doesn't work well even if you try to run it with this step.
> > And We will also check whether your patch work fine.
> >
> > >
> > > One more thing, the tree for ksmbd was very hard to find. I had to do a lot archeology to end up
> at:
> > >
> > > git://git.samba.org/ksmbd.git
> > This is also in the patch cover letter. See "Mailing list and repositories" section.
> > I think that you can use :
> >
> > https://protect2.fireeye.com/v1/url?k=8af83a5d-d5630294-8af9b112-0cc47
> > a336fae-e471ffbdb93d05b7&q=1&e=e44c9f9f-d7ae-4768-8cc2-8f02d748fc6e&u=
> > https%3A%2F%2Fgithub.com%2Fnamjaejeon%2Fsmb3-kernel%2Ftree%2Fksmbd-v7-
> > series
> >
> > >
> > > Would be appreciated if this tree could be reflected in MAINTAINERS
> > > or somewhere else. The github repos with the broken out patches/module aren't really that helpful.
> > Okay, I will add git address of ksmbd in MAINTAINERS on next spin.
> >
> > >
> > > Thanks!
> > > Christian
> > Really thanks for your review and I will apply this patch after checking it.
> 
> Thank your for the pointers.
> 
> Ok, so I've been taking the time to look into cifs and ksmbd today. My mental model was wrong. There
> are two things to consider here:
> 
> 1. server: idmapped mounts with ksmbd
> 2. client: idmapped mounts with cifs
> 
> Your patchset adds support for 1.
Right.

> Let's say I have the following ksmbd config:
> 
> root@f2-vm:~# cat /etc/ksmbd/smb.conf
> [global]
>         netbios name = SMBD
>         server max protocol = SMB3
> [test]
>         path = /opt
>         writeable = yes
>         comment = TEST
>         read only = no
> 
> So /opt can be an idmapped mount and ksmb would know how to deal with that correctly, i.e. you could
> do:
> 
> mount-idmapped --map-mount=b:1000:0:1 /opt /opt
> 
> ksmbd.mountd
> 
> and ksmbd would take the idmapping of /opt into account.
Right.

> 
> That however is different from 2. which is cifs itself being idmappable.
Right.

> Whether or not that makes sense or is needed will need some thinking.
> 
> In any case, this has consequences for xfstests and now I understand your earlier confusion. In
> another mail you pointed out that cifs reports that idmapped mounts are not supported. That is correct
> insofar as it means 2. is not supported, i.e. you can't do:
Right.

> 
> mount -t cifs -o username=foo,password=bar //server/files /mnt
> 
> and then
> 
> mount-idmapped --map-mount=b:1000:0:1 /mnt /mnt
> 
> but that's also not what you want in order to test for ksmbd. What you want is to test 1.
Right. So we have manually tested it, not xfstests.

> 
> So your test setup would require you to setup an idmapped mount and have ksmbd use that which can then
> be mounted by a client.
> 
> With your instructions I was at least able to get a ksmb instance running and be able to mount a
> client with -t cifs. All on the same machine, i.e. my server is localhost.
Okay.

> 
> However, I need to dig a bit into the semantics to make better assertions about what's going on.
Okay. And I have applied your patch to ksmbd.

> 
> Are unix extension supported with ksmb? Everytime I try to use "posix"
> as a mount option with mount -t cifs -o //127.0.0.1/test /mnt I get "uid=0" and "gid=0" and "noposix".
> I do set "unix extensions = yes" in both the samba and ksmbd smb.conf.
With posix mount option, It should work. It worked well before but it is strange now.

I'm not sure this is the correct fix, But could you please try to mount with the below change ?

diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
index eed59bc1d913..5fd0b0ddcc57 100644
--- a/fs/cifs/fs_context.c
+++ b/fs/cifs/fs_context.c
@@ -1268,8 +1268,10 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
        case Opt_unix:
                if (result.negated)
                        ctx->linux_ext = 0;
-               else
+               else {
+                       ctx->linux_ext = 1;
                        ctx->no_linux_ext = 1;
+               }
                break;
        case Opt_nocase:
                ctx->nocase = 1;

Thanks for your work!
> 
> Christian

