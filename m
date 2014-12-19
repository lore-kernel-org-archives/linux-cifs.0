From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: SMB3.1 and linux client
Date: Fri, 19 Dec 2014 01:09:18 -0600
Message-ID: <CAH2r5ms6HFopcubJW_A4iK9-o0JfbJG+YqZj7DCqbeoaD8xrOQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Progress in patches to add support to cifs.ko to allow mounting with vers=3.1
(to Windows 10 for example).   First three patches are posted at:

http://git.samba.org/?p=sfrench/cifs-2.6.git;a=shortlog;h=refs/heads/for-next

[SMB31] Update negotiate protocol for SMB3.1 dialect
[SMB31] Add defines and structs for smb3.1 dialect
Allow parsing vers=3.1 on cifs mount

These patches allow passing in "vers=3.1" and sending the encryption
and preauth contexts on SMB2 negotiate protocol.   Still have to finish
up the patch to update SMB2 session setup (once it gets past negotiate
protocol session setup fails without the final patch to update the hashes).

-- 
Thanks,

Steve
