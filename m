From: =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: Re: cifs running amok after being disconnected (timeout?)
Date: Thu, 02 Mar 2017 15:24:17 +0100
Message-ID: <mpstw7beoz2.fsf@aaptelpc.suse.de>
References: <58B48122.5000708@tlinx.org> <mpslgsqfuyx.fsf@aaptelpc.suse.de> <58B5F296.1080408@tlinx.org> <mpsefyhfd6b.fsf@aaptelpc.suse.de> <58B70DB3.6010102@tlinx.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: L A Walsh <cifs-gT3AUAsYRbTYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <58B70DB3.6010102-gT3AUAsYRbTYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

L A Walsh <cifs-gT3AUAsYRbTYtjvyW6yDsg@public.gmane.org> writes:
>     *ouch*.  That doesn't sound compatible.  Good to know, I guess.
> But if I specify 2.1, and a client can't connect at 2.1, will it fail, or
> gracefully fall back to 2.0?  I.e. is the '-o vers=xyz' used to specify
> a maximum? 

If the server does not support the version cifs.ko is told to use,
mounting will fail.

>
>     you mentioned gettign a trace from when I mount -- but the
> reset-loop doesn't start @ mount, but seems to start a few minutes
> later (maybe 120 seconds?)...Just checked my settings on the
> Win machine (recently "upgraded" (same-to-same) to try to
> eliminate some problems on the Win-machine) -- it has a setting
> for disconnecting idle clients which had been reset to a
> default of 15 minutes, so that's not likely the trigger.  I reset
> it back to "don't disconnect" -- useful for my setup.

I would suggest commenting out your "mount line" (in your /etc/fstab I
assume), rebooting, and use this script (as root) to manually mount (you
may want to edit the mount line, the 50% value or the capture file name,
to something else). You can use dmesg to dump kernel messages at any
moment.

    #!/bin/bash
     
    is_cifs_ok() {
        # exit with 1 if [cifs*] task has more than 50% cpu
        ps aux | perl -nae 'BEGIN{$r=0} END{exit $r}
                            $r=1 if $F[10] =~ /\[cifs/ && $F[2] > 50.'
    }

    # capture on SMB ports only
    tcpdump -p -s 0 -w out.cap port 445 or port 139 &
    pid=$!
    sleep 1
     
    # mount remote share
    mount.cifs //HOST/SHARE /mnt/path -o username=xyz,password=xyz
     
    # wait until problem arise
    while is_cifs_ok; do
        sleep 1;
    done
     
    # let the crazy reconnection loop run for a while
    sleep 5
     
    # stop capture
    kill $pid

-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
