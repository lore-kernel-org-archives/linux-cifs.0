From: David Gelvin <david.gelvin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Question regarding kernel cifs mount bug with prefixpath
Date: Wed, 18 Feb 2015 15:57:07 -0700
Message-ID: <CAA8UQJs35wma7DyY1PoBEadnveA5oU+3vF+8EH6KAJaZgJAcgA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I am trying to mount a specific NetApp CIFS share from various Linux
distributions using the 3.x kernel.  I am able to mount the share root
with no problem:

mount -t cifs //host/share /mnt/cifs

However, any attempt to mount a subdirectory fails:

mount -t cifs //host/share/subdir/subsubdir /mnt/cifs
mount error(2): No such file or directory

I can easily navigate to and browse subdir/subsubdir when I mount the
share root- I just can't mount the subdirectory as a prefixpath.

Using a packet sniffer I see:

QUERY_PATH_INFO, Query File All Info, Path: \\host\share\\subdir\subsubdir
QUERY_PATH_INFO, Error: STATUS_UNSUCCESSFUL

It looks like the kernel is adding an additional slash to the query,
between the share name and the prefixpath.  While many CIFS servers
seem to be fine with this, the NetApp device is not.

This prefixpath mount works successfully with any 2.6 kernel with the
same NetApp device.
