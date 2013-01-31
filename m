From: Adam Williamson <awilliam-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: CIFS auth changes make mount of a DNS-323 share fail unless
 sec=ntlm is passed in 3.8
Date: Thu, 31 Jan 2013 08:48:21 -0800
Message-ID: <1359650901.1875.26.camel@adam>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi, folks. I'm not subscribed, so please ping me if further info is
needed. Jeff Layton said to report this here, as it's a useful data
point, though apparently you already know the underlying cause.

I have what I think is a pretty common setup here at AdamW Towers: an
off-the-shelf consumer NAS box as a dump for 'big but not really
valuable data' (mostly media files) which provides a very
liberally-configured CIFS share: I just allow full unauthenticated
access to any system on the local network, because if you're on my
network, you can do whatever you like to the stuff on the NAS box,
you're either married to me or I trust you *and* I'm sitting where I can
see you. The box I use is a D-Link DNS-323, which is a pretty popular
one - Google will confirm this. I have this line in /etc/fstab :

//192.168.1.13/Volume_1 /share/data cifs
rsize=8192,wsize=8192,nosuid,soft,guest,iocharset=utf8,mapchars 0 0

If I boot a 3.7 kernel, I can mount the share, no problems. If I boot a
3.8 kernel and try to mount it, I get 'Permission denied'. Nautilus can
browse the share through its own CIFS stuff (by going through Network,
not browsing to /share/data).

If I add 'sec=ntlm' to the options, I can mount the share. jlayton tells
me this is a security change in 3.8: NTLM is considered insecure and so
you have to explicitly specify it. I can see the argument, but it seems
a shame to break a working config that - like I say - I suspect is
reasonably common, especially since there's no security expectation
anyway (and this too I suspect is not an unusual situation). Obviously
the 'fix' is simple, but it's the kind of thing that'll catch people out
and frustrate them I think, and they may not have a jlayton on tap to
give them the answer right away :) I have no idea of the technicalities,
but perhaps NTLM could be allowed for 'guest' mounts at least?
-- 
Adam Williamson
Fedora QA Community Monkey
IRC: adamw | Twitter: AdamW_Fedora | identi.ca: adamwfedora
http://www.happyassassin.net
