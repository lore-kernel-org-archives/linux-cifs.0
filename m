Return-Path: <SRS0=O53D=RY=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E82EC43381
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Mar 2019 00:14:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4234F218C3
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Mar 2019 00:14:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727507AbfCUAOv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 20 Mar 2019 20:14:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58473 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727464AbfCUAOu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 20 Mar 2019 20:14:50 -0400
Received: from mail-ot1-f72.google.com ([209.85.210.72])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <andreas.hasenack@canonical.com>)
        id 1h6lM8-0006fW-LR
        for linux-cifs@vger.kernel.org; Thu, 21 Mar 2019 00:14:48 +0000
Received: by mail-ot1-f72.google.com with SMTP id i5so2162374otl.12
        for <linux-cifs@vger.kernel.org>; Wed, 20 Mar 2019 17:14:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QQTGPhoD3BgJv51QNb2XU140vHoqfIEtIKVJOFyQf/k=;
        b=HiI7RrVZ37RjK96Dn47hOs9kVxa3QxrkvDe41lbrP9CjB6NEI0Eap+ExYAaLFxaNU9
         U3jCM13+ypWFNunPvGNCEk1a6QmVDcflGSo8/eFvHKA7dQHlKwaMGP8eUfH1zdx2lqZF
         XIbScvgyZVmJZcBnpLZx4DEqe9zUSl/d7e8WRMpbLfKFcw30TOpclqdwhIEtAbT9iMEP
         QvQkUfwujIB7WNXgPG+jw4/kd86WxLuJ+VmA2F+WrIbV/3wrJ5pIL7f2fQpsyY2iQ8er
         iM9U+5WKCQtdm420UffKJYRdzE0bbS/X+H+XJt4ShrHZPO8blX7LI2HoCzRhl+r8vCac
         y7rQ==
X-Gm-Message-State: APjAAAVDX+nBbA4+8sjgtj+DP/jqox37h09X8vr6aCOJB/0EM3TNoEVD
        woda8fivMmlXXZSW7Of48LRTGmSmFCLYBaqYCnIyhT95sQjFNcpWvzJgdJ3rNB36NE/aVt7bGAw
        qY654EN1X8E0HRlAlkFGLv2j0824uq9I5vXqQQL0zu2g56IbgOdGCfq8=
X-Received: by 2002:a9d:4ee:: with SMTP id 101mr597228otm.197.1553127287502;
        Wed, 20 Mar 2019 17:14:47 -0700 (PDT)
X-Google-Smtp-Source: APXvYqy8C+2zzmllfMpK+tY++jtuYRx6NsDDefBEj9B02im0zJOMnawU12sG9gXIgEh068GVDWNXE21XkQMNSzauAU4=
X-Received: by 2002:a9d:4ee:: with SMTP id 101mr597211otm.197.1553127287254;
 Wed, 20 Mar 2019 17:14:47 -0700 (PDT)
MIME-Version: 1.0
References: <CANYNYEFJos5tzAyN7kdHKaAVeV_cD8QF8=wAs4XXhu9PXWgE3A@mail.gmail.com>
 <87ftrh8bbn.fsf@paulo.ac>
In-Reply-To: <87ftrh8bbn.fsf@paulo.ac>
From:   Andreas Hasenack <andreas@canonical.com>
Date:   Wed, 20 Mar 2019 21:14:36 -0300
Message-ID: <CANYNYEEvpJQLLanQmObL=--k=-mjMM3356dNELEmhnu0Mc+ZGg@mail.gmail.com>
Subject: Re: "Bad SMB2 signature for message" with kernel 5.0.0, works with 4.19.0
To:     Paulo Alcantara <paulo@paulo.ac>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Paulo,

On Wed, Mar 20, 2019 at 6:50 PM Paulo Alcantara <paulo@paulo.ac> wrote:
> Looks like a signing issue when using guest auth in SMB3.11. Could you
> please try mounting it with vers=1.0, vers=2.1 and vers=3.0 and see if
> it works?

vers=1.0 works:
root@ubuntu:~# mount //localhost/pub /mnt -o guest,vers=1.0
root@ubuntu:~# mount -t cifs
//localhost/pub on /mnt type cifs
(rw,relatime,vers=1.0,sec=none,cache=strict,uid=0,noforceuid,gid=0,noforcegid,addr=127.0.0.1,soft,unix,posixpaths,serverino,mapposix,acl,rsize=1048576,wsize=65536,echo_interval=60,actimeo=1)
dmesg: http://paste.ubuntu.com/p/qQz3kBkpzM/

vers=2.1 also works:
root@ubuntu:~# mount //localhost/pub /mnt -o guest,vers=2.1
root@ubuntu:~# mount -t cifs
//localhost/pub on /mnt type cifs
(rw,relatime,vers=2.1,sec=none,cache=strict,uid=0,noforceuid,gid=0,noforcegid,addr=127.0.0.1,file_mode=0755,dir_mode=0755,soft,nounix,serverino,mapposix,rsize=1048576,wsize=1048576,echo_interval=60,actimeo=1)
dmesg: http://paste.ubuntu.com/p/rWSsndKjPN/

vers=3.0 works:
root@ubuntu:~# mount //localhost/pub /mnt -o guest,vers=3.0
root@ubuntu:~# mount -t cifs
//localhost/pub on /mnt type cifs
(rw,relatime,vers=3.0,sec=none,cache=strict,uid=0,noforceuid,gid=0,noforcegid,addr=127.0.0.1,file_mode=0755,dir_mode=0755,soft,nounix,serverino,mapposix,rsize=4194304,wsize=4194304,echo_interval=60,actimeo=1)
dmesg: http://paste.ubuntu.com/p/rVKhYqmTTc/

and just to be complete, vers=3.11 fails:
root@ubuntu:~# mount //localhost/pub /mnt -o guest,vers=3.11
mount error(13): Permission denied
Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)
dmesg: http://paste.ubuntu.com/p/sprkDFY5XH/
