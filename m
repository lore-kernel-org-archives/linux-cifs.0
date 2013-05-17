From: Luk Claes <luk-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
Subject: Setting up a testing environment like discussed on SambaXP
Date: Fri, 17 May 2013 15:10:08 +0200
Message-ID: <51962C30.8090201@debian.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi

To make sure there are no functionality regressions, we discussed
setting up an automatic test setup. It could at first run all kind of
functionality tests against against a Samba server for the 4 protocols
we support: CIFS, SMB 2.0.2, SMB 2.1 and SMB 3.

Once we have actual scripts to handle the automatic building, rebooting
and testing of the client it can be hosted on samba.org hardware.
Therefor I'll try to set up a testing environment soon.

Cheers

Luk
