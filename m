From: Jon Bramley <brammers-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Problems with CVS on CIFS since kernel 2.6.30
Date: Mon, 2 Aug 2010 14:58:00 +0100
Message-ID: <AANLkTingdjU-KKW3=KboAnR0pNeiE7aEje0nXhM6bYbe@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi all,
I'm experiencing a problem with the linux CIFS client which is
preventing me from using any kernel past 2.6.29, I've been=A0banging=A0=
my
head against this one for some months now, so thought it about time to
ask some experts. I'm running Gentoo linux on a 32 bit machine.

When connecting to our cifs share on any kernel I've tried since
2.6.29 (30, 31, 32, 33 and 34) I cannot use CVS on the share, as I get
the following error:

515 14:41 $ cvs update
cvs [update aborted]: cannot get working directory: No such file or dir=
ectory

Here is the bottom part of=A0an strace of the above command:
http://paste.org/pastebin/view/21095

dmesg always seems to report the following, upon mount, on all kernels
past 2.6.29, which I'm guessing is related:

=A0CIFS VFS: server 10.194.0.106 of type Samba 3.0.28a returned
unexpected error on SMB posix open, disabling posix open support.
Check if server update available.
=A0CIFS VFS: Autodisabling the use of server inode numbers on
\\shared.orbis\shared. This server doesn't seem to support them
properly. Hardlinks will not be recognized on this mount. Consider
mounting with the "noserverino" option to silence this message.

I've tried mounting the share using the noserverino option, which
indeed does get rid of the second of those lines in dmesg, but doesn't
fix the problem. Updating the server is not really an option (unless I
can prove very good reason) since this is my work server. One slightly
strange thing, is that some of my colleagues run Ubuntu 10.04, which
uses the 2.6.32 kernel, and they can use the share without problem.

I thought my problem could be related to the one=A0described=A0here:
https://bugzilla.kernel.org/show_bug.cgi?id=3D15088=A0but I think this =
was
fixed in 2.6.34, and that kernel is still not working for me (nor does
it with noserverino).

Are there any steps I could take to debug this issue further, or does
anyone know what the problem might be?

Thanks in advance,

Jon
