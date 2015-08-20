From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Linux CIFS client, Windows 2012 CIFS file server => files not found?
Date: Thu, 20 Aug 2015 11:11:53 -0500
Message-ID: <CAH2r5mv6k7Yw5My-k0b_c32y9QRv+3g-L=e3UagexXfpSMFnXA@mail.gmail.com>
References: <55D5D6FF.1070207@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Kristian Rink <kawazu428-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55D5D6FF.1070207-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

any chance you could send me a small capture file of each (preferably
the smallest possible reproduction scenario so the trace isn't big and
cluttered) so I can compare the two server's responses to see what
might be going on.

(see the "wire captures" section of
https://wiki.samba.org/index.php/LinuxCIFS_troubleshooting)

On Thu, Aug 20, 2015 at 8:32 AM, Kristian Rink <kawazu428-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Folks;
>
> the last few years we've been locally serving files using a NetApp storage
> system exposing CIFS and several (Windows, Linux) clients mounting these
> shares in order to host data and run an internal business application.
>
> The application itself (binaries, libraries, resources, a bunch of ksh
> scripts) entirely lives on the CIFS share. So far (having NetApp CIFS
> mounted), this worked on all machines.
>
> Now, these CIFS shares are to be provided by a Windows 2012 Storage Server.
> Outcome: Linux machines can't run this application anymore. Having mounted
> the W2012 CIFS share, the application won't start complaining that some
> resources (scripts and libraries) are missing, even while they are obviously
> around and also, permission-wise, accessible.
>
> It's difficult to really figure out what happens here. Basically, looking at
> strace output, it seems the application does stat64() one of these files
> which in both cases seems to provide a valid outcome...
>
> stat64("/opt/.../file.oeb", {st_mode=S_IFREG|0755, st_size=36405, ...}) = 0
>
> ... but while mounting the share off the NetApp the application works as
> desired, mounting the share off the W2012 server the application will
> terminate here complaining about this particular resource missing.
>
> Vague as it is, does anyone have any idea what could be causing this? I've
> been playing with various parameters of mount.cifs so far, but I'm not deep
> enough into either NetApps nor Windows 2012s understanding of CIFS to have
> an idea what might have changed here...
>
> TIA,
> Kristian
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
