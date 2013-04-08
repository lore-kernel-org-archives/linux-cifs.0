From: Marc Haber <mh+linux-cifs-ciUMMiFYEj8OIzVOb1FTxg@public.gmane.org>
Subject: Cannot mount Canon Scanner CIFS share with cifs while smbclient
 works
Date: Mon, 8 Apr 2013 21:40:49 +0200
Message-ID: <20130408194049.GE10949@torres.zugschlus.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

I own a Canon MX 420 scanner which can scan to a memory card and then
offer the scanned information via CIFS. Up to a few kernel versions
ago (I think it worked with 3.6, but am not sure about that), things
worked just fine and then stopped.

The issue is the following:

$ sudo mount.cifs  '\\mx420-sch8.local\canon_memory' /media/scanner -o user=anonymous,nounix --verbose
Password: <enter>
mount.cifs kernel mount options: ip=192.168.218.36,unc=\\mx420-sch8.local\canon_memory,nounix,user=anonymous,pass=********
mount error(5): Input/output error
Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)

A pcap file of the network traffic caused by this command can be
downloaded from http://q.bofh.de/~mh/stuff/tcpdump.mount.cifs.

Otoh, smbclient '\\mx420-sch8.local\canon_memory' works. A pcap file
of the network traffic caused by this command can be downloaded from
http://q.bofh.de/~mh/stuff/tcpdump.smbclient.

As somebody not knowing CIFS too well, I note that smbclients tries as
anonymous, while the kernel tries to log in first and receives an
error answer from the scanner.

This behavior has changed at some point of the last six months. The
kernel 3.7 found in grml's 2013.02 release works, at least the 3.8.5
currently running on my notebook doesn't.

Any hints how do address this issue?

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Mannheim, Germany  |  lose things."    Winona Ryder | Fon: *49 621 31958061
Nordisch by Nature |  How to make an American Quilt | Fax: *49 621 31958062
