From: Mike Tonks <fluffymike-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Subject: Dir List Across Network - Slow from one machine, fast from another
Date: Fri, 24 Sep 2010 11:27:37 +0100
Message-ID: <AANLkTi=ELucgtRA=7FW1-04DrsBN=KqvsSc81bjeYVNG@mail.gmail.com>
References: <AANLkTim0jDLqVVsT2WropqDu30=OWmqQyUK4tmsG=x_M@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTim0jDLqVVsT2WropqDu30=OWmqQyUK4tmsG=x_M-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi All,

I hope this is a suitable place to post this message. =A0I read with
interest a previous thread with a very similar issue:
http://lists.samba.org/archive/linux-cifs-client/2010-January/005504.ht=
ml

I have several ubuntu servers here and a remote windows share across a
slow VPN. =A0I'm trying to create a 'folder watcher' to scan
periodically for new files, and this works pretty well using 'ls -la'
and then processing the output in perl.

In particular, a dev machine: Linux highway-dev 2.6.28-18-generic
#60-Ubuntu SMP Fri Mar 12 04:40:52 UTC 2010 i686 GNU/Linux

and a production machine: Linux highway-www 2.6.31-19-server
#56-Ubuntu SMP Thu Jan 28 03:40:48 UTC 2010 x86_64 GNU/Linux

Both dev and production are in the same rack in one location, while
the windows server is at another site. =A0I've tested against other win
servers at other sites with similar results.

The remote folder has 9000+ files in it. =A0The large number of files i=
s
definately part of the issue, with smaller folders the timing is more
acceptable.

=46or a simple 'ls':

dev: =A05 seconds
production: 6 seconds

=46or 'ls -la':

dev: 6 seconds
production: 200 seconds

Sadly - I need the file size and timestamp for my program to work.

My question is - can anyone explain what's going on and (hopefully)
help me speed up the response on the production server / identify the
network issue / etc. =A0Or is this something that's changed at a
software level?

I timed my tests like so:

$ date; ls /mnt/sharename/ > temp.txt; date


$ cat /proc/fs/cifs/DebugData
Display Internal CIFS Data Structures for Debugging
---------------------------------------------------
=2E..
2) Name: x.x.x.x =A0Domain: WORKGROUP Uses: 1 OS: Windows Server 2003 R=
2
3790 Service Pack 2
=A0 =A0 =A0 =A0NOS: Windows Server 2003 R2 5.2 Capability: 0x1f3fd
=A0 =A0 =A0 =A0SMB session status: 1 =A0 TCP status: 1
=A0 =A0 =A0 =A0Local Users To Server: 1 SecMode: 0x3 Req On Wire: 0
=A0 =A0 =A0 =A0Shares:
=A0 =A0 =A0 =A01) \\x.x.x.x\Jobs Mounts: 1 Type: NTFS DevInfo: 0x20 Att=
ributes: 0x700ff
PathComponentMax: 255 Status: 0x1 type: DISK

=A0 =A0 =A0 =A0MIDs:
