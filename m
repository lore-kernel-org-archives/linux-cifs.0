From: Austin Barton <abarton-kLQwt/ZTpnI@public.gmane.org>
Subject: Problem: mount.cifs has high CPU and "stalls" the using process
Date: Fri, 9 Jan 2015 12:07:20 -0700
Message-ID: <CA+63b8cMxUCse_CJ7rv29uZ0gwnThd6Y+GgQgHEXXrgUP_-Pdg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Darren Watts <dwatts-kLQwt/ZTpnI@public.gmane.org>, Michael Dillon <mdillon-kLQwt/ZTpnI@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hello,

I'm looking for some assistance with my mount.cifs issue.

A Windows share is mounted with cifs (rw). At some point a process
using the mount "stalls". Afterwards mount.cifs is consistently shown
as the highest item within top having %CPU at approximately 35. The
process (service) using the mount will not shutdown with init.d and
must be killed. Outside of the process I'm able to read, list, write
(w/content), and delete from the mount in question. Please note in the
"Display Internal CIFS Data Structures for Debugging" below only line
items 1 and 2 relate to the mount in question.

------------------------------
------------------------------------------------------------------------------------------------------------------

CentOS release 6.5 (Final)
kernal version: 2.6.32-431.11.2.el6.x86_64
mount.cifs version: 4.8.1


Display Internal CIFS Data Structures for Debugging
---------------------------------------------------
CIFS Version 1.68
Active VFS Requests: 1
Servers:
1) Name: 10.200.40.132  Domain: I3 Uses: 1 OS: Windows 7 Professional
7601 Service Pack 1
        NOS: Windows 7 Professional 6.1 Capability: 0x1e3fc
        SMB session status: 1   TCP status: 4
        Local Users To Server: 1 SecMode: 0x3 Req On Wire: 0
        Shares:
        1) \\host.domain\share Mounts: 1 Type: NTFS DevInfo: 0x20
Attributes: 0xc700ff
PathComponentMax: 255 Status: 0x1 type: DISK    DISCONNECTED

        MIDs:

2) Name: 10.200.40.132  Domain: I3 Uses: 1 OS: Windows 7 Professional
7601 Service Pack 1
        NOS: Windows 7 Professional 6.1 Capability: 0x1e3fc
        SMB session status: 1   TCP status: 3
        Local Users To Server: 1 SecMode: 0x3 Req On Wire: 0
        Shares:
        1) \\host.domain\share Mounts: 1 Type: NTFS DevInfo: 0x20
Attributes: 0xc700ff
PathComponentMax: 255 Status: 0x1 type: DISK    DISCONNECTED

        MIDs:


3) Name: 10.200.20.105  Domain: I3 Uses: 1 OS: SpinStream2
        NOS: Windows 2000 Lan Manager   Capability: 0xd2fc
        SMB session status: 1   TCP status: 1
        Local Users To Server: 1 SecMode: 0x3 Req On Wire: 0
        Shares:
        1) \\host2.domain\share Mounts: 1 Type: NTFS DevInfo: 0x20
Attributes: 0x4004f
PathComponentMax: 255 Status: 0x1 type: DISK

        MIDs:


When the stack is inspected it consistently reports the following:

[user@host ~]$ sudo cat /proc/10410/stack
[<ffffffffa01a5171>] wait_for_response+0xf1/0x130 [cifs]
[<ffffffffa01a5eb4>] SendReceive+0x154/0x350 [cifs]
[<ffffffffa018b13e>] CIFSGetDFSRefer+0x23e/0x670 [cifs]
[<ffffffffa0194ba5>] get_dfs_path+0x65/0x190 [cifs]
[<ffffffffa0194dbf>] expand_dfs_referral+0xef/0x2c0 [cifs]
[<ffffffffa0195314>] cifs_mount+0x384/0x690 [cifs]
[<ffffffffa018236f>] cifs_get_sb+0xaf/0x2a0 [cifs]
[<ffffffff8118b8cb>] vfs_kern_mount+0x7b/0x1b0
[<ffffffff8118ba72>] do_kern_mount+0x52/0x130
[<ffffffff811aca1b>] do_mount+0x2fb/0x930
[<ffffffff811ad0e0>] sys_mount+0x90/0xe0
[<ffffffff8100b072>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff



Thanks,
Austin
