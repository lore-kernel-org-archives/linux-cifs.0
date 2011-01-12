From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Suspend failed - unable to freeze cifsd
Date: Wed, 12 Jan 2011 10:42:05 -0600
Message-ID: <AANLkTimCX-dkGm6wxo7Aa+Y92ycO7qxjAT9mq57UEb2v@mail.gmail.com>
References: <20110112103422.53368ef0@pluto-lenny.milky.way>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Benjamin S." <da_joind-hi6Y0CQ0nG0@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110112103422.53368ef0-maVnLcQnVqUWzmpQbccHSn8LRjgxFanY@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

What is the kernel version ("cat /proc/version")

On Wed, Jan 12, 2011 at 3:34 AM, Benjamin S. <da_joind-hi6Y0CQ0nG0@public.gmane.org> wrote:
>
>
> dmesg Output after I have tried to suspend my computer:
>
> [334447.728980] [drm:i915_gem_mmap_gtt_ioctl] *ERROR* Attempting to m=
map a purgeable buffer
> [334447.729525] [drm:i915_gem_mmap_gtt_ioctl] *ERROR* Attempting to m=
map a purgeable buffer
> [334447.729571] [drm:i915_gem_mmap_gtt_ioctl] *ERROR* Attempting to m=
map a purgeable buffer
> [334447.729979] [drm:i915_gem_mmap_gtt_ioctl] *ERROR* Attempting to m=
map a purgeable buffer
> [334447.730806] [drm:i915_gem_mmap_gtt_ioctl] *ERROR* Attempting to m=
map a purgeable buffer
> [334447.730853] [drm:i915_gem_mmap_gtt_ioctl] *ERROR* Attempting to m=
map a purgeable buffer
> [334447.730918] [drm:i915_gem_mmap_gtt_ioctl] *ERROR* Attempting to m=
map a purgeable buffer
> [334447.734428] [drm:i915_gem_mmap_gtt_ioctl] *ERROR* Attempting to m=
map a purgeable buffer
> [334447.734465] [drm:i915_gem_mmap_gtt_ioctl] *ERROR* Attempting to m=
map a purgeable buffer
> [347809.421490] PM: Syncing filesystems ... done.
> [347809.647465] Freezing user space processes ... (elapsed 0.01 secon=
ds) done.
> [347809.663090] Freezing remaining freezable tasks ...
> [347829.678854] Freezing of tasks failed after 20.01 seconds (1 tasks=
 refusing to freeze, wq_busy=3D0):
> [347829.678873] cifsd =A0 =A0 =A0 =A0 S ffff880127f7b1b0 =A0 =A0 0 =A0=
1821 =A0 =A0 =A02 0x00800000
> [347829.678883] =A0ffff880127f7b1b0 0000000000000046 ffff88005fe008a8=
 ffff8800ffffffff
> [347829.678890] =A0ffff880127cee6b0 0000000000011100 ffff880127737fd8=
 0000000000004000
> [347829.678897] =A0ffff880127737fd8 0000000000011100 ffff880127f7b1b0=
 ffff880127736010
> [347829.678904] Call Trace:
> [347829.678915] =A0[<ffffffff811e85dd>] ? sk_reset_timer+0xf/0x19
> [347829.678921] =A0[<ffffffff8122cf3f>] ? tcp_connect+0x43c/0x445
> [347829.678928] =A0[<ffffffff8123374e>] ? tcp_v4_connect+0x40d/0x47f
> [347829.678935] =A0[<ffffffff8126ce41>] ? schedule_timeout+0x21/0x1ad
> [347829.678942] =A0[<ffffffff8126e358>] ? _raw_spin_lock_bh+0x9/0x1f
> [347829.678947] =A0[<ffffffff811e81c7>] ? release_sock+0x19/0xef
> [347829.678953] =A0[<ffffffff8123e8be>] ? inet_stream_connect+0x14c/0=
x24a
> [347829.678961] =A0[<ffffffff8104485b>] ? autoremove_wake_function+0x=
0/0x2a
> [347829.678986] =A0[<ffffffffa02ccfe2>] ? ipv4_connect+0x39c/0x3b5 [c=
ifs]
> [347829.678991] =A0[<ffffffffa02cd7b7>] ? cifs_reconnect+0x1fc/0x28a =
[cifs]
> [347829.678999] =A0[<ffffffffa02cdbdc>] ? cifs_demultiplex_thread+0x3=
97/0xb9f [cifs]
> [347829.679003] =A0[<ffffffff81076afc>] ? perf_event_exit_task+0xb9/0=
x1bf
> [347829.679007] =A0[<ffffffffa02cd845>] ? cifs_demultiplex_thread+0x0=
/0xb9f [cifs]
> [347829.679012] =A0[<ffffffffa02cd845>] ? cifs_demultiplex_thread+0x0=
/0xb9f [cifs]
> [347829.679014] =A0[<ffffffff810444a1>] ? kthread+0x7a/0x82
> [347829.679018] =A0[<ffffffff81002d14>] ? kernel_thread_helper+0x4/0x=
10
> [347829.679020] =A0[<ffffffff81044427>] ? kthread+0x0/0x82
> [347829.679022] =A0[<ffffffff81002d10>] ? kernel_thread_helper+0x0/0x=
10
> [347829.679036]
> [347829.679037] Restarting tasks ... done.
> [347829.679862] video LNXVIDEO:00: Restoring backlight state
>
>
> client :
> ii =A0cifs-utils =A0 =A0 =A0 =A02:4.5-2 =A0 =A0 =A0 =A0 Common Intern=
et File System utilities
> ii =A0samba =A0 =A0 =A0 =A0 =A0 =A0 2:3.4.8~dfsg-2 =A0SMB/CIFS file, =
print, and login server for Unix
> ii =A0samba-common =A0 =A0 =A02:3.4.8~dfsg-2 =A0common files used by =
both the Samba server and client
> ii =A0samba-common-bin =A02:3.4.8~dfsg-2 =A0common files used by both=
 the Samba server and client
>
> shares are mounted with mount.cifs
>
>
> server:
> ii =A0samba =A0 =A0 =A0 =A0 =A0 =A0 2:3.5.6~dfsg-3 =A0SMB/CIFS file, =
print, and login server for Unix
> ii =A0samba-common =A0 =A0 =A02:3.5.6~dfsg-3 =A0common files used by =
both the Samba server and client
> ii =A0samba-common-bin =A02:3.5.6~dfsg-3 =A0common files used by both=
 the Samba server and client
>
>
> I tried to suspend multiple times, but every time I got the same
> stack trace. Before I tried to suspend I thought the shares are
> responding slower than they normally do.
>
>
> regards
> Benjamin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Thanks,

Steve
