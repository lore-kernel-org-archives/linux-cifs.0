From: David McBride <dwm37-KWPb1pKIrIJaa/9Udqfwiw@public.gmane.org>
Subject: Re: Hanging cifsiod / OpLock break problems
Date: Fri, 2 Oct 2015 11:10:56 +0100
Message-ID: <560E5830.30201@cam.ac.uk>
References: <zarafa.54f57dff.559b.17aa37831ab590f0@zarafa.ed-chemnitz.de>
 <CADT32e+hRaX7PbvJ9PJJxE1jhd8vNJkFZnyOjg6k62jEvMw0Eg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Tobias Doerffel <tobias.doerffel-2LT3hlbiLj/X2ID+q72mRQ@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32e+hRaX7PbvJ9PJJxE1jhd8vNJkFZnyOjg6k62jEvMw0Eg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 04/03/15 03:08, Shirish Pargaonkar wrote:
> Steven Rostedt had posted a patch on 3/21/2014 on the cifs mailing list
> that might be helpful here.
> 
>  Link: http://lkml.kernel.org/r/20140319151252.16ed3ac6-f9ZlEuEWxVcJvu8Pb33WZ0EMvNT87kid@public.gmane.org
> 
> On Tue, Mar 3, 2015 at 3:25 AM, Tobias Doerffel <tobias.doerffel-2LT3hlbiLj/X2ID+q72mRQ@public.gmane.org> wrote:
>> Hi,
>>
>> we're having constant issues with CIFS mounts on our Linux terminal servers (Ubuntu 12.04 with updated kernel). Usually after 1 or 2 days we see the following in dmesg:

Hello,

I've got some servers operating in a similar configuration --- remote
login servers, running Ubuntu 14.04 (rather than 12.04), with cifs
automounts to a (Windows, not Samba) fileserver for home directories ---
and I've been seeing similar issues under load.

An example mount looks like:

//filestore/d/dwm37 on /home/dwm37 type cifs
(rw,relatime,vers=1.0,sec=ntlmssp,cache=strict,multiuser,domain=DOMAIN,uid=0,noforceuid,gid=0,noforcegid,addr=1.2.3.4,file_mode=0700,dir_mode=0700,nounix,mapchars,nobrl,mfsymlinks,noperm,rsize=61440,wsize=65536,actimeo=1)

(The user's session keyring is automatically populated with their
passphrase on login, allowing them to access mounts as themselves using
strong-authentication.)

An example trace for the deadlock I'm seeing is:

> [389388.350684] INFO: task cifsiod:2810 blocked for more than 120 seconds.
> [389388.351032]       Tainted: G         C     3.19.0-28-generic #30~14.04.1-Ubuntu
> [389388.351221] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [389388.351401] cifsiod         D ffff88012496fbb8     0  2810      2 0x00000000
> [389388.351418] Workqueue: cifsiod cifs_oplock_break [cifs]
> [389388.351420]  ffff88012496fbb8 ffff880095916bf0 0000000000013e80 ffff88012496ffd8
> [389388.351423]  0000000000013e80 ffff8800351c13a0 ffff880095916bf0 ffff88012496fc60
> [389388.351425]  ffff88013fd14778 ffff88012496fc60 ffff88013ffdc2e8 0000000000000002
> [389388.351427] Call Trace:
> [389388.351434]  [<ffffffff817b2ef0>] ? bit_wait+0x50/0x50
> [389388.351437]  [<ffffffff817b26c0>] io_schedule+0xa0/0x130
> [389388.351439]  [<ffffffff817b2f1c>] bit_wait_io+0x2c/0x50
> [389388.351442]  [<ffffffff817b2b55>] __wait_on_bit+0x65/0x90
> [389388.351446]  [<ffffffff8117667d>] ? find_get_pages_tag+0xcd/0x170
> [389388.351449]  [<ffffffff81175657>] wait_on_page_bit+0xc7/0xd0
> [389388.351453]  [<ffffffff810b4e50>] ? autoremove_wake_function+0x40/0x40
> [389388.351456]  [<ffffffff81175759>] filemap_fdatawait_range+0xf9/0x190
> [389388.351459]  [<ffffffff811822de>] ? do_writepages+0x1e/0x40
> [389388.351462]  [<ffffffff81177599>] ? __filemap_fdatawrite_range+0x59/0x60
> [389388.351464]  [<ffffffff81175817>] filemap_fdatawait+0x27/0x30
> [389388.351471]  [<ffffffffc06a12b1>] cifs_oplock_break+0x301/0x340 [cifs]
> [389388.351475]  [<ffffffff8108db6f>] process_one_work+0x14f/0x400
> [389388.351478]  [<ffffffff8108dfbc>] rescuer_thread+0x19c/0x3d0
> [389388.351480]  [<ffffffff8108de20>] ? process_one_work+0x400/0x400
> [389388.351483]  [<ffffffff81093802>] kthread+0xd2/0xf0
> [389388.351486]  [<ffffffff81093730>] ? kthread_create_on_node+0x1c0/0x1c0
> [389388.351489]  [<ffffffff817b6698>] ret_from_fork+0x58/0x90
> [389388.351492]  [<ffffffff81093730>] ? kthread_create_on_node+0x1c0/0x1c0

Which looks extremely similar to the one Tobias reported.

To try to diagnose the problem further, I took the Ubuntu kernel
source-package for the kernel we're running, enabled
CONFIG_PROVE_LOCKING and related options, and rebuilt it using `make
deb-pkg` --- and have been running it on one of our remote-login machines.

(Despite concerns about the performance overhead of this option, it
appears to be perfectly adequate in practice.)

And lo, lockdep triggered overnight:

> [73551.456398] ======================================================
> [73551.456426] [ INFO: possible circular locking dependency detected ]
> [73551.456455] 3.19.8-ckt6 #1 Tainted: G         C  E 
> [73551.456477] -------------------------------------------------------
> [73551.456504] rsync/20306 is trying to acquire lock:
> [73551.456527]  ((&cfile->oplock_break)){+.+.+.}, at: [<ffffffff8108f985>] flush_work+0x5/0x280
> [73551.456584] 
> [73551.456584] but task is already holding lock:
> [73551.456610]  (&sb->s_type->i_mutex_key#19){+.+.+.}, at: [<ffffffff812007aa>] chmod_common+0x6a/0x150
> [73551.456661] 
> [73551.456661] which lock already depends on the new lock.
> [73551.456661] 
> [73551.457458] 
> [73551.457458] the existing dependency chain (in reverse order) is:
> [73551.458879] 
> [73551.458879] -> #2 (&sb->s_type->i_mutex_key#19){+.+.+.}:
> [73551.460298]        [<ffffffff810c6b20>] lock_acquire+0xa0/0x120
> [73551.461016]        [<ffffffff817ee486>] mutex_lock_nested+0x56/0x4d0
> [73551.461737]        [<ffffffffc089f95d>] cifs_strict_writev+0xfd/0x280 [cifs]
> [73551.462465]        [<ffffffff81202501>] new_sync_write+0x81/0xb0
> [73551.463178]        [<ffffffff81202cfa>] vfs_write+0xba/0x1f0
> [73551.463872]        [<ffffffff81203929>] SyS_write+0x49/0xb0
> [73551.464549]        [<ffffffff817f190d>] system_call_fastpath+0x16/0x1b
> [73551.465224] 
> [73551.465224] -> #1 (&cifsi->lock_sem){++++++}:
> [73551.466563]        [<ffffffff810c6b20>] lock_acquire+0xa0/0x120
> [73551.467220]        [<ffffffff817ef2f7>] down_write+0x47/0xb0
> [73551.467869]        [<ffffffffc089863d>] cifs_oplock_break+0xfd/0x380 [cifs]
> [73551.468524]        [<ffffffff81090d52>] process_one_work+0x1c2/0x4a0
> [73551.469167]        [<ffffffff81091151>] worker_thread+0x121/0x450
> [73551.469806]        [<ffffffff810965d9>] kthread+0xf9/0x110
> [73551.470427]        [<ffffffff817f1858>] ret_from_fork+0x58/0x90
> [73551.471048] 
> [73551.471048] -> #0 ((&cfile->oplock_break)){+.+.+.}:
> [73551.472224]        [<ffffffff810c62ae>] __lock_acquire+0x192e/0x1a20
> [73551.472833]        [<ffffffff810c6b20>] lock_acquire+0xa0/0x120
> [73551.473430]        [<ffffffff8108f9cc>] flush_work+0x4c/0x280
> [73551.474017]        [<ffffffff81090650>] __cancel_work_timer+0xa0/0x1d0
> [73551.474660]        [<ffffffff81090790>] cancel_work_sync+0x10/0x20
> [73551.475247]        [<ffffffffc089bba2>] cifsFileInfo_put+0x142/0x3e0 [cifs]
> [73551.475841]        [<ffffffffc08b247d>] smb_set_file_info+0xbd/0x290 [cifs]
> [73551.476413]        [<ffffffffc08a339a>] cifs_set_file_info+0xaa/0x180 [cifs]
> [73551.476979]        [<ffffffffc08a4fe5>] cifs_setattr+0x475/0x980 [cifs]
> [73551.477538]        [<ffffffff812215c1>] notify_change+0x231/0x390
> [73551.478076]        [<ffffffff8120085f>] chmod_common+0x11f/0x150
> [73551.478594]        [<ffffffff81201545>] SyS_chmod+0x45/0xa0
> [73551.479115]        [<ffffffff817f190d>] system_call_fastpath+0x16/0x1b
> [73551.479646] 
> [73551.479646] other info that might help us debug this:
> [73551.479646] 
> [73551.481191] Chain exists of:
> [73551.481191]   (&cfile->oplock_break) --> &cifsi->lock_sem --> &sb->s_type->i_mutex_key#19
> [73551.481191] 
> [73551.482752]  Possible unsafe locking scenario:
> [73551.482752] 
> [73551.483797]        CPU0                    CPU1
> [73551.484311]        ----                    ----
> [73551.484819]   lock(&sb->s_type->i_mutex_key#19);
> [73551.485339]                                lock(&cifsi->lock_sem);
> [73551.485874]                                lock(&sb->s_type->i_mutex_key#19);
> [73551.486400]   lock((&cfile->oplock_break));
> [73551.486930] 
> [73551.486930]  *** DEADLOCK ***
> [73551.486930] 
> [73551.488410] 2 locks held by rsync/20306:
> [73551.488899]  #0:  (sb_writers#17){.+.+.+}, at: [<ffffffff81225b04>] mnt_want_write+0x24/0x50
> [73551.489432]  #1:  (&sb->s_type->i_mutex_key#19){+.+.+.}, at: [<ffffffff812007aa>] chmod_common+0x6a/0x150
> [73551.490513] 
> [73551.490513] stack backtrace:
> [73551.491547] CPU: 0 PID: 20306 Comm: rsync Tainted: G         C  E  3.19.8-ckt6 #1
> [73551.492079] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 04/14/2014
> [73551.493184]  ffffffff82889790 ffff88000a9278a8 ffffffff817e77f1 0000000000000000
> [73551.493772]  ffffffff82889f50 ffff88000a9278f8 ffffffff817e2d3f ffff88000a9278c8
> [73551.494358]  ffff88000a927948 ffff880004921ea8 ffff8800049215f0 ffff880004921ea8
> [73551.494941] Call Trace:
> [73551.495524]  [<ffffffff817e77f1>] dump_stack+0x45/0x57
> [73551.496108]  [<ffffffff817e2d3f>] print_circular_bug+0x1fb/0x20c
> [73551.496703]  [<ffffffff810c62ae>] __lock_acquire+0x192e/0x1a20
> [73551.497290]  [<ffffffff810c6b20>] lock_acquire+0xa0/0x120
> [73551.497874]  [<ffffffff8108f985>] ? flush_work+0x5/0x280
> [73551.498456]  [<ffffffff8108f9cc>] flush_work+0x4c/0x280
> [73551.499035]  [<ffffffff8108f985>] ? flush_work+0x5/0x280
> [73551.499613]  [<ffffffff810c4355>] ? mark_held_locks+0x75/0xa0
> [73551.500186]  [<ffffffff817f0d76>] ? _raw_spin_unlock_irqrestore+0x36/0x60
> [73551.500766]  [<ffffffff810c4355>] ? mark_held_locks+0x75/0xa0
> [73551.501349]  [<ffffffff810906b5>] ? __cancel_work_timer+0x105/0x1d0
> [73551.501923]  [<ffffffff81090650>] __cancel_work_timer+0xa0/0x1d0
> [73551.502486]  [<ffffffff81090790>] cancel_work_sync+0x10/0x20
> [73551.503056]  [<ffffffffc089bba2>] cifsFileInfo_put+0x142/0x3e0 [cifs]
> [73551.503625]  [<ffffffffc088cac8>] ? CIFSSMBSetFileInfo+0x188/0x210 [cifs]
> [73551.504205]  [<ffffffffc088cac8>] ? CIFSSMBSetFileInfo+0x188/0x210 [cifs]
> [73551.504779]  [<ffffffff8118a025>] ? find_get_pages_tag+0x25/0x1c0
> [73551.505359]  [<ffffffffc08b247d>] smb_set_file_info+0xbd/0x290 [cifs]
> [73551.505938]  [<ffffffff811973f5>] ? pagevec_lookup_tag+0x25/0x40
> [73551.506519]  [<ffffffff81188b1b>] ? filemap_fdatawait_range+0x13b/0x190
> [73551.507096]  [<ffffffffc08a339a>] cifs_set_file_info+0xaa/0x180 [cifs]
> [73551.507673]  [<ffffffff811963d1>] ? do_writepages+0x21/0x50
> [73551.508262]  [<ffffffffc08a4fe5>] cifs_setattr+0x475/0x980 [cifs]
> [73551.508857]  [<ffffffff8137f371>] ? evm_inode_setattr+0x21/0x70
> [73551.509452]  [<ffffffff810e7f96>] ? current_fs_time+0x16/0x60
> [73551.510039]  [<ffffffff810c454d>] ? trace_hardirqs_on+0xd/0x10
> [73551.510607]  [<ffffffff812215c1>] notify_change+0x231/0x390
> [73551.511154]  [<ffffffff8120085f>] chmod_common+0x11f/0x150
> [73551.511709]  [<ffffffff81201545>] SyS_chmod+0x45/0xa0
> [73551.512267]  [<ffffffff817f190d>] system_call_fastpath+0x16/0x1b

I'm not sufficiently familiar with the cifs internals to be able to
immediately see whether this is a real scenario, or whether the patch
posted previously by Steven Rostedt will likely address it.

Hopefully this information can advance understanding of this problem?

Kind regards,
David
-- 
David McBride <dwm37-KWPb1pKIrIJaa/9Udqfwiw@public.gmane.org>
Unix Specialist, University Information Services
