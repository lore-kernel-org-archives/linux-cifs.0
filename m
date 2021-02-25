Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCBC2C433E0
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Feb 2021 00:44:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5639864ED6
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Feb 2021 00:44:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232139AbhBYAo1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 24 Feb 2021 19:44:27 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:43625 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229752AbhBYAo1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 24 Feb 2021 19:44:27 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 173DA5C0116;
        Wed, 24 Feb 2021 19:43:41 -0500 (EST)
Received: from imap1 ([10.202.2.51])
  by compute1.internal (MEProxy); Wed, 24 Feb 2021 19:43:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        simon-taylor.me.uk; h=mime-version:message-id:date:from:to:cc
        :subject:content-type; s=fm2; bh=djp7zLT0nDP/ynI8Ap4AY9ff0GVowNr
        yJMaxQV/bcuw=; b=BxQx6JAxTRlJcqsaNYycy5x15wKFHDa2YLD2eBgtyvpEOYf
        r1TB1nMx/6k04bV7s3QxPnNfAofLUC6zWWHDMnEWJMS45Rway2M3fNzyodxid1uF
        JTNk25eNUgfs0tXrY5gaO2JUPB8v1N/1PLwSClzyQEIaW8muqCX80yvvUeZkhViu
        thjoDryWOBJWn9OBkBeYT80zAHO3gP9rTEjsVUKLEcddvMIBPawjbcrCFqaGhMWh
        NRgS3YwHcjGSspOFLc+EgKt1ZxnYrs4TEE8KCjQnxENr1gKk4BqLLubPYE7qu430
        Wp6BiTUnT4ZeIyUxLapCntIxWmUEnv4juWXDvwA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:message-id
        :mime-version:subject:to:x-me-proxy:x-me-proxy:x-me-sender
        :x-me-sender:x-sasl-enc; s=fm2; bh=djp7zLT0nDP/ynI8Ap4AY9ff0GVow
        NryJMaxQV/bcuw=; b=mpul+RWwCIFx8pnm2OrwXZqyFmZS6rCgBCIRYkofcbWzn
        MXPMbw5puKzeKAeVQKQJ9Aks9DO8OstfNuj09oEHPZYMNlAZj0paiXtSLZNtqRCK
        jNY7KGnkNoaBsO3NY87ppJidZvPmZ51bGEP/aJTUWs3eU4NhUsQValQPfuvFmaBD
        Uw+gCDBNQaY+ixzWkrtVIAKzW080RRE87OK9RfmEUDukOYH5tbgnoO5e6dTxODYm
        Lcqo3llYvTGA0jff75PvjGIS/aPe6SU76oeeIwQyrHRhmnb/TW8FC8KtenERkSK5
        3qKKPZlyOozaLdBBqbQoNgBHkpG1F8WWUB4wgAlbw==
X-ME-Sender: <xms:u_I2YH5m7WbPPJf4ZD9iJyvD5LFrY-DkoiK6FaaYKw_80mI8HbJ5oA>
    <xme:u_I2YM7zRyUt1WDN9dRdrcLp9-7XChNcKtOTsr9D23h4-FVU3LbBkTW0whjuMEKRX
    5aYeOI8V9kkq5HnnQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrkeekgddvgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfffhffvufgtsehttdertderredtnecuhfhrohhmpedfufhimhhonhcu
    vfgrhihlohhrfdcuoehsihhmohhnsehsihhmohhnqdhtrgihlhhorhdrmhgvrdhukheqne
    cuggftrfgrthhtvghrnhepveejgeegtdfgveevvdduffelgfekfeetuddvjefhueevgfev
    hfdvudeivefffeefnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilh
    hfrhhomhepshhimhhonhesshhimhhonhdqthgrhihlohhrrdhmvgdruhhk
X-ME-Proxy: <xmx:u_I2YOc69uFXc6vHzhz0rz7z6dJWn4ncc1FBn5-AE86R-v9LrQm_ZA>
    <xmx:u_I2YIIKmlKq1wqJwrWvDSaKlkJNhFh-H3F8mkooQTvZ9ZwPHjjbsg>
    <xmx:u_I2YLIJIzkF3gYj_eP5QXEnFY7YYujE7haB38eykR-bE-ILrnKwjw>
    <xmx:vfI2YNwtAzTM22JwGp91yQMbbMAnArolJJarbPkP331WxIDFZk6pOA>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 39E43130005D; Wed, 24 Feb 2021 19:43:39 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-141-gf094924a34-fm-20210210.001-gf094924a
Mime-Version: 1.0
Message-Id: <0736dea6-ab54-454d-a40b-adaa372a1f53@www.fastmail.com>
Date:   Thu, 25 Feb 2021 00:43:18 +0000
From:   "Simon Taylor" <simon@simon-taylor.me.uk>
To:     "Steve French" <sfrench@samba.org>
Cc:     linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Subject: Using a password containing a comma fails with 5.11.1 kernel
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

There seems to be a bug mounting a share when the password contains a comma with the 5.11.1 kernel.

I used a credential file named commapw

user=CommaTest
pass=beforecomma,aftercomma

and the mount command

mount.cifs //workstation/arch /mnt/arch -o vers=3.1.1,cred=/root/commapw

This successfully mounts the share when using the 5.10.16 kernel but fails when using 5.11.1.

The debug log was:

[ 3835.380355] CIFS: fs/cifs/fs_context.c: CIFS: parsing cifs mount option 'source'
[ 3835.380360] CIFS: fs/cifs/fs_context.c: CIFS: parsing cifs mount option 'ip'
[ 3835.380362] CIFS: fs/cifs/fs_context.c: CIFS: parsing cifs mount option 'unc'
[ 3835.380364] CIFS: fs/cifs/fs_context.c: CIFS: parsing cifs mount option 'vers'
[ 3835.380365] CIFS: fs/cifs/fs_context.c: CIFS: parsing cifs mount option 'user'
[ 3835.380366] CIFS: fs/cifs/fs_context.c: CIFS: parsing cifs mount option 'pass'
[ 3835.380367] CIFS: fs/cifs/fs_context.c: CIFS: parsing cifs mount option 'aftercomma'
[ 3835.380368] cifs: Unknown parameter 'aftercomma'

The kernels are from Arch Linux packages:

Linux 5.10.16-arch1-1 #1 SMP PREEMPT Sat, 13 Feb 2021 20:50:18 +0000 x86_64 GNU/Linux
Linux 5.11.1-arch1-1 #1 SMP PREEMPT Tue, 23 Feb 2021 14:05:30 +0000 x86_64 GNU/Linux

-- 
Regards,
Simon
