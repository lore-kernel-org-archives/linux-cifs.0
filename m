Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02153C0015E
	for <linux-cifs@archiver.kernel.org>; Fri, 11 Aug 2023 15:16:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233860AbjHKPQF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 11 Aug 2023 11:16:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233486AbjHKPQD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 11 Aug 2023 11:16:03 -0400
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D315C2D7F
        for <linux-cifs@vger.kernel.org>; Fri, 11 Aug 2023 08:16:02 -0700 (PDT)
Message-ID: <169d12e72d7d732d32051d22f255c5df.pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1691766961;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fQtzzTtCUNxkuI59Gda5yr11KsKqlzQNxr7ctuLdfbI=;
        b=go/hva8kiDLHQjVUVfVVqE+qC3CNHAxsatZayEUTFOmM0B/AybMc9z7XTBmcLgp3uG0lT0
        b4NmuzLv9w7zWYGRTN5B8jUpxwwx7Tqh5SruXX+NxNgmqN6QnlqisHF9hLaSKhgOVZaspK
        S+Yb8bhbNGslaySdDAqzloA3q2l7fA175tGvhydFjxFxtEFZ2ygGxOLTkWFOSeD6e84K1s
        GFGOSA98FOhgRhafV5Ud8ruy5JbPUhv55kSfdDaPEudH+nb4K5AxA1TBzkuBUbch5KKMVG
        kYWgloigt5GA95r6qSAj98MaYZqxzjZyMAF0OXckskYZc9G4ZJKAcj49sbLH4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1691766961;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fQtzzTtCUNxkuI59Gda5yr11KsKqlzQNxr7ctuLdfbI=;
        b=cnUbkxR6d0SqRglOkZouV+34rsP5mcVp4xrN9n+Rw3mucJQWPOlRn4aG3iaG3SagS0C91t
        a6IWSuxGBIiSyjjQOsckNXV96OfFOR8eucFRa3jeUdAan8iV+AhtiumBgiSbNoMW6sVCKw
        LKgGbThG9N9eenBa8CvpXpN1g03D110ZOkcAWAJc5w+eNtWyP4OxCOo8MPh65QxnFeh0c7
        r2WoxGBZHjGaWn+DxLpJT6muXIj75u9DUKmNCCKlKwCllV+nZYPigSKyTTYqVVT8UmMe76
        w1dEIHSapxs6dqABCdaR7Ck1fZoBApL6/laH02bUcfnfY/uI1hQA0eQb5f5LQA==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1691766961; a=rsa-sha256;
        cv=none;
        b=GcYFTZT5abSa6rESIPQXPZs6+rwyj6EROYGE+D8EgMxA0jHDcRSni7Fw1cD0kwlApohCGY
        gwSA7R6xx7+auCk8R8awDADcZjh5uVqjiIcrAGzMIx4LoERDYd0Sd7RcquODG3BsKySDw+
        4YZ/iC8p6PQFp3v55C+KId2V/Jg3UeU1OejHmaX/DO1XxxbyEnTR1x9Di30MNAyhrTCjjN
        yYGEeZupFRFnyqZB5ph5Ul1LPpk3k/mQkYpKswiy5TXZ1D4R8EOTv1C2Ld+yp3mZ1lDn4W
        Smc4z7H55EUHmA7MzPQunAVHq78dx0REj88I+lcdrPPyu6kBf7iWaipkfGThvw==
From:   Paulo Alcantara <pc@manguebit.com>
To:     Jeff Layton <jlayton@kernel.org>, Steve French <smfrench@gmail.com>
Cc:     =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Jay Shin <jaeshin@redhat.com>
Subject: Re: [PATCH] cifs: missing null pointer check in cifs_mount
In-Reply-To: <84c22724edac345b01e1e4b5527426e00b0be3e7.camel@kernel.org>
References: <CAH2r5mvxp8OZthKPQGCv82xEkNW+z7SN_QhdRUMnHJ2Fm4pJqA@mail.gmail.com>
 <875yy4red3.fsf@suse.com> <B3F6DE12-CA6D-47BD-9383-B4BD2F73FCBC@cjr.nz>
 <CAH2r5mspWoea04K3Veuy9b-4k_TOLvuA13Xxnc8o0c=8g8zJrg@mail.gmail.com>
 <84c22724edac345b01e1e4b5527426e00b0be3e7.camel@kernel.org>
Date:   Fri, 11 Aug 2023 12:15:55 -0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Jeff Layton <jlayton@kernel.org> writes:

> On Wed, 2021-06-23 at 19:34 -0500, Steve French wrote:
>> updated patch attached with Aurelien's suggestion.
>>=20
>> On Wed, Jun 23, 2021 at 7:17 AM Paulo Alcantara <pc@cjr.nz> wrote:
>> >=20
>> > Agreed.
>> >=20
>> > On June 23, 2021 8:48:24 AM GMT-03:00, "Aur=C3=A9lien Aptel" <aaptel@s=
use.com> wrote:
>> > > Steve French <smfrench@gmail.com> writes:
>> > > > We weren't checking if tcon is null before setting dfs path,
>> > > > although we check for null tcon in an earlier assignment statement.
>> > >=20
>> > > If tcon is NULL there is no point in continuing in that function, we
>> > > should have exited earlier.
>> > >=20
>> > > If tcon is NULL it means mount_get_conns() failed so presumably rc w=
ill
>> > > be !=3D 0 and we would goto error.
>> > >=20
>> > > I don't think this is needed. We could change the existing check aft=
er
>> > > the loop to this you really want to be safe:
>> > >=20
>> > >       if (rc || !tcon)
>> > >               goto error;
>> > >=20
>> > >=20
>> > > Cheers,
>>=20
>>=20
>>=20
>
> I know this patch is ancient and the mainline code has marched on, but
> it seems really suspicious to me.

Yes, it is.

> With this, we have cifs_mount returning 0, even though the superblock
> hasn't been properly initialized. Is that expected? Shouldn't it return
> an error in that case?

No, that isn't expected.  And yes, if @tcon would ever be NULL at that
point, we should be returning an error instead.  Otherwise we'd end up
dereferencing a NULL @tcon while trying to get an inode for the root
dentry later.

However, by quickly looking at the old code -- on top of 162004a2f7ef --
I don't see how we'd end up having a NULL @tcon with rc =3D=3D 0 as
mount_get_conns() would return -errno if it couldn't get a tcon.  Please
correct me if I'm missing something.  Whether it is possibile or not,
the NULL @tcon check is certainly missing a 'rc =3D -ENOENT' or some other
error before bailing out as you've pointed out.

> The mount handling has morphed considerably since this patch went in, so
> I can't really tell whether this was later fixed or not.

I don't think there was a follow-up patch for that.
