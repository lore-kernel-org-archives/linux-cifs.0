From: Oliver Schonrock <oliver-wkKXU3v8bAel+tEH4sVNmg@public.gmane.org>
Subject: learning lessons from mount.cifs for throughput of gvfs-smb and
 kioclient-smb
Date: Sat, 24 Dec 2016 20:39:34 +0000
Message-ID: <7a5fcb31-3c22-de38-dfe2-5ab69f3ac09e@openbrackets.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Trying to get some help/advice to learn from throughput optimisations in
mount.cifs.

The major linux desktop projects gnome and KDE are both struggling with
throughput performance of their VFS implementations against smb
backends. This
issue has been going on for a long time. Here are some recently updated
bugs:

Gnome:
https://bugzilla.gnome.org/show_bug.cgi?id=776339

KDE:
https://bugs.kde.org/show_bug.cgi?id=291835

The symptoms are that gvfs or kioclient access to smb resources achieves
3 to
20 times less throughput on a particular hardware/network setup than can be
achieved by mounting the share using mount.cifs or by using smbclient.
Typical
throughput of gvfs-smb and kioclient over Gbit networks are only 5-30MB/s
whereas mount/cifs and smbclient achieve close to wirespeed, ie > 100MB/s.

Both projects use the libsmbclient API (smbc_read/write) , currently with
buffer sizes of about 64kB (ref bugs above). The smbget utility also uses
libsmbclent, with a default of 64000bytes buffer size. smbget exhibits the
same throughput issues as the Desktop VFS implementations. If you pass "--
buffersize=16MB" to smbget, you can get near wire speed (100MB/s).

So the discussions have been around increasing buffer sizes, however,
understandably, no one is comfortable hard coding a 16MB buffer size.

Some users have done tcpdump forensics:
https://bugs.kde.org/show_bug.cgi?id=291835#c26

which appear to show that mount.cifs and smbclient do "clever" things like
"request 2 x 64kB " and when it receives the first one, asks for the 3rd
64kB
block.... which helps keep the wire filled.

Is this correct? Does anyone have any recommendations / advice for these
2 desktop projects on which direction to go to improve throughput? Is
the brute force approach with "huge ~16MB" buffers the only way given
the API that libsmbclent presents, or is there a "smarter" way?

Thanks
