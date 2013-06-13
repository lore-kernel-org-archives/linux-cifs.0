From: Doug Clow <doug.clow-jCDWx9PA3/RBDgjK7y7TUQ@public.gmane.org>
Subject: DFS : Object is remote
Date: Thu, 13 Jun 2013 14:04:55 -0700
Message-ID: <A88483E8-9A66-47E6-ABF9-A1AA86B3F8D5@dashbox.com>
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hello,

I am in need to mount a DFS share on CentOS 6.4.  My kernel is 2.6.32-358.  I am having the trouble where if I mount a DFS root namespace, I cannot enter or ls the shared folders.  If I immediately try to ls the shared folder, I receive the error, "Object is remote".  If I first ls the root of the namespace and then subsequently ls the shared folder I get the error, "Invalid argument" or one time "Resource temporarily unavailable".

I have searched the list archives and I see several mentions of this issue.  Is there a known workaround or a patch at this time?

Thank you,
Doug Clow
