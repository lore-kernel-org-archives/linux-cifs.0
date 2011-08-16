From: Bryan.James.Krone-EXT-zES+1Ur7hjI@public.gmane.org
Subject: CIFS can't read share
Date: Tue, 16 Aug 2011 10:34:28 -0500
Message-ID: <OFF2DA68D6.9F5E142E-ON862578EE.0055727B-862578EE.00558DE9@jci.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I can mount my Windows share with "mount -t cifs //10.2.8.42/myshare 
/mnt/myshare -o 
user=USER,password=cat,domain=WORKGROUP,sec=ntlmssp,noserverino". But when 
I try to access the contents of the directory I get "NT Status: 
STATUS_INVALID_LEVEL" according to wireshark.

Is this a known issue? Is there some configuration I need to add to the 
kernel?

Thanks for your help.

Bryan
