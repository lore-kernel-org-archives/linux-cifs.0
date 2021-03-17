Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5209EC4332E
	for <linux-cifs@archiver.kernel.org>; Wed, 17 Mar 2021 22:11:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26DED64F26
	for <linux-cifs@archiver.kernel.org>; Wed, 17 Mar 2021 22:11:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbhCQWK6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 17 Mar 2021 18:10:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbhCQWKY (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 17 Mar 2021 18:10:24 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29287C06174A
        for <linux-cifs@vger.kernel.org>; Wed, 17 Mar 2021 15:10:23 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id 15so5174952ljj.0
        for <linux-cifs@vger.kernel.org>; Wed, 17 Mar 2021 15:10:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=05fERVyE54TDxhytiX//TrVT2m/SBW1bWCi76mbIC7g=;
        b=HfmOzU1k2aUWtpmU/fFTZ5pvoYvHl7p8UbXKTBNRgqWnHykvpfJ8uYK5LZa2oktPwi
         DLws9q4+tuWGUi84IL/G2NyZEhVuxK1JkYTwkztPPr/w8saAP/ayC/Q3JwYyHSNHp11I
         Xf8q6TdLroTaLr1KL+EUehLXWKf3j/cxoYFnz+eRin46i+oXThMqxm7lhLfnaNu4+DDE
         7izJF27hAzx+HzLChKGc3P/HX/3ePwxEMkk+nImcfv7z53ZKT97SxD6cqXcOhgtf+K65
         SsRSimktYSmbqZX9LskG1RhApNq2WlfFA0lFfLJjA0GTPfxCyjVSrzQpYh7/1B+uy6jH
         JATQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=05fERVyE54TDxhytiX//TrVT2m/SBW1bWCi76mbIC7g=;
        b=VRTeKErDeZxkblfR1v90KnlKsk/Wst0t1Hqw30aM8bFI7ChyH5hUT0okQA9TlS+fQ1
         Kcxf/QKuKwS2bldsZaEOvqkQL7eXJ7QSBJcvwtvm8GXcBAAgNQNb+kNRIsdX5vYWeoHJ
         CfMnnCn3SoSfI8KGFA0Jpioy0ROZINl2mlZijyNY+5lTQXYQyamgOP86RxsjH0w8rhcT
         5XV8QALfL4oeHpFmvy5D+QG1hgpNVilAMQ6eBUB5+FtXxgkX75NXEJ55vJ/a7U6SIttt
         I4x/ReScKfiF8Vm8lsKjd55GE7jhEsQvu+UWJYOu7La7uV7YWeKrB9/pPzjTbvtOkCzy
         D/HQ==
X-Gm-Message-State: AOAM533JvqYwuwsSgCbgJj5290xf5zA+ntDEY5psgOGNXX/wb6hUM8Xl
        f9iB4+sV3CTbFIg238ugdvTgawVETOf30wZozP4HaBvUVLs+vA==
X-Google-Smtp-Source: ABdhPJxPZX4FQWn/v1Hd8K6SRYHaxDWW2lb0PLgcXAz01vEk2V5kyPakrC/N3bu4AlabD3vAdS750wQGE2epcXXVRkc=
X-Received: by 2002:a2e:921a:: with SMTP id k26mr3101966ljg.149.1616019021909;
 Wed, 17 Mar 2021 15:10:21 -0700 (PDT)
MIME-Version: 1.0
From:   Richard Beare <richard.beare@gmail.com>
Date:   Thu, 18 Mar 2021 09:10:10 +1100
Message-ID: <CA+V7QS9gJ+WX6iVsRBaCoHZXwr-zPQSNWbsUqk=N06xAYv1N6g@mail.gmail.com>
Subject: Query - cifscreds usage
To:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi,
Apologies in advance if this is the wrong forum. Getting help
documentation directed me here. I'm setting up a small set of
workstations with what I hope to be three types of users, and would
like to clarify whether certain parts of the cifs configuation are
possible - something I haven't been able to determine from manuals or
google to date.

The base system is ubuntu 20.04lts:

uname -r
5.4.0-67-generic

mount.cifs -V
mount.cifs version: 6.9

The current setup of the machine successfully handles the cifs mount
via pam_mount. The mount uses ntlmssp credentials, with a command
like:

MOUNT_OPTIONS="-o
username=${USER},uid=${_UID},gid=${_GID},domain=DOMAIN,sec=ntlmssp,vers=2.1"
AD_SHARE="//ad.host/home/user${USER_FOLDER}/${USER}"

mount -t cifs ${AD_SHARE} ${_MNTPT} ${MOUNT_OPTIONS}

There is no kerberos for the cifs share available to linux.
What I'd like to know is whether it is possible to use kernel key
credentials, like those stored with cifscreds, to authenticate a mount
request at other times.

For example, might it be possible to capture those credentials in the
pam process and then later issue a mount command that does not prompt
for a password? My interpretation of the docs suggests that it isn't
possible - the credentials are used to control access to an already
mounted share, rather than perform the initial mount.

I'd like to be able to have both cifs and nfs mounts happening in the
same place under autofs control, but without placing credentials in
files. The cifscreds option seems very close, but not quite right - is
my interpretation right?


More information on why I'm asking this - I'd like a user to be able
to authenticate against AD,
get checked against some list, have an nfs mounted home directory
provided if available and the cifs share mounted elsewhere for
convenience. A cifs share gets used for home folders if the user isn't
on the special list. Any user should be able to trigger automounts of
nfs home folders by accessing them, as in a typical pure linux setup.

The other option I think may be viable is modification of the home
folder location during the login process, but I can't see how to
achieve that either.
Thanks
