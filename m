From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: weirdness with cifsd
Date: Thu, 12 Jan 2017 17:58:03 -0600
Message-ID: <CAH2r5msvqa1OOfr8fseU_PCv-Rz4-fyTrkEDRT+qDBJtXQ21Hg@mail.gmail.com>
References: <587815F8.5050309@tlinx.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: L A Walsh <cifs-gT3AUAsYRbTYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <587815F8.5050309-gT3AUAsYRbTYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

You can see some information (i/o in flight e.g.) in
/proc/fs/cifs/DebugData and /proc/fs/cifs/stats

You can enable logging (dmesg ie the kernel log) "echo 7 >
/proc/fs/cifs/cifsFYI")

See https://wiki.samba.org/index.php/LinuxCIFS_troubleshooting

On Thu, Jan 12, 2017 at 5:49 PM, L A Walsh <cifs-gT3AUAsYRbTYtjvyW6yDsg@public.gmane.org> wrote:
> Just today, for the first time in a while, I have my Win machine
> mounted on my linux machine.
>
> But after a short while I'm seeing a large amount of read & write
> network traffic between the two machines.
>
> If I unmount the share (essentially my entire
> Win disk), it stops.  But otherwise, I see cifsd getting
> 100% of a cpu most of the time.
>
>
> Is there a log like samba has to see what is being accessed?
>
> I'm not sure at this point what is causing it...
>
> (sorry for partial note before.  I swear I clicked on save, but must have
> hit send... (lame!)...
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
