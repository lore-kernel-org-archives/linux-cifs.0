From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: cifs.ko fails to load
Date: Mon, 1 Sep 2014 10:28:30 -0500
Message-ID: <CADT32eLGqc3E8DCZFisNsZQyHYW+un+uFDxPx67kh3pv-2KWpQ@mail.gmail.com>
References: <5401364D.6020906@bellsouth.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Richard Overstreet <bubbles455-Bdlq13kUjeyLZ21kGMrzwg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5401364D.6020906-Bdlq13kUjeyLZ21kGMrzwg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Is it possible to attach a wireshark trace obtained during the mount command?

On Fri, Aug 29, 2014 at 9:26 PM, Richard Overstreet
<bubbles455-Bdlq13kUjeyLZ21kGMrzwg@public.gmane.org> wrote:
> Hello All,
>
> I have been trying to get a samba share to mount and I think the error
> is caused by the cifs.ko module not being loaded at boot. From my rc.log
> file.
>
> * Setting system clock using the hardware clock [UTC] ...
>  [ ok ]
>  * Loading module cifs.ko ...
>  * Failed to load cifs.ko
>  [ !! ]
>  * Autoloaded 0 module(s)
>  * Checking local filesystems  ...
>
> This has happened with gentoo kernel versions 3.12.21 and 3.14.14. The
> error I receive when trying to mount a share is.
>
>  sudo mount -t cifs //192.168.1.151/richard ./net -o username=richard
> Password:
> Password for richard@//192.168.1.151/richard:
> mount error(13): Permission denied
> Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)
>
> I can manually load the cifs module with modprobe but I still receive
> the same error. The share is accessible via smbclient -L so I really
> don't know what is going on.
>
> smbclient -L 192.168.1.151
> Enter richard's password:
> Domain=[WORKGROUP] OS=[Unix] Server=[Samba 3.6.23]
>
>         Sharename       Type      Comment
>         ---------       ----      -------
>         IPC$            IPC       IPC Service (Samba 3.6.23)
>         homes           Disk
>         richard         Disk      Home directory of richard
> Domain=[WORKGROUP] OS=[Unix] Server=[Samba 3.6.23]
>
>
> Is there a way to send debugging arguments to cifs.ko during boot
> something of the effect module_cifs_args="debug" in /etc/conf.d/modules?
> Or are there some known kernel modules/options that conflict with the
> cifs module? I am attaching my config file if someone could look it over.
>
> Thanks,
>
> Richard Overstreet
