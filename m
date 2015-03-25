From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: SMB3 Linux<->Linux symlinks?
Date: Tue, 24 Mar 2015 21:56:10 -0500
Message-ID: <CAH2r5mvLxCsFq3is=TEVEu7fZ3ziEwd+_s1PQFt=Hrn6DdCO2w@mail.gmail.com>
References: <CAPiFounJaa7xx=W-FVLrWzCB6xQiCeSMLAAUqNtkwwKSKGiPow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: everett hubble <everetthubble-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAPiFounJaa7xx=W-FVLrWzCB6xQiCeSMLAAUqNtkwwKSKGiPow-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Mar 24, 2015 at 3:16 PM, everett hubble <everetthubble-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> With no Windows involved, can I use SMB3 between two Linux hosts
> and have symlinks work seamlessly-- in other words I when I
> create and read symlinks on the CIFS client side it has the same
> effect as if I did the same thing on the server?
>
> If so, which versions of kernel and Samba and cifs-utils do I need?

symlinks can be emulated on the client side in SMB3 (e.g. using mount
option "mfsylinks") but Samba server does not recognize any of the
four symlink formats as symlinks on the server  ("mfsymlinks" ie apple
style symlinks, "sfu" service for unix style symlinks, Windows
junctions, or Windows "NFS-symlinks") although mfsymlinks and sfu
style symlinks should work (the other two would require support in
Samba for "reparse points").   To allow cifs.ko to create symlinks on
the Linux server (remotely created by the client on the server)
requires posix extensions (which are only available for cifs).

Some view it as a bad idea (a security nightmare) to have the server
OS recognize and follow symlinks that a network client creates, so it
may not be a bad thing that SMB3 symlink emulation ("mfsymlinks") are
not recognized on the server side and are only evaluated on the client
(Apple or Linux client).

-- 
Thanks,

Steve
