Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 227F0C0015E
	for <linux-cifs@archiver.kernel.org>; Fri, 11 Aug 2023 13:16:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232523AbjHKNQ0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 11 Aug 2023 09:16:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230423AbjHKNQZ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 11 Aug 2023 09:16:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2DFB2D43
        for <linux-cifs@vger.kernel.org>; Fri, 11 Aug 2023 06:16:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3755D6576A
        for <linux-cifs@vger.kernel.org>; Fri, 11 Aug 2023 13:16:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB998C433C7;
        Fri, 11 Aug 2023 13:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691759784;
        bh=p2racsPgzXovD6CSkmbjQJsqpW639oL9GYC8O9LkpmM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=h7fGmd11OCsZ1TYbswgausZ9ni9a7jLPUf4yK/GKiD/+2Ke42jcoCiZTFL0SeXiKL
         fHmEIZPoNg72+8ZWDvHzaIS4214kCN3u8mtU6UeaJXgNS9HYF53U9idUut7J2Cdtlp
         KdgKhhxTo0tmKb1S1SJIQfsj5wVxyjFxrfWyLllAo7Wkj6+nc6yFIKRztBFW7I3V3I
         OUrISEvpSDB1fv7hjdJqya4A8w18xPFsrfwmqUcbPDgcQvipP/o3QHqllFVtK3MaeM
         mhFe54Rnl8xeoYG7FXbuxpdkGytoJsNqGG7mQN5+fPgAyI/Z7c9nhaFSv8fgbR01Q5
         41XrDrQ3hBESQ==
Message-ID: <84c22724edac345b01e1e4b5527426e00b0be3e7.camel@kernel.org>
Subject: Re: [PATCH] cifs: missing null pointer check in cifs_mount
From:   Jeff Layton <jlayton@kernel.org>
To:     Steve French <smfrench@gmail.com>, Paulo Alcantara <pc@cjr.nz>
Cc:     =?ISO-8859-1?Q?Aur=E9lien?= Aptel <aaptel@suse.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Jay Shin <jaeshin@redhat.com>
Date:   Fri, 11 Aug 2023 09:16:22 -0400
In-Reply-To: <CAH2r5mspWoea04K3Veuy9b-4k_TOLvuA13Xxnc8o0c=8g8zJrg@mail.gmail.com>
References: <CAH2r5mvxp8OZthKPQGCv82xEkNW+z7SN_QhdRUMnHJ2Fm4pJqA@mail.gmail.com>
         <875yy4red3.fsf@suse.com> <B3F6DE12-CA6D-47BD-9383-B4BD2F73FCBC@cjr.nz>
         <CAH2r5mspWoea04K3Veuy9b-4k_TOLvuA13Xxnc8o0c=8g8zJrg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, 2021-06-23 at 19:34 -0500, Steve French wrote:
> updated patch attached with Aurelien's suggestion.
>=20
> On Wed, Jun 23, 2021 at 7:17 AM Paulo Alcantara <pc@cjr.nz> wrote:
> >=20
> > Agreed.
> >=20
> > On June 23, 2021 8:48:24 AM GMT-03:00, "Aur=E9lien Aptel" <aaptel@suse.=
com> wrote:
> > > Steve French <smfrench@gmail.com> writes:
> > > > We weren't checking if tcon is null before setting dfs path,
> > > > although we check for null tcon in an earlier assignment statement.
> > >=20
> > > If tcon is NULL there is no point in continuing in that function, we
> > > should have exited earlier.
> > >=20
> > > If tcon is NULL it means mount_get_conns() failed so presumably rc wi=
ll
> > > be !=3D 0 and we would goto error.
> > >=20
> > > I don't think this is needed. We could change the existing check afte=
r
> > > the loop to this you really want to be safe:
> > >=20
> > >       if (rc || !tcon)
> > >               goto error;
> > >=20
> > >=20
> > > Cheers,
>=20
>=20
>=20

I know this patch is ancient and the mainline code has marched on, but
it seems really suspicious to me.

With this, we have cifs_mount returning 0, even though the superblock
hasn't been properly initialized. Is that expected? Shouldn't it return
an error in that case?

The mount handling has morphed considerably since this patch went in, so
I can't really tell whether this was later fixed or not.
--=20
Jeff Layton <jlayton@kernel.org>
