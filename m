Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB989C433F5
	for <linux-cifs@archiver.kernel.org>; Fri, 22 Apr 2022 15:06:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449275AbiDVPIz (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 22 Apr 2022 11:08:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1449237AbiDVPIg (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 22 Apr 2022 11:08:36 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A19FB5D646
        for <linux-cifs@vger.kernel.org>; Fri, 22 Apr 2022 08:05:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Date:To:From:CC;
        bh=feLElNr4VPY22ppfptutl465j+qyW1Vci3ChQd4xAjs=; b=VRxwA0bWqlwdmkmOF4r+88Thxx
        UeLciV99Jap6URbmlKxjLBOS1Cr6XLqsG8abCA/mmWt5A7E2ULdTFUgLa4aejwsYgyf8ah1L+xkcY
        p22r4zeyCSUORLp1EPGvQrjmVDoK1GyAI6hKNRY622wtwEL3aJm4zPbBPHns21QTBkaMSTkjLZGm8
        FvMbP7wftG0frRzspeSkUIq0n0d0L+oUzYEy1V0pIAHkT/UyltmtXRatpGFAVT579N+0n2VMwV0YB
        FNH0giYPvh+mtjNlaQcwbEy3RfHV5NIgZf7HUeaAF1B0Qc7F26y4iihBFNh+USHCPIpMFOVCOD6lE
        NRLQ22FI9bjF6ZM0C07HJECTkqLg1OYq3hmv2vnjZHdSAalBP+WbY91lT+eHjgyROGthmWXcfLRN1
        F9QA7Yo9xsPb2p4Z3Iq6g4vnDqrGxI50tJBUk3c2zXJcg58TNKz8ttGREiTjB2ZK7MS+UCohXquDD
        o/UhfKP9rnnKeZOeBF8oKOOq;
Received: from [2a01:4f8:192:486::6:0] (port=41534 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1nhuqg-001pjX-IO
        for cifs-qa@samba.org; Fri, 22 Apr 2022 15:05:30 +0000
Received: from www-data by hr6.samba.org with local (Exim 4.93)
        (envelope-from <www-data@samba.org>)
        id 1nhuqf-0015yl-Ju
        for cifs-qa@samba.org; Fri, 22 Apr 2022 15:05:29 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 15051] New: EBADF/EIO errors in rename/open caused by race
 condition in smb2_compound_op
Date:   Fri, 22 Apr 2022 15:05:29 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 5.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: ohubsch@purestorage.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 qa_contact target_milestone
Message-ID: <bug-15051-10630@https.bugzilla.samba.org/>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D15051

            Bug ID: 15051
           Summary: EBADF/EIO errors in rename/open caused by race
                    condition in smb2_compound_op
           Product: CifsVFS
           Version: 5.x
          Hardware: x64
                OS: Linux
            Status: NEW
          Severity: normal
          Priority: P5
         Component: kernel fs
          Assignee: sfrench@samba.org
          Reporter: ohubsch@purestorage.com
        QA Contact: cifs-qa@samba.org
  Target Milestone: ---

There are two different scenarios where we encountered the EBADF/EIO errors=
:=20

- Write test, where there are multiple threads writing to a file with "_tem=
p"
suffix and after the write completes a rename happens that removes the "_te=
mp"
suffix. Each process/thread writes to a unique file, there are no overlaps.
Read test, where multiple threads attempt to choose a random file out of a
certain set and read it =E2=80=93 so here it can happen that multiple threa=
ds access
the same file at the same time. The error happens most often when the set of
files is small; for example, repeated reads of 5 different 20M files by 128
threads triggered this for us.
- Read test, where multiple threads attempt to choose a random file out of a
certain set and read it =E2=80=93 so here it can happen that multiple threa=
ds access
the same file at the same time. The error happens most often when the set of
files is small; for example, repeated reads of 5 different 20M files by 128
threads triggered this for us.

We believe the root cause for both of them is the same: there seems to be a
race condition in smb2_compound_op:

---
after_close:
        num_rqst++;

        if (cfile) {
                cifsFileInfo_put(cfile); // sends SMB2_CLOSE to the server
                cfile =3D NULL;
---

This code is triggered by smb2_query_path_info operation that happens during
revalidate_dentry. In smb2_query_path_info, get_readable_path is called to =
load
the cfile, increasing the reference counter. If in the meantime, this refer=
ence
becomes the very last, this call to cifsFileInfo_put(cfile) will trigger a
SMB2_CLOSE request sent to the server just before sending this compound req=
uest
=E2=80=93 and so then the compound request fails either with EBADF/EIO depe=
nding on the
timing at the server, because the handle is already closed.


In the first scenario, the race seems to be happening between
smb2_query_path_info triggered by the rename operation, and between =E2=80=
=9Ccleanup=E2=80=9D
of asynchronous writes =E2=80=93 while fsync(fd) likely waits for the async=
hronous
writes to complete, releasing the writeback structures can happen after the
close(fd) call. So the EBADF/EIO errors will pop up if the timing is such t=
hat:
1) There are still outstanding references after close(fd) in the writeback
structures
2) smb2_query_path_info successfully fetches the cfile, increasing the
refcounter by 1
3) All writeback structures release the same cfile, reducing refcounter to 1
4) smb2_compound_op is called with that cfile

In the second scenario, the race seems to be similar =E2=80=93 here open tr=
iggers the
smb2_query_path_info operation, and if all other threads in the meantime
decrease the refcounter to 1 similarly to the first scenario, again SMB2_CL=
OSE
will be sent to the server just before issuing the compound request. This c=
ase
is harder to reproduce across different machines and the timing is more tri=
cky,
so we attach a pseudocode for that case.

Proposed patch:

It seems to us that it should be sufficient and harmless to just remove the=
 two
lines:

cifsFileInfo_put(cfile);
cfile =3D NULL;

The cleanup happens anyways just below the call to compound_send_recv under=
 the
finished: label. Unless something in compound_send_recv can interfere with =
this
cleanup, it should be safe to remove them. In our testing we didn't encount=
er
any issues after removing them.

Observed stack traces by manual insertion of dump_stack to
_cifsFileInfo_put/smb2_compound_op:
rite test, from _cifsFileInfo_put after hitting last reference:

[Tue Apr 19 05:38:30 2022] Call Trace:
[Tue Apr 19 05:38:30 2022]  dump_stack_lvl+0x33/0x42
[Tue Apr 19 05:38:30 2022]  _cifsFileInfo_put+0x124/0x3b1 [cifs]
[Tue Apr 19 05:38:30 2022]  ? smb2_plain_req_init+0x43/0x45 [cifs]
[Tue Apr 19 05:38:30 2022]  ? SMB2_query_info_init+0x5c/0xf5 [cifs]
[Tue Apr 19 05:38:30 2022]  cifsFileInfo_put+0x14/0x15 [cifs]
[Tue Apr 19 05:38:30 2022]  smb2_compound_op+0xd78/0xfc0 [cifs]
[Tue Apr 19 05:38:30 2022]  smb2_query_path_info+0x14e/0x238 [cifs]
[Tue Apr 19 05:38:30 2022]  cifs_get_inode_info+0x1f5/0x6fb [cifs]
[Tue Apr 19 05:38:30 2022]  cifs_revalidate_dentry_attr+0x249/0x2e7 [cifs]
[Tue Apr 19 05:38:30 2022]  cifs_revalidate_dentry+0x1a/0x2b [cifs]
[Tue Apr 19 05:38:30 2022]  cifs_d_revalidate+0x6b/0x15c [cifs]
[Tue Apr 19 05:38:30 2022]  lookup_dcache+0x3b/0x60
[Tue Apr 19 05:38:30 2022]  __lookup_hash+0x1f/0xa0
[Tue Apr 19 05:38:30 2022]  ? down_write+0xe/0x40
[Tue Apr 19 05:38:30 2022]  do_renameat2+0x279/0x510
[Tue Apr 19 05:38:30 2022]  ? strncpy_from_user+0x41/0x1a0
[Tue Apr 19 05:38:30 2022]  __x64_sys_rename+0x3c/0x50
[Tue Apr 19 05:38:30 2022]  do_syscall_64+0x3a/0x80
[Tue Apr 19 05:38:30 2022]  entry_SYSCALL_64_after_hwframe+0x44/0xae


Read test, from smb2_compound_op after hitting rc =3D -9:

Call Trace:
[Wed Apr 20 02:31:10 2022]  dump_stack_lvl+0x33/0x42
[Wed Apr 20 02:31:10 2022]  smb2_compound_op+0x902/0x103b [cifs]
[Wed Apr 20 02:31:10 2022]  ? build_path_from_dentry_optional_prefix+0xa0/0=
x298
[cifs]
[Wed Apr 20 02:31:10 2022]  ? cifsFileInfo_get+0x29/0x2f [cifs]
[Wed Apr 20 02:31:10 2022]  ? ___ratelimit+0x6f/0xd0
[Wed Apr 20 02:31:10 2022]  smb2_query_path_info+0x14c/0x248 [cifs]
[Wed Apr 20 02:31:10 2022]  cifs_get_inode_info+0x1f5/0x6fb [cifs]
[Wed Apr 20 02:31:10 2022]  cifs_revalidate_dentry_attr+0x249/0x2e7 [cifs]
[Wed Apr 20 02:31:10 2022]  cifs_revalidate_dentry+0x1a/0x2b [cifs]
[Wed Apr 20 02:31:10 2022]  cifs_d_revalidate+0x6b/0x15c [cifs]
[Wed Apr 20 02:31:10 2022]  lookup_fast+0xcd/0x150
[Wed Apr 20 02:31:10 2022]  path_openat+0x114/0x1050
[Wed Apr 20 02:31:10 2022]  ? cifsFileInfo_put_final+0xc0/0xc9 [cifs]
[Wed Apr 20 02:31:10 2022]  ? _cifsFileInfo_put+0x391/0x39b [cifs]
[Wed Apr 20 02:31:10 2022]  do_filp_open+0xb4/0x120
[Wed Apr 20 02:31:10 2022]  ? __check_object_size+0x15f/0x170
[Wed Apr 20 02:31:10 2022]  do_sys_openat2+0x242/0x300
[Wed Apr 20 02:31:10 2022]  do_sys_open+0x4b/0x80
[Wed Apr 20 02:31:10 2022]  do_syscall_64+0x3a/0x80
[Wed Apr 20 02:31:10 2022]  entry_SYSCALL_64_after_hwframe+0x44/0xae


Write-case small repro:
#include <iostream>
#include <thread>
#include <vector>
#include <string>
#include <unistd.h>
#include <fcntl.h>

std::string path1 =3D "/mnt/mountpoint/dir";
const int FILES_PER_WORKER =3D 1000;
const int BUF_SIZE =3D 1048576 * 20;
const int BUF_NUMBER_OF_WRITES =3D 1;
const int WORKERS =3D 4;

int main() {
        std::vector<std::thread> ts;
        for (int workerNum =3D 0; workerNum < WORKERS; workerNum++) {
                ts.emplace_back([workerNum](){
                        std::unique_ptr<char[]> buf(new char[BUF_SIZE]);
                        for (int i =3D 0; i < BUF_SIZE; i++)
                                buf[i] =3D 'A';
                        for (int i =3D 0; i < FILES_PER_WORKER; i++) {
                                std::string finalPath =3D path1 +
std::to_string(FILES_PER_WORKER * workerNum + i);
                                std::string tempPath =3D finalPath + "_temp=
";
                                int fd =3D open(tempPath.c_str(), O_RDWR |
O_CREAT | O_TRUNC);
                                if (fd < 0) {
                                        std::cerr << "Open failed!" <<
std::endl;
                                        return;
                                }

                                for (int j =3D 0; j < BUF_NUMBER_OF_WRITES;=
 j++)
{
                                        int res =3D write(fd, buf.get(),
BUF_SIZE);
                                        if (res !=3D BUF_SIZE) {
                                                std::cerr << "Write error!"=
 <<
std::endl;
                                                return;
                                        }
                                }
                                int res =3D fsync(fd);
                                if (res !=3D 0) {
                                        std::cerr << "Fsync error!" <<
std::endl;
                                        return;
                                }
                                res =3D close(fd);
                                if (res !=3D 0) {
                                        std::cerr << "Close error!" <<
std::endl;
                                        return;
                                }
                                res =3D rename(tempPath.c_str(),
finalPath.c_str());
                                if (res !=3D 0) {
                                        std::cerr << "Rename error! (" << e=
rrno
<< ")" << std::endl;
                                        return;
                                }
                        }

                });
        }
        for(auto& t : ts)
                t.join();

        return 0;
}



For the read test, the following happens on each thread instead (on the fil=
es
created by the write test).

for (int j =3D 0; j < TOTAL_READS; j++)
{
    usleep(random time);
    string path =3D basePath + to_string(random number from 0 to 4 inclusiv=
e);
    int fd =3D open(path, O_RDONLY);
    read(fd, buf, 20M);
    close(fd);
}

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
