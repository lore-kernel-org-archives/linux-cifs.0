From: =?utf-8?Q?Aur=C3=A9lien?= Aptel <aurelien.aptel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: mout.cifs - No such file or directory/Permission denied
Date: Mon, 24 Apr 2017 14:08:35 +0200
Message-ID: <mpsmvb6xb24.fsf@aaptelpc.suse.de>
References: <0e877de6-0d85-d185-aaa9-f64b058e19b6@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
To: Miloslav =?utf-8?Q?H=C5=AFla?= <miloslav.hula-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <0e877de6-0d85-d185-aaa9-f64b058e19b6-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Miloslav Hůla <miloslav.hula-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:
> I'm trying to mount NetApp CIFS share, but without success. Connecting 
> it as a network drive or accessing it directly by pasting path into 
> explorer in Windows 8/10 works. smbclient works too.

This looks like good old bso#8950 [1]. You should try a kernel with the
following commits (4.9 or above, or a kernel where they have been backported):

 a6b5058 fs/cifs: make share unaccessible at root level mountable
 4214ebf Fix memory leaks in cifs_do_mount()
 c1d8b24 Compare prepaths when comparing superblocks
 348c1bf Move check for prefix path to within cifs_get_root()
 d171356 Fix regression which breaks DFS mounting

1: https://bugzilla.samba.org/show_bug.cgi?id=8950

-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
