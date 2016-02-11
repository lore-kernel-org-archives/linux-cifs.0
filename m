From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: ASYNC operation
Date: Thu, 11 Feb 2016 17:42:35 +0530
Message-ID: <1455192755.3419.24.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hello Steve,

We have a report where users using async reads by setting the directive
"aio read size =3D 4096"
in smb.conf. The user uses SMB3.

When using large rsize/wsize, we hit the problem where we have the
following messages

=46eb=C2=A0=C2=A08 15:03:28 storage-qe13 kernel: CIFS VFS: SMB response=
 too long
(1048656 bytes)
=46eb=C2=A0=C2=A08 15:03:28 storage-qe13 kernel: CIFS VFS: Send error i=
n read =3D -11

It looks like the Reads in the cifs module does not follow the async io
steps described in =C2=A0
https://msdn.microsoft.com/en-us/library/cc246721.aspx

Looking at the tcpdump, just before the client reconnects to the
server, I see a read response with status set to STATUS_PENDING. The
async_id for the smb2_hdr is set.=C2=A0
This response is received and processed by cifs_readv_receive() which
doesn't not know about the STATUS_PENDING response. It proceeds to
discard the readv response, returns an error and clears the MID.
The subsequent async response for the call then reaches the client.
Since the client has already discarded the MID from the earlier call,
it can no longer find any corresponding MIDs in the pending MID list.
The response is then handled by standard_receive3() which considers it
to be too large.
The connection is closed and the client attempts to reconnect to the
server.

The client then should subsequently retry the read call and should
receive the necessary response.

To reproduce:=C2=A0
On the server, add the following conf
aio read size =3D 4096
and restart server.=C2=A0
Server version used in my test samba-4.1.12-23.el7_1.x86_64.

On the client: using kernel 4.5.0-0.rc1.git2.1.fc24.x86_64

1)=C2=A0=C2=A0mount with the mount options
rsize=3D1048576,wsize=3D1048576,vers=3D3.0=C2=A0

2) Create a file to use to read
dd if=3D/dev/zero of=3Dtest bs=3D1M count=3D1024

3) Start read and keep a tab on dmesg
# dd if=3Dtest of=3D/dev/null=C2=A0

Are there any plans on adding this functionality to the cifs module?=C2=
=A0

Sachin Prabhu
