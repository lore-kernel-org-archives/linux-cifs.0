From: Robert Kudyba <rkudyba-tzaSEmCkE7qVc3sceRu5cw@public.gmane.org>
Subject: backing up to a Drobo CIFS VFS: Error -11 sending data on socket to server, Bufferbloat?
Date: Mon, 8 May 2017 15:02:31 -0400
Message-ID: <2F251951-5DEC-4B0B-ABF8-D80CC77A1D75@fordham.edu>
References: <286943BF-E8A7-4844-B58C-0B2A8D9B4046@fordham.edu>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

We back up via a cron job using tar via a campus to campus dedicated =
fiber line. We get this error about 4 out of 5 times the job runs:

May  8 01:08:10 ourserver kernel: cifs_vfs_err: 2 callbacks suppressed
May  8 01:08:10 ourserver kernel: CIFS VFS: Server ourserver has not =
responded in 120 seconds. Reconnecting...
May  8 01:10:01 ourserver kernel: CIFS VFS: sends on sock =
ffff9f2900764f00 stuck for 15 seconds
May  8 01:10:01 ourserver kernel: CIFS VFS: Error -11 sending data on =
socket to server
May  8 01:10:45 ourserver kernel: CIFS VFS: sends on sock =
ffff9f2900764f00 stuck for 15 seconds
May  8 01:10:45 ourserver kernel: CIFS VFS: Error -11 sending data on =
socket to server

This is on Fedora 25. I saw this 2013 thread, =
http://linux-cifs.vger.kernel.narkive.com/qolENUBe/errors-writing-large-fi=
les-to-cifs-shares which mentions Bufferbloat. Is there a way to perhaps =
tune a kernel parameter in /etc/sysctl.conf?=
