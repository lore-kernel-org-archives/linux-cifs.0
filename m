From: =?UTF-8?Q?Miloslav_H=c5=afla?= <miloslav.hula-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: mout.cifs - No such file or directory/Permission denied
Date: Mon, 24 Apr 2017 17:57:52 +0200
Message-ID: <8f4a5d81-3727-1382-8a00-5b7d8aecb3cc@gmail.com>
References: <0e877de6-0d85-d185-aaa9-f64b058e19b6@gmail.com>
 <mpsmvb6xb24.fsf@aaptelpc.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
To: =?UTF-8?Q?Aur=c3=a9lien_Aptel?= <aurelien.aptel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <mpsmvb6xb24.fsf-zpEvHKhluMwYitT5tn2FcQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Dne 24-Apr-17 v 14:08 Aurélien Aptel napsal(a):
> Miloslav Hůla <miloslav.hula-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:
>> I'm trying to mount NetApp CIFS share, but without success. Connecting
>> it as a network drive or accessing it directly by pasting path into
>> explorer in Windows 8/10 works. smbclient works too.
>
> This looks like good old bso#8950 [1]. You should try a kernel with the
> following commits (4.9 or above, or a kernel where they have been backported):
>
>  a6b5058 fs/cifs: make share unaccessible at root level mountable
>  4214ebf Fix memory leaks in cifs_do_mount()
>  c1d8b24 Compare prepaths when comparing superblocks
>  348c1bf Move check for prefix path to within cifs_get_root()
>  d171356 Fix regression which breaks DFS mounting
>
> 1: https://bugzilla.samba.org/show_bug.cgi?id=8950

In deed it is. With kernel 4.9.0-0.bpo.2-amd64 from jessie-backports 
mount works.

Thank you,
Milo
