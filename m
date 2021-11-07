Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4946C433EF
	for <linux-cifs@archiver.kernel.org>; Sun,  7 Nov 2021 21:45:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADBCE61101
	for <linux-cifs@archiver.kernel.org>; Sun,  7 Nov 2021 21:45:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230424AbhKGVrm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 7 Nov 2021 16:47:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230338AbhKGVrm (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 7 Nov 2021 16:47:42 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5989C061570
        for <linux-cifs@vger.kernel.org>; Sun,  7 Nov 2021 13:44:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Cc:To:From:Date;
        bh=jV3CSKh9dkpvkw56mC1ph7oCWcu1w6JNRkEFUd8FSOI=; b=RPovfrfGNHQ7/zKD9mnMq49xFN
        APDF3rYyxwyCytXwu3CPlrBgl9Ah3zsR3LMjM6dBMDnQSu4bx3PybesRNVFPq9gl/PA3XaL1ps2SU
        xe3fbfsgBaQPjrXi2FCe5WldPgnoLF00iWm9NC62YTA2uxhcxnJGcgc8fM6fxjhC1DGkPGz7040do
        eD8hQxn9GLdoGLNDiAK5kxXVDLTxNsVU8DBsoxhcYNf05tj5ZK92FEIYMJectJQxApMLkDYdZSpi1
        1I12QUqi+WD7Qjt1KmgwbPwY/B4ZEOtlbH1Unn3TVrm4XAEJgb3uCtopZFlEqN5ScC129osFs0WCX
        BlxNq/+dUQCyjCYTN5oBA4fEJjsTm1u+qENYPEq569tfpM6aOyQDz19/ZcqbXn4DawQBkymOTyXTX
        rnRSWSTNusX0SUZwgfO6k1Oi0arI+XPaK7ex4m/yGqT4LqtbNS15aKhO8Gu4aHPZdASmcFAS9hTJZ
        wSzS1GH26xZDwnXVQ1CNZkZ1;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mjpyC-005g9o-59; Sun, 07 Nov 2021 21:44:56 +0000
Date:   Sun, 7 Nov 2021 13:44:53 -0800
From:   Jeremy Allison <jra@samba.org>
To:     Julian Sikorski <belegdol@gmail.com>
Cc:     linux-cifs@vger.kernel.org
Subject: Re: Permission denied when chainbuilding packages with mock
Message-ID: <YYhI1bpioEOXnFYf@jeremy-acer>
Reply-To: Jeremy Allison <jra@samba.org>
References: <24b60b8a-febb-cee9-d96b-d7b8469309a4@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <24b60b8a-febb-cee9-d96b-d7b8469309a4@gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Sun, Nov 07, 2021 at 10:10:17PM +0100, Julian Sikorski wrote:
>Hi,
>
>I have originally posted this to samba list but we were not able to 
>solve the issue:
>https://lists.samba.org/archive/samba/2021-September/237428.html
>
>In brief, I am getting seemingly random permission denied errors when 
>chainbuilding packages with mock and pointing the result dir to a 
>samba share:
>
>$ mock --chain --localrepo=/mnt/openmediavault/kernel -r 
>fedora-35-x86_64 goffice/goffice-0.10.50-2.fc35.src.rpm 
>gnumeric/gnumeric-1.12.50-2.fc36.src.rpm
>^^ this fails every time with: Error calculating checksum /mnt/openmediavault/kernel/results/fedora-35-x86_64/goffice-0.10.50-2.fc35/goffice-0.10.50-2.fc35.x86_64.rpm: 
>(39, fsync failed: Permission denied)
>
>$ mock --chain --localrepo=/mnt/openmediavault/kernel -r 
>fedora-35-x86_64 goffice/goffice-0.10.50-1.fc35.src.rpm 
>gnumeric/gnumeric-1.12.50-2.fc36.src.rpm
>^^ this works when starting with goffice and goffice-devel packages 
>removed from /mnt/openmediavault/kernel/results/fedora-35-x86_64/goffice-0.10.50-2.fc35. 
>If goffice or goffice-devel packages are present in the resultdir, an 
>error will appear:
>Error calculating checksum /mnt/openmediavault/kernel/results/fedora-35-x86_64/goffice-0.10.50-2.fc35/goffice-devel-0.10.50-2.fc35.x86_64.rpm: 
>(39, fsync failed: Permission denied)
>
>So, summing up:
>- same host
>- same target dir
>- same build target
>- effectively the same package [1]
>- different outcome
>
>The target dir is mounted on the samba server as:
>/dev/sda1 on /srv/dev-disk-by-label-omv type ext4 (rw,noexec,relatime,discard,stripe=8191,jqfmt=vfsv0,usrjquota=aquota.user,grpjquota=aquota.group)
>
>
>And on the client as:
>//odroidxu4.local/julian on /mnt/openmediavault type cifs (rw,relatime,vers=3.1.1,cache=strict,username=julas,uid=1000,noforceuid,gid=1000,noforcegid,addr=192.168.0.220,file_mode=0755,dir_mode=0755,soft,nounix,serverino,mapposix,nobrl,rsize=4194304,wsize=4194304,bsize=1048576,echo_interval=60,actimeo=1,_netdev)
>
>On the server one can see errors like:
>[2021/11/07 15:45:48.710865, 10, pid=4069, effective(1000, 100), 
>real(1000, 0), class=smb2] 
>../source3/smbd/smb2_flush.c:138(smbd_smb2_flush_send)
>  smbd_smb2_flush: kernel/results/fedora-35-x86_64/goffice-0.10.50-2.fc35/goffice-0.10.50-2.fc35.x86_64.rpm 
>- fnum 3429228891
>[2021/11/07 15:45:48.710935,  3, pid=4069, effective(1000, 100), 
>real(1000, 0), class=smb2] 
>../source3/smbd/smb2_server.c:3195(smbd_smb2_request_error_ex)
>  smbd_smb2_request_error_ex: smbd_smb2_request_error_ex: idx[1] 
>status[NT_STATUS_ACCESS_DENIED] || at ../source3/smbd/smb2_flush.c:82
>[2021/11/07 15:45:48.711013, 10, pid=4069, effective(1000, 100), 
>real(1000, 0), class=smb2] 
>../source3/smbd/smb2_server.c:3086(smbd_smb2_request_done_ex)
>  smbd_smb2_request_done_ex: idx[1] status[NT_STATUS_ACCESS_DENIED] 
>body[8] dyn[yes:1] at ../source3/smbd/smb2_server.c:3243
>
>but it is not really clear _why_ is the access being denied. Any ideas 
>where to look? Thanks!

What debug log level are you using on th server ? To debug
something like this use log level 10.

fsync failed: Permission denied

is strange. I need to see what access mask the fsp is being
opened with. If it's a directory, it might be running into
this (from smbd_smb2_flush_send()):

         if (!CHECK_WRITE(fsp)) {
                 bool allow_dir_flush = false;
                 uint32_t flush_access = FILE_ADD_FILE | FILE_ADD_SUBDIRECTORY;

                 if (!fsp->fsp_flags.is_directory) {
                         tevent_req_nterror(req, NT_STATUS_ACCESS_DENIED);
                         return tevent_req_post(req, ev);
                 }

                 /*
                  * Directories are not writable in the conventional
                  * sense, but if opened with *either*
                  * FILE_ADD_FILE or FILE_ADD_SUBDIRECTORY
                  * they can be flushed.
                  */

                 if ((fsp->access_mask & flush_access) != 0) {
                         allow_dir_flush = true;
                 }

                 if (allow_dir_flush == false) {
                         tevent_req_nterror(req, NT_STATUS_ACCESS_DENIED);
                         return tevent_req_post(req, ev);
                 }
         }

as 'man 2 fsync' on Linux doesn't show EACCES as a possible return
error from fsync.

If this is the case, then the client redirector is relying on Linux-specific
behavior. From 'man 2 fsync':

NOTES
        On some UNIX systems (but not Linux), fd must be a writable file descriptor.
