From: "ISHIKAWA,chiaki" <ishikawa-FORCTJUUkgPbmG5+kqVDhQ@public.gmane.org>
Subject: Re: Hung CIFS driver
Date: Sun, 10 Nov 2013 14:49:14 +0900
Message-ID: <527F1E5A.9090900@yk.rim.or.jp>
References: <527BAFC6.5010600@yk.rim.or.jp> <20131107110353.6d203196@tlielax.poochiereds.net> <CAH2r5mtuM6e7BpHk06sM9rzOxfcRgdkmw0vuQhJfYsrJkfrEdA@mail.gmail.com> <527BC9C9.5080502@yk.rim.or.jp> <527D1ABD.3080404@yk.rim.or.jp> <527D2255.1070709@yk.rim.or.jp> <20131109065826.481ff52c@tlielax.poochiereds.net> <527F0E21.603@yk.rim.or.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <527F0E21.603-FORCTJUUkgPbmG5+kqVDhQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

(2013/11/10 13:40), ISHIKAWA,chiaki wrote:
> (2013/11/09 20:58), Jeff Layton wrote:
>> On Sat, 09 Nov 2013 02:41:41 +0900
>> "ISHIKAWA,chiaki" <ishikawa-FORCTJUUkgPbmG5+kqVDhQ@public.gmane.org> wrote:
>>
>>> I am keeping this linux running in this manner and so
>>> let me know if you need some runtime information which can be gleaned by
>>> some means (like system trace, etc.). Please advise how to obtain the
>>> information in that case (the particular command to obtain the desired
>>> value will be useful.)
>>>
>>
>> I think what's missing here is some information about what's actually
>> happening on the network when you try to recontact the server.
>>
>> When you bring the interface back up, does the client ever send a SYN
>> back to the server? If so, does the server respond?
>>
>
> OK, here is my TODO list:
> I will try to capture the packet using WireShark on the side of Win7 host.
>

Sorry, this has to wait. I am not sure what I should do to open a TCP 
conenction. Should I try to mount a different CIFS-share to the WIN7 
host and close the connection or should I open a different TCP 
connection using a different connection? I think the latter
is better since it would not disturb the CIFS driver status.

> Oh wait, can I ping the host right now? Of course, it can.
> I understand that the suggestion about SYN is regarding the TCP socket
> (CIFS now uses TCP, I suppose) reestablishment.
>
>> Also, what is cifsd (the kernel thread that handles receives) doing at
>> this point? I'd expect it to be trying to reconnect to the server...
>>
> CIFS driver is inside the kernel, correct. I am not entirely sure how I
> can do this. Maybe I should use google to figure out how to debug kernel
> thread.
>
>> What kernel version is this too, btw?
>
> uname -r
> 3.10-3-amd64
>
> It is 3.10.3 64bit.

I could find out where the lower-level kernel worker threads are stuck.
But it may not be high-level enough to know where CIFS driver gets stuck?

I search for the process stuck in "D" state.
Not knowing what to do, I used "ps -aelfw | grep D" to look for
tell-tale "D".
I marked the lines relevant to this discussion.

     ishikawa@vm-debian-amd64:/var/log$ ps -aelfw | grep D
     F S UID        PID  PPID  C PRI  NI ADDR SZ WCHAN  STIME TTY 
    TIME CMD
     5 S Debian-+  3009     1  0  80   0 - 12904 ?      Nov06 ? 
00:00:00 /usr/sbin/exim4 -bd -q30m
     4 S root      3129  3108  0  80   0 - 43934 ?      Nov06 ? 
00:00:00 /usr/lib/gdm3/gdm-simple-slave --display-id /org/gnome/Di
     0 S ishikawa  3180  8788  0  80   0 -  2190 -      13:47 pts/8 
00:00:00 grep D
     0 S ishikawa  3919  3894  0  80   0 -  9632 -      Nov06 ? 
00:00:01 oclock -xtsessionID 23103f808-3bda-4369-b14c-79eb6dac971e
*   1 D root     17092     2  0  80   0 -     0 ?      Nov08 ? 
00:00:12 [kworker/0:166]
*   1 D root     17768     2  0  80   0 -     0 ?      Nov08 ? 
00:00:30 [kworker/0:0]
*   0 D ishikawa 17969     1  0  80   0 -  1050 -      Nov08 ? 
00:00:00 ./cp-test big-file /tmp/L-temp/1111gQGn
*   0 D ishikawa 18801     1  0  80   0 -  7264 -      Nov08 ? 
00:00:00 ls -aF -ltr /tmp/L-temp/
*   0 D ishikawa 25747     1  0  80   0 -  5153 -      Nov09 ? 
00:00:00 ls -aF /tmp/L-temp/

17092, 17768 are kernel thread: given the date shown they are likely
to be related.

17969, 18801, 25757 are the user processed I invoked. "./cp-test" is
the copy program. "ls" are when I tried to show the directory listing
and got stuck.

OK, we may want to find out what kernel threads
17092, and 17768 are doing.
(And may want to find out what are the status of page locks and
maybe some semaphore/mutex/futex or whatever these threads hold.)

I found out that I can print the contents of /proc/[pid]/stack to
obtain stacktrace of a process/thread.  From the listing, I gather the
following kernel kworker thread seem to get stuck after CIFS-related
operations

17092 ... cifs_oplock_break ...
17768 ... cifs_writev_complete ...

and then do "wake_bit_function". 17768 does a __lock_page while 17092
does wait_on_page_bit, and so the stackstraces are a little bit
non-symmetrical. Maybe 17768 and 177092 are locking each other or
with other kernel threads? The underlying page(s) are either locked or 
gone???

So I think the mount is still on and reconnected(?)

root@vm-debian-amd64:/# cat /proc/17092/stack
[<ffffffff810c051f>] sleep_on_page+0x0/0x8
[<ffffffff810c0524>] sleep_on_page+0x5/0x8
[<ffffffff810c05ce>] wait_on_page_bit+0x69/0x6e
[<ffffffff81057ca7>] wake_bit_function+0x0/0x27
[<ffffffff810c0c7b>] filemap_fdatawait_range+0x65/0xfa
[<ffffffffa04dec18>] cifs_oplock_break+0xd5/0x21d [cifs]
[<ffffffff8105f74a>] finish_task_switch+0x81/0xaa
[<ffffffff81052a71>] process_one_work+0x18b/0x28c
[<ffffffff81052f1b>] worker_thread+0x121/0x1e7
[<ffffffff81052dfa>] worker_thread+0x0/0x1e7
[<ffffffff81057325>] kthread+0x7d/0x85
[<ffffffff810572a8>] kthread+0x0/0x85
[<ffffffff8138b47c>] ret_from_fork+0x7c/0xb0
[<ffffffff810572a8>] kthread+0x0/0x85
[<ffffffffffffffff>] 0xffffffffffffffff
root@vm-debian-amd64:/# cat /proc/17768/stack
[<ffffffff810c051f>] sleep_on_page+0x0/0x8
[<ffffffff810c0524>] sleep_on_page+0x5/0x8
[<ffffffff810c051a>] __lock_page+0x5c/0x61
[<ffffffff81057ca7>] wake_bit_function+0x0/0x27
[<ffffffffa04d17c8>] cifs_writev_complete+0x87/0x17e [cifs]
[<ffffffff81052a71>] process_one_work+0x18b/0x28c
[<ffffffff81052f1b>] worker_thread+0x121/0x1e7
[<ffffffff81052dfa>] worker_thread+0x0/0x1e7
[<ffffffff81057325>] kthread+0x7d/0x85
[<ffffffff81040900>] do_exit+0x901/0x918
[<ffffffff810572a8>] kthread+0x0/0x85
[<ffffffff8138b47c>] ret_from_fork+0x7c/0xb0
[<ffffffff810572a8>] kthread+0x0/0x85
[<ffffffffffffffff>] 0xffffffffffffffff
root@vm-debian-amd64:/#

I wonder how I can find out about the pages that are the targets of
wake_on_page_bit -> sleep_on_page, and
__lock_page -> sleep_on_page.

TIA


PS: mount seems to be still in effect at least on the linux side.
(The issue may be  whether this is still valid on Win7 side after
two days of hung CIFS driver: so maybe once this hung-state is cleared
CIFS may try to reestablish the upper-level connection?)

mountinfo as seen by kworker 17768: the last line shows the CIFS-share 
mount.

root@vm-debian-amd64:/# cat /proc/17768/mountinfo
14 19 0:13 / /sys rw,nosuid,nodev,noexec,relatime - sysfs sysfs rw
15 19 0:3 / /proc rw,nosuid,nodev,noexec,relatime - proc proc rw
16 19 0:5 / /dev rw,relatime - devtmpfs udev 
rw,size=10240k,nr_inodes=1177830,mode=755
17 16 0:10 / /dev/pts rw,nosuid,noexec,relatime - devpts devpts 
rw,gid=5,mode=620,ptmxmode=000
18 19 0:14 / /run rw,nosuid,noexec,relatime - tmpfs tmpfs 
rw,size=942744k,mode=755
19 1 8:1 / / rw,relatime - ext4 
/dev/disk/by-uuid/e5f60120-3afd-457a-be02-9bd6d8cc4f4d 
rw,errors=remount-ro,data=ordered
20 18 0:15 / /run/lock rw,nosuid,nodev,noexec,relatime - tmpfs tmpfs 
rw,size=5120k
21 18 0:16 / /run/shm rw,nosuid,nodev,noexec,relatime - tmpfs tmpfs 
rw,size=2861760k
22 14 0:17 / /sys/fs/fuse/connections rw,relatime - fusectl fusectl rw
23 19 8:3 / /boot rw,relatime - ext2 /dev/sda3 rw,errors=continue
24 19 8:5 / /home rw,relatime - ext4 /dev/sda5 rw,data=ordered
25 19 8:6 / /usr rw,relatime - ext4 /dev/sda6 rw,data=ordered
26 19 8:7 / /var rw,relatime - ext4 /dev/sda7 rw,data=ordered
27 19 8:17 / /TB-NEW rw,relatime - ext4 /dev/sdb1 rw,data=ordered
28 19 8:33 / /FF-NEW rw,relatime - ext4 /dev/sdc1 
rw,errors=remount-ro,data=ordered
29 19 8:49 / /COMM-CENTRAL rw,relatime - ext4 /dev/sdd1 
rw,errors=remount-ro,data=ordered
30 19 8:65 / /TEST-MAIL-DIR rw,relatime - ext4 /dev/sde1 
rw,errors=remount-ro,data=ordered
31 19 8:81 / /REF-COMM-CENTRAL rw,relatime - ext4 /dev/sdf1 
rw,errors=remount-ro,data=ordered
32 19 8:97 / /REF-OBJ-DIR rw,relatime - ext4 /dev/sdg1 rw
33 18 0:18 / /run/vmblock-fuse rw,nosuid,nodev,relatime - 
fuse.vmware-vmblock vmware-vmblock 
rw,user_id=0,group_id=0,default_permissions,allow_other
34 26 0:19 / /var/lib/nfs/rpc_pipefs rw,relatime - rpc_pipefs rpc_pipefs rw
35 15 0:20 / /proc/sys/fs/binfmt_misc rw,nosuid,nodev,noexec,relatime - 
binfmt_misc binfmt_misc rw
37 19 0:21 / /tmp/L-temp rw,relatime - cifs //192.168.0.112/L-temp 
rw,vers=1.0,sec=ntlmssp,cache=strict,username=ci,domain=USER-PC,uid=0,noforceuid,gid=0,noforcegid,addr=192.168.0.112,file_mode=0755,dir_mode=0755,nounix,serverino,noperm,rsize=61440,wsize=65536,actimeo=1
root@vm-debian-amd64:/#
