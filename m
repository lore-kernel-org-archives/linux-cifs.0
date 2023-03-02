Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94B55C678D4
	for <linux-cifs@archiver.kernel.org>; Thu,  2 Mar 2023 19:38:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbjCBTii (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 2 Mar 2023 14:38:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjCBTih (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 2 Mar 2023 14:38:37 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37F8415C81
        for <linux-cifs@vger.kernel.org>; Thu,  2 Mar 2023 11:38:36 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id a9so357924plh.11
        for <linux-cifs@vger.kernel.org>; Thu, 02 Mar 2023 11:38:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ixsystems.com; s=google; t=1677785915;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MP8klIlkGjxi86EowgbbvVUpjn1ecCb8v0dZGCZRXnk=;
        b=QoClbpShbbogdxbb3Q80T7PvsteTV47udPWeTRbjPwUU/BhMUbTxhmzDnGV/ld7e8e
         f3YO+7HO0124MKElkOqmZ3VJTH/b98zZ9/CscSlwfAn+3fw3Ae5Yg52MY/hGdW+gN/gb
         4+sA+lmyJ1tg3GM4ejWRf+409RUPTb6qMWC5r2sdcs93JomMkwL8aLHkSbeUj0PSLKdh
         gBBge23sDQ8p/NVEIJtQILXVD4Us4Dc4I9tz9Q4ZGmcunB4CctR1tDpgyK8sMnAEvX9L
         xajarYBpobcG1vl+rL0WzSOyBLS7p/xW7zZ/wULeSZrugJ42sEOxNLTVvpd7mtTHgAbm
         5g/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677785915;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MP8klIlkGjxi86EowgbbvVUpjn1ecCb8v0dZGCZRXnk=;
        b=2bE+nG4n1YZTJ3HankF9ijpkEQShx+baUegVfVgqvVG4Ysol/1CWxnlaDcQsyglmgS
         W7UFcgEMxilug3dPtj1yYoLhcsET/CGesm1lpJidwKewxyzhwaaeSWx9uIqgBORZnDbn
         g4kRxsrOHZo4m4HwkMYjdSa1dLuHjMQQgTGeICa33Mdwi3e9KfG3ZWmTxv5CdhW30Mwm
         3JjOvXkH7PUUaNg0hsXtVSV54JIql4Syi+cSg1LfV6saKq1g/ZuzmwSFj1YUtrzOolCz
         zA6CE8v/cTBMa6guehT7m5SwFtPp2pQQLu8xGrnXP74MDYKVTGde1tJan9jXJgpZiUZx
         h3Sw==
X-Gm-Message-State: AO0yUKWNs03QIJDk/cMfxlmHmtC1RkscDJ4Zdei0o7a+IQE4NFwXiScx
        peJjKISt9Qke4/4j0RQKmS/urkh3Nlk8+J+oJIlxlQ==
X-Google-Smtp-Source: AK7set/9d3+1nDPL7yR0YwwLQAzh1gfAoIIFsXF4hedF+IMne5IjdnO9p9pjtJSJugxRTYqkIhzNcAAiSyn+fQQqFhQ=
X-Received: by 2002:a17:903:44f:b0:19a:f63a:47db with SMTP id
 iw15-20020a170903044f00b0019af63a47dbmr4165095plb.2.1677785915542; Thu, 02
 Mar 2023 11:38:35 -0800 (PST)
MIME-Version: 1.0
References: <CAB5c7xoUXH6Xy+79Wz8M4yC70E=rwUL0ZRD_ApAFWv=C7S_uxg@mail.gmail.com>
 <514a3d90d263bd8422e9d13bd4c6e269.pc@manguebit.com> <CAB5c7xrdKSO4YE_vUQ6tg+p=WwxEdquj+VrRpwKxi8Jd0vPyAQ@mail.gmail.com>
 <CAH2r5mv52koGnKbvtRKE95c_JwwtitTXFaRc6mcM8nwLmWNo9A@mail.gmail.com>
 <300597ce-06a5-a987-5110-aa6ec24ea199@talpey.com> <CAH2r5msjKi-FMQRaHptk5fPycZRSS5ZQNC-u=1wE8oxBUhN5Ug@mail.gmail.com>
 <0a9990d0-84bf-d5b3-db11-8eafad22f618@talpey.com>
In-Reply-To: <0a9990d0-84bf-d5b3-db11-8eafad22f618@talpey.com>
From:   Andrew Walker <awalker@ixsystems.com>
Date:   Thu, 2 Mar 2023 14:38:24 -0500
Message-ID: <CAB5c7xoTahmT97te+vtsT4+E5nC_GmujJ4S_xOP04CT04boMkA@mail.gmail.com>
Subject: Re: Nested NTFS volumes within Windows SMB share may result in inode
 collisions in linux client
To:     Tom Talpey <tom@talpey.com>
Cc:     Steve French <smfrench@gmail.com>,
        Paulo Alcantara <pc@manguebit.com>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Mar 2, 2023 at 1:32=E2=80=AFPM Tom Talpey <tom@talpey.com> wrote:
>
> On 3/2/2023 2:23 PM, Steve French wrote:
> >> Why isn't this behavior simply the default?
> >
> > Without persisted inode numbers (UniqueId) it would cause problems
> > with hardlinks (ie mounting with noserverino).  We could try a trick
> > of hashing them with the volume id if we could detect the transition
> > to a different volume (as original thread was discussing) -
> > fortunately in Linux you have to walk a path component by component so
> > might be possible to spot these more easily.
>
> Well yeah, it can't be a random assignment, and the fileid is only
> unique within the scope of a volumeid. Blindly using the server's
> fileid as a client inode without checking for a volume crossing is
> a client protocol violation, right?
>
>
> > On Thu, Mar 2, 2023 at 1:19=E2=80=AFPM Tom Talpey <tom@talpey.com> wrot=
e:
> >>
> >> On 3/1/2023 8:49 PM, Steve French wrote:
> >>> I would expect when the inode collision is noted that
> >>> "cifs_autodisable_serverino()" will get called in the Linux client an=
d
> >>> you should see: "Autodisabling the user of server inode numbers on
> >>> ..."
> >>> "Consider mounting with noserverino to silence this message"
> >>
> >> Why isn't this behavior simply the default? It's going to be
> >> data corruption (sev 1 issue) if the inode number is the same
> >> for two different fileid's, so this seems entirely backwards.
> >>
> >> Also, the words "to silence this message" really don't convey
> >> the severity of the situation.
> >>
> >> Tom.
> >
> >
> >

Just glancing briefly at the kernel NFS client, it appears there is
dynamic handling for crossing mountpoints:
```
/*
 * nfs_d_automount - Handle crossing a mountpoint on the server
 * @path - The mountpoint
 *
 * When we encounter a mountpoint on the server, we want to set up
 * a mountpoint on the client too, to prevent inode numbers from
 * colliding, and to allow "df" to work properly.
 * On NFSv4, we also want to allow for the fact that different
 * filesystems may be migrated to different servers in a failover
 * situation, and that different filesystems may want to use
 * different security flavours.
 */
struct vfsmount *nfs_d_automount(struct path *path)
{
```
c.f. fs/nfs/namespace.c

and

```
                } else if (S_ISDIR(inode->i_mode)) {
                        inode->i_op =3D
NFS_SB(sb)->nfs_client->rpc_ops->dir_inode_ops;
                        inode->i_fop =3D &nfs_dir_operations;
                        inode->i_data.a_ops =3D &nfs_dir_aops;
                        nfs_inode_init_dir(nfsi);
                        /* Deal with crossing mountpoints */
                        if (fattr->valid & NFS_ATTR_FATTR_MOUNTPOINT ||
                                        fattr->valid &
NFS_ATTR_FATTR_V4_REFERRAL) {
                                if (fattr->valid & NFS_ATTR_FATTR_V4_REFERR=
AL)
                                        inode->i_op =3D
&nfs_referral_inode_operations;
                                else
                                        inode->i_op =3D
&nfs_mountpoint_inode_operations;
                                inode->i_fop =3D NULL;
                                inode->i_flags |=3D S_AUTOMOUNT;
                        }
```

in fs/nfs/inode.c

Andrew
