From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: next patches to merge into for-next
Date: Mon, 23 Jul 2012 16:40:32 -0500
Message-ID: <CAH2r5mska-RYVR8zizNs7eYhua_hOhj=MNe4sVrMeDSEWTR_OQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Pavel,
I merged five of jeff's patches into the for-next branch, and plan to
merge the first group of (already reviewed) ones of Pavel's but not
sure yet where we will start hitting merge conflicts (Al's patches are
already in, but perhaps with Jeff's patches).

762a4206a3f415db0fcf2c7aed9a5e91deff221d cifs: rename cifs_sign_smb2
to cifs_sign_smbv
d971e0656bf6e57925292dae755d36fb3c5b093d cifs: remove bogus reset of
smb_buf_length in smb_send routines
c5fd363d771393a7b42bbbe051f30f97d4867a40 cifs: move file_lock off
stack in cifs_push_posix_locks
ac3aa2f8ae29c186c4742d15e39712af417c6d68 cifs: remove extraneous
newlines from cERROR and cFYI calls
00401ff780c58b9dabffef668386c206efc71c7c cifs: after upcalling for
krb5 creds, invalidate key rather than revoking it


-- 
Thanks,

Steve
