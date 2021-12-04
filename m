Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B577C433F5
	for <linux-cifs@archiver.kernel.org>; Sat,  4 Dec 2021 02:00:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237319AbhLDCEU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 3 Dec 2021 21:04:20 -0500
Received: from mx.cjr.nz ([51.158.111.142]:58892 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231452AbhLDCET (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 3 Dec 2021 21:04:19 -0500
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 03B46808AC;
        Sat,  4 Dec 2021 02:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1638583253;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1GMjEfLv7xG1hO2N7HtyDEHeVz4KDWDaJ5vJk0m5uIg=;
        b=NWue+Tt8XVoPkDzb8Mp/w9Zop1a1PWvJ6NHz9fRrdpfCz+R2PzOzkk5lzGHZogva2RNXal
        beA7d1QVwu7nSeKvOBwir0skWMi4+IvU71u3ArK8HIuNfPWrHlevr7l2HMxiE5rcSKYXoV
        KdXfdmuh9LiNxsYJ/IUvtl5RlPadav0j/9Gs47yfg/t/cHlw90eULWu6IJvaK/Kb+OCpwl
        yjFqlyeUyKJ6F//pNOpeQKvWFyhX/4mrGo+TIj7A5VHp1WwugHB6Ttw39b8D1IdQrQuQnv
        nmnn94jv6O1E3MlYALwiFKSN7Jby4LLS0CNLRG+7+R9s18a124Up7Nj4wrDg9w==
Date:   Fri, 03 Dec 2021 23:00:42 -0300
From:   Paulo Alcantara <pc@cjr.nz>
To:     Jeff Layton <jlayton@redhat.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>, linux-cachefs@redhat.com
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH=5D_cifs=3A_wait_for_tcon_reso?= =?US-ASCII?Q?urce=5Fid_before_getting_fscache_super?=
In-Reply-To: <88b88564292f84714c83bfe14cae75691e4387c5.camel@redhat.com>
References: <CANT5p=qXbQU4g4VX=W9mOQo1SjMxnFGfpkLOJWgCpicyDLvt-w@mail.gmail.com> <88b88564292f84714c83bfe14cae75691e4387c5.camel@redhat.com>
Message-ID: <5550E7F6-E870-4A21-88F5-4D08BE5990CF@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On December 3, 2021 1:21:15 PM GMT-03:00, Jeff Layton <jlayton@redhat=2Ecom=
> wrote:
>On Fri, 2021-12-03 at 14:52 +0530, Shyam Prasad N wrote:
>> The logic for initializing tcon->resource_id is done inside
>> cifs_root_iget=2E fscache super cookie relies on this for aux
>> data=2E So we need to push the fscache initialization to this
>> later point during mount=2E
>>=20
>> Signed-off-by: Shyam Prasad N <sprasad@microsoft=2Ecom>
>> ---
>>  fs/cifs/connect=2Ec | 6 ------
>>  fs/cifs/fscache=2Ec | 2 +-
>>  fs/cifs/inode=2Ec   | 7 +++++++
>>  3 files changed, 8 insertions(+), 7 deletions(-)
>>=20
>> diff --git a/fs/cifs/connect=2Ec b/fs/cifs/connect=2Ec
>> index 6b705026da1a3=2E=2Eeee994b0925ff 100644
>> --- a/fs/cifs/connect=2Ec
>> +++ b/fs/cifs/connect=2Ec
>> @@ -3046,12 +3046,6 @@ static int mount_get_conns(struct mount_ctx *mnt=
_ctx)
>>   cifs_dbg(VFS, "read only mount of RW share\n");
>>   /* no need to log a RW mount of a typical RW share */
>>   }
>> - /*
>> - * The cookie is initialized from volume info returned above=2E
>> - * Inside cifs_fscache_get_super_cookie it checks
>> - * that we do not get super cookie twice=2E
>> - */
>> - cifs_fscache_get_super_cookie(tcon);
>>   }
>>=20
>>   /*
>> diff --git a/fs/cifs/fscache=2Ec b/fs/cifs/fscache=2Ec
>> index 7e409a38a2d7c=2E=2Ef4da693760c11 100644
>> --- a/fs/cifs/fscache=2Ec
>> +++ b/fs/cifs/fscache=2Ec
>> @@ -92,7 +92,7 @@ void cifs_fscache_get_super_cookie(struct cifs_tcon *=
tcon)
>>   * In the future, as we integrate with newer fscache features,
>>   * we may want to instead add a check if cookie has changed
>>   */
>> - if (tcon->fscache =3D=3D NULL)
>> + if (tcon->fscache)
>>   return;
>>=20
>
>Ouch! Does the above mean that fscache on cifs is just plain broken at
>the moment? If this is the routine that sets the tcon cookie, then it
>looks like it just never gets set?

Dont much know about fscache, but remember that multiple mounts can share =
a single tcon (if not using nosharesock)=2E  So, if we find an existing tco=
n and we have a cookie for it already, the check makes sense=2E

>
>>   sharename =3D extract_sharename(tcon->treeName);
>> diff --git a/fs/cifs/inode=2Ec b/fs/cifs/inode=2Ec
>> index 82848412ad852=2E=2E96d083db17372 100644
>> --- a/fs/cifs/inode=2Ec
>> +++ b/fs/cifs/inode=2Ec
>> @@ -1376,6 +1376,13 @@ struct inode *cifs_root_iget(struct super_block =
*sb)
>>   inode =3D ERR_PTR(rc);
>>   }
>>=20
>> + /*
>> + * The cookie is initialized from volume info returned above=2E
>> + * Inside cifs_fscache_get_super_cookie it checks
>> + * that we do not get super cookie twice=2E
>> + */
>> + cifs_fscache_get_super_cookie(tcon);
>> +
>>  out:
>>   kfree(path);
>>   free_xid(xid);
>>=20
>

