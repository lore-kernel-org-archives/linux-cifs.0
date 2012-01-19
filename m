From: "ralda-Mmb7MZpHnFY@public.gmane.org" <ralda-Mmb7MZpHnFY@public.gmane.org>
Subject: Trouble accessing Buffalo NAS with CIFSFS
Date: Thu, 19 Jan 2012 09:19:09 +0100
Message-ID: <20120119091909.d6c30922.ralda@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Sorry, I got interrupted during writing the message, so I made a
mistake:

Adding "noserverino" to mount options silences one message in the
dmesg list but DO NOT CHANGE the other behavior.
