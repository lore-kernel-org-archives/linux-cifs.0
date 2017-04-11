From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] CIFS: handle guest access errors to Windows shares
Date: Mon, 10 Apr 2017 23:27:04 -0500
Message-ID: <CAH2r5mutAc_C_GjsXz3WEBhLznKahJJs_TvGfP1eTmxa5mi7eA@mail.gmail.com>
References: <20161129113646.13360-2-mark.syms@citrix.com> <mpszikis34d.fsf@suse.com>
 <0d4b27917f3e4a90a19342a7e27b5d9f@AMSPEX02CL02.citrite.net> <mpswpfkswko.fsf@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: Mark Syms <Mark.Syms-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>,
        "sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org" <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel-IBi9RG/b67k@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <mpswpfkswko.fsf-IBi9RG/b67k@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged into cifs-2.6.git for-next and cc: stable

Good catch - thx

On Wed, Nov 30, 2016 at 11:32 AM, Aur=C3=A9lien Aptel <aaptel-IBi9RG/b67k@public.gmane.org> wro=
te:
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
> I've tested v3.10, v4.4, master, master+your patch using default options
> (empty or no user "NU") and user=3Dabc (U).
>
> NT_LOGON_FAILURE in session setup: LF
> This is what you seem to have in 3.10.
>
> NT_ACCESS_DENIED in tree connect to the share: AD
> This is what you get before your infinite loop.
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
> I guess it could be from either the Windows version or the share/folder
> ACL. A deeper analysis of the packets might reveal more.
>
> In any case I did not notice any issues for on a basic DFS setup with
> the patch so I don't think it introduced any regressions, which is
> probably all that matters. It still bothers me a little I couldn't hit
> the bug.
>
> I've included kernel output w/ debugging output and network capture of
> my tests if anyone want to have a look at it. (master+patch =3D ml-guestf=
ix).
>
> Reviewed-by: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
> Tested-by: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
>
>
>
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Linux GmbH, Maxfeldstra=C3=9Fe 5, 90409 N=C3=BCrnberg, Germany
> GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton, HRB 21284 (AG N=
=C3=BCrnberg)
>



--=20
Thanks,

Steve
