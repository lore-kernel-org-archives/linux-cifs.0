From: =?ISO-8859-1?Q?Victor_Augusto_S=E1nchez_Ram=EDrez?=
	<vicsramirez-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: (unknown)
Date: Mon, 28 Nov 2011 11:55:09 -0600
Message-ID: <CAAQmuzZA+kAB4XzX1si=xioNzrz+uAWz8yes3GQUjvCby=AEYg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Subject: 
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hello:
I have the next situation, in linux Red Hat Enterprise 5.7=A0=A0 I can
mount successfuly a=A0 windows 2003 share by doing,

$=A0 mount.cifs \\\\Windows2003server\\testcifs /root/cifs/ -o user=3Du=
ser
Password:
$

when I want to see the changes in a=A0 file on that server I commonly u=
se:

$ tail -f /root/cifs/Test.txt
<Content_file>

now whe I do a change in file Test.txt in the windows machine, I am
not able to seen the changes in the Linux Box until I type the tail -f
command again.

The question is: Is this a normal behavior or there exists an option
in mount.cifs or kernel module that let me see the changes in a real
time way with=A0 tail -f?

I already read the man page and doing some google but no answer so far.

My versions are:

Redhat Enterprise 5.7
samba-client-3.0.33-3.29.el5_
6.2
kernel: 2.6.18-238.el5

Greetings
