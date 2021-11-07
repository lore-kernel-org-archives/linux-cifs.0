Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E68F3C433F5
	for <linux-cifs@archiver.kernel.org>; Sun,  7 Nov 2021 15:50:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3E7661355
	for <linux-cifs@archiver.kernel.org>; Sun,  7 Nov 2021 15:50:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234752AbhKGPwr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 7 Nov 2021 10:52:47 -0500
Received: from ciao.gmane.io ([116.202.254.214]:50344 "EHLO ciao.gmane.io"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234160AbhKGPwr (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sun, 7 Nov 2021 10:52:47 -0500
Received: from list by ciao.gmane.io with local (Exim 4.92)
        (envelope-from <glkc-linux-cifs@m.gmane-mx.org>)
        id 1mjkQj-000Ab5-P7
        for linux-cifs@vger.kernel.org; Sun, 07 Nov 2021 16:50:01 +0100
X-Injected-Via-Gmane: http://gmane.org/
To:     linux-cifs@vger.kernel.org
From:   Julian Sikorski <belegdol@gmail.com>
Subject: Permission denied when chainbuilding packages with mock
Date:   Sun, 7 Nov 2021 16:44:53 +0100
Message-ID: <sm8s9l$fk7$1@ciao.gmane.io>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Content-Language: en-US
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

