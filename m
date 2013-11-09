From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Hung CIFS driver
Date: Sat, 9 Nov 2013 06:58:26 -0500
Message-ID: <20131109065826.481ff52c@tlielax.poochiereds.net>
References: <527BAFC6.5010600@yk.rim.or.jp>
	<20131107110353.6d203196@tlielax.poochiereds.net>
	<CAH2r5mtuM6e7BpHk06sM9rzOxfcRgdkmw0vuQhJfYsrJkfrEdA@mail.gmail.com>
	<527BC9C9.5080502@yk.rim.or.jp>
	<527D1ABD.3080404@yk.rim.or.jp>
	<527D2255.1070709@yk.rim.or.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: "ISHIKAWA,chiaki" <ishikawa-FORCTJUUkgPbmG5+kqVDhQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <527D2255.1070709-FORCTJUUkgPbmG5+kqVDhQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 09 Nov 2013 02:41:41 +0900
"ISHIKAWA,chiaki" <ishikawa-FORCTJUUkgPbmG5+kqVDhQ@public.gmane.org> wrote:

> (2013/11/09 2:09), ISHIKAWA,chiaki wrote:
> >
> > In my next e-mail, I will report that
> > under Debian GNU/Linux 64bits, the CIFS driver
> > (uname -r shows 3.10-3-amd64)
> > can get hung, after a network error simulation by disabling
> > network interface and enabling again.
> > CIFS connection is reset, but a process gets stuck in I/O state
> > ("D" in ps output), and cannot be killed.
> >
> 
> System: Debian GNU/Linux 64-bits running in a VMPlayer hosted on Win7.
> 
> Remote host: Win7 (the host)
> 
> Test: CIFS-share is mounted
> 
> mount.cifs //192.168.0.112/L-temp /tmp/L-temp/ -o username=myid,noperm
> 
> and under that mounted directory, the following test is performed.
> 
> /tmp/L-temp is where CIFS-share is mounted.
> 
> TEST SCRIPT:
> Below,
> |cp-test| is a program that copies bytes from a file to the other using
> read/write system calls. (I can post a source on request.)
> 
> The test script is this:
> 
> # big-file is a 26+MiB file.
> TDIR=/tmp/L-temp   # changed to suit the system layout.
> while true
> do
> 	# t1=`create a temporary file name`
> 	t1=`mktemp $TDIR/1111XXXX`
> 	t2=`mktemp $TDIR/2222XXXX`
> 	t3=`mktemp $TDIR/3333XXXX`
> 
> 	# big-file is a 26+MiB file.
> 	./cp-test big-file ${t1}
> 	sleep 2
> 	./cp-test ${t1} ${t2}
> 	sleep 2
> 	./cp-test ${t2} ${t3}
> 	sleep 4
> 	rm -f ${t1} ${t2} ${t3}
> 	sleep 2
> done
> 
> The other side: CIFS share is on Windows 7.
> I tried the remedies discussed in
> https://wiki.archlinux.org/index.php/Samba/Troubleshooting
> and in a few other places
> to remedy the error ("cannot allocate memory" due to non-paged resource
> allocation failure on Win7, and subsequent mount failure on linux side.
> 
> Symptom: after a few tests of network failures simulated by
> disabling and enabling network interface of the VMPlayer,
> I noticed an incarnation of the program ./cp-test got stuck
> in "D" state, and could not be interrupted (^C) at all.
> I mounted CIFS-share with default option and so "soft" should be in effect.
> 
> Since this happened already after a few tests were performed,
> I cannot exclude the possibility of screwed up Windows7 host, but even 
> after a full day,
> I still cannot run "ls -lR" without getting the it hung (I cannot 
> interrupt it with
> ^C).
> 
> On the remote side, in Win7 system log, I see about the time the problem 
> started
> (24 hours ago or so) that windows was complaining that
> 
> The system could not allocate 983 work items in 60 seconds
> The system could not allocate 983 work items in 60 seconds
>   etc.
> (my translation : I am using Japanese windows and so not sure what
> the English windows would show.)
> 
> Now after 24 hours, I don't see it any more even when local "ls -lR" 
> gets hung. I just tested.
> So it now becomes pure local issue. The driver gets hung somewhere 
> without accessing the
> remote server at all. (Right, I see not much network traffic.)
> 
> Here is the dmesg output : I only copied the last part of the output
> and threw away unrelated messages (unrelated, I hope).
> 
> [133221.834132] FS-Cache: Netfs 'cifs' registered for caching
> [133221.834292] Key type cifs.spnego registered
> [133221.834322] Key type cifs.idmap registered
> [133221.966838] Status code returned 0xc000006d NT_STATUS_LOGON_FAILURE
> [133221.966846] CIFS VFS: Send error in SessSetup = -13
> [133221.967211] CIFS VFS: cifs_mount failed w/return code = -13
> [133331.808616] CIFS VFS: Error -104 sending data on socket to server
> [133331.808644] CIFS VFS: Error -32 sending data on socket to server
> 
> 		[ lots of same messages (-32)...]
> 
> [133331.809348] CIFS VFS: Error -32 sending data on socket to server
> 
> 		**** Here I simulated the network error again ****
> 

$ grep 32 /usr/include/asm-generic/errno-base.h 
#define	EPIPE		32	/* Broken pipe */

...this comes from the socket layer.

> [133566.580607] e1000: eth0 NIC Link is Down
> [133566.580722] e1000 0000:02:01.0 eth0: Reset adapter
> [133604.856771] e1000: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow 
> Control: None
> 
>                  **** Somehow CIFS in this version of linux seems to respond
> 		     only after 120 seconds timeout. I thought there was 15 seconds
> 		     timeout. ****
> 
> [133690.810481] CIFS VFS: Server 192.168.0.112 has not responded in 120 
> seconds. Reconnecting...

The cifs code attempts to send a SMB echo command (sort of like a ping
at the SMB layer) to the server every 60s. If the server doesn't
respond to two of them, the connection is reestablished.

> [133929.781446] e1000: eth0 NIC Link is Down
> [133929.781621] e1000 0000:02:01.0 eth0: Reset adapter
> [133957.933636] e1000: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow 
> Control: None
> [134054.949640] CIFS VFS: Server 192.168.0.112 has not responded in 120 
> seconds. Reconnecting...
> 
> 		**** Obviously a read/write routine gets stuck more than 120 seconds.
> 		     CIFS is being remounted after 120 seconds, but remount took more
> 		     than a few seconds, I guess. So 120+ seconds hung for the
> 		     stucked task/process ****
> 

It depends on what you mean by "routine" here. A read or write system
call may mean more than one SMB being transmitted on the wire. But it
really looks like you're having communications problems with the server.

> [134251.478654] INFO: task kworker/0:166:17092 blocked for more than 120 
> seconds.
> [134251.478659] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
> disables this message.
> [134251.478661] kworker/0:166   D ffff88028b613f40     0 17092      2 
> 0x00000000
> [134251.478694] Workqueue: cifsiod cifs_oplock_break [cifs]
> [134251.478697]  ffff8800a3c54100 0000000000000046 ffffffff81613400 
> 0000000000013f40
> [134251.478703]  ffff88005e8a1fd8 ffff88005e8a1fd8 ffff8800a3c54100 
> ffff88028b613f40
> [134251.478706]  ffff8800a3c54100 ffff88005e8a1d28 ffffffff810c051f 
> 0000000000000002
> [134251.478709] Call Trace:
> [134251.478781]  [<ffffffff810c051f>] ? __lock_page+0x61/0x61
> [134251.478820]  [<ffffffff813858be>] ? io_schedule+0x54/0x69
> [134251.478824]  [<ffffffff810c0524>] ? sleep_on_page+0x5/0x8
> [134251.478827]  [<ffffffff813846dd>] ? __wait_on_bit+0x3b/0x6e
> [134251.478829]  [<ffffffff810c05ce>] ? wait_on_page_bit+0x69/0x6e
> [134251.478851]  [<ffffffff81057ca7>] ? autoremove_wake_function+0x2a/0x2a
> [134251.478854]  [<ffffffff810c0c7b>] ? filemap_fdatawait_range+0x65/0xfa
> [134251.478860]  [<ffffffffa04dec18>] ? cifs_oplock_break+0xd5/0x21d [cifs]
> [134251.478865]  [<ffffffff8105f74a>] ? finish_task_switch+0x81/0xaa
> [134251.478871]  [<ffffffff81052a71>] ? process_one_work+0x18b/0x28c
> [134251.478873]  [<ffffffff81052f1b>] ? worker_thread+0x121/0x1e7
> [134251.478876]  [<ffffffff81052dfa>] ? rescuer_thread+0x265/0x265
> [134251.478878]  [<ffffffff81057325>] ? kthread+0x7d/0x85
> [134251.478881]  [<ffffffff810572a8>] ? __kthread_parkme+0x59/0x59
> [134251.478885]  [<ffffffff8138b47c>] ? ret_from_fork+0x7c/0xb0
> [134251.478887]  [<ffffffff810572a8>] ? __kthread_parkme+0x59/0x59
> [134251.478895] INFO: task pool:17993 blocked for more than 120 seconds.
> [134251.478897] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
> disables this message.
> [134251.478898] pool            D ffff88028b613f40     0 17993   5142 
> 0x00000000
> [134251.478901]  ffff88027cbe6780 0000000000000082 ffffffff81613400 
> 0000000000013f40
> [134251.478904]  ffff880221259fd8 ffff880221259fd8 ffff88027cbe6780 
> ffff88028b613f40
> [134251.478906]  ffff88027cbe6780 ffff880221259bc0 ffffffff810c051f 
> 0000000000000002
> [134251.478909] Call Trace:
> [134251.478911]  [<ffffffff810c051f>] ? __lock_page+0x61/0x61
> [134251.478914]  [<ffffffff813858be>] ? io_schedule+0x54/0x69
> [134251.478916]  [<ffffffff810c0524>] ? sleep_on_page+0x5/0x8
> [134251.478918]  [<ffffffff813846dd>] ? __wait_on_bit+0x3b/0x6e
> [134251.478920]  [<ffffffff810c05ce>] ? wait_on_page_bit+0x69/0x6e
> [134251.478922]  [<ffffffff81057ca7>] ? autoremove_wake_function+0x2a/0x2a
> [134251.478987]  [<ffffffff810cb14b>] ? 
> invalidate_inode_pages2_range+0x94/0x226
> [134251.478995]  [<ffffffffa04e64af>] ? 
> cifs_invalidate_mapping+0x22/0x51 [cifs]
> [134251.479000]  [<ffffffffa04dce7a>] ? cifs_d_revalidate+0x17/0x88 [cifs]
> [134251.479022]  [<ffffffff81111ad0>] ? lookup_fast+0x17f/0x213
> [134251.479026]  [<ffffffff81111d7b>] ? walk_component+0x33/0x1a2
> [134251.479029]  [<ffffffff81112b39>] ? path_lookupat+0x8e/0x293
> [134251.479034]  [<ffffffff810fa52e>] ? kmem_cache_alloc+0x8c/0xfd
> [134251.479037]  [<ffffffff81112d5d>] ? filename_lookup+0x1f/0x73
> [134251.479054]  [<ffffffff81114efe>] ? user_path_at_empty+0x6f/0xa6
> [134251.479064]  [<ffffffff8107c8f5>] ? do_futex+0xd1/0x7b5
> [134251.479066]  [<ffffffff8110d1f7>] ? vfs_fstatat+0x3e/0x8b
> [134251.479069]  [<ffffffff8110d4bd>] ? SYSC_newlstat+0x10/0x29
> [134251.479072]  [<ffffffff8138b529>] ? system_call_fastpath+0x16/0x1b
> [134251.479074] INFO: task pool:18378 blocked for more than 120 seconds.
> [134251.479076] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
> disables this message.
> [134251.479077] pool            D ffff88028b633f40     0 18378   5142 
> 0x00000000
> [134251.479079]  ffff88010cc2c840 0000000000000082 ffff880281179780 
> 0000000000013f40
> [134251.479082]  ffff88024678bfd8 ffff88024678bfd8 ffff88010cc2c840 
> ffff88028b633f40
> [134251.479084]  ffff88010cc2c840 ffff88024678bbc0 0000000000000002 
> ffffffff810c051f
> [134251.479087] Call Trace:
> [134251.479089]  [<ffffffff810c051f>] ? __lock_page+0x61/0x61
> [134251.479092]  [<ffffffff813858be>] ? io_schedule+0x54/0x69
> [134251.479094]  [<ffffffff810c0524>] ? sleep_on_page+0x5/0x8
> [134251.479096]  [<ffffffff813847c0>] ? __wait_on_bit_lock+0x3a/0x7e
> [134251.479098]  [<ffffffff810c051a>] ? __lock_page+0x5c/0x61
> [134251.479101]  [<ffffffff81057ca7>] ? autoremove_wake_function+0x2a/0x2a
> [134251.479105]  [<ffffffff810cb121>] ? 
> invalidate_inode_pages2_range+0x6a/0x226
> [134251.479111]  [<ffffffffa04e64af>] ? 
> cifs_invalidate_mapping+0x22/0x51 [cifs]
> [134251.479116]  [<ffffffffa04dce7a>] ? cifs_d_revalidate+0x17/0x88 [cifs]
> [134251.479119]  [<ffffffff81111ad0>] ? lookup_fast+0x17f/0x213
> [134251.479122]  [<ffffffff81111d7b>] ? walk_component+0x33/0x1a2
> [134251.479125]  [<ffffffff81112b39>] ? path_lookupat+0x8e/0x293
> [134251.479128]  [<ffffffff810fa52e>] ? kmem_cache_alloc+0x8c/0xfd
> [134251.479131]  [<ffffffff81112d5d>] ? filename_lookup+0x1f/0x73
> [134251.479133]  [<ffffffff81114efe>] ? user_path_at_empty+0x6f/0xa6
> [134251.479136]  [<ffffffff810f9498>] ? ____cache_alloc+0x1d3/0x290
> [134251.479138]  [<ffffffff8110d1f7>] ? vfs_fstatat+0x3e/0x8b
> [134251.479141]  [<ffffffff8109fb12>] ? __call_rcu.constprop.51+0xc2/0x1c6
> [134251.479143]  [<ffffffff8110d4bd>] ? SYSC_newlstat+0x10/0x29
> [134251.479147]  [<ffffffff8104f3f1>] ? SyS_prctl+0x104/0x32f
> [134251.479149]  [<ffffffff8138b529>] ? system_call_fastpath+0x16/0x1b
> [134251.479151] INFO: task pool:18384 blocked for more than 120 seconds.
> [134251.479153] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
> disables this message.
> [134251.479154] pool            D ffff88028b613f40     0 18384   5142 
> 0x00000000
> [134251.479156]  ffff88027c9c8800 0000000000000082 ffffffff81613400 
> 0000000000013f40
> [134251.479159]  ffff88024267dfd8 ffff88024267dfd8 ffff88027c9c8800 
> ffff88028b613f40
> [134251.479161]  ffff88027c9c8800 ffff88024267dbc0 0000000000000002 
> ffffffff810c051f
> [134251.479163] Call Trace:
> [134251.479166]  [<ffffffff810c051f>] ? __lock_page+0x61/0x61
> [134251.479168]  [<ffffffff813858be>] ? io_schedule+0x54/0x69
> [134251.479170]  [<ffffffff810c0524>] ? sleep_on_page+0x5/0x8
> [134251.479172]  [<ffffffff813847c0>] ? __wait_on_bit_lock+0x3a/0x7e
> [134251.479174]  [<ffffffff810c051a>] ? __lock_page+0x5c/0x61
> [134251.479177]  [<ffffffff81057ca7>] ? autoremove_wake_function+0x2a/0x2a
> [134251.479179]  [<ffffffff810cb121>] ? 
> invalidate_inode_pages2_range+0x6a/0x226
> [134251.479184]  [<ffffffffa04e64af>] ? 
> cifs_invalidate_mapping+0x22/0x51 [cifs]
> [134251.479189]  [<ffffffffa04dce7a>] ? cifs_d_revalidate+0x17/0x88 [cifs]
> [134251.479192]  [<ffffffff81111ad0>] ? lookup_fast+0x17f/0x213
> [134251.479195]  [<ffffffff81111d7b>] ? walk_component+0x33/0x1a2
> [134251.479197]  [<ffffffff81112b39>] ? path_lookupat+0x8e/0x293
> [134251.479200]  [<ffffffff810fa52e>] ? kmem_cache_alloc+0x8c/0xfd
> [134251.479203]  [<ffffffff81112d5d>] ? filename_lookup+0x1f/0x73
> [134251.479205]  [<ffffffff81114efe>] ? user_path_at_empty+0x6f/0xa6
> [134251.479208]  [<ffffffff8105f5ff>] ? __wake_up_sync_key+0x3d/0x55
> [134251.479211]  [<ffffffff810fa52e>] ? kmem_cache_alloc+0x8c/0xfd
> [134251.479213]  [<ffffffff8110d1f7>] ? vfs_fstatat+0x3e/0x8b
> [134251.479215]  [<ffffffff8109fb12>] ? __call_rcu.constprop.51+0xc2/0x1c6
> [134251.479217]  [<ffffffff8110d4bd>] ? SYSC_newlstat+0x10/0x29
> [134251.479220]  [<ffffffff8104f3f1>] ? SyS_prctl+0x104/0x32f
> [134251.479223]  [<ffffffff8138b529>] ? system_call_fastpath+0x16/0x1b
> [134251.479225] INFO: task pool:18385 blocked for more than 120 seconds.
> [134251.479226] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
> disables this message.
> [134251.479227] pool            D ffff88028b613f40     0 18385   5142 
> 0x00000000
> [134251.479229]  ffff8802427e9080 0000000000000082 ffffffff81613400 
> 0000000000013f40
> [134251.479232]  ffff88024674ffd8 ffff88024674ffd8 ffff8802427e9080 
> ffff88028b613f40
> [134251.479234]  ffff8802427e9080 ffff88024674fda8 ffffffff810c051f 
> 0000000000000002
> [134251.479236] Call Trace:
> [134251.479239]  [<ffffffff810c051f>] ? __lock_page+0x61/0x61
> [134251.479241]  [<ffffffff813858be>] ? io_schedule+0x54/0x69
> [134251.479243]  [<ffffffff810c0524>] ? sleep_on_page+0x5/0x8
> [134251.479245]  [<ffffffff813846dd>] ? __wait_on_bit+0x3b/0x6e
> [134251.479247]  [<ffffffff810c05ce>] ? wait_on_page_bit+0x69/0x6e
> [134251.479250]  [<ffffffff81057ca7>] ? autoremove_wake_function+0x2a/0x2a
> [134251.479252]  [<ffffffff810c0c7b>] ? filemap_fdatawait_range+0x65/0xfa
> [134251.479259]  [<ffffffffa04e6706>] ? cifs_getattr+0x45/0xe6 [cifs]
> [134251.479262]  [<ffffffff8110d208>] ? vfs_fstatat+0x4f/0x8b
> [134251.479264]  [<ffffffff8110d4bd>] ? SYSC_newlstat+0x10/0x29
> [134251.479267]  [<ffffffff8104f3f1>] ? SyS_prctl+0x104/0x32f
> [134251.479270]  [<ffffffff8138b529>] ? system_call_fastpath+0x16/0x1b
> [134251.479273] INFO: task cp-test:17969 blocked for more than 120 seconds.
> [134251.479275] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
> disables this message.
> [134251.479276] cp-test         D ffff88028b613f40     0 17969  16775 
> 0x00000000
> [134251.479278]  ffff880221270040 0000000000000086 ffffffff81613400 
> 0000000000013f40
> [134251.479281]  ffff88010cc85fd8 ffff88010cc85fd8 ffff880221270040 
> ffff88028b613f40
> [134251.479283]  ffff880221270040 ffff88010cc85e38 ffffffff810c051f 
> 0000000000000002
> [134251.479285] Call Trace:
> [134251.479288]  [<ffffffff810c051f>] ? __lock_page+0x61/0x61
> [134251.479290]  [<ffffffff813858be>] ? io_schedule+0x54/0x69
> [134251.479292]  [<ffffffff810c0524>] ? sleep_on_page+0x5/0x8
> [134251.479294]  [<ffffffff813846dd>] ? __wait_on_bit+0x3b/0x6e
> [134251.479296]  [<ffffffff810c05ce>] ? wait_on_page_bit+0x69/0x6e
> [134251.479299]  [<ffffffff81057ca7>] ? autoremove_wake_function+0x2a/0x2a
> [134251.479301]  [<ffffffff810c0c7b>] ? filemap_fdatawait_range+0x65/0xfa
> [134251.479304]  [<ffffffff810c22be>] ? filemap_write_and_wait+0x20/0x33
> [134251.479309]  [<ffffffffa04e2d79>] ? cifs_flush+0x1d/0x4d [cifs]
> [134251.479329]  [<ffffffff81107bc5>] ? filp_close+0x37/0x68
> [134251.479333]  [<ffffffff81108c82>] ? SyS_close+0x1a/0x3c
> [134251.479335]  [<ffffffff8138b529>] ? system_call_fastpath+0x16/0x1b
> [134371.629437] INFO: task kworker/0:166:17092 blocked for more than 120 
> seconds.
> [134371.629442] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
> disables this message.
> [134371.629445] kworker/0:166   D ffff88028b613f40     0 17092      2 
> 0x00000000
> [134371.629504] Workqueue: cifsiod cifs_oplock_break [cifs]
> [134371.629507]  ffff8800a3c54100 0000000000000046 ffffffff81613400 
> 0000000000013f40
> [134371.629511]  ffff88005e8a1fd8 ffff88005e8a1fd8 ffff8800a3c54100 
> ffff88028b613f40
> [134371.629515]  ffff8800a3c54100 ffff88005e8a1d28 ffffffff810c051f 
> 0000000000000002
> [134371.629518] Call Trace:
> [134371.629526]  [<ffffffff810c051f>] ? __lock_page+0x61/0x61
> [134371.629532]  [<ffffffff813858be>] ? io_schedule+0x54/0x69
> [134371.629535]  [<ffffffff810c0524>] ? sleep_on_page+0x5/0x8
> [134371.629538]  [<ffffffff813846dd>] ? __wait_on_bit+0x3b/0x6e
> [134371.629541]  [<ffffffff810c05ce>] ? wait_on_page_bit+0x69/0x6e
> [134371.629546]  [<ffffffff81057ca7>] ? autoremove_wake_function+0x2a/0x2a
> [134371.629549]  [<ffffffff810c0c7b>] ? filemap_fdatawait_range+0x65/0xfa
> [134371.629557]  [<ffffffffa04dec18>] ? cifs_oplock_break+0xd5/0x21d [cifs]
> [134371.629562]  [<ffffffff8105f74a>] ? finish_task_switch+0x81/0xaa
> [134371.629566]  [<ffffffff81052a71>] ? process_one_work+0x18b/0x28c
> [134371.629570]  [<ffffffff81052f1b>] ? worker_thread+0x121/0x1e7
> [134371.629573]  [<ffffffff81052dfa>] ? rescuer_thread+0x265/0x265
> [134371.629576]  [<ffffffff81057325>] ? kthread+0x7d/0x85
> [134371.629579]  [<ffffffff810572a8>] ? __kthread_parkme+0x59/0x59
> [134371.629583]  [<ffffffff8138b47c>] ? ret_from_fork+0x7c/0xb0
> [134371.629586]  [<ffffffff810572a8>] ? __kthread_parkme+0x59/0x59
> [134371.629596] INFO: task pool:17993 blocked for more than 120 seconds.
> [134371.629598] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
> disables this message.
> [134371.629600] pool            D ffff88028b613f40     0 17993   5142 
> 0x00000000
> [134371.629603]  ffff88027cbe6780 0000000000000082 ffffffff81613400 
> 0000000000013f40
> [134371.629606]  ffff880221259fd8 ffff880221259fd8 ffff88027cbe6780 
> ffff88028b613f40
> [134371.629609]  ffff88027cbe6780 ffff880221259bc0 ffffffff810c051f 
> 0000000000000002
> [134371.629613] Call Trace:
> [134371.629616]  [<ffffffff810c051f>] ? __lock_page+0x61/0x61
> [134371.629619]  [<ffffffff813858be>] ? io_schedule+0x54/0x69
> [134371.629622]  [<ffffffff810c0524>] ? sleep_on_page+0x5/0x8
> [134371.629625]  [<ffffffff813846dd>] ? __wait_on_bit+0x3b/0x6e
> [134371.629632]  [<ffffffff810c05ce>] ? wait_on_page_bit+0x69/0x6e
> [134371.629636]  [<ffffffff81057ca7>] ? autoremove_wake_function+0x2a/0x2a
> [134371.629641]  [<ffffffff810cb14b>] ? 
> invalidate_inode_pages2_range+0x94/0x226
> [134371.629649]  [<ffffffffa04e64af>] ? 
> cifs_invalidate_mapping+0x22/0x51 [cifs]
> [134371.629656]  [<ffffffffa04dce7a>] ? cifs_d_revalidate+0x17/0x88 [cifs]
> [134371.629661]  [<ffffffff81111ad0>] ? lookup_fast+0x17f/0x213
> [134371.629664]  [<ffffffff81111d7b>] ? walk_component+0x33/0x1a2
> [134371.629668]  [<ffffffff81112b39>] ? path_lookupat+0x8e/0x293
> [134371.629673]  [<ffffffff810fa52e>] ? kmem_cache_alloc+0x8c/0xfd
> [134371.629677]  [<ffffffff81112d5d>] ? filename_lookup+0x1f/0x73
> [134371.629680]  [<ffffffff81114efe>] ? user_path_at_empty+0x6f/0xa6
> [134371.629686]  [<ffffffff8107c8f5>] ? do_futex+0xd1/0x7b5
> [134371.629689]  [<ffffffff8110d1f7>] ? vfs_fstatat+0x3e/0x8b
> [134371.629692]  [<ffffffff8110d4bd>] ? SYSC_newlstat+0x10/0x29
> [134371.629696]  [<ffffffff8138b529>] ? system_call_fastpath+0x16/0x1b
> [134371.629699] INFO: task pool:18378 blocked for more than 120 seconds.
> [134371.629700] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
> disables this message.
> [134371.629702] pool            D ffff88028b633f40     0 18378   5142 
> 0x00000000
> [134371.629705]  ffff88010cc2c840 0000000000000082 ffff880281179780 
> 0000000000013f40
> [134371.629708]  ffff88024678bfd8 ffff88024678bfd8 ffff88010cc2c840 
> ffff88028b633f40
> [134371.629711]  ffff88010cc2c840 ffff88024678bbc0 0000000000000002 
> ffffffff810c051f
> [134371.629715] Call Trace:
> [134371.629717]  [<ffffffff810c051f>] ? __lock_page+0x61/0x61
> [134371.629721]  [<ffffffff813858be>] ? io_schedule+0x54/0x69
> [134371.629723]  [<ffffffff810c0524>] ? sleep_on_page+0x5/0x8
> [134371.629727]  [<ffffffff813847c0>] ? __wait_on_bit_lock+0x3a/0x7e
> [134371.629729]  [<ffffffff810c051a>] ? __lock_page+0x5c/0x61
> [134371.629732]  [<ffffffff81057ca7>] ? autoremove_wake_function+0x2a/0x2a
> [134371.629736]  [<ffffffff810cb121>] ? 
> invalidate_inode_pages2_range+0x6a/0x226
> [134371.629743]  [<ffffffffa04e64af>] ? 
> cifs_invalidate_mapping+0x22/0x51 [cifs]
> [134371.629749]  [<ffffffffa04dce7a>] ? cifs_d_revalidate+0x17/0x88 [cifs]
> [134371.629753]  [<ffffffff81111ad0>] ? lookup_fast+0x17f/0x213
> [134371.629757]  [<ffffffff81111d7b>] ? walk_component+0x33/0x1a2
> [134371.629760]  [<ffffffff81112b39>] ? path_lookupat+0x8e/0x293
> [134371.629764]  [<ffffffff810fa52e>] ? kmem_cache_alloc+0x8c/0xfd
> [134371.629768]  [<ffffffff81112d5d>] ? filename_lookup+0x1f/0x73
> [134371.629770]  [<ffffffff81114efe>] ? user_path_at_empty+0x6f/0xa6
> [134371.629775]  [<ffffffff810f9498>] ? ____cache_alloc+0x1d3/0x290
> [134371.629777]  [<ffffffff8110d1f7>] ? vfs_fstatat+0x3e/0x8b
> [134371.629781]  [<ffffffff8109fb12>] ? __call_rcu.constprop.51+0xc2/0x1c6
> [134371.629784]  [<ffffffff8110d4bd>] ? SYSC_newlstat+0x10/0x29
> [134371.629788]  [<ffffffff8104f3f1>] ? SyS_prctl+0x104/0x32f
> [134371.629792]  [<ffffffff8138b529>] ? system_call_fastpath+0x16/0x1b
> [134371.629794] INFO: task pool:18384 blocked for more than 120 seconds.
> [134371.629796] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
> disables this message.
> [134371.629798] pool            D ffff88028b613f40     0 18384   5142 
> 0x00000000
> [134371.629801]  ffff88027c9c8800 0000000000000082 ffffffff81613400 
> 0000000000013f40
> [134371.629804]  ffff88024267dfd8 ffff88024267dfd8 ffff88027c9c8800 
> ffff88028b613f40
> [134371.629807]  ffff88027c9c8800 ffff88024267dbc0 0000000000000002 
> ffffffff810c051f
> [134371.629811] Call Trace:
> [134371.629813]  [<ffffffff810c051f>] ? __lock_page+0x61/0x61
> [134371.629817]  [<ffffffff813858be>] ? io_schedule+0x54/0x69
> [134371.629819]  [<ffffffff810c0524>] ? sleep_on_page+0x5/0x8
> [134371.629822]  [<ffffffff813847c0>] ? __wait_on_bit_lock+0x3a/0x7e
> [134371.629825]  [<ffffffff810c051a>] ? __lock_page+0x5c/0x61
> [134371.629828]  [<ffffffff81057ca7>] ? autoremove_wake_function+0x2a/0x2a
> [134371.629831]  [<ffffffff810cb121>] ? 
> invalidate_inode_pages2_range+0x6a/0x226
> [134371.629838]  [<ffffffffa04e64af>] ? 
> cifs_invalidate_mapping+0x22/0x51 [cifs]
> [134371.629846]  [<ffffffffa04dce7a>] ? cifs_d_revalidate+0x17/0x88 [cifs]
> [134371.629850]  [<ffffffff81111ad0>] ? lookup_fast+0x17f/0x213
> [134371.629854]  [<ffffffff81111d7b>] ? walk_component+0x33/0x1a2
> [134371.629857]  [<ffffffff81112b39>] ? path_lookupat+0x8e/0x293
> [134371.629861]  [<ffffffff810fa52e>] ? kmem_cache_alloc+0x8c/0xfd
> [134371.629865]  [<ffffffff81112d5d>] ? filename_lookup+0x1f/0x73
> [134371.629868]  [<ffffffff81114efe>] ? user_path_at_empty+0x6f/0xa6
> [134371.629871]  [<ffffffff8105f5ff>] ? __wake_up_sync_key+0x3d/0x55
> [134371.629875]  [<ffffffff810fa52e>] ? kmem_cache_alloc+0x8c/0xfd
> [134371.629878]  [<ffffffff8110d1f7>] ? vfs_fstatat+0x3e/0x8b
> [134371.629881]  [<ffffffff8109fb12>] ? __call_rcu.constprop.51+0xc2/0x1c6
> [134371.629884]  [<ffffffff8110d4bd>] ? SYSC_newlstat+0x10/0x29
> [134371.629888]  [<ffffffff8104f3f1>] ? SyS_prctl+0x104/0x32f
> [134371.629891]  [<ffffffff8138b529>] ? system_call_fastpath+0x16/0x1b
> [184501.155185] CIFS VFS: Server 192.168.0.112 has not responded in 120 
> seconds. Reconnecting...
> 
> 		**** But now after this, the test program copying a file from the other
> 		     gets stuck in D state and cannot be killed.
> 		     I think only reboot will remedy this situation.
> 

Most of these processes are stuck trying to lock a page to either
invalidate it, or to perform writeback. That implies that something else is holding the lock on that page.

> Hope this helps.
> 
> Even if this could be triggered by flakey windows 7 CIFS-share issues,
> I think it is worthwhile to make CIFS driver robust in such situations.
> 

Me too -- easier said than done ;)

> I am keeping this linux running in this manner and so
> let me know if you need some runtime information which can be gleaned by
> some means (like system trace, etc.). Please advise how to obtain the 
> information in that case (the particular command to obtain the desired 
> value will be useful.)
> 

I think what's missing here is some information about what's actually
happening on the network when you try to recontact the server.

When you bring the interface back up, does the client ever send a SYN
back to the server? If so, does the server respond?

Also, what is cifsd (the kernel thread that handles receives) doing at
this point? I'd expect it to be trying to reconnect to the server...

What kernel version is this too, btw?

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
