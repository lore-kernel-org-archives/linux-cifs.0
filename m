From: Assen Totin <assen.totin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Shortcuts on Windows share not accessible in CIFS mount
Date: Wed, 16 Jan 2013 11:53:24 +0200
Message-ID: <CAMrYpX7HBx=JMi+71BWbt=TFw6doxYdBrit-a00+7eANKEpGbw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

A long-time Linux user which recently found himself in a Windows
environment, I ran onto an issue with CIFS and need experts' advice.

I have a dual boot, Windows 7 and Linux. In Windows 7 I log onto a
domain with a username and password. The domain controller is Windows
(not Samba), probably 2007 (I have no acess to it). After logging on,
I can open Windows Explorer, type the name of a server (like this:
\\Server) and I get the list of its shares. I can then double click a
share (e.g., "Docs") and view its contents. Its entries are shown as
"shortcut folders" (the folder pictogram with the Windows shortcut
arrow). I can double click the shortcut and it opens an actual
directory with files.

My Linux is not member of the domain. I can mount the same share
//Server/Docs using 'mount.cifs' with the domain name, username and
password. 'ls -l' shows the shortcuts (only their names, not where
they point to), but when I try to 'cd' to any of them, I get 'illegal
argument'. At the same time, Nautilus (Gnome's file manager) shows the
shortcuts as directories, but with the 'X' overlayed (i.e. the
directory is not accessible); trying to open it results in an error.
However, if there are regular directories and files inside the share,
I can access them as usual. (Note: I don't have access to a domain
admin account and cannot join my Linux to the domain).

My question is: assuming that \\Server\Docs contains shorcuts and that
my domain account is allowed to follow them (in Windows), is there any
way I can follow them in Linux? (I alreay dot my Exchange mailbox in
Linux and also have a suitable Lync replacement, so this seems to be
the last remaining issue before dumping Windows.)

Thanks in advance for any help.

Assen Totin
