Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EE07C433B4
	for <linux-cifs@archiver.kernel.org>; Tue,  4 May 2021 07:49:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2514261176
	for <linux-cifs@archiver.kernel.org>; Tue,  4 May 2021 07:49:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbhEDHus (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 4 May 2021 03:50:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbhEDHus (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 4 May 2021 03:50:48 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07586C061574
        for <linux-cifs@vger.kernel.org>; Tue,  4 May 2021 00:49:54 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id d25so7971102oij.5
        for <linux-cifs@vger.kernel.org>; Tue, 04 May 2021 00:49:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=YBeNKt5XYGJH9WrXKnL7Q+6ZOWf+fG2oNwuWc+bCkSE=;
        b=rKBM5v6G+HuPSa9tcLirQpUvqWoNeHVWKEGzMJO75iwI88tsjif9UZSbCfJHekSzIM
         3RicUCzPfaRCuXvzMl7PEFuMf7Iap4BfBt6HGJ2SlFsRV2WYiyMCo2AKZT6Kvw171tkp
         UCw0GGMDuA7iIVp9ouwR8tl0an/0JyyY8MP+vQQevU4Ic+HMLC+xHcKvCN8og+WIOS82
         zT4CeVgX/1cHVzowuCrLGxjxlf/JB5ZmA2CX5BD3sI73CvOfwcFMmqW3u0M+aolLZD5e
         yI5n9wfwYiXYx6044vv/es9tp9pwbWyGTfxwuzZkI8pOEE7K9dkPES36c9XeQSZQZ8Q1
         oLXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=YBeNKt5XYGJH9WrXKnL7Q+6ZOWf+fG2oNwuWc+bCkSE=;
        b=YHTov5pIANtatDx1teSjIHW4JabhbOYG/p9igCNRVLupoGEQUAMS0rVt+v7Xn49plR
         FFPJXG8DiAQwsjWxXidssC0MHinBlTt//4zyYtv+HImZXrcidHvNqFiB5xYJcGHmZTLq
         5jgBOUSF81kOsZxs9zrLS6MYkBhf0FAwN0K5/keF2cr35jdaHZMqZqI4jEkLSqy5XutF
         VnbbjSfqBM5KE285XeFkWn6G4szsAebeWCP5IyHkLy9fZIiBlzYawOfOMyAqJu1Lzbfg
         qQTfKC0LpsvSC2tMqz3o8SpJUAlsrrlTEU/HECGIBwJvWHnZSZ9WOi39ub5M5zsrFl2W
         5fLg==
X-Gm-Message-State: AOAM5320a+WGzHoRgUuvKOZmCwu8DFxN4hbpEhplxQpNcPJ/oE34kw54
        KCMCR+ZLnANRy6DEZkV/PpwaY7yIngGxGevq5lEPJgTKt7l/ZjpI
X-Google-Smtp-Source: ABdhPJzDxFwRhX2NqNW69C92VOnx16gFhVhZCRProVQO9bPRweZMR1gBbrnynXRbvcroH7LCmiD3Ov3K4VZFwik1mpg=
X-Received: by 2002:a54:4f07:: with SMTP id e7mr13930525oiy.140.1620114593432;
 Tue, 04 May 2021 00:49:53 -0700 (PDT)
MIME-Version: 1.0
From:   Calvin Chiang <calvin.chiang@gmail.com>
Date:   Tue, 4 May 2021 09:49:42 +0200
Message-ID: <CAEVyU88zhTKVrbk-+YCrd4fTN=za8906CwFFGzDk0OovSD4=QA@mail.gmail.com>
Subject: Unable to find pw entry for uid
To:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi



I=E2=80=99m attempting to get autofs (using cifs) to automatically mount us=
er
directories for me using existing Kerberos credentials.

But it doesn=E2=80=99t even make it to the Kerberos section of cifs.upcall =
as



My /etc/auto.master config looks like this:



/cifs /etc/auto.cifs



My /etc/auto.cifs config looks like this:



folder1   -fstype=3Dcifs,multiuser,uid=3Dalice,user=3Dalice,cruid=3Dalice,s=
ec=3Dkrb5,vers=3D3.0
   ://member-server.cyberloop.local/sharedfolder/folder1



Note:

    I=E2=80=99ve hardcoded the uid/cruid/user, as the expansion didn=E2=80=
=99t seem
tobe working properly.
    The user =E2=80=9Calice=E2=80=9D has uid 1023001106
    The user =E2=80=9Calice=E2=80=9D, is the owner of the krb5 ticket /tmp/=
krb5_1023001106





when I attempt to access the folder /cifs/folder1 I get the following error=
:



May  3 14:34:41 centos8 kernel: fs/cifs/cifs_spnego.c: key description
=3D ver=3D0x2;host=3Dmember-server.cyberloop.local;ip4=3D192.168.0.102;sec=
=3Dkrb5;uid=3D0x3cf9c212;creduid=3D0x3cf9c212;user=3Dalice;pid=3D0x10ad28

May  3 14:34:41 centos8 cifs.upcall[1092907]: key description:
cifs.spnego;0;0;39010000;ver=3D0x2;host=3Dmember-server.cyberloop.local;ip4=
=3D192.168.0.102;sec=3Dkrb5;uid=3D0x3cf9c212;creduid=3D0x3cf9c212;user=3Dal=
ice;pid=3D0x10ad28

May  3 14:34:41 centos8 cifs.upcall[1092907]: ver=3D2

May  3 14:34:41 centos8 cifs.upcall[1092907]: host=3Dmember-server.cyberloo=
p.local

May  3 14:34:41 centos8 cifs.upcall[1092907]: ip=3D192.168.0.102

May  3 14:34:41 centos8 cifs.upcall[1092907]: sec=3D1

May  3 14:34:41 centos8 cifs.upcall[1092907]: uid=3D1023001106

May  3 14:34:41 centos8 cifs.upcall[1092907]: creduid=3D1023001106

May  3 14:34:41 centos8 cifs.upcall[1092907]: user=3Dalice

May  3 14:34:41 centos8 cifs.upcall[1092907]: pid=3D1092904

May  3 14:34:41 centos8 cifs.upcall[1092907]: Unable to find pw entry
for uid 1023001106: Success

May  3 14:34:41 centos8 cifs.upcall[1092907]: Exit status 1



The weird thing here is that it hits this section of cifs.upcall.c and
errors here:



    pw =3D getpwuid(uid);

    if (!pw) {

        syslog(LOG_ERR, "Unable to find pw entry for uid %d: %s\n",

            uid, strerror(errno));

        rc =3D 1;

        goto out;

    }



Now oddly the strerror(errno) is actually returning SUCCESS



But the pw =3D getpwuid(uid); is failing.



Getpwuid(uid) is calling nss.



My nss config looks like this:



passwd:         files systemd sss

group:          files systemd sss

shadow:         files sss

gshadow:        files



hosts:          files dns

networks:       files



protocols:      db files

services:       db files sss

ethers:         db files

rpc:            db files



netgroup:       nis sss

sudoers:        files sss

automount:      sss



and the output from the sssd_nss.log is:



    (Mon May  3 13:05:12 2021) [sssd[nss]] [cache_req_search_send]
(0x0400): CR #114: Object found, but needs to be refreshed.

    (Mon May  3 13:05:12 2021) [sssd[nss]] [cache_req_search_dp]
(0x0400): CR #114: Performing midpoint cache update of
[UID:1023001106@cyberloop.local]

    (Mon May  3 13:05:12 2021) [sssd[nss]] [sss_dp_issue_request]
(0x0400): Issuing request for
[0x559bd1d69e70:1:1023001106@cyberloop.local]

    (Mon May  3 13:05:12 2021) [sssd[nss]] [sss_dp_get_account_msg]
(0x0400): Creating request for
[cyberloop.local][0x1][BE_REQ_USER][idnumber=3D1023001106:-]

    (Mon May  3 13:05:12 2021) [sssd[nss]] [sbus_add_timeout]
(0x2000): 0x559bd20df680

    (Mon May  3 13:05:12 2021) [sssd[nss]] [sss_dp_internal_get_send]
(0x0400): Entering request
[0x559bd1d69e70:1:1023001106@cyberloop.local]

    (Mon May  3 13:05:12 2021) [sssd[nss]]
[cache_req_search_ncache_filter] (0x0400): CR #114: Filtering out
results by negative cache

    (Mon May  3 13:05:12 2021) [sssd[nss]] [sss_ncache_check_str]
(0x2000): Checking negative cache for
[NCE/USER/cyberloop.local/alice@cyberloop.local]

    (Mon May  3 13:05:12 2021) [sssd[nss]]
[cache_req_create_and_add_result] (0x0400): CR #114: Found 1 entries
in domain cyberloop.local

    (Mon May  3 13:05:12 2021) [sssd[nss]] [cache_req_done] (0x0400):
CR #114: Finished: Success

    (Mon May  3 13:05:12 2021) [sssd[nss]] [nss_protocol_done]
(0x4000): Sending reply: success

    (Mon May  3 13:05:12 2021) [sssd[nss]] [sbus_remove_timeout]
(0x2000): 0x559bd20df680

    (Mon May  3 13:05:12 2021) [sssd[nss]] [sbus_dispatch] (0x4000):
dbus conn: 0x559bd20d9230

    (Mon May  3 13:05:12 2021) [sssd[nss]] [sbus_dispatch] (0x4000):
Dispatching.

    (Mon May  3 13:05:12 2021) [sssd[nss]] [sss_dp_get_reply]
(0x1000): Got reply from Data Provider - DP error code: 0 errno: 0
error message: Success

    (Mon May  3 13:05:12 2021) [sssd[nss]] [cache_req_search_oob_done]
(0x2000): Out of band request finished

    (Mon May  3 13:05:12 2021) [sssd[nss]] [sss_dp_req_destructor]
(0x0400): Deleting request:
[0x559bd1d69e70:1:1023001106@cyberloop.local]

    (Mon May  3 13:05:42 2021) [sssd[nss]] [setup_client_idle_timer]
(0x4000): Idle timer re-set for client [0x559bd20f19a0][21]

    (Mon May  3 13:06:12 2021) [sssd[nss]] [setup_client_idle_timer]
(0x4000): Idle timer re-set for client [0x559bd20f19a0][21]

    (Mon May  3 13:06:42 2021) [sssd[nss]] [client_idle_handler]
(0x2000): Terminating idle client [0x559bd20f19a0][21]

    (Mon May  3 13:06:42 2021) [sssd[nss]]



So I don=E2=80=99t quite see how !pw is actually matched here=E2=80=A6



Calvin
