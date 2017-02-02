From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: An odd behavior (win-junction vs. symlink): trying to find why, &
 claim of no-symlinks valid?
Date: Wed, 1 Feb 2017 19:50:27 -0600
Message-ID: <CAH2r5mvXVX3XZB4kEV-x-sox=E8LmjZ5s00sR3QeE9U78OvHEw@mail.gmail.com>
References: <589274FE.5070002@tlinx.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: L A Walsh <cifs-gT3AUAsYRbTYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <589274FE.5070002-gT3AUAsYRbTYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Have you tried a relative symlink target path (ie ../Program Files)
instead of an absolute path?

I am puzzled how a junction could work (on Linux) ever - if the target
path had C:\... in it or started with \  - on the other hand a target
that was relative to the first directory (e.g. began with ..\) should
be fine because Linux client could resolve the path.

Offline if you could send me a wireshark trace (or netmon) - of just
the stat or ls of the failing link - I could tell you more clearly
what is going.

On Wed, Feb 1, 2017 at 5:53 PM, L A Walsh <cifs-gT3AUAsYRbTYtjvyW6yDsg@public.gmane.org> wrote:
> I'm trying to figure out a 'why' (I know how to get around it) one
> junction is showing as a broken link when mounted on linux via cifs.
>
> Background/context:
>
> I have a split system with my Desktop on Windows, but most of the
> non-program
> storage on a linux box.  I do most of my development on the linux system
> and usually have one or more local tty-session "ssh'd" into it.
>
> I have the root folders of each system mounted on the other, with my
> Windows desktop's C-drive mounted at /Athenae.
>
> I have several links of one sort or another (symlink/symlinkd/junctions)
> in the Winbox's root drive.
>
> All except one are working from linux and it's the 'one' that I'm
> trying to figure out the 'why' -- i.e. what is different about
> this one 'symlink'. I put that in quotes, because it's actually
> a junction, but other junctions on Athenae work (resolve, are
> readable, etc...)
>
> FWIW, my linux server is also functioning as an NT4-style domain
> (samba 3.6.22) named 'Bliss' (my idea of irony).  As a result,
> I have 2 sets of creds on the Winbox (domain & local creds are
> the same on a PDC (Primary Domain Controller).  On the Winbox,
> any domain creds have 'Bliss\' prepended to them.
>
>
> On linux for those junctions I see:
>
> ls: cannot read symbolic link '/Athenae/var': Operation not supported
> drwxr-xr-x 2 law Administrators 0  /Athenae/Prog/
> drwxr-xr-x 2 law Administrators 0  /Athenae/Symbols/
> l--------- 1 law Administrators 0  /Athenae/var    ## shows as broken link
>
>
> On Windows, using Windows's dir:
>
> 11/06/2014  07:45 PM    <JUNCTION>     Prog [C:\Program Files (x86)]
> 02/09/2016  11:05 PM    <JUNCTION>     Symbols [\\Bliss\Share\Win7_Symbols]
> 01/11/2017  04:17 PM    <JUNCTION>     var [C:\Windows\System32\cygwin\var]
>
> Also on winbox under cygwin:
>
> lrwxrwxrwx 1 Bliss\law lawgroup       20  /Prog -> /Program Files (x86)/
> lrwxrwxrwx 1 Bliss\law Bliss\lawgroup 26  /Symbols ->
> //Bliss/Share/Win7_Symbols/
> lrwxrwxrwx 1 Bliss\law Bliss\lawgroup 28  /var ->
> /Windows/System32/cygwin/var/
>
>
> I was wondering if anyone had any ideas why the 1 junction is showing
> as 'unreadable' (even though it is -- but showing as a broken link)
> while the others work (and permissions don't ***seem*** to be at
> issue).
>
> FWIW, any symlinks on my Winbox work just fine on Linux mounts using
> CIFS. It _bothers_ me that I've seen in a few places that one is
> not supposed to be able to read Windows symlinks via CIFS when I can.
>
> Is this true or is it that no one has been able to verify them working?
> If it is the latter, my own experience is that it's a matter of making
> sure the symlinks 'resolve'. Even the 'Symbols' link, above which
> points back to the linux server, works -- though not very efficiently.
>
> Ideas on the 1 junction misbehaving & verification on symlinks working
> or not would be appreciated -- though I'm already close to just "fixing it"
> by using a symlinkd instead of a junction after writing this up... ;-)
>
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
