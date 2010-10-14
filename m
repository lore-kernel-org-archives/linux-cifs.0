From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: getcifsacl/setcifsacl, SID to/fro uid,gid mapping - First attempt at
 a design
Date: Thu, 14 Oct 2010 15:28:42 -0500
Message-ID: <AANLkTinYBhr6-7uWWsRfnaBPU+S2+LqQfQ_DJkTj1nVm@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The goal is to implement tools/utilities named such as getcifsacl and
setcifsacl,
similar to getfacl and setfacl respectively.

getcifsacl would be used to display ACL for a file system object which belongs
to a mapped remote share supporting CIFS/NTFS ACL.
getcifsacl should be supplied with just the file object path and not
with details such
as server name/address and share name, user id and password either
explicitly (as can
be done for smbcacls command or implicitly e.g. via a configuration file)

cifs vfs client has almost working code to tree connect/disconnect to
an IPC$ share on
the server.  Cifs vfs client will need an additional functionality to send a
Trans command which implements a transaction, to implement named pipe API
TransactNamedPipe (that is the only API that is needed) and a means to
invoke this
Trans command i.e. via an ioctl or an xattr.

When a very first tree connection for a very first smb session for an
smb connection
succeeds, a tree connection to IPC$ share should occurr, which should succeed.
Before the last smb session on an smb connection is removed, the tree connection
to IPC$ share should be disconnected.
After reconnect of an smb connection, above should repeat.

When an user issues a command like getcifsacl, getcifsacl invokes getxattr with
attribute name system.cifsacl which results in cifs client getting
security descriptor
from the server which is returned as a blob as attribute value, to the caller.

Caller parses the blob and for every SID it encounters, makes a
winbind call, passing
the SID and expecting a (looked-up) name for that SID.  Winbind maps the sid and
associates that SID with an id.

If winbind can't resolve the name of that SID and returns an error,
getcifsacl will
attempt to resolve it by talking to the named pipe lsarpc on the
server.  This would
involve a sequence of calls such as opening the named pipe, writing to the
named pipe (e.g. bind rpc), a series of named pipe lsarpc specific
function calls
via SMB Trans command to resolve the SID to a name, and finally close
of that named pipe.
The RPC calls to the named pipe lsarpc could be part of a newly
created library or an
existing library such as librpc.  If this name lookup succeeds, the
SID is mapped to an
id using winbind. If the name lookup fails, getcifsacl displays the SID.

For the command setcifsacl, either an SID or a name can be provided.
If an SID is
provided, there is no name look-up involved. setcifsacl will construct
an appropriate
security descriptor and send it as a blob to the cifs vfs client to
send it to the
server using set security descriptor to be set which could either succeed or
fail and caller of the setcifsacl command is notified of the result.
If a name is specified instead of a SID, setcifsacl shall first asks
winbind for a SID
and if it fails, can lookup directly by asking the named pipe lsarpc
on the server
for the SID.  Once a SID is obtained, a security descriptor is constructed by
setcifsacl and sent to cifs vfs client. If the SID can't be obtained, setcifsacl
tool/utility fails.

-------------------------------------------------------------------------------------

For commands such as ls, cifs client will make an upcall to look up
SID name and if
needed map that SID to an id. The mapped id of the Owner SID becomes
uid and mapped id
of the Group SID becomes gid of the file system object.

For commands such as chmod or chgrp, the id is looked up for a SID
from the winbind
and if winbind fails to provide, the name associated with the id is
looked up for
an SID on the named pipe lsarpc on the server.  If either the windbind
or the SID
lookup  (in that order) succeeds, chmod or chgrp command should construct an
appropriate security descriptor and send it to the server to set and to either
succeed or fail, the results of which are notified to the calling command.
If the SID lookup fails, the chmod/chgrp command should fail at the client.

--------------------------------------------------------------------------------------

If winbind rpm is not installed or winbind deamon is not running or if
/etc/nsswitch.conf does not specify winbind for passwd and group, id mapping
will not work.  (How) Can/should cifs-utils or getcifsacl and setcifsacl tools
specify dependency on all three conditions? Or is there any alternative?

I am not sure if there could be a security descriptor which does not contain a
Group SID and if that is the case, what should group id be/default_to?

Should all the SIDs mapped during the life of an smb connection should
purged from
winbind when the smb connection is coming down (including when
reconnect happens)?
I am not sure if there are any SIDs that should not be purged which
are universal
amongst every server, and once mapped, should stay with the winbind
and should not
be purged.
I am not sure whether windbind allows a any qualifier at all or a
qualifier such as
server name/address, for id mapping.
