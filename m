From: "ISHIKAWA,chiaki" <ishikawa-FORCTJUUkgPbmG5+kqVDhQ@public.gmane.org>
Subject: Re: Hung CIFS driver
Date: Sun, 10 Nov 2013 23:06:28 +0900
Message-ID: <527F92E4.6000206@yk.rim.or.jp>
References: <527BAFC6.5010600@yk.rim.or.jp> <20131107110353.6d203196@tlielax.poochiereds.net> <CAH2r5mtuM6e7BpHk06sM9rzOxfcRgdkmw0vuQhJfYsrJkfrEdA@mail.gmail.com> <527BC9C9.5080502@yk.rim.or.jp> <527D1ABD.3080404@yk.rim.or.jp> <527D2255.1070709@yk.rim.or.jp> <20131109065826.481ff52c@tlielax.poochiereds.net> <527F0E21.603@yk.rim.or.jp> <20131110070412.0c685682@tlielax.poochiereds.net> <527F7C46.4040105@yk.rim.or.jp> <527F7E54.5080905@yk.rim.or.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <527F7E54.5080905-FORCTJUUkgPbmG5+kqVDhQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

(2013/11/10 21:38), ISHIKAWA,chiaki wrote:
> cat /proc/16901/stack

I found a few more:

root@vm-debian-amd64:/tmp# ps -aef | grep cifs
root     12744 11427  0 22:03 pts/8    00:00:00 grep cifs
root     16853     2  0 Nov08 ?        00:00:00 [cifsiod]
root     16901     2  0 Nov08 ?        00:00:31 [cifsd]
root@vm-debian-amd64:/tmp# cat /proc/16853/status
Name:	cifsiod
State:	S (sleeping)
Tgid:	16853
Pid:	16853
PPid:	2
TracerPid:	0
Uid:	0	0	0	0
Gid:	0	0	0	0
FDSize:	64
Groups:	
Threads:	1
SigQ:	0/73614
SigPnd:	0000000000000000
ShdPnd:	0000000000000000
SigBlk:	0000000000000000
SigIgn:	ffffffffffffffff
SigCgt:	0000000000000000
CapInh:	0000000000000000
CapPrm:	0000001fffffffff
CapEff:	0000001fffffffff
CapBnd:	0000001fffffffff
Seccomp:	0
Cpus_allowed:	ffffffff
Cpus_allowed_list:	0-31
Mems_allowed:	00000000,00000001
Mems_allowed_list:	0
voluntary_ctxt_switches:	2
nonvoluntary_ctxt_switches:	0
root@vm-debian-amd64:/tmp# cat /proc/16901/status
Name:	cifsd
State:	S (sleeping)
Tgid:	16901
Pid:	16901
PPid:	2
TracerPid:	0
Uid:	0	0	0	0
Gid:	0	0	0	0
FDSize:	64
Groups:	
Threads:	1
SigQ:	0/73614
SigPnd:	0000000000000000
ShdPnd:	0000000000000000
SigBlk:	0000000000000000
SigIgn:	ffffffffffffffff
SigCgt:	0000000000000000
CapInh:	0000000000000000
CapPrm:	0000001fffffffff
CapEff:	0000001fffffffff
CapBnd:	0000001fffffffff
Seccomp:	0
Cpus_allowed:	ffffffff
Cpus_allowed_list:	0-31
Mems_allowed:	00000000,00000001
Mems_allowed_list:	0
voluntary_ctxt_switches:	159414
nonvoluntary_ctxt_switches:	54456
root@vm-debian-amd64:/tmp# !521
cat /proc/16853/status
Name:	cifsiod
State:	S (sleeping)
Tgid:	16853
Pid:	16853
PPid:	2
TracerPid:	0
Uid:	0	0	0	0
Gid:	0	0	0	0
FDSize:	64
Groups:	
Threads:	1
SigQ:	0/73614
SigPnd:	0000000000000000
ShdPnd:	0000000000000000
SigBlk:	0000000000000000
SigIgn:	ffffffffffffffff
SigCgt:	0000000000000000
CapInh:	0000000000000000
CapPrm:	0000001fffffffff
CapEff:	0000001fffffffff
CapBnd:	0000001fffffffff
Seccomp:	0
Cpus_allowed:	ffffffff
Cpus_allowed_list:	0-31
Mems_allowed:	00000000,00000001
Mems_allowed_list:	0
voluntary_ctxt_switches:	2
nonvoluntary_ctxt_switches:	0
root@vm-debian-amd64:/tmp# !522
cat /proc/16901/status
Name:	cifsd
State:	S (sleeping)
Tgid:	16901
Pid:	16901
PPid:	2
TracerPid:	0
Uid:	0	0	0	0
Gid:	0	0	0	0
FDSize:	64
Groups:	
Threads:	1
SigQ:	0/73614
SigPnd:	0000000000000000
ShdPnd:	0000000000000000
SigBlk:	0000000000000000
SigIgn:	ffffffffffffffff
SigCgt:	0000000000000000
CapInh:	0000000000000000
CapPrm:	0000001fffffffff
CapEff:	0000001fffffffff
CapBnd:	0000001fffffffff
Seccomp:	0
Cpus_allowed:	ffffffff
Cpus_allowed_list:	0-31
Mems_allowed:	00000000,00000001
Mems_allowed_list:	0
voluntary_ctxt_switches:	159420
nonvoluntary_ctxt_switches:	54456
root@vm-debian-amd64:/tmp#


---
Note that volunary context switches value for
16901 [cifsd] increased between the two dumps, so I suspect that the
routines in the top of the stacktrace are repeated.

---

cat /proc/16901/syscall
-1 0xffff880269253f58 0x0
root@vm-debian-amd64:/tmp#

cd /proc/16901/net:
root@vm-debian-amd64:/proc/16901/net# ls
anycast6      hci	     ip_mr_vif	 protocols  rt_acct	  tcp
arp	      icmp	     ipv6_route  psched     rt_cache	  tcp6
bnep	      if_inet6	     l2cap	 ptype	    sco		  udp
connector     igmp	     mcfilter	 raw	    snmp	  udp6
dev	      igmp6	     mcfilter6	 raw6	    snmp6	  udplite
dev_mcast     ip6_flowlabel  netfilter	 rfcomm     sockstat	  udplite6
dev_snmp6     ip6_mr_cache   netlink	 route	    sockstat6	  unix
fib_trie      ip6_mr_vif     netstat	 rpc	    softnet_stat  wireless
fib_triestat  ip_mr_cache    packet	 rt6_stats  stat
root@vm-debian-amd64:/proc/16901/net# cat ip_mr_cache
Group    Origin   Iif     Pkts    Bytes    Wrong Oifs
root@vm-debian-amd64:/proc/16901/net# cat raw
   sl  local_address rem_address   st tx_queue rx_queue tr tm->when 
retrnsmt   uid  timeout inode ref pointer drops
root@vm-debian-amd64:/proc/16901/net# cat rpc
cat: rpc: Is a directory
root@vm-debian-amd64:/proc/16901/net# ls rpc
auth.rpcsec.context  auth.unix.ip   nfs4.nametoid  nfsd.fh
auth.rpcsec.init     nfs	    nfsd	   use-gss-proxy
auth.unix.gid	     nfs4.idtoname  nfsd.export
root@vm-debian-amd64:/proc/16901/net# cat tcp
   sl  local_address rem_address   st tx_queue rx_queue tr tm->when 
retrnsmt   uid  timeout inode 

    0: 00000000:8806 00000000:0000 0A 00000000:00000000 00:00000000 
00000000  1000        0 10130 1 ffff88026a2cc040 100 0 0 10 0 

    1: 00000000:006F 00000000:0000 0A 00000000:00000000 00:00000000 
00000000     0        0 6597 1 ffff88027f8e8780 100 0 0 10 0 

    2: 00000000:0016 00000000:0000 0A 00000000:00000000 00:00000000 
00000000     0        0 5631 1 ffff88027f8e8080 100 0 0 10 0 

    3: 0100007F:0277 00000000:0000 0A 00000000:00000000 00:00000000 
00000000     0        0 184452 1 ffff8800379ca740 100 0 0 10 0 

    4: 0100007F:0019 00000000:0000 0A 00000000:00000000 00:00000000 
00000000     0        0 5656 1 ffff880279a227c0 100 0 0 10 0 

    5: 0100007F:177A 00000000:0000 0A 00000000:00000000 00:00000000 
00000000  1001        0 105025 1 ffff880037b451c0 100 0 0 10 0 

    6: 0100007F:177B 00000000:0000 0A 00000000:00000000 00:00000000 
00000000  1001        0 643610 1 ffff880269ac7100 100 0 0 10 0 

    7: 00000000:445C 00000000:0000 0A 00000000:00000000 00:00000000 
00000000  1000        0 10456 1 ffff880279a220c0 100 0 0 10 0 

    8: 00000000:8A5C 00000000:0000 0A 00000000:00000000 00:00000000 
00000000   105        0 5282 1 ffff88027d341740 100 0 0 10 0 

    9: 00000000:C001 00000000:0000 0A 00000000:00000000 00:00000000 
00000000  1000        0 90294 1 ffff880037b458c0 100 0 0 10 0 

   10: 00000000:5701 00000000:0000 0A 00000000:00000000 00:00000000 
00000000   114        0 5494 1 ffff88027d341040 100 0 0 10 0 

   11: 0400A8C0:B6B4 7000A8C0:01BD 01 00000079:00000000 01:00001580 
0000000C     0        0 1056947 2 ffff88027cffa7c0 12000 0 0 1 7 

   12: 0400A8C0:DAD7 70A2A06C:0050 01 00000000:00000000 00:00000000 
00000000  1000        0 1060503 1 ffff8800379ca040 34 4 31 10 -1 

   13: 0100007F:5701 0100007F:987A 01 00000000:00000000 00:00000000 
00000000   114        0 10129 1 ffff88026a2cc740 21 4 1 10 -1 

   14: 0100007F:987A 0100007F:5701 01 00000000:00000000 00:00000000 
00000000  1000        0 10128 1 ffff88027cca21c0 20 4 0 10 -1 

   15: 0400A8C0:0016 4100A8C0:E3F0 01 00000000:00000000 02:0003146D 
00000000     0        0 1034669 2 ffff88026a2b1140 22 4 0 7 7 



According to what the man page of |proc| says,
 > 11: 0400A8C0:B6B4 7000A8C0:01BD 01 00000079:00000000 01:00001580 
0000000C     0        0 1056947 2 ffff88027cffa7c0 12000 0 0 1

This is for the CIFS mount.
7000A8C0:01BD -> 112.0.168.192 (reverse of 192.168.0.112 the address of 
Win7 host) : 445 (port # of CIFS tcp mount)


root@vm-debian-amd64:/proc/16901/net# cat sockstat
sockets: used 527
TCP: inuse 16 orphan 0 tw 0 alloc 32 mem 2
UDP: inuse 12 mem 6
UDPLITE: inuse 0
RAW: inuse 0
FRAG: inuse 0 memory 0
root@vm-debian-amd64:/proc/16901/net# cat stat
cat: stat: Is a directory
root@vm-debian-amd64:/proc/16901/net# ls stat
arp_cache  ndisc_cache	rt_cache
root@vm-debian-amd64:/proc/16901/net#

I hope this might give a clue.

TIA
