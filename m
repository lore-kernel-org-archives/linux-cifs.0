From: =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: Re: cifs running amok after being disconnected (timeout?)
Date: Wed, 01 Mar 2017 12:29:16 +0100
Message-ID: <mpsefyhfd6b.fsf@aaptelpc.suse.de>
References: <58B48122.5000708@tlinx.org> <mpslgsqfuyx.fsf@aaptelpc.suse.de> <58B5F296.1080408@tlinx.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: L A Walsh <cifs-gT3AUAsYRbTYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <58B5F296.1080408-gT3AUAsYRbTYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

L A Walsh <cifs-gT3AUAsYRbTYtjvyW6yDsg@public.gmane.org> writes:
>     Have to gen a new kernel -- about time for that w/4.10 being
> released...but the last patch and one before don't apply well
> for some reason ('git' tag? or index up front?)...

I'm not sure I understand what you mean. You can pick a recent vanilla
kernel or rebuild your distro kernel with these options enabled (they
have been there for a while). There is no patch to apply. You might be
able to check the options built in your current kernel by looking at
/proc/config.gz, they might already be enabled.

>     kernel seems best for kernel-based stuff.

Historically cifs.ko was a samba project. Both have a (neglected :(...)
cifs section you can use.

https://bugzilla.samba.org/buglist.cgi?component=kernel%20fs&list_id=11514&product=CifsVFS&resolution=---
https://bugzilla.kernel.org/buglist.cgi?component=CIFS&product=File%20System&resolution=---

>     I don't specify a protocol on my mount lines, but the
> samba server doesn't have a SMB2.1 option that I know of (nor
> a 'SMB3').  Should samba allow specifications of 'smb' > 2?

The Samba server lets you pick the min and max supported protocols via
"server min protocol" and "server max protocol" in smb.conf. Look at
your smb.conf man page for possible values supported by your system
smbd.

>     As for the client -- Win7, it could use 2.1 I believe
> (not sure what differences are between 2.1 and 2), but smb3
> is unavailable for win7.  That said, though, if I don't
> specify a proto, the client is win7sp1, and the server is
> the in-kernel CIFS, shouldn't "2.1" be negotiated as
> the highest level supported?

(I'm assuming you meant "the server is samba" as there is no in-kernel
cifs server that I know of)

Windows clients will try to negotiate the highest protocol version but
cifs.ko defaults to 1.0 unless you specify otherwise via -o vers=xyz at
mount.

-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
