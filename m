Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4501EC433EF
	for <linux-cifs@archiver.kernel.org>; Sun,  7 Nov 2021 21:10:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D3EA61374
	for <linux-cifs@archiver.kernel.org>; Sun,  7 Nov 2021 21:10:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234057AbhKGVNE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 7 Nov 2021 16:13:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230092AbhKGVNE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 7 Nov 2021 16:13:04 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9D66C061570
        for <linux-cifs@vger.kernel.org>; Sun,  7 Nov 2021 13:10:20 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id d27so23441360wrb.6
        for <linux-cifs@vger.kernel.org>; Sun, 07 Nov 2021 13:10:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject
         :content-language:to:content-transfer-encoding;
        bh=iI0kBBvtlPABX3d49MIWITeswb6R1TN21aM3kshjzEs=;
        b=hm4zRozE9JseXmPT5/dQXLsQ8tRqEhkAKQ9MebgmtZZJdVjdUzbUsHgENMMrKw+9ej
         RWIDcWIsC/AHbdPAuJySv7x+WrKm09EfKKANBJKUJVGhLqe1frNWYvYyiZcgvGzzH8Pa
         O9MnValJpX3KwKlrehAGHnGMNBCvgMFFESd1YTzBYfS4c2ZiVEWLFQsJJ0Aytn66BwcH
         R1PofUhIKlD2ih39d1hJewEe33b4TEDKKDjGQifJoX3Oidk4U/l8+bVrOi516x3jZkdG
         fxKH8igYkN7RHgvL3INQ+/6DtEOBNhUsGTIhxVt2pRDciDS4Ylf6YDJyedpm1vUmAjbk
         /ooQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:content-language:to:content-transfer-encoding;
        bh=iI0kBBvtlPABX3d49MIWITeswb6R1TN21aM3kshjzEs=;
        b=topbAIn2gpS3jDWBJw4NKV+F1MLUZzE5//1dg8fgNqFT6U5uUQgLsxBvXs/lPzrblb
         ygnGbTpHy7Jn3hUQL/tathX2C4isU9LKLUJ6jfwRsTUv9zHsmt74WjW++jSxXUp4GHNw
         Mbcd/bTQBg6yYP+GD3LOf9BIy98bwr+mGMyx2oA0YxRNpZpaDacYZ3bdOHWnwvyYPXTs
         LmUl9pzNt1ukxH910yxQryuJg8MvLdYG/7BhSR2twXoFYLDGBNoJGn3c5V20XFhQSAk/
         Dx6O41M2jF4f0VGlvkvOUFKz9jxi5eWcmoTLerER73a6I0ubIuYk6+l3juoJPxAb0apK
         H+Rw==
X-Gm-Message-State: AOAM531DxdfC4LsCBuq3UkZhFDbTFbY5ebpumiiw5Kq6/Z0yqf3O0DRq
        j076tl3Sdci9RkD+wOpmjd7PnLse5fWFWw==
X-Google-Smtp-Source: ABdhPJz6TJAS37g+Crb8PKfceCWwj67qnsxBDNXXcoWsoj9tjZ9hYkVO+EXUCLONc3u091j1yP2zFg==
X-Received: by 2002:a5d:6d88:: with SMTP id l8mr57794265wrs.270.1636319418749;
        Sun, 07 Nov 2021 13:10:18 -0800 (PST)
Received: from ?IPV6:2a02:908:1980:7720::7039? ([2a02:908:1980:7720::7039])
        by smtp.gmail.com with ESMTPSA id v7sm14226607wrq.25.2021.11.07.13.10.17
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Nov 2021 13:10:18 -0800 (PST)
Message-ID: <24b60b8a-febb-cee9-d96b-d7b8469309a4@gmail.com>
Date:   Sun, 7 Nov 2021 22:10:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
From:   Julian Sikorski <belegdol@gmail.com>
Subject: Permission denied when chainbuilding packages with mock
Content-Language: en-US
To:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi,

I have originally posted this to samba list but we were not able to 
solve the issue:
https://lists.samba.org/archive/samba/2021-September/237428.html

In brief, I am getting seemingly random permission denied errors when 
chainbuilding packages with mock and pointing the result dir to a samba 
share:

$ mock --chain --localrepo=/mnt/openmediavault/kernel -r 
fedora-35-x86_64 goffice/goffice-0.10.50-2.fc35.src.rpm 
gnumeric/gnumeric-1.12.50-2.fc36.src.rpm
^^ this fails every time with: Error calculating checksum 
/mnt/openmediavault/kernel/results/fedora-35-x86_64/goffice-0.10.50-2.fc35/goffice-0.10.50-2.fc35.x86_64.rpm: 
(39, fsync failed: Permission denied)

$ mock --chain --localrepo=/mnt/openmediavault/kernel -r 
fedora-35-x86_64 goffice/goffice-0.10.50-1.fc35.src.rpm 
gnumeric/gnumeric-1.12.50-2.fc36.src.rpm
^^ this works when starting with goffice and goffice-devel packages 
removed from 
/mnt/openmediavault/kernel/results/fedora-35-x86_64/goffice-0.10.50-2.fc35. 
If goffice or goffice-devel packages are present in the resultdir, an 
error will appear:
Error calculating checksum 
/mnt/openmediavault/kernel/results/fedora-35-x86_64/goffice-0.10.50-2.fc35/goffice-devel-0.10.50-2.fc35.x86_64.rpm: 
(39, fsync failed: Permission denied)

So, summing up:
- same host
- same target dir
- same build target
- effectively the same package [1]
- different outcome

The target dir is mounted on the samba server as:
/dev/sda1 on /srv/dev-disk-by-label-omv type ext4 
(rw,noexec,relatime,discard,stripe=8191,jqfmt=vfsv0,usrjquota=aquota.user,grpjquota=aquota.group) 


And on the client as:
//odroidxu4.local/julian on /mnt/openmediavault type cifs 
(rw,relatime,vers=3.1.1,cache=strict,username=julas,uid=1000,noforceuid,gid=1000,noforcegid,addr=192.168.0.220,file_mode=0755,dir_mode=0755,soft,nounix,serverino,mapposix,nobrl,rsize=4194304,wsize=4194304,bsize=1048576,echo_interval=60,actimeo=1,_netdev)

On the server one can see errors like:
[2021/11/07 15:45:48.710865, 10, pid=4069, effective(1000, 100), 
real(1000, 0), class=smb2] 
../source3/smbd/smb2_flush.c:138(smbd_smb2_flush_send)
   smbd_smb2_flush: 
kernel/results/fedora-35-x86_64/goffice-0.10.50-2.fc35/goffice-0.10.50-2.fc35.x86_64.rpm 
- fnum 3429228891
[2021/11/07 15:45:48.710935,  3, pid=4069, effective(1000, 100), 
real(1000, 0), class=smb2] 
../source3/smbd/smb2_server.c:3195(smbd_smb2_request_error_ex)
   smbd_smb2_request_error_ex: smbd_smb2_request_error_ex: idx[1] 
status[NT_STATUS_ACCESS_DENIED] || at ../source3/smbd/smb2_flush.c:82
[2021/11/07 15:45:48.711013, 10, pid=4069, effective(1000, 100), 
real(1000, 0), class=smb2] 
../source3/smbd/smb2_server.c:3086(smbd_smb2_request_done_ex)
   smbd_smb2_request_done_ex: idx[1] status[NT_STATUS_ACCESS_DENIED] 
body[8] dyn[yes:1] at ../source3/smbd/smb2_server.c:3243

but it is not really clear _why_ is the access being denied. Any ideas 
where to look? Thanks!

Best regards,
Julian
