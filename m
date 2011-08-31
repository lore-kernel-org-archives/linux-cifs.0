From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: wait_event_freezable variant for TASK_KILLABLE?
Date: Wed, 31 Aug 2011 08:44:00 -0400
Message-ID: <20110831084400.1908dada@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-pm-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I had a bug reported a while back that cifs mounts were preventing
machines from suspending. I can reproduce this pretty readily by simply
making a cifs mount, leaving it idle for a bit (so that the root dentry
will need to be revalidated) and then attempting to suspend the
machine. When I do that I get the following backtrace:

[ 5323.278130] PM: Syncing filesystems ... done.
[ 5323.313956] PM: Preparing system for mem sleep
[ 5323.435457] Freezing user space processes ... 
[ 5343.444237] Freezing of tasks failed after 20.00 seconds (1 tasks refusing to freeze, wq_busy=0):
[ 5343.444335] umount          D ffff88011075dc00     0  7400   7383 0x00800084
[ 5343.444342]  ffff8800c95e1b08 0000000000000086 ffff8800c95e1b40 ffff880000000001
[ 5343.444348]  ffff880117965cc0 ffff8800c95e1fd8 ffff8800c95e1fd8 0000000000012540
[ 5343.444354]  ffff8800d5d5c590 ffff880117965cc0 ffff8800c95e1b18 00000001c95e1ad8
[ 5343.444359] Call Trace:
[ 5343.444378]  [<ffffffffa044f0ca>] wait_for_response+0x199/0x19e [cifs]
[ 5343.444384]  [<ffffffff81070566>] ? remove_wait_queue+0x3a/0x3a
[ 5343.444392]  [<ffffffffa044fe93>] SendReceive+0x184/0x285 [cifs]
[ 5343.444399]  [<ffffffffa043a51e>] CIFSSMBUnixQPathInfo+0x167/0x212 [cifs]
[ 5343.444407]  [<ffffffffa044ae90>] cifs_get_inode_info_unix+0x8e/0x165 [cifs]
[ 5343.444414]  [<ffffffffa0444223>] ? build_path_from_dentry+0xe2/0x20d [cifs]
[ 5343.444418]  [<ffffffff8111673e>] ? __kmalloc+0x103/0x115
[ 5343.444425]  [<ffffffffa0444223>] ? build_path_from_dentry+0xe2/0x20d [cifs]
[ 5343.444431]  [<ffffffffa0444223>] ? build_path_from_dentry+0xe2/0x20d [cifs]
[ 5343.444439]  [<ffffffffa044c11d>] cifs_revalidate_dentry_attr+0x10b/0x172 [cifs]
[ 5343.444447]  [<ffffffffa044c259>] cifs_getattr+0x7a/0xfc [cifs]
[ 5343.444451]  [<ffffffff8112a9f7>] vfs_getattr+0x45/0x63
[ 5343.444454]  [<ffffffff8112aa6d>] vfs_fstatat+0x58/0x6e
[ 5343.444457]  [<ffffffff8112aabe>] vfs_stat+0x1b/0x1d
[ 5343.444460]  [<ffffffff8112abbd>] sys_newstat+0x1a/0x33
[ 5343.444463]  [<ffffffff8112f9e8>] ? path_put+0x20/0x24
[ 5343.444466]  [<ffffffff810a0e84>] ? audit_syscall_entry+0x145/0x171
[ 5343.444469]  [<ffffffff811302d1>] ? putname+0x34/0x36
[ 5343.444473]  [<ffffffff8148e842>] system_call_fastpath+0x16/0x1b
[ 5343.444476] 
[ 5343.444477] Restarting tasks ... done.

wait_for_response basically does this to put a task to sleep while it's
waiting for the server to respond:

        error = wait_event_killable(server->response_q,
                                    midQ->midState != MID_REQUEST_SUBMITTED);

NFS does similar sorts of things, and I think it has similar problems
with the freezer.

The problem there is pretty clear. That won't wake up unless you send
it a fatal signal, and we need it to wake up and freeze in that
situation. So, I made a stab at rolling a wait_event_freezekillable()
macro, based on wait_event_freezable.

-----------------------[snip]-----------------------------

#define wait_event_freezekillable(wq, condition)                        \
({                                                                      \
        int __retval;                                                   \
        do {                                                            \
                __retval = wait_event_killable(wq,                      \
                                (condition) || freezing(current));      \
                if (__retval && !freezing(current))                     \
                        break;                                          \
                else if (!(condition))                                  \
                        __retval = -ERESTARTSYS;                        \
        } while (try_to_freeze());                                      \
        __retval;                                                       \
})

-----------------------[snip]-----------------------------

However, I still got the same problem when trying to put the task to
sleep. I could dig in and try to figure out why this isn't working like
I expect, but I figured I'd ask here first to see if I can determine
whether linux-pm has advice on how best to approach this. :)

Basically, what we'd like is something akin to wait_event_freezable,
but that only returns -ERESTARTSYS on fatal signals (SIGKILL).

Thoughts?
-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
