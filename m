From: Marti Raudsepp <marti@juffo.org>
Subject: CIFS on 3.5.0 causes hung tasks; Unexpected lookup error -19
Date: Thu, 16 Aug 2012 16:56:15 +0300
Message-ID: <CABRT9RD9+NCdFXSv1pc12YsCmyheBxmMkXX+Jvck_n+gzq1zbA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Kernel hackers <linux-kernel@vger.kernel.org>,
	CIFS hackers <linux-cifs@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Hi list,

I have a few mount points to Microsoft Windows 2000 SP4 and a simple
process that repeatedly opens files by name, reads the first 256 bytes
and then closes it.

Yesterday I was testing some unrelated applications in face of network
problems and I used tc/netem/mirred/ifb to cause 50% packet loss on
the receiving side. Shortly after setting it up, CIFS started
reporting various errors from the mount point, though I was not aware
of that.

Today, I was updating my system using pacman and it hung because it
does statvfs on every file system to find the amount of free space.
Any file system access to /mnt/direc01 now freezes the process. Even
sending a SIGKILL does not make it a defunct/zombie process.

Surprisingly, another CIFS mount point (which I have unmounted by now)
was not affected and was still functioning.

I'm using Arch Linux x86_64, Linux 3.5.0, cifs-utils 5.6. There are
two CIFS mounts on the same mount point due to operator accident. They
were manually mounted using mount.cifs.

Mount info:
# mount |grep cifs
//192.168.xx.xx/e$/recorder.0020 on /mnt/direc01 type cifs
(ro,relatime,vers=1.0,sec=ntlm,cache=loose,unc=\\192.168.xx.xx\e$,username=xxxxxxxx,uid=0,noforceuid,gid=0,noforcegid,addr=192.168.xx.xx,file_mode=0755,dir_mode=0755,nounix,serverino,rsize=61440,wsize=65536,actimeo=1)
//192.168.xx.xx/e$/recorder.0020 on /mnt/direc01 type cifs
(ro,relatime,vers=1.0,sec=ntlm,cache=strict,unc=\\192.168.xx.xx\e$,username=xxxxxxxx,uid=0,noforceuid,gid=0,noforcegid,addr=192.168.xx.xx,file_mode=0755,dir_mode=0755,nounix,rsize=61440,wsize=65536,actimeo=1)
# umount -f /mnt/direc01
umount: /mnt/direc01: target is busy.

Info about the hung task:
# cat /proc/28959/wchan
cifs_reconnect_tcon
# cat /proc/28959/status
Name:	pacman
State:	D (disk sleep)
Tgid:	28959
Pid:	28959
PPid:	28958
TracerPid:	29611
Uid:	0	0	0	0
Gid:	0	0	0	0
FDSize:	64
Groups:	0 1 2 3 4 6 10 19
VmPeak:	  187888 kB
VmSize:	  157188 kB
VmLck:	       0 kB
VmPin:	       0 kB
VmHWM:	   32088 kB
VmRSS:	   30392 kB
VmData:	  102648 kB
VmStk:	     136 kB
VmExe:	      96 kB
VmLib:	    6376 kB
VmPTE:	     196 kB
VmSwap:	      40 kB
Threads:	1
SigQ:	7/30088
SigPnd:	0000000000040100
ShdPnd:	0000000000000100
SigBlk:	0000000000000000
SigIgn:	0000000000001000
SigCgt:	0000000180004403
CapInh:	0000000000000000
CapPrm:	ffffffffffffffff
CapEff:	ffffffffffffffff
CapBnd:	ffffffffffffffff
Cpus_allowed:	3f
Cpus_allowed_list:	0-5
Mems_allowed:	00000000,00000001
Mems_allowed_list:	0
voluntary_ctxt_switches:	68890
nonvoluntary_ctxt_switches:	1601


This is how I set up my netem (eth1 is the actual network interface):

modprobe ifb
modprobe act_mirred
ip link set dev ifb0 up
tc qdisc add dev eth1 ingress
tc filter add dev eth1 parent ffff: protocol ip u32 match u32 0 0
flowid 1:1 action mirred egress redirect dev ifb0
tc qdisc add dev ifb0 root netem loss 50%

Relevant dmesg:
[1407727.963832] Mirror/redirect action on
[1407745.870295] netem: version 1.3
[1407830.398552] u32 classifier
[1407830.398555]     input device check on
[1407830.398556]     Actions configured
[1407908.403807] CIFS VFS: Send error in read = -11
[1407974.046542] CIFS VFS: Send error in read = -11
[1408088.564354] CIFS VFS: Send error in read = -11
[1408217.057189] CIFS VFS: Send error in read = -11
[1408249.777488] CIFS VFS: Server 192.168.xx.xx has not responded in
120 seconds. Reconnecting...
[1408348.797783] CIFS VFS: Send error in read = -11
[1408508.941496] CIFS VFS: Send error in read = -11
[1408633.414822] CIFS VFS: Send error in read = -11
[1408730.842848] CIFS VFS: Send error in read = -11
[1408869.264888] CIFS VFS: Send error in read = -11
[1408965.201995] CIFS VFS: Send error in read = -11
[1409117.178193] CIFS VFS: Server 192.168.xx.xx has not responded in
120 seconds. Reconnecting...
[1409117.178240] CIFS VFS: Send error in read = -11
[1409296.989095] CIFS VFS: Send error in read = -11
[1409424.869743] CIFS VFS: Send error in read = -11
[1409600.976700] CIFS VFS: Server 192.168.xx.xx has not responded in
120 seconds. Reconnecting...
[1409600.976739] CIFS VFS: Send error in read = -11
[1483702.836664] INFO: task pacman:28959 blocked for more than 120 seconds.
[1483702.836668] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[1483702.836670] pacman          D 0000000000000246     0 28959  28958
0x00000000
[1483702.836673]  ffff8800215b9c18 0000000000000082 ffff8800cbc258b0
ffff8800215b9fd8
[1483702.836676]  ffff8800215b9fd8 ffff8800215b9fd8 ffff880009fbb060
ffff8800cbc258b0
[1483702.836678]  ffff8800215b9dc8 ffff8800215b9dc8 ffff88010ff610d0
ffff88010ff610d0
[1483702.836681] Call Trace:
[1483702.836689]  [<ffffffff81183164>] ? lookup_fast+0x44/0x310
[1483702.836693]  [<ffffffff8120304c>] ? security_inode_permission+0x1c/0x30
[1483702.836696]  [<ffffffff81479569>] schedule+0x29/0x70
[1483702.836698]  [<ffffffff81479837>] schedule_preempt_disabled+0x27/0x40
[1483702.836701]  [<ffffffff81477ec8>] __mutex_lock_slowpath+0x148/0x340
[1483702.836706]  [<ffffffff814780d6>] mutex_lock+0x16/0x30
[1483702.836712]  [<ffffffffa03b0686>] cifs_reconnect_tcon+0x196/0x320 [cifs]
[1483702.836717]  [<ffffffffa03b08e9>] smb_init+0x39/0x70 [cifs]
[1483702.836720]  [<ffffffffa03b8814>] CIFSSMBQFSInfo+0x64/0x210 [cifs]
[1483702.836723]  [<ffffffffa03af47e>] cifs_statfs+0xce/0x160 [cifs]
[1483702.836726]  [<ffffffff811a6c61>] statfs_by_dentry+0xa1/0x140
[1483702.836727]  [<ffffffff811a6d1b>] vfs_statfs+0x1b/0xb0
[1483702.836729]  [<ffffffff811a6de7>] user_statfs+0x37/0x50
[1483702.836731]  [<ffffffff811a6e80>] sys_statfs+0x20/0x40
[1483702.836734]  [<ffffffff81481929>] system_call_fastpath+0x16/0x1b
[1483822.625146] INFO: task pacman:28959 blocked for more than 120 seconds.
[1483822.625151] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[1483822.625152] pacman          D 0000000000000246     0 28959  28958
0x00000000
[1483822.625156]  ffff8800215b9c18 0000000000000082 ffff8800cbc258b0
ffff8800215b9fd8
[1483822.625159]  ffff8800215b9fd8 ffff8800215b9fd8 ffff880009fbb060
ffff8800cbc258b0
[1483822.625161]  ffff8800215b9dc8 ffff8800215b9dc8 ffff88010ff610d0
ffff88010ff610d0
[1483822.625163] Call Trace:
[1483822.625171]  [<ffffffff81183164>] ? lookup_fast+0x44/0x310
[1483822.625175]  [<ffffffff8120304c>] ? security_inode_permission+0x1c/0x30
[1483822.625178]  [<ffffffff81479569>] schedule+0x29/0x70
[1483822.625181]  [<ffffffff81479837>] schedule_preempt_disabled+0x27/0x40
[1483822.625183]  [<ffffffff81477ec8>] __mutex_lock_slowpath+0x148/0x340
[1483822.625188]  [<ffffffff814780d6>] mutex_lock+0x16/0x30
[1483822.625193]  [<ffffffffa03b0686>] cifs_reconnect_tcon+0x196/0x320 [cifs]
[1483822.625199]  [<ffffffffa03b08e9>] smb_init+0x39/0x70 [cifs]
[1483822.625203]  [<ffffffffa03b8814>] CIFSSMBQFSInfo+0x64/0x210 [cifs]
[1483822.625206]  [<ffffffffa03af47e>] cifs_statfs+0xce/0x160 [cifs]
[1483822.625208]  [<ffffffff811a6c61>] statfs_by_dentry+0xa1/0x140
[1483822.625210]  [<ffffffff811a6d1b>] vfs_statfs+0x1b/0xb0
[1483822.625212]  [<ffffffff811a6de7>] user_statfs+0x37/0x50
[1483822.625213]  [<ffffffff811a6e80>] sys_statfs+0x20/0x40
[1483822.625216]  [<ffffffff81481929>] system_call_fastpath+0x16/0x1b
[1483942.413619] INFO: task pacman:28959 blocked for more than 120 seconds.
[1483942.413623] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[1483942.413624] pacman          D 0000000000000246     0 28959  28958
0x00000000
[1483942.413628]  ffff8800215b9c18 0000000000000082 ffff8800cbc258b0
ffff8800215b9fd8
[1483942.413631]  ffff8800215b9fd8 ffff8800215b9fd8 ffff880009fbb060
ffff8800cbc258b0
[1483942.413633]  ffff8800215b9dc8 ffff8800215b9dc8 ffff88010ff610d0
ffff88010ff610d0
[1483942.413636] Call Trace:
[1483942.413643]  [<ffffffff81183164>] ? lookup_fast+0x44/0x310
[1483942.413647]  [<ffffffff8120304c>] ? security_inode_permission+0x1c/0x30
[1483942.413650]  [<ffffffff81479569>] schedule+0x29/0x70
[1483942.413652]  [<ffffffff81479837>] schedule_preempt_disabled+0x27/0x40
[1483942.413655]  [<ffffffff81477ec8>] __mutex_lock_slowpath+0x148/0x340
[1483942.413659]  [<ffffffff814780d6>] mutex_lock+0x16/0x30
[1483942.413665]  [<ffffffffa03b0686>] cifs_reconnect_tcon+0x196/0x320 [cifs]
[1483942.413671]  [<ffffffffa03b08e9>] smb_init+0x39/0x70 [cifs]
[1483942.413674]  [<ffffffffa03b8814>] CIFSSMBQFSInfo+0x64/0x210 [cifs]
[1483942.413677]  [<ffffffffa03af47e>] cifs_statfs+0xce/0x160 [cifs]
[1483942.413680]  [<ffffffff811a6c61>] statfs_by_dentry+0xa1/0x140
[1483942.413682]  [<ffffffff811a6d1b>] vfs_statfs+0x1b/0xb0
[1483942.413683]  [<ffffffff811a6de7>] user_statfs+0x37/0x50
[1483942.413685]  [<ffffffff811a6e80>] sys_statfs+0x20/0x40
[1483942.413688]  [<ffffffff81481929>] system_call_fastpath+0x16/0x1b
[1484062.202109] INFO: task pacman:28959 blocked for more than 120 seconds.
[1484062.202113] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[1484062.202115] pacman          D 0000000000000246     0 28959  28958
0x00000000
[1484062.202119]  ffff8800215b9c18 0000000000000082 ffff8800cbc258b0
ffff8800215b9fd8
[1484062.202122]  ffff8800215b9fd8 ffff8800215b9fd8 ffff880009fbb060
ffff8800cbc258b0
[1484062.202124]  ffff8800215b9dc8 ffff8800215b9dc8 ffff88010ff610d0
ffff88010ff610d0
[1484062.202126] Call Trace:
[1484062.202133]  [<ffffffff81183164>] ? lookup_fast+0x44/0x310
[1484062.202137]  [<ffffffff8120304c>] ? security_inode_permission+0x1c/0x30
[1484062.202141]  [<ffffffff81479569>] schedule+0x29/0x70
[1484062.202143]  [<ffffffff81479837>] schedule_preempt_disabled+0x27/0x40
[1484062.202146]  [<ffffffff81477ec8>] __mutex_lock_slowpath+0x148/0x340
[1484062.202150]  [<ffffffff814780d6>] mutex_lock+0x16/0x30
[1484062.202156]  [<ffffffffa03b0686>] cifs_reconnect_tcon+0x196/0x320 [cifs]
[1484062.202161]  [<ffffffffa03b08e9>] smb_init+0x39/0x70 [cifs]
[1484062.202165]  [<ffffffffa03b8814>] CIFSSMBQFSInfo+0x64/0x210 [cifs]
[1484062.202168]  [<ffffffffa03af47e>] cifs_statfs+0xce/0x160 [cifs]
[1484062.202170]  [<ffffffff811a6c61>] statfs_by_dentry+0xa1/0x140
[1484062.202172]  [<ffffffff811a6d1b>] vfs_statfs+0x1b/0xb0
[1484062.202173]  [<ffffffff811a6de7>] user_statfs+0x37/0x50
[1484062.202175]  [<ffffffff811a6e80>] sys_statfs+0x20/0x40
[1484062.202178]  [<ffffffff81481929>] system_call_fastpath+0x16/0x1b
[1484181.990599] INFO: task pacman:28959 blocked for more than 120 seconds.
[1484181.990603] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[1484181.990605] pacman          D 0000000000000246     0 28959  28958
0x00000000
[1484181.990609]  ffff8800215b9c18 0000000000000082 ffff8800cbc258b0
ffff8800215b9fd8
[1484181.990612]  ffff8800215b9fd8 ffff8800215b9fd8 ffff880009fbb060
ffff8800cbc258b0
[1484181.990614]  ffff8800215b9dc8 ffff8800215b9dc8 ffff88010ff610d0
ffff88010ff610d0
[1484181.990617] Call Trace:
[1484181.990624]  [<ffffffff81183164>] ? lookup_fast+0x44/0x310
[1484181.990627]  [<ffffffff8120304c>] ? security_inode_permission+0x1c/0x30
[1484181.990631]  [<ffffffff81479569>] schedule+0x29/0x70
[1484181.990633]  [<ffffffff81479837>] schedule_preempt_disabled+0x27/0x40
[1484181.990635]  [<ffffffff81477ec8>] __mutex_lock_slowpath+0x148/0x340
[1484181.990639]  [<ffffffff814780d6>] mutex_lock+0x16/0x30
[1484181.990645]  [<ffffffffa03b0686>] cifs_reconnect_tcon+0x196/0x320 [cifs]
[1484181.990650]  [<ffffffffa03b08e9>] smb_init+0x39/0x70 [cifs]
[1484181.990654]  [<ffffffffa03b8814>] CIFSSMBQFSInfo+0x64/0x210 [cifs]
[1484181.990657]  [<ffffffffa03af47e>] cifs_statfs+0xce/0x160 [cifs]
[1484181.990659]  [<ffffffff811a6c61>] statfs_by_dentry+0xa1/0x140
[1484181.990661]  [<ffffffff811a6d1b>] vfs_statfs+0x1b/0xb0
[1484181.990663]  [<ffffffff811a6de7>] user_statfs+0x37/0x50
[1484181.990664]  [<ffffffff811a6e80>] sys_statfs+0x20/0x40
[1484181.990667]  [<ffffffff81481929>] system_call_fastpath+0x16/0x1b
[1484301.779055] INFO: task pacman:28959 blocked for more than 120 seconds.
[1484301.779058] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[1484301.779060] pacman          D 0000000000000246     0 28959  28958
0x00000000
[1484301.779064]  ffff8800215b9c18 0000000000000082 ffff8800cbc258b0
ffff8800215b9fd8
[1484301.779068]  ffff8800215b9fd8 ffff8800215b9fd8 ffff880009fbb060
ffff8800cbc258b0
[1484301.779069]  ffff8800215b9dc8 ffff8800215b9dc8 ffff88010ff610d0
ffff88010ff610d0
[1484301.779072] Call Trace:
[1484301.779079]  [<ffffffff81183164>] ? lookup_fast+0x44/0x310
[1484301.779082]  [<ffffffff8120304c>] ? security_inode_permission+0x1c/0x30
[1484301.779086]  [<ffffffff81479569>] schedule+0x29/0x70
[1484301.779088]  [<ffffffff81479837>] schedule_preempt_disabled+0x27/0x40
[1484301.779090]  [<ffffffff81477ec8>] __mutex_lock_slowpath+0x148/0x340
[1484301.779095]  [<ffffffff814780d6>] mutex_lock+0x16/0x30
[1484301.779101]  [<ffffffffa03b0686>] cifs_reconnect_tcon+0x196/0x320 [cifs]
[1484301.779106]  [<ffffffffa03b08e9>] smb_init+0x39/0x70 [cifs]
[1484301.779109]  [<ffffffffa03b8814>] CIFSSMBQFSInfo+0x64/0x210 [cifs]
[1484301.779112]  [<ffffffffa03af47e>] cifs_statfs+0xce/0x160 [cifs]
[1484301.779115]  [<ffffffff811a6c61>] statfs_by_dentry+0xa1/0x140
[1484301.779117]  [<ffffffff811a6d1b>] vfs_statfs+0x1b/0xb0
[1484301.779118]  [<ffffffff811a6de7>] user_statfs+0x37/0x50
[1484301.779120]  [<ffffffff811a6e80>] sys_statfs+0x20/0x40
[1484301.779123]  [<ffffffff81481929>] system_call_fastpath+0x16/0x1b
[1484421.567540] INFO: task pacman:28959 blocked for more than 120 seconds.
[1484421.567543] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[1484421.567545] pacman          D 0000000000000246     0 28959  28958
0x00000000
[1484421.567549]  ffff8800215b9c18 0000000000000082 ffff8800cbc258b0
ffff8800215b9fd8
[1484421.567552]  ffff8800215b9fd8 ffff8800215b9fd8 ffff880009fbb060
ffff8800cbc258b0
[1484421.567554]  ffff8800215b9dc8 ffff8800215b9dc8 ffff88010ff610d0
ffff88010ff610d0
[1484421.567557] Call Trace:
[1484421.567564]  [<ffffffff81183164>] ? lookup_fast+0x44/0x310
[1484421.567568]  [<ffffffff8120304c>] ? security_inode_permission+0x1c/0x30
[1484421.567572]  [<ffffffff81479569>] schedule+0x29/0x70
[1484421.567574]  [<ffffffff81479837>] schedule_preempt_disabled+0x27/0x40
[1484421.567576]  [<ffffffff81477ec8>] __mutex_lock_slowpath+0x148/0x340
[1484421.567582]  [<ffffffff814780d6>] mutex_lock+0x16/0x30
[1484421.567587]  [<ffffffffa03b0686>] cifs_reconnect_tcon+0x196/0x320 [cifs]
[1484421.567592]  [<ffffffffa03b08e9>] smb_init+0x39/0x70 [cifs]
[1484421.567596]  [<ffffffffa03b8814>] CIFSSMBQFSInfo+0x64/0x210 [cifs]
[1484421.567599]  [<ffffffffa03af47e>] cifs_statfs+0xce/0x160 [cifs]
[1484421.567602]  [<ffffffff811a6c61>] statfs_by_dentry+0xa1/0x140
[1484421.567604]  [<ffffffff811a6d1b>] vfs_statfs+0x1b/0xb0
[1484421.567605]  [<ffffffff811a6de7>] user_statfs+0x37/0x50
[1484421.567607]  [<ffffffff811a6e80>] sys_statfs+0x20/0x40
[1484421.567610]  [<ffffffff81481929>] system_call_fastpath+0x16/0x1b
[1484541.356021] INFO: task pacman:28959 blocked for more than 120 seconds.
[1484541.356025] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[1484541.356027] pacman          D 0000000000000246     0 28959  28958
0x00000000
[1484541.356030]  ffff8800215b9c18 0000000000000082 ffff8800cbc258b0
ffff8800215b9fd8
[1484541.356033]  ffff8800215b9fd8 ffff8800215b9fd8 ffff880009fbb060
ffff8800cbc258b0
[1484541.356035]  ffff8800215b9dc8 ffff8800215b9dc8 ffff88010ff610d0
ffff88010ff610d0
[1484541.356038] Call Trace:
[1484541.356046]  [<ffffffff81183164>] ? lookup_fast+0x44/0x310
[1484541.356050]  [<ffffffff8120304c>] ? security_inode_permission+0x1c/0x30
[1484541.356053]  [<ffffffff81479569>] schedule+0x29/0x70
[1484541.356056]  [<ffffffff81479837>] schedule_preempt_disabled+0x27/0x40
[1484541.356058]  [<ffffffff81477ec8>] __mutex_lock_slowpath+0x148/0x340
[1484541.356062]  [<ffffffff814780d6>] mutex_lock+0x16/0x30
[1484541.356068]  [<ffffffffa03b0686>] cifs_reconnect_tcon+0x196/0x320 [cifs]
[1484541.356073]  [<ffffffffa03b08e9>] smb_init+0x39/0x70 [cifs]
[1484541.356077]  [<ffffffffa03b8814>] CIFSSMBQFSInfo+0x64/0x210 [cifs]
[1484541.356080]  [<ffffffffa03af47e>] cifs_statfs+0xce/0x160 [cifs]
[1484541.356082]  [<ffffffff811a6c61>] statfs_by_dentry+0xa1/0x140
[1484541.356084]  [<ffffffff811a6d1b>] vfs_statfs+0x1b/0xb0
[1484541.356086]  [<ffffffff811a6de7>] user_statfs+0x37/0x50
[1484541.356087]  [<ffffffff811a6e80>] sys_statfs+0x20/0x40
[1484541.356090]  [<ffffffff81481929>] system_call_fastpath+0x16/0x1b
[1484661.144493] INFO: task pacman:28959 blocked for more than 120 seconds.
[1484661.144497] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[1484661.144499] pacman          D 0000000000000246     0 28959  28958
0x00000000
[1484661.144502]  ffff8800215b9c18 0000000000000082 ffff8800cbc258b0
ffff8800215b9fd8
[1484661.144506]  ffff8800215b9fd8 ffff8800215b9fd8 ffff880009fbb060
ffff8800cbc258b0
[1484661.144508]  ffff8800215b9dc8 ffff8800215b9dc8 ffff88010ff610d0
ffff88010ff610d0
[1484661.144510] Call Trace:
[1484661.144517]  [<ffffffff81183164>] ? lookup_fast+0x44/0x310
[1484661.144521]  [<ffffffff8120304c>] ? security_inode_permission+0x1c/0x30
[1484661.144526]  [<ffffffff81479569>] schedule+0x29/0x70
[1484661.144528]  [<ffffffff81479837>] schedule_preempt_disabled+0x27/0x40
[1484661.144530]  [<ffffffff81477ec8>] __mutex_lock_slowpath+0x148/0x340
[1484661.144534]  [<ffffffff814780d6>] mutex_lock+0x16/0x30
[1484661.144540]  [<ffffffffa03b0686>] cifs_reconnect_tcon+0x196/0x320 [cifs]
[1484661.144545]  [<ffffffffa03b08e9>] smb_init+0x39/0x70 [cifs]
[1484661.144549]  [<ffffffffa03b8814>] CIFSSMBQFSInfo+0x64/0x210 [cifs]
[1484661.144552]  [<ffffffffa03af47e>] cifs_statfs+0xce/0x160 [cifs]
[1484661.144555]  [<ffffffff811a6c61>] statfs_by_dentry+0xa1/0x140
[1484661.144557]  [<ffffffff811a6d1b>] vfs_statfs+0x1b/0xb0
[1484661.144558]  [<ffffffff811a6de7>] user_statfs+0x37/0x50
[1484661.144560]  [<ffffffff811a6e80>] sys_statfs+0x20/0x40
[1484661.144563]  [<ffffffff81481929>] system_call_fastpath+0x16/0x1b
[1484780.932994] INFO: task pacman:28959 blocked for more than 120 seconds.
[1484780.932998] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[1484780.932999] pacman          D 0000000000000246     0 28959  28958
0x00000000
[1484780.933003]  ffff8800215b9c18 0000000000000082 ffff8800cbc258b0
ffff8800215b9fd8
[1484780.933006]  ffff8800215b9fd8 ffff8800215b9fd8 ffff880009fbb060
ffff8800cbc258b0
[1484780.933008]  ffff8800215b9dc8 ffff8800215b9dc8 ffff88010ff610d0
ffff88010ff610d0
[1484780.933011] Call Trace:
[1484780.933018]  [<ffffffff81183164>] ? lookup_fast+0x44/0x310
[1484780.933022]  [<ffffffff8120304c>] ? security_inode_permission+0x1c/0x30
[1484780.933025]  [<ffffffff81479569>] schedule+0x29/0x70
[1484780.933028]  [<ffffffff81479837>] schedule_preempt_disabled+0x27/0x40
[1484780.933030]  [<ffffffff81477ec8>] __mutex_lock_slowpath+0x148/0x340
[1484780.933035]  [<ffffffff814780d6>] mutex_lock+0x16/0x30
[1484780.933041]  [<ffffffffa03b0686>] cifs_reconnect_tcon+0x196/0x320 [cifs]
[1484780.933046]  [<ffffffffa03b08e9>] smb_init+0x39/0x70 [cifs]
[1484780.933050]  [<ffffffffa03b8814>] CIFSSMBQFSInfo+0x64/0x210 [cifs]
[1484780.933052]  [<ffffffffa03af47e>] cifs_statfs+0xce/0x160 [cifs]
[1484780.933055]  [<ffffffff811a6c61>] statfs_by_dentry+0xa1/0x140
[1484780.933056]  [<ffffffff811a6d1b>] vfs_statfs+0x1b/0xb0
[1484780.933058]  [<ffffffff811a6de7>] user_statfs+0x37/0x50
[1484780.933060]  [<ffffffff811a6e80>] sys_statfs+0x20/0x40
[1484780.933063]  [<ffffffff81481929>] system_call_fastpath+0x16/0x1b
[1485543.267793] CIFS VFS: Unexpected lookup error -19
[1485543.267842] CIFS VFS: Unexpected lookup error -19
[1485543.267856] CIFS VFS: Unexpected lookup error -19
[1485543.267868] CIFS VFS: Unexpected lookup error -19
[1485543.267880] CIFS VFS: Unexpected lookup error -19
[1485543.267891] CIFS VFS: Unexpected lookup error -19
[1485543.267902] CIFS VFS: Unexpected lookup error -19
[1485543.267914] CIFS VFS: Unexpected lookup error -19
[1485543.267925] CIFS VFS: Unexpected lookup error -19
[1485543.267936] CIFS VFS: Unexpected lookup error -19
[1485543.267960] CIFS VFS: Unexpected lookup error -19

Regards,
Marti
