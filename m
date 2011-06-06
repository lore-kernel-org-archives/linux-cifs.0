From: JM <johnmiller-06ZeP6ie+xM@public.gmane.org>
Subject: Very slow performance with gigabit network
Date: Mon, 6 Jun 2011 22:58:00 +0200
Message-ID: <201106062258.00601.johnmiller@email.it>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi all.
I have a problem with the cifs module in my gigabit network.
I get the following performance:
95 mbytes/s with FTP
65 mbytes/s with samba, windows 7 client
8 mbytes/ with the cifs module on opensuse 11.4

I have tried all the solutions  found on google,
such as directio, modifying rsize and wsize, with
 no improvements. Any advice?

I started asking around collegues and others, on the internet too,
and I found that almost everybody I know have performance
problem with cifs.
If needed, I can test some new version of the driver to help
your job.
I am a C programmer, even if I am not a kernel programmer and
I don't know the CIFS protocol

JM
