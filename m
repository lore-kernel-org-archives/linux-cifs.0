From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: on multiuser mount, set ownership to
 current_fsuid/current_fsgid (try #5)
Date: Fri, 8 Oct 2010 10:33:47 -0500
Message-ID: <AANLkTi=TeqVrP1dgp1Tw9Thy2JzPAC8bT3=mcgY_4yZ1@mail.gmail.com>
References: <1286477188-26681-1-git-send-email-jlayton@redhat.com>
	<AANLkTimTO_aBJFm==qLkRhXG-LVbMH7CqCdFhkxHAhCB@mail.gmail.com>
	<20101008071137.45a4e27c@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101008071137.45a4e27c-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Oct 8, 2010 at 6:11 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Thu, 7 Oct 2010 22:25:23 -0500
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> One case does seem strange - I forgot what happens when you specify a
>> mnt_uid of 0 (root)
>>
>
> Oof, you're right... we should base this on CIFS_MOUNT_OVERR_UID and
> CIFS_MOUNT_OVERR_GID flags instead. I'll send a fixed patch once I've
> tested it.
>
> Now that I think about this though, maybe we shouldn't do this based on
> CIFS_MOUNT_MULTIUSER but instead on CIFS_MOUNT_NO_PERM? It would mean
> a behavior change for anyone currently "-o noperm" on a mount without
> unix extensions but I think it would make a bit more sense than special
> casing CIFS_MOUNT_MULTIUSER here.

When the MOUNT_NO_PERM is not set (ie where both client and server
evaluate permissions) I agree that it doesn't make sense to change
uids on the fly (to current_fsuid) since it becomes almost meaningless
to set and evaluate a mode if we are always owner.   For the case
where you MOUNT_NO_PERM, I lean toward the following heirarchy:

1) report the uid owner that the admin tells us to report.  In some
cases admins won't know what they are doing, and won't know when to
set a uid on mount, but if we want to help the admin decide whether to
override it or not, we could do the warnings in the user space
helpers.

... if no uid specified on mount then:

2) report the "correct" uid if we can
    - if the unix extensions are on (eventually we can do the
"WHO_AM_I" cifs unix extension call and/or use the domain name of the
server and/or winbind upcall as hints to see if we are not in the same
uid namespace).
   - when we have an upcall to winbind or uid mapping info, we can do
this for Windows servers as well

... if no uid specified on mount and we don't know the right uids

3) report a "default uid"
    - for the noperm multiuser case we could report the current user,
seems reasonable
   - for the case where it is noperm but not multiuser, we are sending
the mount users credentials on every operation, so new files will be
created as that user - probably better to still report the user who
did the mount as owner since those are the credentials used
    - otherwise whoever did the mount is the default user

-- 
Thanks,

Steve
