From: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/2] cifs: remove rfc1002 length field from all SMB2 response structures
Date: Mon, 22 Jan 2018 09:06:42 +1100
Message-ID: <20180121220644.7907-1-lsahlber@redhat.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Steve, All

Review but do not merge to for-next. This patch still breaks SMBD.
I have tested the patch with SMB1/2/3 with and without signing as well as
with SMB3 encryption and it works in my tests.

The first patch removes the rfc1002 length from all the response structures
hopefully making it easier to implement compounding later. It also gets rid
of a lot of magic add/subtract 4 from various computations.

The second patch updates the demultiplex loop so that it will now be able
to handle compounded responses we receive from the server. In theory, we
will not know it this works until we can actually send compounded requests.



Next steps will be to start implementing the actual compounding.
That, I think, will consist of refactoring the SMB2_open/query/close
functions into dedicated marshalling functions and then create a new
compound_send_recv() function.
The second part will require some additional plumbing.
In smb2_send_recv() we currently create iovectors as
[0] length
[1] smb2 header
[2+] additional data

or, when smb3 encryption is used

[0] length
[1] transform header
[2] smb2 header
[3+] additional data

Instead, in compound_send_recv() we will need to create an array of iovectors,
one for each pdu, that would look like
[0] smb2 header
[1+] additional data

and similar for smb3 encryption.

These iovectors would then be propagated down the stack without an initial
length field until we are ready to transmit them.
So, for the TCP case, we would not prepend the vectors we want to send with
a [0] length field until the point where we are just about to start writing
the data to the tcp socket.

That shouldnt be too hard. But we need these patches first.
