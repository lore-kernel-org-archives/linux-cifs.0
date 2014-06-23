From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: cifs case insensitivity
Date: Sun, 22 Jun 2014 21:42:50 -0500
Message-ID: <CADT32e+gSSayhjKdHS6HWOn3SHoaMX7yEX2-r6YGn7fYQ_+nhQ@mail.gmail.com>
References: <CAPO=4gDhsduZ24Ah3rGKVEWY6CPHeFPnr+QbSoXkoZCiuvRGUg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Timothy Davenport <warrickguy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAPO=4gDhsduZ24Ah3rGKVEWY6CPHeFPnr+QbSoXkoZCiuvRGUg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I posted a patch but may not be right one.  I think easiest workaround would be
to use either sec=ntlmv2 or sec=ntlm as one of the mount options
(default one, sec=ntlmssp is what is broken) against this server.


On Sun, Jun 15, 2014 at 2:23 PM, Timothy Davenport <warrickguy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> I've noticed a problem with case insensitivity on my cifs mounts.  I
> ran into it when upgrading from Linux Mint 13 to 17.  I've since
> determined that the problem also exists on debian testing.
> The shares on my NAS boxes (Buffalo and ZyXEL) are case sensitive with
> Mint 13 and debian stable (wheezy).  They are case insensitive on Mint
> 17 and debian testing (jessie).  I do a lot of file renaming
> (upper/lower casing) and the insensitivity poses a real problem.
>
> Here is an example from fstab for one of my shares and the mount command used.
>
> //10.2.76.31/android    /mnt/ls-pro-android    cifs
> users,noauto,credentials=/home/trdavenport/sambapw,iocharset=utf8    0
>    0
>
> mount     /mnt/ls-pro-android
>
> As a test I first installed a new instance of debian stable (Linux
> 3.2.0-4-amd64 #1 SMP Debian 3.2.57-3+deb7u2)(cifs.ko v.1.76),
> installed cifs-utils (2:5.5-1) and configured everything to access my
> shares.  This resulted in case sensitive access to all my shares.
>
> Without making any other changes I installed a backported kernel
> (Linux 3.12-0.bpo.1-amd64 #1 SMP Debian 3.12.9-1~bpo70+1)(cifs.ko
> v.2.02) and with that all my shares are case insensitive.  Using grub
> I can switch back and forth between the two kernels and the results
> are consistent.
>
> Have I missed an option or configuration that would address this?  I
> think the nocase option is supposed to turn off sensitivity, but can't
> find anything to turn it on.
>
> Could this fix ( http;//article.gmane.org/gmane.linux.kernel.cifs/8832
> )  from 2013-09-12 have something to do with it?
>
> If I use fuse/gvfs, all the shares are case sensitive on debian stable
> and testing as well as Mint 13 and 17.
>
>  --
> Tim Davenport
> Gatlinburg, Tennessee  USA
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
