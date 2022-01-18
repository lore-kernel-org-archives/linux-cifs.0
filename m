Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2E5EC433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 18 Jan 2022 17:24:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347288AbiARRYp convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 18 Jan 2022 12:24:45 -0500
Received: from mail.astralinux.ru ([217.74.38.119]:33080 "EHLO
        mail.astralinux.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347283AbiARRYo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 18 Jan 2022 12:24:44 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.astralinux.ru (Postfix) with ESMTP id F0880306860F;
        Tue, 18 Jan 2022 20:24:42 +0300 (MSK)
Received: from mail.astralinux.ru ([127.0.0.1])
        by localhost (rbta-msk-vsrv-mail01.astralinux.ru [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id 7w5laBlctcBO; Tue, 18 Jan 2022 20:24:42 +0300 (MSK)
Received: from localhost (localhost [127.0.0.1])
        by mail.astralinux.ru (Postfix) with ESMTP id 1AB303068611;
        Tue, 18 Jan 2022 20:24:42 +0300 (MSK)
X-Virus-Scanned: amavisd-new at astralinux.ru
Received: from mail.astralinux.ru ([127.0.0.1])
        by localhost (rbta-msk-vsrv-mail01.astralinux.ru [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 9s-lfl6eD-0w; Tue, 18 Jan 2022 20:24:42 +0300 (MSK)
Received: from debian-BULLSEYE-live-builder-AMD64 (unknown [46.148.196.130])
        by mail.astralinux.ru (Postfix) with ESMTPSA id DD0E2306860D;
        Tue, 18 Jan 2022 20:24:41 +0300 (MSK)
Date:   Tue, 18 Jan 2022 20:24:40 +0300
From:   Eugene Korenevsky <ekorenevsky@astralinux.ru>
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     linux-cifs@vger.kernel.org
Subject: Re: [PATCH v2 2/2] cifs: quirk for STATUS_OBJECT_NAME_INVALID
 returned for non-ASCII dfs refs
Message-ID: <Yeb32NlvfHzi7TxD@debian-BULLSEYE-live-builder-AMD64>
References: <YeHUxJ9zTVNrKveF@himera.home>
 <20220117211305.ambdxok747u6kwlm@cyberdelia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220117211305.ambdxok747u6kwlm@cyberdelia>
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Jan 17, 2022 at 06:14:05PM -0300, Enzo Matsumiya wrote:

> The patch fixes the initial issue (mount and listing files) as per
> reported in the mentioned bugzilla, but it still fails to create files:
> 
> % echo "test" | sudo tee myfile
> tee: myfile: No such file or directory
> test


Sorry, cannot reproduce.

```
# mount
...
//192.168.57.14/дфс on /tmp/x type cifs (rw,relatime,vers=default,cache=strict,username=user,domain=WIN-TCIN4O86A6M,uid=0,noforceuid,gid=0,noforcegid,addr=192.168.57.14,file_mode=0755,dir_mode=0755,soft,nounix,mapposix,rsize=4194304,wsize=4194304,bsize=1048576,echo_interval=60,actimeo=1)
//WIN-TCIN4O86A6M/дфс/temp on /tmp/x/temp type cifs (rw,relatime,vers=3.1.1,cache=strict,username=user,domain=WIN-TCIN4O86A6M,uid=0,noforceuid,gid=0,noforcegid,addr=192.168.57.4,file_mode=0755,dir_mode=0755,soft,nounix,mapposix,rsize=4194304,wsize=4194304,bsize=1048576,echo_interval=60,actimeo=1)
# pwd
/tmp/x/temp
# echo test | tee myfile
test
# rm myfile
# echo test | tee myfile
test
# cat myfile
test
# rm myfile && echo ok
ok
```

Could you provide your 'mount' output as well?


--
Eugene
