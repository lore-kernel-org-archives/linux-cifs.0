From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: sid name lookup
Date: Tue, 12 Oct 2010 13:19:28 -0500
Message-ID: <AANLkTik8GSdOowtE6mMsfevd9AtYAHabn+R_y=UCY5K6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Need to lookup name for a SID.

Mount a cifs share using cifs client.
Would want to use an utility/command named like cifsacl, similar to getfacl.
I have modified cifs vfs client to fetch acl/sec desc blob using
extended attribute (getxattr call).

If I have means to connect to an IPC$ share (when a very first session
over an smb
connection is established) and stay connected to the server for the life of an
smb connection, and one named pipe Trans command, TransQNmPipe,
implemented and accessible
via either ioctl or xattr interface, RPC commands/calls (bind and
other pipe appropriate
commands) can flow over this smb connection and authenticated smb
session to/fro pertinent
named pipe and sid can be resolved to a name.

If not, we have to use Samba libraries (which ones?) calls and/or
services (windbind?) APIs.
I am trying to figure that out. Any pointers to sample code would be
appreciated.

I am also concerned about the usage of cifsacl command/tool. It should
be expected
to be used in the similar fashion as getfacl gets used.  But cifsacl has be to
implicilty/explicitly aware of server, share, means to obtain
authenticated credentials
etc. everytime it is invoked.  I am not sure whether that is such a good idea.
I am particularly concerned about how it would obtain authenticated credentials.
A usage for cifsacl similar to getfacl is preferable over the usage
like smbcacls command.
