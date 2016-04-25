From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC][PATCHSET] reduce messing with iovecs in cifs
Date: Sun, 24 Apr 2016 22:22:34 -0500
Message-ID: <CAH2r5msj7oxce-XJXk-ntQM6tv4aBcQGhyJYb=21Z3AhSq3QcQ@mail.gmail.com>
References: <20160409204301.GF25498@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160409204301.GF25498-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Reviewed-by: Steve French <steve.french-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>

Let me know if you want any of them to go in via the cifs tree or
prefer going in through your tree (other than patch 1 which could go
in the net-next tree are you indicated)

On Sat, Apr 9, 2016 at 3:43 PM, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org> wrote:
>         Now that sendmsg/recvmsg do not mangle iovecs and are capable of
> handling bvec-based ->msg_iter, we can seriously reduce the amount of PITA
> in cifs.  The series below is completely untested, and I would appreciate
> comments/review/testing/etc.
>
> I'll post the individual patches in followups; for those who prefer to use
> git it can be found in
> git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git sendmsg.cifs
>
> 1/6: [net] drop 'size' argument of sock_recvmsg()
>         should go via net-next; does what it says.
>
> 2/6: cifs: merge the hash calculation helpers
>         takes the common parts of {cifs,smb2,smb3}_calc_signature() into a
> common helper.
>
> 3/6: cifs: quit playing games with draining iovecs
>         Switch smb_send_kvec() to passing msghdr (and thus iov_iter) and
> make it use sock_sendmsg() - that allows to avoid draining iovecs, since
> ->msg_iter will be advanced properly and all we need is to keep it around
> between the calls of sock_sendmsg(), rather than reinitializing it on each
> loop iteration.  The same thing allows to get rid of messing with kmap()
> when sending the stuff in ->rq_pages[] - ITER_BVEC will do the right thing.
>
> 4/6: cifs: no need to wank with copying and advancing iovec on recvmsg side either
>         Similar to the previous - use sock_recvmsg() in cifs_readv_from_socket()
> and there's no need to modify iovecs, or allocate a copy especially for
> such modifications, etc.
>
> 5/6: cifs_readv_receive: use cifs_read_from_socket()
>         building a 1-element iovec array for cifs_readv_from_socket() is
> an overkill - simple cifs_read_from_socket() will do just fine.
>
> 6/6: cifs: don't bother with kmap on read_pages side
>         Similar to the other half of 3/6: we can use ITER_BVEC for
> read-into-page case.  Just make cifs_readv_from_socket() take msghdr from
> caller and use a helper that would feed it a bvec-backed ->msg_iter.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
