From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] CIFS: handle guest access errors to Windows shares
Date: Fri, 2 Dec 2016 10:42:01 -0600
Message-ID: <CAH2r5msRXHseV9A9o=RwDL69v5smXoQZWo_WeT1PEtudzpYiLw@mail.gmail.com>
References: <20161129113646.13360-2-mark.syms@citrix.com> <mpszikis34d.fsf@suse.com>
 <0d4b27917f3e4a90a19342a7e27b5d9f@AMSPEX02CL02.citrite.net>
 <mpswpfkswko.fsf@suse.com> <856abc11c5864627bfcdea9ce0933465@AMSPEX02CL02.citrite.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel-IBi9RG/b67k@public.gmane.org>,
        "sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org" <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Mark Syms <Mark.Syms-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <856abc11c5864627bfcdea9ce0933465-ZIyKOb66IhyzM76k4uAzvRgL0UkB//ZR@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Note that we have seen negotiate differences - spnego encapsulated
ntlmssp vs. raw ntlmssp - between standalone servers (and Windows
clients acting as a server) and Windows servers acting as an AD DC.

Also note that comparing the same os in the client vs server
comparison (Windows 10 vs Windows 2016) could help determine if server
vs. client difference or version difference.

On Fri, Dec 2, 2016 at 10:25 AM, Mark Syms <Mark.Syms-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org> wrote:
> Hi,
>
> I've just tried a plain vanilla Debian testing machine with the vendor 4.=
8.0 kernel and the issue reproduces.
>
> Now, interestingly, if I issue the same mount command to a WS2016 machine=
 configured in the same way as a Win8.1 machine it fails with permission de=
nied as we'd expect and doesn't go into the DFS chase process. So, this app=
ears to be something that is specific to connecting SMB to client grade OS =
machines.
>
>         Mark
>
> -----Original Message-----
> From: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-cifs-owner-u79uwXL29Tb/PtFMR13I2A@public.gmane.org=
el.org] On Behalf Of Aur=C3=A9lien Aptel
> Sent: 30 November 2016 17:32
> To: Mark Syms <Mark.Syms-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>; sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org; linux-cifs@vger.=
kernel.org
> Subject: RE: [PATCH] CIFS: handle guest access errors to Windows shares
>
> Hi Mark,
>
> New setup
>
>   PS> net user guest /activate:no
>   PS> mkdir C:\guestshare
>   PS> icacls C:\guestshare /grant 'Everyone:(OI)(CI)F'
>   PS> new-smbshare -name guestshare -path C:\guestshare -fullaccess Every=
one
>
> I've tested v3.10, v4.4, master, master+your patch using default options =
(empty or no user "NU") and user=3Dabc (U).
>
> NT_LOGON_FAILURE in session setup: LF
> This is what you seem to have in 3.10.
>
> NT_ACCESS_DENIED in tree connect to the share: AD This is what you get be=
fore your infinite loop.
>
>              |   NU       U
> --------------------------------
> 3.10         |   LF       LF
> 4.4          |   LF       LF
> master       |   AD       LF
> master+patch |   AD       LF
>
> No infinite DFS loop :(
> All these issues result in mount failing very fast with permission denied=
.
>
> I guess it could be from either the Windows version or the share/folder A=
CL. A deeper analysis of the packets might reveal more.
>
> In any case I did not notice any issues for on a basic DFS setup with the=
 patch so I don't think it introduced any regressions, which is probably al=
l that matters. It still bothers me a little I couldn't hit the bug.
>
> I've included kernel output w/ debugging output and network capture of my=
 tests if anyone want to have a look at it. (master+patch =3D ml-guestfix).
>
> Reviewed-by: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
> Tested-by: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--=20
Thanks,

Steve
