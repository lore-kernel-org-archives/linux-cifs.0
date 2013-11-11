From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: btrfs clone ordering of mutex
Date: Mon, 11 Nov 2013 15:50:18 -0600
Message-ID: <CAH2r5msK0=D3u_Xic4mU85NhaBaARW3q3wcE_OtoFRF3gdGRww@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Chris Mason <chris.mason-5c4llco8/ftWk0Htik3J/w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Pavel pointed out (as we were discussing clone) that this mutex
locking sequence in btrfs_ioctl_clone in btrfs/ioctl.c will unlock the
mutexes in the wrong order much of the time.  Shouldn't the unlock of
two mutexes be done in the reverse order from the lock of the mutexes
to avoid other users of these mutexes potentially deadlocking?  See
this small section of btrfs_ioctl_clone

    if (!same_inode) {
        if (inode < src) {
            mutex_lock_nested(&inode->i_mutex, I_MUTEX_PARENT);
            mutex_lock_nested(&src->i_mutex, I_MUTEX_CHILD);
        } else {
            mutex_lock_nested(&src->i_mutex, I_MUTEX_PARENT);
            mutex_lock_nested(&inode->i_mutex, I_MUTEX_CHILD);
        }
    } else {
        mutex_lock(&src->i_mutex);
    }

followed by:

    mutex_unlock(&src->i_mutex);
    if (!same_inode)
        mutex_unlock(&inode->i_mutex);

-- 
Thanks,

Steve
