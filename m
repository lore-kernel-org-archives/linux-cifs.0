From: bruce-FsTrmwUK8BR2iXbJP1moag@public.gmane.org
Subject: mount.cifs prerequisites
Date: Thu, 18 Aug 2011 17:31:59 +0100
Message-ID: <6d15d641caf322cf62917e8b03035fbf.squirrel@alpha.server-room.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


Dear List,
I am running a 2.6.28 kernel that I have compiled with cifs filesystem
support. I am trying to mount a share from a windows 2008 server requiring
ntlmv2. when I try to pass the option sec=ntlmv2 or ntlmv2i I receive an
invalid argument message. If I omit the sec option I receive a permission
denied.
I have also tried to use a stock Debian kernel (2.6.32) that I have
checked to have cifs compiled in and I get the same results. If I perform
a 'modinfo cifs' it shows the module to be loaded and that I am running
ver 1.61 of cifs.
Is there any other components I need to check (do I need a library package
to support ntlmv2??)
I can mount shares of servers that allow NTLMv1.

Any help gratefully received.

Thanks Bruce
