From: Markus Greger <Markus.Greger-hi6Y0CQ0nG0@public.gmane.org>
Subject: Is there a way to enumerate Alternate Data Streams?
Date: Wed, 27 Jan 2016 23:17:39 +0100
Message-ID: <56A94203.3060807@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I'm looking for a way to enumerate Alternate Data Streams from linux,
specifically from a filesystem mounted via cifs.

Mounting a windows share via cifs allows me to read, write and delete
alternate data streams from linux (like indicated at
http://article.gmane.org/gmane.linux.kernel.cifs/7228/match=alternate+data+streams).

However I couldn't find a way to actually query if there are alternate
data streams and / or enumerate them. Even when mounting with
"user_xattr" option and using getfattr there was no information about
alternate streams.

A very similiar if not identical question was asked quite some time ago
at
http://linux-cifs.vger.kernel.narkive.com/W8aaTElO/alternate-data-streams but
I couldn't manage to really find an answer.

A quick glimpse through kernel source gave references in comments to
"proc/fs/cifs/streamstoxattr" but this seems not yet implemented - at
least searches yield nothing about how to set "proc/fs/cifs/streamstoxattr".

So is there any ioctl, option/configuration or "well known" attribute
name to get a list of alternate data streams?

Markus
