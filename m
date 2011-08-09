From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH 0/3] cifs: chown/chgrp id/sid mapping
Date: Tue,  9 Aug 2011 12:33:05 -0500
Message-ID: <1312911185-22310-1-git-send-email-shirishpargonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

chown/chmod commands for mount option cifsacl.

Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---

This patchset aim to enable chown and chgrp commands when
cifsacl mount option is specified, especially to Windows SMB servers.
Currently we can't do that.  So now along with chmod command,
chown and chgrp work.

Winbind is used to map id to a SID.  chown and chgrp use an upcall
to provide an id to winbind and upcall returns with corrosponding
SID if any exists. That SID is used to build security descriptor.
The DACL part of a security descriptor is not changed by either
chown or chgrp functionality.

cifs client maintains a separate caches for uid to SID and 
gid to SID mapping. This is similar to the one used earlier
to map SID to id (as part of ID mapping code).

I tested it by mounting shares from a Windows (2003) server by
authenticating as two users, one at a time, as Administrator and
as a ordinary user.
And then attempting to change owner of a file on the share.

Depending on the permissions/privileges at the server for that file,
chown request fails to either open a file (to change the ownership)
or to set security descriptor.
So it all depends on privileges on the file at the server and what
user you are authenticated as at the server, cifs client is just a
conduit.

I compared the security descriptor during chown command to that
what smbcacls sends when it is used with -M OWNNER: option
and they are similar.

This patchset aim to enable chown and chgrp commands when
cifsacl mount option is specified, especially to Windows SMB servers.
Currently we can't do that.  So now along with chmod command,
chown and chgrp work.

I tested it by mounting shares from a Windows (2003) server by
authenticating as two users, one at a time, as Administrator and
as a ordinary user.
And then attempting to change owner of a file on the share.

Depending on the permissions/privileges at the server for that file,
chown request fails to either open a file (to change the ownership)
or to set security descriptor.
So it all depends on privileges on the file at the server and what
user you are authenticated as at the server, cifs client is just a
conduit.
