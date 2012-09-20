From: Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Ownership and other subjects.
Date: Thu, 20 Sep 2012 13:28:02 +0200
Message-ID: <CANXojcyahNHmDQfrhczhtofVwgbTQj01XaOGdRfDyRQJDOHKhQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

I've some questions regarding the uid:gid reported by cifs. As you
know ownership can be set
using the options uid= and gid=.
In the construction I work on the use of these options (actually the
answer to the question the
remote uid:gid has meaning on this host) depends on the output of an
external script.

Now at this moment the administrator can set per workgroup/domain the
uid:gid has meaning, so
has to be overwritten or not.

Is there a general way to do this automatically?

My guess is that first the nss libraries use something like
libnss_ldap.so or something simular, like libnss_winbind.so. And then
if this is the case, check the remote server shares the same uid base.
How?

It looks like a call to that server is required (rpc?). In windows
world I guess this is just all done in active dir.

And the use of the keyring is only possible with the multiuser option?


Futher making the sending of fs notify change requests and the
receiving of events has still my attention, but it's very hard to make
this work with libsmbclient. Libsmbclient has to be changed. I've
posted a message about this at the samba technical maillist, and it's
not so easy. Maybe I will try it myself. See:

https://lists.samba.org/archive/samba-technical/2012-September/086464.html

I very much would like too make this work, so I can step up to make
this work with cifs.

See for my efforts:

http://code.google.com/p/notifyfs/

Finally I would like to attract some attention to fuse-workspace,
which offers access to smb workgroups and servers using FUSE and
libsmbclient, and offers the possibility to access the shares using
cifs or libsmbclient.
You of course are interested in using cifs!

See:

https://github.com/stefbon/fuse-workspace

Specially a screenshot at:

https://github.com/stefbon/fuse-workspace/wiki/Access-SMB-Network.

I'm working on making this work with as less configuration possible.
So if the user logs in using a remote uid base, this construction
should check to use these credentials.
Comments welcome.

Stef
