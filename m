Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71D44C433F5
	for <linux-cifs@archiver.kernel.org>; Fri, 30 Sep 2022 03:15:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbiI3DPT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 29 Sep 2022 23:15:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbiI3DPR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 29 Sep 2022 23:15:17 -0400
Received: from mail-ua1-x929.google.com (mail-ua1-x929.google.com [IPv6:2607:f8b0:4864:20::929])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 712E645060
        for <linux-cifs@vger.kernel.org>; Thu, 29 Sep 2022 20:15:15 -0700 (PDT)
Received: by mail-ua1-x929.google.com with SMTP id a14so1245159uat.13
        for <linux-cifs@vger.kernel.org>; Thu, 29 Sep 2022 20:15:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date;
        bh=vXRC8BR0J3sIbnpbzyB8Kf3sG1BMq8/DgFEdbA0KeTU=;
        b=Y2FCFpS82cQVwsaHeNNSWa7Ok0cIvHQEuFWa/lZo58F3MvjnfsCx31L2Y6qZpeDpsG
         Mfz3ngCGORh3Ds6g1mjzGctQsoZIprH7EA1xI82PVD14cyLq6m9hEguGMuN/M1T7RmQl
         Le8PAqYdSTw6QXl0dclwnarg0GHoNCRpuV07mcixu7GHAn7eiDleqkV7bjrb2rEWKj7k
         QdhoM1wNRx2rikfe7xeiYWn7Kv+CLhnx6aid1ltZ3bkeXv80F6NqwgCLHx2j3KcL9Zag
         NNdVmkPLqLPjgz6/6vT+DeGBNgyjeI08nVL+yH88/xvmkRW4bVHzw/QuKKpc8ihv5H4f
         G8ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date;
        bh=vXRC8BR0J3sIbnpbzyB8Kf3sG1BMq8/DgFEdbA0KeTU=;
        b=mOqMLIxKh5uSe0uUNO09mkweyTPPj6iQ9jwup9luZ1Ucp/l3FFx0nQMyQeSQT5v87V
         nNQYePv18Uulsz0qxsMnsLMRmz0xbrRIcenE5qzVLnIYTthlnH8lYpkm4mazQfciOJiQ
         BFDRcdhsiNxgHfH2ThDq+stwlkZzUeXINBS4Lwc7MMJ7ICzZMJ57avwtvXq4OBANygdd
         M9B8pQS3Lh8Pz9I/hg8AZCDZ23f1WY11AByi/OAjHLePnGHk2+khH2J/xC/AkD0q4JN5
         pqPwem1LiEIEkofcB9WbiCBomn6StWgmXNggpy+CEZGiO2mReJjkEBDEwGkdR2Uq9l0r
         3yFw==
X-Gm-Message-State: ACrzQf0YXgTcfNGKT+SbbXXjQQ1KvDtFVXO+yvJsovc/q4IDYfnlWd2C
        n5fu9EPoePvurIT/TGzXiyGI+WRJ9NTCSQ0aeLByLJkb
X-Google-Smtp-Source: AMsMyM6oQUff1lAMqKycPmVj/XARETAtopXP5v0HtLdGgTJfWZZjp8akviDAWTHNshUFkyVD57mq/eceG8TsxWLeiyg=
X-Received: by 2002:a9f:2c41:0:b0:3ba:d8ea:77e0 with SMTP id
 s1-20020a9f2c41000000b003bad8ea77e0mr3472298uaj.96.1664507714263; Thu, 29 Sep
 2022 20:15:14 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 29 Sep 2022 22:15:03 -0500
Message-ID: <CAH2r5mvXmjiY25wcUYM=8-MbJjaO3=_dziNwc6i1n4qW00N0kw@mail.gmail.com>
Subject: Kerberos mount testing and buildbot
To:     CIFS <linux-cifs@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I noticed  we should be running more tests to kerberos mounts e.g.
cifs-utils/102.

Did I miss any?  Any thoughts about running this as part of the main
cifs-testing group as well?  Adding more kerberos tests?

We also need to create a test group for very current Samba (and also
ksmbd) running with posix mount option to make sure we don't have any
bugs show up as they continue to finish up the server side of this
support.

-- 
Thanks,

Steve
